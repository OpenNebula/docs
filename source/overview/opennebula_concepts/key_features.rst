.. _key_features:
.. _features:

============
Key Features
============

OpenNebula offers a **simple but feature-rich and flexible solution** to build and manage data center virtualization and enterprise clouds. This guide summarizes its key features(\*). You can also refer to the :ref:`Platform Notes <uspng>` included in the documentation of each version to know about the infrastructure platforms and services supported by OpenNebula.


**INTERFACES FOR CLOUD CONSUMERS**



**VIRTUAL MACHINE AND CONTAINER MANAGEMENT**

- Virtual infrastructure management adjusted to enterprise data centers with full control, monitoring and accounting of virtual resources

- Virtual machine image management through :ref:`catalogs of disk images <img_guide>` (termed datastores) with OS installations, persistent data sets or empty data blocks that are created within the datastore

-  Virtual machine template management through :ref:`catalogs of templates <vm_guide>` that allow to register :ref:`virtual machine <vm_guide_2>` definitions in the system to be instantiated later as virtual machine instances

-  Virtual machine instance management with full control of :ref:`virtual machine lifecycle <vm_guide_2>`

-  :ref:`Programmable VM operations <vm_guide2_scheduling_actions>` allowing users to schedule actions

-  Volume and network hotplugging

-  :ref:`Disk snapshot capabilities <vm_guide_2_disk_snapshots>` and :ref:`disk resizing <vm_guide2_resize_disk>` for KVM, LXD and Firecracker instances

- LXD Containers are treated the same way as VMs in OpenNebula and support most of the VM features

- Firecracker MicroVMs are treated the same way as VMs in OpenNebula and support most of the VM features


**VIRTUAL NETWORK MANAGEMENT**

- :ref:`Advanced network virtualization capabilities <manage_vnets>` with traffic isolation, address reservation, flexible definition of address ranges to accommodate any address distribution, definition of generic attributes to define multi-tier services...

- :ref:`IPv6 support <manage_vnets>` with definition site and global unicast addresses

- :ref:`Virtual routers <vrouter>`

- :ref:`Security Groups <security_groups>` to define firewall rules and apply them to KVM, LXD, Firecracker and vCenter instances


**APPLICATION CONFIGURATION AND INSIGHT**

- :ref:`Automatic installation and configuration of application environments <context_overview>`

- VM attributes can be provided by the user when the template is instantiated

- Wide range of guest operating system including Microsoft Windows and Linux

- :ref:`Gain insight cloud applications <onegate_overview>` so their status and metrics can be easily queried through OpenNebula interfaces and used in auto-scaling rules


**MULTI-VM APPLICATION MANAGEMENT**

- :ref:`Automatic execution of multi-tiered (multi-VM) applications <oneapps_overview>` and their provision from a catalog and self-service portal

- :ref:`Automatic scaling of multi-tiered applications <appflow_elasticity>` according to performance metrics and time schedule


**INTERFACES FOR ADMINISTRATORS AND ADVANCED USERS**

- Powerful :ref:`Command Line Interface <cli>` that resembles typical UNIX commands applications

- :ref:`Easy-to-use Sunstone Graphical Interface <sunstone>` providing usage graphics and statistics with cloudwatch-like functionality, :ref:`remote access through VNC or SPICE <remote_access_sunstone>`, different system views for different roles, catalog access, multiple-zone management...

- :ref:`Sunstone is easily customizable <suns_views>` to define multiple cloud views for different user groups


**APPLIANCE MARKETPLACE**

- Access to the public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__ with a catalog of :ref:`OpenNebula-ready <context_overview>` cloud images

- Create your private centralized catalog (external datastore) of cloud applications (images and templates)

- Move VM images and templates across different types of datastores within the same OpenNebula instance

- Share VM images in Federation environments across several OpenNebula instances


**ACCOUNTING AND SHOWBACK**

- Configurable :ref:`accounting system <accounting>` to report resource usage data and guarantee fair share of resources among users

- Easy integration with chargeback and billing platforms

- :ref:`Showback <showback>` capabilities to define cost associated to CPU/hours and MEMORY/hours per VM Template


**MULTI-TENANCY AND SECURITY**

- :ref:`Fine-grained ACLs <manage_acl>` for resource allocation

- Powerful :ref:`user and role management <manage_users>`

- Administrators can :ref:`groups users <manage_users_groups>` into organizations that can represent different projects, division...

- Integration with :ref:`external identity management services <external_auth>`

- Special authentication mechanisms for :ref:`SunStone (OpenNebula GUI) <suns_auth>` and the :ref:`Cloud Services (EC2) <cloud_auth>`

- :ref:`Login token <manage_users>` functionality to password based logins

- Fine-grained auditing

- Support for isolation at different levels

- Advanced access control policies for VMs to redefine the access level (:ref:`ADMIN, MANAGE and USE <oned_conf_vm_operations>`) required for each VM action

- Traceability on VM actions, :ref:`VM history records <vm_history>` logs the data associated to the action performed on a VM


**ON-DEMAND PROVISION OF VIRTUAL DATA CENTERS**

