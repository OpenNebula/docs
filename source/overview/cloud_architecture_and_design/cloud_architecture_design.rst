.. _intro:

===========================
Cloud Architecture Design
===========================

To start learning about OpenNebula, or if you want to quickly try an Edge, Hybrid or Multi-cloud deployment, we strongly recommend you start with the :ref:`Quick Start Guide <quick_start>`. In the Quick Start, you can:

  * :ref:`Install an OpenNebula Front-end <try_opennebula_on_kvm>`
  * Deploy on-demand :ref:`Edge Clusters <first_edge_cluster>` on remote cloud providers
  * Deploy :ref:`Virtual Machines <running_virtual_machines>` and :ref:`Kubernetes clusters <running_kubernetes_clusters>`
  
As you follow the tutorials you will learn the basic usage and operation of your cloud. This trial of a real cloud deployment can help you to plan for the most suitable features for performance, scalability, to get the most out of your OpenNebula cloud.

The sections below describe the high-level steps to design and deploy an OpenNebula cloud.

Step 1. Install the Front-end
=================================================

The first step is the installation of the OpenNebula Front-end. The :ref:`installation process <frontend_installation>` is based on operating system packages for the most widely-used Linux distributions, and is the same for any underlying hypervisor or deployment model.

If you are planning for a system with a very large number of hypervisors, don’t forget to read the :ref:`Large-scale Deployment <large_scale_deployment_overview>` section. The general recommendation is that each OpenNebula instance handle up to 2500 servers and 10,000 VMs. Better performance and higher scalability can be achieved by tuning other components, such as the DB. In any case, to grow the size of your cloud beyond these limits, you can horizontally scale the cloud by adding new OpenNebula zones within a federated deployment. The largest OpenNebula deployment consists of 16 data centers and 300,000 cores.

To reduce downtime of core OpenNebula services, you can optionally set up a :ref:`High-availability cluster <frontend_ha_setup>`. If planning for a large-scale infrastructure, you can :ref:`configure a MySQL/MariaDB backend <mysql>` as an alternative to the default SQLite backend.

A single OpenNebula Front-end can manage multiple clusters geographically distributed across several data centers and cloud providers. However, you can choose a multi-zone deployment with :ref:`data center federation <introf>` if data centers belong to different administrative domains or if connectivity between them does not meet latency and bandwidth requirements. Multiple OpenNebula zones can be configured as a federation, where they will share the same user accounts, groups, and permissions across data centers.

Besides connecting your cloud to the public :ref:`OpenNebula Marketplace and other third-party Marketplaces <public_marketplaces>`, you can build your own :ref:`private marketplace <private_marketplace_overview>` to provide your users with an easy way of privately publishing, downloading and sharing your own custom Appliances.

Step 2. Deploy Edge Clusters
=================================================

OpenNebula brings its own :ref:`Edge Cluster configuration <true_hybrid_cloud_reference_architecture>` that is based on solid open-source storage and networking technologies, and is a much simpler approach than those of customized cloud architectures made of more complex, general-purpose and separate infrastructure components. OpenNebula :ref:`automates the deployment of Edge Clusters <try_hybrid_overview>` on-demand, on virtual or bare-metal resources both on-premises and on your choice of public cloud or edge provider.

Step 3. Set Up Customized Clusters On-premises
=================================================

OpenNebula is certified to work on top of multiple combinations of hypervisors, storage and networking technologies. In this model, you need to first install and configure the underlying cloud infrastructure software components, then install OpenNebula to build the cloud. Clusters can be deployed on-premises or on your choice of bare-metal cloud or hosting provider. If you are interested in an OpenNebula cloud fully based on open source platforms and technologies, please refer to our :ref:`Open Cloud Reference Architecture <open_cloud_architecture>`. The reference architecture and the guide have been created from the collective information and experiences of hundreds of users and cloud client engagements. Besides the main logical components and interrelationships, these guide documents software products, configurations, and requirements of infrastructure platforms recommended for a smooth OpenNebula installation.

3.1. Choose Your Hypervisor
--------------------------------------------------

