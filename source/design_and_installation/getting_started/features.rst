.. _features:

===================================================
OpenNebula 4.4 Detailed Features and Functionality
===================================================

This section describes the **detailed features and functionality of the latest version of OpenNebula (v4.4)** for the management of private clouds and datacenter virtualization(\*). It includes links to the different parts of the documentation and the web site that provide extended information about each feature. We also provide a summarized table of `key features <http://opennebula.org/about:keyfeatures>`__.

Powerful User Security Management
=================================

-  Secure and efficient :ref:`Users and Groups Subsystem <documentation:rel4.4:auth_overview>` for authentication and authorization of requests with complete functionality for `user management <http://opennebula.org/doc/4.4/cli/oneuser.1.html>`__: create, delete, show...
-  :ref:`Pluggable authentication and authorization <documentation:rel4.4:external_auth>` based on :ref:`passwords <documentation:rel4.4:manage_users#users>`, :ref:`ssh rsa keypairs <documentation:rel4.4:ssh_auth>`, :ref:`X509 certificates <documentation:rel4.4:x509_auth>`, :ref:`LDAP <documentation:rel4.4:ldap>` or :ref:`Active Directory <documentation:rel4.4:ldap>`
-  Special authentication mechanisms for :ref:`SunStone (OpenNebula GUI) <documentation:rel4.4:sunstone#authentication_methods>` and the :ref:`Cloud Services (EC2 and OCCI) <documentation:rel4.4:cloud_auth>`
-  Authorization framework with :ref:`fine-grained ACLs <documentation:rel4.4:manage_acl>` that allows multiple-role support for different types of users and administrators, delegated control to authorized users, secure isolated multi-tenant environments, and easy resource (VM template, VM image, VM instance, virtual network and host) sharing

Advanced Multi-tenancy with Group Management
============================================

-  Administrators can :ref:`groups users <documentation:rel4.4:manage_users#groups>` into organizations that can represent different projects, division...
-  Each group have :ref:`configurable access to shared resources <documentation:rel4.4:manage_acl>` so enabling a multi-tenant environment with multiple groups sharing the same infrastructure
-  Configuration of special :ref:`users that are restricted to public cloud APIs <documentation:rel4.4:cloud_auth>` (e.g. EC2 or OCCI)
-  Complete functionality for management of `groups <http://opennebula.org/doc/4.4/cli/onegroup.1.html>`__: create, delete, show...
-  Multiple group support, with the ability to define `primary and secondary groups <http://opennebula.org/documentation:rel4.4:manage_users#primary_and_secondary_groups>`__.

On-demand Provision of Virtual Data Centers
===========================================

-  A :ref:`Virtual Data Centers (VDC) <documentation:rel4.4:vdcmngt>` is a fully-isolated virtual infrastructure environment where a group of users, under the control of the VDC administrator, can create and manage compute, storage and networking capacity
-  Support for the creation and management of multiples VDCs within the same logical cluster and zone
-  Advanced multi-tenancy with complete functionality for management of `VDCs <http://opennebula.org/doc/4.4/cli/onevdc.1.html>`__: create, delete, show...

Advanced Control and Monitoring of Virtual Infrastructure
=========================================================

-  :ref:`Image Repository Subsystem <documentation:rel4.4:img_guide>` with catalog and complete functionality for `VM image management <http://opennebula.org/doc/4.4/cli/oneimage.1.html>`__: list, publish, unpublish, show, enable, disable, register, update, saveas, delete, clone...
-  :ref:`Template Repository Subsystem <documentation:rel4.4:vm_guide>` with catalog and complete functionality for `VM template management <http://opennebula.org/doc/4.4/cli/onetemplate.1.html>`__: add, delete, list, duplicate...
-  :ref:`Full control of VM instance life-cycle <documentation:rel4.4:vm_guide_2>` and complete functionality for `VM instance management <http://opennebula.org/doc/4.4/cli/onevm.1.html>`__: submit, deploy, migrate, livemigrate, reschedule, stop, save, resume, cancel, shutdown, restart, reboot, delete, monitor, list, power-on, power-off,...
-  Advanced functionality for VM dynamic management like :ref:`system and disk snapshotting <documentation:rel4.4:vm_guide_2#snapshotting>`, :ref:`capacity resizing <documentation:rel4.4:vm_guide_2#resizing_a_vm>`, or :ref:`NIC hotplugging <documentation:rel4.4:vm_guide_2#nic_hotpluging>`
-  :ref:`Programmable VM operations <documentation:rel4.4:vm_guide_2#scheduling_actions>`, so allowing users to schedule actions
-  Volume hotplugging to easily hot plug a volatile disk created on-the-fly or an existing image from a Datastore to a running VM
-  :ref:`Broad network virtualization capabilities <documentation:rel4.4:vgg>` with traffic isolation, ranged or fixed networks, definition of generic attributes to define multi-tier services consisting of groups of inter-connected VMs, and complete functionality for `virtual network management <http://opennebula.org/doc/4.4/cli/onevnet.1.html>`__ to interconnect VM instances: create, delete, monitor, list...
-  :ref:`IPv6 support <documentation:rel4.4:vgg#ipv6_networks>` with definition site and global unicast addresses
-  Configurable :ref:`system accounting statistics <documentation:rel4.4:accounting>` to visualize and report resource usage data, to allow their integration with chargeback and billing platforms, or to guarantee fair share of resources among users
-  Tagging of users, VM images and virtual networks with arbitrary metadata that can be later used by other components
-  :ref:`User defined VM tags <documentation:rel4.4:vm_guide_2#user_defined_data>` to simplify VM management and to store application specific data
-  :ref:`Plain files datastore <documentation:rel4.4:file_ds>` to store kernels, ramdisks and files to be used in context. The whole set of OpenNebula features applies, e.g. ACLs, ownership...

