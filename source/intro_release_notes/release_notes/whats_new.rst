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

..

OpenNebula 5.12 (Firework) is the seventh major release of the OpenNebula 5 series. The main focus has been to write a new monitoring subsystem to support very large scale deployments, as well as several OneFlow improvements. In this line support for NSX-v and NSX-t has been integrated with the Security Groups model in OpenNebula. And other very nice perks!. The highlights of Firework are:

- **New monitoring subsytem**, with separate upgrade intervals for different types of information. This enables the efficient monitoring of large scale deployments with thousands of physical hosts and tens of thousands of virtual machines.
- **OneFlow** has been revamped to use the hook mechanism for VM monitoring rendering significant performance improvements. Also with new functionality like automatic network creation when a service is deployed, support for fenced networking to map an external and internal network as well as batch operations on all VMs of the service or a particular role. The new incarnation of OneFlow reduces times for service deployment (1m to 11s), scaling (1m20s to 15s) and failure (23s to 1s).
- **NSX** integrated with the **Security Groups** functionality. This opens the door to manage inbound/outbound network traffic with L3 rules, using the power of NSX within OpenNebula.
- **Firecracker** support to innovative serverless deployments. Firecracker is a virtual machine manager—responsible for managing lots of tiny virtual machines on a server. Couple the security of the VMs with the agility of containers, combining different workloads with the same OpenNebula instance.
- New ways of remote accesing your VMs in **Sunstone**, better SPICE integration with the possiblity of spawning an external virt-viewer program, as well as the possiblity of automatically autheticating on a Windows VM using a RDP client from Sunstone.

.. image:: /images/virt-viewer-example.png
    :width: 90%
    :align: center

As usual, OpenNebula 5.12 codename refers to a nebula, in this case the `Firework Nebula <https://apod.nasa.gov/apod/ap980704.html>`__, the result of a type of stellar explosion called a nova. In a nova, a nuclear detonation on the surface of a compact white dwarf star blasts away material that has been dumped on its surface by a companion star. Also known as GK Persei or Nova Persei, this nova became one of the brightest stars in the night sky in the year 1901. As bright as your OpenNebula cloud :).

The OpenNebula team is now transitioning to "bug-fixing mode". Note that this is a first beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release. Also note that being a beta, there is no migration path from the previous stable version (5.10.4) nor migration path to the final stable version (5.12.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/28>`__.

In the following list you can check the highlights of OpenNebula 5.12 (a detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/28?closed=1>`__):

OpenNebula Core
================================================================================
- **PostgreSQL Backend** is now supported as Technology Preview, see :ref:`here <postgresql>`.
- **Better Hostname Detection**. Now OpenNebula reads the FQDN of the hostname. It can also be configured in ``oned.conf``.
- **SSH agent integration** - Added a new service ``opennebula-ssh-agent`` and with it the need to copy around a private SSH key was removed.

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
- Support for RDP in alias interfaces. Check :ref:`this <rdp_sunstone>` for more information.
- RDP links available in VMs table.
- Support for Virt-Viewer links. Check :ref:`this <remote_access_sunstone>` for more information.
- Support for nic alias in Sunstone service dialog. Check :ref:`this <appflow_use_cli_networks>` for more information.
- Support for VM Charter. Check :ref:`this <vm_charter>` for more information.
- Universal 2nd Factor authentication using WebAuthn (for U2F/FIDO2 keys). Check :ref:`this <2f_auth>` for more information.
- Administrator accounts :ref:`passwords <change_credentials>` can't be changed via Sunstone.
- Make Suntone color thresholds configurable. Check :ref:`this <sunstone_branding>` for more information.
- Add force remove of :ref:`address ranges <manage_vnets>`.
- Now is possible to update existing :ref:`Schedule Actions <schedule_actions>`.
- Search box for :ref:`Wilds VMs <import_wild_vms>`.


Scheduler
================================================================================

- New actions have been added as a scheduled actions, in particular: ``snapshot-revert``, ``snapshot-delete``, ``disk-snapshot-create``, ``disk-snapshot-revert``, ``disk-snapshot-delete``. Check :ref:`this <vm_instances>` for more information.

