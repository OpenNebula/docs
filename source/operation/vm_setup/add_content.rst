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

- **External Images**. If you already have disk images in any supported format (raw, qcow2, vmdk...) you can just add them to a datastore. Alternatively you can use any virtualization tool (e.g. virt-manager) to install an image and then add it to a OpenNebula datastore.
- **Install within OpenNebula**. You can also use OpenNebula to prepare the images for your cloud. The process will be as follows:

  - Add the installation medium to a OpenNebula datastore. Usually it will be a OS installation CD-ROM/DVD.
  - Create a DATABLOCK image of the desired capacity to install the OS. Once created change its type to OS and make it persistent.
  - Create a new template using the previous two images. Make sure to set the OS/BOOT parameter to cdrom and enable the VNC console.
  - Instantiate the template and install the OS and any additional software. You can find specific instructions to install contextualization packages in the other two sections of this guide.
  - Once you are done, shutdown the VM

-  **Use the OpenNebula Marketplace**. Go to the marketplace tab in Sunstone, and simply pick a disk image with the OS and Hypervisor of your choice.

Once the images are ready, just create VM templates with the relevant configuration attributes, including default capacity, networking or any other preset needed by your infrastructure.

You are done, make sure that your cloud users can access the images and templates you have just created.


Adding External Images
======================

You can use as basis for your images the ones provided by the distributions. These images are usually prepared to be used with other clouds and won't behave correctly or will not have all the features provided by OpenNebula. You can do a customization of these images before importing them.

To do this modification we are going to use the software `libguestfs <http://libguestfs.org/>`__ in a Linux machine with kvm support. You should use a modern distribution to have a recent version of libguestfs (>= 1.26). To have the latest version you can use Arch Linux but a CentOS 7 is ok.

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

This package is available in `aur repository <https://aur.archlinux.org/packages/libguestfs/>`__. You can either download the ``PKGUILD`` and compile it manually or use a pacman helper like `yaourt <https://archlinux.fr/yaourt-en>`__:

.. prompt:: bash # auto

    # yaourt -S libguestfs


Step 2. Download the Image
--------------------------

You can find the images for distributions in these links. We are going to use the ones from CentOS but the others are here for reference:

* **CentOS 7**: http://cloud.centos.org/centos/7/images/
* **Debian 8**: http://cdimage.debian.org/cdimage/openstack/current/
* **Ubuntu**: https://cloud-images.ubuntu.com/

Step 3. Download Context Packages
---------------------------------

The context packages can be downloaded from the `release section of the project <https://github.com/OpenNebula/addon-context-linux/releases>`__. Make sure you download the version you need. For example, for CentOS download the `rpm` version. Also, don't download the packages marked with `ec2` as they are specific for EC2 images.

You have to download them to a directory that we will later refer. In this example it's going to be called ``packages``.

.. prompt:: bash $ auto

    $ mkdir packages
    $ cd packages
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context_4.14.4.rpm
    $ wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context_4.14.4.deb
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

    # Install opennebula context package
    rpm -Uvh /tmp/mount/one-context*rpm

    # Remove cloud-init and NetworkManager
    yum remove -y NetworkManager cloud-init

    # Install growpart and upgrade util-linux
    yum install -y epel-release --nogpgcheck
    yum install -y cloud-utils-growpart --nogpgcheck
    yum upgrade -y util-linux --nogpgcheck

    # Install ruby and rubygem-json for onegate
    yum install -y ruby rubygem-json

    # Install VMware tools. You can skip this step for KVM images
    yum install -y open-vm-tools

CentOS 7
~~~~~~~~

.. code-block:: bash

    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    # Install opennebula context package
    rpm -Uvh /tmp/mount/one-context*rpm

    # Remove cloud-init and NetworkManager
    yum remove -y NetworkManager cloud-init

    # Install growpart and upgrade util-linux
    yum install -y epel-release --nogpgcheck
    yum install -y cloud-utils-growpart --nogpgcheck
    yum upgrade -y util-linux --nogpgcheck

    # Install ruby for onegate tool
    yum install -y ruby

    # Install VMware tools. You can skip this step for KVM images
    yum install -y open-vm-tools

Debian 8
~~~~~~~~

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    # remove cloud-init and add one-context
    dpkg -i /tmp/mount/one-context*deb
    apt-get remove -y cloud-init


    # This package contains growpart
    apt-get install -y cloud-utils

    # Unconfigure serial console. OpenNebula does not configure a serial console
    # and growpart in initrd tries to write to it. It panics in the first boot
    # if it is configured in the kernel parameters.
    sed -i 's/console=ttyS0,115200//' /extlinux.conf
    cat /extlinux.conf

    # Install ruby for onegate tool
    apt-get install -y ruby

    # Install VMware tools. You can skip this step for KVM images
    apt-get install -y open-vm-tools

Ubuntu 14.04
~~~~~~~~~~~~

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    apt-key update
    apt-get update

    # remove cloud-init and add one-context
    dpkg -i /tmp/mount/one-context*deb
    apt-get remove -y cloud-init

    # This package contains partx. Some old versions can not do online partition
    # resizing
    apt-get install -y util-linux

    # This package contains growpart
    apt-get install -y cloud-utils

    # Install ruby for onegate tool
    apt-get install -y ruby

    # Install VMware tools. You can skip this step for KVM images
    apt-get install -y open-vm-tools

Ubuntu 16.04
~~~~~~~~~~~~

