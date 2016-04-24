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


**ON-DEMAND PROVISION OF VIRTUAL DATA CENTERS**

- A :ref:`VDC <manage_vdcs>` is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the VDC admin, can create and manage compute and storage capacity

- :ref:`Sunstone view for new group admin group_admin_view>` can be defined without the need of modifying the Sunstone configuration files


**VIRTUAL MACHINE MANAGEMENT**

- Virtual infrastructure management adjusted to enterprise data centers with full control, monitoring and accounting of virtual infrastructure resources

- Virtual machine image management through :ref:`catalogs of disk images <img_guide>` (termed datastores) with OS installations, persistent data sets or empty data blocks that are created within the datastore

-  Virtual machine template management through :ref:`catalogs of templates <vm_guide>` that allow to register :ref:`virtual machine <vm_guide_2>` definitions in the system to be instantiated later as virtual machine instances

-  Virtual machine instance management with full control of :ref:`virtual machine lifecycle <vm_guide_2>`

-  :ref:`Programmable VM operations <vm_guide2_scheduling_actions>` allowing users to schedule actions


**VIRTUAL NETWORK MANAGEMENT**

- Fully isolated :ref:`virtual networks <vgg>` organised in network catalogs that can be defined as IPv4, IPv6, or mixed networks.

- [TODO: Add Features]

- Virtual routers [TODO: Add link]

- :ref:`Security Groups <security_groups>` to define firewall rules and apply them to Virtual Machines


**INTERFACES FOR ADMINISTRATORS AND ADVANCED USERS**	

- Powerful :ref:`Command Line Interface <cli>` that resembles typical UNIX commands applications

- ref:`Sunstone GUI <sunstone>` for administrators and advanced users


**APPLIANCE MARKETPLACE**	

- Create your private centralized catalog of cloud applications 

- Move VM images and templates across different types of datastores 

- Share OpenNebula images in Federation environments


**ACCOUNTING AND CHARGEBACK**	

- Fine-grained accounting and monitoring

- Easy integration with any billing system

- Showback system

-  **Accounting**: A Configurable :ref:`accounting system <accounting>` to visualize and report resource usage data, to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users.



**MULTI-TENANCY AND SECURITY**

- Dynamic creation of Virtual Data Centers as fully-isolated virtual infrastructure environments where a group of users, under the control of the VDC administrator, can create and manage compute, storage and networking capacity

- Fine-grained ACLs for resource allocation

- Resource Quota Management to track and limit computing, storage and networking resource utilization

- Powerful user, group and role management

- Integration with external identity management services

- Login token functionality

- Fine-grained auditing

- Support for isolation at different levels

-  **Users and Groups**: OpenNebula features advanced multi-tenancy with powerful :ref:`users and groups management <manage_users>`, :ref:`fine-grained ACLs <manage_acl>` for resource allocation, and :ref:`resource quota management <quota_auth>` to track and limit computing, storage and networking utilization.

-  **Security**: This feature is spread across several subsystems: :ref:`authentication and authorization mechanisms <auth_overview>` allowing for various possible mechanisms to identify a authorize users, a powerful :ref:`Access Control List <manage_acl>` mechanism allowing different role management with fine grain permission granting over any resource managed by OpenNebula, support for isolation at different levels...

