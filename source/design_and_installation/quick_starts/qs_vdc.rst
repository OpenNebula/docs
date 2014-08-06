.. _qs_vdc:

===================================================
Quickstart: Create Your First VDC
===================================================

This guide will provide a quick example of how to partition your cloud for a VDC. In short, a VDC is a group of users with part of the physical resources assigned to them. The :ref:`Understanding OpenNebula<understand>` guide explains the OpenNebula provisioning model in detail.


Step 1. Create a Cluster
================================================================================

We will first create a :ref:`cluster <cluster_guide>`, 'web-dev', where we can group :ref:`hosts <hostsubsystem>`, :ref:`datastores <sm>` and :ref:`virtual networks <vgg>` for the new VDC.

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 host01          web-dev     0       0 / 200 (0%)     0K / 7.5G (0%) on
       1 host02          web-dev     0       0 / 200 (0%)     0K / 7.5G (0%) on
       2 host03          -           0       0 / 200 (0%)     0K / 7.5G (0%) on
       3 host04          -           0       0 / 200 (0%)     0K / 7.5G (0%) on

    $ onedatastore list
      ID NAME                SIZE AVAIL CLUSTER      IMAGES TYPE DS       TM
       0 system            113.3G 25%   web-dev           0 sys  -        shared
       1 default           113.3G 25%   web-dev           1 img  fs       shared
       2 files             113.3G 25%   -                 0 fil  fs       ssh

    $ onevnet list
      ID USER         GROUP        NAME            CLUSTER      TYPE BRIDGE   LEASES
       0 oneadmin     oneadmin     private         web-dev         R virbr0        0

|qs_vdc1|

Step 2. Create a VDC Group
================================================================================

We can now create the new :ref:`group <manage_groups>`, named also 'web-dev'. This group, or VDC, will have a special admin user, 'web-dev-admin'. This admin user will be able to create new users inside the VDC.

When a new group is created, you will also have the opportunity to configure different options, like the available :ref:`Sunstone views <suns_views>`. Another thing that can be configured is if the virtual resources will be shared for all the users of the VDC, or private.

.. code::

    $ onegroup create --name web-dev --admin_user web-dev-admin --admin_password abcd
    ID: 100

    $ onegroup add_provider 100 0 web-dev

|qs_vdc2|

|qs_vdc3|

Step 3. Optionally, Set Quotas
================================================================================

The cloud administrator can set :ref:`usage quotas <quota_auth>` for the VDC. In this case, we will put a limit of 10 VMs.

.. code::

    $ onegroup show web-dev
    GROUP 100 INFORMATION
    ID             : 100
    NAME           : web-dev

    GROUP TEMPLATE
    GROUP_ADMINS="web-dev-admin"
    GROUP_ADMIN_VIEWS="vdcadmin"
    SUNSTONE_VIEWS="cloud"

    USERS
    ID
    2

    RESOURCE PROVIDERS
       ZONE CLUSTER
          0     100

    RESOURCE USAGE & QUOTAS

        NUMBER OF VMS               MEMORY                  CPU        VOLATILE_SIZE
          0 /      10        0M /       0M      0.00 /     0.00        0M /       0M

|qs_vdc4|

Step 4. Prepare Virtual Resources for the Users
================================================================================

The cloud administrator has to create the :ref:`Virtual Machine Templates <vm_guide>` and :ref:`Images <img_guide>` that the VDC users will instantiate. If you don't have any working Image yet, import the ttylinux testing appliance from the :ref:`marketplace <marketplace>`.

|qs_vdc8|

Now you need to create a VM Template that uses the new Image. Make sure you set the features mentioned in the :ref:`Cloud View guide <cloud_view_features>`, specifically the logo, description, ssh key, and user inputs.

The new Template will be owned by oneadmin. To make it available to all users (including the ones of the new VDC), check the ``OTHER USE`` permission **for both the Template and the Image**. Read more about assigning virtual resources to a VDC in the :ref:`Managing Groups & VDC guide <manage_groups_virtual_resources>`.

|qs_vdc9|

You can also prepare a :ref:`Service Template <appflow_use_cli>`. A Service is a group of interconnected Virtual Machines with deployment dependencies between them.

Create a basic Service with two roles: master (x1) and slave (x2). Check 'master' as the parent role of 'slave'. For testing purposes, both can use the ttylinux VM Template. This Service Template also needs to be shared with other users, changing the ``OTHER USE`` permission.

|qs_vdc11|

Step 5. Using the Cloud as a VDC Admin
================================================================================

If you login as the 'web-dev-admin', you will see a simplified interface, the :ref:`VDC admin view <vdc_admin_view>`. This view hides the physical infrastructure, but allows some administration tasks to be performed.

|vdcadmin_dash|

The VDC admin can create new user accounts, that will belong to the same VDC group. They can also see the current resource usage of all the VDC users, and set quota limits for each one of them.

|vdcadmin_create_user|

The VDC admin can manage the Services, VMs and Templates of other users in the VDC. The resources of a specific user can be filtered in the list views for each resource type or can be listed in the detailed view of the user.

|vdcadmin_user_info|

Although the cloud administrator is the only one that can create new base Images and Templates, the VDC admin can customize existing Templates, and share them with the rest of the VDC users.

|vdcadmin_save_vm|

Create a new user, and login again.

Step 6. Using the Cloud as a Regular User
=========================================

The regular users of the VDC use the :ref:`Cloud View<cloud_view>`, an even more simplified view of their virtual resources.

|cloud_dash|

The end users can provision new VMs and Services from the templates prepared by the administrators.

|cloud_create_vm|

They can also manage their own VMs and Services: see their monitorization, shutdown them, and save the changes made.

|cloud_service_info|

|cloud_vm_info|

The users can perform basic administration on their account. They can check his current usage and quotas, or generate accounting reports.

|cloud_user_acct|

From the user settings tab, the users can also change their password, language, and ssh key.

|cloud_user_settings|


.. |qs_vdc1| image:: /images/qs_vdc1.png
   :width: 100 %
.. |qs_vdc2| image:: /images/qs_vdc2.png
   :width: 100 %
.. |qs_vdc3| image:: /images/qs_vdc3.png
   :width: 100 %
.. |qs_vdc4| image:: /images/qs_vdc4.png
   :width: 100 %
.. |qs_vdc5| image:: /images/qs_vdc5.png
   :width: 100 %
.. |qs_vdc8| image:: /images/qs_vdc8.png
   :width: 100 %
.. |qs_vdc9| image:: /images/qs_vdc9.png
   :width: 100 %
.. |qs_vdc10| image:: /images/qs_vdc10.png
   :width: 100 %
.. |qs_vdc11| image:: /images/qs_vdc11.png
   :width: 100 %
.. |vdcadmin_dash| image:: /images/vdcadmin_dash.png
.. |vdcadmin_create_user| image:: /images/vdcadmin_create_user.png
.. |vdcadmin_user_info| image:: /images/vdcadmin_user_info.png
.. |vdcadmin_save_vm| image:: /images/vdcadmin_save_vm.png
.. |cloud_dash| image:: /images/cloud_dash.png
.. |cloud_service_info| image:: /images/cloud_service_info.png
.. |cloud_create_vm| image:: /images/cloud_create_vm.png
.. |cloud_vm_info| image:: /images/cloud_vm_info.png
.. |cloud_user_acct| image:: /images/cloud_user_acct.png
.. |cloud_user_settings| image:: /images/cloud_user_settings.png
