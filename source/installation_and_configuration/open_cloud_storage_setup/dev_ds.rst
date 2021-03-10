.. _dev_ds:

================================================================================
Raw Device Mapping (RDM) Datastore
================================================================================

The RDM Datastore is an Image Datastore that enables raw access to node block devices. This datastore enables fast VM deployments due to a non-existent transfer operation from the image datastore to the system datastore.

.. warning:: The datastore should only be usable by the administrators. Letting users create images in this datastore will cause security problems. For example, register an image ``/dev/sda`` and reading the host filesystem.

Datastore Layout
================================================================================

The RDM Datastore is used to register already existent block devices in the nodes. The devices should be already setup and available and, VMs using these devices must be fixed to run in the nodes ready for them. Additional virtual machine files, like deployment files or volatile disks are created as regular files.

Frontend Setup
================================================================================

No addtional setup is required. Make sure **/etc/one/oned.conf** has the following configuration for the RDM datastore:

.. code-block:: bash

    TM_MAD_CONF = [
      NAME = "dev", LN_TARGET = "NONE", CLONE_TARGET = "NONE", SHARED = "YES",
      TM_MAD_SYSTEM = "ssh,shared", LN_TARGET_SSH = "SYSTEM", CLONE_TARGET_SSH = "SYSTEM",
      DISK_TYPE_SSH = "BLOCK", LN_TARGET_SHARED = "NONE",
      CLONE_TARGET_SHARED = "SELF", DISK_TYPE_SHARED = "BLOCK"
    ]

Node Setup
================================================================================

The devices you want to attach to a VM should be accessible by the hypervisor. As KVM usually runs as oneadmin, make sure this user is in a group with access to the disk (like disk) and has read write permissions for the group.

.. _dev_ds_templates:

OpenNebula Configuration
================================================================================
Once the storage is setup, the OpenNebula configuration comprises two steps:

* Create a System Datastore
* Create an Image Datastore

Create a System Datastore
--------------------------------------------------------------------------------

The RDM Datastore can work with the following System Datastores:

* Filesystem, shared transfer mode
* Filesystem, ssh transfer mode

Please refer to the :ref:`Filesystem Datastore section <fs_ds>` for more details. Note that the System Datastore is only used for volatile disks and context devices.

Create an Image Datastore
--------------------------------------------------------------------------------

To create an Image Datastore you just need to define the name, and set the following:

+---------------+-------------------------------------------------+
|   Attribute   |                   Description                   |
+===============+=================================================+
| ``NAME``      | The name of the datastore                       |
+---------------+-------------------------------------------------+
| ``TYPE``      | ``IMAGE_DS``                                    |
+---------------+-------------------------------------------------+
| ``DS_MAD``    | ``dev``                                         |
+---------------+-------------------------------------------------+
| ``TM_MAD``    | ``dev``                                         |
+---------------+-------------------------------------------------+
| ``DISK_TYPE`` | ``BLOCK``                                       |
+---------------+-------------------------------------------------+

An example of datastore:

.. code::

    > cat rdm.conf
    NAME      = rdm_datastore
    TYPE      = "IMAGE_DS"
    DS_MAD    = "dev"
    TM_MAD    = "dev"
    DISK_TYPE = "BLOCK"

    > onedatastore create rdm.conf
    ID: 101

Datastore Usage
================================================================================

New images can be added as any other image specifying the path.  As an example here is an image template to add a node disk ``/dev/sdb``:

.. code-block:: bash

    cat image.tmpl

    NAME=scsi_device
    PATH=/dev/sdb
    PERSISTENT=YES

    oneimage create image.tmpl -d 101

If you are using the CLI shorthand parameters define the image using source:

.. code-block:: bash

   oneimage create -d 101 --name nbd --source /dev/sdc --driver raw --prefix vd --persistent --type OS --size 0MB

.. note:: As this datastore does is just a container for existing devices images does not take any size from it. All devices registered will render size of 0 and the overall devices datastore will show up with 1MB of available space