Complete Virtual Machine Configuration
======================================

-  Complete :ref:`definition of VM attributes and requirements <documentation:rel4.4:template>`
-  Support for automatic configuration of VMs with advanced :ref:`contextualization mechanisms <documentation:rel4.4:cong>`
-  :ref:`Cloud-init <documentation:rel4.4:cloud-init>` support
-  :ref:`Hook Manager <documentation:rel4.4:hooks>` to trigger administration scripts upon VM state change
-  Wide range of guest operating system including Microsoft Windows and Linux
-  :ref:`Flexible network defintion <documentation:rel4.4:vnet_template>`
-  :ref:`Configuration of firewall for VMs <documentation:rel4.4:firewall>` to specify a set of black/white TCP/UDP ports

Advanced Control and Monitoring of Physical Infrastructure
==========================================================

-  :ref:`Configurable to deploy public, private and hybrid clouds <documentation:rel4.4:intro>`
-  :ref:`Host Management Subsystem <documentation:rel4.4:host_guide>` with complete functionality for management of `physical hosts <http://opennebula.org/doc/4.4/cli/onehost.1.html>`__: create, delete, enable, disable, monitor, list...
-  Dynamic creation of :ref:`clusters <documentation:rel4.4:cluster_guide>` as a logical set of physical resources, namely: hosts, networks and data stores, within each zone
-  Highly scalable and extensible built-in :ref:`monitoring subsystem <documentation:rel4.4:mom>`

Broad Commodity and Enterprise Platform Support
===============================================

-  Hypervisor agnostic :ref:`Virtualization Subsystem <documentation:rel4.4:vmmg>` with broad hypervisor support (:ref:`Xen <documentation:rel4.4:xeng>`, :ref:`KVM <documentation:rel4.4:kvmg>` and :ref:`VMware <documentation:rel4.4:evmwareg>`), centralized management of environments with multiple hypervisors, and support for multiple hypervisors within the same physical box
-  :ref:`Storage Subsystem <documentation:rel4.4:sm>` with support for multiple data stores to balance I/O operations between storage servers, or to define different SLA policies (e.g. backup) and performance features for different VM types or users
-  :ref:`Storage Subsystem <documentation:rel4.4:sm>` supporting any backend configuration with different datastore types: :ref:`file system datastore <documentation:rel4.4:fs_ds>`, to store disk images in a file form and with image transferring using ssh or shared file systems (NFS, GlusterFS, Lustre...), :ref:`LVM <documentation:rel4.4:lvm>` to store disk images in a block device form, :ref:`Ceph <documentation:rel4.4:ceph_ds>` for distributed block device, and :ref:`VMware datastore <documentation:rel4.4:vmware_ds>` specialized for the VMware hypervisor that handle the vmdk format and with support for VMFS
-  Flexible :ref:`Network Subsystem <documentation:rel4.4:nm>` with integration with :ref:`Ebtable <documentation:rel4.4:ebtables>`, :ref:`Open vSwitch <documentation:rel4.4:openvswitch>` and :ref:`802.1Q tagging <documentation:rel4.4:hm-vlan>`
-  :ref:`Virtual Router <documentation:rel4.4:router>` fully integrated with OpenNebula to provide basic L3 services like NATting, DHCP, DNS...

