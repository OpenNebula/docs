.. _fs_lvm_ds:

=====================
The FS LVM Datastore
=====================

Overview
========

The FS LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images.

It is assumed that the OpenNebula hosts using this datastore will be configured with CLVM, therefore modifying the OpenNebula Volume Group in one host will reflect in the others.

|image0|

Requirements
============

OpenNebula Front-end
--------------------

-  Password-less ssh access to an OpenNebula LVM-enabled host.

OpenNebula LVM Hosts
--------------------

LVM must be available in the Hosts. The ``oneadmin`` user should be able to execute several LVM related commands with sudo passwordlessly.

-  Password-less sudo permission for: ``lvremove``, ``lvcreate``, ``lvs``, ``vgdisplay`` and ``dd``.
-  LVM2
-  ``oneadmin`` needs to belong to the ``disk`` group (for KVM).

Configuration
=============

Configuring the System Datastore
--------------------------------

To use LVM drivers, the system datastore **must** be ``shared``. This sytem datastore will hold only the symbolic links to the block devices, so it will not take much space. See more details on the :ref:`System Datastore Guide <system_ds>`

It will also be used to hold context images and Disks created on the fly, they will be created as regular files.

It is worth noting that running virtual disk images will be created in Volume Groups that are hardcoded to be ``vg-one-<system_ds_id>``. Therefore the nodes **must** have those Volume Groups pre-created and available for **all** possible system datastores.

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
       0 system          none     0      fs     shared
       1 default         none     3      fs     shared
     100 production      none     0      fs     fs_lvm

.. note:: Datastores are not associated to any cluster by default, and they are supposed to be accessible by every single host. If you need to configure datastores for just a subset of the hosts take a look to the :ref:`Cluster guide <cluster_guide>`.

After creating a new datastore the LN\_TARGET and CLONE\_TARGET parameters will be added to the template. These values should not be changed since they define the datastore behaviour. The default values for these parameters are defined in :ref:`oned.conf <oned_conf_transfer_driver>` for each driver.

Host Configuration
------------------

The hosts must have LVM2 and **must** have a Volume-Group for every possible system-datastore that can run in the host. CLVM must also be installed and active accross all the hosts that use this datastore.

It's also required to have password-less sudo permission for: ``lvremove``, ``lvcreate``, ``lvs`` and ``dd``.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter:

Under ``/var/lib/one/remotes/``:

-  **tm/fs\_lvm/ln**: Links to the LVM logical volume.
-  **tm/fs\_lvm/clone**: Clones the image by creating a snapshot.
-  **tm/fs\_lvm/mvds**: Saves the image in a new LV for SAVE\_AS.
-  **tm/fs\_lvm/cpds**: Saves the image in a new LV for SAVE\_AS while VM is running.

.. |image0| image:: /images/fs_lvm_datastore.png
