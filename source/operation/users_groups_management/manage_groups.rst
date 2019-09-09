.. _manage_groups:
.. _manage_users_groups:

==========================
Managing Groups
==========================

A group in OpenNebula makes it possible to isolate users and resources. A user can see and use the :ref:`shared resources <chmod>` from other users.

The group is an authorization boundary for the users, but you can also partition your cloud infrastructure and define what resources are available to each group using :ref:`Virtual Data Centers (VDC) <manage_vdcs>`. You can read more about OpenNebula's approach to VDCs and the cloud from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

Adding and Deleting Groups
================================================================================

There are two special groups created by default. The ``oneadmin`` group allows any user in it to perform any operation, allowing different users to act with the same privileges as the ``oneadmin`` user. The ``users`` group is the default group where new users are created.

Your can use the ``onegroup`` command line tool to manage groups in OpenNebula. There are two groups created by default, ``oneadmin`` and ``users``.

To create new groups:

.. prompt:: bash $ auto

    $ onegroup list
      ID NAME
       0 oneadmin
       1 users

    $ onegroup create "new group"
    ID: 100

The new group has ID 100 to differentiate the special groups from the user-defined ones.

.. note:: When a new group is created, an ACL rule is also created to provide the default behavior, allowing users to create basic resources. You can learn more about ACL rules in :ref:`this guide <manage_acl>`; but you don't need any further configuration to start using the new group.

Adding Users to Groups
================================================================================

Use the ``oneuser chgrp`` command to assign users to groups.

.. prompt:: bash $ auto

    $ oneuser chgrp -v regularuser "new group"
    USER 1: Group changed

    $ onegroup show 100
    GROUP 100 INFORMATION
    ID             : 100
    NAME           : new group

    USERS
    ID              NAME
    1               regularuser

To delete a user from a group, just move it again to the default ``users`` group.

.. _manage_groups_permissions:

Admin Users and Allowed Resources
================================================================================

Upon group creation, a special admin user account can be defined. This admin user will have administrative privileges only for the new group, not for all the resources in the OpenNebula cloud as the 'oneadmin' group users have.

Another aspect that can be controlled on creation time is the type of resources that group users will be allowed to create.

This can be managed visually in Sunstone, and can also be managed through the CLI. In the latter, details of the group are passed to the ``onegroup create`` command as arguments. This table lists the description of said arguments.

+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+
|         Argument        |   M / O   |       Value        |                                   Description                                   |
+=========================+===========+====================+=================================================================================+
| `-n, --name name`       | Mandatory | Any string         | Name for the new group                                                          |
+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+
| `-u, --admin_user`      | Optional  | Any string         | Creates an admin user for the group with the given name                         |
+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+
| `-p, --admin_password`  | Optional  | Any string         | Password for the admin user of the group                                        |
+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+
| `-d, --admin_driver`    | Optional  | Any string         | Auth driver for the admin user of the group                                     |
+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+
| `-r, --resources`       | Optional  | "+" separated list | Which resources can be created by group users (VM+IMAGE+TEMPLATE by default)    |
+-------------------------+-----------+--------------------+---------------------------------------------------------------------------------+

An example:

.. prompt:: bash $ auto

    $ onegroup create --name groupA \
    --admin_user admin_userA --admin_password somestr \
    --resources TEMPLATE+VM

|manage_groups_1|

.. _add_admin_user_to_group:

Add Admin Users to an Existing Group
================================================================================

Any user can be configured to be Admin of a group with the commands ``onegroup addadmin`` and ``deladmin``.

|manage_groups_2|

.. _manage_groups_virtual_resources:

Managing Groups and Virtual Resources
================================================================================

You can make the following virtual resources available to group users:

* :ref:`Virtual Machine Templates <vm_guide>`
* :ref:`Service Templates <appflow_use_cli>`
* :ref:`Images <img_guide>`
* :ref:`Files & Kernels <img_guide_files>`

To make a virtual resource owned by oneadmin available to users of the new group, you have two options:

* Change the resource's group, and give it ``GROUP USE`` permissions. This will make the resource only available to users in that group. The recommended practice to assign golden resources to groups is to first clone the resource and then assign it to the desired group for their users' consumption.
* Leave the resource in the oneadmin group, and give it ``OTHER USE`` permissions. This will make the resource available to every user in OpenNebula.

|prepare-tmpl-chgrp|

The Virtual Machine and Service Templates are visible to the group users when they want to create a new VM or Service. The Images (including File Images) used by those Templates are not visible to the users, but must be also made available, otherwise the VM creation will fail with an error message similar to this one:

.. code::

    [TemplateInstantiate] User [6] : Not authorized to perform USE IMAGE [0].

You can read more about OpenNebula permissions in the :ref:`Managing Permissions <chmod>` and :ref:`Managing ACL Rules <manage_acl>` guides.


