.. _vmware_cloud_architecture:

================================================================================
VMware Reference Architecture
================================================================================

OpenNebula is intended for companies willing to create a self-service cloud environment on top of their VMware infrastructure without having to abandon their investment in VMware and retool the entire stack. In these environments, OpenNebula seamlessly integrates with existing vCenter infrastructures to leverage advanced features — such as vMotion, HA, DRS scheduling or NSX-T / NSX-V — provided by the VMware vSphere product family. OpenNebula exposes a multi-tenant, cloud-like provisioning layer on top of vCenter, including features like virtual data centers, data center federation or hybrid cloud computing to connect in-house vCenter infrastructures with public clouds.

OpenNebula over vCenter is intended for companies that want to keep VMware management tools, procedures and workflows. For these companies, throwing away VMware and retooling the entire stack is not the answer. However, as they consider moving beyond virtualization toward a private cloud, they can choose to either invest more in VMware, or proceed on a tactically challenging but strategically rewarding path of open infrastructure.

Architectural Overview
================================================================================

OpenNebula assumes that your physical infrastructure adopts a classical cluster-like architecture with a front-end, and a set of vCenter instances grouping ESX hosts where Virtual Machines (VM) will be executed. There is at least one physical network joining all the vCenters and ESX hosts with the front-end. Connection from the front-end to vCenter is for management purposes, whereas the connection from the front-end to the ESX hosts is to support VNC or VMRC connections.

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manage one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor. Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level; vCenter then uses the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine.

.. image:: /images/one_vcenter_high.png
    :width: 90%
    :align: center

A cloud architecture is defined by three components: storage, networking and virtualization. Therefore, the basic components of an OpenNebula cloud are:

-  **Front-end** that executes the OpenNebula services.
-  Hypervisor-enabled **hosts** that provide the resources needed by the VMs.
-  **Datastores** that hold the base images of the VMs.
-  Physical or software defined **networks** used to support basic services such as interconnection of the VMs.

OpenNebula presents a highly modular architecture that offers broad support for commodity and enterprise-grade hypervisors, monitoring, storage, networking and user management services. This Section briefly describes the different choices that you can make for the management of the different subsystems. If your specific services are not supported we recommend checking the drivers available in the `Add-on Catalog <https://github.com/OpenNebula/one/wiki/Add_ons-Catalog>`__. We also provide information and support about how to develop new drivers.

Dimensioning the Cloud
================================================================================

The dimension of a cloud infrastructure can be directly inferred from the expected workload in terms of VMs that the cloud infrastructure must sustain. This workload is also tricky to estimate, but this is a crucial exercise to build an efficient cloud.

**OpenNebula front-end**

The minimum recommended specs are for the OpenNebula front-end are:

+-----------+-----------------------------------+
|  Resource | Minimum Recommended configuration |
+===========+===================================+
| Memory    | 8 GB                              |
+-----------+-----------------------------------+
| CPU       | 2 CPU (4 cores)                   |
+-----------+-----------------------------------+
| Disk Size | 200 GB                            |
+-----------+-----------------------------------+
| Network   | 2 NICs                            |
+-----------+-----------------------------------+

When running on a front-end with the minimums described in the above table, OpenNebula is able to manage a vCenter infrastructure of the following characteristics:

- Up to 4 vCenters
- Up to 40 ESXs managed by each vCenter
- Up to 1.000 VMs in total, each vCenter managing up to 250 VMs

**ESX nodes**

Regarding the dimensions of the ESX virtualization nodes:

- **CPU**: without overcommitment, each CPU core assigned to a VM must exists as a physical CPU core. By example, for a workload of 40 VMs with 2 CPUs, the cloud will need 80 physical CPUs. These 80 physical CPUs can be spread among different hosts: 10 servers with 8 cores each, or 5 server of 16 cores each. With overcommitment, however, CPU dimension can be planned ahead, using the ``CPU`` and ``VCPU`` attributes: ``CPU`` states physical CPUs assigned to the VM, while ``VCPU`` states virtual CPUs to be presented to the guest OS.

- **MEMORY**: Planning for memory is straightforward, as by default *there is no overcommitment of memory* in OpenNebula. It is always a good practice to count 10% of overhead by the hypervisor. (This is not an absolute upper limit, it depends on the hypervisor.) So, in order to sustain a VM workload of 45 VMs with 2GB of RAM each, 90GB of physical memory is needed. The number of hosts is important, as each one will incur a 10% overhead due to the hypervisors. For instance, 10 hypervisors with 10GB RAM each will contribute with 9GB each (10% of 10GB = 1GB), so they will be able to sustain the estimated workload. The rule of thumb is having at least 1GB per core, but this also depends on the expected workload.

**Storage**

Dimensioning storage is a critical aspect, as it is usually the cloud bottleneck. OpenNebula can manage any datastore that is mounted in the ESX and visible in vCenter. The datastore used by a VM can be fixed by the cloud admin or delegated to the cloud user. It is important to ensure that enough space is available for new VMs, otherwise its creation process will fail. One valid approach is to limit the storage available to users by defining quotas in the number of maximum VMs, and ensuring enough datastore space to comply with the limit set in the quotas. In any case, OpenNebula allows cloud administrators to add more datastores if needed.

**Network**

Networking needs to be carefully designed to ensure reliability in the cloud infrastructure. The recommendation is to have 2 NICs in the front-end (service and public network) and 4 NICs present in each ESX node (private, public, service and storage networks). Fewer NICs may be needed depending on the storage and networking configuration.

Front-End
================================================================================

The machine that holds the OpenNebula installation is called the front-end. This machine needs network connectivity to all the vCenter and ESX hosts. The base installation of OpenNebula takes less than 150MB.

