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

  - Add the installation medium to a OpenNebula datastore. Usually it will be a OS installation CD-ROM/DVD.
  - Create a DATABLOCK image of the desired capacity to install the OS. Once created change its type to OS and make it persistent.
  - Create a new template using the previous two images. Make sure to set the OS/BOOT parameter to cdrom and enable the VNC console.
  - Instantiate the template and install the OS and any additional software
  - Once you are done, shutdown the VM

-  **Use the OpenNebula Marketplace**. Go to the marketplace tab in Sunstone, and simply pick a disk image with the OS and Hypervisor of your choice.

Once the images are ready, just create VM templates with the relevant configuration attributes, including default capacity, networking or any other preset needed by your infrastructure.

You are done, make sure that your cloud users can access the images and templates you have just created.


.. todo:: Format and review the following contents



How to Prepare the Virtual Machine Templates
================================================================================

.. todo:: not true anymore, instantiate is the same for admin and cloud views

The dialog to launch new VMs from the Cloud View is a bit different from the standard "Template instantiate" action. To make a Template available for end users, take into account the following items:

Capacity is Customizable
--------------------------------------------------------------------------------

.. todo:: Instance types are deprecated

You must set a default CPU and Memory for the Template, but users can change these values. The available capacity presets can be :ref:`customized <sunstone_instance_types>`

|prepare-tmpl-capacity|

You can disable this option for the whole cloud modifying the ``cloud.yaml`` or ``groupadmin.yaml`` view files or per template in the template creation wizard

.. code::

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

If the users need persistent storage, they can use the `Save a VM`_ functionality

.. _cloud_view_select_network:

Prepare the Network Interfaces
--------------------------------------------------------------------------------

Users can select the VM network interfaces when launching new VMs. You can create templates without any NIC, or set the default ones. If the template contains any NIC, users will still be able to remove them and select new ones.

|prepare-tmpl-network|

Because users will add network interfaces, you need to define a default NIC model in case the VM guest needs a specific one (e.g. virtio for KVM). This can be done with the :ref:`NIC_DEFAULT <nic_default_template>` attribute, or through the Template wizard. Alternatively, you could change the default value for all VMs in the driver configuration file (see the :ref:`KVM one <kvmg_default_attributes>` for example).

|prepare-tmpl-nic-default|

You can disable this option for the whole cloud modifying the ``cloud.yaml`` or ``groupadmin.yaml`` view files or per template in the template creation wizard

.. code::

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

.. code::

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


.. |prepare-tmpl-chgrp| image:: /images/prepare-tmpl-chgrp.png
.. |prepare-tmpl-network| image:: /images/prepare-tmpl-network.png
.. |prepare-tmpl-capacity| image:: /images/prepare-tmpl-capacity.png
.. |prepare-tmpl-nic-default| image:: /images/prepare-tmpl-nic-default.png
.. |prepare-tmpl-ssh| image:: /images/prepare-tmpl-ssh.png
.. |prepare-tmpl-user-input-1| image:: /images/prepare-tmpl-user-input-1.png
.. |prepare-tmpl-user-input-2| image:: /images/prepare-tmpl-user-input-2.png
.. |prepare-tmpl-flow-1| image:: /images/prepare-tmpl-flow-1.png
.. |prepare-tmpl-flow-2| image:: /images/prepare-tmpl-flow-2.png