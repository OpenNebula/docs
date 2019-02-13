.. _whats_new:

================================================================================
What's New in 5.8
================================================================================

OpenNebula 5.8 (Edge) is the fifth major release of the OpenNebula 5 series. A significant effort has been applied in this release to enhance features introduced in 5.6 Blue Flash, while keeping an eye in implementing those features more demanded by the community. A major highlight of Edge is its focus to support computing on the Edge, bringing the processing power of VMs closer to the consumers to reduce latency. In this regards, Edge comes with the following major features:

- Support for LXD. This enables low resource container orchestration.  LXD containers are ideal to run in low consumption devices closer to the customers.
- Automatic NIC selection. This enhancement of the OpenNebula scheduler will alleviate the burden of VM/container Template management in edge environments where the remote hosts can be potentially heterogeneous, with different network configurations.
- Distributed Data Centers. This feature is key for the edge cloud. OpenNebula now offers the ability to use bare metal providers to build remote clusters in a breeze, without needing to change the workload nature. We are confident that this is a killer feature that sets OpenNebula apart from the direct competitors in the space.
- Scalability improvements. Orchestrating an edge cloud will be demanding in terms of the number of VMs, containers and hypervisors to manage. OpenNebula 5.8 brings to the table a myriad of improvements to the monitoring, pool management and GUI, to deliver a smooth user experience in large scale environments.


This OpenNebula release is named after the edges of nebulas. Nebulas are diffuse objects, and their edges can be considered vacuum. However, they are very thick, so they appear to be dense. This is the aim of OpenNebula 5.8, to provide computing power on a wide geographic surface to offer services closer to customers, building a cloud managed from a single portal over very thin infrastructure. There's an `Edge Nebula <http://freelancer.wikia.com/wiki/Edge_Nebula>`__ on the Freelancer videogame.

The OpenNebula team is now transitioning to "bug-fixing mode". Note that this is a second beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release. Also note that being a beta, there is no migration path from the previous stable version (5.6.1) nor migration path to the final stable version (5.8.0). A `list of open issues <https://github.com/OpenNebula/one/milestone/9>`__ can be found in the GitHub development portal.


.. image:: /images/lxd_screenshot.png
    :width: 90%
    :align: center

OpenNebula Core
--------------------------------------------------------------------------------
- **Rename disk snapshots**, there is now an option available for renaming disk snapshots via OCA and CLI.
- **Migration through poweroff/on cycle**, new options for cold-migrating a Virtual Machine, now they can also be migrated via poweroff and poweroff hard.
- **Mixed mode** for ``ALLOW_ORPHAN`` attribute which takes care of the dependencies between snapshots after revert actions at Ceph datastores.
- Default configuration values for RAFT have been updated to a more conservative setting.
- **Search for virtual machines**, a new option for searching VMs using ``onevm list`` command or ``one.vmpool.info`` API call is available. Find out how to search VM instances :ref:`here <vm_search>`.
- The ``one.vmpool.info`` call now returns a reduce version of the VMs body in order to achive better performance on large environments whit a large number of VMs.

KVM Driver
----------------------------------------------------------------------------------
- **Metadata information** with OpenNebula information is included in the Libvirt domain XML, :ref:`see here <libvirt_metadata>`.

Sunstone
--------------------------------------------------------------------------------
- **More customization**, now the admin can disable the VM advanced options in the :ref:`Cloud View dialogs <cloud_view_config>`.
- Added flag in view configuration yamls to disable animations in the dashboard widgets.
- Autorefresh has been removed

Networking
--------------------------------------------------------------------------------
- New attribute for the networks called **BRIDGE_TYPE** for defining the bridging technology used by the driver. More info :ref:`here <devel-nm>`.
- New self-provisioning model for networks, :ref:`Virtual Network Templates <vn_templates>`. Users can now instantiate their own virtual networks from predefined templates with their own addressing.
- Support for NIC Alias. VM's can have more than one IP associated to the same network interface. NIC Alias uses the same interface as regular NIC, e.g. live attach/detach or context support for autoconfiguration. More info :ref:`here <vgg_vn_alias>`.

