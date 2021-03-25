.. _cloud_view:

================================================================================
Self-service Cloud View
================================================================================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new VMs easily. To create new VMs and Services, they just have to select one of the available Templates prepared by the administrators.

|cloud_dash|

Using the Cloud
================================================================================

Create VM
--------------------------------------------------------------------------------

In this scenario the cloud administrator must prepare a set of Templates and Images to make them available to the cloud users. These resources must be **ready** to be used.

E.g. when template attributes are defined as mandatory, users can optionally **customize the VM capacity**, **resize disks**, **add new Network Interfaces** and **provide values required by the template**. Read tips on how to :ref:`prepare VM Templates for End-Users <vm_templates_endusers>`.

|cloud_create_vm|

.. _cloudview_ssh_keys:

Access the VMs with SSH Keys
--------------------------------------------------------------------------------

Any user can provide his own ssh public key to be included in the VMs created through this view. This requires the VM guest to be :ref:`contextualized <context_overview>`, and the Template must have the ssh **contextualization enabled**.

|cloud_add_ssh_key|

Manage VMs
--------------------------------------------------------------------------------

The status of the virtual machines can be monitored from the **VMs tab**.

|cloud_vms_list|

Information about the capacity, operating system, ips, creation time and monitoring graphs for a specific VM are available in the **detail view**.

|cloud_vm_info|

Users can perform the following actions from this view:

* Access the VNC console, but only if it's configured in the Template.
* Reboot the VM, the user can send the reboot signal (``reboot``) or reboot the machine (``reboot hard``).
* Power off the VM, the user can send the power off signal (``poweroff``) or power off the machine (``poweroff hard``).
* Terminate the VM.
* Save the VM into a new Template.
* Power on the VM.

.. _save_vm_as_template_cloudview:
.. _cloudview_persistent:

Make the VM Changes Persistent
--------------------------------------------------------------------------------

Users can create a persistent private copy of the available templates. A **persistent copy will preserve the changes** made to the VM disks after the instance is terminated. This **template is private**, and will only be listed to the owner user.

To create a persistent copy, use the **Persistent** switch next to the create button:

|sunstone_persistent_1|

Alternatively, a VM that wasn't created as persistent can be saved before it's destroyed. To do so, the user has to ``power off`` the VM first and then use the ``save`` operation.

|sunstone_persistent_3|

Any of the these two actions will create a new Template. This Template can be used to create **restore the state of a VM after deletion**. This template contains a copy of each one of the original disk images.

.. warning:: If you delete this template, all the disk contents will be also lost.

|sunstone_persistent_2|

.. note:: **Avoid making a persistent copy of a persistent copy!** Although there are use cases where it is justified, you will end with a long list of Templates and the disk usage quota will decrease quickly.

For more details about the limitations of saved VM, continue to the :ref:`Managing Virtual Machines guide <vm_guide2_clone_vm>`.

Create Service
--------------------------------------------------------------------------------

In the same way that instantiating a VM, the cloud administrator must prepare a set of Service Templates. Before instantiating them, users can optionally **customize the Service cardinality**, **define the network interfaces** and **provide values required by the template**.

|cloud_create_service|

Manage Services
--------------------------------------------------------------------------------

The status of the Services can be monitored from the Services tab.

|cloud_services_list|

Information of the creation time, cardinality and status for each Role are available in the **detail view**.

|cloud_service_info|

Users can perform the following actions from this view:

* Change the cardinality of each Role
* Retrieve the VMs of each Role
* Delete the Service
* Recover the Service from a fail status

Usage, Accounting and Showback
--------------------------------------------------------------------------------

From the user settings dialog, the user can check his current **quotas**, **accounting**, **showback** information and **change account configuration** like his password, language, ssh key and view:

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
