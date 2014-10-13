.. _img_guide:

================
Managing Images
================

The :ref:`Storage system <sm>` allows OpenNebula administrators and users to set up images, which can be operative systems or data, to be used in Virtual Machines easily. These images can be used by several Virtual Machines simultaneously, and also shared with other users.

If you want to customize the Storage in your system, visit the :ref:`Storage subsystem guide <sm>`.

Image Types
===========

There are six different types of images. Using the command ``oneimage chtype``, you can change the type of an existing Image.

-  **OS**: An OS image contains a working operative system. Every :ref:`VM template <template>` must define one DISK referring to an image of this type.

-  **CDROM**: These images are readonly data. Only one image of this type can be used in each :ref:`VM template <template>`. These type of images are not cloned when using shared storage.

-  **DATABLOCK**: A datablock image is a storage for data, which can be accessed and modified from different Virtual Machines. These images can be created from previous existing data, or as an empty drive.

-  **KERNEL**: A plain file to be used as kernel (VM attribute OS/KERNEL\_DS). Note that KERNEL file images can be registered only in File Datastores.

-  **RAMDISK**: A plain file to be used as ramdisk (VM attribute OS/INITRD\_DS). Note that RAMDISK file images can be registered only in File Datastores.

-  **CONTEXT**: A plain file to be included in the context CD-ROM (VM attribute CONTEXT/FILES\_DS). Note that CONTEXT file images can be registered only in File Datastores.

The Virtual Machines can use as many datablocks as needed. Refer to the :ref:`VM template <template>` documentation for further information.

.. warning:: Note that some of the operations described below do not apply to KERNEL, RAMDISK and CONTEXT images, in particular: clone and persistent.

Image Life-cycle
================

+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| Short state   | State           | Meaning                                                                                                          |
+===============+=================+==================================================================================================================+
| ``lock``      | ``LOCKED``      | The image file is being copied or created in the Datastore.                                                      |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``rdy``       | ``READY``       | Image ready to be used.                                                                                          |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``used``      | ``USED``        | Non-persistent Image used by at least one VM. It can still be used by other VMs.                                 |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``used``      | ``USED_PERS``   | Persistent Image is use by a VM. It cannot be used by new VMs.                                                   |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``disa``      | ``DISABLED``    | Image disabled by the owner, it cannot be used by new VMs.                                                       |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``err``       | ``ERROR``       | Error state, a FS operation failed. See the Image information with ``oneimage show`` for an error message.       |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+
| ``dele``      | ``DELETE``      | The image is being deleted from the Datastore.                                                                   |
+---------------+-----------------+------------------------------------------------------------------------------------------------------------------+

This is the state diagram for **persistent** images:

|Persistent Image States|

And the following one is the state diagram for **non-persistent** images:

|Non-Persistent Image States|

Managing Images
===============

Users can manage their images using the command line interface command ``oneimage``. The complete reference is :ref:`here <cli>`.

You can also manage your images using :ref:`Sunstone <sunstone>`. Select the Images tab, and there you will be able to create, enable, disable, delete your images and even manage their persistence and publicity in a user friendly way. From Sunstone 3.4, you can also upload images directly from the web UI.

|image3|

Create Images
-------------

.. warning:: For VMWare images, please read **also** the :ref:`VMware Drivers guide <evmwareg_usage>`.

The three types of images can be created from an existing file, but for **datablock** images you can specify a size and filesystem type and let OpenNebula create an empty image in the datastore.

If you want to create an **OS image**, you need to prepare a contextualized virtual machine, and extract its disk.

Please read first the documentation about the MAC to IP mechanism in the :ref:`virtual network management documentation <vgg>`, and how to use contextualization :ref:`here <cong>`.

Once you have a disk you want to upload, you need to create a new :ref:`image template <img_template>`, and submit it using the ``oneimage create`` command.

The complete reference for the image template is :ref:`here <img_template>`. This is how a sample template looks like:

