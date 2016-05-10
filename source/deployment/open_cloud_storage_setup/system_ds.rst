.. _system_ds:

=====================
The System Datastore
=====================

The system datastore is a special Datastore class that holds images for running VMs. As opposed to the regular images datastores you cannot register new images into a system datastore.

Types of System Datastore
=========================

For each running VM in the datastore there is a directory containing the disk images and additional configuration files. For example, the structure of the system datastore 0 with 3 VMs (VM 0 and 2 running, and VM 7 stopped) could be:

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

There are three system datastore types, based on the TM_MAD driver used:

* ``shared``, the storage area for the system datastore is a shared directory across the hosts.
* ``ssh``, uses a local storage area from each host for the system datastore
* ``ceph``, uses Ceph to store volatile and swap disks, and checkpoint files, but the context and deployment files are still stored locally

.. _system_ds_shared:

The Shared System Datastore
---------------------------

The shared transfer driver requires the hosts to share the system datastore directory (it does not need to be shared with the front-end). Typically these storage areas are shared using a distributed FS like NFS, GlusterFS, Lustre, but it's not necessary.

A shared system datastore usually reduces VM deployment times and **enables live-migration**, but it can also become a bottleneck in your infrastructure and degrade your VMs performance if the virtualized services perform disk-intensive workloads. Usually this limitation may be overcome by:

* Using different file-system servers for the images datastores, so the actual I/O bandwith is balanced
* Using an ssh system datastore instead, the images are copied locally to each host
* Tuning or improving the file-system servers

|image0|

The SSH System Datastore
------------------------

In this case the system datastore is distributed among the hosts. The ssh transfer driver uses the hosts' local storage to place the images of running VMs (as opposed to a shared FS in the shared driver). All the operations are then performed locally but images have to be copied always to the hosts, which in turn can be a very resource demanding operation. Also this driver prevents the use of live-migrations between hosts.

|image1|

.. _system_ds_ceph:

The Ceph System Datastore
-------------------------

The :ref:`Ceph Image Datastore <ceph_ds>` works **both** with the Shared System datastores, and with the specific Ceph System datastore. The Ceph System datastore has the advantage that it does not require the set-up of a shared file-system and everything is stored in the Ceph backend.

The Ceph System Datastore is created with the :ref:`same attributes as the Ceph Image Datastore <ceph_ds_configuring>`, **with the exception that DS_MAD is not specified**.

The following table summarizes the behavior of both system datastores:

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
| Live-Migration      | Allowed. Files are already avaiable in the destination host | Allowed. Local files (context and deployment) are scp'd to the target host, and removed from the source host upon success |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+
| System DS Migration | Allowed. Does not affect the Ceph images                    | Not allowed                                                                                                               |
+---------------------+-------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------+

.. warning::

    As the checkpoint file is temporarily first saved to the hypervisor local filessystem, it needs to have enough scratch space to store it. The path where the checkpoint file will be written to is `$DATASTORE_LOCATION/<ds_id>/<vm_id>`, which is the same as with the other system datastores.

The System and Image Datastores
-------------------------------

OpenNebula will automatically transfer VM disk images to/from the system datastore when a VM is booted or terminated. The actual transfer operations and the space taken from the system datastore depends on both the image configuration (persistent vs non-persistent) as well as the drivers used by the images datastore. The following table summarizes the actions performed by each transfer manager driver type.

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

* **link** is the equivalent to a symbolic link operation that will not take any significant amount of storage from the system datastore
* **copy, rbd copy and lv copy**, are copy operations as in regular cp file operations, that may involve creation of special devices like a logical volume. This will take the same size as the original image.
* **snapshot**, qcow2 snapshot operation.
* **new**, a new image file is created on the system datastore of the specified size.

**Important Note, operations with +**, are performed on the original image datastore; an so those operations take storage from the image datastore and not from the system one.

Once the disk images are transferred from the image datastore to the system datastore using the operations described above, the system datastore (and its drivers) is responsible for managing the images, mainly to:

* Move the images across hosts, e.g. when the VM is stopped or migrated
* Delete any copy from the hosts when the VM is terminated

Configuration Overview
======================

OpenNebula comes with a pre-configured System Datastore: ``default``, with ID: ``0``. It is configured as a ``shared`` System Datastore.

Each :ref:`cluster <cluster_guide>` must have at least one System Datastore assigned. With more than one System Datastore per Cluster, you can better plan the storage requirements, in terms of total capacity assigned, performance requirements and load balancing across system datastores.

To configure the system datastores for your OpenNebula cloud you need to:

* Create as many system datastores as needed (you can add more later if you need them).
* Assign the system datastores to a given cluster.
* Configure the Hosts to access the system datastores (this may involved installing Ceph, or mounting an NFS, etc...).

Step 1. Create a New System Datastore
=====================================

To create a new system datastore you need to specify its type as system either in Sunstone (system) or through the CLI (adding ``TYPE = SYSTEM_DS`` to the datastore template). And you need to select the system datastore drivers, as discussed above: ``shared``, ``ssh`` or ``ceph``.

For example to create a system datastore using the shared drivers simply:

.. code::

    $ cat systemds.txt
    NAME    = nfs_ds
    TM_MAD  = shared
    TYPE    = SYSTEM_DS

    $ onedatastore create system.ds
    ID: 100

Step 2. Assign the System Datastores
====================================

