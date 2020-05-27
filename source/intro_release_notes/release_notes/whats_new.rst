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

OpenNebula 5.12 (Firework) is the seventh stable release of the OpenNebula 5 series. The main focus has been to better support cloud infrastructures with several thousands of physical hosts, running tens of thousands of VMs, distributed cloud/edge and HA deployments, and micro-VMs for innovative serverless deployments and secure multi-tenant container-based services.

There are plenty of very nice perks! The highlights of “Firework” are:

- The `much-announced integration <https://opennebula.io/opennebula-firecracker-building-the-future-of-on-premises-serverless-computing/>`__ with **Firecracker** for supporting innovative serverless deployments. Firecracker is a virtual machine manager widely used by Amazon Web Services (AWS) and designed for managing lots of tiny virtual machines (micro-VMs) on a server. Here you can couple the security of traditional VMs with the agility of containers, combining different workloads on the same OpenNebula instance.

- It also brings seamless integration with the **Docker Hub Marketplace**, permitting direct execution of Docker Hub images using KVM/LXD/Firecracker hypervisors in your OpenNebula cloud. This brings all of the current application container management right square in-line with OpenNebula.

- **New monitoring subsystem**, able to **scale to thousands of physical hosts and tens of thousands of VMs** and better **support hypervisors at cloud/edge locations and HA deployments**. This re-design decouples DB access for monitoring and VM/Host data to improve *oned* response time and overall monitor processing time. Additionally, the host monitor agents have been improved to better report VM state changes and optimize network usage.

- **OneFlow has been revamped** to use the hook mechanism for VM monitoring rendering significant performance improvements. It also includes new functionality like automatic network creation when a service is deployed, support for fenced networking to map an external and internal network, as well as batch operations on all VMs of the service or a particular role. The new incarnation of OneFlow **reduces times for service deployment (1m to 11s), scaling (1m20s to 15s) and failure (23s to 1s)**.

- **NSX integrated with the Security Groups functionality**. This opens the door to manage inbound/outbound network traffic with L3 rules, using the power of NSX within OpenNebula.

- **New ways of remote accessing your VMs in Sunstone**. Better SPICE integration with the possibility of spawning an external virt-viewer program, as well as the possibility of automatically authenticating on a Windows VM using a RDP client from Sunstone.

.. image:: /images/virt-viewer-example.png
    :width: 90%
    :align: center

As usual, the OpenNebula 5.12 codename refers to a nebula, in this case the `Firework Nebula <https://opennebula.io/the-firework-nebula/>`__, the result of a type of stellar explosion called a nova. In a nova, a nuclear detonation on the surface of a compact white dwarf star blasts away material that has been dumped on its surface by a companion star. Also known as GK Persei or Nova Persei 1901, this nova became one of the brightest stars in the night sky in the year 1901—almost as bright as your OpenNebula cloud ;). More on this in this `excellent blog post <https://opennebula.io/the-firework-nebula/>`__.

The OpenNebula team is now transitioning to "bug-fixing mode". Note that this is a second beta release aimed at testers and developers to try the new features, and we welcome you to send feedback for the final release. Please check the :ref:`known issues <known_issues>` before submitting an `issue through GitHub <https://github.com/OpenNebula/one/issues/new?template=bug_report.md>`__. Also note that for this version there is no migration path from the previous stable version (5.10.5) nor migration path to the final stable version (5.12.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/28>`__.

In the following list you can check the highlights of OpenNebula 5.12 (a detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/28?closed=1>`__):

OpenNebula Core
================================================================================

- **PostgreSQL Backend** is now supported as Technology Preview, see :ref:`here <postgresql>`.
- **Better Hostname Detection**. Now OpenNebula reads the FQDN of the hostname. It can also be configured in ``oned.conf``.
- :ref:`SSH agent integration <kvm_ssh>` - A secure way to delegate private SSH keys from front-end to hosts without needing to distribute secrets across hosts.
- **Monitoring** new monitoring system check :ref:`Monitoring <mon>` for more information.

