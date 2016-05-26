.. _ds_op:

Create a Datastore
==================

.. _ds_op_definition:

Datastore Attributes
--------------------------------------------------------------------------------

When defining a datastore there are a set of global attributes that can be used in any datastore. Please note that this list **must** be extended with the specific attributes for each datastore type, which can be found in the specific guide for each datastore driver.

Common attributes:

.. _sm_common_attributes:

+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
|          Attribute           |                                                           Description                                                            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``Name`` (**mandatory**)     | The name of the datastore                                                                                                        |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD`` (**mandatory**)   | The DS type. Possible values: ``fs``, ``lvm``, ``fs_lvm``, ``ceph``, ``dev``                                                     |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD`` (**mandatory**)   | Transfer drivers for the datastore. Possible values: ``shared``, ``ssh``, ``qcow2``, ``lvm``, ``fs_lvm``, ``ceph``, ``dev``      |
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


+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute    |                                                                                                                                               Description                                                                                                                                               |
+=================+=========================================================================================================================================================================================================================================================================================================+
| ``BRIDGE_LIST`` | **(Optional)** Space separated list of hosts that have access to the storage. This can be all the hosts in the storage cluster, or a subset of them, which will carry out the write operations to the datastore. For each operation only one of the host will be chosen, using a round-robin algorithm. |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``STAGING_DIR`` | **(Optional)** Images are first downloaded to the frontend and then scp'd over to the chosen host from the ``BRIDGE_LIST`` list. They are scp'd to the ``STAGING_DIR``, and then moved to the final destination. If empty, it defaults to ``/var/tmp``.                                                 |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Multiple System Datastore Setup
===============================

In order to distribute efficiently the I/O of the Virtual Machines across different disks, LUNs or several storage backends, OpenNebula is able to define multiple System Datastores per cluster. Scheduling algorithms take into account disk requirements of a particular VM, so OpenNebula is able to pick the best execution host based on capacity and storage metrics.

Admin Perspective
-----------------

For an admin, it means that she would be able to decide which storage policy to apply for the whole cloud she is administering, that will then be used to chose which System Datastore is more suitable for a certain VM.

When more than one System Datastore is added to a cluster, all of them can be taken into account by the scheduler to place Virtual Machines into.

System scheduling policies are defined in ``/etc/one/sched.conf``. These are the defaults the scheduler would use if the VM template doesn't state otherwise. The possibilities are described here:

* **Packing**. Tries to optimize storage usage by selecting the Datastore with less free space.
* **Striping**. Tries to optimize I/O by distributing the Virtual Machines across Datastores.
* **Custom**. Based on any of the attributes present in the Datastore template.

To activate for instance the Stripping storage policy, ``/etc/one/sched.conf`` must contain:

.. code::

    DEFAULT_DS_SCHED = [
       policy = 1
    ]

After a VM is deployed in a System Datastore, the admin can migrate it to another System Datastore. To do that, the VM must be first :ref:`powered-off <vm_guide_2>`. The command ``onevm migrate`` accepts both a new Host and Datastore id, that must have the same TM_MAD drivers as the source Datastore.

.. warning:: Any Host belonging to a given cluster **must** be able to access any system or image Datastore defined in that cluster.

User Perspective
----------------

For a user, OpenNebula's ability to handle multiple Datastores means that he would be able to require for its Virtual Machines to be run on a System Datastore backed by a fast storage SAN, or run on the Host with a Datastore with the most free space available. This choice is obviously limited to the underlying hardware and the configuration.

This control can be exerted within the VM template, with two attributes:

+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------+
|       Attribute       |                                                                      Description                                                                       |                    Examples                   |
+=======================+========================================================================================================================================================+===============================================+
| SCHED_DS_REQUIREMENTS | Boolean expression that rules out entries from the pool of Datastores suitable to run this VM.                                                         | ``SCHED_DS_REQUIREMENTS="ID=100"``            |
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

