.. _ds_op:

================================================================================
Datastores
================================================================================

OpenNebula features three different datastore types:

* The **Images Datastore**, stores the images repository.

* The **System Datastore** holds disk for running virtual machines, copied or cloned from the Images Datastore.

* The **Files & Kernels Datastore** to store plain files.

Datastore Management
================================================================================

Datastores are managed with the :ref:`''onedatastore'' command <cli>`. In order to be operational an OpenNebula cloud needs at least one Image Datastore and one System Datastore.

Datastore Definition
--------------------------------------------------------------------------------

.. _ds_definition:

A datastore definition includes specific attributes to configure its interaction with the storage system; and common attributes that define its generic behavior.

The specific attributes for System and Images Datastores depends on the storage:

* Define :ref:`Filesystem Datastores <fs_ds>`.
* Define :ref:`LVM Datastores <lvm_drivers>`.
* Define :ref:`Ceph Datastores <ceph_ds>`.
* Define :ref:`Raw Device Mapping Datastores <dev_ds>`.
* Define :ref:`iSCSI - Libvirt Datastores <iscsi_ds>`.

.. _ds_op_common_attributes:

Also, there are a set of common attributes that can be used in any datastore and compliments the specific attributes for each datastore type described above for each datastore type.

+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
|          Attribute           |                                                           Description                                                            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS``          | Paths that can not be used to register images. A space separated list of paths.                                                  |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``                | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                          |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``NO_DECOMPRESS``            | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers                            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``LIMIT_TRANSFER_BW``        | Specify the maximum transfer rate in bytes/second when downloading images from a http/https URL. Suffixes K, M or G can be used. |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DATASTORE_CAPACITY_CHECK`` | If ``yes``, the available capacity of the datastore is checked before creating a new image                                       |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``LIMIT_MB``                 | The maximum capacity allowed for the datastore in ``MB``.                                                                        |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST``              | Space separated list of hosts that have access to the storage to add new images to the datastore.                                |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``STAGING_DIR``              | Path in the storage bridge host to copy an Image before moving it to its final destination. Defaults to ``/var/tmp``.            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DRIVER``                   | Specific image mapping driver enforcement. If present it overrides image ``DRIVER`` set in the image attributes and VM template. |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``COMPATIBLE_SYS_DS``        | Only for IMAGE_DS. Specifies which system datastores are compatible with an image datastore by ID. Ex: "0,100"                   |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+

The Files & Kernels Datastore is an special datastore type to store plain files to be used as kernels, ram-disks or context files. :ref:`See here to learn how to define them <file_ds>`.

.. _system_ds_multiple_system_datastore_setups:

Multiple System Datastore Setup
================================================================================

In order to distribute efficiently the I/O of the Virtual Machines across different disks, LUNs or several storage backends, OpenNebula is able to define multiple System Datastores per cluster. Scheduling algorithms take into account disk requirements of a particular VM, so OpenNebula is able to pick the best execution host based on capacity and storage metrics.

Configuring Multiple Datastores
--------------------------------------------------------------------------------

When more than one System Datastore is added to a cluster, all of them can be taken into account by the scheduler to place Virtual Machines into. System wide scheduling policies are defined in ``/etc/one/sched.conf``. The storage scheduling policies are:

* **Packing**. Tries to optimize storage usage by selecting the Datastore with less free space.
* **Striping**. Tries to optimize I/O by distributing the Virtual Machines across Datastores.
* **Custom**. Based on any of the attributes present in the Datastore template.

To activate for instance the Stripping storage policy, ``/etc/one/sched.conf`` must contain:

.. code::

    DEFAULT_DS_SCHED = [
       policy = 1
    ]

These policies may be overriden in the Virtual Machine Template, and so apply specific storage policies to specific Virtual Machines:

+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+
|       Attribute       |                    Description                                                    |                 Example                    |
+=======================+===================================================================================+============================================+
| SCHED_DS_REQUIREMENTS | Boolean expression to select System Datastores (evaluates to true) to run a  VM.  | ``SCHED_DS_REQUIREMENTS="ID=100"``         |
|                       |                                                                                   | ``SCHED_DS_REQUIREMENTS="NAME=GoldenDS"``  |
|                       |                                                                                   | ``SCHED_DS_REQUIREMENTS=FREE_MB > 250000`` |
+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+
| SCHED_DS_RANK         | Arithmetic expression to sort the suitable datastores for this VM.                | ``SCHED_DS_RANK= FREE_MB``                 |
|                       |                                                                                   | ``SCHED_DS_RANK=-FREE_MB``                 |
+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+

After a VM is deployed in a System Datastore, the admin can migrate it to another System Datastore. To do that, the VM must be first :ref:`powered-off <vm_guide_2>`. The command ``onevm migrate`` accepts both a new Host and Datastore id, that must have the same ``TM_MAD`` drivers as the source Datastore.

.. warning:: Any Host belonging to a given cluster **must** be able to access any System or Image Datastore defined in that cluster.

.. warning:: Admins rights grant permissions to deploy a virtual machine to a certain datastore, using 'onevm deploy' command.

.. _disable_system_ds:

Disable a System Datastore
=================================================================================

System Datastores can be disabled to prevent the scheduler from deploying new Virtual Machines in them. Datastores in the ``disabled`` state and monitored as usual, and the existing Virtual Machines will continue to run in them.

.. code::

    $ onedatastore disable system -v
    DATASTORE 0: disabled

    $ onedatastore show system
    DATASTORE 0 INFORMATION
    ID             : 0
    NAME           : system
    ...
    STATE          : DISABLED
    ...