Disaggregated Data Centers
================================================================================
- Provision support of other object types. Refer to :ref:`this <ddc_virtual>` for more information.
- Provision templates can extends multiple ones. Refer to :ref:`this <ddc_usage_example6>` for more information.
- Provision templates supports multiple playbooks. Refer to :ref:`this <ddc_usage_example7>` for more information.
- New examples of complete clusters, check them :ref:`here <ddc_provision_cluster_templates>`.

OneFlow & OneGate
===============================================================================
- The OneFlow component has been revamped to improve its performance. This revamp has been made in terms of times, so we have reduced a lot the time that each operations consumes. The API is the same as it was before. Click :ref:`here <appflow_use_cli>` to check more information about this component.
- **OneFlow template** can be :ref:`cloned <service_clone>`, optionally in a recursive fashion so all the VM Templates and images are cloned as well
- OneFlow sched actions at service level. Refer to :ref:`this <flow_sched>` for more information.

CLI
================================================================================
- Functionality to read database credentials from ``oned.conf`` when using ``onedb`` command has been added.

Packaging
================================================================================
- Bundled Ruby gem dependencies are `distributed as a single <https://github.com/OpenNebula/packages/issues/141>`_ package **opennebula-rubygems**.
- Use of bundled Ruby gems is now even more `isolated <https://github.com/OpenNebula/one/issues/4304>`_ from the rest of the system.
- `Logrotate configurations don't change global settings <https://github.com/OpenNebula/one/issues/4557>`_.

VMware Virtualization driver
===============================================================================
- **vCenter Resource pool tab**, within the host individual view a new tab displays the information of all :ref:`resource pools <vcenter_resource_pool>` defined in the vCenter cluster corresponding to the OpenNebula host.
- Monitoring the physical path of the disks inside the vCenter datastore. :ref:`Monitoring Attributes <vm_monitoring_attributes_vcenter>`.
- Differentiate created :ref:`Virtual Machine Templates <vm_templates>` on vCenter.
- Option to create :ref:`Tags and Categories <vcenter_tags_and_categories>` on vCenter.
- Preparing vCPU for numa and pinning adding the option to define the :ref:`number of cores per socket <numa_topology_section>` on vCenter using CORES attribute.
- Support for attach and detach NIC operations in poweroff state.
- Define Virtual Cores per Socket on vCenter VM. Check :ref:`this <numa>` for more information. 

KVM Virtualization Driver
================================================================================

- ...

Hybrid Virtualization
================================================================================
- :ref:`Azure driver <azg>` was refactored to use Azure Resource Manager deployment

Containers
==========

- **docker-machine-driver-opennebula**, is updated to support latest :ref:`Rancher <rancher_tutorial>` version.
- TODO: Firecracker

Other Issues Solved
================================================================================
- `Fixed capacity bars in Clusters and Host when user reserve CPU and Memory <https://github.com/OpenNebula/one/issues/4256>`_.
- `LXD Template Wizard: Clean OS & CPU section <https://github.com/OpenNebula/one/issues/3025>`_.
- `Template Wizard: Change fieldname of target device to mountpoint when hypervisor LXD <https://github.com/OpenNebula/one/issues/3024>`_.
- `LXD Marketplace attributes <https://github.com/OpenNebula/one/issues/3059>`_.
- `Fixed network is lost after making a save as template <https://github.com/OpenNebula/one/issues/4284>`_.
- `Fixed edit vCenter virtual network context fails <https://github.com/OpenNebula/one/issues/3675>`_.
- `Fixed vRouter not showing floating IP <https://github.com/OpenNebula/one/issues/4147>`_.
- `Added asynchronous retry of KVM time sync <https://github.com/OpenNebula/one/issues/4508>`_.
- `Fix wrong PCI to VM association when undeploying and terminating a VM with PCI pass-through <https://github.com/OpenNebula/one/issues/3964>`__.
- `Fixed disable instantiate options in Sunstone <https://github.com/OpenNebula/one/issues/3604>`_.
- `Fixed VROUTER_KEEPALIVED_ID = 0 <https://github.com/OpenNebula/one/issues/4220>`_.