.. code::

    $ cat ubuntu_img.one
    NAME          = "Ubuntu"
    PATH          = /home/cloud/images/ubuntu-desktop/disk.0
    TYPE          = OS
    DESCRIPTION   = "Ubuntu 10.04 desktop for students."

You need to choose the Datastore where to register the new Image. To know the available datastores, use the ``onedatastore list`` command. In this case, only the 'default' one is listed:

.. code::

    $ onedatastore list
      ID NAME            CLUSTER  IMAGES TYPE   TM
       1 default         -        1      fs     shared

To submit the template, you just have to issue the command

.. code::

    $ oneimage create ubuntu_img.one --datastore default
    ID: 0

You can also create images using just parameters in the ``oneimage create`` call. The parameters to generate the image are as follows:

+--------------------------------+---------------------------------------------------------------------------------------+
| Parameter                      | Description                                                                           |
+================================+=======================================================================================+
| ``-name name``                 | Name of the new image                                                                 |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-description description``   | Description for the new Image                                                         |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-type type``                 | Type of the new Image: OS, CDROM or DATABLOCK, FILE                                   |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-persistent``                | Tells if the image will be persistent                                                 |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-prefix prefix``             | Device prefix for the disk (eg. hd, sd, xvd or vd)                                    |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-target target``             | Device the disk will be attached to                                                   |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-path path``                 | Path of the image file                                                                |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-driver driver``             | Driver to use image (raw, qcow2, tap:aio:...)                                         |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-disk_type disk_type``       | Type of the image (BLOCK, CDROM or FILE)                                              |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-source source``             | Source to be used. Useful for not file-based images                                   |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-size size``                 | Size in MB. Used for DATABLOCK type                                                   |
+--------------------------------+---------------------------------------------------------------------------------------+
| ``-fstype fstype``             | Type of file system to be built: ext2, ext3, ext4, ntfs, reiserfs, jfs, swap, qcow2   |
+--------------------------------+---------------------------------------------------------------------------------------+

To create the previous example image you can do it like this:

.. code::

    $ oneimage create --datastore default --name Ubuntu --path /home/cloud/images/ubuntu-desktop/disk.0 \
      --description "Ubuntu 10.04 desktop for students."

.. warning:: You can use **gz** compressed image files (i.e. as specified in path) when registering them in OpenNebula.

.. _sunstone_upload_images:

Uploading Images from Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Image file upload to the server via the client browser is possible with the help of a vendor library. The process is as follow:

-  Step 1: The client uploads the whole image to the server in a temporal file in the ``tpmdir`` folder specified in the configuration.
-  Step 2: OpenNebula registers an image setting the PATH to that temporal file.
-  Step 3: OpenNebula copies the images to the datastore.
-  Step 4: The temporal file is deleted and the request returns successfully to the user (a message pops up indicating that image was uploaded correctly).

Note that when file sizes become big (normally over 1GB), and depending on your hardware, it may take long to complete the copying in step 3. Since the upload request needs to stay pending until copying is sucessful (so it can delete the temp file safely), there might be Ajax timeouts and/or lack of response from the server. This may cause errors, or trigger re-uploads (which reinitiate the loading progress bar).

As of Firefox 11 and previous versions, uploads seem to be limited to 2GB. Chrome seems to work well with images > 4 GB.

Clone Images
------------

Existing images can be cloned to a new one. This is useful to make a backup of an Image before you modify it, or to get a private persistent copy of an image shared by other user.

To clone an image, execute

.. code::

    $ oneimage clone Ubuntu new_image

You can optionally clone the Image to a different Datastore. The new Datastore must be compatible with the current one, i.e. have the same :ref:`DS_MAD drivers <sm>`.

.. code::

    $ oneimage clone Ubuntu new_image --datastore new_img_ds

Listing Available Images
------------------------

You can use the ``oneimage list`` command to check the available images in the repository.

