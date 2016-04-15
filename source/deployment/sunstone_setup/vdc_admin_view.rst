.. _vdc_admin_view:
.. _group_admin_view:

========================
Group Admin View
========================

The role of a Group Admin is to manage all the virtual resources of the Group, including the creation of new users. When one of these Group Admin users access Sunstone, they get a limited view of the cloud, but more complete than the one end users get with the :ref:`Cloud View <cloud_view>`.

You can read more about OpenNebula's approach to Groups and VDC's from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

|groupadmin_dash|

Manage Users
================================================================================

The Group Admin can create new user accounts, that will belong to the same Group.

|groupadmin_create_user|

They can also see the current resource usage of all the Group users, and set quota limits for each one of them.

|groupadmin_users|

|groupadmin_user_info|

Manage Resources
================================================================================

The Group admin can manage the Services, VMs and Templates of other users in the Group. The resources of a specific user can be filtered in each of the list views for each resource type or can be listed in the detailed view of the user

Filtering Resources by User
---------------------------

|groupadmin_filtering_resources|

User Resources
--------------

|groupadmin_user_resources|

Create Resources
================================================================================

The Group admin view is an extension of the Cloud view, and includes all the functionlity provided through the :ref:`Cloud view <cloud_view>`. The Group admin can create new resources in the same way as a regular user does.

.. _vdc_admin_view_save:
.. _group_admin_view_save:

Prepare Resources for Other Users
================================================================================

Any user of the Cloud View can save the changes made to a VM back to a new Template, and use this Template to instantiate new VMs later. The Group admin can also share his own Saved Templates with the rest of the group. For example the Group admin can instantiate a clean VM prepared by the cloud administrator, install software needed by other users in his Group, save it in a new Template and make it available for the rest of the group.

The Group admin has to power off the VM first and then the save operation will create a new Image and a Template referencing this Image. Note that only the first disk will saved, if the VM has more than one disk, they will not be saved.

|groupadmin_save_vm|

The Group admin can share/unshare saved templates from the list of templates.

|groupadmin_share_template|

These shared templates will be listed under the "Group" tab when trying to create a new VM. A Saved Template created by a regular user is only available for that user and is listed under the "Saved" tab.

|groupadmin_create_vm_templates_list|

When deleting a saved template both the Image and the Template will be removed from OpenNebula.

Accounting & Showback
================================================================================

Group Accounting & Showback
--------------------------------------------------------------------------------

The Group info tab provides information of the usage of the Group and also accounting and showback reports can be generated. These reports can be configured to report the usage per VM or per user for a specific range of time.

|groupadmin_vdc_acct|

|groupadmin_vdc_showback|

User Accounting & Showback
--------------------------------------------------------------------------------

The detailed view of the user provides information of the usage of the user, from this view accounting reports can be also genereated for this specific user

|groupadmin_user_acct|


How to Enable
================

By default the Group Admin account is not created for a new group. It can be enabled in the Admin tab of the Group creation form, this view will be automatically assigned to him.

|groupadmin_create_admin|

.. |groupadmin_dash| image:: /images/vdcadmin_dash.png
.. |groupadmin_create_admin| image:: /images/vdcadmin_create_admin.png
.. |groupadmin_users| image:: /images/vdcadmin_users.png
.. |groupadmin_create_user| image:: /images/vdcadmin_create_user.png
.. |groupadmin_user_info| image:: /images/vdcadmin_user_info.png
.. |groupadmin_filtering_resources| image:: /images/vdcadmin_filtering_resources.png
.. |groupadmin_user_resources| image:: /images/vdcadmin_user_resources.png
.. |groupadmin_save_vm| image:: /images/vdcadmin_save_vm.png
.. |groupadmin_share_template| image:: /images/vdcadmin_share_template.png
.. |groupadmin_create_vm_templates_list| image:: /images/vdcadmin_create_vm_templates_list.png
.. |groupadmin_vdc_acct| image:: /images/vdcadmin_vdc_acct.png
.. |groupadmin_user_acct| image:: /images/vdcadmin_user_acct.png
.. |groupadmin_vdc_showback| image:: /images/vdcadmin_vdc_showback.png
