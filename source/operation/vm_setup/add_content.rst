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
