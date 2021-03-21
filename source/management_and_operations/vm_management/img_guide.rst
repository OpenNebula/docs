.. _img_guide:

================
Managing Images
================

The :ref:`Storage system <sm>` allows OpenNebula administrators and users to set up Images, which can be operating systems or data, to be used in Virtual Machines easily. These Images can be used by several Virtual Machines simultaneously, and also shared with other users.

If you want to customize the Storage in your system, visit the :ref:`Storage subsystem documentation <sm>`.

Image Types
===========

There are six different types of Images. Using the command ``oneimage chtype``, you can change the type of an existing Image.

For Virtual Machine disks:

* ``OS``: An bootable disk Image. Every :ref:`VM template <template>` must define one DISK referring to an Image of this type.
* ``CDROM``: These Images are read-only data. Only one Image of this type can be used in each :ref:`VM template <template>`.
* ``DATABLOCK``: A datablock Image is a storage for data. These Images can be created from previous existing data, or as an empty drive.

"File" types. Images of these types cannot be used as VM disks, and are listed in Sunstone under the Files tab:

* ``KERNEL``: A plain file to be used as kernel (VM attribute OS/KERNEL\_DS).
* ``RAMDISK``: A plain file to be used as ramdisk (VM attribute OS/INITRD\_DS).
* ``CONTEXT``: A plain file to be included in the context CD-ROM (VM attribute CONTEXT/FILES\_DS).

.. note:: KERNEL, RAMDISK and CONTEXT file Images can be registered only in File Datastores.

.. note:: Some of the operations described below do not apply to KERNEL, RAMDISK and CONTEXT Images, in particular: clone and persistent.

.. _img_life_cycle_and_states:

Image Life-cycle
================

+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| Short state |        State         |                                                  Meaning                                                   |
+=============+======================+============================================================================================================+
| ``lock``    | ``LOCKED``           | The Image file is being copied or created in the Datastore.                                                |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``lock``    | ``LOCKED_USED``      | Image file is being copied or created in the Datastore, with VMs waiting for the operation to finish.      |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``lock``    | ``LOCKED_USED_PERS`` | Same as ``LOCKED_USED``, for Persistent Images                                                             |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``rdy``     | ``READY``            | Image ready to be used.                                                                                    |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``used``    | ``USED``             | Non-persistent Image used by at least one VM. It can still be used by other VMs.                           |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``used``    | ``USED_PERS``        | Persistent Image is use by a VM. It cannot be used by new VMs.                                             |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``disa``    | ``DISABLED``         | Image disabled by the owner, it cannot be used by new VMs.                                                 |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``err``     | ``ERROR``            | Error state, a FS operation failed. See the Image information with ``oneimage show`` for an error message. |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``dele``    | ``DELETE``           | The Image is being deleted from the Datastore.                                                             |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+
| ``clon``    | ``CLONE``            | The Image is being cloned.                                                                                 |
+-------------+----------------------+------------------------------------------------------------------------------------------------------------+

This is the state diagram for **persistent** Images:

|Persistent Image States|

And the following one is the state diagram for **non-persistent** Images:

|Non-Persistent Image States|

Managing Images
===============

Users can manage their Images using the command line interface command ``oneimage``. The complete reference is :ref:`here <cli>`.

You can also manage your Images using Sunstone, selecting the Images tab. By default this tab is available in the ``admin`` view, but not in the ``cloud`` or ``groupadmin`` views.

Create Images
-------------

The three types of Images can be created from an existing file, but for **datablock** Images you can specify a size and let OpenNebula create an empty Image in the Datastore.

If you want to create an **OS Image**, you need to prepare a contextualized virtual machine, and extract its disk.

Please read first the documentation about :ref:`VM contextualization here <context_overview>`.

Once you have a disk you want to register, you can upload it directly using Sunstone:

|image3|

To register it from the command line you need to create a new :ref:`image template <img_template>`, and submit it using the ``oneimage create`` command.

