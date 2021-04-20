.. _intro:

===========================
Cloud Architecture Design
===========================

In order to get familiar with OpenNebula, or if you want to try an Edge, Hybrid or Multi-cloud deployment, we strongly recommend you start with the :ref:`Quick Start guide <quick_start>`. In the Quick Start, you will learn how to install a single OpenNebula Front-end, deploy on-demand Edge Clusters on remote cloud providers, as well as the basic usage and operation of your cloud. This trial of a real cloud deployment will help you create a plan with the features, performance, scalability, and high availability characteristics in order to get the most out of an OpenNebula Cloud.

Step 1. Install the Front-end
=================================================

The first step is the installation of OpenNebula in the cloud Front-end. This :ref:`installation process <frontend_installation>` based on operating system packages for the most widely used Linux distributions is the same for any underlying hypervisor or deployment model. Alternatively, you can deploy the complete OpenNebula Front-end from the :ref:`official container image <container_overview>` on Docker or Podman. Container installation is in Technology Preview and only supported for testing and development.

Don't forget to read the section about :ref:`Large-scale Deployment <large_scale_deployment_overview>` if you're planning a system with a very large number of hypervisors. The general recommendation is to have no more than 2,500 servers and 10,000 VMs managed by a single instance. Better performance and higher scalability can be achieved with specific tuning of other components like the DB. In any case, to grow the size of your cloud beyond these limits, you can horizontally scale your cloud by adding new OpenNebula zones within a federated deployment. The largest OpenNebula deployment consists of 16 data centers and 300,000 cores.  

Optionally you can set up a :ref:`high available cluster <frontend_ha_setup>` for OpenNebula to reduce downtime of core OpenNebula services, and :ref:`configure a MySQL/MariaDB backend <mysql>` as an alternative to the default Sqlite Back-end if you are planning a large-scale infrastructure. :ref:`PostgreSQL <postgresql_setup>` is also supported but for evaluation only (Technology Preview).

Although a single OpenNebula Front-end can manage multiple clusters geographically distributed in several data centers and cloud providers, a multi-zone deployment with :ref:`datacenter federation <introf>` functionality can be chosen when data centers are in different administrative domains or when the connectivity across data centers does not meet latency and bandwidth requirements. Multiple OpenNebula zones can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across data centers.

Besides connecting your cloud to the public :ref:`OpenNebula Marketplace and other third-party Marketplaces like Docker Hub and Linux Containers <public_marketplaces>`, you can build your own :ref:`private marketplace <private_marketplace_overview>` to provide your users with an easy way of privately publishing, downloading and sharing your own custom Appliances.

Step 2. Deploy Edge Clusters
=================================================

OpenNebula brings its own :ref:`Edge Cluster configuration that is based on solid open source storage and networking technologies <true_hybrid_cloud_reference_architecture>`, and is a much simpler approach than those of customized cloud architectures made of more complex, general-purpose and separate infrastructure components. :ref:`OpenNebula automates the deployment of Edge Clusters on-demand on virtual or bare-metal resources both on-premises and on your choice of public cloud or edge provider<try_hybrid_overview>`. 

Step 3. Set up Customized Clusters On-premises
=================================================

OpenNebula is certified to work on top of multiple combinations of hypervisors, storage and networking technologies. In this model, you need to install and configure the underlying cloud infrastructure software components first and then install OpenNebula to build the cloud. The clusters can be deployed on-premises or on your choice of bare-metal cloud or hosting provider. If you are interested in designing and deploying an OpenNebula cloud on top of VMware vCenter, please refer to our :ref:`VMWare Cloud Reference Architecture <vmware_cloud_architecture>`. If you are interested in an OpenNebula cloud fully based on open source platforms and technologies, please refer to our :ref:`Open Cloud Reference Architecture <open_cloud_architecture>`. These guides have been created from the collective information and experiences of hundreds of users and cloud client engagements. Besides the main logical components and interrelationships, these guides document software products, configurations, and requirements of infrastructure platforms recommended for a smooth OpenNebula installation.

3.1.Choose Your Hypervisor
--------------------------------------------------

The first step in building a customized cluster is to decide on the hypervisor that you will use in your cloud infrastructure. The main OpenNebula distribution provides full support for the two most widely used hypervisors, KVM and VMware (through vCenter), LXC system containers, and Firecracker lightweight virtualization at different levels of functionality.