Resource Sharing
================================================================================

When a new group is created the cloud administrator can define if the users of this view will be allowed to view the VMs and Services of other users in the same group. If this option is checked a new ACL rule will be created to give users in this group access to the VMS and Services in the same group. Users will not able to manage these resources but they will be included in the list views of each resource.

|cloud_resource_sharing|


.. _manage_users_primary_and_secondary_groups:

Primary and Secondary Groups
================================================================================

With the commands ``oneuser addgroup`` and ``delgroup`` the administrator can add or delete secondary groups. Users assigned to more than one group will see the resources from all their groups. e.g. a user in the groups testing and production will see VMs from both groups.

The group set with ``chgrp`` is the primary group, and resources (Images, VMs, etc) created by a user will belong to this primary group. Users can change their primary group to any of their secondary group without the intervention of an administrator, using ``chgrp`` again.

Group-wise Configuration Attributes
================================================================================

When a group is created you can define specific configuration aspects for the group users. These include:

* Sunstone. Allow users and group admins to access specific views. The configuration attributes are stored in the group template in the ``SUNSTONE`` attribute:

+-------------------------+---------------------------------------------------------------------------------+
|         Attribute       |                                   Description                                   |
+=========================+=================================================================================+
| DEFAULT_VIEW            | Default Sunstone view for regular users                                         |
+-------------------------+---------------------------------------------------------------------------------+
| VIEWS                   | List of available views for regular users                                       |
+-------------------------+---------------------------------------------------------------------------------+
| GROUP_ADMIN_DEFAULT_VIEW| Default Sunstone view for group admin users                                     |
+-------------------------+---------------------------------------------------------------------------------+
| GROUP_ADMIN_VIEWS       | List of available views for the group admins                                    |
+-------------------------+---------------------------------------------------------------------------------+

The views are defined by a comma separated list of group names. By default the following views are defined: ``groupadmin, cloud, admin, user, admin_vcenter, cloud_vcenter, groupadmin_vcenter``

Example:

.. code::

    SUNSTONE = [
      DEFAULT_VIEW = "cloud",
      VIEWS        = "cloud",
      GROUP_ADMIN_DEFAULT_VIEW = "groupadmin",
      GROUP_ADMIN_VIEWS        = "groupadmin,cloud"
    ]

* OpenNebula Core. Set specific attributes to control some operations. The configuration attributes are stored in the group template in the ``OPENNEBULA`` attribute:

+------------------------------+----------------------------------------------------------------------------+
|         Attribute            |                              Description                                   |
+==============================+============================================================================+
| DEFAULT_IMAGE_PERSISTENT     | Control the default value for the PERSISTENT attribute on image creation ( |
|                              | clone and disk save-as).                                                   |
+------------------------------+----------------------------------------------------------------------------+
| DEFAULT_IMAGE_PERSISTENT_NEW | Control the default value for the PERSISTENT attribute on image creation ( |
|                              | only new images).                                                          |
+------------------------------+----------------------------------------------------------------------------+
| API_LIST_ORDER               | Sets order (by ID) of elements in list API calls (e.g. onevm list).        |
|                              | Values: ASC (ascending order) or DESC (descending order)                   |
+------------------------------+----------------------------------------------------------------------------+

The Group template can be used to customize the access level of the ``VM_USE_OPERATIONS``, ``VM_MANAGE_OPERATIONS`` and ``VM_ADMIN_OPERATIONS``. For a description of these attributes see :ref:`VM Operations Permissions <oned_conf_vm_operations>`

.. note:: These values can be overwritten for each user by placing the desired values in the user template.

If the values are not set the defaults defined in ``oned.conf`` are used.

Example:

.. code::

    OPENNEBULA = [
      DEFAULT_IMAGE_PERSISTENT     = "YES",
      DEFAULT_IMAGE_PERSISTENT_NEW = "NO"
    ]

.. _manage_groups_sunstone:

Managing Groups in Sunstone
================================================================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|image3|

There is an option to filter all system resources by ``group``. In the user's menu appear the groups of this user. There's the option ``All`` to see all system resources. When you filter by group, you also change the effective group of the user.

This allows to work more comfortably on projects, by isolating the resources belonging to one group from others.

|sunstone_filter|

It's possible to show the filter in the top menu.

.. code-block:: yaml

    filter-view: true

.. |image3| image:: /images/sunstone_group_list.png
.. |prepare-tmpl-chgrp| image:: /images/prepare-tmpl-chgrp.png
.. |manage_groups_1| image:: /images/manage_groups_1.png
.. |manage_groups_2| image:: /images/manage_groups_2.png
.. |cloud_resource_sharing| image:: /images/cloud_resource_sharing.png
.. |sunstone_filter| image:: /images/sunstone_filter.png
