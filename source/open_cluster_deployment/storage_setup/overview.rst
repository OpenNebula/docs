.. _sm:
.. _storage:

=================
Overview
=================

Datastore Types
================================================================================

Storage in OpenNebula is designed around the concept of Datastores. A Datastore is any storage medium to store disk images. OpenNebula distinguishes between three different Datastore types:

* **Images Datastore**, which stores the base operating system images, persistent data volumes, CD-ROMs.
* **System Datastore** holds disks of running Virtual Machines. Disk are moved from/to the Images when the VMs are deployed/terminated.
* **Files & Kernels Datastore** to store plain files (not disk images), e.g. kernels, ramdisks, or contextualization files. :ref:`See details here <file_ds>`.

|image0|

Image Datastores
----------------

There are different Image Datastores depending on how the images are stored on the underlying storage technology:
   - :ref:`NFS/NAS <nas_ds>`
   - :ref:`Local Storage <local_ds>`
   - :ref:`OneStor <onestor_ds>`
   - :ref:`Ceph <ceph_ds>`
   - :ref:`SAN <lvm_drivers>`
   - :ref:`Raw Device Mapping <dev_ds>`
   - :ref:`iSCSI - Libvirt <iscsi_ds>`, to access iSCSI devices through the built-in QEMU support

How Should I Read This Chapter
==============================

Before reading this chapter make sure you are familiar with Node Deployment from :ref:`Open Cloud Deployment <vmmg>`.

After that, proceed with the specific Datastore documentation you might be interested in.

Hypervisor Compatibility
========================

This chapter applies to KVM, Firecracker, and LXC.

.. warning::

   Hypervisor limitations:

   - **LXC** Node only supports :ref:`NFS/NAS <nas_ds>`, :ref:`Local Storage <local_ds>` and :ref:`Ceph <ceph_ds>` datastores
   - **Firecracker** Node only supports :ref:`NFS/NAS <nas_ds>`, :ref:`Local Storage <local_ds>` datastores.

Follow the chapter :ref:`vCenter Storage <vcenter_ds>` for a similar guide for vCenter.

.. |image0| image:: /images/datastoreoverview.png
    :width: 35%