-  **Virtualization and Cloud Management on KVM**. Many companies use OpenNebula to manage data center virtualization, consolidate servers, and integrate existing IT assets for computing, storage, and networking. In this deployment model, OpenNebula directly integrates with KVM and has complete control over virtual and physical resources, providing advanced features for capacity management, resource optimization, high availability and business continuity. Some of these deployments additionally use OpenNebula’s **Cloud Management and Provisioning** features when they want to federate data centers, implement cloud bursting, or offer self-service portals for end-users.

-  **Cloud Management on VMware vCenter**. Other companies use OpenNebula to provide a multi-tenant, cloud-like provisioning layer on top of VMware vCenter. These deployments are looking for provisioning, elasticity and multi-tenancy cloud features like virtual data centers provisioning, datacenter federation or hybrid cloud computing to connect in-house infrastructures with public clouds, while the infrastructure is managed by already familiar tools for infrastructure management and operation, such as vSphere and vCenter Operations Manager.

-  **Containerization with LXC**. Containers are the next step towards virtualization. They have a minimal memory footprint and skip the compute intensive and sometimes unacceptable performance degradation inherent to hardware emulation. You can have a very high density of containers per virtualization node and run workloads close to bare-metal metrics. LXC focuses on system containers unlike similar technologies like Docker, which focuses on application containers.

-  **Lightweight Virtualization on Firecracker**. Firecracker MicroVMs provide enhanced security and workload isolation over traditional container solutions while preserving their speed and resource efficiency. MicroVMs are especially designed for creating and managing secure, multi-tenant container (CaaS) and function-based (FaaS) services.

After having installed the cloud with one hypervisor, you may add other hypervisors. You can deploy heterogeneous multi-hypervisor environments managed by a single OpenNebula instance. An advantage of using OpenNebula on VMware is the strategic path to openness as companies move beyond virtualization toward a private cloud. OpenNebula can leverage existing VMware infrastructure, protecting IT investments, and at the same time gradually integrate other open source hypervisors, therefore avoiding future vendor lock-in and strengthening the negotiating position of the company.

|OpenNebula Hypervisors|

3.2. Install the Virtualization hosts
-------------------------------------------------

Now you are ready to **add the virtualization nodes**. The OpenNebula packages bring support for :ref:`KVM <kvm_node>`, :ref:`LXC <lxd_node>`, :ref:`Firecracker <fc_node>` and :ref:`vCenter <vCenter_node>` nodes. In the case of vCenter, a host represents a vCenter cluster with all its ESX hosts. You can add different hypervisors to the same OpenNebula instance.

3.3. Integrate with Data Center Infrastructure
------------------------------------------------------------

Now you should have an OpenNebula cloud up and running with at least one virtualization node. The next step is to configure OpenNebula to work with your infrastructure. When using the vCenter driver, no additional configurations are needed.

However, when using KVM, LXC or Firecracker, OpenNebula directly manages the hypervisor, networking and storage platforms, and you may need additional configuration:

-  **Networking setup** with :ref:`802.1Q VLANs <hm-vlan>`, :ref:`ebtables <ebtables>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage setup** with :ref:`NFS/NAS datastore <nas_ds>`, :ref:`Local Storage datastore <local_ds>`, :ref:`SAN datastore <lvm_drivers>`, :ref:`Ceph <ceph_ds>`, :ref:`Dev <dev_ds>`, or :ref:`iSCSI <iscsi_ds>` datastore.

-  **Host setup** with the configuration options for the :ref:`KVM hosts <kvmg>`, :ref:`LXC hosts <lxdmg>`, :ref:`Firecracker hosts <fcmg>` :ref:`Monitoring subsystem <mon>`, :ref:`Virtual Machine HA <ftguide>` or :ref:`PCI Passthrough <kvm_pci_passthrough>`.

- **Authenticagtion setup**, OpenNebula comes by default with an internal **user/password authentication system**, but it can use an external Authentication driver like :ref:`ssh <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`ldap <ldap>` or :ref:`Active Directory <ldap>`.

3.4. Configure Cloud Services
--------------------------------------------------

OpenNebula operates coordinating a set of specialized daemons and services to provide specific functions. You can get an in-depth overview of the main OpenNebula components, their configuration files, start and stop procedures as well as logging facilities in :ref:`the OpenNebula Services Guide <deployment_references_overview>`.

Step 4. Operate your Cloud
===============================================

4.1. Define a Provisioning Model
--------------------------------------------------

