.. _intro:

================================================================================
Start Here: OpenNebula Overview
================================================================================

Welcome to OpenNebula documentation!

OpenNebula is an open-source management platform to build IaaS private, public and hybrid clouds. Installing a cloud from scratch could be a complex process, in the sense that many components and concepts are involved. The degree of familiarity with these concepts (system administration, infrastructure planning, virtualization management) will determine the difficulty of the installation process. If you are new to OpenNebula you should go through this short introduction before proceeding to the deployment and administration guides.

Step 1. Choose Your Hypervisor
=================================================

The first step is to decide on the hypervisor that you will use in your cloud infrastructure. The main OpenNebula distribution provides full support for the two most widely used hypervisors, KVM and VMware (through vCenter), at different levels of functionality.

- **Virtualization and Cloud Management on KVM**. Many companies use OpenNebula to manage data center virtualization, consolidate  servers, and integrate existing IT assets for computing, storage, and networking. In this deployment model, OpenNebula directly integrates with KVM and has complete control over virtual and physical resources, providing advanced features for capacity management, resource optimization, high availability and business continuity. Some of these deployments additionally use OpenNebula’s **Cloud  Management and Provisioning** features when they want to federate data centers, implement cloudbursting, or offer self-service portals for end users.

-  **Cloud Management on VMware vCenter**. Other companies use OpenNebula to provide a multi-tenant, cloud-like provisioning layer on top of VMware vCenter. These deployments are looking for provisioning, elasticity and multi-tenancy cloud features like virtual data centers provisioning, datacenter federation or hybrid cloud computing to connect in-house infrastructures with public clouds, while the infrastructure is managed by already familiar tools for infrastructure management and operation, such as vSphere and vCenter Operations Manager.

After having installed the cloud with one hypervisor you may add another hypervisors. You can deploy heterogeneous multi-hypervisor environments managed by a single OpenNebula instance. An advantage of using OpenNebula on VMware is the strategic path to openness as companies move beyond virtualization toward a private cloud. OpenNebula can leverage existing VMware infrastructure, protecting IT investments, and at the same time gradually integrate other open-source hypervisors, therefore avoiding future vendor lock-in and strengthening the negotiating position of the company.

There are other virtualization technologies, like LXC or Xen, supported by the community. Please refer to the OpenNebula Add-ons Catalog [TODO: Add link].

[TODO: Add Figure]

Step 2. Cloud Design and Installation
=======================================

2.1. Understand the OpenNebula Provisioning Model
--------------------------------------------------

Before defining the architeture of your cloud, we recommend you go through this introduction to the :ref:`OpenNebula provisioning model <understand>`. In a small installation with a few hosts, you can skip this guide and use OpenNebula without giving much thought to infrastructure federation, partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure. 

2.2. Design the Cloud Architecture
--------------------------------------------------

In order to get the most out of a OpenNebula Cloud, we recommend that you create a plan with the features, performance, scalability, and high availability characteristics you want in your deployment. We have prepared Cloud Architecture Design guides for :ref:`KVM <open_cloud_architecture>` and :ref:`vCenter <vmware_cloud_architecture>` to help you plan an OpenNebula installation, so you can easily architect your deployment and understand the technologies involved in the management of virtualized resources and their relationship. These guides have been created from the collective information and experiences from hundreds of users and cloud client engagements. Besides main logical components and interrelationships, this guides document software products, configurations, and requirements of infrastructure platforms recommended for a smooth OpenNebula installation. 

2.3. Install the Front-end
--------------------------------------------------

Next step is the installation of OpenNebula in the cloud front-end. This :ref:`installation process<frontend_installation>` is the same for any underlying hypervisor. 

Optionally you can setup a :ref:`high available cluster for OpenNebula <frontend_ha_setup>` for OpenNebula to reduce downtime of core OpenNebula services, and :ref:`configure a MySQL backend <mysql>` as an alternative to the default Sqlite backend if you are planning a large-scale infrastructure.

2.4. Install the Virtualization hosts
--------------------------------------------------