Networking
================================================================================
- **Security Groups** are now supported on NSX-T and NSX-V networks. Check :ref:`NSX Setup <nsx_setup>` for initial requirements and the :ref:`Security Groups Operation Guide <security_groups>` to learn how to operate with them. For more details about this integration go to :ref:`NSX Driver <nsx_driver>`.
- `Force option to remove address ranges (AR) with leases <https://github.com/OpenNebula/one/issues/4132>`__: ``onevnet rmar`` supports optional ``--force`` flag, which forces AR removal even if active leases exist.
- `Added **route metrics** support per network interface where default gateway is set <https://github.com/OpenNebula/addon-context-linux/issues/83>`_


Authentication
================================================================================

- **Group admins for LDAP driver**, when configuring your LDAP driver you can define *group_admin_group_dn* which will cause that members of that group will be group admins of all the mapped LDAP group in OpenNebula :ref:`LDAP driver <ldap>`


Sunstone
================================================================================

- Support for RDP in alias interfaces. Check :ref:`this <rdp_sunstone>` for more information.
- RDP links are available in VMs table.
- Support for Virt-Viewer links. Check :ref:`this <remote_access_sunstone>` for more information.
- Support for nic alias in Sunstone service dialog. Check :ref:`this <appflow_use_cli_networks>` for more information.
- Support for VM Charter. Check :ref:`this <vm_charter>` for more information.
- Universal 2nd Factor authentication using WebAuthn (for U2F/FIDO2 keys). Check :ref:`this <2f_auth>` for more information.
- Administrator accounts :ref:`passwords <change_credentials>` can't be changed via Sunstone.
- Make Sunstone color thresholds configurable. Check :ref:`this <sunstone_branding>` for more information.
- Add force remove of :ref:`address ranges <manage_vnets>`.
- Now it is possible to update existing :ref:`Schedule Actions <schedule_actions>`.
- Search box for :ref:`Wilds VMs <import_wild_vms>`.
- MarketplaceApp now considers the app state :ref:`to download it <marketapp_download>`.
- Show more than 2 IPs in a dropdown list on instantiated VMs table. Check :ref:`this <manage_vnets>` for more information.
- Template attributes called **LINK** will be represented as hyperlinks. Check :ref:`this <link_attribute_sunstone>` for more information.
- Disable network, interface type and RDP connection when instantiate template. Check :ref:`this <sunstone_template_section>` for more information.
- Add custom paginate for cloud view. Check :ref:`this <sunstone_sunstone_server_conf>` for more information.
- Add buttons on VNets to add and remove Security Groups. Check :ref:`this <security_groups>` for more information.
- Add force IPv4 on Cloud View. Check :ref:`this <force_ipv4_sunstone>` for more information.
- Keep state on VMs nics table. Check :ref:`this <vm_guide2_nic_hotplugging>` for more information.
- Add TB unit to disks. Check :ref:`this <vm_disks>` for more information.
- Add VM name in VNet leases. Check :ref:`this <add_and_delete_vnet>` for more information.
- Move NSX specific attributes to NSX tab. Check :ref:`this <nsx_autodiscovered_attributes>` for more information.

Scheduler
================================================================================

- New actions have been added as scheduled actions, in particular: ``snapshot-revert``, ``snapshot-delete``, ``disk-snapshot-create``, ``disk-snapshot-revert``, ``disk-snapshot-delete``. Check :ref:`this <vm_instances>` for more information.

Disaggregated Data Centers
================================================================================
- Provision support of other object types. Refer to :ref:`this <ddc_virtual>` for more information.
- Provision templates can extends multiple ones. Refer to :ref:`this <ddc_usage_example6>` for more information.
- Provision templates supports multiple playbooks. Refer to :ref:`this <ddc_usage_example7>` for more information.
- New examples of complete clusters, check them :ref:`here <ddc_provision_cluster_templates>`.

