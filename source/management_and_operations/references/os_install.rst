.. _os_install:

================================================================================
Guest OS Installation in OpenNebula
================================================================================

If you are using KVM hypervisor you can do the installations using OpenNebula. Here are the steps to do it:

Step 1. Add the Installation Medium
================================================================================

You can add the installation CD to OpenNebula uploading the image using Sunstone and setting its type to CDROM or using the command line. For example, to add the CentOS ISO file you can use this command:

.. prompt:: bash $ auto

    $ oneimage create --name centos7-install --path http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-DVD.iso --type CDROM --datastore default

Step 2. Create Installation Disk
================================================================================

The disk where the OS will be installed needs to be created as a DATABLOCK. Don't make the image too big as it can be resized afterwards on VM instantiation. Also make sure to make it persistent so we don't lose the installation when the Virtual Machine terminates.

With the CLI you can create a datablock with:

.. prompt:: bash $ auto

    $ oneimage create --name centos7 --description "Base CentOS 7 Installation" --type DATABLOCK --persistent --prefix vd --driver qcow2 --size 10240 --datastore default

Step 3. Create a Template to do the Installation
================================================================================

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
================================================================================

You can now shutdown the Virtual Machine from inside, that is, use the OS to shutdown itself. When the machine appears as poweroff in OpenNebula terminate it.

Make sure that you change the image to non persistent and you give access to other people.

Using the CLI you can do:

.. prompt:: bash $ auto

    $ oneimage nonpersistent centos7
    $ oneimage chmod centos7 744