.. code-block:: bash

    # mount cdrom with packages
    mkdir /tmp/mount
    mount LABEL=PACKAGES /tmp/mount

    apt-key update
    apt-get update

    # remove cloud-init and add one-context
    dpkg -i /tmp/mount/one-context*deb
    apt-get remove -y cloud-init

    # This package contains partx. Some old versions can not do online partition
    # resizing
    apt-get install -y util-linux

    # This package contains growpart
    apt-get install -y cloud-utils

    # Install ruby for onegate tool
    apt-get install -y ruby

    # Take out serial console from kernel configuration. It prevents the
    # image from booting.
    sed -i 's/console=ttyS0$//g' /boot/grub/grub.cfg

    # Install VMware tools. You can skip this step for KVM images
    apt-get install -y open-vm-tools


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

After we are happy with the result we can convert the image to the preferred format to import to OpenNebula. Even if we want a ``qcow2`` image we hace to convert it to consolidate all the layers in one file. For example, to create a ``qcow2`` image that can be imported to fs (ssh, shared and qcow2), ceph and fs_lvm datastores we can execute this command:

.. prompt:: bash $ auto

    $ qemu-img convert -O qcow2 modified.qcow2 final.qcow2

To create a vmdk image, for vCenter hypervisors we can use this other command:

.. prompt:: bash $ auto

    $ qemu-img convert -O vmdk modified.qcow2 final.vmdk

Step 9. Upload it to an OpenNebula Datastore
--------------------------------------------

You can now use Sunstone to upload the final version of the image or copy it to the frontend and import it. If you are going to use the second option make sure that the image is in a directory that allows image imports (by default ``/var/tmp``). For example:

.. prompt:: bash $ auto

    $ oneimage crate --name centos7 --path /var/tmp/final.qcow2 --driver qcow2 --prefix vd --datastore default

How to Prepare the Virtual Machine Templates
================================================================================

.. todo:: not true anymore, instantiate is the same for admin and cloud views

The dialog to launch new VMs from the Cloud View is a bit different from the standard "Template instantiate" action. To make a Template available for end users, take into account the following items:

Capacity is Customizable
--------------------------------------------------------------------------------

.. todo:: Instance types are deprecated

You must set a default CPU and Memory for the Template, but users can change these values. The available capacity presets can be :ref:customized <sunstone_instance_types>

|prepare-tmpl-capacity|

You can disable this option for the whole cloud modifying the ``cloud.yaml`` or ``groupadmin.yaml`` view files or per template in the template creation wizard

.. code-block:: yaml

    provision-tab:
        ...
        create_vm:
            capacity_select: true
            network_select: true

Set a Cost
--------------------------------------------------------------------------------

Each VM Template can have a cost. This cost is set by CPU and MB, to allow users to change the capacity and see the cost updated accordingly. VMs with a cost will appear in the :ref:`showback reports <showback>`.

|showback_template_wizard|

.. _cloud_view_features:

Enable Cloud View Features
--------------------------------------------------------------------------------

There are a few features of the Cloud View that will work if you configure the Template to make use of them:

* Users will see the Template logo and description, something that is not so visible in the normal admin view.

* The Cloud View gives access to the VM's VNC, but only if it is configured in the Template.

* End users can upload their public ssh key. This requires the VM guest to be :ref:`contextualized <bcont>`, and the Template must have the ssh contextualization enabled.

|prepare-tmpl-ssh|

Further Contextualize the Instance with User Inputs
--------------------------------------------------------------------------------

A Template can define :ref:`USER INPUTS <vm_guide_user_inputs>`. These inputs will be presented to the Cloud View user when the Template is instantiated. The VM guest needs to be :ref:`contextualized <bcont>` to make use of the values provided by the user.

|prepare-tmpl-user-input-2|

Make the Images Non-Persistent
--------------------------------------------------------------------------------

The Images used by the Cloud View Templates should not be persistent. A :ref:`persistent Image <img_guide_persistent>` can only be used by one VM simultaneously, and the next user will find the changes made by the previous user.

If the users need persistent storage, they can use the :ref:`Save a VM functionality <vm_guide2_clone_vm>`.

.. _cloud_view_select_network:

Prepare the Network Interfaces
--------------------------------------------------------------------------------

Users can select the VM network interfaces when launching new VMs. You can create templates without any NIC, or set the default ones. If the template contains any NIC, users will still be able to remove them and select new ones.

|prepare-tmpl-network|

Because users will add network interfaces, you need to define a default NIC model in case the VM guest needs a specific one (e.g. virtio for KVM). This can be done with the :ref:`NIC_DEFAULT <nic_default_template>` attribute, or through the Template wizard. Alternatively, you could change the default value for all VMs in the driver configuration file (see the :ref:`KVM one <kvmg_default_attributes>` for example).

|prepare-tmpl-nic-default|

You can disable this option for the whole cloud modifying the ``cloud.yaml`` or ``groupadmin.yaml`` view files or per template in the template creation wizard

.. code-block:: yaml

    provision-tab:
        ...
        create_vm:
            capacity_select: true
            network_select: true

Change Permissions to Make It Available
--------------------------------------------------------------------------------

To make a Template available to other users, you have two options:

* Change the Template's group, and give it ``GROUP USE`` permissions. This will make the Template only available to users in that group.
* Leave the Template in the oneadmin group, and give it ``OTHER USE`` permissions. This will make the Template available to every user in OpenNebula.

|prepare-tmpl-chgrp|

Please note that you will need to do the same for any Image and Virtual Network referenced by the Template, otherwise the VM creation will fail with an error message similar to this one:

.. code-block:: text

    [TemplateInstantiate] User [6] : Not authorized to perform USE IMAGE [0].

You can read more about OpenNebula permissions in the :ref:`Managing Permissions <chmod>` and :ref:`Managing ACL Rules <manage_acl>` guides.

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

.. |prepare-tmpl-flow-1| image:: /images/prepare-tmpl-flow-1.png
.. |prepare-tmpl-flow-2| image:: /images/prepare-tmpl-flow-2.png
