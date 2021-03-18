.. _intro:

===========================
Cloud Architecture Design
===========================

In order to get familiar with OpenNebula, or if you are only interested in building a True Hybrid and Edge deployment, we strongly recommend you start with the Quick Start guide where you will learn how to install a single OpenNebula front-end, deploy on-demand hybrid clusters on remote cloud provider resources, and the basic usage and operation of your cloud. This trial of a real cloud deplyment will help you create a plan with the features, performance, scalability, and high availability characteristics in order to get the most out of an OpenNebula Cloud.

.. todo:: Add Links above

Step 1. Install the Front-end
=================================================

The first step is the **installation of OpenNebula in the cloud front-end**. This :ref:`installation process <frontend_installation>` is the same for any underlying hypervisor or deployment model.

Optionally you can setup a :ref:`high available cluster for OpenNebula <frontend_ha_setup>` for OpenNebula to reduce downtime of core OpenNebula services, and :ref:`configure a MySQL backend <mysql>` as an alternative to the default Sqlite backend if you are planning a large-scale infrastructure.

.. todo:: Include Postgress above

- :ref:`Marketplaces <public_marketplace_overview>` for sharing, provisioning and consuming cloud images. They can be seen as external datastores, where images can be easily imported, exported and shared by a federation of OpenNebula instances.

.. todo:: Explain public marketplaces above and link to guide

The :ref:`datacenter federation <introf>` functionality allows for the **centralized management of multiple instances of OpenNebula for scalability, isolation and multiple-site support**.


Step 2. Deploy True Hybrid Clusters
=================================================

.. todo:: Explain True Hybrid Deployments

.. TODO REF NON EXISTENT COMPONENTS REFERENCES

-  :ref:Disaggregated Data Centers <ddc_overview> provides tools to build and grow the physical infrastructure with resources from public bare-metal cloud providers, e.g. :ref:Amazon EC2 <ddc_driver_aws> and :ref:Packet <ddc_driver_packet>. New physical machines are allocated from the provider, configured to run the hypervisor and added into OpenNebula as new clusters with hosts, datastores and virtual networks.

.. todo:: Change previous parragraph to expian oneprovision

Step 3. Setup Customized Clusters On-premises
=================================================

.. todo:: Explain Follow from here only if interested in customized clusters

We have prepared **Cloud Architecture Design guides** for :ref:`KVM and LXD <open_cloud_architecture>` and :ref:`vCenter <vmware_cloud_architecture>` to help you plan an OpenNebula installation, so you can easily architect your deployment and understand the technologies involved in the management of virtualized resources and their relationship. These guides have been created from the collective information and experiences from hundreds of users and cloud client engagements. Besides the main logical components and interrelationships, these guides document software products, configurations, and requirements of infrastructure platforms recommended for a smooth OpenNebula installation.

3.1.Choose Your Hypervisor
--------------------------------------------------

The first step in building a customized cluster is to decide on the hypervisor that you will use in your cloud infrastructure. The main OpenNebula distribution provides full support for the two most widely used hypervisors, KVM and VMware (through vCenter), LXD system containers, and Firecracker lightweight virtualization at different levels of functionality.

-  **Virtualization and Cloud Management on KVM**. Many companies use OpenNebula to manage data center virtualization, consolidate servers, and integrate existing IT assets for computing, storage, and networking. In this deployment model, OpenNebula directly integrates with KVM and has complete control over virtual and physical resources, providing advanced features for capacity management, resource optimization, high availability and business continuity. Some of these deployments additionally use OpenNebula’s **Cloud Management and Provisioning** features when they want to federate data centers, implement cloudbursting, or offer self-service portals for end users.

-  **Cloud Management on VMware vCenter**. Other companies use OpenNebula to provide a multi-tenant, cloud-like provisioning layer on top of VMware vCenter. These deployments are looking for provisioning, elasticity and multi-tenancy cloud features like virtual data centers provisioning, datacenter federation or hybrid cloud computing to connect in-house infrastructures with public clouds, while the infrastructure is managed by already familiar tools for infrastructure management and operation, such as vSphere and vCenter Operations Manager.

-  **Containerization with LXD**. Containers are the next step towards virtualization. They have a minimal memory footprint and skip the compute intensive and sometimes unacceptable performance degradation inherent to hardware emulation. You can have a very high density of containers per virtualization node and run workloads close to bare-metal metrics. LXD focuses on system containers, instead of similar technologies like Docker, which focuses on application containers.

