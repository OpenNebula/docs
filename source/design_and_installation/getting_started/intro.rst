=========================
An Overview of OpenNebula
=========================

OpenNebula is the **open-source industry standard for data center
virtualization**, offering a **simple but feature-rich and flexible
solution** to build and manage enterprise clouds and virtualized data
centers. This introductory guide gives an overview of OpenNebula and
summarizes its main benefits for the different stakeholders involved in
a cloud computing infrastructure.

What Are the Key Features Provided by OpenNebula?
=================================================

You can refer to our a summarized table of `Key
Features </./about:keyfeatures>`__ or to the `Detailed Features and
Functionality Guide </./features>`__ included in the documentation of
each version.

What Are the Interfaces Provided by OpenNebula?
===============================================

OpenNebula provides many different interfaces that can be used to
interact with the functionality offered to manage physical and virtual
resources. There are four main different perspectives to interact with
OpenNebula:

-  Cloud interfaces for **Cloud Consumers**, like the
`OCCI </./occidd>`__ and `EC2 Query and EBS </./ec2qug>`__
interfaces, and a simple `Sunstone cloud user view </./cloud_view>`__
that can be used as a self-service portal.
-  Administration interfaces for **Cloud Advanced Users and Operators**,
like a Unix-like `command line interface </./cli>`__ and the powerful
`Sunstone GUI </./sunstone>`__.
-  Extensible low-level APIs for **Cloud Integrators** in
`Ruby </./documentation:rel3.8:ruby>`__,
`JAVA </./documentation:rel3.8:java>`__ and `XMLRPC
API </./documentation:rel3.8:api>`__
-  A `Marketplace </./marketplace>`__ for **Appliance Builders** with a
catalog of virtual appliances ready to run in OpenNebula
environments.

| OpenNebula Cloud Interfaces|

What Does OpenNebula Offer to Cloud Consumers?
==============================================

OpenNebula provides a powerful, scalable and secure multi-tenant cloud
platform for fast delivery and elasticity of virtual resources.
Multi-tier applications can be deployed and consumed as pre-configured
virtual appliances from catalogs.

-  **Image Catalogs**: OpenNebula allows to store `disk images in
catalogs </./img_guide>`__ (termed datastores), that can be then used
to define VMs or shared with other users. The images can be OS
installations, persistent data sets or empty data blocks that are
created within the datastore.
-  **Network Catalogs**: `Virtual networks </./vgg>`__ can be also be
organised in network catalogs, and provide means to interconnect
virtual machines. This kind of resources can be defined as fixed or
ranged networks, and can be used to achieve full isolation between
virtual networks.
-  **VM Template Catalog**: The `template catalog </./vm_guide>`__
system allows to register `virtual machine </./vm_guide_2>`__
definitions in the system, to be instantiated later as virtual
machine instances.
-  **Virtual Resource Control and Monitoring**: Once a template is
instantiated to a virtual machine, there are a number of operations
that can be performed to control lifecycle of the `virtual machine
instances </./vm_guide_2>`__, such as migration (live and cold),
stop, resume, cancel, poweroff, etc.
-  **Multi-tier Cloud Application Control and Monitoring**: OpenNebula
allows to `define, execute and manage multi-tiered elastic
applications </./appflow_use_cli>`__, or services composed of
interconnected Virtual Machines with deployment dependencies between
them and `auto-scaling rules </./appflow_elasticity>`__.

| OpenNebula Cloud Support for Virtual Infrastructures|

What Does OpenNebula Offer to Cloud Operators?
==============================================

OpenNebula is composed of the following subsystems:

-  **Users and Groups**: OpenNebula features advanced multi-tenancy with
powerful `users and groups management </./manage_users>`__,
`fine-grained ACLs </./manage_acl>`__ for resource allocation, and
`resource quota management </./rel3.8:quota_auth>`__ to track and
limit computing, storage and networking utilization.

-  **Virtualization**: Various hypervisors are supported in the
`virtualization manager </./vmmg>`__, with the ability to control the
complete lifecycle of Virtual Machines and multiple hypervisors in
the same cloud infrastructure.

-  **Hosts**: The `host manager </./host_guide>`__ provides complete
functionality for the management of the physical hosts in the cloud.

-  **Monitoring**: Virtual resources as well as
`hosts </./hostsubsystem>`__ are periodically monitored for key
performance indicators. The information can then used by a powerful
and flexible `scheduler </./schg>`__ for the definition of workload
and resource-aware allocation policies. You can also `gain insight
application status and performance </./onegate_usage>`__.

-  **Accounting**: A Configurable `accounting system </./accounting>`__
to visualize and report resource usage data, to allow their
integration with chargeback and billing platforms, or to guarantee
fair share of resources among users.

-  **Networking**: An easily adaptable and customizable `network
subsystem </./nm>`__ is present in OpenNebula in order to better
integrate with the specific network requirements of existing data
centers and to allow full isolation between virtual machines that
composes a virtualised service.

-  **Storage**: The support for multiple datastores in the `storage
subsystem </./sm>`__ provides extreme flexibility in planning the
storage backend and important performance benefits.

