.. _manage_groups:

==========================
Managing Groups & vDC
==========================

.. _manage_users_groups:

Groups
======

A group in OpenNebula makes it possible to isolate users and resources. A user can see and use the :ref:`shared resources <chmod>` from other users.

There are two special groups created by default. The ``onedmin`` group allows any user in it to perform any operation, allowing different users to act with the same privileges as the ``oneadmin`` user. The ``users`` group is the default group where new users are created.

Adding and Deleting Groups
--------------------------

Your can use the ``onegroup`` command line tool to manage groups in OpenNebula. There are two groups created by default, ``oneadmin`` and ``users``.

To create new groups:

.. code::

    $ onegroup list
      ID NAME
       0 oneadmin
       1 users

    $ onegroup create "new group"
    ID: 100
    ACL_ID: 2
    ACL_ID: 3

The new group has ID 100 to differentiate the special groups to the user-defined ones.

When a new group is created, two ACL rules are also created to provide the default behaviour. You can learn more about ACL rules in :ref:`this guide <manage_acl>`; but you don't need any further configuration to start using the new group.

Adding Users to Groups
----------------------

Use the ``oneuser chgrp`` command to assign users to groups.

.. code::

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

.. _manage_users_primary_and_secondary_groups:

Admin Groups
------------

Upon group creation, an associated administration group can be defined. This admin group will contain users with administrative privileges for the associated regular group, not for all the resources in the OpenNebula cloud as the 'oneadmin' group users have. Also, an admin user belonging to both groups can be defined upon creation as well. Another aspect that can be controlled on creation time is the type of resources that group users will be alowed to create. 

This can be managed visually in Sunstone, and can also be managed through the CLI. In the latter, details of the group are passed to the ``onegroup``. This table lists the description of valid attributes when creating a group using ``onegroup``.

+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Attribute      |   M / O   |       Value        |                                                                             Description                                                                              |
+=====================+===========+====================+======================================================================================================================================================================+
| **NAME**            | Mandatory | Any string         | Name that the Group will get. Every group must have a unique name.                                                                                                   |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **RESOURCES**       | Optional  | "+" separated list | List of resources that group members are allowed to create. If not present, it defaults to VM+IMAGE+NET+TEMPLATE                                                     |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_GROUP**     | Optional  | Any string         | Name of the administrator group (if desired). All members of this group would be administrators of the created group.                                                |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_RESOURCES** | Optional  | "+" separated list | List of resources that admin group members are allowed to manage. If not present, it defaults to **RESOURCES**, and if that is missing too, to VM+IMAGE+NET+TEMPLATE |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_USER**      | Optional  | Any string         | Name of the administrator of the group (if desired). This user can only be defined if ADMIN_GROUP is present.                                                        |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_PASSWORD**  | Optional  | Any string         | Password for the group administrator                                                                                                                                 |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_DRIVER**    | Optional  | Any string         | Auth driver for the group administrator                                                                                                                              |
+---------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. code::

    $ onegroup create --name MyGroup -admin_group MyAdminGroup --admin_user MyAdminUser --admin_password MyAdminPassword --admin_driver core --resource VM+TEMPLATE+NET+IMAGE 

.. _managing-resource-provider-within-groups:

Managing Resource Provider within Groups
----------------------------------------

Groups can be assigned with resource providers. A resource provider is an OpenNebula cluster (set of physical hosts and associated datastores and virtual networks) from a particular zone (an OpenNebula instance). A group can be assigned (examples with CLI, but functionality is also available through Sunstone):

* A particular resource provider, for instance cluster 7 of Zone 0

.. code::

    $ onegroup add_provider <group_id> 0 7

* All resources from a particular zone (special cluster id 10)

.. code::

    $ onegroup add_provider <group_id> 0 10

By default a group doesn't have any resource provider, so users won't be entitled to use any resource until explicitly added a resource provider.

To remove resource providers within a group, use the simetric operation "del_provider".

Primary and Secondary Groups
----------------------------

With the commands ``oneuser addgroup`` and ``delgroup`` the administrator can add or delete secondary groups. Users assigned to more than one group will see the resources from all their groups. e.g. a user in the groups testing and production will see VMs from both groups.

The group set with ``chgrp`` is the primary group, and resources (Images, VMs, etc) created by a user will belong to this primary group. Users can change their primary group to any of their secondary group without the intervention of an administrator, using ``chgrp`` again.

Managing Groups in Sunstone
=====================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|image3|

.. |image3| image:: /images/sunstone_group_list.png