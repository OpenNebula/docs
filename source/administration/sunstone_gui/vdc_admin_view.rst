.. _vdc_admin_view:

========================
vDC Admin View
========================

The role of a vDC Admin is to manage all the virtual resources of the vDC, including the creation of new users. When one of these vDC Admin users access Sunstone, they get a limited view of the cloud, but more complete than the one end users get with the :ref:`Cloud View <cloud_view>`.

You can read more about OpenNebula's approach to vDC's and the cloud from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

|vdcadmin_dash|


Manage Users
================================================================================

The vDC Admin can create new user accounts, that will belong to the same vDC group. They can also see the current resource usage of other users, and set quota limits for each one of them.

|vdcadmin_users|

|vdcadmin_create_user|

|vdcadmin_quota|

|vdcadmin_edit_quota|

Manage Resources
================================================================================

Admins can manage the VMs and Images of other users in the vDC.

|vdcadmin_manage_vm|

Create Machines
================================================================================

To create new Virtual Machines, the vDC Admin must change his current view to the 'cloud' view. This can be done in the settings menu, accesible from the upper username button.

|vdcadmin_change_view|

The :ref:`Cloud View <cloud_view>` is self explanatory.

|vdcadmin_create_vm|


Prepare Resources for Other Users
================================================================================

Any user of the Cloud View can save the changes made to a VM back to a new Template. vDC Admins can for example instantiate a clean VM prepared by the cloud administrator, install software needed by other users in his vDC, and make it available for the rest of the group.

|vdcadmin_save_vm|

The save operation from the Cloud View will create a new Template and Image. These can be managed changing back to the 'vdcadmin' view from the settings.

|vdcadmin_change_view_cloud|

|vdcadmin_saved_template|

|vdcadmin_saved_img|

The admin must change the **Group Use** permission checkbox for *both* the new Template and Image.

|vdcadmin_template_chmod|

Alternately, the new template & image could be assigned to a specific user. This can be done changing the owner.

|vdcadmin_template_chown|

Manage the Infrastructure
================================================================================

Although vDC admins can't manage the physical infrastructure, they have a limited amount of information about the storage and the networks assigned to the vDC.

|vdcadmin_ds|
|vdcadmin_vnet|


.. |vdcadmin_change_view_cloud| image:: /images/vdcadmin_change_view_cloud.png
   :width: 100 %
.. |vdcadmin_change_view| image:: /images/vdcadmin_change_view.png
   :width: 100 %
.. |vdcadmin_create_user| image:: /images/vdcadmin_create_user.png
   :width: 100 %
.. |vdcadmin_create_vm| image:: /images/vdcadmin_create_vm.png
   :width: 100 %
.. |vdcadmin_dash| image:: /images/vdcadmin_dash.png
   :width: 100 %
.. |vdcadmin_ds| image:: /images/vdcadmin_ds.png
   :width: 100 %
.. |vdcadmin_edit_quota| image:: /images/vdcadmin_edit_quota.png
   :width: 100 %
.. |vdcadmin_manage_vm| image:: /images/vdcadmin_manage_vm.png
   :width: 100 %
.. |vdcadmin_quota| image:: /images/vdcadmin_quota.png
   :width: 100 %
.. |vdcadmin_saved_img| image:: /images/vdcadmin_saved_img.png
   :width: 100 %
.. |vdcadmin_saved_template| image:: /images/vdcadmin_saved_template.png
   :width: 100 %
.. |vdcadmin_save_vm| image:: /images/vdcadmin_save_vm.png
   :width: 100 %
.. |vdcadmin_template_chmod| image:: /images/vdcadmin_template_chmod.png
   :width: 100 %
.. |vdcadmin_template_chown| image:: /images/vdcadmin_template_chown.png
   :width: 100 %
.. |vdcadmin_users| image:: /images/vdcadmin_users.png
   :width: 100 %
.. |vdcadmin_vnet| image:: /images/vdcadmin_vnet.png
   :width: 100 %