The first step in building a customized cluster is to decide on the hypervisor that you will use in your cloud infrastructure. The main OpenNebula distribution provides full support KVM, one of the most efficient and widely-used hypervisors, as well as LXC system containers.

-  **Virtualization and Cloud Management on KVM**. Many companies use OpenNebula to manage data center virtualization, consolidate servers, and integrate existing IT assets for computing, storage, and networking. In this deployment model, OpenNebula directly integrates with KVM and complete controls virtual and physical resources, providing advanced features for capacity management, resource optimization, high availability and business continuity. Some of these deployments additionally use OpenNebula’s **Cloud Management and Provisioning** features when they want to federate data centers, implement cloud bursting, or offer self-service portals for end-users.

-  **Containerization with LXC**. Containers are the next step towards virtualization. They have a minimal memory footprint and skip the compute-intensive and sometimes unacceptable performance degradation inherent to hardware emulation. You can have a very high density of containers per virtualization node and run workloads close to bare-metal metrics. LXC focuses on system containers unlike similar technologies such as Docker, which focuses on application containers.

OpenNebula allows you to deploy heterogeneous multi-hypervisor environments managed by a single OpenNebula instance, so after after having installed the cloud with one hypervisor, you can add another. The ability to gradually integrate other open source hypervisors helps to protect existing IT investments and facilitate evaluation and testing, at the same time avoiding vendor lock-in by using open-source components.

|OpenNebula Hypervisors|

3.2. Install the Virtualization Hosts
-------------------------------------------------

After selecting the hypervisor(s) for your cloud, you are ready to **add the virtualization nodes**. The OpenNebula packages bring support for :ref:`KVM <kvm_node>` and :ref:`LXC <lxd_node>` nodes. As mentioned earlier, you can add different hypervisors to the same OpenNebula instance.

3.3. Integrate with Data Center Infrastructure
------------------------------------------------------------

Now you should have an OpenNebula cloud up and running with at least one virtualization node. The next step is to configure OpenNebula to work with your infrastructure. OpenNebula directly manages the hypervisor, networking and storage platforms, and you may need additional configuration:

-  **Networking setup** with :ref:`802.1Q VLANs <hm-vlan>`, :ref:`Open vSwitch <openvswitch>` or :ref:`VXLAN <vxlan>`.

-  **Storage setup** with :ref:`NFS/NAS datastore <nas_ds>`, :ref:`Local Storage datastore <local_ds>`, :ref:`SAN datastore <lvm_drivers>`, :ref:`Ceph <ceph_ds>`, :ref:`Dev <dev_ds>`, or :ref:`iSCSI <iscsi_ds>` datastore.

-  **Host setup** with the configuration options for the :ref:`KVM hosts <kvmg>`, :ref:`LXC hosts <lxdmg>`, :ref:`Monitoring subsystem <mon>`, :ref:`Virtual Machine HA <ftguide>` or :ref:`PCI Passthrough <kvm_pci_passthrough>`.

- **Authentication setup**, OpenNebula includes by default an internal **user/password authentication system**, but it can also use an external authentication driver such as :ref:`SSH <ssh_auth>`, :ref:`x509 <x509_auth>`, :ref:`LDAP <ldap>` or :ref:`Active Directory <ldap>`.

3.4. Configure Cloud Services
--------------------------------------------------

OpenNebula runs a set of specialized, coordinated daemons and services to provide specific functions. For an in-depth overview of the main OpenNebula components, their configuration files, start/stop procedures and logging facilities please refer to the :ref:`the OpenNebula Services Guide <deployment_references_overview>`.

Step 4. Operate your Cloud
===============================================

4.1. Define a Provisioning Model
--------------------------------------------------

Before configuring multi-tenancy and defining the provisioning model of your cloud, we recommend you consult the introduction to the :ref:`OpenNebula Provisioning Model <understand>`. In a small installation with a few Hosts, you can skip this guide and use OpenNebula without giving much thought to infrastructure partitioning and provisioning. However, for medium and large deployments you will probably want to provide some level of isolation and structure.

OpenNebula helps you to define a provisioning model based on two concepts:

-  **Users and Groups.** OpenNebula features advanced multi-tenancy with powerful :ref:`user and groups management <manage_users>`, implemented through an :ref:`Access Control List <manage_acl>` mechanism that allows for differential role management based on fine-grained permissions that can be applied over any resource. The :ref:`resource quota management <quota_auth>` subsystem lets you track and limit the use of computing, storage and networking resources.

-  **Virtual Data Centers** or :ref:`VDCs <manage_vdcs>` allow you to assign one or more user groups to a pool of physical resources. You can also create *logical* pools of resources—which may physically belong to different clusters and zones—and allocate them to user groups.

Finally, the :ref:`accounting <accounting>` and :ref:`showback <showback>` modules allow you to visualize and report resource usage data, produce usage reports, and integrate with chargeback and billing platforms.

4.2. Manage Virtual Resources
--------------------------------------------------

Now everything is ready for operation. OpenNebula provides you with full control to manage virtual resources.

-  **Virtual machine image management** that allows you to store disk images in :ref:`catalogs <img_guide>` (termed datastores), that can then be used to define VMs, or be shared with other users. The images may be OS installations, persistent datasets or empty data blocks that are created within the datastore.

-  **Virtual network management** allows you to organize :ref:`Virtual networks <manage_vnets>` in catalogs, as well as to provide means to interconnect virtual machines. This type of resource may be defined as IPv4, IPv6, or mixed networks, and may be used to achieve full isolation between virtual networks. Networks can be easily interconnected by :ref:`virtual routers <vrouter>`, and may be hardened by dynamic configuration of :ref:`security groups <security_groups>`

-  **Virtual machine template management** implements a :ref:`template catalog <vm_guide>` that allows you to register :ref:`virtual machine <vm_guide_2>` definitions to be instantiated later as Virtual Machines.

-  **Virtual machine instance management** includes a number of operations to control the life cycle of :ref:`virtual machine instances <vm_guide_2>`, such as migration (live and cold), stop, resume, cancel, power-off or :ref:`backup <vm_backup>`.

-  :ref:`OneFlow <oneapps_overview>` implements **multi-VM application and auto-scaling** to :ref:`define, execute and manage multi-tiered elastic applications <appflow_use_cli>`, or services composed of interconnected Virtual Machines with deployment dependencies between them, using :ref:`auto-scaling rules <appflow_elasticity>`.

-  **Application insight** with :ref:`OneGate <onegate_overview>` allows Virtual Machine guests to pull and push VM information from OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VM.

Reference guides are provided with more information about definition files, templates, and the CLI.

4.3. Add contents to your Cloud
--------------------------------------------------

OpenNebula offers multiple options for adding Applications to your cloud, from using your existing disk images to downloading them from public or private Marketplaces. For information on creating new applications, see the :ref:`Creating Images <images>` section.

Step 5. Integrate with other Components
===============================================

This step is optional and only for integrators and builders.

Because no two clouds are the same, OpenNebula provides many different interfaces that can be used to interact with the functionality offered to manage physical and virtual resources.

-  A **Modular and extensible architecture** with :ref:`customizable plug-ins <intro_integration>` for integration with any third-party data center infrastructure platform for :ref:`storage <sd>`, :ref:`monitoring <devel-im>`, :ref:`networking <devel-nm>`, :ref:`authentication <devel-auth>`, :ref:`virtualization <devel-vmm>` and :ref:`market <devel-market>`.

-  A **Rich API set** that offers all the functionality of OpenNebula components, with bindings for :ref:`Ruby <ruby>` and :ref:`Java <java>` as well as the :ref:`XML-RPC API <api>`. These APIs will ease the integration of your cloud with higher-level tools such as chargeback, billing or self-service platforms.

-  The **OneFlow API** to create, control and monitor :ref:`multi-tier applications or services <appflow_api>` composed of interconnected Virtual Machines.

-  A **Hook Manager** to :ref:`trigger administration scripts <hooks>` upon resource state changes or API calls.

|OpenNebula Cloud Architecture|

.. |OpenNebula Hypervisors| image:: /images/6_features.png
  :width: 70%
  :align: center

.. |OpenNebula Cloud Architecture| image:: /images/new_overview_integrators.png
  :width: 70%
  :align: center  