Virtual Machine Management
--------------------------------------------------------------------------------
- **Automatic selection of Virtual Networks** for VM NICs. Based on the usual requirements and rank, the Scheduler can pick the right Network for a NIC. You can use this feature to balance network usage at deployment time or to reduce clutter in your VM Template list, as you do not need to duplicate VM Templates for different networks. More info :ref:`here <vgg_vm_vnets>`.
- **LXD hypervisor**. OpenNebula can now manage LXD containers the same way Virtual Machines are managed. Setup an LXD host and use the already present Linux network and storage stack. There are virtualization and monitorization drivers allowing this feature and also a new MarketPlace with a public LXD image server backend. More about this :ref:`here <lxdmg>`.
- **KVM VM snapshots after migration** are now properly restored on the destination host.

vCenter
--------------------------------------------------------------------------------
- Added new configuration file vcenterrc, to allow you to change the default behaviour in the process of image importation. More info :ref:`here <vcenterc_image>`.
- It is now possible to change boot order devices updating the vm template. More info :ref:`here <template_os_and_boot_options_section>`.
- VM migration between clusters and datastores is now supported, :ref:`check here <vcenter_migrate>`.
- It is now possible to migrate images from KVM to vCenter or vice versa. More info :ref:`here <migrate_images>`.

MarketPlace
--------------------------------------------------------------------------------
- When a MarketPlace appliance is imported into a datastore it is converted if needed from qcow2/raw to vmdk.
- Added new :ref:`LXD MarketPlace <market_lxd>`. A sample LXD marketplace will be created in new installations. You can easily create one for existing deployments following the instructions in the :ref:`maketplace guide <market_lxd>`.

API & CLI
--------------------------------------------------------------------------------
- New Python bindings for the OpenNebula Cloud API (OCA). The PyONE addon is now part of the official distribution, more info :ref:`here <python>`
- **Distributed Data Centers** provide tools to build and grow your cloud on bare-metal cloud providers. More info :ref:`here <ddc>`.
- `one.vm.migrate` now accepts an additional argument to set the type of cold migration (save, poweroff or poweroff hard)
- XSD files has been updated and completed
- Pagination can be disabled using ``no-pager`` option.

Storage
--------------------------------------------------------------------------------
- Free space of the KVM hypervisor is now updated faster for SSH and LVM transfer managers by sending HUP signal to collectd client, :ref:`see more here <imudppushg>`. Additionally, you can trigger an information update manually with the ```onehost forceupdate``` command.
- LVM drivers supports configurable zero'ing of allocated volumes to prevent data leaks to other VMs, :ref:`see more here <lvm_driver_conf>`.
- Attaching volatile disk to the VM running on the LVM datastore is now correctly created as logical volume.

