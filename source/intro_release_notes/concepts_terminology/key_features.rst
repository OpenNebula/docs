.. _key_features:

================================================================================
OpenNebula Key Features
================================================================================

OpenNebula offers a **simple but feature-rich and flexible solution** to build and manage data center virtualization and enterprise clouds. This guide summarizes its key features. You can also refer to the :ref:`Platform Notes <uspng>` included in the documentation of each version to know about the infrastructure platforms and services supported by OpenNebula.

**INTERFACES FOR CLOUD CONSUMERS**

- :ref:`De-facto standard cloud APIs <introc>` with compatibility with cloud ecosystem tools

- :ref:`Simple, clean, intuitive Portals for cloud consumers <cloud_view>` to allow non-IT end users to easily create, deploy and manage compute, storage and network resources


**CLOUD CONSUMPTION**

- :ref:`Automatic installation and configuration of application environments <context_overview>`

- :ref:`Automatic execution of multi-tiered (multi-VM) applications <oneapps_overview>` and their provision from a catalog and self-service portal

- :ref:`Gain insight cloud applications <onegate_overview>` so their status and metrics can be easily queried through OpenNebula interfaces and used in auto-scaling rules




Management of Multi-tier Applications
=====================================

-  :ref:`Automatic deployment and undeployment of Virtual Machines <appflow_use_cli>` according to their dependencies in the Service Template
-  Provide configurable services from a catalog and self-service portal
-  Enable tight, efficient administrative control
-  Complete integration with the OpenNebula's `User Security Management <http://opennebula.org/documentation:features#powerful_user_security_management>`__ system
-  Computing resources can be tracked and limited using OpenNebula's :ref:`Resource Quota Management <quota_auth>`
-  :ref:`Automatic scaling of multi-tiered applications <appflow_elasticity>` according to performance metrics and time schedule
- Dynamic information sharing where information can be passed across nodes in the service
- Network configuration can be defined for a service template
- OpenNebula Flow has been integrated in the Cloud and VDC Admin Sunstone views, so users can instantiate new services and monitor groups of Virtual Machines

**ON-DEMAND PROVISION OF VIRTUAL DATA CENTERS**

- A :ref:`VDC (Virtual Data Center) <manage_vdcs>` is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the group admin, can create and manage compute and storage capacity

- There is a pre-configured :ref:`Sunstone view for group admins<suns_views_group_admin>` 


**VIRTUAL MACHINE MANAGEMENT**

- Virtual infrastructure management adjusted to enterprise data centers with full control, monitoring and accounting of virtual  resources

- Virtual machine image management through :ref:`catalogs of disk images <img_guide>` (termed datastores) with OS installations, persistent data sets or empty data blocks that are created within the datastore

-  Virtual machine template management through :ref:`catalogs of templates <vm_guide>` that allow to register :ref:`virtual machine <vm_guide_2>` definitions in the system to be instantiated later as virtual machine instances

-  Virtual machine instance management with full control of :ref:`virtual machine lifecycle <vm_guide_2>`

-  :ref:`Programmable VM operations <vm_guide2_scheduling_actions>` allowing users to schedule actions

-  Volume hotplugging to easily hot plug a volatile disk created on-the-fly or an existing image from a Datastore to a running VM


**VIRTUAL NETWORK MANAGEMENT**

- :ref:`Advanced network virtualization capabilities <vgg>` with traffic isolation, address reservation, flexible defintion of address ranges to accommodate any address distribution, definition of generic attributes to define multi-tier services...

- :ref:`IPv6 support <vgg_ipv6_networks>` with definition site and global unicast addresses

- Virtual routers [TODO: Add link]

- :ref:`Security Groups <security_groups>` to define firewall rules and apply them to Virtual Machines


**VIRTUAL MACHINE CONFIGURATION**

-  Complete :ref:`definition of VM attributes and requirements <template>`
-  VM attributes can be provided by the user when the template is instantiated
-  Support for automatic configuration of VMs with advanced :ref:`contextualization mechanisms <cong>`
-  Wide range of guest operating system including Microsoft Windows and Linux


**INTERFACES FOR ADMINISTRATORS AND ADVANCED USERS**

- Powerful :ref:`Command Line Interface <cli>` that resembles typical UNIX commands applications

- ref:`Sunstone GUI <sunstone>` for administrators and advanced users


**APPLIANCE MARKETPLACE**