OpenNebula services include:

-  Management daemon (``oned``) and scheduler (``mm_sched``)
-  Web interface server (``sunstone-server``)
-  Advanced components: OneFlow, OneGate, econe, ...

.. note:: Note that these components communicate through :ref:`XML-RPC <api>` and may be installed in different machines for security or performance reasons.

There are several certified platforms to act as front-end for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that best fits your needs.

OpenNebula's default database uses **sqlite**. If you are planning a production or medium to large scale deployment, you should consider using :ref:`MySQL <mysql>`.

If you are interested in setting up a highly available cluster for OpenNebula, check the :ref:`High Availability OpenNebula Section <oneha>`.

Monitoring
================================================================================

The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of probes in the front-end provided by OpenNebula.

Please check the :ref:`the Monitoring Section <mon>` for more details.

Virtualization Hosts
================================================================================

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manage one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor. The Virtualization Subsystem is the component in charge of talking with vCenter and taking the actions needed for each step in the VM life-cycle. All the management operations are issued by the front-end to vCenter, except the VNC connection that is performed directly from the front-end to the ESX where a particular VM is running.

OpenNebula natively supports the :ref:`vCenter <vcenterg>` hypervisor. vCenter drivers need to be configured in the OpenNebula front-end.

If you are interested in fail-over protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Section <ftguide>`.

Storage
================================================================================

OpenNebula interacts as a consumer of vCenter storage, and as such, supports all the storage devices supported by `ESX <http://www.vmware.com/resources/compatibility/search.php?action=base&deviceCategory=san>`__. When a VM is instantiated from a VM Template, OpenNebula's Scheduler will choose a datastore using the default policy of distributing the VMs across available datastores. However this scheduler policy can be changed, and you can force VMs to be instantiated from a template to use a specific datastore thanks to the SCHED_DS_REQUIREMENTS attribute. If Storage DRS is enabled, OpenNebula can request storage recommendations to the Storage DRS cluster and apply them when a VM is instantiated, so in this case OpenNebula would delegate the datastore selection to vCenter's Storage DRS.

vCenter/ESX Datastores can be represented in OpenNebula to create, clone and/or upload VMDKs. The vCenter/ESX datastore representation in OpenNebula is described in the :ref:`vCenter datastore Section <vcenter_ds>`.

Networking
================================================================================

Networking in OpenNebula is handled by creating or importing Virtual Network representations of vCenter Networks and Distributed vSwitches. In this way, new VMs with defined network interfaces will be bound by OpenNebula to these Networks and/or Distributed vSwitches. OpenNebula can create a new logical layer of these vCenter Networks and Distributed vSwitches; in particular, three types of Address Ranges can be defined per Virtual Network representing the vCenter network resources: plain Ethernet, IPv4 and IPv6. This networking information can be passed to the VMs through the :ref:`contextualization <vcenter_contextualization>` process.

OpenNebula supports NSX-T and NSX-V logical switches through the NSX Manager API. Some of the key points of this integration are:

-  NSX Manager is automatically detected from vCenter Server.
-  Transport Zones are automatically discovered.
-  Logical switches are created in the NSX Manager after a Virtual Network is created in OpenNebula.
-  Link VM NICs to these logical switches through the OpenNebula GUI, both at deployment and run times.
-  Import or remove existing logical switches.

Please check the :ref:`vCenter Networking Setup <vcenter_networking_setup>` and :ref:`NSX Setup <nsx_setup>` to find out more about the networking support in vCenter infrastructures by OpenNebula.

Authentication
================================================================================

The following authentication methods are supported to access OpenNebula:

-  :ref:`Built-in User/Password <manage_users_adding_and_deleting_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>` (and Active Directory)

.. warning:: **Default:** OpenNebula comes by default with an internal built-in user/password authentication.

Please check the :ref:`Authentication Chapter <external_auth>` to find out more about the authentication technologies supported by OpenNebula.

Multi-Datacenter Deployments
================================================================================

OpenNebula interacts with the vCenter instances by interfacing with its SOAP API exclusively. This characteristic enables architectures where the OpenNebula instance and the vCenter environment are located in different datacenters. A single OpenNebula instance can orchestrate several vCenter instances remotely located in different data centers. Connectivity between data centers needs to have low latency in order to have a reliable management of vCenter from OpenNebula.

.. image:: /images/vcenter_remote_dc.png
    :width: 90%
    :align: center

When administration domains need to be isolated, or the interconnection between datacenters does not allow a single controlling entity, OpenNebula can be configured in a federation. Each OpenNebula instance of the federation is called a Zone, one of them configured as master and the others as slaves. An OpenNebula federation is a tightly coupled integration; all the instances will share the same user accounts, groups, and permissions configuration. Federation allows end users to consume resources allocated by the federation administrators regardless of their geographic location. The integration is seamless, meaning that a user logged into the Sunstone web interface of a Zone will not have to log out and enter the address of another Zone. Sunstone allows to change the active Zone at any time, and it will automatically redirect the requests to the right OpenNebula at the target Zone. For more information, check the :ref:`Federation Section <federation_section>`.

.. image:: /images/vcenter_multi_dc.png
    :width: 90%
    :align: center

Advanced Components
================================================================================

Once you have an OpenNebula cloud up and running, you can install the following advanced components:

.. todo:: Add more?

-  :ref:`Multi-VM Applications and Auto-scaling <oneapps_overview>`: OneFlow allows users and administrators to define, execute and manage services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management.
-  :ref:`Application Insight <onegate_overview>`: OneGate allows Virtual Machine guests to push monitoring information to OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow auto-scaling rules.
