.. _vdc_admin_view:
.. _group_admin_view:

========================
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