-  **Security**: This feature is spread across several subsystems:
`authentication and authorization mechanisms </./auth_overview>`__
allowing for various possible mechanisms to identify a authorize
users, a powerful `Access Control List </./manage_acl>`__ mechanism
allowing different role management with fine grain permission
granting over any resource managed by OpenNebula, support for
isolation at different levelsâ€¦

-  **High Availability**: Support for `HA architectures </./oneha>`__
and `configurable behavior in the event of host or VM
failure </./ftguide>`__ to provide easy to use and cost-effective
failover solutions.

-  **Clusters**: `Clusters </./cluster_guide>`__ are pools of hosts that
share datastores and virtual networks. Clusters are used for load
balancing, high availability, and high performance computing.

-  **Multiple Zones**: The OpenNebula Zones component
(`oZones </./ozones>`__) allows for the centralized management of
multiple instances of OpenNebula, called `Zones </./zonesmngt>`__,
for scalability, isolation and multiple-site support.

-  **VDCs**. An OpenNebula instance (or Zone) can be further
compartmentalized in `Virtual Data Centers (VDCs) </./vdcmngt>`__,
which offer a fully-isolated virtual infrastructure environments
where a group of users, under the control of the VDC administrator,
can create and manage compute, storage and networking capacity.

-  **Cloud Bursting**: OpenNebula gives support to build a `hybrid
cloud </./introh>`__, an extension of a private cloud to combine
local resources with resources from remote cloud providers. A whole
public cloud provider can be encapsulated as a local resource to be
able to use extra computational capacity to satisfy peak demands.

-  **App Market**: OpenNebula allows the deployment of a `private
centralized catalog of cloud
applications <https://github.com/OpenNebula/addon-appmarket>`__ to
share and distribute virtual appliances across OpenNebula instances

| OpenNebula Cloud Internals|

What Does OpenNebula Offer to Cloud Builders?
=============================================

OpenNebula offers broad support for commodity and enterprise-grade
hypervisor, monitoring, storage, networking and user management
services:

-  **User Management**: OpenNebula can validate users using its own
internal user database based on
`passwords </./manage_users#users>`__, or external mechanisms, like
`ssh </./ssh_auth>`__, `x509 </./x509_auth>`__, `ldap </./ldap>`__ or
`Active Directory </./ldap>`__

-  **Virtualization**: Several hypervisor technologies are fully
supported, like `Xen </./xeng>`__, `KVM </./kvmg>`__ and
`VMware </./evmwareg>`__.

-  **Monitoring**: OpenNebula provides its own `customizable and highly
scalable monitoring system </./mon>`__ and also can be integrated
with external data center monitoring tools.

-  **Networking**: Virtual networks can be backed up by `802.1Q
VLANs </./hm-vlan>`__, `ebtables </./ebtables>`__, `Open
vSwitch </./openvswitch>`__ or `VMware networking </./vmwarenet>`__.

-  **Storage**: Multiple backends are supported like the regular (shared
or not) `filesystem datastore </./fs_ds>`__ supporting popular
distributed file systems like NFS, Lustre, GlusterFS, ZFS, GPFS,
MooseFSâ€¦; the `iSCSI datastore </./iscsi_ds>`__, the `VMware
datastore </./vmware_ds>`__ (both regular filesystem or VMFS based)
specialized for the VMware hypervisor that handle the vmdk format;
the `iSCSI/LVM datastore </./lvm_ds>`__ to store disk images in a
block device form; and `Ceph </./ceph_ds>`__ for distributed block
device.

-  **Databases**: Aside from the original sqlite backend,
`mysql </./mysql>`__ is also supported.

-  **Cloud Bursting**: Out of the box connectors are shipped to support
`Amazon EC2 </./ec2g>`__ cloudbursting.

| OpenNebula Cloud Platform Support|

What Does OpenNebula Offer to Cloud Integrators?
================================================

OpenNebula is fully platform independent and offers many tools for cloud
integrators:

-  **Modular and extensible architecture** with `customizable
plug-ins </./introapis>`__ for integration with any third-party data
center service

-  **API for integration** with higher level tools such as billing,
self-service portalsâ€¦ that offers all the rich functionality of the
OpenNebula core, with bindings for `ruby </./ruby>`__ and
`java </./java>`__.

-  **oZones API** used to `programatically manage OpenNebula Zones and
Virtual Data Centers </./zona>`__.

-  **Sunstone Server custom routes** to extend the `sunstone
server </./sunstone_server_plugin_guide>`__.

-  **OneFlow API** to create, control and monitor `multi-tier
applications or services composed of interconnected Virtual
Machines </./appflow_api>`__.

-  **Hook Manager** to `trigger administration scripts upon VM state
change </./hooks>`__.

| OpenNebula Cloud Architecture|

.. | OpenNebula Cloud Interfaces| image:: /./_media/overview_interfaces.4.0.png?w=600
.. | OpenNebula Cloud Support for Virtual Infrastructures| image:: /./_media/overview_consumers.png?w=600
.. | OpenNebula Cloud Internals| image:: /./_media/overview_operators.png?w=600
.. | OpenNebula Cloud Platform Support| image:: /./_media/overview_builders.png?w=500
.. | OpenNebula Cloud Architecture| image:: /./_media/overview_integrators.png?w=500
