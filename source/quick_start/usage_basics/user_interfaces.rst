.. _user_interfaces:

===============
User Interfaces
===============

.. _cloud_view:

Self-service Cloud View
================================================================================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new virtual machines easily. To create new VMs and Services, they just have to select one of the available templates prepared by the administrators.

|cloud_dash|

.. todo:: Adjust titles (Using the Cloud should be less significant than Self-service Cloud View)

Using the Cloud
================================================================================

Create VM
--------------------------------------------------------------------------------

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optionally customize the VM capacity, resize disks, add new network interfaces and provide values required by the template. Read :ref:`Adding Content to Your Cloud <add_content>` for more information.

|cloud_create_vm|

Access the VMs with SSH Keys
--------------------------------------------------------------------------------

Any user can provide his own ssh public key to be included in the VMs created through this view. Note that the template has to be configured to include it.

|cloud_add_ssh_key|

.. note::
  Can include **more that one** public key adding a ``\n`` among them.
  The only problem is that you won't be able to select an specific ssh key for each VM.

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

.. _vdc_admin_view:
.. _group_admin_view:

Group Admin View
========================

The role of a Group Admin is to manage all the virtual resources of the Group, including the creation of new users. When one of these Group Admin users access Sunstone, they get a limited version of the cloud administrator view. You can read more about OpenNebula's approach to Groups and VDC's from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

Group administrators can also access the :ref:`simplified Cloud View <cloud_view>` if they prefer to.

|groupadmin_dash|

|groupadmin_change_view|

Manage Users
================================================================================

The Group Admin can create new user accounts, that will belong to the same Group.

|groupadmin_create_user|

They can also see the current resource usage of all the Group users, and set quota limits for each one of them.

|groupadmin_users|

|groupadmin_edit_quota|

Manage Resources
================================================================================

The Group admin can manage the Services, VMs and Templates of other users in the Group.

|groupadmin_list_vms|

Create Resources
================================================================================

The Group admin can create new resources in the same way as a regular user does from the :ref:`Cloud view <cloud_view>`. The creation wizard for the Virtual Machines and Services are similar in the ``groupadmin`` and ``cloud`` views.

|groupadmin_instantiate|

.. _vdc_admin_view_save:
.. _group_admin_view_save:

Prepare Resources for Other Users
================================================================================

Any user of the Cloud View or Group Admin View can save the changes made to a VM back to a new Template, and use this Template to instantiate new VMs later. See the :ref:`VM persistency options in the Cloud View <cloudview_persistent>` for more information.

The Group admin can also share his own Saved Templates with the rest of the group. For example the Group admin can instantiate a clean VM prepared by the cloud administrator, install software needed by other users in his Group, save it in a new Template and make it available for the rest of the group.

|groupadmin_share_template|

These shared templates will be listed to all the group users in the VM creation wizard, marked as 'group'. A Saved Template created by a regular user is only available for that user and is marked as 'mine'.

|groupadmin_create_vm_templates_list|

Accounting & Showback
================================================================================

Group Accounting & Showback
--------------------------------------------------------------------------------

The Group info tab provides information of the usage of the Group and also accounting and showback reports can be generated. These reports can be configured to report the usage per VM or per user for a specific range of time.

|groupadmin_group_acct|

|groupadmin_group_showback|

User Accounting & Showback
--------------------------------------------------------------------------------

The detailed view of the user provides information of the usage of the user, from this view accounting reports can be also generated for this specific user

|groupadmin_user_acct|

Networking
================================================================================

Group administrators can create :ref:`Virtual Routers <vrouter>` from Templates prepared by the cloud administrator. These Virtual Routers can be used to connect two or more of the Virtual Networks assigned to the Group.

|groupadmin_create_vrouter|

|groupadmin_topology|


.. |groupadmin_dash| image:: /images/groupadmin_dash.png
.. |groupadmin_change_view| image:: /images/groupadmin_change_view.png
.. |groupadmin_users| image:: /images/groupadmin_users.png
.. |groupadmin_create_user| image:: /images/groupadmin_create_user.png
.. |groupadmin_edit_quota| image:: /images/groupadmin_edit_quota.png
.. |groupadmin_list_vms| image:: /images/groupadmin_list_vms.png
.. |groupadmin_instantiate| image:: /images/groupadmin_instantiate.png
.. |groupadmin_share_template| image:: /images/groupadmin_share_template.png
.. |groupadmin_filtering_resources| image:: /images/vdcadmin_filtering_resources.png
.. |groupadmin_create_vm_templates_list| image:: /images/groupadmin_create_vm_templates_list.png
.. |groupadmin_group_acct| image:: /images/groupadmin_group_acct.png
.. |groupadmin_group_showback| image:: /images/groupadmin_group_showback.png
.. |groupadmin_user_acct| image:: /images/groupadmin_user_acct.png
.. |groupadmin_create_vrouter| image:: /images/groupadmin_create_vrouter.png
.. |groupadmin_topology| image:: /images/groupadmin_topology.png
