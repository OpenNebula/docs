.. _qs_vdc:

===================================================
Quickstart: Create Your First vDC
===================================================

This guide will provide a quick example of how to partition your cloud for a vDC. In short, a vDC is a group of users with part of the physical resources assigned to them. The :ref:`Understanding OpenNebula<understand>` guide explains the OpenNebula provisioning model in detail.


Step 1. Create a Cluster
================================================================================

We will first create a :ref:`cluster <cluster_guide>`, 'web-dev', where we can group hosts, datastores and virtual networks for the new vDC.

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

Step 2. Create a vDC Group
================================================================================

We can now create the new :ref:`group <manage_groups>`, named also 'web-dev'. This group, or vDC, will have a special admin user, 'web-dev-admin'.

.. code::

    $ onegroup create --name web-dev --admin_user web-dev-admin --admin_password abcd
    ID: 100

    $ onegroup add_provider 100 0 web-dev

|qs_vdc2|

|qs_vdc3|

Step 3. Optionally, Set Quotas
================================================================================

The cloud administrator can set :ref:`usage quotas <quota_auth>` for the vDC. In this case, we will put a limit of 10 VMs.

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

At this point, the cloud administrator can also prepare working Templates and Images for the vDC users.

.. code::

    $ onetemplate chgrp ubuntu web-dev

|qs_vdc5|

Reference for End Users
================================================================================

The vDC admin uses an interface similar to the cloud administrator, but without any information about the physical infrastructure. He will be able to create new users inside the vDC, monitor their resources, and create new Templates for them. The vDC admin can also decide to configure quota limits for each user.

Refer your vDC admin user to the :ref:`vDC Admin View Guide <vdc_admin_view>`.

End users access OpenNebula through a simplified instantiate, where they can launch their own VMs from the Templates prepared by the administrator. Users can also save the changes they make to their machines. This view is self explanatory, you can read more about it in the :ref:`Cloud View Guide <cloud_view>`.

|qs_vdc6|

|qs_vdc7|


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
.. |qs_vdc6| image:: /images/qs_vdc6.png
   :width: 100 %
.. |qs_vdc7| image:: /images/qs_vdc7.png
   :width: 100 %