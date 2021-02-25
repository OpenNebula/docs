.. _add_content:

================================================================================
Adding Content to Your Cloud
================================================================================
Once you have setup your OpenNebula cloud you'll have ready the infrastructure
(clusters, hosts, virtual networks and datastores) but you need to add contents
to it for your users. This basically means two different things:

-  Add base disk images with OS installations of your choice. Including any software package of interest.
-  Define virtual servers in the form of VM Templates. We recommend that VM definitions are made by the admins as it may require fine or advanced tuning. For example you may want to define a LAMP server with the capacity to be instantiated in a remote AWS cloud.

When you have basic virtual server definitions the users of your cloud can use them to easily provision VMs, adjusting basic parameters, like capacity or network connectivity.

There are three basic methods to bootstrap the contents of your cloud, namely:

* **External Images**. If you already have disk images in any supported format (raw, qcow2, vmdk...) you can just add them to a datastore. Alternatively you can use any virtualization tool (e.g. virt-manager) to install an image and then add it to a OpenNebula datastore.
* **Install within OpenNebula**. You can also use OpenNebula to prepare the images for your cloud.
* **Use the OpenNebula Marketplace**. Go to the marketplace tab in Sunstone, and simply pick a disk image with the OS and Hypervisor of your choice.

Once the images are ready, just create VM templates with the relevant configuration attributes, including default capacity, networking or any other preset needed by your infrastructure.

You are done, make sure that your cloud users can access the images and templates you have just created.


.. _add_content_external_images:

Adding External Images
======================

You can use as basis for your images the ones provided by the distributions. These images are usually prepared to be used with other clouds and won't behave correctly or will not have all the features provided by OpenNebula. You can do a customization of these images before importing them.

To do this modification we are going to use the software `libguestfs <http://libguestfs.org/>`__ in a Linux machine with kvm support. You should use a modern distribution to have a recent version of libguestfs (>= 1.26). To have the latest version you can use Arch Linux but a CentOS 7 is OK.

Step 1. Install Libguestfs
--------------------------

The package is available in most distributions. Here are the commands to do it in some of them.

CentOS
~~~~~~

.. prompt:: bash # auto

    # yum install libguestfs-tools

Debian/Ubuntu
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # apt-get install libguestfs-tools

Arch Linux
~~~~~~~~~~

This package is available in `aur repository <https://aur.archlinux.org/packages/libguestfs/>`__. You can either download the ``PKGBUILD`` and compile it manually or use a pacman helper like `yaourt <https://archlinux.fr/yaourt-en>`__:

.. prompt:: bash # auto

    # yaourt -S libguestfs


Step 2. Download the Image
--------------------------

You can find the images for distributions in these links. We are going to use the ones from CentOS but the others are here for reference:

* **CentOS 7**: http://cloud.centos.org/centos/7/images/
* **Debian**: http://cdimage.debian.org/cdimage/openstack/
* **Ubuntu**: https://cloud-images.ubuntu.com/

Step 3. Download Context Packages
---------------------------------

The context packages can be downloaded from the `release section of the project <https://github.com/OpenNebula/addon-context-linux/releases>`__. Make sure you download the version you need. For example, for CentOS download the `rpm` version. Also, don't download the packages marked with `ec2` as they are specific for EC2 images.

You have to download them to a directory that we will later refer. In this example it's going to be called ``packages``.

.. prompt:: bash $ auto

    $ mkdir packages
    $ cd packages
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-1.el6.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-1.el7.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-1.el8.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-1.suse.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-alt1.noarch.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context_5.12.0.2-1.deb
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2-r1.apk
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v5.12.0.2/one-context-5.12.0.2_1.txz
    $ cd ..


Step 4. Create a CDROM Image with Context Packages
--------------------------------------------------

We will use this image as the source to install the context package. The image will be created with an specific label so later is easier to mount it. The label chosen is ``PACKAGES``.


.. prompt:: bash $ auto

    $ genisoimage -o packages.iso -R -J -V PACKAGES packages/


Step 5. Create a Script to Prepare the Image
--------------------------------------------

The script will be different depending on the distribution and any extra steps we want to do to the image. The script will be executed in a chroot of the image root filesystem.

Here are some versions of the script for several distributions. The script will be called ``script.sh``.

CentOS 6
~~~~~~~~

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
~~~~~~~~

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

Debian 8
~~~~~~~~

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
~~~~~~~~

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


Ubuntu 14.04, 16.04
~~~~~~~~~~~~~~~~~~~

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


Step 6. Create an Overlay Image
-------------------------------

It's always a good idea to not modify the original image in case you want to use it again or something goes wrong with the process. To do it we can use ``qemu-img`` command:

.. prompt:: bash $ auto

    $ qemu-img create -f qcow2 -b <original image> modified.qcow2

Step 7. Apply Customizations to the Image
-----------------------------------------

Now we are going to execute ``virt-customize`` (a tool of libguestfs) to modify the image. This is the meaning of the parameters:

* ``-v``: verbose output, in case we want to debug problems
* ``--attach packages.iso``: add the CDROM image previously created with the packages
* ``--format qcow2``: the image format is qcow2
* ``-a modified.qcow2``: the disk image we want to modify
* ``--run script.sh``: script with the instructions to modify the image
* ``--root-password disabled``: deletes root password. In case you want to set a password (for debugging) use ``--root-password password:the-new-root-password``

.. prompt:: bash $ auto

    $ virt-customize -v --attach packages.iso --format qcow2 -a modified.qcow2 --run script.sh --root-password disabled

