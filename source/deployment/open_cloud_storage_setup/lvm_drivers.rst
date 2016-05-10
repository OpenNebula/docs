.. _lvm_drivers:
.. _fs_lvm_ds:

============
LVM Drivers
============

The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance.

Overview
========

OpenNebula ships with an LVM Driver: **FS LVM**. The images will be stored as regular files, but they will be dumped into a Logical Volumes (LV) upon instantiation, using the ``fs_lvm`` drivers. The Virtual Machines will run from Logical Volumes in the host. Therefore, this mechanism keeps separate the image datastore, where the images will be stored as files (under the usual path: ``/var/lib/one/datastores/<id>``), from the system datastore, where images are dumped into an LV.

This is the recommended driver to be used when a high-end SAN is available. The same LUN can be exported to all the hosts, Virtual Machines will be able to run directly from the SAN.

When a Virtual Machine is instantiated OpenNebula will dynamically select the system datastore. Let's assume for instance the selected datastore is ``104``. The virtual disk image will be copied from the stored image file under the ``datastores`` directory and dumped into a LV under the Volume Group: ``vg-one-104``. It follows that each node **must** have a cluster-aware LVM Volume Group for every possible system datastore it may execute.

If the system datastore runs out of space, the OpenNebula architect can add a new system datastore, providing horizontal scalability for the storage. As OpenNebula features a dynamic selection of the system datastore, it turns into a more granular control of the performance of the storage backend.

|image0|

.. note::

  A difference from previous versions and with the deprecated ``lvm`` drivers is that this datastore does **not** need CLVM configured in your cluster. The drivers refresh LVM meta-data each time an image is needed in another host.

Requirements
============

OpenNebula Front-end
--------------------

No specific requirements are needed for the OpenNebula frontend.

OpenNebula LVM Hosts
--------------------

LVM must be available in the Hosts. The ``oneadmin`` user should be able to execute several LVM related commands with sudo passwordlessly.

* Password-less sudo permission for: ``lvremove``, ``lvcreate``, ``lvs``, ``lvscan``, ``lvchange``, ``vgdisplay`` and ``dd``.
* LVM2 installed.
* ``lvmetad`` must be disabled. Set this parameter in ``/etc/lvm/lvm.conf``: ``use_lvmetad = 0``, and disable the ``lvm2-lvmetad.service`` if running.
* ``oneadmin`` needs to belong to the ``disk`` group (for KVM).

Configuration
=============

Host Configuration
------------------

``lvmetad`` must be disabled. Set this parameter in ``/etc/lvm/lvm.conf``: ``use_lvmetad = 0``, and disable the ``lvm2-lvmetad.service`` if running.

The hosts must have LVM2 installed and **must** have a Volume-Group for every possible system-datastore that can run in the host.

Configuring the System Datastore
--------------------------------

To use LVM drivers, the system datastore **must** be ``fs_lvm``. This system datastore will hold only the symbolic links to the block devices, and the checkpoints if ``onevm suspend`` is executed , so it will not take much space. See more details on the :ref:`System Datastore Guide <system_ds>`.

It will also be used to hold context images and Disks created on the fly, they will be created as regular files.

The LVM Volume Group is hardcoded to have the following name: ``vg-one-<system_ds_id>``. Therefore the nodes **must** have those Volume Groups pre-created and available in the Hosts.

Configuring LVM Datastores
--------------------------

The first step to create a LVM datastore is to set up a template file for it.

The specific attributes for this datastore driver are listed in the following table, you will also need to complete with the :ref:`common datastore attributes <sm_common_attributes>`:

+-----------------+------------------------------------------------------+
|    Attribute    |                     Description                      |
+=================+======================================================+
| ``DS_MAD``      | Must be ``fs``                                       |
+-----------------+------------------------------------------------------+
| ``TM_MAD``      | Must be ``fs_lvm``                                   |
+-----------------+------------------------------------------------------+
| ``DISK_TYPE``   | Must be ``block``                                    |
+-----------------+------------------------------------------------------+

For example, the following examples illustrates the creation of an LVM datastore using a configuration file. In this case we will use the host ``host01`` as one of our OpenNebula LVM-enabled hosts.

.. code::

    > cat ds.conf
    NAME = production
    DS_MAD = fs
    TM_MAD = fs_lvm

    > onedatastore create ds.conf
    ID: 100

    > onedatastore list
      ID NAME            CLUSTER  IMAGES TYPE   TM
       0 system          none     0      fs     fs_lvm
       1 default         none     3      fs     shared
     100 production      none     0      fs     fs_lvm


Now you need to setup the LVM VG. To do so, in one host run ``pvcreate <PhysicalVolume>`` for the physical volume that is shared across all the hosts. Now create a new VG using that very same PV with the name: ``vg-one-<system_ds_id>``. In the rest of the nodes simply run ``pvscan`` and ``vgscan``. You should see the new VG as long as the host has access to the shared physical volume.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter:

Under ``/var/lib/one/remotes/``:

* **tm/fs_lvm/ln**: Links to the LVM logical volume.
* **tm/fs_lvm/clone**: Clones the image by creating a snapshot.
* **tm/fs_lvm/mvds**: Saves the image in a new LV for SAVE_AS.
* **tm/fs_lvm/cpds**: Saves the image in a new LV for SAVE_AS while VM is running.

.. |image0| image:: /images/fs_lvm_datastore.png
