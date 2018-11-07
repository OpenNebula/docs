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
- New possibility to define a new form to add a NIC to a Virtual Machine, you can set a NIC with new attribute NETWORK_MODE = "auto" and OpenNebula, concretly the Scheduler will pick the NETWORK for this NIC. Also you can define REQUIREMENTS or RANK to pick the NETWORK. More info :ref:`here <vgg_vm_vnets>`.