Hosts can only use use a system datastore if they are in the same cluster, so once created you need to add the system datastores to the cluster. You can **add more than one system datastore** to a cluster, the actual system DS used to deploy the VM will be selected based on storage scheduling policies, see below.

To associate this system datastore to the cluster, add it:

.. code::

    $ onecluster adddatastore production_cluster nfs_ds

The Hosts need to be configured to access the systems datastore through a well-known location: ``/var/lib/one/datastores`` (or the value of ``DATASTORE_LOCATION`` in ``oned.conf``).

Step 3. Configure the Hosts
===========================

The specific configuration for the hosts depends on the system datastore type (shared or ssh). Before continuing check that SSH is configured to enable oneadmin passwordless access in every host.

Configure the Hosts for the Shared System Datastore
---------------------------------------------------

A NAS has to be configured to export a directory to the hosts, this directory will be used as the storage area for the system datastore. Each host has to mount this directory under ``$DATASTORE_LOCATION/<ds_id>``. In small installations the front-end can be also used to export the system datastore directory to the hosts. Although this deployment is not recommended for medium-large size deployments.

Configure the Hosts for the SSH System Datastore
------------------------------------------------

There is no special configuration needed to take place to use the ssh drivers for the system datastore. Just be sure that there is enough space under ``$DATASTORE_LOCATION`` to hold the images of the VMs that will run in each particular host.

Also be sure that there is space in the frontend under ``/var/lib/one/datastores/<ds_id>`` to hold the images of the stopped or undeployed VMs

Configure the Hosts for the Ceph System Datastore
-------------------------------------------------

Follow the same configuration of the Host as the one required by the :ref:`Ceph Datastore <ceph_ds>` section.

.. _system_ds_multiple_system_datastore_setups:

Multiple System Datastore Setup
===============================

In order to distribute efficiently the I/O of the VMs across different disks, LUNs or several storage backends, OpenNebula is able to define multiple system datastores per cluster. Scheduling algorithms take into account disk requirements of a particular VM, so OpenNebula is able to pick the best execution host based on capacity and storage metrics.

Admin Perspective
-----------------

For an admin, it means that she would be able to decide which storage policy to apply for the whole cloud she is administering, that will then be used to chose which system datastore is more suitable for a certain VM.

When more than one system datastore is added to a cluster, all of them can be taken into account by the scheduler to place VMs into.

System scheduling policies are defined in ``/etc/one/sched.conf``. These are the defaults the scheduler would use if the VM template doesn't state otherwise. The possibilities are described here:

* **Packing**. Tries to optimize storage usage by selecting the datastore with less free space.
* **Striping**. Tries to optimize I/O by distributing the VMs across datastores.
* **Custom**. Based on any of the attributes present in the datastore template.

To activate for instance the Stripping storage policy, ``/etc/one/sched.conf`` must contain:

.. code::

    DEFAULT_DS_SCHED = [
       policy = 1
    ]

After a VM is deployed in a system datastore, the admin can migrate it to another system datastore. To do that, the VM must be first :ref:`powered-off <vm_guide_2>`. The command ``onevm migrate`` accepts both a new host and datastore id, that must have the same TM_MAD drivers as the source datastore.

.. warning:: Any host belonging to a given cluster **must** be able to access any system or image datastore defined in that cluster.

User Perspective
----------------

For a user, OpenNebula's ability to handle multiples datastore means that she would be able to require for its VMs to be run on a system datastore backed by a fast storage cabin, or run on the host with a datastore with the most free space available. This choice is obviously limited to the underlying hardware and the administrator configuration.

This control can be exerted within the VM template, with two attributes:

+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------+
|       Attribute       |                                                                      Description                                                                       |                    Examples                   |
+=======================+========================================================================================================================================================+===============================================+
| SCHED_DS_REQUIREMENTS | Boolean expression that rules out entries from the pool of datastores suitable to run this VM.                                                         | ``SCHED_DS_REQUIREMENTS="ID=100"``            |
|                       |                                                                                                                                                        | ``SCHED_DS_REQUIREMENTS="NAME=GoldenCephDS"`` |
|                       |                                                                                                                                                        | ``SCHED_DS_REQUIREMENTS=FREE_MB > 250000``    |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------+
| SCHED_DS_RANK         | States which attribute will be used to sort the suitable datastores for this VM. Basically, it defines which datastores are more suitable than others. | ``SCHED_DS_RANK= FREE_MB``                    |
|                       |                                                                                                                                                        | ``SCHED_DS_RANK=-FREE_MB``                    |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------+

.. warning:: Admins and user with admins rights can force the deployment to a certain datastore, using 'onevm deploy' command.

.. _disable_system_ds:

Disable a System Datastore
================================

System Datastores can be disabled to prevent the scheduler from deploying new Virtual Machines in them. Datastores in the ``disabled`` state and monitored as usual, and the existing VMs will continue to run in them.

.. code::

    $ onedatastore disable system -v
    DATASTORE 0: disabled

    $ onedatastore show system
    DATASTORE 0 INFORMATION
    ID             : 0
    NAME           : system
    ...
    STATE          : DISABLED

Tuning and Extending
====================

Drivers can be easily customized. Please refer to the specific guide for each datastore driver or to the :ref:`Storage substystem developer's guide <sd>`.

However you may find the files you need to modify here:

* ``/var/lib/one/remotes/datastore/<DS_DRIVER>``
* ``/var/lib/one/remotes/tm/<TM_DRIVER>``

.. |image0| image:: /images/shared_system.png
.. |image1| image:: /images/ssh_system.png
