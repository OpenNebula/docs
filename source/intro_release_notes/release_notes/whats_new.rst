.. _whats_new:

================================================================================
What's New in 5.8
================================================================================

OpenNebula Core
--------------------------------------------------------------------------------
- **Rename disk snapshots**, there is available an option for renaming disk snapshots via OCA and CLI.
- **Migration through poweroff/on cycle**, new options for cold-migrating a Virtual Machine, now they also can be migrated via poweroff and poweroff hard.

Sunstone
--------------------------------------------------------------------------------
- **More customization**, now the admin can disable the VM advanced options in the :ref:`Cloud View dialogs <cloud_view_config>`.

Networking
--------------------------------------------------------------------------------
- New attribute for the networks called **BRIDGE_TYPE** for defining the brdiging technology used by the driver. More info :ref:`here <devel-nm>`.
- New self-provisioning model for networks, :ref:`Virtual Network Templates <vn_templates>`. Users can now instantiate their own virtual networks from predefined templates with their own addressing.

- Support for NIC Alias. VM's can have more than one IP associated to the same netowrk interface. NIC Alias uses the same interface as regular NIC, e.g. live attach/detach or context support for autoconfiguration. More info :ref:`here <vgg_vn_alias>`.

Virtual Machine management
--------------------------------------------------------------------------------
- **Automatic selection of Virtual Networks** for VM NICs. Based on the usual requirements and rank the Scheduler can pick the rigth Network for a NIC. You can use this feature to balance network usage at deployment time or to reduce clutter in your VM Template list, as you do not need to duplicate VM Templates for different networks. More info :ref:`here <vgg_vm_vnets>`.

vCenter
--------------------------------------------------------------------------------
- Added new configuration file vcenterc, allow you to change the default behaviour in the proccess of image importation. More info :ref:`here <vcenterc_image>`.

Sunstone
----------------------------------------------------------------------------------
- Added flag in view configuration yamls to disable animations in the dashboard widgets.
- Autorefresh has been removed

MarketPlace
--------------------------------------------------------------------------------
- When a MarketPlace appliance is imported into a datastore it is converted to/from vmdk/qcow2 as needed.

API & CLI
--------------------------------------------------------------------------------
- New Python bindings for the OpenNebula Cloud API (OCA). The PyONE addon is now part of the official distribution, more info :ref:`here <python>`
- `one.vm.migrate` now accepts an additional argument to set the type of cold migration (save, poweroff or poweroff hard)

Other Issues Solved
--------------------------------------------------------------------------------
- `Fix issue where a wrong TM_MAD could be used with multiple transfer mode Datastores <https://github.com/OpenNebula/one/issues/2544>`__.
- `Fix issue where only one Ceph monitor was considered on disk attach operations <https://github.com/OpenNebula/one/issues/1955>`__.
- `Fix install.sh script, add missing options <https://github.com/OpenNebula/one/issues/2001>`__.
- `Fix issue regarding saveas operation and CD-ROMs <https://github.com/OpenNebula/one/issues/2610>`__.
- `Fix vcenter persistency with unmanaged disks and imported images <https://github.com/OpenNebula/one/issues/2624>`__.
- `Fix issue Sunstone is not showing well security groups for ICMP6 <https://github.com/OpenNebula/one/issues/2580>`__.
- `Fix issue that prevents to use floating IPs with BRIDGE interfaces <https://github.com/OpenNebula/one/issues/2607>`__.
