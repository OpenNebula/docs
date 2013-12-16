.. _fs_ds:

=========================
The Filesystem Datastore
=========================

The Filesystem datastore lets you store VM images in a file form. The datastore is format agnostic, so you can store any file-type depending on the target hypervisor. The use of file-based disk images presents several benefits over deviced backed disks (e.g. easily backup images, or use of shared FS) although it may less performing in some cases.

Usually it is a good idea to have multiple filesystem datastores to:

-  Group images of the same type, so you can have a qcow datastore for KVM hosts and a raw one for Xen
-  Balance I/O operations, as the datastores can be in different servers
-  Use different datastores for different cluster hosts
-  Apply different QoS policies to different images

Requirements
============

There are no special requirements or software dependencies to use the filesystem datastore. The drivers make use of standard filesystem utils (cp, ln, mv, tar, mkfs...) that should be installed in your system.

Configuration
=============

Configuring the System Datastore
--------------------------------

Filesystem datastores can work with a system datastore that uses either the shared or the SSH transfer drivers, note that:

-  Shared drivers for the **system** datastore enables live-migrations, but it could demand a high-performance SAN.

-  SSH drivers for the **system** datastore may increase deployment/shutdown times but all the operations are performed locally, so improving performance in general.

See more details on the :ref:`System Datastore Guide <system_ds>`

Configuring the FileSystem Datastores
-------------------------------------

The first step to create a filesystem datastore is to set up a template file for it. In the following table you can see the valid configuration attributes for a filesystem datastore. The datastore type is set by its drivers, in this case be sure to add ``DS_MAD=fs``.

The other important attribute to configure the datastore is the transfer drivers. These drivers determine how the images are accessed in the hosts. The Filesystem datastore can use shared, ssh and qcow2. See below for more details.

+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| Attribute                      | Description                                                                                                                                          | Values                                              |
+================================+======================================================================================================================================================+=====================================================+
| ``NAME``                       | The name of the datastore                                                                                                                            | N/A                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``DS_MAD``                     | The DS type, use ``fs`` for the Filesystem datastore                                                                                                 | ceph, dummy, fs, iscsi, lvm, vmfs                   |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``TM_MAD``                     | Transfer drivers for the datastore: ``shared``, ``ssh`` or ``qcow2``, see below                                                                      | ceph, dummy, iscsi, lvm, qcow2, shared, ssh, vmfs   |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``RESTRICTED_DIRS``            | Paths that can not be used to register images. A space separated list of paths.                                                                      | N/A                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``SAFE_DIRS``                  | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                                              | N/A                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``NO_DECOMPRESS``              | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers. Use value ``yes`` to disable decompression.   | yes                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``LIMIT_TRANSFER_BW``          | Specify the maximum transfer rate in bytes/second when downloading images from a http/https URL. Suffixes K, M or G can be used.                     | N/A                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``DATASTORE_CAPACITY_CHECK``   | If ``yes``, the available capacity of the datastore is checked before creating a new image                                                           | yes                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+
| ``BASE_PATH``                  | Base path to build the path of the Datastore Images. This path is used to store the images when they are created in the datastore                    | N/A                                                 |
+--------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------+

.. note:: The ``RESTRICTED_DIRS`` directive will prevent users registering important files as VM images and accessing them thourgh their VMs. OpenNebula will automatically add its configuration directories: /var/lib/one, /etc/one and oneadmin's home. If users try to register an image from a restricted directory, they will get the following error message: ``Not allowed to copy image file``.

For example, the following illustrates the creation of a filesystem datastore using the shared transfer drivers.

.. code::

    > cat ds.conf
    NAME = production
    DS_MAD = fs
    TM_MAD = shared

    > onedatastore create ds.conf
    ID: 100

    > onedatastore list
      ID NAME            CLUSTER  IMAGES TYPE   TM
       0 system          none     0      fs     shared
       1 default         none     3      fs     shared
     100 production      none     0      fs     shared

