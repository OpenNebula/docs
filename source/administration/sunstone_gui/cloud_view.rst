.. _cloud_view:

========================
Self-service Cloud View
========================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new virtual machines easily. To create new VMs and Services, they just have to select one of the available templates prepared by the administrators.

|cloud_dash|

Using the Cloud
===============

Create VM
---------

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optinally customize the VM capacity, add new network interfaces and provide values required by the template. Check `How to Prepare the Virtual Machine Templates`_ for more information.

|cloud_create_vm|

Any user of the Cloud View can save the changes made to a VM back to a new Template, and use this Template to instantiate new VMs later. For example the a regular user can instantiate a clean VM prepared by the cloud administrator, install software needed by his application and save it in a new Template to instantiate new VMs. A Saved Template created by a regular user is only available for that user and is listed under the "Saved" tab.

The VDC admin can also share his own Saved Templates with the rest of the group. These shared templates will be listed under the "VDC" tab when trying to create a new VM.

Access to the VM, SSH Keys
---------------------------

Any user can provide his own ssh public key to be included in the VMs created through this view. Note that the template has to be configured to include it.

|cloud_add_ssh_key|

Manage VMs
----------

The status of the VMs can be monitored from the VMs tab.

|cloud_vms_list|

Information of the capacity, OS, IPs, creation time and monitoring graphs for an specific VM are available in the detailed view of the VM

|cloud_vm_info|

A user can perform the following actions from this view:

* Access the VNC console, note that the Template has to be configured for this
* Reboot the VM, the user can send the reboot signal (reboot) or reboot the machine (reboot hard)
* Power off the VM, the user can send the power off signal (poweroff) or power off the machine (poweroff hard)
* Delete the VM, all the information will be lost
* Save the VM into a new Template
* Power on the VM

|cloud_vm_poweroff|

Save a VM
---------

Any user of the Cloud View can save the changes made to a VM back to a new Template, and use this Template to instantiate new VMs later.

The user has to power off the VM first and then the save operation will create a new Image and a Template referencing this Image. Note that only the first disk will saved, if the VM has more than one disk, they will not be saved.

|cloud_save_vm|

A Saved Template created by a regular user is only available for that user and is listed under the "Saved" tab.

|cloud_create_vm_select_template|

Saved Templates can be managed from the Templates tab. When deleting a saved template both the Image and the Template will be removed from OpenNebula.

|cloud_templates_list|

Create Service
--------------

In this scenario the cloud administrator must prepare a set of Service templates and make them available to the cloud users. These Service templates must be ready to be instantiated, i.e. they define all the mandatory attributes and the templates that are referenced ara available for the user. Before using them, users can optinally customize the Service cardinality, define the network interfaces and provide values required by the template. Check `How to Prepare the Service Templates`_ for more information.

|cloud_create_service|

Manage Services
---------------

The status of the Services can be monitored from the Services tab

|cloud_services_list|

Information of the creation time, cardinality and status for each Role are available in the detailed view of the Service

|cloud_service_info|

A user can perform the following actions from this view:

* Change the cardinality of each Role
* Retrieve the VMs of each Role
* Delete the Service
* Recover the Service from a fail status

Usage & Accounting
------------------

The user can check his current usage and quotas

|cloud_user_quota|

Also, the user can generate accounting reports for a given range of time

|cloud_user_acct|

User Settings
-------------

From the user settings tab, the user can change his password, language, ssh key and view

|cloud_user_settings|


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

A Template can define :ref:`USER INPUTS <vm_guide_user_inputs>`. These inputs will be presented to the Cloud View user when the Template is instantiated. The VM guest needs to be :ref:`contextualized <bcont>` to make use of the values provided by the user.

|prepare-tmpl-user-input-2|

Make the Images Non-Persistent
--------------------------------------------------------------------------------

The Images used by the Cloud View Templates should not be persistent. A :ref:`persistent Image <img_guide_persistent>` can only be used by one VM simultaneously, and the next user will find the changes made by the previous user.

If the users need persistent storage, they can use the `Save a VM`_ functionality

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

Resource Sharing
================

When a new group is created the cloud administrator can define if the users of this view will be allowed to view the VMs and Services of other users in the same group. If this option is checked a new ACL rule will be created to give users in this group acces to the VMS and Services in the same group. Users will not able to manage these resources but they will be included in the list views of each resource.

|cloud_resource_sharing|


How to Enable
==============

The cloud view is enabled by default for all users and you can enable/disable it for an specific group in the group creation form.

.. note:: Any user can change the current view in the Sunstone settings. Administrators can use this view without any problem if they find it easier to manage their VMs.

.. |cloud_dash| image:: /images/cloud_dash.png
.. |cloud_create_vm| image:: /images/cloud_create_vm.png
.. |cloud_add_ssh_key| image:: /images/cloud_add_ssh_key.png
.. |cloud_vms_list| image:: /images/cloud_vms_list.png
.. |cloud_vm_info| image:: /images/cloud_vm_info.png
.. |cloud_vm_poweroff| image:: /images/cloud_vm_poweroff.png
.. |cloud_save_vm| image:: /images/cloud_save_vm.png
.. |cloud_create_vm_select_template| image:: /images/cloud_create_vm_select_template.png
.. |cloud_templates_list| image:: /images/cloud_templates_list.png
.. |cloud_create_service| image:: /images/cloud_create_service.png
.. |cloud_services_list| image:: /images/cloud_services_list.png
.. |cloud_service_info| image:: /images/cloud_service_info.png
.. |cloud_user_quota| image:: /images/cloud_user_quota.png
.. |cloud_user_acct| image:: /images/cloud_user_acct.png
.. |cloud_user_settings| image:: /images/cloud_user_settings.png
.. |cloud_resource_sharing| image:: /images/cloud_resource_sharing.png
.. |prepare-tmpl-chgrp| image:: /images/prepare-tmpl-chgrp.png
.. |prepare-tmpl-network| image:: /images/prepare-tmpl-network.png
.. |prepare-tmpl-capacity| image:: /images/prepare-tmpl-capacity.png
.. |prepare-tmpl-nic-default| image:: /images/prepare-tmpl-nic-default.png
.. |prepare-tmpl-ssh| image:: /images/prepare-tmpl-ssh.png
.. |prepare-tmpl-user-input-1| image:: /images/prepare-tmpl-user-input-1.png
.. |prepare-tmpl-user-input-2| image:: /images/prepare-tmpl-user-input-2.png
.. |prepare-tmpl-flow-1| image:: /images/prepare-tmpl-flow-1.png
.. |prepare-tmpl-flow-2| image:: /images/prepare-tmpl-flow-2.png

