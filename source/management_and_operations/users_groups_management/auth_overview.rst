.. _auth_overview:

========
Overview
========

OpenNebula includes a complete user & group management system.

The resources a user may access in OpenNebula are controlled by a permissions system that resembles the typical UNIX one. By default, only the owner of a resource can use and manage it. Users can easily share the resources by granting use or manage permissions to other users in her group or to any other user in the system.

Upon group creation, an associated administrator user can be created. By default this user will be able to create users in the new group, and manage non owned resources for the regular group, through the CLI and/or a special Sunstone view. Groups can also be assigned to :ref:`Virtual Data Centers <manage_vdcs>` (VDCs).

OpenNebula comes with a default set of ACL rules that enables a standard usage. For common use cases, you don't need to manage the :ref:`ACL rules <manage_acl>` but they might by useful if you need a high level of permission customization.

By default, the authentication and authorization is handled by the OpenNebula Service as described above. Optionally, you can delegate it to an external module, see the :ref:`Authentication Guide <external_auth>` for more information.

How Should I Read This Chapter
================================================================================

For basic users it's recommended to read at least the ones for **Users**, **Groups** and **Permissions** as they contain the basics on how to control and share access you your resources. The other ones which describe more advanced features that usually are only available for cloud administrators are only recommended for such type of users.

* :ref:`Managing Users <manage_users>`
* :ref:`Managing Groups <manage_groups>`
* :ref:`Managing VDCs <manage_vdcs>`
* :ref:`Managing Permissions and ACLs<chmod>`
* :ref:`Accounting Tool <accounting>`
* :ref:`Showback <showback>`

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
