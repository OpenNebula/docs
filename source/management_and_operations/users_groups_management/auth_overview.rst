.. _auth_overview:

========
Overview
========

OpenNebula includes a complete user & group management system. Users in an OpenNebula installation are classified in four types:

* **Administrators**, an admin user belongs to an admin group (oneadmin or otherwise) and can perform manage operations
* **Regular users**, that may access most OpenNebula functionality.
* **Public users**, only basic functionality (and public interfaces) are open to public users.
* **Service users**, a service user account is used by the OpenNebula services (i.e. cloud APIs like EC2 or GUI's like Sunstone) to proxy auth requests.

The resources a user may access in OpenNebula are controlled by a permissions system that resembles the typical UNIX one. By default, only the owner of a resource (e.g. a VM or an image) can use and manage it. Users can easily share the resources by granting use or manage permissions to other users in her group or to any other user in the system.

Upon group creation, an associated admin user can be created. By default this user will be able to create users in the new group, and manage non owned resources for the regular group, through the CLI and/or a special Sunstone view. This group can also be assigned to VDC, what is basically a pool of OpenNebula physical resources (hosts, datastores and virtual networks).

Along with the users & groups the Auth Subsystem is responsible for the authentication and authorization of user's requests.

Any interface to OpenNebula (CLI, Sunstone, Ruby or Java OCA) communicates with the core using XML-RPC calls, that contain the user's session string, which is authenticated by the OpenNebula core comparing the username and password with the registered users.

Each operation generates an authorization request that is checked against the registered ACL rules. The core then can grant permission, or reject the request.

OpenNebula comes with a default set of ACL rules that enables a standard usage. You don't need to manage the ACL rules unless you need the level of permission customization if offers.

By default, the authentication and authorization is handled by the OpenNebula Core as described above. Optionally, you can delegate it to an external module, see the :ref:`Authentication Guide <external_auth>` for more information.


How Should I Read This Chapter
================================================================================

From these guides you should read at least the ones for **Users**, **Groups** and **Permissions** as are the basis for any cloud:

* :ref:`Managing Users <manage_users>`
* :ref:`Managing Groups <manage_groups>`
* :ref:`Managing VDCs <manage_vdcs>`
* :ref:`Managing Permissions <chmod>`
* :ref:`Accounting Tool <accounting>`
* :ref:`Showback <showback>`
* :ref:`Managing ACL Rules <manage_acl>`
* :ref:`Quota Management <quota_auth>`


Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
