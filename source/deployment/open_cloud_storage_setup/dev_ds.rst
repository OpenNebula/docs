.. _dev_ds:

================================================================================
Raw Device Mapping (RDM) Datastore
================================================================================

The RDM Datastore is an Image Datastore that enables raw access to node block devices.

.. warning:: The datastore should only be usable by the administrators. Letting users create images in this datastore will cause security problems. For example, register an image ``/dev/sda`` and reading the host filesystem.

Datastore Layout
================================================================================

The RDM Datastore is used to register already existent block devices in the nodes. The devices should be already setup and available and, VMs using these devices must be fixed to run in the nodes ready for them. Additional virtual machine files, like deployment files or volatile disks are created as regular files.

Frontend Setup
================================================================================

No addtional setup is required.

Node Setup
================================================================================

The devices you want to attach to a VM should be accessible by the hypervisor. As KVM usually runs as oneadmin, make sure this user is in a group with access to the disk (like disk) and has read write permissions for the group.

OpenNebula Configuration
================================================================================

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

.. warning:: Images created in this datastore should be persistent. Making the images non persistent allows more than one VM use this device and will probably cause problems and data corruption.

Datastore Usage
================================================================================

New images can be added as any other image specifying the path. If you are using the CLI do not use the shorthand parameters as the CLI check if the file exists and the device most provably won't exist in the frontend. As an example here is an image template to add a node disk ``/dev/sdb``:

.. code:: bash

    NAME=scsi_device
    PATH=/dev/sdb
    PERSISTENT=YES

.. warning:: As this datastore does is just a container for existing devices images does not take any size from it. All devices registered will render size of 0 and the overall devices datastore will show up with 1MB of available space

