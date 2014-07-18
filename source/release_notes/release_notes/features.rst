.. _features:

========
Features
========

This section describes the **detailed features and functionality of OpenNebula** for the management of private clouds and datacenter virtualization(\*). It includes links to the different parts of the documentation and the web site that provide extended information about each feature. We also provide a summarized table of `key features <http://opennebula.org/about/key-features/>`__.

Powerful User Security Management
=================================

-  Secure and efficient :ref:`Users and Groups Subsystem <auth_overview>` for authentication and authorization of requests with complete functionality for `user management <http://docs.opennebula.org/doc/4.6/cli/oneuser.1.html>`__: create, delete, show...
-  :ref:`Pluggable authentication and authorization <external_auth>` based on :ref:`passwords <manage_users_users>`, :ref:`ssh rsa keypairs <ssh_auth>`, :ref:`X509 certificates <x509_auth>`, :ref:`LDAP <ldap>` or :ref:`Active Directory <ldap>`
-  Special authentication mechanisms for :ref:`SunStone (OpenNebula GUI) <sunstone>` and the :ref:`Cloud Services (EC2) <cloud_auth>`
-  Authorization framework with :ref:`fine-grained ACLs <manage_acl>` that allows multiple-role support for different types of users and administrators, delegated control to authorized users, secure isolated multi-tenant environments, and easy resource (VM template, VM image, VM instance, virtual network and host) sharing

Advanced Multi-tenancy with Group Management
============================================

-  Administrators can :ref:`groups users <manage_users_groups>` into organizations that can represent different projects, division...
-  Each group have :ref:`configurable access to shared resources <manage_acl>` so enabling a multi-tenant environment with multiple groups sharing the same infrastructure
-  Configuration of special :ref:`users that are restricted to public cloud APIs <cloud_auth>` (EC2)
-  Complete functionality for management of `groups <http://docs.opennebula.org/doc/4.6/cli/onegroup.1.html>`__: create, delete, show...
-  Multiple group support, with the ability to define `primary and secondary groups <http://opennebula.org/manage_users#primary_and_secondary_groups>`__.

On-demand Provision of Virtual Data Centers
===========================================

- A vDC is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the vDC admin, can create and manage compute and storage capacity.
- User Groups can be assigned one or more resource providers. Resource providers are defined as a cluster of servers, virtual networs, datastores and public clouds for cloud bursting in an OpenNebula zone. Read more in the :ref:`Users and Groups Management Guide <managing_resource_provider_within_groups>`.
- A special administration group can be defined to manage specific aspects of the group like user management or appliances definition. Read more in the :ref:`Managing Users and Groups <manage_users>` guide.
- Sunstone views for new groups can be dynamically defined without the need of modifying the Sunstone configuration files. More information in the :ref:`Sunstone Views <suns_views>` guide.
- Groups can now be tagged with custom attributes. Read more in the :ref:`Managing Users and Groups <manage_users>` guide.

Advanced Control and Monitoring of Virtual Infrastructure
=========================================================

