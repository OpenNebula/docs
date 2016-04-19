.. _intro:

==========================
An Overview of OpenNebula
==========================

OpenNebula offers a **simple but feature-rich and flexible solution** to build and manage enterprise clouds and virtualized data centers. This introductory guide gives an overview of OpenNebula and summarizes its key features for the different roles involved in a cloud computing setup.

Key Features
=================================================

OpenNebula provides features at the two main layers of Data Center Virtualization and Cloud Infrastructure:

- **Data Center Virtualization Management**. Many companies use OpenNebula to manage data center virtualization,  consolidate  servers, and  integrate existing IT assets for computing, storage, and networking. In this deployment model, OpenNebula directly integrates with the hypervisor (mostly KVM) and has complete control over virtual and physical resources, providing advanced features for capacity management, resource optimization, high availability and business continuity. Some of these users additionally enjoy OpenNebula’s cloud management and provisioning features when they additional want to federate data centers, implement cloudbursting, or offer self-service portals for end users.
- **Cloud Management**. Other companies use OpenNebula to provide a multi-tenant, cloud-like provisioning layer on top of an existing infrastructure management solution (mostly VMware vCenter). These users are looking for provisioning, elasticity and multi-tenancy cloud features like virtual data centers provisioning, datacenter federation or hybrid cloud computing to connect in-house infrastructures with public clouds, while the infrastructure is managed by already familiar tools for infrastructure management and operation.

TODO: FIgure

You can refer to our a summarized table of `Key Features <http://opennebula.org/about/key-features/>`__ or to the :ref:`Detailed Features and Functionality Guide <features>` included in the documentation of each version.

Interfaces
===============================================

Because no two clouds are the same, OpenNebula provides many different interfaces that can be used to interact with the functionality offered to manage physical and virtual resources. There are four main different perspectives to interact with OpenNebula:

-  Cloud interfaces for **Cloud Consumers**, like :ref:`EC2 Query and EBS <ec2qug>` interfaces, and a simple :ref:`Sunstone cloud user view <cloud_view>` that can be used as a self-service portal.
-  Administration interfaces for **Cloud Advanced Users and Operators**, like a Unix-like :ref:`command line interface <cli>` and the powerful :ref:`Sunstone GUI <sunstone>`.
-  Extensible low-level APIs for **Cloud Integrators** in :ref:`Ruby <ruby>`, :ref:`JAVA <java>` and :ref:`XMLRPC API <api>`
-  A :ref:`Marketplace <marketplace>` for **Appliance Builders** with a catalog of virtual appliances ready to run in OpenNebula environments.

|OpenNebula Cloud Interfaces|

Key Features for Cloud Consumers
==============================================

OpenNebula provides a powerful, scalable and secure multi-tenant cloud platform for fast delivery and elasticity of virtual resources. Multi-tier applications can be deployed and consumed as pre-configured virtual appliances from catalogs.

-  **Image Catalogs**: OpenNebula allows to store :ref:`disk images in catalogs <img_guide>` (termed datastores), that can be then used to define VMs or shared with other users. The images can be OS installations, persistent data sets or empty data blocks that are created within the datastore.
-  **Network Catalogs**: :ref:`Virtual networks <vgg>` can be also be organised in network catalogs, and provide means to interconnect virtual machines. This kind of resources can be defined as IPv4, IPv6, or mixed networks, and can be used to achieve full isolation between virtual networks.
-  **VM Template Catalog**: The :ref:`template catalog <vm_guide>` system allows to register :ref:`virtual machine <vm_guide_2>` definitions in the system, to be instantiated later as virtual machine instances.
-  **Virtual Resource Control and Monitoring**: Once a template is instantiated to a virtual machine, there are a number of operations that can be performed to control lifecycle of the :ref:`virtual machine instances <vm_guide_2>`, such as migration (live and cold), stop, resume, cancel, poweroff, etc.
-  **Multi-tier Cloud Application Control and Monitoring**: OpenNebula allows to :ref:`define, execute and manage multi-tiered elastic applications <appflow_use_cli>`, or services composed of interconnected Virtual Machines with deployment dependencies between them and :ref:`auto-scaling rules <appflow_elasticity>`.

|OpenNebula Cloud Support for Virtual Infrastructures|

Key Features for Cloud Operators
==============================================


OpenNebula is all about simplicity. It has been designed to be extremely simple. Simple to install, update and operate for the cloud administrators, and simple to use by end users. OpenNebula is composed of the following subsystems:

-  **Users and Groups**: OpenNebula features advanced multi-tenancy with powerful :ref:`users and groups management <manage_users>`, :ref:`fine-grained ACLs <manage_acl>` for resource allocation, and :ref:`resource quota management <quota_auth>` to track and limit computing, storage and networking utilization.

-  **Virtualization**: Various hypervisors are supported in the :ref:`virtualization manager <vmmg>`, with the ability to control the complete lifecycle of Virtual Machines and multiple hypervisors in the same cloud infrastructure.

-  **Hosts**: The :ref:`host manager <host_guide>` provides complete functionality for the management of the physical hosts in the cloud.

