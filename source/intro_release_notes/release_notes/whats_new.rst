.. _whats_new:

================================================================================
What's New in 5.8
================================================================================

OpenNebula 5.8 (Edge) is the fifth major release of the OpenNebula 5 series. A significant effort has been applied in this release to enhance features introduced in 5.6 Blue Flash, while keeping an eye in implementing those features more demanded by the community. A major highlight of Edge is its focus to support computing on the Edge, bringing the processing power of VMs closer to the consumers to reduce latency. In this regards, Edge comes with the following major features:

- Support for LXD This enables low resource containers orchestration, which are ideal to run in low consumption devices closer to the customers.
- Automatic NIC selection. This enhancement of the OpenNebula scheduler will alleviate the burden of VM/container Template management in edge environments where the remote hosts can be potentially heterogeneous, with different network configurations.
- Distributed Data Centers. This feature is key for the edge cloud. OpenNebula now offers the ability to use bare metal providers to build remote clusters in a breeze, without needing to change the workload nature. We are confident that this is a killer feature that sets OpenNebula apart from the direct competitors in the space.
- Scalability improvements. Orchestrating an edge cloud will be demanding in terms of number of VMs, containers and hypervisors to manage. OpenNebula 5.8 brings to the table a myriad of improvements in terms of monitoring, pool management and GUI, to deliver a smooth user experience in large scale environments.


This OpenNebula release is named after the edges of nebulas. Nebulas are diffuse objects, and their edges can be considered vacuum. However, they are very thick, so they appear to be dense. This is the aim of OpenNebula 5.8, to provide computing power on a wide geographic surface to offer services closer to customers, building a cloud managed from a single portal over very thin infrastructure. There's an `Edge Nebula <http://freelancer.wikia.com/wiki/Edge_Nebula>` on the Freelancer videogame.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release. Note that being a beta there is no migration path from the previous stable version (5.6.1) nor migration path to the final stable version (5.8.0). A <a href=https://github.com/OpenNebula/one/milestone/9>list of open issues</a> can be found in the GitHub development portal.


OpenNebula Core
--------------------------------------------------------------------------------
- **Rename disk snapshots**, there is available an option for renaming disk snapshots via OCA and CLI.
- **Migration through poweroff/on cycle**, new options for cold-migrating a Virtual Machine, now they also can be migrated via poweroff and poweroff hard.
- **Mixed mode** for ``ALLOW_ORPHAN`` attribute which take care of the dependencies between snapshots after revert actions at Ceph datastores.
- Default configuration values for RAFT has been updated to a more conservative setting.

Sunstone
--------------------------------------------------------------------------------
- **More customization**, now the admin can disable the VM advanced options in the :ref:`Cloud View dialogs <cloud_view_config>`.
- Added flag in view configuration yamls to disable animations in the dashboard widgets.
- Autorefresh has been removed

Networking
--------------------------------------------------------------------------------
- New attribute for the networks called **BRIDGE_TYPE** for defining the bridging technology used by the driver. More info :ref:`here <devel-nm>`.
- New self-provisioning model for networks, :ref:`Virtual Network Templates <vn_templates>`. Users can now instantiate their own virtual networks from predefined templates with their own addressing.

- Support for NIC Alias. VM's can have more than one IP associated to the same netowrk interface. NIC Alias uses the same interface as regular NIC, e.g. live attach/detach or context support for autoconfiguration. More info :ref:`here <vgg_vn_alias>`.

Virtual Machine Management
--------------------------------------------------------------------------------
- **Automatic selection of Virtual Networks** for VM NICs. Based on the usual requirements and rank the Scheduler can pick the right Network for a NIC. You can use this feature to balance network usage at deployment time or to reduce clutter in your VM Template list, as you do not need to duplicate VM Templates for different networks. More info :ref:`here <vgg_vm_vnets>`.

- **LXD hypervisor**. OpenNebula can now manage LXD containers the same way Virtual Machines are managed. Setup a LXD host and use the already present Linux network and storage stack. There are virtualization and monitorization drivers allowing this feature and also a new MarketPlace with a public LXD image server backend.

vCenter
--------------------------------------------------------------------------------
- Added new configuration file vcenterrc, allow you to change the default behaviour in the process of image importation. More info :ref:`here <vcenterc_image>`.
- It is possible to change boot order devices updating the vm template. More info :ref:`here <template_os_and_boot_options_section>`.
- VM migration between clusters and datastores is now supported, :ref:`check here <vcenter_migrate>`.

MarketPlace
--------------------------------------------------------------------------------
- When a MarketPlace appliance is imported into a datastore it is converted to/from vmdk/qcow2 as needed.
- Added  :ref:`LXD MarketPlace <market_lxd>`.

API & CLI
--------------------------------------------------------------------------------
- New Python bindings for the OpenNebula Cloud API (OCA). The PyONE addon is now part of the official distribution, more info :ref:`here <python>`
- **Distributed Data Centers** provide tools to build and grow your cloud on bare-metal cloud providers. More info :ref:`here <ddc>`.
- `one.vm.migrate` now accepts an additional argument to set the type of cold migration (save, poweroff or poweroff hard)
- XSD files has been updated and completed
- Pagination can be disabled using ``no-pager`` option.

Other Issues Solved
--------------------------------------------------------------------------------
- `Fix issue where a wrong TM_MAD could be used with multiple transfer mode Datastores <https://github.com/OpenNebula/one/issues/2544>`__.
- `Fix issue about vm monitoring desynchronization in vCenter driver <https://github.com/OpenNebula/one/issues/2552>`__.
- `Fix issue about removing unmanaged nics in vCenter driver <https://github.com/OpenNebula/one/issues/2558>`__.
- `Fix issue where only one Ceph monitor was considered on disk attach operations <https://github.com/OpenNebula/one/issues/1955>`__.
- `Fix install.sh script, add missing options <https://github.com/OpenNebula/one/issues/2001>`__.
- `Fix issue regarding saveas operation and CD-ROMs <https://github.com/OpenNebula/one/issues/2610>`__.
- `Fix vcenter persistency with unmanaged disks and imported images <https://github.com/OpenNebula/one/issues/2624>`__.
- `Fix issue Sunstone is not showing well security groups for ICMP6 <https://github.com/OpenNebula/one/issues/2580>`__.
- `Fix issue that prevents to use floating IPs with BRIDGE interfaces <https://github.com/OpenNebula/one/issues/2607>`__.
- `Fix issue with disk-saveas on ubuntu 18.04 <https://github.com/OpenNebula/one/issues/2646>`__.
- `Fix issue with sensitive group-membership matching in LDAP auth <https://github.com/OpenNebula/one/issues/2677>`__.
- `Make use of HTTPS by default in OpenNebula MarketPlace <https://github.com/OpenNebula/one/issues/2668>`__.
- `Fix issue about restoring erasure-coded Ceph VM image from shanshot <https://github.com/OpenNebula/one/issues/2476>`__.
