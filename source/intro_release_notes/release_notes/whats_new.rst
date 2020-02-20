.. _whats_new:

================================================================================
What's New in 5.11
================================================================================

..
   Conform to the following format for new features.
   Big/important features follow this structure
   - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
   Minor features are added in a separate block in each section as:
   - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

...

OpenNebula Core
================================================================================
- ...

Storage
--------------------------------------------------------------------------------
- ...

Networking
--------------------------------------------------------------------------------
- ...


Authentication
--------------------------------------------------------------------------------

- **Group admins for LDAP driver**, when configuring your LDAP driver you can define *group_admin_group_dn* which will cause that members of that group will be group admins of all the mapped LDAP group in OpenNebula :ref:`LDAP driver <ldap>`


Sunstone
--------------------------------------------------------------------------------
- ...

vCenter
===============================================================================
- **vCenter Resource pool tab**, within the host individual view a new tab displays the information of all :ref:`resource pools <vcenter_resource_pool>` defined in the vCenter cluster corresponding to the OpenNebula host.

OneFlow & OneGate
===============================================================================
- ...

CLI
================================================================================
- ...

Packaging
================================================================================
- ...

KVM Monitoring Drivers
================================================================================

- ...

KVM Virtualization Driver
================================================================================

- ...

Hybrid Virtualization
================================================================================
- :ref:`Azure driver <azg>` was refactored to use Azure Resource Manager deployment


Other Issues Solved
================================================================================

- `Description <https://github.com/OpenNebula/one/issues/XXXX>`_.
