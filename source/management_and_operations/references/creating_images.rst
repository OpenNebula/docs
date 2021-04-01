.. _creating_images:
.. _os_install:

================================================================================
Creating Disk Images
================================================================================


You can use the images provided by the distributions as a basis for your images.
These images are usually prepared to be used with other clouds and won't behave correctly or won't have all the features provided by OpenNebula.
However, you can customize these images before importing them.

Using a GNU/Linux Host
================================================================================

To perform the image modification we'll use the `libguestfs <http://libguestfs.org/>`__ software running on a Linux machine with KVM support.
A modern distribution with a recent version of libguestfs (>= 1.26) should be used.

Step 1. Install Libguestfs
--------------------------------------------------------------------------------

The package is available in most distributions. Here are the commands to do it in some of them.

RHEL/CentOS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash # auto

    # yum install libguestfs-tools

Debian/Ubuntu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash # auto

    # apt-get install libguestfs-tools

Arch Linux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This package is available in `aur repository <https://aur.archlinux.org/packages/libguestfs/>`__. You can either download the ``PKGBUILD`` and compile it manually or use a pacman helper like `yaourt <https://archlinux.fr/yaourt-en>`__:

.. prompt:: bash # auto

    # yaourt -S libguestfs


Step 2. Download the Image
--------------------------------------------------------------------------------

You can find the images for distributions in these links. We are going to use the ones from CentOS but the others are here for reference:

* **CentOS**: https://cloud.centos.org/centos/
* **Debian**: https://cdimage.debian.org/cdimage/openstack/
* **Ubuntu**: https://cloud-images.ubuntu.com/
* **Amazon Linux**: https://cdn.amazonlinux.com/os-images/latest/kvm/
* **Oracle Linux**: https://yum.oracle.com/oracle-linux-templates.html

Step 3. Download Context Packages
--------------------------------------------------------------------------------

The context packages can be downloaded from the `release section of the project <https://github.com/OpenNebula/addon-context-linux/releases>`__.
Make sure you download the version you need. For example, for CentOS 8, download the corresponding `rpm` package (``one-context-<VERSION>.el8.noarch.rpm``).
Do not download the packages marked with `ec2` as they are specific for EC2 images.

You have to download them to a directory that we will later refer. For our example, we'll call it ``packages``.

.. prompt:: bash $ auto

    $ mkdir packages
    $ cd packages
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-1.el6.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-1.el7.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-1.el8.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-1.suse.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-alt1.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context_6.0.0-1.deb
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0-r1.apk
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v6.0.0/one-context-6.0.0_1.txz
    $ cd ..

Step 4. Create a CDROM Image with Context Packages
--------------------------------------------------------------------------------

The CDROM image (ISO) will be created with an specific label so later it is easier to mount it. The label chosen is ``PACKAGES``.


.. prompt:: bash $ auto

    $ genisoimage -o packages.iso -R -J -V PACKAGES packages/


Step 5. Guest OS Installation
--------------------------------------------------------------------------------

The script will be different depending on the distribution and the extra steps we want to perform in the image.
It will be executed in a *chroot* jail of the image root filesystem.

Here are some versions of the script for several distributions. The script name will be ``script.sh``.

CentOS 6
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    yum install -y epel-release

    # Remove NetworkManager
    yum remove -y NetworkManager

    # Upgrade util-linux
    yum upgrade -y util-linux

    # Install OpenNebula context package
    yum install -y /tmp/mount/one-context*el6*rpm

    # Take out the serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i --follow-symlinks '/^serial/d' /etc/grub.conf
    sed -i --follow-symlinks 's/console=ttyS[^ "]*//g' /etc/grub.conf

CentOS 7
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    yum install -y epel-release

    # Remove NetworkManager
    yum remove -y NetworkManager

    # Install OpenNebula context package
    yum install -y /tmp/mount/one-context*el7*rpm

    # Take out serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i --follow-symlinks 's/console=ttyS[^ "]*//g' /etc/default/grub /etc/grub2.cfg