Distributed Resource Optimization
=================================

-  Powerful and flexible :ref:`requirement/rank matchmaker scheduler <documentation:rel4.4:schg>` providing automatic initial VM placement for the definition of workload and resource-aware allocation policies such as packing, striping, load-aware, affinity-aware...
-  :ref:`Advanced requirement expressions <documentation:rel4.4:template#requirement_expression_syntax>` with cluster attributes for VM placement, affinity policies, any host attribute for scheduling expressions, and scheduler feedback through VM tags
-  Powerful and flexible :ref:`requirement/rank matchmaker scheduler <documentation:rel4.4:system_ds#multiple_system_datastore_setups>` for storage load balancing to distribute efficiently the I/O of the VMs across different disks, LUNs or several storage backends
-  :ref:`Resource quota management <documentation:rel4.4:quota_auth>` to allocate, track and limit computing, storage and networking resource utilization
-  Support for :ref:`cgroups <documentation:rel4.4:kvmg#working_with_cgroups_optional>` on KVM to enforce VM CPU usage as described in the VM Template

Centralized Management of Multiple Zones
========================================

-  :ref:`Single access point and centralized management for multiple instances of OpenNebula <documentation:rel4.4:ozones>`
-  :ref:`Federation of multiple OpenNebula zones <documentation:rel4.4:zonesmngt>` for scalability, isolation or multiple-site support
-  Support for the creation and management of multiples clusters within the same zone
-  Complete functionality for management of `zones <http://opennebula.org/doc/4.4/cli/onezone.1.html>`__: create, delete, show, list...

High Availability
=================

-  Persistent database backend with support for high availability configurations
-  :ref:`Configurable behavior in the event of host, VM, or OpenNebula instance failure to provide an easy to use and cost-effective failover solution <documentation:rel4.4:ftguide>`
-  Support for :ref:`high availability architectures <documentation:rel4.4:oneha>`

Community Virtual Appliance Marketplace
=======================================

-  `Marketplace <http://marketplace.c12g.com>`__ with an online catalog where individuals and organizations can quickly distribute and deploy virtual appliances ready-to-run on OpenNebula cloud environments
-  :ref:`Marketplace is fully integrated with OpenNebula <documentation:rel4.4:marketplace>` so any user of an OpenNebula cloud can find and deploy virtual appliances in a single click through familiar tools like the SunStone GUI or the OpenNebula CLI

Management of Multi-tier Applications
=====================================

-  :ref:`Automatic execution of multi-tiered applications <documentation:rel4.4:cloud_app_management_overview>` with complete `functionality for the management of groups of virtual machines as a single entity <http://opennebula.org/doc/4.4/cli/oneflow.1.html>`__: list, delete, scale up, scale down, shutdown... and the `management of Service Templates <http://opennebula.org/doc/4.4/cli/oneflow-template.1.html>`__: create, show, delete, instantiate...
-  :ref:`Automatic deployment and undeployment of Virtual Machines <documentation:rel4.4:appflow_use_cli>` according to their dependencies in the Service Template
-  Provide configurable services from a catalog and self-service portal
-  Enable tight, efficient administrative control
-  Complete integration with the OpenNebula's `User Security Management <http://opennebula.org/documentation:features#powerful_user_security_management>`__ system
-  Computing resources can be tracked and limited using OpenNebula's :ref:`Resource Quota Management <documentation:quota_auth>`
-  :ref:`Automatic scaling of multi-tiered applications <documentation:rel4.4:appflow_elasticity>` according to performance metrics and time schedule

Gain Insight into Cloud Applications
====================================

-  :ref:`OneGate allows Virtual Machine guests to push monitoring information to OpenNebula <documentation:rel4.4:onegate_usage>`
-  With a security token the VMs can call back home and report guest and/or application status in a simple way, that can be easily queried through OpenNebula interfaces (Sunstone, CLI or API).
-  Users and administrators can use it to gather metrics, detect problems in their applications, and trigger :ref:`OneFlow auto-scaling rules <documentation:rel4.4:appflow_elasticity>`

Hybrid Cloud Computing and Cloud Bursting
=========================================

-  :ref:`Extension of the local private infrastructure with resources from remote clouds <documentation:rel4.4:introh>`
-  :ref:`Support for Amazon EC2 <documentation:rel4.4:ec2g>` with most of the EC2 features like tags, security groups or VPC; and simultaneous access to multiple remote clouds

Standard Cloud Interfaces and Simple Self-Service Portal for Cloud Consumers
============================================================================

