.. _vmware_ds:

===================
The VMFS Datastore
===================

In order to use VMware hypervisors in your OpenNebula cloud you will need to use **VMFS Datastores**. To configure them, it is important to keep in mind that there are (at least) two datastores to define, the ``system datastore`` (where the running VMs and their images reside, only need transfer manager drivers) and the ``images datastore`` (where the images are stored, needs both datastore and transfer manager drivers).

Requirements
============

-  In order to use the VMFS datastore, the ESX servers need to have the SSH access configured for the oneadmin account.

-  If the VMFS volumes are exported through a SAN, it should be accesible and configured so the ESX server can mount the iSCSI export.

Description
===========

This storage model implies that all the volumes involved in the image staging are purely VMFS volumes, taking full advantage of the VMware filesystem (VM image locking and improved performance).

|image0|

Infrastructure Configuration
============================

-  The OpenNebula front-end doesn't need to mount any datastore.

-  The ESX servers needs to present or mount (as iSCSI, NFS or local storage) both the ``system`` datastore and the ``image`` datastore (naming them with just the <datastore-id>, for instance ``0`` for the ``system`` datastore and ``1`` for the ``image`` datastore).

.. warning:: The system datastore can be other than the default one (``0``). In this case, the ESX will need to mount the datastore *with the same id as the datastores has in OpenNebula*. More details in the :ref:`System Datastore Guide <system_ds>`.

OpenNebula Configuration
========================

The datastore location on ESX hypervisors is ”/vmfs/volumes”. There are two choices:

-  In homogeneous clouds (all the hosts are ESX) set the following in /etc/one/oned.conf:

.. code::

    DATASTORE_LOCATION=/vmfs/volumes

-  In heterogeneous clouds (mix of ESX and other hypervisor hosts) put all the ESX hosts in clusters with the following attribute in their template (e.g. onecluster update):

.. code::

    DATASTORE_LOCATION=/vmfs/volumes

.. warning:: You need also to set the BASE\_PATH attribute in the template when the Datastore is created.

.. _vmware_ds_datastore_configuration:

Datastore Configuration
-----------------------

The ``system`` and ``images`` datastores needs to be configured with the following drivers:

+-----------------+------------------+------------------+
| **Datastore**   | **DS Drivers**   | **TM Drivers**   |
+=================+==================+==================+
| **System**      | -                | vmfs             |
+-----------------+------------------+------------------+
| **Images**      | vmfs             | vmfs             |
+-----------------+------------------+------------------+

System Datastore
~~~~~~~~~~~~~~~~

**vmfs** drivers: the ``system`` datastore needs to be updated in OpenNebula (``onedatastore update <ds_id>``) to set the TM\_MAD drivers to ``vmfs``. There is no need to configure datastore drivers for the system datastore.

OpenNebula expects the system datastore to have the ID=0, but a system datastore with different ID can be defined per cluster. See the :ref:`system datastore guide <system_ds_multiple_system_datastore_setups>` for more details.

Images Datastore
~~~~~~~~~~~~~~~~

The ``image`` datastore needs to be updated to use **vmfs** drivers for the datastore drivers, and **vmfs** drivers for the transfer manager drivers. The default datastore can be updated as:

.. code::

     $ onedatastore update 1
     DS_MAD=vmfs
     TM_MAD=vmfs
     BRIDGE_LIST=<space-separated list of ESXi host>

Apart from DS\_MAD, TM\_MAD and BRIDGE\_LIST; the following attributes can be set:

+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|          Attribute           |                                                                                  Description                                                                                  |
+==============================+===============================================================================================================================================================================+
| ``NAME``                     | The name of the datastore                                                                                                                                                     |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD``                   | The DS type, use ``vmware`` or ``vmfs``                                                                                                                                       |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``                   | Transfer drivers for the datastore: ``shared``, ``ssh`` or ``vmfs``, see below                                                                                                |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS``          | Paths that can not be used to register images. A space separated list of paths.                                                                                               |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``                | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                                                                       |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``UMASK``                    | Default mask for the files created in the datastore. Defaults to ``0007``                                                                                                     |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST``              | Space separated list of ESX servers that are going to be used as proxies to stage images into the datastore (``vmfs`` datastores only)                                        |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DS_TMP_DIR``               | Path in the OpenNebula front-end to be used as a buffer to stage in files in ``vmfs`` datastores. Defaults to the value in ``/var/lib/one/remotes/datastore/vmfs/vmfs.conf``. |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``NO_DECOMPRESS``            | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers                                                                         |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DATASTORE_CAPACITY_CHECK`` | If “yes”, the available capacity of the datastore is checked before creating a new image                                                                                      |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BASE_PATH``                | This variable must be set to /vmfs/volumes for VMFS datastores.                                                                                                               |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. warning:: ``RESTRICTED_DIRS`` will prevent users registering important files as VM images and accessing them through their VMs. OpenNebula will automatically add its configuration directories: /var/lib/one, /etc/one and oneadmin's home. If users try to register an image from a restricted directory, they will get the following error message: “Not allowed to copy image file”.

After creating a new datastore the LN\_TARGET and CLONE\_TARGET parameters will be added to the template. These values should not be changed since they define the datastore behaviour. The default values for these parameters are defined in :ref:`oned.conf <oned_conf_transfer_driver>` for each driver.

Driver Configuration
--------------------

Transfer Manager Drivers
~~~~~~~~~~~~~~~~~~~~~~~~

These drivers trigger the events remotely through an ssh channel. The **vmfs** drivers are a specialization of the shared drivers to work with the VMware vmdk filesystem tools using the ``vmkfstool`` command. This comes with a number of advantages, like FS locking, easier VMDK cloning, format management, etc.

Datastore Drivers
~~~~~~~~~~~~~~~~~

The **vmfs** datastore drivers allows the use of the VMware VM filesystem, which handles VM file locks and also boosts I/O performance.

-  To correctly configure a ``vmfs`` datastore set of drivers there is the need to chose the ESX bridges, i.e., the ESX serves that are going to be used as proxies to stage images into the ``vmfs`` datastore. A list of bridges **must** be defined with the ``BRIDGE_LIST`` attribute of the datastore template (see the table below). The drivers will pick one ESX server from that list in a round robin fashion.

-  The ``vmfs`` datastore needs to use the front-end as a buffer for the image staging in some cases, this buffer can be set in the ``DS_TMP_DIR`` attribute.

Tuning and Extending
====================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage substystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/``<DS_DRIVER>``
-  /var/lib/one/remotes/tm/``<TM_DRIVER>``

.. |image0| image:: /images/pure-vmfs.png