-  :ref:`Image Repository Subsystem <img_guide>` with catalog and complete functionality for `VM image management <http://docs.opennebula.org/doc/4.6/cli/oneimage.1.html>`__: list, publish, unpublish, show, enable, disable, register, update, saveas, delete, clone...
-  :ref:`Template Repository Subsystem <vm_guide>` with catalog and complete functionality for `VM template management <http://docs.opennebula.org/doc/4.6/cli/onetemplate.1.html>`__: add, delete, list, duplicate...
-  :ref:`Full control of VM instance life-cycle <vm_guide_2>` and complete functionality for `VM instance management <http://docs.opennebula.org/doc/4.6/cli/onevm.1.html>`__: submit, deploy, migrate, livemigrate, reschedule, stop, save, resume, cancel, shutdown, restart, reboot, delete, monitor, list, power-on, power-off,...
-  Advanced functionality for VM dynamic management like :ref:`system and disk snapshotting <vm_guide2_snapshotting>`, :ref:`capacity resizing <vm_guide2_resizing_a_vm>`, or :ref:`NIC hotplugging <vm_guide2_nic_hotplugging>`
-  :ref:`Programmable VM operations <vm_guide2_scheduling_actions>`, so allowing users to schedule actions
-  Volume hotplugging to easily hot plug a volatile disk created on-the-fly or an existing image from a Datastore to a running VM
-  :ref:`Broad network virtualization capabilities <vgg>` with traffic isolation, definition of generic attributes to define multi-tier services consisting of groups of inter-connected VMs, and complete functionality for `virtual network management <http://docs.opennebula.org/doc/4.6/cli/onevnet.1.html>`__ to interconnect VM instances: create, delete, monitor, list...
-  :ref:`IPv6 support <vgg_ipv6_networks>` with definition site and global unicast addresses
-  Configurable :ref:`system accounting statistics <accounting>` to visualize and report resource usage data, to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users
-  Tagging of users, VM images and virtual networks with arbitrary metadata that can be later used by other components
-  :ref:`User defined VM tags <vm_guide2_user_defined_data>` to simplify VM management and to store application specific data
-  :ref:`Plain files datastore <file_ds>` to store kernels, ramdisks and files to be used in context. The whole set of OpenNebula features applies, e.g. ACLs, ownership...

Complete Virtual Machine Configuration
======================================

-  Complete :ref:`definition of VM attributes and requirements <template>`
-  Support for automatic configuration of VMs with advanced :ref:`contextualization mechanisms <cong>`
-  :ref:`Cloud-init <cloud-init>` support
-  :ref:`Hook Manager <hooks>` to trigger administration scripts upon VM state change
-  Wide range of guest operating system including Microsoft Windows and Linux
-  :ref:`Flexible network defintion <vnet_template>`
-  :ref:`Configuration of firewall for VMs <firewall>` to specify a set of black/white TCP/UDP ports

Advanced Control and Monitoring of Physical Infrastructure
==========================================================

-  :ref:`Configurable to deploy public, private and hybrid clouds <intro>`
-  :ref:`Host Management Subsystem <host_guide>` with complete functionality for management of `physical hosts <http://docs.opennebula.org/doc/4.6/cli/onehost.1.html>`__: create, delete, enable, disable, monitor, list...
-  Dynamic creation of :ref:`clusters <cluster_guide>` as a logical set of physical resources, namely: hosts, networks and data stores, within each zone
-  Highly scalable and extensible built-in :ref:`monitoring subsystem <mon>`

Broad Commodity and Enterprise Platform Support
===============================================

-  Hypervisor agnostic :ref:`Virtualization Subsystem <vmmg>` with broad hypervisor support (:ref:`Xen <xeng>`, :ref:`KVM <kvmg>` and :ref:`VMware <evmwareg>`), centralized management of environments with multiple hypervisors, and support for multiple hypervisors within the same physical box
-  :ref:`Storage Subsystem <sm>` with support for multiple data stores to balance I/O operations between storage servers, or to define different SLA policies (e.g. backup) and performance features for different VM types or users
-  :ref:`Storage Subsystem <sm>` supporting any backend configuration with different datastore types: :ref:`file system datastore <fs_ds>`, to store disk images in a file form and with image transferring using ssh or shared file systems (NFS, GlusterFS, Lustre...), :ref:`LVM <lvm_drivers>` to store disk images in a block device form, :ref:`Ceph <ceph_ds>` for distributed block device, and :ref:`VMware datastore <vmware_ds>` specialized for the VMware hypervisor that handle the vmdk format and with support for VMFS
-  Flexible :ref:`Network Subsystem <nm>` with integration with :ref:`Ebtable <ebtables>`, :ref:`Open vSwitch <openvswitch>` and :ref:`802.1Q tagging <hm-vlan>`
-  :ref:`Virtual Router <router>` fully integrated with OpenNebula to provide basic L3 services like NATting, DHCP, DNS...

Distributed Resource Optimization
=================================