-  :ref:`Transform your local infrastructure into a public cloud by exposing REST-based interfaces <documentation:rel4.4:introc>`
-  :ref:`OGF OCCI service <documentation:rel4.4:occicg>`, the emerging cloud API standard, and :ref:`client tools <documentation:rel4.4:occiug>`
-  :ref:`AWS EC2 API service <documentation:rel4.4:ec2qcg>`, the de facto cloud API standard, with :ref:`compatibility with EC2 ecosystem tools <documentation:rel4.4:ec2qec>` and :ref:`client tools <documentation:rel4.4:ec2qug>`
-  Support for simultaneously exposing multiple cloud APIs
-  :ref:`Self-service provisioning portal implemented as a user view of Sunstone <documentation:rel4.4:cloud_view>` to allow non-IT end users to easily create, deploy and manage compute, storage and network resources

Rich Command Line and Web Interfaces for Cloud Administrators
=============================================================

-  :ref:`Unix-like Command Line Interface <documentation:rel4.4:cli>` to manage all resources: users, VM images, VM templates, VM instances, virtual networks, zones, VDCs, physical hosts, accounting, authentication, authorization...
-  :ref:`Easy-to-use Sunstone Graphical Interface <documentation:rel4.4:sunstone>` providing usage graphics and statistics with cloudwatch-like functionality, VNC support, different system views for different roles, catalog access, multiple-zone management...
-  :ref:`Sunstone is easily customizable <documentation:rel4.4:suns_views>` to define multiple cloud views for different user groups

Multiple Deployment Options
===========================

-  :ref:`Easy to install and update <documentation:rel4.4:ignc>` with `packages for most common Linux distributions <http://opennebula.org/software:software>`__
-  :ref:`Available in most popular Linux distributions <software:software>`
-  :ref:`Optional building from source code <documentation:rel4.4:compile>`
-  :ref:`System features a small footprint <documentation:rel4.4:plan>`, less than 10Mb
-  :ref:`Detailed log files <documentation:rel4.4:log_debug>` with :ref:`syslog support <documentation:rel4.4:log_debug#configure_the_logging_system>` for the different components that maintain a record of significant changes

Easy Extension and Integration
==============================

-  Modular and extensible architecture to fit into any existing datacenter
-  Customizable drivers for the main subsystems to easily leverage existing IT infrastructure and system management products: :ref:`Virtualization <documentation:rel4.4:devel-vmm>`, :ref:`Storage <documentation:rel4.4:sd>`, :ref:`Monitoring <documentation:rel4.4:devel-im>`, :ref:`Image Repository <documentation:rel4.4:img_mad>`, :ref:`Network <documentation:rel4.4:devel-nm>`, :ref:`Auth <documentation:rel4.4:auth_overview>` and :ref:`Hybrid Cloud <documentation:rel4.4:devel-vmm>`
-  New drivers can be easily written in any language
-  Plugin support to easily extend SunStone Graphical Interface with additional tabs to better integrate Cloud and VM management with each site own operations and tools
-  Easily customizable self-service portal for cloud consumers
-  :ref:`Configuration and tuning parameters <documentation:rel4.4:oned_conf>` to adjust behavior of the cloud management instance to the requirements of the environment and use cases
-  `Fully open-source technology available under Apache license <http://dev.opennebula.org/projects/opennebula/repository>`__
-  Powerful and extensible low-level cloud API in :ref:`Ruby <documentation:rel4.4:ruby>` and :ref:`JAVA <documentation:rel4.4:java>` and :ref:`XMLRPC API <documentation:rel4.4:api>`
-  A Ruby API to build applications on top of the Zones/VDC component :ref:`ZONA, the ZONes Api <documentation:rel4.4:zona>`
-  :ref:`OpenNebula Add-on Catalog <addons:addons>` with components enhancing the functionality provided by OpenNebula

Reliability, Efficiency and Massive Scalability
===============================================

-  :ref:`Automated testing process for functionality, scalability, performance, robustness and stability <software:testing>`
-  :ref:`Technology matured through an active and engaged community <community:community>`
-  Proven on large scale infrastructures consisting of tens of thousands of cores and VMs
-  Highly scalable database back-end with support for :ref:`MySQL <documentation:rel4.4:mysql>` and SQLite
-  Virtualization drivers adjusted for maximum scalability
-  Very efficient core developed in C++ language

(\*) *Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.*

-  *The list of features may change on the different platform configurations*
-  *Not all platform configurations exhibit a similar performance and stability*
-  *The features may change to offer users more features and integration with other virtualization and cloud components*
-  *The features may change due to changes in the functionality provided by underlying virtualization services*

