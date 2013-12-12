.. _sm:

=================
Storage Overview
=================

A Datastore is any storage medium used to store disk images for VMs, previous versions of OpenNebula refer to this concept as Image Repository. Typically, a datastore will be backed by SAN/NAS servers.

An OpenNebula installation can have multiple datastores of several types to store disk images. OpenNebula also uses a special datastore, the *system datastore*, to hold images of running VMs.

|image0|

What Datastore Types Are Available?
===================================

OpenNebula is shipped with 3 different datastore classes:

-  **:ref:`System <system_ds>`**, to hold images for running VMs, depending on the storage technology used these temporal images can be complete copies of the original image, qcow deltas or simple filesystem links.

-  **Images**, stores the disk images repository. Disk images are moved, or cloned to/from the System datastore when the VMs are deployed or shutdown; or when disks are attached or snapshoted.

-  **:ref:`Files <file_ds>`**, This is a special datastore used to store plain files and not disk images. The plain files can be used as kernels, ramdisks or context files.

Image datastores can be of different type depending on the underlying storage technology:

-  **:ref:`File-system <fs_ds>`**, to store disk images in a file form. The files are stored in a directory mounted from a SAN/NAS server.

-  **:ref:`vmfs <vmware_ds#configuring_the_datastore_drivers_for_vmware>`**, a datastore specialized in VMFS format to be used with VMware hypervisors. Cannot be mounted in the OpenNebula front-end since VMFS is not \*nix compatible.

-  **:ref:`LVM <lvm_drivers#lvm>`**, The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance..

-  **:ref:`Ceph <ceph_ds>`**, to store disk images using Ceph block devices.

As usual in OpenNebula the system has been architected to be highly modular, so you can easily adapt the base types to your deployment.

How Are the Images Transferred to the Hosts?
============================================

The Disk images registered in a datastore are transferred to the hosts by the transfer manager (TM) drivers. These drivers are specialized pieces of software that perform low-level storage operations.

The transfer mechanism is defined for each datastore. In this way a single host can simultaneously access multiple datastores that uses different transfer drivers. Note that the hosts must be configured to properly access each data-store type (e.g. mount FS shares).

OpenNebula includes 6 different ways to distribute datastore images to the hosts:

-  **shared**, the datastore is exported in a shared filesystem to the hosts.
-  **ssh**, datastore images are copied to the remote hosts using the ssh protocol
-  **vmfs**, image copies are done using the vmkfstools (VMware filesystem tools)
-  **qcow**, a driver specialized to handle qemu-qcow format and take advantage of its snapshoting capabilities
-  **ceph**, a driver that delegates to libvirt/KVM the management of Ceph RBDs.
-  **lvm**, images are stored as LVs in a cLVM volume.

Planning your Storage
=====================

You can take advantage of the multiple datastore features of OpenNebula to better scale the storage for your VMs, in particular:

-  Balancing I/O operations between storage servers
-  Different VM types or users can use datastores with different performance features
-  Different SLA policies (e.g. backup) can be applied to different VM types or users
-  Easily add new storage to the cloud

There are some limitations and features depending on the transfer mechanism you choose for your system and image datastores (check each datastore guide for more information). The following table summarizes the valid combinations of Datastore and transfer drivers:

Datastore

Transfer Manager Drivers

shared

ssh

qcow

vmfs

ceph

lvm

fs\_lvm

System

x

x

x

File-System

x

x

x

x

vmfs

x

ceph

x

lvm

x

Tuning and Extending
====================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage substystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/``<DS_DRIVER>``
-  /var/lib/one/remotes/tm/``<TM_DRIVER>``

.. |image0| image:: /images/datastoreoverview.png