Now you are ready to add the virtualization nodes. The OpenNebula packages bring support for :ref:`KVM <kvm_node>` and :ref:`vCenter <vCenter_node>` nodes. In the case of vCenter, a host represents a vCenter cluster with all its ESX hosts. You can add different hypervisors to the same OpenNebula instance, or any other virtualization technology, like LXC or Xen, supported by the community. Please refer to the OpenNebula Add-ons Catalog [TODO: Add link].

Step 3. Infrastructure Set-up
===============================================

3.1. Data Center Infrastructure Integration
--------------------------------------------------

Now you should have an OpenNebula cloud up and running with at least one virtualization node. The next step is, if needed, to perform the integration of OpenNebula with your infrastructure platform and define the configuration of its components. When using the vCenter driver, no additonal integragtion is required because the interaction with the underlying networking, storage and compute infrastructure is performed through vCenter. 

However when using KVM, in the open cloud architecture, OpenNebula directly manages the hypervisor, networking and storage platforms, and you may need additional configuration:

-  Networking setup with :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  Storage setup with :ref:`filesystem datastore <fs_ds>`, :ref:`LVM datastore <lvm_drivers>` or :ref:`Ceph <ceph_ds>`.

-  Host setup with the configuration options for the hosts, like high availability or scheduling. [TODO: Add links]

3.2. Cloud Services Configuration
--------------------------------------------------