The DS and TM MAD can be changed later using the ``onedatastore update`` command. You can check more details of the datastore by issuing the ``onedatastore show`` command.

Finally, you have to prepare the storage for the datastore and configure the hosts to access it. This depends on the transfer mechanism you have chosen for your datastore.

After creating a new datastore the LN\_TARGET and CLONE\_TARGET parameters will be added to the template. These values should not be changed since they define the datastore behaviour. The default values for these parameters are defined in :ref:`oned.conf <oned_conf_transfer_driver>` for each driver.

.. warning:: Note that datastores are not associated to any cluster by default, and their are supposed to be accessible by every single host. If you need to configure datastores for just a subset of the hosts take a look to the :ref:`Cluster guide <cluster_guide>`.

Using the Shared Transfer Driver
================================

The shared transfer driver assumes that the datastore is mounted in all the hosts of the cluster. When a VM is created, its disks (the ``disk.i`` files) are copied or linked in the corresponding directory of the system datastore. These file operations are always performed remotely on the target host.

|image1|

Persistent & Non Persistent Images
----------------------------------

If the VM uses a persistent image, a symbolic link to the datastore is created in the corresponding directory of the system datastore. Non-persistent images are copied instead. For persistent images, this allows an immediate deployment, and no extra time is needed to save the disk back to the datastore when the VM is shut down.

On the other hand, the original file is used directly, and if for some reason the VM fails and the image data is corrupted or lost, there is no way to cancel the persistence.

Finally images created using the 'onevm disk-snapshot' command will be moved to the datastore only after the VM is successfully shut down. This means that the VM has to be shutdown using the 'onevm shutdown' command, and not 'onevm delete'. Suspending or stopping a running VM won't copy the disk file to the datastore either.

Host Configuration
------------------

Each host has to mount the datastore under ``$DATASTORE_LOCATION/<datastore_id>``. You also have to mount the datastore in the front-end in ``/var/lib/one/datastores/<datastore_id>``.

.. warning:: DATASTORE\_LOCATION defines the path to access the datastores in the hosts. It can be defined for each cluster, or if not defined for the cluster the default in oned.conf will be used.

.. warning:: When needed, the front-end will access the datastores using BASE\_PATH (defaults to ``/var/lib/one/datastores``). You can set the BASE\_PATH for the datastore at creation time.

Using the SSH Transfer Driver
=============================

In this case the datastore is only directly accessed by the front-end. VM images are copied from/to the datastore using the SSH protocol. This may impose high VM deployment times depending on your infrastructure network connectivity.

|image2|

Persistent & Non Persistent Images
----------------------------------

In either case (persistent and non-persistent) images are always copied from the datastore to the corresponding directory of the system datastore in the target host.

If an image is persistent (or for the matter of fact, created with the 'onevm disk-snapshot' command), it is transferred back to the Datastore only after the VM is successfully shut down. This means that the VM has to be shut down using the 'onevm shutdown' command, and not 'onevm delete'. Note that no modification to the image registered in the datastore occurs till that moment. Suspending or stopping a running VM won't copy/modify the disk file registered in the datastore either.

Host Configuration
------------------

There is no special configuration for the hosts in this case. Just make sure that there is enough space under ``$DATASTORE_LOCATION`` to hold the images of the VMs running in that host.

Using the qcow2 Transfer driver
===============================

The qcow2 drivers are a specialization of the shared drivers to work with the qcow2 format for disk images. The same features/restrictions and configuration applies so be sure to read the shared driver section.

The following list details the differences:

-  Persistent images are created with the ``qemu-img`` command using the original image as backing file
-  When an image has to be copied back to the datastore the ``qemu-img convert`` command is used instead of a direct copy

Tuning and Extending
====================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage substystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/``<DS_DRIVER>``
-  /var/lib/one/remotes/tm/``<TM_DRIVER>``

.. |image1| image:: /images/fs_shared.png
.. |image2| image:: /images/fs_ssh.png