-  **User Management**: OpenNebula can validate users using its own internal user database based on :ref:`passwords <manage_users>`, or external mechanisms, like :ref:`ssh <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`ldap <ldap>` or :ref:`Active Directory <ldap>`.


**CAPACITY AND PERFORMANCE MANAGEMENT**	

- Dynamic creation of Clusters as pools of hosts that share datastores and virtual networks for load balancing, high availability, and high performance computing.

- Federation of multiple OpenNebula Zones for scalability, isolation or multiple-site support

- Powerful and flexible Scheduler for the definition of workload and resource-aware allocation policies such as packing, striping, load-aware, affinity-aware…

-  **Hosts**: The :ref:`host manager <host_guide>` provides complete functionality for the management of the physical hosts in the cloud.


-  **Clusters**: :ref:`Clusters <cluster_guide>` are pools of hosts that share datastores and virtual networks. Clusters are used for load balancing, high availability, and high performance computing.

-  **Multiple Zones**: The :ref:`Data Center Federation <introf>` functionality allows for the centralized management of multiple instances of OpenNebula for scalability, isolation and multiple-site support.

**HIGH AVAILABILITY AND BUSINESS CONTINUITY**	

- High availability architecture

- Persistent database backend with support for high availability configurations

- Configurable behavior in the event of host or VM failure to provide easy to use and cost-effective failover solutions

-  **High Availability**: Support for :ref:`HA architectures <oneha>` and :ref:`configurable behavior in the event of host or VM failure <ftguide>` to provide easy to use and cost-effective failover solutions.



**CLOUD BURSTING**	

- Native support for hybrid cloud computing
-  **Cloud Bursting**: OpenNebula gives support to build a :ref:`hybrid cloud <introh>`, an extension of a private cloud to combine local resources with resources from remote cloud providers. A whole public cloud provider can be encapsulated as a local resource to be able to use extra computational capacity to satisfy peak demands.


**PLATFORM**	

- Fully platform independent

- Various hypervisors are supported with the ability to control the complete lifecycle of Virtual Machines and multiple hypervisors in the same cloud infrastructure.

- Broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services

- Packages for major Linux distributions

-  **Networking**: An easily adaptable and customizable :ref:`network subsystem <nm>` is present in OpenNebula in order to better integrate with the specific network requirements of existing data centers and to allow full isolation between virtual machines that composes a virtualised service.

-  **Storage**: The support for multiple datastores in the :ref:`storage subsystem <sm>` provides extreme flexibility in planning the storage backend and important performance benefits.

-  **Networking**: Virtual networks can be backed up by :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage**: Multiple backends are supported like the regular (shared or not) :ref:`filesystem datastore <fs_ds>` supporting popular distributed file systems like NFS, Lustre, GlusterFS, ZFS, GPFS, MooseFS...; the :ref:`LVM datastore <lvm_drivers>` to store disk images in a block device form; and :ref:`Ceph <ceph_ds>` for distributed block device.

-  **Monitoring**: Virtual resources as well as :ref:`hosts <hostsubsystem>` are periodically monitored for key performance indicators. The information can then used by a powerful and flexible :ref:`scheduler <schg>` for the definition of workload and resource-aware allocation policies. You can also :ref:`gain insight application status and performance <onegate_usage>`.

-  **Monitoring**: OpenNebula provides its own :ref:`customizable and highly scalable monitoring system <mon>` and also can be integrated with external data center monitoring tools.


**INTEGRATION WITH THIRD-PARTY TOOLS**	

- Modular and extensible architecture

- Customizable plug-ins for integration with any third-party data center service

- API for integration with higher level tools such as billing, self-service portals…

- Powerful hooking system


-  **Modular and extensible architecture** with :ref:`customizable plug-ins <introapis>` for integration with any third-party data center service

-  **API for integration** with higher level tools such as billing, self-service portals... that offers all the rich functionality of the OpenNebula core, with bindings for :ref:`ruby <ruby>` and :ref:`java <java>`.

-  **Sunstone custom routes and tabs** to extend the :ref:`sunstone server <sunstone_dev>`.

-  **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.

-  **Hook Manager** to :ref:`trigger administration scripts upon VM state change <hooks>`.


**LICENSING**	

- Fully open-source software released under Apache license

**UPGRADE PROCESS**	

- Automatic import of existing environments

- All key functionalities for enterprise cloud computing, storage and networking in a single install

- Long term stability and performance through a single integrated patching and upgrade process


**QUALITY ASSURANCE**	

- Internal quality assurance process for functionality, scalability, performance, robustness and stability

- Technology matured through an active and engaged large community

- Scalability, reliability and performance tested on many massive scalable production deployments


**PRODUCT SUPPORT**	

- Best-effort community support

- SLA-based commercial support directly from the developers