-  **Monitoring**: Virtual resources as well as :ref:`hosts <hostsubsystem>` are periodically monitored for key performance indicators. The information can then used by a powerful and flexible :ref:`scheduler <schg>` for the definition of workload and resource-aware allocation policies. You can also :ref:`gain insight application status and performance <onegate_usage>`.

-  **Accounting**: A Configurable :ref:`accounting system <accounting>` to visualize and report resource usage data, to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users.

-  **Networking**: An easily adaptable and customizable :ref:`network subsystem <nm>` is present in OpenNebula in order to better integrate with the specific network requirements of existing data centers and to allow full isolation between virtual machines that composes a virtualised service.

-  **Storage**: The support for multiple datastores in the :ref:`storage subsystem <sm>` provides extreme flexibility in planning the storage backend and important performance benefits.

-  **Security**: This feature is spread across several subsystems: :ref:`authentication and authorization mechanisms <auth_overview>` allowing for various possible mechanisms to identify a authorize users, a powerful :ref:`Access Control List <manage_acl>` mechanism allowing different role management with fine grain permission granting over any resource managed by OpenNebula, support for isolation at different levels...

-  **High Availability**: Support for :ref:`HA architectures <oneha>` and :ref:`configurable behavior in the event of host or VM failure <ftguide>` to provide easy to use and cost-effective failover solutions.

-  **Clusters**: :ref:`Clusters <cluster_guide>` are pools of hosts that share datastores and virtual networks. Clusters are used for load balancing, high availability, and high performance computing.

-  **Multiple Zones**: The :ref:`Data Center Federation <introf>` functionality allows for the centralized management of multiple instances of OpenNebula for scalability, isolation and multiple-site support.

-  **VDCs**. An OpenNebula instance (or Zone) can be further compartmentalized in  :ref:`Virtual Data Centers (VDCs) <managing_resource_provider_within_groups>`, which offer a fully-isolated virtual infrastructure environment where a group of users, under the control of the group administrator, can create and manage compute, storage and networking capacity.

-  **Cloud Bursting**: OpenNebula gives support to build a :ref:`hybrid cloud <introh>`, an extension of a private cloud to combine local resources with resources from remote cloud providers. A whole public cloud provider can be encapsulated as a local resource to be able to use extra computational capacity to satisfy peak demands.

-  **App Market**: OpenNebula allows the deployment of a `private centralized catalog of cloud applications <https://github.com/OpenNebula/addon-appmarket>`__ to share and distribute virtual appliances across OpenNebula instances

|OpenNebula Cloud Internals|

Key Features for Cloud Builders
=============================================

OpenNebula is a turnkey enterprise-ready solution that includes all the features needed to provide an on-premises (private) cloud offering, and to offer public cloud services. 


OpenNebula offers broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services:

-  **User Management**: OpenNebula can validate users using its own internal user database based on :ref:`passwords <manage_users>`, or external mechanisms, like :ref:`ssh <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`ldap <ldap>` or :ref:`Active Directory <ldap>`

-  **Virtualization**: Several hypervisor technologies are fully supported, like :ref:`KVM <kvmg>`.

-  **Monitoring**: OpenNebula provides its own :ref:`customizable and highly scalable monitoring system <mon>` and also can be integrated with external data center monitoring tools.

-  **Networking**: Virtual networks can be backed up by :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage**: Multiple backends are supported like the regular (shared or not) :ref:`filesystem datastore <fs_ds>` supporting popular distributed file systems like NFS, Lustre, GlusterFS, ZFS, GPFS, MooseFS...; the :ref:`LVM datastore <lvm_drivers>` to store disk images in a block device form; and :ref:`Ceph <ceph_ds>` for distributed block device.

-  **Databases**: Aside from the original sqlite backend, :ref:`mysql <mysql>` is also supported.

-  **Cloud Bursting**: Out of the box connectors are shipped to support :ref:`Amazon EC2 <ec2g>` and :ref:`Microsoft Azure <azg>` cloudbursting.

|OpenNebula Cloud Platform Support|

Key Features for Cloud Integrators
================================================

OpenNebula is fully platform independent and offers many tools for cloud integrators:

-  **Modular and extensible architecture** with :ref:`customizable plug-ins <introapis>` for integration with any third-party data center service

-  **API for integration** with higher level tools such as billing, self-service portals... that offers all the rich functionality of the OpenNebula core, with bindings for :ref:`ruby <ruby>` and :ref:`java <java>`.

-  **Sunstone custom routes and tabs** to extend the :ref:`sunstone server <sunstone_dev>`.

-  **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.

-  **Hook Manager** to :ref:`trigger administration scripts upon VM state change <hooks>`.

|OpenNebula Cloud Architecture|

.. |OpenNebula Cloud Interfaces| image:: /images/overview_interfaces.png
.. |OpenNebula Cloud Support for Virtual Infrastructures| image:: /images/overview_consumers.png
.. |OpenNebula Cloud Internals| image:: /images/overview_operators.png
.. |OpenNebula Cloud Platform Support| image:: /images/overview_builders.png
.. |OpenNebula Cloud Architecture| image:: /images/overview_integrators.png