-  **Lightweight Virtualization on Firecracker**. Firecracker MicroVMs provide enhanced security and workload isolation over traditional container solution while preserving their speed and resource efficiency. MicroVMs are especially designed for creating and managing secure, multi-tenant container (CaaS) and function-based (FaaS) services.

After having installed the cloud with one hypervisor you may add other hypervisors. You can deploy heterogeneous multi-hypervisor environments managed by a single OpenNebula instance. An advantage of using OpenNebula on VMware is the strategic path to openness as companies move beyond virtualization toward a private cloud. OpenNebula can leverage existing VMware infrastructure, protecting IT investments, and at the same time gradually integrate other open-source hypervisors, therefore avoiding future vendor lock-in and strengthening the negotiating position of the company.

|OpenNebula Hypervisors|

3.2. Install the Virtualization hosts
-------------------------------------------------

Now you are ready to **add the virtualization nodes**. The OpenNebula packages bring support for :ref:`KVM <kvm_node>`, :ref:`LXD <lxd_node>`, :ref:`Firecracker <fc_node>` and :ref:`vCenter <vCenter_node>` nodes. In the case of vCenter, a host represents a vCenter cluster with all its ESX hosts. You can add different hypervisors to the same OpenNebula instance, or any other virtualization technology, like Xen, supported by the community. Please refer to the `OpenNebula Add-ons Catalog <https://github.com/OpenNebula/one/wiki/Add_ons-Catalog>`__.

3.3. Integrate with Data Center Infrastructure
------------------------------------------------------------

Now you should have an OpenNebula cloud up and running with at least one virtualization node. The next step is, if needed, to perform the integration of OpenNebula with your infrastructure platform and define the configuration of its components. When using the vCenter driver, no additional integration is required because the interaction with the underlying networking, storage and compute infrastructure is performed through vCenter.

However when using KVM, LXD or Firecracker, in the open cloud architecture, OpenNebula directly manages the hypervisor, networking and storage platforms, and you may need additional configuration:

-  **Networking setup** with :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage setup** with :ref:`filesystem datastore <fs_ds>`, :ref:`LVM datastore <lvm_drivers>`, :ref:`Ceph <ceph_ds>`, :ref:`Dev <dev_ds>`, or :ref:`iSCSI <iscsi_ds>` datastore.

-  **Host setup** with the configuration options for the :ref:`KVM hosts <kvmg>`, :ref:`LXD hosts <lxdmg>`, :ref:`Firecracker hosts <fcmg>` :ref:`Monitoring subsystem <mon>`, :ref:`Virtual Machine HA <ftguide>` or :ref:`PCI Passthrough <kvm_pci_passthrough>`.

3.4. Configure Cloud Services
--------------------------------------------------