Before configuring multi-tenancy and defining the provisioning model of your cloud, we recommend you go through this introduction to the :ref:`OpenNebula provisioning model <understand>`. In a small installation with a few Hosts, you can skip this guide and use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

OpenNebula helps you to define a provisioning model with two concepts:

-  **Users and Groups.** OpenNebula features advanced multi-tenancy with powerful :ref:`users and groups management <manage_users>`, an :ref:`Access Control List <manage_acl>` mechanism allowing different role management with fine-grain permission granting over any resource. The :ref:`resource quota management <quota_auth>` subsystem lets you track and limit computing, storage and networking utilization.

-  **Virtual Data Centers** :ref:`VDCs <manage_vdcs>` let you assign one or more user groups to a pool of physical resources. Virtual Data Centers (VDCs) allow the creation of *logical* pools of resources (which could belong to different clusters and zones) and allocate them to user groups.

Finally, with the :ref:`accounting  <accounting>` and :ref:`showback  <showback>` modules you can visualize and report resource usage data periodically, and eventually, allow its integration with chargeback and billing platforms.

4.2. Manage Virtual Resources
--------------------------------------------------

Now everything is ready for operation. OpenNebula provides full control to manage virtual resources.

-  **Virtual machine image management** that allows you to store :ref:`disk images in catalogs <img_guide>` (termed datastores), that can then be used to define VMs or shared with other users. The images can be OS installations, persistent datasets or empty data blocks that are created within the datastore.

-  **Virtual network management** of :ref:`Virtual networks <manage_vnets>` that can be organized in network catalogs and provide means to interconnect virtual machines. This kind of resource can be defined as IPv4, IPv6, or mixed networks, and can be used to achieve full isolation between virtual networks. Networks can be easily interconnected by using :ref:`virtual routers <vrouter>` and KVM, LXC and Firecracker users can also dynamically configure :ref:`security groups <security_groups>`

-  **Virtual machine template management** with a :ref:`template catalog <vm_guide>` system that allows the registering of :ref:`virtual machine <vm_guide_2>` definitions in the system, to be instantiated later as Virtual Machine instances.

-  **Virtual machine instance management** with a number of operations that can be performed to control the lifecycle of the :ref:`virtual machine instances <vm_guide_2>`, such as migration (live and cold), stop, resume, cancel, power-off,... or :ref:`backup <vm_backup>`.

-  :ref:`OneFlow <oneapps_overview>` allows **multi-VM application and auto-scaling** to :ref:`define, execute and manage multi-tiered elastic applications <appflow_use_cli>`, or services composed of interconnected Virtual Machines with deployment dependencies between them and :ref:`auto-scaling rules <appflow_elasticity>`.

-  **Application insight** with :ref:`OneGate <onegate_overview>` allows Virtual Machine guests to pull and push VM information from OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VM.

Several reference guides are provided for more information about definition files, templates, and the CLI.

4.3. Add contents to your Cloud
--------------------------------------------------

You have multiple options when adding Applications to your cloud, from using your existing disk images to download them from public Marketplaces. Please refer to the :ref:`Creating Images section of the Image Guide <images>`.

Step 5. Integrate with other Components
===============================================

This step is optional and only for integrators and builders.

Because no two clouds are the same, OpenNebula provides many different interfaces that can be used to interact with the functionality offered to manage physical and virtual resources.

-  **Modular and extensible architecture** with :ref:`customizable plug-ins <intro_integration>` for integration with any third-party data center infrastructure platform for :ref:`storage <sd>`, :ref:`monitoring <devel-im>`, :ref:`networking <devel-nm>`, :ref:`authentication <devel-auth>`, :ref:`virtualization <devel-vmm>` and :ref:`market <devel-market>`.

-  **Rich API set** that offers all the functionality of OpenNebula components, with bindings for :ref:`ruby <ruby>` and :ref:`java <java>` and :ref:`XML-RPC API <api>`. These APIs will ease the integration of your cloud with higher level tools such as billing, self-service portals...

-  **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services composed of interconnected Virtual Machines <appflow_api>`.

-  **Sunstone custom routes and tabs** to extend the :ref:`sunstone web UI interface <sunstone_dev>`.

-  **Hook Manager** to :ref:`trigger administration scripts upon resource state changes or API calls <hooks>`.

|OpenNebula Cloud Architecture|

.. |OpenNebula Hypervisors| image:: /images/6_features.png
  :width: 70%

.. |OpenNebula Cloud Architecture| image:: /images/new_overview_integrators.png
  :width: 70%