- A :ref:`VDC (Virtual Data Center) <manage_vdcs>` is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the group admin, can create and manage compute and storage capacity

- There is a pre-configured :ref:`Sunstone view for group admins<vdc_admin_view>`


**CAPACITY AND PERFORMANCE MANAGEMENT**

- :ref:`Host management <hosts>` with complete functionality for the management of the virtualization nodes in the cloud

- Dynamic creation of :ref:`Clusters <cluster_guide>` as pools of hosts that share datastores and virtual networks for load balancing, high availability, and high performance computing

- :ref:`Customizable and highly scalable monitoring system <mon>` and also can be integrated with external data center monitoring tools.

- Powerful and flexible :ref:`scheduler <schg>` for the definition of workload and resource-aware allocation policies such as packing, striping, load-aware, affinity-aware…

- Definition of groups of related VMs and set :ref:`VM affinity <vmgroups>` rules across them.

- :ref:`Resource quota management <quota_auth>` to track and limit computing, storage and networking resource utilization

- Support for multiple data stores to balance I/O operations between storage servers, or to define different SLA policies (e.g. backup) and performance features for different types or users using KVM, LXD or Firecracker based virtualization.

- :ref:`PCI passthrough <kvm_pci_passthrough>` available for KVM VMs that need consumption of raw GPU devices


**FEDERATED CLOUD ENVIRONMENTS**

- :ref:`Federation of multiple OpenNebula Zones <introf>` for scalability, isolation or multiple-site support

- Users can seamlessly provision virtual machines from multiple zones with an integrated interface both in Sunstone and CLI


**HIGH AVAILABILITY AND BUSINESS CONTINUITY**

- :ref:`High availability architecture <oneha>` in active-passive configuration

- Persistent database backend with support for high availability configurations

- :ref:`Configurable behavior in the event of host or KVM/LXD/Firecracker instance failure <ftguide>` to provide easy to use and cost-effective failover solutions


**PLATFORM**

- Fully platform independent

- Hypervisor agnostic with broad hypervisor support (:ref:`KVM <kvmg>`, :ref:`LXD <lxdmg>`, :ref:`Firecracker <fcmg>` and :ref:`VMware vCenter <vcenterg>`) and centralized management of environments with multiple hypervisors

- :ref:`Broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services <uspng>`

- `Packages for major Linux distributions <http://opennebula.io/use/>`__


**CUSTOMIZATION AND INTEGRATION**

- :ref:`Modular and extensible architecture <intro_integration>` to fit into any existing datacenter

- Customizable drivers for the main subsystems to easily leverage existing IT infrastructure and system management products: :ref:`storage <sd>`, :ref:`monitoring <devel-im>`, :ref:`networking <devel-nm>`, :ref:`authentication <devel-auth>`, :ref:`virtualization <devel-vmm>` and :ref:`market <devel-market>`

- :ref:`API for integration with higher level tools <introapis>` such as billing, self-service portals…

- Hook manager to :ref:`trigger administration scripts upon VM state change <hooks>`

- Sunstone custom routes and tabs to extend the :ref:`sunstone server <sunstone_dev>`

- OneFlow API to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.

- `OpenNebula Add-on Catalog <https://github.com/OpenNebula/one/wiki/Add_ons-Catalog>`_ with components enhancing the functionality provided by OpenNebula

- :ref:`Configuration and tuning parameters <oned_conf>` to adjust behavior of the cloud management instance to the requirements of the environment and use cases


**LICENSING**

- `Fully open-source software <https://github.com/OpenNebula/one>`__  released under Apache license


**INSTALLATION AND UPGRADE PROCESS**

-  :ref:`Configurable to deploy public, private and hybrid clouds <intro>`

- All key functionalities for enterprise cloud computing, storage and networking in a :ref:`single install <frontend_installation>`

- Long term stability and performance through a single integrated patching and :ref:`upgrade process <upgrade>`.

- :ref:`Automatic import of existing VMs <import_wild_vms>` running in local hypervisors and public clouds for hybrid cloud computing

- :ref:`Optional building from source code <compile>`

- System features a small footprint, less than 10Mb


**QUALITY ASSURANCE**

- `Internal quality assurance process for functionality, scalability, performance, robustness and stability <https://github.com/OpenNebula/one/wiki/Quality-Assurance>`__

- `Technology matured through an active and engaged large community <http://opennebula.io/community-champions>`__

- Scalability, reliability and performance tested on many massive scalable production deployments consisting of hundreds of thousands of cores and VMs


**PRODUCT SUPPORT**

- `Best-effort community support <http://forum.opennebula.io>`__

- `SLA-based commercial support directly from the developers <http://opennebula.pro>`__

- :ref:`Integrated tab in Sunstone <commercial_support_sunstone>` to access OpenNebula Systems professional support

(\*) *Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.*

-  *The list of features may change on the different platform configurations*
-  *Not all platform configurations exhibit a similar performance and stability*
-  *The features may change to offer users more features and integration with other virtualization and cloud components*
-  *The features may change due to changes in the functionality provided by underlying virtualization services*