CentOS 8
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    yum install -y epel-release

    # Remove NetworkManager
    yum remove -y NetworkManager

    # Install OpenNebula context package
    yum install -y /tmp/mount/one-context*el8*rpm
    systemctl enable network.service

    # Take out serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i --follow-symlinks 's/console=ttyS[^ "]*//g' /etc/default/grub /etc/grub2.cfg

Debian 8
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    apt-key update
    apt-get update

    # Remove cloud-init
    apt-get purge -y cloud-init

    # Install OpenNebula context package
    dpkg -i /tmp/mount/one-context*deb || apt-get install -fy

    # Take out serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i 's/console=ttyS[^ "]*//' /extlinux.conf /boot/extlinux/extlinux.conf


Debian 9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    apt-key update
    apt-get update

    # Remove cloud-init
    apt-get purge -y cloud-init

    # Install OpenNebula context package
    dpkg -i /tmp/mount/one-context*deb || apt-get install -fy

    # Take out serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i 's/console=ttyS[^ "]*//' /etc/default/grub /boot/grub/grub.cfg
    sed -i 's/earlyprintk=ttyS[^ "]*//' /etc/default/grub /boot/grub/grub.cfg


Ubuntu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    apt-key update
    apt-get update

    # Remove cloud-init
    apt-get remove -y cloud-init

    # Install OpenNebula context package
    dpkg -i /tmp/mount/one-context*deb || apt-get install -fy

    # Take out serial console from kernel configuration
    # (it can freeze during the boot process).
    sed -i 's/console=ttyS[^ "]*//g' /etc/default/grub /boot/grub/grub.cfg


Create an Overlay Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It's always a good idea to not modify the original image in case you want to use it again or something goes wrong with the process. To do it we can use ``qemu-img`` command:

.. prompt:: bash $ auto

    $ qemu-img create -f qcow2 -b <original image> modified.qcow2

Apply Customizations to the Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now we are going to execute ``virt-customize`` (a tool of libguestfs) to modify the image. This is the meaning of the parameters:

* ``-v``: verbose output, in case we want to debug problems
* ``--attach packages.iso``: add the CDROM image previously created with the packages
* ``--format qcow2``: the image format is qcow2
* ``-a modified.qcow2``: the disk image we want to modify
* ``--run script.sh``: script with the instructions to modify the image
* ``--root-password disabled``: delete root password. In case you want to set a password (for debugging) use ``--root-password password:the-new-root-password``

.. prompt:: bash $ auto

    $ virt-customize -v --attach packages.iso --format qcow2 -a modified.qcow2 --run script.sh --root-password disabled

Alternatively, you can force `start qemu directly <https://libguestfs.org/libguestfs-test-tool.1.html>`__ (instead of using *libvirt* as backend):

.. prompt:: bash $ auto

    $ LIBGUESTFS_BACKEND=direct virt-customize -v --attach packages.iso --format qcow2 -a modified.qcow2 --run script.sh --root-password disabled

Convert the Image to the Desired Format
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After we are happy with the result, we can convert the image to the preferred format to import to OpenNebula.
Even if we want a final ``qcow2`` image we need to convert it to consolidate all the layers in one file.
For example, to create a ``qcow2`` image that can be imported to *fs* (ssh, shared and qcow2), *ceph* and *fs_lvm* datastores we can execute this command:

.. prompt:: bash $ auto

    $ qemu-img convert -O qcow2 modified.qcow2 final.qcow2

If you want to create a ``vmdk`` image, for vCenter hypervisors, you can use this other command:

.. prompt:: bash $ auto

    $ qemu-img convert -O vmdk modified.qcow2 final.vmdk

Upload it to an OpenNebula Datastore
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can now use Sunstone to upload the final version of the image or copy it to the frontend and import it. If you are going to use the second option make sure that the image is in a directory that allows image imports (by default ``/var/tmp``). For example:

.. prompt:: bash $ auto

    $ oneimage create --name centos7 --path /var/tmp/final.qcow2 --prefix vd --datastore default

.. _add_content_install_withing_opennebula:

Using OpenNebula
================

If you are using KVM hypervisor you can create base images using OpenNebula.

Step 1. Add the Installation Medium
-----------------------------------

You can add the installation CD to OpenNebula by uploading the image using Sunstone and setting its type to CDROM or using the command line.
For example, to add the CentOS ISO file you can use this command:

.. prompt:: bash $ auto

    $ oneimage create --name centos7-install --path https://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-DVD-1910-01.iso --type CDROM --datastore default

Step 2. Create Installation Disk
--------------------------------

The disk where the OS will be installed needs to be created as a ``DATABLOCK``.
Don't make the image too big as it can be resized afterwards on VM instantiation.
Also make sure to make it persistent so we won't lose the disk changes when the Virtual Machine terminates.

|sunstone_datablock_create|

If you are using the CLI you can do the same with this command:

.. prompt:: bash $ auto

    $ oneimage create --name centos7 --description "Base CentOS 7 Installation" --type DATABLOCK --persistent --prefix vd --driver qcow2 --size 10240 --datastore default

Step 3. Create a Template to do the Installation
------------------------------------------------

You'll need to create a VM Template with the following caracteristics:

* In *Storage* tab, ``DISK 0`` disk will be the installation disk (future base image) created in step 2, and ``DISK 1`` Second disk will be the installation CD image created in step 1.
* In *Network* tab, attach ``NIC 0`` to a Virtual Network as it will be needed to download context packages.
* In *Boot* tab of *OS & CPU* tab, enable (check) both disks for booting.
  The boot order will be: first the installation media and second the installation disk.
* In *Input/Output* tab: enable VNC in *Graphics* and set ``Tablet`` ``USB`` in *Inputs*.
  This will be useful in case the OS has a graphical installation.

This can be done from the CLI as well using this command:

.. prompt:: bash $ auto

    $ onetemplate create --name centos7-cli --cpu 1 --memory 1G --disk centos7,centos7-install --nic network --boot disk0,disk1 --vnc --raw "INPUT=[TYPE=tablet,BUS=usb]"

Now, instantiate the recently created VM Template and do the guest OS installation using the VNC viewer.
You'll need to configure the network manually as there are no context packages in the installation media.
Upon completion, tell the instanter to reboot the machine, login to the guest OS and follow the :ref:`Open Cloud Contextualization <kvm_contextualization>` instructions.

As a tip, one of the latest things you should do when using this method is disabling ``root`` password and deleting any extra users created by the installation tools.

Step 4. Shutdown the Machine and Configure the Image
----------------------------------------------------

Now, you can shutdown the Virtual Machine from the guest OS. When the Vitual Machine appears as ``POWEROFF`` in OpenNebula, terminate it.

Make sure to change the attribute ``PERSISTENT`` of the installation disk image to ``NO`` and set access permissions for other users (optional).

Using the CLI you can do:

.. prompt:: bash $ auto

    $ oneimage nonpersistent centos7
    $ oneimage chmod centos7 744


.. _add_content_marketplace:

Using the OpenNebula Marketplace
================================

If you have access to the public OpenNebula Marketplace from your frontend, you'll find there images prepared to run in a OpenNebula Cloud.
To get images from the OpenNebula Marketplace:

* Go to the *Storage/Apps* tab in Sunstone
* Select one of the images displayed
* Click the *Download* button

|sunstone_marketplace_list_import|

Using the CLI, you can list an import images using these commands:

.. prompt:: text $ auto

	$ onemarketapp list
	  ID NAME                         VERSION  SIZE STAT TYPE  REGTIME MARKET               ZONE
	[...]
	  41 boot2docker                   1.10.2   32M  rdy  img 02/26/16 OpenNebula Public       0
	  42 alpine-vrouter (KVM)           1.0.3  256M  rdy  img 03/10/16 OpenNebula Public       0
	  43 alpine-vrouter (vcenter)         1.0  256M  rdy  img 03/10/16 OpenNebula Public       0
	  44 CoreOS alpha                1000.0.0  245M  rdy  img 04/03/16 OpenNebula Public       0
	  45 Devuan                      1.0 Beta    8M  rdy  img 05/03/16 OpenNebula Public       0
	$ onemarketapp export Devuan Devuan --datastore default
	IMAGE
		ID: 12
	VMTEMPLATE
		ID: -1

.. |sunstone_datablock_create| image:: /images/sunstone_datablock_create.png
.. |sunstone_marketplace_list_import| image:: /images/sunstone_marketplace_list_import.png
