.. _dev_ds:

================================================================================
Raw Device Mapping (RDM) Datastore
================================================================================

The RDM Datastore is an Image Datastore that enables raw access to block devices on Nodes. This Datastore enables fast VM deployments due to a non-existent transfer operation from the Image Datastore to the System Datastore.

.. warning:: The Datastore should only be usable by the administrators. Letting users create images in this Datastore is a huge **security risk**! For example, users could register an image ``/dev/sda`` and read the host filesystem.

Datastore Layout
================================================================================

The RDM Datastore is used to register already existing block devices on the Nodes. The devices should be already setup and available and VMs using these devices must be enforced to run on the Nodes ready for them. Additional Virtual Machine files, like deployment files or volatile disks, are created as regular files.

Frontend Setup
================================================================================

No additional setup is required. Make sure :ref:`/etc/one/oned.conf <oned_conf>` has the following configuration for the RDM Datastore:

.. code-block:: bash

    TM_MAD_CONF = [
        NAME = "dev", LN_TARGET = "NONE", CLONE_TARGET = "NONE", SHARED = "YES",
        TM_MAD_SYSTEM = "ssh,shared",
        LN_TARGET_SSH = "SYSTEM", LN_TARGET_SHARED = "NONE",
        DISK_TYPE_SSH = "FILE", DISK_TYPE_SHARED = "FILE",
        CLONE_TARGET_SSH = "SYSTEM", CLONE_TARGET_SHARED =  "SELF",
        DRIVER = "raw"
    ]

Node Setup
================================================================================

The devices you want to attach to a VM should be accessible by the hypervisor. KVM usually runs under identity of ``oneadmin`` user, make sure this user is in a group with access to the disk (like ``disk``) and has read write permissions for the group.

.. _dev_ds_templates:

OpenNebula Configuration
================================================================================

Once the Node storage setup is ready, the OpenNebula configuration comprises of two steps:

* Create System Datastore
* Create Image Datastore

Create System Datastore
--------------------------------------------------------------------------------

The RDM Datastore can work with the following System Datastores:

* Filesystem, **shared** transfer mode
* Filesystem, **ssh** transfer mode

Please refer to the :ref:`Filesystem Datastore section <fs_ds>` for more details. Note that the System Datastore is only used for volatile disks and context devices.

Create Image Datastore
--------------------------------------------------------------------------------

To create an Image Datastore, you need to set following (template) parameters:

+---------------+-------------------------------------------------+
|   Attribute   |                   Description                   |
+===============+=================================================+
| ``NAME``      | Name of Datastore                               |
+---------------+-------------------------------------------------+
| ``TYPE``      | ``IMAGE_DS``                                    |
+---------------+-------------------------------------------------+
| ``DS_MAD``    | ``dev``                                         |
+---------------+-------------------------------------------------+
| ``TM_MAD``    | ``dev``                                         |
+---------------+-------------------------------------------------+
| ``DISK_TYPE`` | ``BLOCK``                                       |
+---------------+-------------------------------------------------+

An example template of Datastore:

.. code-block:: bash

    $ cat rdm.conf
    NAME      = rdm_datastore
    TYPE      = "IMAGE_DS"
    DS_MAD    = "dev"
    TM_MAD    = "dev"
    DISK_TYPE = "BLOCK"

    $ onedatastore create rdm.conf
    ID: 101

Datastore Usage
================================================================================

New images can be added as any other image specifying the path. As an example here is an image template to add a Node disk ``/dev/sdb``:

.. code-block:: bash

    $ cat image.tmpl
    NAME=scsi_device
    PATH=/dev/sdb
    PERSISTENT=YES

    $ oneimage create image.tmpl -d 101

If you are using the CLI shorthand parameters define the image using source:

.. prompt:: bash $ auto

    $ oneimage create -d 101 --name nbd --source /dev/sdc --driver raw --prefix vd --persistent --type OS --size 0MB

.. note:: As this Datastore is just a container for existing devices, images doesn't take any size from it. All devices registered will render size of 0 and the overall devices Datastore will show up with 1MB of available space