The complete reference for the image template is :ref:`here <img_template>`. This is how a sample template looks like:

.. prompt:: text $ auto

    $ cat ubuntu_img.one
    NAME          = "Ubuntu"
    PATH          = "/home/cloud/images/ubuntu-desktop/disk.0"
    TYPE          = "OS"
    DESCRIPTION   = "Ubuntu desktop for students."

You need to choose the Datastore where to register the new Image. To know the available datastores, use the ``onedatastore list`` command. In a clean installation you will only have one datastores with type ``img``, default.

.. prompt:: text $ auto

    $ onedatastore list
      ID NAME                SIZE AVAIL CLUSTERS     IMAGES TYPE DS      TM      STAT
       0 system            145.2G 56%   0                 0 sys  -       shared  on
       1 default           145.2G 56%   0                 3 img  fs      shared  on
       2 files             145.2G 56%   0                 0 fil  fs      ssh     on


To submit the template, you just have to issue the command

.. prompt:: text $ auto

    $ oneimage create ubuntu_img.one --datastore default
    ID: 0

You can also create Images using just parameters in the ``oneimage create`` call. The parameters to generate the Image are as follows:

+-------------------------------+-----------------------------------------------------------------------+
|           Parameter           |                              Description                              |
+===============================+=======================================================================+
| ``--name name``               | Name of the new Image                                                 |
+-------------------------------+-----------------------------------------------------------------------+
| ``--description description`` | Description for the new Image                                         |
+-------------------------------+-----------------------------------------------------------------------+
| ``--type type``               | Type of the new Image: OS, CDROM, DATABLOCK, KERNEL, RAMDISK, CONTEXT |
+-------------------------------+-----------------------------------------------------------------------+
| ``--persistent``              | Tells if the Image will be persistent                                 |
+-------------------------------+-----------------------------------------------------------------------+
| ``--prefix prefix``           | Device prefix for the disk (eg. hd, sd, xvd or vd)                    |
+-------------------------------+-----------------------------------------------------------------------+
| ``--target target``           | Device the disk will be attached to                                   |
+-------------------------------+-----------------------------------------------------------------------+
| ``--path path``               | Path of the Image file                                                |
+-------------------------------+-----------------------------------------------------------------------+
| ``--driver driver``           | Driver to use (raw, qcow2, tap:aio:...)                               |
+-------------------------------+-----------------------------------------------------------------------+
| ``--disk_type disk_type``     | Type of the Image (BLOCK, CDROM or FILE)                              |
+-------------------------------+-----------------------------------------------------------------------+
| ``--source source``           | Source to be used. Useful for not file-based Images                   |
+-------------------------------+-----------------------------------------------------------------------+
| ``--size size``               | Size in MB. Used for DATABLOCK type                                   |
+-------------------------------+-----------------------------------------------------------------------+

To create the previous example Image you can do it like this:

.. prompt:: text $ auto

    $ oneimage create --datastore default --name Ubuntu --path /home/cloud/images/ubuntu-desktop/disk.0 \
      --description "Ubuntu desktop for students."

.. note:: You can use **gz** compressed image files when registering them in OpenNebula.

.. _sunstone_upload_images:


Creating LUKS encrypted images (KVM)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For KVM hypervisor you can use LUKS-encrypted raw images. First you need to create an encrypted
volume using:

.. prompt:: text $ auto

    $ qemu-img create --object secret,id=sec0,data=secret-passphrase -o key-secret=sec0 -f luks /tmp/luks.vol 10G

Then import the image to the OpenNebula datastore as usual:

.. prompt:: text $ auto

    $ oneimage create --name luks-image --path /tmp/luks.vol -d default

Finally you need to do is to define the secret in the libvirt, prepare a secret.xml file

.. prompt:: text $ auto

    $ uuidgen
    a94c5c16-d936-4346-89ad-7067517f411a

.. prompt:: text $ auto

    $ cat secret.xml
    <secret ephemeral='no' private='yes'>
          <uuid>a94c5c16-d936-4346-89ad-7067517f411a</uuid>
          <description>luks key</description>
    </secret>

