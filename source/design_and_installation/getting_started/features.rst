==================================================
OpenNebula 4.4 Detailed Features and Functionality
==================================================

This section describes the **detailed features and functionality of the
latest version of OpenNebula (v4.4)** for the management of private
clouds and datacenter virtualization(\*). It includes links to the
different parts of the documentation and the web site that provide
extended information about each feature. We also provide a summarized
table of `key features <http://opennebula.org/about:keyfeatures>`__.

Powerful User Security Management
=================================

-  Secure and efficient `Users and Groups
Subsystem </./documentation:rel4.4:auth_overview>`__ for
authentication and authorization of requests with complete
functionality for `user
management <http://opennebula.org/doc/4.4/cli/oneuser.1.html>`__:
create, delete, showâ€¦
-  `Pluggable authentication and
authorization </./documentation:rel4.4:external_auth>`__ based on
`passwords </./documentation:rel4.4:manage_users#users>`__, `ssh rsa
keypairs </./documentation:rel4.4:ssh_auth>`__, `X509
certificates </./documentation:rel4.4:x509_auth>`__,
`LDAP </./documentation:rel4.4:ldap>`__ or `Active
Directory </./documentation:rel4.4:ldap>`__
-  Special authentication mechanisms for `SunStone (OpenNebula
GUI) </./documentation:rel4.4:sunstone#authentication_methods>`__ and
the `Cloud Services (EC2 and
OCCI) </./documentation:rel4.4:cloud_auth>`__
-  Authorization framework with `fine-grained
ACLs </./documentation:rel4.4:manage_acl>`__ that allows
multiple-role support for different types of users and
administrators, delegated control to authorized users, secure
isolated multi-tenant environments, and easy resource (VM template,
VM image, VM instance, virtual network and host) sharing

Advanced Multi-tenancy with Group Management
============================================

-  Administrators can `groups
users </./documentation:rel4.4:manage_users#groups>`__ into
organizations that can represent different projects, divisionâ€¦
-  Each group have `configurable access to shared
resources </./documentation:rel4.4:manage_acl>`__ so enabling a
multi-tenant environment with multiple groups sharing the same
infrastructure
-  Configuration of special `users that are restricted to public cloud
APIs </./documentation:rel4.4:cloud_auth>`__ (e.g. EC2 or OCCI)
-  Complete functionality for management of
`groups <http://opennebula.org/doc/4.4/cli/onegroup.1.html>`__:
create, delete, showâ€¦
-  Multiple group support, with the ability to define `primary and
secondary
groups <http://opennebula.org/documentation:rel4.4:manage_users#primary_and_secondary_groups>`__.

On-demand Provision of Virtual Data Centers
===========================================

-  A `Virtual Data Centers (VDC) </./documentation:rel4.4:vdcmngt>`__ is
a fully-isolated virtual infrastructure environment where a group of
users, under the control of the VDC administrator, can create and
manage compute, storage and networking capacity
-  Support for the creation and management of multiples VDCs within the
same logical cluster and zone
-  Advanced multi-tenancy with complete functionality for management of
`VDCs <http://opennebula.org/doc/4.4/cli/onevdc.1.html>`__: create,
delete, showâ€¦

Advanced Control and Monitoring of Virtual Infrastructure
=========================================================

-  `Image Repository Subsystem </./documentation:rel4.4:img_guide>`__
with catalog and complete functionality for `VM image
management <http://opennebula.org/doc/4.4/cli/oneimage.1.html>`__:
list, publish, unpublish, show, enable, disable, register, update,
saveas, delete, cloneâ€¦
-  `Template Repository Subsystem </./documentation:rel4.4:vm_guide>`__
with catalog and complete functionality for `VM template
management <http://opennebula.org/doc/4.4/cli/onetemplate.1.html>`__:
add, delete, list, duplicateâ€¦
-  `Full control of VM instance
life-cycle </./documentation:rel4.4:vm_guide_2>`__ and complete
functionality for `VM instance
management <http://opennebula.org/doc/4.4/cli/onevm.1.html>`__:
submit, deploy, migrate, livemigrate, reschedule, stop, save, resume,
cancel, shutdown, restart, reboot, delete, monitor, list, power-on,
power-off,â€¦
-  Advanced functionality for VM dynamic management like `system and
disk
snapshotting </./documentation:rel4.4:vm_guide_2#snapshotting>`__,
`capacity
resizing </./documentation:rel4.4:vm_guide_2#resizing_a_vm>`__, or
`NIC
hotplugging </./documentation:rel4.4:vm_guide_2#nic_hotpluging>`__
-  `Programmable VM
operations </./documentation:rel4.4:vm_guide_2#scheduling_actions>`__,
so allowing users to schedule actions
-  Volume hotplugging to easily hot plug a volatile disk created
on-the-fly or an existing image from a Datastore to a running VM
-  `Broad network virtualization
capabilities </./documentation:rel4.4:vgg>`__ with traffic isolation,
ranged or fixed networks, definition of generic attributes to define
multi-tier services consisting of groups of inter-connected VMs, and
complete functionality for `virtual network
management <http://opennebula.org/doc/4.4/cli/onevnet.1.html>`__ to
interconnect VM instances: create, delete, monitor, listâ€¦
-  `IPv6 support </./documentation:rel4.4:vgg#ipv6_networks>`__ with
definition site and global unicast addresses
-  Configurable `system accounting
statistics </./documentation:rel4.4:accounting>`__ to visualize and
report resource usage data, to allow their integration with
chargeback and billing platforms, or to guarantee fair share of
resources among users
-  Tagging of users, VM images and virtual networks with arbitrary
metadata that can be later used by other components
-  `User defined VM
tags </./documentation:rel4.4:vm_guide_2#user_defined_data>`__ to
simplify VM management and to store application specific data
-  `Plain files datastore </./documentation:rel4.4:file_ds>`__ to store
kernels, ramdisks and files to be used in context. The whole set of
OpenNebula features applies, e.g. ACLs, ownershipâ€¦

