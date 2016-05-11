.. _sm:
.. _storage:

=================
Overview
=================

.. todo::

    * Architect
    * KVM

A Datastore is any storage medium used to store disk images for VMs, previous versions of OpenNebula refer to this concept as Image Repository. Typically, a datastore will be backed by SAN/NAS servers.

An OpenNebula installation can have multiple datastores of several types to store disk images. OpenNebula also uses a special datastore, the *system datastore*, to hold images of running VMs.

|image0|

What Datastore Types Are Available?
===================================

OpenNebula is shipped with 3 different datastore classes:

* :ref:`System <system_ds>`, to hold images for running VMs, depending on the storage technology, these temporal images can be complete copies of the original image, qcow2 deltas or simple file-system links.
* **Images**, stores the disk images repository. Disk images are moved, or cloned to/from the System datastore when the VMs are deployed or terminated; or when disks are attached or snapshotted.
* :ref:`Files <file_ds>`, This is a special datastore used to store plain files and not disk images. The plain files can be used as kernels, ram-disks or context files.

Image datastores can be of different type depending on the underlying storage technology:

* :ref:`File-system <fs_ds>`, to store disk images in a file form. The files are stored in a directory mounted from a SAN/NAS server.
* :ref:`LVM <lvm_drivers>`, The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance..
* :ref:`Ceph <ceph_ds>`, to store disk images using Ceph block devices.
* :ref:`Dev <dev_ds>`, to attach already existing block devices in the nodes in the virtual machines
* :ref:`iSCSI <iscsi_ds>`, to attach already existing iSCSI volume available to the hypervisor nodes, to be used with virtual machines

As usual in OpenNebula the system has been architected to be highly modular, so you can easily adapt the base types to your deployment.

How Are the Images Transferred to the Hosts?
============================================

The Disk images registered in a datastore are transferred to the hosts by the transfer manager (TM) drivers. These drivers are specialized pieces of software that perform low-level storage operations.

The transfer mechanism is defined for each datastore. In this way a single host can simultaneously access multiple datastores that uses different transfer drivers. Note that the hosts must be configured to properly access each data-store type (e.g. mount FS shares).

OpenNebula includes 6 different ways to distribute datastore images to the hosts:

* **shared**, the datastore is exported in a shared file-system to the hosts.
* **ssh**, datastore images are copied to the remote hosts using the ssh protocol
* **qcow2**, a driver specialized to handle qemu-qcow2 format and take advantage of its snapshoting capabilities
* **ceph**, a driver that delegates to libvirt/KVM the management of Ceph RBDs.
* **lvm**, images are stored as LVs in a cLVM volume.
* **fs_lvm**, images are in a file system and are dumped to a new LV in a LVM volume.
* **dev**, attaches existing block devices directly to the VMs
* **iscsi_libvirt**, attaches existing iSCSI volumes directly to the VMs

Planning your Storage
=====================

You can take advantage of the multiple datastore features of OpenNebula to better scale the storage for your VMs, in particular:

* Balancing I/O operations between storage servers
* Different VM types or users can use datastores with different performance features
* Different SLA policies (e.g. backup) can be applied to different VM types or users
* Easily add new storage to the cloud

There are some limitations and features depending on the transfer mechanism you choose for your system and image datastores (check each datastore guide for more information). The following table summarizes the valid combinations of Datastore and transfer drivers:

+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
|   Datastore   | shared | ssh | qcow2 | ceph | lvm | fs_lvm | dev | iscsi_libvirt |
+===============+========+=====+=======+======+=====+========+=====+===============+
| System        | x      | x   |       | x    |     | x      |     |               |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
| Filesystem    | x      | x   | x     |      |     | x      |     |               |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
| ceph          |        |     |       | x    |     |        |     |               |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
| lvm           |        |     |       |      | x   |        |     |               |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
| dev           |        |     |       |      |     |        | x   |               |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+
| iscsi_libvirt |        |     |       |      |     |        |     | x             |
+---------------+--------+-----+-------+------+-----+--------+-----+---------------+

.. _storage_snapshot_compatilibity:

The following table reflects the compatiblity of disk snapshotting and disk live snapshotting (i.e. snapshotting with the VM in running state) for the different transfer manager drivers. This only applies for the kvm hypervisor.

+-------------------+--------+-----+-------+------+-----+--------+-----+---------------+
|     Datastore     | shared | ssh | qcow2 | ceph | lvm | fs_lvm | dev | iscsi_libvirt |
+===================+========+=====+=======+======+=====+========+=====+===============+
| Snapshotting      | x      | x   | x     | x    |     |        |     |               |
+-------------------+--------+-----+-------+------+-----+--------+-----+---------------+
| Live Snapshotting |        |     | x     | x    |     |        |     |               |
+-------------------+--------+-----+-------+------+-----+--------+-----+---------------+

Datastore Attributes
====================

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

Tuning and Extending
====================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage subsystem developer's guide <sd>`.

However you may find the files you need to modify here:

* ``/var/lib/one/remotes/datastore/<DS_DRIVER>``
* ``/var/lib/one/remotes/tm/<TM_DRIVER>``

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Host <vmmg>` chapter.

Regardless of what Image Datastore you are using, read the :ref:`System Datastore <system_ds>` section as it is a crucial part of the Storage system. Likewise, you should also be familiar with the :ref:`Files <file_ds>` datastore, as you can use it with any Datastore type. Finally, read the specific section for the Datastores you may be interested in.

After reading this chapter you should read the :ref:`Open Cloud Networking <nm>` chapter.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.

Follow the :ref:`vCenter Storage <vcenter_ds>` section for a similar guide for vCenter.

.. |image0| image:: /images/datastoreoverview.png
