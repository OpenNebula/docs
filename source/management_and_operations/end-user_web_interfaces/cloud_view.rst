.. _cloud_view:

================================================================================
Self-service Cloud View
================================================================================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new virtual machines easily. To create new VMs and Services, they just have to select one of the available templates prepared by the administrators.

|cloud_dash|

Using the Cloud
================================================================================

Create VM
--------------------------------------------------------------------------------

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optionally customize the VM capacity, resize disks, add new network interfaces and provide values required by the template. Read :ref:`Adding Content to Your Cloud <add_content>` for more information.

|cloud_create_vm|

.. _cloudview_ssh_keys:

Access the VMs with SSH Keys
--------------------------------------------------------------------------------

Any user can provide his own ssh public key to be included in the VMs created through this view. Note that the template has to be configured to include it.

|cloud_add_ssh_key|

Manage VMs
--------------------------------------------------------------------------------

The status of the VMs can be monitored from the VMs tab.

|cloud_vms_list|

Information about the capacity, OS, IPs, creation time and monitoring graphs for a specific VM are available in the detailed view of the VM

|cloud_vm_info|

A user can perform the following actions from this view:

* Access the VNC console, note that the Template has to be configured for this
* Reboot the VM, the user can send the reboot signal (reboot) or reboot the machine (reboot hard)
* Power off the VM, the user can send the power off signal (poweroff) or power off the machine (poweroff hard)
* Terminate the VM
* Save the VM into a new Template
* Power on the VM

.. _save_vm_as_template_cloudview:
.. _cloudview_persistent:

Make the VM Changes Persistent
--------------------------------------------------------------------------------

Users can create a persistent private copy of the available templates. A persistent copy will preserve the changes made to the VM disks after the instance is terminated. This template is private, and will only be listed to the owner user.

To create a persistent copy, use the "Persistent" switch next to the create button:

|sunstone_persistent_1|

Alternatively, a VM that was not created as persistent can be saved before it is destroyed. To do so, the user has to power off the VM first and then use the save operation.

|sunstone_persistent_3|

Any of the these two actions will create a new Template with the VM name. This template can be used in the "new VM wizard" to restore the VM after it is terminated. This template contains a copy of each one of the original disk images. If you delete this template, all the disk contents will be also lost.

|sunstone_persistent_2|

.. note:: Avoid making a persistent copy of a persistent copy! Although there are use cases where it is justified, you will end with a long list of Templates and the disk usage quota will decrease quickly.

For more details about the limitations of saved VM, continue to the :ref:`Managing Virtual Machines guide <vm_guide2_clone_vm>`.

Create Service
--------------------------------------------------------------------------------

In this scenario the cloud administrator must prepare a set of Service templates and make them available to the cloud users. These Service templates must be ready to be instantiated, i.e. they define all the mandatory attributes and the templates that are referenced are available for the user. Before using them, users can optionally customize the Service cardinality, define the network interfaces and provide values required by the template. Read :ref:`Adding Content to Your Cloud <add_content>` for more information.

|cloud_create_service|

Manage Services
--------------------------------------------------------------------------------

The status of the Services can be monitored from the Services tab

|cloud_services_list|

Information of the creation time, cardinality and status for each Role are available in the detailed view of the Service

|cloud_service_info|

A user can perform the following actions from this view:

* Change the cardinality of each Role
* Retrieve the VMs of each Role
* Delete the Service
* Recover the Service from a fail status

Usage, Accounting and Showback
--------------------------------------------------------------------------------

From the user settings dialog, the user can check his current quotas, accounting and showback information. From this dialog the user can also change his password, language, ssh key and view:

|cloud_user_settings|

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
.. |cloud_user_settings| image:: /images/cloud_user_settings.png
.. |showback_template_wizard| image:: /images/showback_template_wizard.png
.. |sunstone_persistent_1| image:: /images/sunstone_persistent_1.png
.. |sunstone_persistent_2| image:: /images/sunstone_persistent_2.png
.. |sunstone_persistent_3| image:: /images/sunstone_persistent_3.png
