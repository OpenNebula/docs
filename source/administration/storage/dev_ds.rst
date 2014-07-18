.. _dev_ds:

=====================
The Devices Datastore
=====================

This datastore is used to register already existent block devices in the nodes to be used with virtual machines. It does not do any kind of device discovering or setup. The devices should be already setup and available and, VMs using these devices must be fixed to run in the nodes ready for them.

.. warning:: This driver **only** works with KVM and Xen drivers. VMware is not supported.

Requirements
============

The devices you want to attach to a VM should be accessible by the hypervisor:

* Xen runs as root so this user should be able to access it.
* KVM usually runs as oneadmin. Make sure this user is in a group with access to the disk (like disk) and has read write permissions for the group.

Images created in this datastore should be persistent. Making the images non persistent allows more than one VM use this device and will probably cause problems and data corruption.

.. warning:: The datastore should only be usable by the administrators. Letting users create images in this datastore will cause security problems. For example, register an image ``/dev/sda`` and reading the host filesystem.

Configuration
=============

Configuring the System Datastore
--------------------------------

The system datastore can be of type ``shared`` or ``ssh``. See more details on the :ref:`System Datastore Guide <system_ds>`


Configuring DEV Datastore
-------------------------

The datastore needs to have both ``DS_MAD`` and ``TM_MAD`` set to ``dev`` and ``DISK_TYPE`` to ``BLOCK``.

An example of datastore:

.. code::

    > cat dev.conf
    NAME=dev
    DISK_TYPE="BLOCK"
    DS_MAD="dev"
    TM_MAD="dev"
    TYPE="IMAGE_DS"

    > onedatastore create dev.conf
    ID: 101

    > onedatastore list
      ID NAME                SIZE AVAIL CLUSTER      IMAGES TYPE DS       TM
       0 system              9.9G 98%   -                 0 sys  -        shared
       1 default             9.9G 98%   -                 2 img  shared   shared
       2 files              12.3G 66%   -                 0 fil  fs       ssh
     101 dev                   1M 100%  -                 0 img  dev      dev

Use
===

New images can be added as any other image specifying the path. If you are using the CLI do not use the shorthand parameters as the CLI check if the file exists and the device most provably won't exist in the frontend. As an example here is an image template to add a node disk ``/dev/sdb``:

.. code:: bash

    NAME=scsi_device
    PATH=/dev/sdb
    PERSISTENT=YES

.. warning:: As this datastore does is just a container for existing devices images does not take any size from it. All devices registered will render size of 0 and the overall devices datastore will show up with 1MB of available space
