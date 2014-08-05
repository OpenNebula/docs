.. _vdc_admin_view:

========================
VDC Admin View
========================

The role of a VDC Admin is to manage all the virtual resources of the VDC, including the creation of new users. When one of these VDC Admin users access Sunstone, they get a limited view of the cloud, but more complete than the one end users get with the :ref:`Cloud View <cloud_view>`.

You can read more about OpenNebula's approach to VDC's and the cloud from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

|vdcadmin_dash|

Manage Users
================================================================================

The VDC admin can create new user accounts, that will belong to the same VDC group.

|vdcadmin_create_user|

They can also see the current resource usage of all the VDC users, and set quota limits for each one of them.

|vdcadmin_users|

|vdcadmin_user_info|

Manage Resources
================================================================================

The VDC admin can manage the Services, VMs and Templates of other users in the VDC. The resources of an specific user can be filtered in each of the list views for each resource type or can be listed in the detailed view of the user

Filtering Resources by User
---------------------------

|vdcadmin_filtering_resources|

User Resources
--------------

|vdcadmin_user_resources|

Create Resources
================================================================================

The VDC admin view is an extension of the Cloud view, and includes all the functionlity provided through the :ref:`Cloud view <cloud_view>`. The VDC admin can create new resources in the same way as a regular VDC user does.

.. _vdc_admin_view_save:

Prepare Resources for Other Users
================================================================================

Any user of the Cloud View can save the changes made to a VM back to a new Template, and use this Template to instantiate new VMs later. The VDC admin can also share his own Saved Templates with the rest of the group. For example the VDC admin can instantiate a clean VM prepared by the cloud administrator, install software needed by other users in his VDC, save it in a new Template and make it available for the rest of the group.

The VDC admin has to power off the VM first and then the save operation will create a new Image and a Template referencing this Image. Note that only the first disk will saved, if the VM has more than one disk, they will not be saved.

|vdcadmin_save_vm|

The VDC admin can share/unshare saved templates from the list of templates.

|vdcadmin_share_template|

These shared templates will be listed under the "VDC" tab when trying to create a new VM. A Saved Template created by a regular user is only available for that user and is listed under the "Saved" tab.

|vdcadmin_create_vm_templates_list|

When deleting a saved template both the Image and the Template will be removed from OpenNebula.

Accounting
================================================================================

VDC Accounting
--------------

The VDC info tab provides information of the usage of the VDC and also accounting reports can be generated. These reports can be configured to report the usage per VM or per user for an specific range of time.

|vdcadmin_vdc_acct|

User Accounting
---------------

The detailed view of the user provides information of the usage of the user, from this view accounting reports can be also genereated for this specific user

|vdcadmin_user_acct|


How to Enable
================

By default the VDC Admin account is not created for a new group. It can be enabled in the Admin tab of the Group creation form, this view will be automatically assigned to him.

|vdcadmin_create_admin|

.. |vdcadmin_dash| image:: /images/vdcadmin_dash.png
.. |vdcadmin_create_admin| image:: /images/vdcadmin_create_admin.png
.. |vdcadmin_users| image:: /images/vdcadmin_users.png
.. |vdcadmin_create_user| image:: /images/vdcadmin_create_user.png
.. |vdcadmin_user_info| image:: /images/vdcadmin_user_info.png
.. |vdcadmin_filtering_resources| image:: /images/vdcadmin_filtering_resources.png
.. |vdcadmin_user_resources| image:: /images/vdcadmin_user_resources.png
.. |vdcadmin_save_vm| image:: /images/vdcadmin_save_vm.png
.. |vdcadmin_share_template| image:: /images/vdcadmin_share_template.png
.. |vdcadmin_create_vm_templates_list| image:: /images/vdcadmin_create_vm_templates_list.png
.. |vdcadmin_vdc_acct| image:: /images/vdcadmin_vdc_acct.png
.. |vdcadmin_user_acct| image:: /images/vdcadmin_user_acct.png