.. code::

    $ oneimage list
      ID USER     GROUP    NAME         DATASTORE     SIZE TYPE PER STAT  RVMS
       0 oneuser1 users    Ubuntu       default         8M   OS  No  rdy     0

To get complete information about an image, use ``oneimage show``, or list images continuously with ``oneimage top``.

Publishing Images
-----------------

The users can share their images with other users in their group, or with all the users in OpenNebula. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Let's see a quick example. To share the image 0 with users in the group, the **USE** right bit for **GROUP** must be set with the **chmod** command:

.. code::

    $ oneimage show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    $ oneimage chmod 0 640

    $ oneimage show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

The following command allows users in the same group **USE** and **MANAGE** the image, and the rest of the users **USE** it:

.. code::

    $ oneimage chmod 0 664

    $ oneimage show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

The commands ``oneimage publish`` and ``oneimage unpublish`` are still present for compatibility with previous versions. These commands set/unset the GROUP USE bit.

.. _img_guide_persistent:

Making Images Persistent
------------------------

Use the ``oneimage persistent`` and ``oneimage nonpersistent`` commands to make your images persistent or not.

A persistent image saves back to the datastore the changes made inside the VM after it is shut down. More specifically, the changes are correctly preserved only if the VM is ended with the ``onevm shutdown`` or ``onevm shutdown --hard`` commands. Note that depending on the Datastore type a persistent image can be a link to the original image, so any modification is directly made on the image.

.. code::

    $ oneimage list
      ID USER     GROUP    NAME         DATASTORE     SIZE TYPE PER STAT  RVMS
       0 oneadmin oneadmin Ubuntu       default        10G   OS  No  rdy     0
    $ oneimage persistent Ubuntu
    $ oneimage list
      ID USER     GROUP    NAME         DATASTORE     SIZE TYPE PER STAT  RVMS
       0 oneadmin oneadmin Ubuntu       default        10G   OS Yes  rdy     0
    $ oneimage nonpersistent 0
    $ oneimage list
      ID USER     GROUP    NAME         DATASTORE     SIZE TYPE PER STAT  RVMS
       0 oneadmin oneadmin Ubuntu       default        10G   OS  No  rdy     0

.. warning:: When images are public (GROUP or OTHER USE bit set) they are always cloned, and persistent images are never cloned. Therefore, an image cannot be public and persistent at the same time. To manage a public image that won't be cloned, unpublish it first and make it persistent.

How to Use Images in Virtual Machines
=====================================

This a simple example on how to specify images as virtual machine disks. Please visit the :ref:`virtual machine user guide <vm_guide>` and the :ref:`virtual machine template <template>` documentation for a more thorough explanation.

Assuming you have an OS image called *Ubuntu desktop* with ID 1, you can use it in your :ref:`virtual machine template <template>` as a DISK. When this machine is deployed, the first disk will be taken from the image repository.

Images can be referred in a DISK in two different ways:

-  IMAGE\_ID, using its ID as returned by the create operation

-  IMAGE, using its name. In this case the name refers to one of the images owned by the user (names can not be repeated for the same user). If you want to refer to an IMAGE of other user you can specify that with IMAGE\_UID (by the uid of the user) or IMAGE\_UNAME (by the name of the user).

.. code::

    CPU    = 1
    MEMORY = 3.08

    DISK = [ IMAGE_ID   = 1 ]

    DISK = [ type   = swap,
             size   = 1024  ]

    NIC    = [ NETWORK_ID = 1 ]
    NIC    = [ NETWORK_ID = 0 ]

    # FEATURES=[ acpi="no" ]

    GRAPHICS = [
      type    = "vnc",
      listen  = "1.2.3.4",
      port    = "5902"  ]


    CONTEXT = [
        files      = "/home/cloud/images/ubuntu-desktop/init.sh"  ]

.. _img_guide_save_changes:

Save Changes
------------