OpenNebula comes by default with an internal user/password authentication system. Optionally you can enable an external Authentication driver like :ref:`ssh <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`ldap <ldap>` or :ref:`Active Directory <ldap>`.

Sunstone, the OpenNebula GUI, brings by default a pre-defined configuration of views. Optionally it can be customized and extended to meet your needs. You can :ref:`customize the roles and views <suns_views>`, :ref:`improve security with x509 authentication and SSL <suns_auth>` or :ref:`improve scalability for large deployments <suns_advance>`.

We also provide references with a detailed description of the different configuration files, and logging and debugging reports of the OpenNebula services. [TODO: Add links]

Step 4. Operation and Usage
===============================================

4.1. Host and User Management
--------------------------------------------------
You are now ready to define the :ref:` provisioning model <understand>` in your cloud. 

Regarding user management, OpenNebula features advanced multi-tenancy with powerful :ref:`users and groups management <manage_users>`, a :ref:`Access Control List <manage_acl>` mechanism allowing different role management with fine grain permission granting over any resource, :ref:`resource quota management <quota_auth>` to track and limit computing, storage and networking utilization, and a configurable :ref:`accounting  <accounting>` and :ref:`showback  <showback>` systems to visualize and report resource usage data and to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users.
Regarding the underlying infrastructure, OpenNebula provides complete functionality for the management of the :ref:`physical hosts <host_guide>` and :ref:`clusters <cluster_guide>`in the cloud. A Cluster is a group of Hosts that can have associated Datastores and Virtual Networks. 
Last but not least, you can define VDCs (Virtual Data Center) as assignments of one or several user groups to a pool of physical resources. While clusters are used to group physical resources according to common characteristics such as networking topology or physical location, Virtual Data Centers (VDCs) allow to create “logical” pools of resources (which could belong to different clusters and cones) and allocate them to user groups.  

4.2. Virtual Resources Management
--------------------------------------------------

OpenNebula provides ruch functionality to manage the life-cycle of all virtual resources.

OpenNebula provides a powerful, scalable and secure multi-tenant cloud platform for fast delivery and elasticity of virtual resources. Multi-tier applications can be deployed and consumed as pre-configured virtual appliances from catalogs.

-  **Image Catalogs**: OpenNebula allows to store :ref:`disk images in catalogs <img_guide>` (termed datastores), that can be then used to define VMs or shared with other users. The images can be OS installations, persistent data sets or empty data blocks that are created within the datastore.
-  **Network Catalogs**: :ref:`Virtual networks <vgg>` can be also be organised in network catalogs, and provide means to interconnect virtual machines. This kind of resources can be defined as IPv4, IPv6, or mixed networks, and can be used to achieve full isolation between virtual networks.
-  **VM Template Catalog**: The :ref:`template catalog <vm_guide>` system allows to register :ref:`virtual machine <vm_guide_2>` definitions in the system, to be instantiated later as virtual machine instances.
-  **Virtual Resource Control and Monitoring**: Once a template is instantiated to a virtual machine, there are a number of operations that can be performed to control lifecycle of the :ref:`virtual machine instances <vm_guide_2>`, such as migration (live and cold), stop, resume, cancel, poweroff, etc.

Step 5. Advanced Components
===============================================

-  Cloud interfaces for **Cloud Consumers**, like :ref:`EC2 Query and EBS <ec2qug>` interfaces, and a simple :ref:`Sunstone cloud user view <cloud_view>` that can be used as a self-service portal.

-  **Multi-tier Application Management**: OpenNebula allows to :ref:`define, execute and manage multi-tiered elastic applications <appflow_use_cli>`, or services composed of interconnected Virtual Machines with deployment dependencies between them and :ref:`auto-scaling rules <appflow_elasticity>`.

Step 6. Integration with other Components
===============================================


Because no two clouds are the same, OpenNebula provides many different interfaces that can be used to interact with the functionality offered to manage physical and virtual resources. There are four main different perspectives to interact with OpenNebula:

-  Administration interfaces for **Cloud Advanced Users and Operators**, like a Unix-like :ref:`command line interface <cli>` and the powerful :ref:`Sunstone GUI <sunstone>`.
-  Extensible low-level APIs for **Cloud Integrators** in :ref:`Ruby <ruby>`, :ref:`JAVA <java>` and :ref:`XMLRPC API <api>`
-  A :ref:`Marketplace <marketplace>` for **Appliance Builders** with a catalog of virtual appliances ready to run in OpenNebula environments.

|OpenNebula Cloud Interfaces|

Key Features for Cloud Consumers
==============================================



|OpenNebula Cloud Support for Virtual Infrastructures|

Key Features for Cloud Operators
==============================================

OpenNebula is all about simplicity. It has been designed to be extremely simple to install, update and operate for the cloud administrators:

.

-  **Monitoring**: Virtual resources as well as :ref:`hosts <hostsubsystem>` are periodically monitored for key performance indicators. The information can then used by a powerful and flexible :ref:`scheduler <schg>` for the definition of workload and resource-aware allocation policies. You can also :ref:`gain insight application status and performance <onegate_usage>`.


-  **Networking**: An easily adaptable and customizable :ref:`network subsystem <nm>` is present in OpenNebula in order to better integrate with the specific network requirements of existing data centers and to allow full isolation between virtual machines that composes a virtualised service.

-  **Storage**: The support for multiple datastores in the :ref:`storage subsystem <sm>` provides extreme flexibility in planning the storage backend and important performance benefits.


-  **High Availability**: Support for :ref:`HA architectures <oneha>` and :ref:`configurable behavior in the event of host or VM failure <ftguide>` to provide easy to use and cost-effective failover solutions.


-  **Multiple Zones**: The :ref:`Data Center Federation <introf>` functionality allows for the centralized management of multiple instances of OpenNebula for scalability, isolation and multiple-site support.

-  **VDCs**. An OpenNebula instance (or Zone) can be further compartmentalized in  :ref:`Virtual Data Centers (VDCs) <managing_resource_provider_within_groups>`, which offer a fully-isolated virtual infrastructure environment where a group of users, under the control of the group administrator, can create and manage compute, storage and networking capacity.

-  **Cloud Bursting**: OpenNebula gives support to build a :ref:`hybrid cloud <introh>`, an extension of a private cloud to combine local resources with resources from remote cloud providers. A whole public cloud provider can be encapsulated as a local resource to be able to use extra computational capacity to satisfy peak demands.

-  **App Market**: OpenNebula allows the deployment of a `private centralized catalog of cloud applications <https://github.com/OpenNebula/addon-appmarket>`__ to share and distribute virtual appliances across OpenNebula instances

|OpenNebula Cloud Internals|

Key Features for Cloud Builders
=============================================

OpenNebula offers broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services. The main OpenNebula distributions brings support for:

-  **Monitoring**: OpenNebula provides its own :ref:`customizable and highly scalable monitoring system <mon>` and also can be integrated with external data center monitoring tools.




-  **Cloud Bursting**: Out of the box connectors are shipped to support :ref:`Amazon EC2 <ec2g>` and :ref:`Microsoft Azure <azg>` cloudbursting.

OpenNebula addtionaly supports other infrastructure components through the drivers available in the Add-ons Catalog.

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