OpenNebula comes by default with an internal **user/password authentication system**. Optionally you can enable an external Authentication driver like :ref:`ssh <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`ldap <ldap>` or :ref:`Active Directory <ldap>`.

**Sunstone, the OpenNebula GUI**, brings by default a pre-defined configuration of views. Optionally it can be customized and extended to meet your needs. You can :ref:`customize the roles and views <suns_views>`, :ref:`improve security with x509 authentication and SSL <suns_auth>` or :ref:`improve scalability for large deployments <suns_advance>`.

We also provide **references** with a detailed description of the different :ref:`configuration files <oned_conf>`, and :ref:`logging and debugging reports <log_debug>` of the OpenNebula services.

Step 4. Operate your Cloud
===============================================

.. todo:: Add explanation and links to usage and operation basics


4.1. Define a Provisioning Model
--------------------------------------------------

Before configuring multi-tenancy and defining the provisioning model of your cloud, we recommend you go through this introduction to the :ref:`OpenNebula provisioning model <understand>`. In a small installation with a few hosts, you can skip this guide and use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

-  Regarding the **underlying infrastructure**, OpenNebula provides complete functionality for the management of the :ref:`physical hosts <host_guide>` and :ref:`clusters <cluster_guide>` in the cloud. A Cluster is a group of Hosts that can have associated Datastores and Virtual Networks.

-  Regarding **user management**, OpenNebula features advanced multi-tenancy with powerful :ref:`users and groups management <manage_users>`, an :ref:`Access Control List <manage_acl>` mechanism allowing different role management with fine grain permission granting over any resource, :ref:`resource quota management <quota_auth>` to track and limit computing, storage and networking utilization, and a configurable :ref:`accounting  <accounting>` and :ref:`showback  <showback>` system to visualize and report resource usage data and to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users.

-  Last but not least, you can define :ref:`VDCs <manage_vdcs>` (Virtual Data Center) as assignments of one or several user groups to a pool of physical resources. While clusters are used to group physical resources according to common characteristics such as networking topology or physical location, Virtual Data Centers (VDCs) allow creating “logical” pools of resources (which could belong to different clusters and zones) and allocate them to user groups.

4.2. Manage Virtual Resources
--------------------------------------------------

Now everything is ready for operation. OpenNebula provides full control to manage virtual resources.

-  **Virtual machine image management** that allows storing :ref:`disk images in catalogs <img_guide>` (termed datastores), that can then be used to define VMs or shared with other users. The images can be OS installations, persistent data sets or empty data blocks that are created within the datastore.

-  **Virtual network management** of :ref:`Virtual networks <vgg>` that can be organized in network catalogs, and provide means to interconnect virtual machines. This kind of resource can be defined as IPv4, IPv6, or mixed networks, and can be used to achieve full isolation between virtual networks. Networks can be easily interconnected by using :ref:`virtual routers <vrouter>` and KVM, LXD and Firecracker users can also dynamically configure :ref:`security groups <security_groups>`

-  **Virtual machine template management** with a :ref:`template catalog <vm_guide>` system that allows registering :ref:`virtual machine <vm_guide_2>` definitions in the system, to be instantiated later as virtual machine instances.

-  **Virtual machine instance management** with a number of operations that can be performed to control the lifecycle of the :ref:`virtual machine instances <vm_guide_2>`, such as migration (live and cold), stop, resume, cancel, power-off, etc.

-  :ref:`OneFlow <oneapps_overview>` allows **multi-VM application and auto-scaling** to :ref:`define, execute and manage multi-tiered elastic applications <appflow_use_cli>`, or services composed of interconnected Virtual Machines with deployment dependencies between them and :ref:`auto-scaling rules <appflow_elasticity>`.

-  **Application insight** with :ref:`OneGate <onegate_overview>` allows Virtual Machine guests to pull and push VM information from OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VM.

Several :ref:`reference guides <overview_references_operation>` are provided for more information about definition files, templates and the CLI.

4.3. Create Virtual Machines
--------------------------------------------------

One of the most important aspects of the cloud is the **preparation of the images** for our users. OpenNebula uses a method called :ref:`contextualization <context_overview>` to send information to the VM at boot time. Its most basic usage is to share networking configuration and login credentials with the VM so it can be configured. More advanced cases can be starting a custom script on VM boot, or preparing a configuration to use :ref:`OpenNebula Gate <onegate_usage>`.

Step 5. Integrate with other Components
===============================================

This step is optional and only for integrators and builders.

Because no two clouds are the same, OpenNebula provides many different interfaces that can be used to interact with the functionality offered to manage physical and virtual resources.

-  **Modular and extensible architecture** with :ref:`customizable plug-ins <intro_integration>` for integration with any third-party data center infrastructure platform for :ref:`storage <sd>`, :ref:`monitoring <devel-im>`, :ref:`networking <devel-nm>`, :ref:`authentication <devel-auth>`, :ref:`virtualization <devel-vmm>` and :ref:`market <devel-market>`.

-  **API for integration** with higher level tools such as billing, self-service portals... that offers all the rich functionality of the OpenNebula core, with bindings for :ref:`ruby <ruby>` and :ref:`java <java>` and :ref:`XML-RPC API <api>`,

-  **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.

-  **Sunstone custom routes and tabs** to extend the :ref:`sunstone server <sunstone_dev>`.

-  **Hook Manager** to :ref:`trigger administration scripts upon VM state change <hooks>`.

.. todo:: Review and complete previous list

|OpenNebula Cloud Architecture|

.. |OpenNebula Hypervisors| image:: /images/OpenNebula_Hypervisors.png
.. |OpenNebula Cloud Architecture| image:: /images/new_overview_integrators.png