- Access to the public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>` with a catalog of :ref:`OpenNebula-ready <bcont>` cloud images

- Create your private centralized catalog (external satastore) of cloud applications (images and templates)  [TODO: Add link]

- Move VM images and templates across different types of datastores within the same OpenNebula instance  [TODO: Add link]

- Share VM images in Federation environments across several OpenNebula instances  [TODO: Add link]


**ACCOUNTING AND SHOWBACK**

- Configurable :ref:`accounting system <accounting>` to report resource usage data and guarantee fair share of resources among users

- Easy integration with chargeback and billing platforms

- :ref:`Showback <showback>` capabilities to define cost associated to CPU/hours and MEMORY/hours per VM Template.


**MULTI-TENANCY AND SECURITY**

- :ref:`Fine-grained ACLs <manage_acl>` for resource allocation

- Powerful :ref:`user and role management <manage_users>`

- Administrators can :ref:`groups users <manage_users_groups>` into organizations that can represent different projects, division...

- Integration with :ref:`external identity management services <auth_overview>`

- Special authentication mechanisms for :ref:`SunStone (OpenNebula GUI) <sunstone>` and the :ref:`Cloud Services (EC2) <cloud_auth>`

- :ref:`Login token <manage_users_managing_users>` functionality to password based logins

- Fine-grained auditing

- Support for isolation at different levels


**CAPACITY AND PERFORMANCE MANAGEMENT**

- :ref:`Host management <host_guide>` with complete functionality for the management of the virtualziation nodes in the cloud

- Dynamic creation of :ref:`Clusters <cluster_guide>` as pools of hosts that share datastores and virtual networks for load balancing, high availability, and high performance computing

- ref:`customizable and highly scalable monitoring system <mon>` and also can be integrated with external data center monitoring tools.

- Powerful and flexible :ref:`scheduler <schg>` for the definition of workload and resource-aware allocation policies such as packing, striping, load-aware, affinity-aware…  

- :ref:`Resource quota management <quota_auth>` to track and limit computing, storage and networking resource utilization

- Support for multiple data stores to balance I/O operations between storage servers, or to define different SLA policies (e.g. backup) and performance features for different VM types or users [TODO: Add Link]

- :ref:`PCI passthrough <kvm_pci_passthrough>` available for VMs that need consumption of raw GPU devices existing on a physical host

- :ref:`Advanced disk snapshot capabilities <vm_guide_2_disk_snapshots>`, Disk resizing, :ref:`grow a VM disk at instantiation time <vm_guide2_resize_disk>` on your VM while conforming with your quotas and being noted down for accounting FALTA HOT

**FEDERATED CLOUD ENVIRONMENTS**

- :ref:`Federation of multiple OpenNebula Zones <introf>` for scalability, isolation or multiple-site support

- Users can seamlessly provision virtual machines from multiple zones with an integrated interface both in Sunstone and CLI


**HIGH AVAILABILITY AND BUSINESS CONTINUITY**

- :ref:`High availability architecture <oneha>` in active-passive configuration

- Persistent database backend with support for high availability configurations

- ref:`Configurable behavior in the event of host or VM failure <ftguide>` to provide easy to use and cost-effective failover solutions


**CLOUD BURSTING**

- Build a :ref:`hybrid cloud <introh>` to combine your local resources with resources from remote cloud provider and use extra computational capacity to satisfy peak demands


**PLATFORM**

- Fully platform independent

- Hypervisor agnostic with broad hypervisor support (:ref:`KVM <kvmg>` and :ref:`VMware vCenter <vcenterg>`) and centralized management of environments with multiple hypervisors

- Broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services [TODO: Link to Platform Notes]

- Packages for major Linux distributions [TODO: Link]


**CUSTOMIZATION AND INTEGRATION**

- Modular and extensible architecture

- :ref:`Customizable plug-ins <intro_integration>` for integration with underlying data cservices

- :ref:`API for integration with higher level tools <introapis>` such as billing, self-service portals…

-  **Hook Manager** to :ref:`trigger administration scripts upon VM state change <hooks>`.

-  **Sunstone custom routes and tabs** to extend the :ref:`sunstone server <sunstone_dev>`.

-  **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.


**LICENSING**

- Fully open-source software released under Apache license [TODO: Link to GitHub]


**INSTALLATION AND UPGRADE PROCESS**

-  :ref:`Configurable to deploy public, private and hybrid clouds <intro>`

- :ref:`Automatic import of existing VMs <import_wild_vms>` running in local hypervisors and public clouds for hybrid cloud computing

- All key functionalities for enterprise cloud computing, storage and networking in a single install [TODO: Link to Front-end Installaton Guide]

- Long term stability and performance through a single integrated patching and upgrade process  [TODO: Link to Upgrade in RN]


**QUALITY ASSURANCE**

- Internal quality assurance process for functionality, scalability, performance, robustness and stability  [TODO: Link to web site page]

- Technology matured through an active and engaged large community [TODO: Link to community page]

- Scalability, reliability and performance tested on many massive scalable production deployments


**PRODUCT SUPPORT**

- Best-effort community support [TODO: Link to forum]

- SLA-based commercial support directly from the developers  [TODO: Link to OpenNebula.pro]


[TODO: This info should go to Platform Notes]

-  **Networking**: Virtual networks can be backed up by :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage**: Multiple backends are supported like the regular (shared or not) :ref:`filesystem datastore <fs_ds>` supporting popular distributed file systems like NFS, Lustre, GlusterFS, ZFS, GPFS, MooseFS...; the :ref:`LVM datastore <lvm_drivers>` to store disk images in a block device form; and :ref:`Ceph <ceph_ds>` for distributed block device.