Once the VM is deployed you can snapshot a disk, i.e. save the changes made to the disk as a new image. There are two types of disk snapshots in OpenNebula:

-  **Deferred snapshots** (disk-snapshot), changes to a disk will be saved as a new Image in the associated datastore when the VM is shutdown.
-  **Hot snapshots** (hot disk-snapshot), just as the deferred snapshots, but the disk is copied to the datastore the moment the operation is triggered. Therefore, you must guarantee that the disk is in a consistent state during the save\_as operation (e.g. by umounting the disk from the VM).

To save a disk, use the ``onevm disk-snapshot`` command. This command takes three arguments: The VM name (or ID), the disk ID to save and the name of the new image to register. And optionally the --live argument to not defer the disk-snapshot operation.

To know the ID of the disk you want to save, just take a look at the ``onevm show`` output for your VM, you are interested in the ID column in the VM DISK section.

.. code::

    $ onevm show 11
    VIRTUAL MACHINE 11 INFORMATION
    ID                  : 11
    NAME                : ttylinux-11
    USER                : ruben
    GROUP               : oneadmin
    STATE               : PENDING
    LCM_STATE           : LCM_INIT
    RESCHED             : No
    START TIME          : 03/08 22:24:57
    END TIME            : -
    DEPLOY ID           : -

    VIRTUAL MACHINE MONITORING
    USED MEMORY         : 0K
    USED CPU            : 0
    NET_TX              : 0K
    NET_RX              : 0K

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    VM DISKS
     ID TARGET IMAGE                               TYPE SAVE SAVE_AS
      0    hda ttylinux                            file   NO       -
      1    hdb raw - 100M                          fs     NO       -

    VM NICS
    ID NETWORK      VLAN BRIDGE   IP              MAC
     0 net_172        no vbr0     172.16.0.201    02:00:ac:10:00:c9
                                  fe80::400:acff:fe10:c9

    VIRTUAL MACHINE TEMPLATE
    CPU="1"
    GRAPHICS=[
      LISTEN="0.0.0.0",
      PORT="5911",
      TYPE="vnc" ]
    MEMORY="512"
    OS=[
      ARCH="x86_64" ]
    TEMPLATE_ID="0"
    VCPU="1"

The IDs are assigned in the same order the disks were defined in the :ref:`VM template <template>`.

The next command will register a new image called *SO upgrade*, that will be ready as soon as the VM is shut down. Till then the image will be locked, and so you cannot use it.

.. code::

    $ onevm disk-snapshot ttylinux-11 0 "SO upgraded"

This command copies disk 1 to the datastore with name *Backup of DB volume*, the image will be available once the image copy end:

.. code::

    $ onevm disk-snapshot --live ttylinux-11 1 "Backup of DB volume"

.. _img_guide_files:

How to Use File Images in Virtual Machines
==========================================

.. _img_guide_kernel_and_ramdisk:

KERNEL and RAMDISK
------------------

KERNEL and RAMDISK type Images can be used in the OS/KERNEL\_DS and OS/INITRD\_DS attributes of the VM template. See the :ref:`complete reference <template_os_and_boot_options_section>` for more information.

Example:

.. code::

    OS = [ KERNEL_DS  = "$FILE[IMAGE=kernel3.6]",
           INITRD_DS  = "$FILE[IMAGE_ID=23]",
           ROOT       = "sda1",
           KERNEL_CMD = "ro xencons=tty console=tty1" ]

CONTEXT
-------

The :ref:`contextualization cdrom <context_overview>` can include CONTEXT type Images. Visit the :ref:`complete reference <template_context>` for more information.

.. code::

    CONTEXT = [
      FILES_DS   = "$FILE[IMAGE_ID=34] $FILE[IMAGE=kernel]",
    ]

.. |Persistent Image States| image:: /images/image-persistent.png
.. |Non-Persistent Image States| image:: /images/image-nonpersistent.png
.. |image3| image:: /images/sunstone_image_create.png