Complete Virtual Machine Configuration
======================================

-  Complete `definition of VM attributes and
requirements </./documentation:rel4.4:template>`__
-  Support for automatic configuration of VMs with advanced
`contextualization mechanisms </./documentation:rel4.4:cong>`__
-  `Cloud-init </./documentation:rel4.4:cloud-init>`__ support
-  `Hook Manager </./documentation:rel4.4:hooks>`__ to trigger
administration scripts upon VM state change
-  Wide range of guest operating system including Microsoft Windows and
Linux
-  `Flexible network
defintion </./documentation:rel4.4:vnet_template>`__
-  `Configuration of firewall for
VMs </./documentation:rel4.4:firewall>`__ to specify a set of
black/white TCP/UDP ports

Advanced Control and Monitoring of Physical Infrastructure
==========================================================

-  `Configurable to deploy public, private and hybrid
clouds </./documentation:rel4.4:intro>`__
-  `Host Management Subsystem </./documentation:rel4.4:host_guide>`__
with complete functionality for management of `physical
hosts <http://opennebula.org/doc/4.4/cli/onehost.1.html>`__: create,
delete, enable, disable, monitor, listâ€¦
-  Dynamic creation of
`clusters </./documentation:rel4.4:cluster_guide>`__ as a logical set
of physical resources, namely: hosts, networks and data stores,
within each zone
-  Highly scalable and extensible built-in `monitoring
subsystem </./documentation:rel4.4:mom>`__

Broad Commodity and Enterprise Platform Support
===============================================

-  Hypervisor agnostic `Virtualization
Subsystem </./documentation:rel4.4:vmmg>`__ with broad hypervisor
support (`Xen </./documentation:rel4.4:xeng>`__,
`KVM </./documentation:rel4.4:kvmg>`__ and
`VMware </./documentation:rel4.4:evmwareg>`__), centralized
management of environments with multiple hypervisors, and support for
multiple hypervisors within the same physical box
-  `Storage Subsystem </./documentation:rel4.4:sm>`__ with support for
multiple data stores to balance I/O operations between storage
servers, or to define different SLA policies (e.g. backup) and
performance features for different VM types or users
-  `Storage Subsystem </./documentation:rel4.4:sm>`__ supporting any
backend configuration with different datastore types: `file system
datastore </./documentation:rel4.4:fs_ds>`__, to store disk images in
a file form and with image transferring using ssh or shared file
systems (NFS, GlusterFS, Lustreâ€¦),
`LVM </./documentation:rel4.4:lvm>`__ to store disk images in a block
device form, `Ceph </./documentation:rel4.4:ceph_ds>`__ for
distributed block device, and `VMware
datastore </./documentation:rel4.4:vmware_ds>`__ specialized for the
VMware hypervisor that handle the vmdk format and with support for
VMFS
-  Flexible `Network Subsystem </./documentation:rel4.4:nm>`__ with
integration with `Ebtable </./documentation:rel4.4:ebtables>`__,
`Open vSwitch </./documentation:rel4.4:openvswitch>`__ and `802.1Q
tagging </./documentation:rel4.4:hm-vlan>`__
-  `Virtual Router </./documentation:rel4.4:router>`__ fully integrated
with OpenNebula to provide basic L3 services like NATting, DHCP,
DNSâ€¦

Distributed Resource Optimization
=================================

