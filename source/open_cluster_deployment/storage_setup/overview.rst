.. _sm:
.. _storage:

=================
Overview
=================

Datastore Types
================================================================================

OpenNebula storage is structured around the Datastore concept. A Datastore is any storage medium to store disk images. OpenNebula features three different datastore types:

* The **Images Datastore**, stores the images repository.

* The **System Datastore** holds disk for running virtual machines. Disk are moved, or cloned to/from the Images datastore when the VMs are deployed or terminated; or when disks are attached or snapshotted.

* The **Files & Kernels Datastore** to store plain files and not disk images. The plain files can be used as kernels, ram-disks or context files. :ref:`See details here <file_ds>`.

|image0|

Image Datastores
--------------------------------------------------------------------------------
There are different Image Datastores depending on how the images are stored on the underlying storage technology:

* :ref:`Filesystem <fs_ds>`, to store images in a file form.

* :ref:`LVM <lvm_drivers>`, to store images in LVM logical volumes.

* :ref:`Ceph <ceph_ds>`, to store images using Ceph block devices.

* :ref:`Raw Device Mapping <dev_ds>`, to direct attach to the virtual machine existing block devices in the nodes.

* :ref:`iSCSI - Libvirt Datastore <iscsi_ds>`, to access iSCSI devices through the buil-in qemu support.

Disk images are transferred between the Image and System datastores by the transfer manager (TM) drivers. These drivers are specialized pieces of software that perform low-level storage operations. The following table summarizes the available transfer modes for each datastore:

+---------------+-------------------------------------------------------------------+
|   Datastore   | Image to System Datastore disk transfers methods                  |
+===============+===================================================================+
| Filesystem    | * **shared**, images are exported in a shared filesystem          |
|               | * **ssh**, images are copied using the ssh protocol               |
|               | * **qcow2**, like *shared* but specialized for the qcow2 format   |
+---------------+-------------------------------------------------------------------+
| Ceph          | * **ceph**, all images are exported in Ceph pools                 |
|               | * **shared**, volatile & context disks exported in a shared FS.   |
+---------------+-------------------------------------------------------------------+
| LVM           | * **fs_lvm**, images exported in a shared FS but dumped to a LV   |
+---------------+-------------------------------------------------------------------+
| Raw Devices   | * **dev**, images are existing block devices in the nodes         |
+---------------+-------------------------------------------------------------------+
| iSCSI libvirt | * **iscsi**, images are iSCSI targets                             |
+---------------+-------------------------------------------------------------------+

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Host <vmmg>` chapter. After that, proceed to the specific section for the Datastores you may be interested in.

After reading this chapter you should read the :ref:`Open Cloud Networking <nm>` chapter.

Hypervisor Compatibility
================================================================================

This chapter applies to KVM, Firecracker and LXD.

.. note:: LXD Drivers only support Filesystem and Ceph

.. note:: Firecracker Drivers only support Filesystem

Follow the :ref:`vCenter Storage <vcenter_ds>` section for a similar guide for vCenter.

.. |image0| image:: /images/datastoreoverview.png