-  Powerful and flexible :ref:`requirement/rank matchmaker scheduler <schg>` providing automatic initial VM placement for the definition of workload and resource-aware allocation policies such as packing, striping, load-aware, affinity-aware...
-  :ref:`Advanced requirement expressions <template_requirement_expression_syntax>` with cluster attributes for VM placement, affinity policies, any host attribute for scheduling expressions, and scheduler feedback through VM tags
-  Powerful and flexible :ref:`requirement/rank matchmaker scheduler <system_ds_multiple_system_datastore_setups>` for storage load balancing to distribute efficiently the I/O of the VMs across different disks, LUNs or several storage backends
-  :ref:`Resource quota management <quota_auth>` to allocate, track and limit computing, storage and networking resource utilization
-  Support for :ref:`cgroups <kvmg_working_with_cgroups_optional>` on KVM to enforce VM CPU usage as described in the VM Template

Centralized Management of Multiple Zones
========================================

- Federation of multiple OpenNebula zones for scalability, isolation or multiple-site support
- Users can seamlessly provision virtual machines from multiple zones with an integrated interface both in Sunstone and CLI.
- A new tool set has been developed to upgrade, integrate new zones and import existing zones into an OpenNebula federation. Read more in the :ref:`Federation Configuration <federationconfig>` guide.
- Integrated zone management in OpenNebula core. Read more about this in the :ref:`Data Center Federation <introf>` guide.
- Redesigned data model to minimize replication data across zones and to tolerate large latencies. Read more about this in the :ref:`Data Center Federation <introf>` guide.
-  Complete functionality for management of `zones <http://docs.opennebula.org/doc/4.6/cli/onezone.1.html>`__: create, delete, show, list...

High Availability
=================

-  Persistent database backend with support for high availability configurations
-  :ref:`Configurable behavior in the event of host, VM, or OpenNebula instance failure to provide an easy to use and cost-effective failover solution <ftguide>`
-  Support for :ref:`high availability architectures <oneha>`

Community Virtual Appliance Marketplace
=======================================

-  `Marketplace <http://marketplace.c12g.com>`__ with an online catalog where individuals and organizations can quickly distribute and deploy virtual appliances ready-to-run on OpenNebula cloud environments
-  :ref:`Marketplace is fully integrated with OpenNebula <marketplace>` so any user of an OpenNebula cloud can find and deploy virtual appliances in a single click through familiar tools like the SunStone GUI or the OpenNebula CLI
-  Support for importing OVAs processed by the AppMarket Worker. Read more `here <https://github.com/OpenNebula/addon-appmarket/blob/master/doc/usage.md#importing-an-appliance-from-sunstone>`__.


Management of Multi-tier Applications
=====================================

-  :ref:`Automatic execution of multi-tiered applications <oneapps_overview>` with complete `functionality for the management of groups of virtual machines as a single entity <http://docs.opennebula.org/doc/4.6/cli/oneflow.1.html>`__: list, delete, scale up, scale down, shutdown... and the `management of Service Templates <http://docs.opennebula.org/doc/4.6/cli/oneflow-template.1.html>`__: create, show, delete, instantiate...
-  :ref:`Automatic deployment and undeployment of Virtual Machines <appflow_use_cli>` according to their dependencies in the Service Template
-  Provide configurable services from a catalog and self-service portal
-  Enable tight, efficient administrative control
-  Complete integration with the OpenNebula's `User Security Management <http://opennebula.org/documentation:features#powerful_user_security_management>`__ system
-  Computing resources can be tracked and limited using OpenNebula's :ref:`Resource Quota Management <quota_auth>`
-  :ref:`Automatic scaling of multi-tiered applications <appflow_elasticity>` according to performance metrics and time schedule

Gain Insight into Cloud Applications
====================================

-  :ref:`OneGate allows Virtual Machine guests to push monitoring information to OpenNebula <onegate_usage>`
-  With a security token the VMs can call back home and report guest and/or application status in a simple way, that can be easily queried through OpenNebula interfaces (Sunstone, CLI or API).
-  Users and administrators can use it to gather metrics, detect problems in their applications, and trigger :ref:`OneFlow auto-scaling rules <appflow_elasticity>`

Hybrid Cloud Computing and Cloud Bursting
=========================================