and define the secret and set its value, beware it's base64 encoded. **This has to be done on every hypervisor**

.. prompt:: text $ auto

    $ virsh -c qemu:///system secret-define secret.xml

    $ virsh -c qemu:///system secret-set-value a94c5c16-d936-4346-89ad-7067517f411a "$(echo secret-passphrase | base64)"

Now you can use the image as usual.

Limitations when Uploading Images from Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Image file upload to the server via the client browser is possible. The process is as follow:

-  Step 1: The client uploads the whole image file to the server in a temporal file in the ``tmpdir`` folder specified in the configuration.
-  Step 2: OpenNebula registers an Image setting the PATH to that temporal file.
-  Step 3: OpenNebula copies the image file to the datastore.
-  Step 4: The temporal file is deleted and the request returns successfully to the user (a message pops up indicating that Image was uploaded correctly).

Note that when file sizes become big (normally over 1GB), and depending on your hardware, it may take long to complete the copying in step 3. Since the upload request needs to stay pending until copying is successful (so it can delete the temp file safely), there might be Ajax timeouts and/or lack of response from the server. This may cause errors, or trigger re-uploads (which re-initiate the loading progress bar).

Clone Images
------------

Existing Images can be cloned to a new one. This is useful to make a backup of an Image before you modify it, or to get a private persistent copy of an Image shared by other user. Note that persistent Images with snapshots cannot be cloned. In order to do so, the user would need to flatten it first, see the :ref:`snapshots <img_guide_snapshots>` section for more information.

To clone an Image, execute

.. prompt:: text $ auto

    $ oneimage clone Ubuntu new_image

You can optionally clone the Image to a different Datastore. The new Datastore must be compatible with the current one, i.e. have the same :ref:`DS_MAD drivers <sm>`.

.. prompt:: text $ auto

    $ oneimage clone Ubuntu new_image --datastore new_img_ds

The Sunstone Images tab also contains a dialog for the clone operation:

|sunstone_image_clone|

Listing Available Images
------------------------

You can use the ``oneimage list`` command to check the available images in the repository.

.. prompt:: text $ auto

    $ oneimage list
      ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
       0 oneadmin   oneadmin   ttylinux-vd     default       200M OS    No used    8
       1 johndoe    users      my-ubuntu-disk- default       200M OS   Yes used    1
       2 alice      testgroup  customized-ubun default       200M OS   Yes used    1

To get complete information about an Image, use ``oneimage show``, or list Images continuously with ``oneimage top``.

.. note:: Orphan images (i.e images not referenced by any template) can be shown with ``oneimage orphans`` command.

Sharing Images
-----------------

The users can share their Images with other users in their group, or with all the users in OpenNebula. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Let's see a quick example. To share the Image 0 with users in the group, the **USE** right bit for **GROUP** must be set with the **chmod** command:

.. prompt:: text $ auto

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

The following command allows users in the same group **USE** and **MANAGE** the Image, and the rest of the users **USE** it:

.. prompt:: text $ auto

    $ oneimage chmod 0 664

    $ oneimage show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

.. _img_guide_persistent:

Making Images Persistent
------------------------

Use the ``oneimage persistent`` and ``oneimage nonpersistent`` commands to make your Images persistent or not.

A persistent Image saves back to the datastore the changes made inside the VM after it is shut down.

.. prompt:: text $ auto

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

Note that persistent Images with snapshots cannot be made non-persistent. In order to do so, the user would need to flatten it first, see the :ref:`snapshots <img_guide_snapshots>` section for more information.

.. _img_guide_snapshots:

Managing Snapshots in Persistent Images
---------------------------------------

Persistent Images can have associated snapshots if the user :ref:`created them <vm_guide_2_disk_snapshots_managing>` during the life-cycle of VM that used the persistent Image. The following are operations that allow the user to manage these snapshots directly:


* ``oneimage snapshot-revert <image_id> <snapshot_id>``: The active state of the Image is overwritten by the specified snapshot. Note that this operation discards any unsaved data of the disk state.
* ``oneimage snapshot-delete <image_id> <snapshot_id>``: Deletes a snapshot. This operation is only allowed if the snapshot is not the active snapshot and if it has no children.
* ``oneimage snapshot-flatten <image_id> <snapshot_id>``: This operation effectively converts the Image to an Image without snapshots. The saved disk state of the Image is the state of the specified snapshot. It's an operation similar to running ``snapshot-revert`` and then deleting all the snapshots.

Images with snapshots **cannot** be cloned or made non-persistent. To run either of these operations the user would need to flatten the Image first.

How to Use Images in Virtual Machines
=====================================

This is a simple example on how to specify Images as virtual machine disks. Please visit the :ref:`virtual machine user guide <vm_guide>` and the :ref:`virtual machine template <template>` documentation for a more thorough explanation.

Assuming you have an OS Image called *Ubuntu desktop* with ID 1, you can use it in your :ref:`virtual machine template <template>` as a DISK. When this machine is deployed, the first disk will be taken from the Datastore.

Images can be referred in a DISK in two different ways:

* ``IMAGE_ID``, using its ID as returned by the create operation
* ``IMAGE``, using its name. In this case the name refers to one of the Images owned by the user (names can not be repeated for the same user). If you want to refer to an IMAGE of other user you can specify that with ``IMAGE_UID`` (by the uid of the user) or ``IMAGE_UNAME`` (by the name of the user).

.. code-block:: none

    CPU    = 1
    MEMORY = 3.08

    DISK = [ IMAGE_ID   = 7 ]

    DISK = [ IMAGE       = "Ubuntu",
             IMAGE_UNAME = "oneadmin" ]

    DISK = [ type   = swap,
             size   = 1024  ]

    NIC    = [ NETWORK_ID = 1 ]
    NIC    = [ NETWORK_ID = 0 ]

    # FEATURES=[ acpi="no" ]

    GRAPHICS = [
      type    = "vnc",
      listen  = "1.2.3.4",
      port    = "5902"  ]


.. _img_guide_save_changes:

Save Changes
------------

Once the VM is deployed and changes are made to its disk, you can save those changes in two different ways:

* **Disk snapshots**, a snapshot of the disk state is saved, you can later revert to this saved state.
* **Disk save\_as**, the disk is copied to a new Image in the datastore. A new virtual machine can be started from it. The disk must be in a consistent state during the save\_as operation (e.g. by unmounting the disk from the VM).

A detailed description of this process is :ref:`described in section Virtual Machine Instances <vm_guide_2_disk_snapshots>`

.. _img_guide_files:

How to Use File Images in Virtual Machines
==========================================

.. _img_guide_kernel_and_ramdisk:

KERNEL and RAMDISK
------------------

KERNEL and RAMDISK type Images can be used in the OS/KERNEL_DS and OS/INITRD_DS attributes of the VM template. See the :ref:`complete reference <template_os_and_boot_options_section>` for more information.

Example:

.. code-block:: none

    OS = [ KERNEL_DS  = "$FILE[IMAGE=kernel3.6]",
           INITRD_DS  = "$FILE[IMAGE_ID=23]",
           ROOT       = "sda1",
           KERNEL_CMD = "ro console=tty1" ]

CONTEXT
-------

The :ref:`contextualization cdrom <context_overview>` can include CONTEXT type Images. Visit the :ref:`complete reference <template_context>` for more information.

.. code-block:: none

    CONTEXT = [
      FILES_DS   = "$FILE[IMAGE_ID=34] $FILE[IMAGE=kernel]",
    ]

.. |Persistent Image States| image:: /images/image-persistent.png
.. |Non-Persistent Image States| image:: /images/image-nonpersistent.png
.. |image3| image:: /images/sunstone_image_create.png
.. |sunstone_image_clone| image:: /images/sunstone_image_clone.png
