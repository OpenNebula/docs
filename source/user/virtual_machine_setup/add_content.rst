.. _add_content:

================================================================================
Adding Content to Your Cloud
================================================================================
Once you have setup your OpenNebula cloud you'll have ready the infrastructure
(clusters, hosts, virtual networks and datastores) but you need to add contents
to it for your users. This basically means two different things:

-  Add base disk images with OS installations of your choice. Including any software package of interest.
-  Define virtual servers in the form of VM Templates. We recommend that VM definitions are made by the admins as it may require fine or advanced tunning. For example you may want to define a LAMP server with the capacity to be instantiated in a remote AWS cloud.

When you have basic virtual server definitions the users of your cloud can use them to easily provision VMs, adjusting basic parameters, like capacity or network connectivity.

There are three basic methods to bootstratp the contents of your cloud, namely:

- **External Images**. If you already have disk images in any supported format (raw, qcow2, vmdk...) you can just add them to a datastore. Alternatively you can use any virtualization tool (e.g. virt-manager) to install an image and then add it to a OpenNebula datastore.
- **Install within OpenNebula**. You can also use OpenNebula to prepare the images for your cloud. The process will be as follows:

    + Add the installation medium to a OpenNebula datastore. Usually it will be a OS installation CD-ROM/DVD.
    + Create a DATABLOCK image of the desired capacity to install the OS. Once created change its type to OS and make it persistent.
    + Create a new template using the previous two images. Make sure to set the OS/BOOT parameter to cdrom and enable the VNC console.
    + Instantiate the template and install the OS and any additional software
    + Once you are done, shutdown the VM

-  **Use the OpenNebula Marketplace**. Go to the marketplace tab in Sunstone, and simply pick a disk image with the OS and Hypervisor of your choice.

Once the images are ready, just create VM templates with the relevant configuration attributes, including default capacity, networking or any other preset needed by your infrastructure.

You are done, make sure that your cloud users can access the images and templates you have just created.
