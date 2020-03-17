.. _whats_new:

================================================================================
What's New in 5.12
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
- **Security Groups** are now supported on NSX-T and NSX-V networks. Check :ref:`NSX Setup <nsx_setup>` for initial requirements and the :ref:`Security Groups Operation Guide <security_groups>` to learn how to operate with them. For more details about this integration go to :ref:`NSX Driver <nsx_driver>`


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
- `OneFlow revamp <https://github.com/OpenNebula/one/issues/4132>`__.
- `OneFlow template cloning recursively <https://github.com/OpenNebula/one/issues/4287>`__.

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

VMware Virtualization driver
================================================================================
- Support for attach and detach NIC operations in poweroff state

Other Issues Solved
================================================================================

- `Description <https://github.com/OpenNebula/one/issues/XXXX>`_.