Step 8. Convert the Image to the Desired Format
-----------------------------------------------

After we are happy with the result we can convert the image to the preferred format to import to OpenNebula. Even if we want a ``qcow2`` image we have to convert it to consolidate all the layers in one file. For example, to create a ``qcow2`` image that can be imported to fs (ssh, shared and qcow2), ceph and fs_lvm datastores we can execute this command:

.. prompt:: bash $ auto

    $ qemu-img convert -O qcow2 modified.qcow2 final.qcow2

To create a vmdk image, for vCenter hypervisors we can use this other command:

.. prompt:: bash $ auto

    $ qemu-img convert -O vmdk modified.qcow2 final.vmdk

Step 9. Upload it to an OpenNebula Datastore
--------------------------------------------

You can now use Sunstone to upload the final version of the image or copy it to the frontend and import it. If you are going to use the second option make sure that the image is in a directory that allows image imports (by default ``/var/tmp``). For example:

.. prompt:: bash $ auto

    $ oneimage create --name centos7 --path /var/tmp/final.qcow2 --driver qcow2 --prefix vd --datastore default

.. _add_content_install_withing_opennebula:

Install within OpenNebula
=========================

If you are using KVM hypervisor you can do the installations using OpenNebula. Here are the steps to do it:

Step 1. Add the Installation Medium
-----------------------------------

You can add the installation CD to OpenNebula uploading the image using Sunstone and setting its type to CDROM or using the command line. For example, to add the CentOS ISO file you can use this command:

.. prompt:: bash $ auto

    $ oneimage create --name centos7-install --path http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-DVD.iso --type CDROM --datastore default

Step 2. Create Installation Disk
--------------------------------

The disk where the OS will be installed needs to be created as a DATABLOCK. Don't make the image too big as it can be resized afterwards on VM instantiation. Also make sure to make it persistent so we don't lose the installation when the Virtual Machine terminates.

|sunstone_datablock_create|

If you are using the CLI you can do the same with this command:

.. prompt:: bash $ auto

    $ oneimage create --name centos7 --description "Base CentOS 7 Installation" --type DATABLOCK --persistent --prefix vd --driver qcow2 --size 10240 --datastore default

Step 3. Create a Template to do the Installation
------------------------------------------------

In this step you have to take the following into account:

* Add first the persistent datablock and second the installation media in the storage tab
* Add a network as it will be needed to download context packages
* On OS Booting tab enable both disks for booting. The first time it will use the CD and after installing the OS the DATABLOCK will be used
* In Input/Output tab enable VNC and add as input an USB Tablet. This will be useful in case the OS has a graphical installation

This can be done with the CLI using this command:

.. prompt:: bash $ auto

    $ onetemplate create --name centos7-cli --cpu 1 --memory 1G --disk centos7,centos7-install --nic network --boot disk0,disk1 --vnc --raw "INPUT=[TYPE=tablet,BUS=usb]"

Now instantiate the template and do the installation using the VNC viewer. Make sure that you configure the network manually as there are no context packages in the installation media. Upon completion tell the instanter to reboot the machine, log into the new OS and follow the instructions from the accompanying sections to install the contextualization.

As a tip, one of the latest things you should do when using this method is disabling ``root`` password and deleting any extra users that the install tool has created.

Step 4. Shutdown the Machine and Configure the Image
----------------------------------------------------

You can now shutdown the Virtual Machine from inside, that is, use the OS to shutdown itself. When the machine appears as poweroff in OpenNebula terminate it.

Make sure that you change the image to non persistent and you give access to other people.

Using the CLI you can do:

.. prompt:: bash $ auto

    $ oneimage nonpersistent centos7
    $ oneimage chmod centos7 744


.. _add_content_marketplace:

Use the OpenNebula Marketplace
==============================

If your frontend is connected to the internet it should have access to the public OpenNebula Marketplace. In it there are several images prepared to run in an OpenNebula Cloud. To get images from it you can go to the Storage/Apps tab in Sunstone web interface, select one of the images and click the download button:

|sunstone_marketplace_list_import|

Using the CLI we can list an import using these commands:

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


.. _cloud_view_services:

How to Prepare the Service Templates
================================================================================

When you prepare a :ref:`OneFlow Service Template <appflow_use_cli>` to be used by the Cloud View users, take into account the following:

* You can define :ref:`dynamic networks <appflow_use_cli_networks>` in the Service Template, to allow users to choose the virtual networks for the new Service instance.
* If any of the Virtual Machine Templates used by the Roles has User Inputs defined (see the section above), the user will be also asked to fill them when the Service Template is instantiated.
* Users will also have the option to change the Role cardinality before the Service is created.

|prepare-tmpl-flow-1|

|prepare-tmpl-flow-2|

To make a Service Template available to other users, you have two options:

* Change the Template's group, and give it ``GROUP USE`` permissions. This will make the Service Template only available to users in that group.
* Leave the Template in the oneadmin group, and give it ``OTHER USE`` permissions. This will make the Service Template available to every user in OpenNebula.

Please note that you will need to do the same for any VM Template used by the Roles, and any Image and Virtual Network referenced by those VM Templates, otherwise the Service deployment will fail.

.. |sunstone_datablock_create| image:: /images/sunstone_datablock_create.png
.. |sunstone_marketplace_list_import| image:: /images/sunstone_marketplace_list_import.png
.. |prepare-tmpl-flow-1| image:: /images/prepare-tmpl-flow-1.png
.. |prepare-tmpl-flow-2| image:: /images/prepare-tmpl-flow-2.png