Other Issues Solved
--------------------------------------------------------------------------------
- `Fix issue where a wrong TM_MAD could be used with multiple transfer mode Datastores <https://github.com/OpenNebula/one/issues/2544>`__.
- `Fix issue about saving as template virtual machines with vCenter driver <https://github.com/OpenNebula/one/issues/1299>`__.
- `Fix issue about vm monitoring desynchronization in vCenter driver <https://github.com/OpenNebula/one/issues/2552>`__.
- `Fix issue about removing unmanaged nics in vCenter driver <https://github.com/OpenNebula/one/issues/2558>`__.
- `Fix issue not displaying stacktrace in vCenter driver <https://github.com/OpenNebula/one/issues/1826>`__.
- `Fix issue that makes possible to add network interfaces to vCenter templates without any network <https://github.com/OpenNebula/one/issues/2828>`__.
- `Fix issue deploying vCenter templates with unmanaged distributed nic does not work <https://github.com/OpenNebula/one/issues/2835>`__.
- `Fix issue vCenter driver driver do not allow to remove duplicated unmanaged nics from template <https://github.com/OpenNebula/one/issues/2833>`__.
- `Fix issue vCenter driver performs too much reconfigure calls when a machine is deployed <https://github.com/OpenNebula/one/issues/2649>`__.
- `Fix issue Nic model is ignored on vCenter template <https://github.com/OpenNebula/one/issues/2293>`__.
- `Fix issue where delete recursive operation of templates instantiated as persistent does not remove images from the vCenter datastores <https://github.com/OpenNebula/one/issues/1350>`__.
- `Fix issue where only one Ceph monitor was considered on disk attach operations <https://github.com/OpenNebula/one/issues/1955>`__.
- `Fix install.sh script, add missing options <https://github.com/OpenNebula/one/issues/2001>`__.
- `Fix issue regarding saveas operation and CD-ROMs <https://github.com/OpenNebula/one/issues/2610>`__.
- `Fix vCenter persistency with unmanaged disks and imported images <https://github.com/OpenNebula/one/issues/2624>`__.
- `Fix issue Sunstone is not showing well security groups for ICMP6 <https://github.com/OpenNebula/one/issues/2580>`__.
- `Fix issue that prevents to use floating IPs with BRIDGE interfaces <https://github.com/OpenNebula/one/issues/2607>`__.
- `Fix issue with disk-saveas on ubuntu 18.04 <https://github.com/OpenNebula/one/issues/2646>`__.
- `Fix issue with sensitive group-membership matching in LDAP auth <https://github.com/OpenNebula/one/issues/2677>`__.
- `Make use of HTTPS by default in OpenNebula MarketPlace <https://github.com/OpenNebula/one/issues/2668>`__.
- `Fix issue about restoring erasure-coded Ceph VM image from shanshot <https://github.com/OpenNebula/one/issues/2476>`__.
- `Fix CPU_MODEL can't be changed <https://github.com/OpenNebula/one/issues/2820>`__.
- `Fix KVM probe of machines models stuck <https://github.com/OpenNebula/one/issues/2842>`__.
- `Fix create/update of .monitor for local DS monitoring <https://github.com/OpenNebula/one/issues/2767>`__.
- `Fix recover recreate on vCenter: Clear VM DEPLOY ID attribute <https://github.com/OpenNebula/one/issues/2641>`__-
- `Fix remove unmanaged nics leads to vm failure in vCenter <https://github.com/OpenNebula/one/issues/2558>`__.
- `Impossible to create vmgroup using advanced mode <https://github.com/OpenNebula/one/issues/2522>`__.
- `Fix restricted attr disk/size in Sunstone <https://github.com/OpenNebula/one/issues/2533>`__.
- `vCenter: invalidState exception using vm actions <https://github.com/OpenNebula/one/issues/2552>`__.
- `Fix Network model is not working in vCenter <https://github.com/OpenNebula/one/issues/2474>`__.
- `Fix VCENTER_ESX_HOST fail with DRS in vCenter <https://github.com/OpenNebula/one/issues/2477>`__.
- `Fix Case senstive labels in Sunstone <https://github.com/OpenNebula/one/issues/1333>`__.
- `Fix Allow creation of "Empty disk image" for type OS  in Sunstone <https://github.com/OpenNebula/one/issues/1089>`__.
- `Fix auth tokens login in Sunstone, so group scope is preserved <https://github.com/OpenNebula/one/issues/2575>`__.
- `Fix save as template, so disk advanced params are saved in the new template <https://github.com/OpenNebula/one/issues/1312>`__.
- `Wild VM monitoring should not return datastores that contain only swap file <https://github.com/OpenNebula/one/issues/1699>`__.
- `Sunstone dialog automatically select the tab where the error is located in virtual networks update <https://github.com/OpenNebula/one/issues/2711>`__.
- `Fix issue in VR instantiation dialog preventing network selection <https://github.com/OpenNebula/one/issues/2905>`__.