-  :ref:`Extension of the local private infrastructure with resources from remote clouds <introh>`
-  :ref:`Support for Amazon EC2 <ec2g>` with most of the EC2 features like tags, security groups or VPC; and simultaneous access to multiple remote clouds

Standard Cloud Interfaces and Simple Provisioning Portal for Cloud Consumers
============================================================================

-  :ref:`Transform your local infrastructure into a public cloud by exposing REST-based interfaces <introc>`
-  :ref:`AWS EC2 API service <ec2qcg>`, the de facto cloud API standard, with :ref:`compatibility with EC2 ecosystem tools <ec2qec>` and :ref:`client tools <ec2qug>`
-  Support for simultaneously exposing multiple cloud APIs
-  :ref:`Provisioning portal implemented as a user view of Sunstone <cloud_view>` to allow non-IT end users to easily create, deploy and manage compute, storage and network resources

Rich Command Line and Web Interfaces for Cloud Administrators
=============================================================

-  :ref:`Unix-like Command Line Interface <cli>` to manage all resources: users, VM images, VM templates, VM instances, virtual networks, zones, VDCs, physical hosts, accounting, authentication, authorization...
-  :ref:`Easy-to-use Sunstone Graphical Interface <sunstone>` providing usage graphics and statistics with cloudwatch-like functionality, VNC support, different system views for different roles, catalog access, multiple-zone management...
-  :ref:`Sunstone is easily customizable <suns_views>` to define multiple cloud views for different user groups

Multiple Deployment Options
===========================

-  :ref:`Easy to install and update <ignc>` with `packages for most common Linux distributions <http://opennebula.org/software:software>`__
-  `Available in most popular Linux distributions <http://opennebula.org/software:software>`__
-  :ref:`Optional building from source code <compile>`
-  :ref:`System features a small footprint <plan>`, less than 10Mb
-  :ref:`Detailed log files <log_debug>` with :ref:`syslog support <log_debug_configure_the_logging_system>` for the different components that maintain a record of significant changes

Easy Extension and Integration
==============================

-  Modular and extensible architecture to fit into any existing datacenter
-  Customizable drivers for the main subsystems to easily leverage existing IT infrastructure and system management products: :ref:`Virtualization <devel-vmm>`, :ref:`Storage <sd>`, :ref:`Monitoring <devel-im>`, :ref:`Network <devel-nm>`, :ref:`Auth <auth_overview>` and :ref:`Hybrid Cloud <devel-vmm>`
-  New drivers can be easily written in any language
-  Plugin support to easily extend SunStone Graphical Interface with additional tabs to better integrate Cloud and VM management with each site own operations and tools
-  Easily customizable self-service portal for cloud consumers
-  :ref:`Configuration and tuning parameters <oned_conf>` to adjust behavior of the cloud management instance to the requirements of the environment and use cases
-  `Fully open-source technology available under Apache license <http://dev.opennebula.org/projects/opennebula/repository>`__
-  Powerful and extensible low-level cloud API in :ref:`Ruby <ruby>` and :ref:`JAVA <java>` and :ref:`XMLRPC API <api>`
-  `OpenNebula Add-on Catalog <http://opennebula.org/addons:addons>`_ with components enhancing the functionality provided by OpenNebula

Reliability, Efficiency and Massive Scalability
===============================================

-  `Automated testing process for functionality, scalability, performance, robustness and stability <http://opennebula.org/software:testing>`_
-  `Technology matured through an active and engaged community <http://opennebula.org/community:community>`_
-  Proven on large scale infrastructures consisting of tens of thousands of cores and VMs
-  Highly scalable database back-end with support for :ref:`MySQL <mysql>` and SQLite
-  Virtualization drivers adjusted for maximum scalability
-  Very efficient core developed in C++ language

(\*) *Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.*

-  *The list of features may change on the different platform configurations*
-  *Not all platform configurations exhibit a similar performance and stability*
-  *The features may change to offer users more features and integration with other virtualization and cloud components*
-  *The features may change due to changes in the functionality provided by underlying virtualization services*

