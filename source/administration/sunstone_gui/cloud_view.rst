.. _cloud_view:

========================
Self-service Cloud View
========================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new virtual machines easily. To create new VMs, they just have to select one of the available templates prepared by the administrators.

In this scenario the cloud administrator, or the vDC administrator, must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optinally customize the VM capacity, and add new network interfaces.


|image0|

How to Prepare the Virtual Machine Templates
================================================================================

The dialog to launch new VMs from the Cloud View is a bit different from the standard "Template instantiate" action. To make a Template available for end users, take into account the following items:

Capacity is Customizable
--------------------------------------------------------------------------------

You must set a default CPU and Memory for the Template, but users can change these values. The available capacity presets can be customized 

.. todo:: link to sunstone.conf with instance_types explained

|prepare-tmpl-capacity|

Enable Cloud View Features
--------------------------------------------------------------------------------

There are a few features of the Cloud View that will work if you configure the Template to make use of them:

* Users will see the Template logo and description, something that is not so visible in the normal admin view. If needed, more logos can be added...

.. todo:: where to add logos

|cloud-view-create|

* The Cloud View gives access to the VM's VNC, but only if it is configured in the Template.

* End users can upload their public ssh key. This requires the VM guest to be :ref:`contextualized <bcont>`, and the Template must have the ssh contextualization enabled.

|prepare-tmpl-ssh|

Further Contextualize the Instance with User Inputs
--------------------------------------------------------------------------------

A Template can define :ref:`USER INPUTS <template_user_inputs>`.

|prepare-tmpl-user-input-1|

These inputs will be presented to the Cloud View user when the Template is instantiated. The VM guest needs to be :ref:`contextualized <bcont>` to make use of the values provided by the user.

|prepare-tmpl-user-input-2|

Make the Images Non-Persistent
--------------------------------------------------------------------------------

The Images used by the Cloud View Templates should not be persistent. A :ref:`persistent Image <img_guide_persistent>` can only be used by one VM simultaneously, and the next user will find the changes made by the previous user.

If the users need persistent storage, they can use the

.. todo:: save as functionality

Prepare the Network Interfaces
--------------------------------------------------------------------------------

Users can select the VM network interfaces when launching new VMs. You can create templates without any NIC, or set the default ones. If the template contains any NIC, users will still be able to remove them and select new ones. 

|prepare-tmpl-network|

Because users will add network interfaces, you need to define a default NIC model in case the VM guest needs a specific one (e.g. virtio for KVM). This can be done with the :ref:`NIC_DEFAULT <nic_default_template>` attribute, or through the Template wizard. Alternatively, you could change the default value for all VMs in the driver configuration file (see the :ref:`KVM one <kvmg_default_attributes>` for example).

|prepare-tmpl-nic-default|

Change Permissions to Make It Available
--------------------------------------------------------------------------------

To make a Template available to other users, you have two options:

* Change the Template's group, and give it ``GROUP USE`` permissions. This will make the Template only available to users in that group (vDC).
* Leave the Template in the oneadmin group, and give it ``OTHER USE`` permissions. This will make the Template available to every user in OpenNebula.

|prepare-tmpl-chgrp|

Please note that you will need to do the same for any Image and Virtual Network referenced by the Template, otherwise the VM creation will fail with an error message similar to this one:

.. code::

    [TemplateInstantiate] User [6] : Not authorized to perform USE IMAGE [0].

You can read more about OpenNebula permissions in the :ref:`Managing Permissions <chmod>` and :ref:`Managing ACL Rules <manage_acl>` guides.

How to Prepare the Service Templates
================================================================================

When you prepare a :ref:`OneFlow Service Template <appflow_use_cli>` to be used by the Cloud View users, take into account the following:

* You can define :ref:`dynamic networks <appflow_use_cli_networks>` in the Service Template, to allow users to choose the virtual networks for the new Service instance.
* If any of the Virtual Machine Templates used by the Roles has User Inputs defined (see the section above), the user will be also asked to fill them when the Service Template is instantiated.
* Users will also have the option to change the Role cardinality before the Service is created.

|prepare-tmpl-flow-1|

|prepare-tmpl-flow-2|

To make a Service Template available to other users, you have two options:

* Change the Template's group, and give it ``GROUP USE`` permissions. This will make the Service Template only available to users in that group (vDC).
* Leave the Template in the oneadmin group, and give it ``OTHER USE`` permissions. This will make the Service Template available to every user in OpenNebula.

Please note that you will need to do the same for any VM Template used by the Roles, and any Image and Virtual Network referenced by those VM Templates, otherwise the Service deployment will fail.



How to Enable
================

The cloud view is enabled by default for all users. If you want to disable it, or enable just for certain groups, proceed to the :ref:`Sunstone Views <suns_views>` documentation.

.. note:: Any user can change the current view in the Sunstone settings. Administrators can use this view without any problem if they find it easier to manage their VMs.

.. |image0| image:: /images/cloud-view.png
   :width: 100 %
.. |cloud-view-create| image:: /images/cloud-view-create.png
.. |prepare-tmpl-chgrp| image:: /images/prepare-tmpl-chgrp.png
.. |prepare-tmpl-network| image:: /images/prepare-tmpl-network.png
.. |prepare-tmpl-capacity| image:: /images/prepare-tmpl-capacity.png
.. |prepare-tmpl-nic-default| image:: /images/prepare-tmpl-nic-default.png
.. |prepare-tmpl-ssh| image:: /images/prepare-tmpl-ssh.png
.. |prepare-tmpl-user-input-1| image:: /images/prepare-tmpl-user-input-1.png
.. |prepare-tmpl-user-input-2| image:: /images/prepare-tmpl-user-input-2.png
.. |prepare-tmpl-flow-1| image:: /images/prepare-tmpl-flow-1.png
.. |prepare-tmpl-flow-2| image:: /images/prepare-tmpl-flow-2.png

