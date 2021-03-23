.. _sm:
.. _storage:

=================
Overview
=================

Datastore Types
================================================================================

Storage in OpenNebula is designed around the concept of Datastores. A Datastore is any storage medium to store disk images. OpenNebula distinguishes among three different Datastore types:

* **Images Datastore**, which stores the base operating system images, persistent data volumes, CD-ROMs.
* **System Datastore** holds disks of running Virtual Machines. Disk are moved from/to the Images when the VMs are deployed/terminated.
* **Files & Kernels Datastore** to store plain files (not disk images), e.g. kernels, ramdisks, or contextualization files. :ref:`See details here <file_ds>`.

|image0|

Image Datastores
----------------

There are different Image Datastores depending on how the images are stored on the underlying storage technology:

* :ref:`Filesystem <fs_ds>`, to store images as files.
* :ref:`Ceph <ceph_ds>`, to store images using Ceph block devices.
* :ref:`LVM <lvm_drivers>`, to store images in LVM logical volumes.
* :ref:`Raw Device Mapping <dev_ds>`, to directly attach existing block devices on the Nodes to the Virtual Machine.
* :ref:`iSCSI - Libvirt Datastore <iscsi_ds>`, to access iSCSI devices through the built-in QEMU support.

Disk images are transferred between the Image and System datastores by the :ref:`transfer manager <sd_tm>` (TM) drivers. These drivers are specialized pieces of software that perform low-level storage operations. The following table summarizes the available transfer modes for each datastore:

+---------------+-------------------------------------------------------------------+
|   Datastore   | Image to System (VM) Datastore disk transfers methods             |
+===============+===================================================================+
| Filesystem    | ``shared`` - images are exported in a shared filesystem           |
|               +-------------------------------------------------------------------+
|               | ``qcow2`` - like *shared* but specialized for the qcow2 format    |
|               +-------------------------------------------------------------------+
|               | ``ssh`` - images are copied using the SSH protocol                |
+---------------+-------------------------------------------------------------------+
| Ceph          | ``ceph`` - all images are exported in Ceph pools                  |
|               +-------------------------------------------------------------------+
|               | ``shared`` - volatile & context disks exported in a shared FS.    |
|               +-------------------------------------------------------------------+
|               | ``ssh`` - images are copied from Ceph to local filesystem         |
+---------------+-------------------------------------------------------------------+
| LVM           | ``fs_lvm`` - images exported in a shared FS but dumped to a LV    |
+---------------+-------------------------------------------------------------------+
| Raw Devices   | ``dev`` - images are existing block devices on the Nodes          |
+---------------+-------------------------------------------------------------------+
| iSCSI libvirt | ``iscsi`` - images are iSCSI targets                              |
+---------------+-------------------------------------------------------------------+

How Should I Read This Chapter
==============================

Before reading this chapter make sure you are familiar with Node Deployment from :ref:`Open Cloud Deployment <vmmg>`.

After that, proceed with the specific Datastore documentation you might be interested in:

* :ref:`Filesystem <fs_ds>`
* :ref:`Ceph <ceph_ds>`
* :ref:`LVM <lvm_drivers>`
* :ref:`Raw Device Mapping <dev_ds>`
* :ref:`iSCSI - Libvirt Datastore <iscsi_ds>`
* :ref:`Kernels & Files Datastore <file_ds>`

Hypervisor Compatibility
========================

This chapter applies to KVM, Firecracker, and LXD.

.. warning::

   Hypervisor limitations:

   - **LXD** Node only supports :ref:`Filesystem <fs_ds>` and :ref:`Ceph <ceph_ds>`
   - **Firecracker** Node only supports :ref:`Filesystem <fs_ds>`

Follow the chapter :ref:`vCenter Storage <vcenter_ds>` for a similar guide for vCenter.

.. |image0| image:: /images/datastoreoverview.png
    :width: 35%
