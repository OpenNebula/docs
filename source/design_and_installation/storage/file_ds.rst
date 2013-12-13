.. _file_ds:

==============================
The Kernels & Files Datastore
==============================

The Files Datastore lets you store plain files to be used as VM kernels, ramdisks or context files. The Files Datastore does not expose any special storage mechanism but a simple and secure way to use files within VM templates. There is a Files Datastore (datastore ID: 2) ready to be used in OpenNebula.

Requirements
============

There are no special requirements or software dependencies to use the Files Datastore. The recommended drivers make use of standard filesystem utils (cp, ln, mv, tar, mkfs...) that should be installed in your system.

Configuration
=============

Most of the configuration considerations used for disk images datastores do apply to the Files Datastore (e.g. driver setup, cluster assignment, datastore management...). However, given the special nature of the Files Datastore most of these attributes can be fixed as summarized in the following table:

+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
|          Attribute           |                                                           Description                                                            |
+==============================+==================================================================================================================================+
| ``NAME``                     | The name of the datastore                                                                                                        |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``TYPE``                     | Use ``FILE_DS`` to setup a Files datastore                                                                                       |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD``                   | The DS type, use ``fs`` to use the file-based drivers                                                                            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``                   | Transfer drivers for the datastore, use ``ssh`` to transfer the files                                                            |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS``          | Paths that can not be used to register images. A space separated list of paths.                                                  |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``                | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                          |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``LIMIT_TRANSFER_BW``        | Specify the maximum transfer rate in bytes/second when downloading images from a http/https URL. Suffixes K, M or G can be used. |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DATASTORE_CAPACITY_CHECK`` | If “yes”, the available capacity of the datastore is checked before creating a new image                                         |
+------------------------------+----------------------------------------------------------------------------------------------------------------------------------+

.. warning:: This will prevent users registering important files as VM images and accessing them thourgh their VMs. OpenNebula will automatically add its configuration directories: /var/lib/one, /etc/one and oneadmin's home. If users try to register an image from a restricted directory, they will get the following error message: “Not allowed to copy image file”.

For example, the following illustrates the creation of File Datastore.

.. code::

    > cat kernels_ds.conf
    NAME = kernels
    DS_MAD = fs
    TM_MAD = ssh
    TYPE = FILE_DS
    SAFE_DIRS = /var/tmp/files

    > onedatastore create kernels_ds.conf
    ID: 100

    > onedatastore list
      ID NAME                      CLUSTER         IMAGES TYPE DS       TM      
       0 system                    -                    0 sys  -        dummy   
       1 default                   -                    0 img  dummy    dummy   
       2 files                     -                    0 fil  fs       ssh   
     100 kernels                   -                    0 fil  fs       ssh   

The DS and TM MAD can be changed later using the ``onedatastore update`` command. You can check more details of the datastore by issuing the ``onedatastore show`` command.

Host Configuration
==================

The recommended ``ssh`` driver for the File Datastore does not need any special configuration for the hosts. Just make sure that there is enough space under ``$DATASTORE_LOCATION`` to hold the VM files in the front-end and hosts.

For more details :ref:`refer to the Filesystem Datastore guide <fs_ds>`, as the same configuration guidelines applies.