-  Powerful and flexible `requirement/rank matchmaker
scheduler </./documentation:rel4.4:schg>`__ providing automatic
initial VM placement for the definition of workload and
resource-aware allocation policies such as packing, striping,
load-aware, affinity-awareâ€¦
-  `Advanced requirement
expressions </./documentation:rel4.4:template#requirement_expression_syntax>`__
with cluster attributes for VM placement, affinity policies, any host
attribute for scheduling expressions, and scheduler feedback through
VM tags
-  Powerful and flexible `requirement/rank matchmaker
scheduler </./documentation:rel4.4:system_ds#multiple_system_datastore_setups>`__
for storage load balancing to distribute efficiently the I/O of the
VMs across different disks, LUNs or several storage backends
-  `Resource quota management </./documentation:rel4.4:quota_auth>`__ to
allocate, track and limit computing, storage and networking resource
utilization
-  Support for
`cgroups </./documentation:rel4.4:kvmg#working_with_cgroups_optional>`__
on KVM to enforce VM CPU usage as described in the VM Template

Centralized Management of Multiple Zones
========================================

-  `Single access point and centralized management for multiple
instances of OpenNebula </./documentation:rel4.4:ozones>`__
-  `Federation of multiple OpenNebula
zones </./documentation:rel4.4:zonesmngt>`__ for scalability,
isolation or multiple-site support
-  Support for the creation and management of multiples clusters within
the same zone
-  Complete functionality for management of
`zones <http://opennebula.org/doc/4.4/cli/onezone.1.html>`__: create,
delete, show, listâ€¦

High Availability
=================

-  Persistent database backend with support for high availability
configurations
-  `Configurable behavior in the event of host, VM, or OpenNebula
instance failure to provide an easy to use and cost-effective
failover solution </./documentation:rel4.4:ftguide>`__
-  Support for `high availability
architectures </./documentation:rel4.4:oneha>`__

Community Virtual Appliance Marketplace
=======================================

-  `Marketplace <http://marketplace.c12g.com>`__ with an online catalog
where individuals and organizations can quickly distribute and deploy
virtual appliances ready-to-run on OpenNebula cloud environments
-  `Marketplace is fully integrated with
OpenNebula </./documentation:rel4.4:marketplace>`__ so any user of an
OpenNebula cloud can find and deploy virtual appliances in a single
click through familiar tools like the SunStone GUI or the OpenNebula
CLI

Management of Multi-tier Applications
=====================================

-  `Automatic execution of multi-tiered
applications </./documentation:rel4.4:cloud_app_management_overview>`__
with complete `functionality for the management of groups of virtual
machines as a single
entity <http://opennebula.org/doc/4.4/cli/oneflow.1.html>`__: list,
delete, scale up, scale down, shutdownâ€¦ and the `management of
Service
Templates <http://opennebula.org/doc/4.4/cli/oneflow-template.1.html>`__:
create, show, delete, instantiateâ€¦
-  `Automatic deployment and undeployment of Virtual
Machines </./documentation:rel4.4:appflow_use_cli>`__ according to
their dependencies in the Service Template
-  Provide configurable services from a catalog and self-service portal
-  Enable tight, efficient administrative control
-  Complete integration with the OpenNebula's `User Security
Management <http://opennebula.org/documentation:features#powerful_user_security_management>`__
system
-  Computing resources can be tracked and limited using OpenNebula's
`Resource Quota Management </./documentation:quota_auth>`__
-  `Automatic scaling of multi-tiered
applications </./documentation:rel4.4:appflow_elasticity>`__
according to performance metrics and time schedule

Gain Insight into Cloud Applications
====================================

-  `OneGate allows Virtual Machine guests to push monitoring information
to OpenNebula </./documentation:rel4.4:onegate_usage>`__
-  With a security token the VMs can call back home and report guest
and/or application status in a simple way, that can be easily queried
through OpenNebula interfaces (Sunstone, CLI or API).
-  Users and administrators can use it to gather metrics, detect
problems in their applications, and trigger `OneFlow auto-scaling
rules </./documentation:rel4.4:appflow_elasticity>`__

Hybrid Cloud Computing and Cloud Bursting
=========================================

-  `Extension of the local private infrastructure with resources from
remote clouds </./documentation:rel4.4:introh>`__
-  `Support for Amazon EC2 </./documentation:rel4.4:ec2g>`__ with most
of the EC2 features like tags, security groups or VPC; and
simultaneous access to multiple remote clouds

Standard Cloud Interfaces and Simple Self-Service Portal for Cloud Consumers
============================================================================

