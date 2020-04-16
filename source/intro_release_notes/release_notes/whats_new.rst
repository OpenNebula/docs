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
- `Force option to remove address ranges (AR) with leases <https://github.com/OpenNebula/one/issues/4132>`__: ``onevnet rmar`` supports optional ``--force`` flag, which forces AR removal even if active leases exists


Authentication
--------------------------------------------------------------------------------

- **Group admins for LDAP driver**, when configuring your LDAP driver you can define *group_admin_group_dn* which will cause that members of that group will be group admins of all the mapped LDAP group in OpenNebula :ref:`LDAP driver <ldap>`


Sunstone
--------------------------------------------------------------------------------
- Support for RDP in alias interfaces. Check :ref:`this <sunstone_rdp_troubleshootings>` for more information.
- RDP links available in VMs table.
- Support for nic alias in Sunstone service dialog. Check :ref:`this <appflow_use_cli_networks>` for more information.
- Support for VM Charter. Check :ref:`this <vm_charter>` for more information.

Scheduler
================================================================================

- New actions have been added as a scheduled actions, in particular: ``snapshot-revert``, ``snapshot-delete``, ``disk-snapshot-create``, ``disk-snapshot-revert``, ``disk-snapshot-delete``. Check :ref:`this <vm_instances>` for more information.

Disaggregated Data Centers
================================================================================
- Provision support of other object types. Refer to :ref:`this <ddc_virtual>` for more information.
- Provision templates can extends multiple ones. Refer to :ref:`this <ddc_usage_example6>` for more information.
- Provision templates supports multiple playbooks. Refer to :ref:`this <ddc_usage_example7>` for more information.

vCenter
===============================================================================
- **vCenter Resource pool tab**, within the host individual view a new tab displays the information of all :ref:`resource pools <vcenter_resource_pool>` defined in the vCenter cluster corresponding to the OpenNebula host.
- **docker-machine-driver-opennebula**, is updated to support latest :ref:`Rancher <rancher_tutorial>` version.
- Monitoring the physical path of the disks inside the vCenter datastore. :ref:`Monitoring Attributes <vm_monitoring_attributes_vcenter>`.

OneFlow & OneGate
===============================================================================
- The OneFlow component has been revamped to improve its performance. This revamp has been made in terms of times, so we have reduced a lot the time that each operations consumes. The API is the same as it was before. Click :ref:`here <appflow_use_cli>` to check more information about this component.
- `OneFlow template cloning recursively <https://github.com/OpenNebula/one/issues/4287>`__.
- OneFlow sched actions at service level. Refer to :ref:`this <flow_sched>` for more information.

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
- `Fixed capacity bars in Clusters and Host when user reserve CPU and Memory <https://github.com/OpenNebula/one/issues/4256>`_.
- `LXD Template Wizard: Clean OS & CPU section <https://github.com/OpenNebula/one/issues/3025>`_.
- `Template Wizard: Change fieldname of target device to mountpoint when hypervisor LXD <https://github.com/OpenNebula/one/issues/3024>`_.
- `LXD Marketplace attributes <https://github.com/OpenNebula/one/issues/3059>`_.
- `Fixed network is lost after making a save as template <https://github.com/OpenNebula/one/issues/4284>`_.
- `Fixed edit vCenter virtual network context fails <https://github.com/OpenNebula/one/issues/3675>`_.
