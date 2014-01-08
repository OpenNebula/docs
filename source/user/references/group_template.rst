.. _group_template:

==========================
Group Definition Template
==========================

This page describes how to define a new group template. A group template follows the same syntax as the :ref:`VM template <template>`.

If you want to learn more about groups, you can do so :ref:`here <manage_users_groups>`.


Template Attributes
===================

The following attributes can be defined in the group template.

+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|         Attribute          |   M / O   |       Value        |                                                                             Description                                                                              |
+============================+===========+====================+======================================================================================================================================================================+
| **NAME**                   | Mandatory | Any string         | Name that the Group will get. Every group must have a unique name.                                                                                                   |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **RESOURCES**              | Optional  | "+" separated list | List of resources that group members are allowed to create. If not present, it defaults to VM+IMAGE+NET+TEMPLATE                                                     |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_GROUP**            | Optional  | Any string         | Name of the administrator group (if desired). All members of this group would be administrators of the created group.                                                |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_GROUP_RESOURCES**  | Optional  | "+" separated list | List of resources that admin group members are allowed to manage. If not present, it defaults to **RESOURCES**, and if that is missing too, to VM+IMAGE+NET+TEMPLATE |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_MANAGE_USERS**     | Optional  | "YES" or "NO"      | List of resources that admin group members are allowed to manage. If not present, it defaults to **RESOURCES**, and if that is missing too, to VM+IMAGE+NET+TEMPLATE |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_USER_NAME**        | Optional  | Any string         | Name of the administrator of the group (if desired)                                                                                                                  |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_USER_PASSWORD**    | Optional  | Any string         | Password for the group administrator                                                                                                                                 |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ADMIN_USER_AUTH_DRIVER** | Optional  | Any string         | Auth driver for the group administrator                                                                                                                              |
+----------------------------+-----------+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Template Examples
=================

Example of a group template, with an associated admin group and admin user:

.. code::

    NAME = MyGroup
    ADMIN_GROUP = MyAdminGroup
    ADMIN_USER_NAME = MyAdminUser
    ADMIN_USER_PASSWORD = MyAdminPassword
    ADMIN_USER_AUTH_DRIVER = Core
    RESOURCES = VM+TEMPLATE+NET+IMAGE      # This is the default if nothing is declared explicitly
