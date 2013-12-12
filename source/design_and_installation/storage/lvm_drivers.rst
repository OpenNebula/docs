.. _lvm_drivers:

============
LVM Drivers
============

The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance.

Overview
========

OpenNebula ships with two sets of LVM drivers:

-  **FS LVM**, file based VM disk images with Logical Volumes (LV), using the ``fs_lvm`` drivers
-  **Block LVM**, pure Logical Volume (LV), using the ``lvm`` drivers

In both cases Virtual Machine will run from Logical Volumes in the host, and they both require cLVM in order to provide live-migration.

However there are some differences, in particular the way non active images are stored, and the name of the Volume Group where they are executed.

This is a brief description of both drivers:

FS LVM
======

In a FS LVM datastore using the fs\_lvm drivers (the now recommended LVM drivers), images are registered as files in a shared FS volume, under the usual path: ``/var/lib/one/datastores/<id>``.

This directory needs to be accessible in the worker nodes, using NFS or any other shared/distributed file-system.

When a Virtual Machine is instantiated OpenNebula will dynamically select the system datastore. Let's assume for instance the selected datastore is ``104``. The virtual disk image will be copied from the stored image file under the ``datastores`` directory and dumped into a LV under the Volume Group: ``vg-one-104``. It follows that each node **must** have a cluster-aware LVM Volume Group for every possible system datastore it may execute.

This set of drivers brings precisely the advantage of dynamic selection of the system datastore, allowing therefore more granular control of the performance of the storage backend.

|image0|

:ref:`Read more <fs_lvm_ds>`

Block LVM
=========

The Block LVM datastore use the ``lvm`` drivers with the classical approach to using LVM in OpenNebula.

When a new datastore that uses this set of drivers is created, it requires the VG\_NAME parameter, which will tie the images to that Volume Group. Images will be registered directly as Logical Volumes in that Volume Group (as opposed to being registered as files in the frontend), and when they are instantiated the new cloned Logical Volume will also be created in that very same Volume Group.

|image1|

:ref:`Read more <lvm_ds>`

.. |image0| image:: /images/fs_lvm_datastore.png
.. |image1| image:: /images/lvm_datastore_detail.png
