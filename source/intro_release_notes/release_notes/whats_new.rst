.. _whats_new:

================================================================================
What's New in 5.8
================================================================================

OpenNebula Core
--------------------------------------------------------------------------------
- **Rename disk snapshots**, there is available an option for renaming disk snapshots via OCA and CLI.

Sunstone
--------------------------------------------------------------------------------
- **More customization**, now the admin can disable the VM advanced options in the :ref:`Cloud View dialogs <cloud_view_config>`.

Networking
--------------------------------------------------------------------------------
- New attribute for the networks called **BRIDGE_TYPE** for defining the brdiging technology used by the driver. More info :ref:`here <devel-nm>`.

Virtual Machine management
--------------------------------------------------------------------------------
- Automatic selection of Virtual Networks for VM NICs. Based on the usual requirements and rank the Scheduler can pick the rigth Network for a NIC. You can use this feature to balance network usage at deployment time or to reduce clutter in your VM Template list, as you do not need to duplicate VM Templates for different networks. More info :ref:`here <vgg_vm_vnets>`.

Sunstone
----------------------------------------------------------------------------------
- Added flag in view configuration yamls to disable animations in the dashboard widgets.
- Autorefresh is only performed on the information tab of the VirtualMachines.

Other Issues Solved
--------------------------------------------------------------------------------
- `Fix issue where a wrong TM_MAD could be used with multiple transfer mode Datastores <https://github.com/OpenNebula/one/issues/2544>`__.
- `Fix issue where only one Ceph monitor was considered on disk attach operations <https://github.com/OpenNebula/one/issues/1955>`__.