-  `Transform your local infrastructure into a public cloud by exposing
REST-based interfaces </./documentation:rel4.4:introc>`__
-  `OGF OCCI service </./documentation:rel4.4:occicg>`__, the emerging
cloud API standard, and `client
tools </./documentation:rel4.4:occiug>`__
-  `AWS EC2 API service </./documentation:rel4.4:ec2qcg>`__, the de
facto cloud API standard, with `compatibility with EC2 ecosystem
tools </./documentation:rel4.4:ec2qec>`__ and `client
tools </./documentation:rel4.4:ec2qug>`__
-  Support for simultaneously exposing multiple cloud APIs
-  `Self-service provisioning portal implemented as a user view of
Sunstone </./documentation:rel4.4:cloud_view>`__ to allow non-IT end
users to easily create, deploy and manage compute, storage and
network resources

Rich Command Line and Web Interfaces for Cloud Administrators
=============================================================

-  `Unix-like Command Line Interface </./documentation:rel4.4:cli>`__ to
manage all resources: users, VM images, VM templates, VM instances,
virtual networks, zones, VDCs, physical hosts, accounting,
authentication, authorizationâ€¦
-  `Easy-to-use Sunstone Graphical
Interface </./documentation:rel4.4:sunstone>`__ providing usage
graphics and statistics with cloudwatch-like functionality, VNC
support, different system views for different roles, catalog access,
multiple-zone managementâ€¦
-  `Sunstone is easily
customizable </./documentation:rel4.4:suns_views>`__ to define
multiple cloud views for different user groups

Multiple Deployment Options
===========================

-  `Easy to install and update </./documentation:rel4.4:ignc>`__ with
`packages for most common Linux
distributions <http://opennebula.org/software:software>`__
-  `Available in most popular Linux
distributions </./software:software>`__
-  `Optional building from source
code </./documentation:rel4.4:compile>`__
-  `System features a small footprint </./documentation:rel4.4:plan>`__,
less than 10Mb
-  `Detailed log files </./documentation:rel4.4:log_debug>`__ with
`syslog
support </./documentation:rel4.4:log_debug#configure_the_logging_system>`__
for the different components that maintain a record of significant
changes

Easy Extension and Integration
==============================

-  Modular and extensible architecture to fit into any existing
datacenter
-  Customizable drivers for the main subsystems to easily leverage
existing IT infrastructure and system management products:
`Virtualization </./documentation:rel4.4:devel-vmm>`__,
`Storage </./documentation:rel4.4:sd>`__,
`Monitoring </./documentation:rel4.4:devel-im>`__, `Image
Repository </./documentation:rel4.4:img_mad>`__,
`Network </./documentation:rel4.4:devel-nm>`__,
`Auth </./documentation:rel4.4:auth_overview>`__ and `Hybrid
Cloud </./documentation:rel4.4:devel-vmm>`__
-  New drivers can be easily written in any language
-  Plugin support to easily extend SunStone Graphical Interface with
additional tabs to better integrate Cloud and VM management with each
site own operations and tools
-  Easily customizable self-service portal for cloud consumers
-  `Configuration and tuning
parameters </./documentation:rel4.4:oned_conf>`__ to adjust behavior
of the cloud management instance to the requirements of the
environment and use cases
-  `Fully open-source technology available under Apache
license <http://dev.opennebula.org/projects/opennebula/repository>`__
-  Powerful and extensible low-level cloud API in
`Ruby </./documentation:rel4.4:ruby>`__ and
`JAVA </./documentation:rel4.4:java>`__ and `XMLRPC
API </./documentation:rel4.4:api>`__
-  A Ruby API to build applications on top of the Zones/VDC component
`ZONA, the ZONes Api </./documentation:rel4.4:zona>`__
-  `OpenNebula Add-on Catalog </./addons:addons>`__ with components
enhancing the functionality provided by OpenNebula

Reliability, Efficiency and Massive Scalability
===============================================

-  `Automated testing process for functionality, scalability,
performance, robustness and stability </./software:testing>`__
-  `Technology matured through an active and engaged
community </./community:community>`__
-  Proven on large scale infrastructures consisting of tens of thousands
of cores and VMs
-  Highly scalable database back-end with support for
`MySQL </./documentation:rel4.4:mysql>`__ and SQLite
-  Virtualization drivers adjusted for maximum scalability
-  Very efficient core developed in C++ language

(\*) *Because OpenNebula leverages the functionality exposed by the
underlying platform services, its functionality and performance may be
affected by the limitations imposed by those services.*

-  *The list of features may change on the different platform
configurations*
-  *Not all platform configurations exhibit a similar performance and
stability*
-  *The features may change to offer users more features and integration
with other virtualization and cloud components*
-  *The features may change due to changes in the functionality provided
by underlying virtualization services*

