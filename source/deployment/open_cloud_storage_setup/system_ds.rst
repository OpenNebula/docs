.. _system_ds:

=====================
The System Datastore
=====================

The System Datastore is a special Datastore class that holds Images for running Virtual Machines. As opposed to a regular Images Datastores you cannot register new Images into a System Datastore.

Types of System Datastore
=========================

For each running Virtual Machine in the Datastore there is a directory containing the disk images and additional configuration files. For example, the structure of the System Datastore 0 with 3 Virtual Machines (VM 0 and 2 running, and VM 7 stopped) could be:

.. code::

    datastores
    |-- 0/
    |   |-- 0/
    |   |   |-- disk.0
    |   |   `-- disk.1
    |   |-- 2/
    |   |   `-- disk.0
    |   `-- 7/
    |       |-- checkpoint
    |       `-- disk.0

There are three System Datastore types, based on the TM_MAD driver used:

* ``shared``, the storage area for the System Datastore is a shared directory across the hosts.
* ``ssh``, uses a local storage area from each host for the System Datastore
* ``ceph``, uses Ceph to store volatile and swap disks, and checkpoint files, but the context and deployment files are still stored locally

.. _system_ds_shared:

The Shared System Datastore
---------------------------

The shared transfer driver requires the hosts to share the System Datastore directory (it does not need to be shared with the front-end). Typically these storage areas are shared using a distributed FS like NFS, GlusterFS, Lustre, but it's not necessary.

A shared System Datastore usually reduces VM deployment times and **enables live-migration**, but it can also become a bottleneck in your infrastructure and degrade your Virtual Machines performance if the virtualized services perform disk-intensive workloads. Usually this limitation may be overcome by:

* Using different file-system servers for the images datastores, so the actual I/O bandwidth is balanced
* Using an ssh System Datastore instead, the images are copied locally to each host
* Tuning or improving the file-system servers

|image0|

The SSH System Datastore
------------------------

In this case the System Datastore is distributed among the hosts. The ssh transfer driver uses the hosts' local storage to place the images of running Virtual Machines (as opposed to a shared FS in the shared driver). All the operations are then performed locally but images have to be copied always to the hosts, which in turn can be a very resource demanding operation. Also this driver prevents the use of live-migrations between hosts.

|image1|

.. _system_ds_ceph:

The Ceph System Datastore
-------------------------

The :ref:`Ceph Image Datastore <ceph_ds>` works **both** with the Shared System Datastores, and with the specific Ceph System Datastore. The Ceph System Datastore has the advantage that it does not require the set-up of a shared file-system and everything is stored in the Ceph backend.

The Ceph System Datastore is created with the :ref:`same attributes as the Ceph Image Datastore <ceph_ds_configuring>`, **with the exception that DS_MAD is not specified**.

The following table summarizes the behavior of both System Datastores:

+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
|                     |                            Shared                           |                                                            Ceph                                                           |
+=====================+=============================================================+===========================================================================================================================+
| Volatile and Swap   | Stored in the shared fs                                     | Stored in the Ceph System Datastore                                                                                       |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| Checkpoint          | Stored in the shared fs                                     | Saved temporarily to the local hypervisor filesystem and then dumped to the Ceph System Datastore                         |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| Deployment file     | Stored in the shared fs                                     | Stored locally in the hypervisor                                                                                          |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| Context             | Stored in the shared fs                                     | Stored locally in the hypervisor                                                                                          |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| Live-Migration      | Allowed. Files are  available in the destination host       | Allowed. Local files (context and deployment) are scp'd to the target host, and removed from the source host upon success |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| System DS Migration | Allowed. Does not affect the Ceph images                    | Not allowed                                                                                                               |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+

.. warning::

    As the checkpoint file is temporarily first saved to the hypervisor local file-system, it needs to have enough scratch space to store it. The path where the checkpoint file will be written to is `$DATASTORE_LOCATION/<ds_id>/<vm_id>`, which is the same as with the other System Datastores.

The System and Image Datastores
-------------------------------

OpenNebula will automatically transfer VM disk images to/from the System Datastore when a VM is booted or terminated. The actual transfer operations and the space taken from the System Datastore depends on both the image configuration (persistent vs non-persistent) as well as the drivers used by the images datastore. The following table summarizes the actions performed by each transfer manager driver type.

+----------------+--------+------+----------+-----------+----------+------------+------+
|   Image Type   | shared | ssh  |  qcow2   |    ceph   |   lvm    | shared lvm | dev  |
+================+========+======+==========+===========+==========+============+======+
| Persistent     | link   | copy | link     | link      | link     | lv copy    | -    |
+----------------+--------+------+----------+-----------+----------+------------+------+
| Non-persistent | copy   | copy | snapshot | rdb copy+ | lv copy+ | lv copy    | link |
+----------------+--------+------+----------+-----------+----------+------------+------+
| Volatile       | new    | new  | new      | new       | new      | new        | new  |
+----------------+--------+------+----------+-----------+----------+------------+------+