OneFlow & OneGate
===============================================================================
- The OneFlow component has been revamped to improve its performance. This revamp has been made in terms of elapsed time, so we have reduced a lot of the time that each operations consumes. The API is the same as it was before. Click :ref:`here <appflow_use_cli>` to check more information about this component.
- **OneFlow template** can be :ref:`cloned <service_clone>`, optionally in a recursive fashion so all the VM Templates and images are cloned, as well.
- OneFlow sched actions at service level. Refer to :ref:`this <flow_sched>` for more information.
- Now with OneGate you can update template with string with white spaces. Check more information about OneGate :ref:`here <onegate_usage>`.

CLI
================================================================================
- Functionality to read database credentials from ``oned.conf`` when using ``onedb`` command has been added.
- You can now filter data by hidden columns, e.g: ``onevm list --filter HOST=localhost --list ID,NAME``

Packaging
================================================================================
- Bundled Ruby gem dependencies are `distributed as a single <https://github.com/OpenNebula/packages/issues/141>`_ package **opennebula-rubygems**.
- Use of bundled Ruby gems is now even more `isolated <https://github.com/OpenNebula/one/issues/4304>`_ from the rest of the system.
- `Logrotate configurations don't change global settings <https://github.com/OpenNebula/one/issues/4557>`_.

VMware Virtualization driver
===============================================================================
- **vCenter Resource pool tab**, within the host individual view a new tab displays the information of all :ref:`resource pools <vcenter_resource_pool>` defined in the vCenter cluster corresponding to the OpenNebula host.
- Monitoring the physical path of the disks inside the vCenter datastore - :ref:`Monitoring Attributes <vm_monitoring_attributes_vcenter>`.
- Differentiate created :ref:`Virtual Machine Templates <vm_templates>` on vCenter.
- Option to create :ref:`Tags and Categories <vcenter_tags_and_categories>` on vCenter.
- Preparing vCPU for numa and pinning, adding the option to define the :ref:`number of cores per socket <numa_topology_section>` on vCenter using CORES attribute.
- Support for attach and detach NIC operations in poweroff state.
- Define Virtual Cores per Socket on vCenter VM. Check :ref:`this <numa>` for more information.

Hybrid Virtualization
================================================================================
- :ref:`Azure driver <azg>` was refactored to use Azure Resource Manager deployment.

Containers
==========

- **docker-machine-driver-opennebula**, is updated to support latest :ref:`Rancher <rancher_tutorial>` version.

MicroVMs
========

- MicroVMs are supported via the new **Firecracker** hypervisor. More information can be found in the :ref:`Firecracker Driver <fcmg>` guide.
- New :ref:`DockerHub Marketplace <market_dh>` have been added in order to easily provide images for MicroVMs.

Other Issues Solved
================================================================================
- `Fixed capacity bars in Clusters and Host when user reserves CPU and Memory <https://github.com/OpenNebula/one/issues/4256>`_.
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
- `Fixed limit the sunstone notification box content size <https://github.com/OpenNebula/one/issues/2126>`_.
- `Fixed real used cpu should use real total cpu as base <https://github.com/OpenNebula/one/issues/1756>`_.
- `Make LXD marketplace Apps compatible only with LXD hypervisor by default <https://github.com/OpenNebula/one/issues/4669>`_.
- `Validate RAW/DATA section with libvirt xml schema <https://github.com/OpenNebula/one/issues/3953>`_.
- `Added systemd timer job to compute showback every night <https://github.com/OpenNebula/one/issues/865>`_.
- `Allow unselect row when previously selected in Sunstone <https://github.com/OpenNebula/one/issues/4697>`_.
- `Fixed host widget in sunstone <https://github.com/OpenNebula/one/issues/4790>`_.
- `Fixed error when creating bridge on a hypervisor <https://github.com/OpenNebula/one/issues/4794>`_.
- `Fixed VM log tab if the VM is remote on a federated oned <https://github.com/OpenNebula/one/issues/3465>`_.