In the table above:

* **link** is the equivalent to a symbolic link operation that will not take any significant amount of storage from the System Datastore
* **copy, rbd copy and lv copy**, are copy operations as in regular cp file operations, that may involve creation of special devices like a logical volume. This will take the same size as the original image.
* **snapshot**, qcow2 snapshot operation.
* **new**, a new image file is created on the System Datastore of the specified size.

**Important Note, operations with +**, are performed on the original image datastore; an so those operations take storage from the image datastore and not from the system one.

Once the disk images are transferred from the image datastore to the System Datastore using the operations described above, the System Datastore (and its drivers) is responsible for managing the images, mainly to:

* Move the images across Hosts, e.g. when the VM is stopped or migrated
* Delete any copy from the Hosts when the VM is terminated

Configuration Overview
======================

OpenNebula comes with a pre-configured System Datastore: ``default``, with ID: ``0``. It is configured as a ``shared`` System Datastore.

Each :ref:`cluster <cluster_guide>` must have at least one System Datastore assigned. With more than one System Datastore per Cluster, you can better plan the storage requirements, in terms of total capacity assigned, performance requirements and load balancing across System Datastores.

To configure the System Datastores for your OpenNebula cloud you need to:

* Create as many System Datastores as needed (you can add more later if you need them).
* Assign the System Datastores to a given cluster.
* Configure the Hosts to access the System Datastores (this may involved installing Ceph, or mounting an NFS, etc...).

Step 1. Create a New System Datastore
=====================================

To create a new System Datastore you need to specify its type as system either in Sunstone (system) or through the CLI (adding ``TYPE = SYSTEM_DS`` to the datastore template). And you need to select the System Datastore drivers, as discussed above: ``shared``, ``ssh`` or ``ceph``.

For example to create a System Datastore using the shared drivers simply:

.. code::

    $ cat systemds.txt
    NAME    = nfs_ds
    TM_MAD  = shared
    TYPE    = SYSTEM_DS

    $ onedatastore create systemds.txt
    ID: 100

Step 2. Assign the System Datastores
====================================

Hosts can only use use a System Datastore if they are in the same cluster, so once created you need to add the System Datastores to the cluster. You can **add more than one System Datastore** to a cluster, the actual system DS used to deploy the VM will be selected based on storage scheduling policies, see below.

To associate this System Datastore to the cluster, add it:

.. code::

    $ onecluster adddatastore production_cluster nfs_ds

The Hosts need to be configured to access the systems datastore through a well-known location: ``/var/lib/one/datastores`` (or the value of ``DATASTORE_LOCATION`` in ``oned.conf``).

Step 3. Configure the Hosts
===========================

The specific configuration for the Hosts depends on the System Datastore type (shared or ssh). Before continuing check that SSH is configured to enable oneadmin passwordless access in every host.

Configure the Hosts for the Shared System Datastore
---------------------------------------------------

A NAS has to be configured to export a directory to the Hosts, this directory will be used as the storage area for the System Datastore. Each host has to mount this directory under ``$DATASTORE_LOCATION/<ds_id>``. In small installations the front-end can be also used to export the System Datastore directory to the Hosts. Although this deployment is not recommended for medium-large size deployments.

Configure the Hosts for the SSH System Datastore
------------------------------------------------

There is no special configuration needed to take place to use the ssh drivers for the System Datastore. Just be sure that there is enough space under ``$DATASTORE_LOCATION`` to hold the images of the Virtual Machines that will run in each particular host.

Also be sure that there is space in the frontend under ``/var/lib/one/datastores/<ds_id>`` to hold the images of the stopped or undeployed Virtual Machines

Configure the Hosts for the Ceph System Datastore
-------------------------------------------------

Follow the same configuration of the Host as the one required by the :ref:`Ceph Datastore <ceph_ds>` section.

.. _system_ds_multiple_system_datastore_setups:

Tuning and Extending
====================

Drivers can be easily customized. Please refer to the specific guide for each datastore driver or to the :ref:`Storage substystem developer's guide <sd>`.

However you may find the files you need to modify here:

* ``/var/lib/one/remotes/datastore/<DS_DRIVER>``
* ``/var/lib/one/remotes/tm/<TM_DRIVER>``

.. |image0| image:: /images/shared_system.png
.. |image1| image:: /images/ssh_system.png
