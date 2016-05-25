.. _vmware_cloud_architecture:

================================================================================
VMware Cloud Architecture
================================================================================

In order to get the most out of a OpenNebula Cloud, we recommend that you create a plan with the features, performance, scalability, and high availability characteristics you want in your deployment. This Section provides information to plan an OpenNebula cloud based on KVM, an open source hypervisor. With this information, you will be able to easily architect and dimension your deployment, as well as understand the technologies involved in the management of virtualized resources and their relationship.

OpenNebula is intended for companies willing to create a self-service cloud environment on top of their VMware infrastructure without having to abandon their investment in VMware and retool the entire stack. In these environments, OpenNebula seamlessly integrates with existing vCenter infrastructures to leverage advanced features -such as vMotion, HA or DRS scheduling- provided by the VMware vSphere product family. OpenNebula exposes a multi-tenant, cloud-like provisioning layer on top of vCenter, including features like virtual data centers, data center federation or hybrid cloud computing to connect in-house vCenter infrastructures with public clouds.


OpenNebula over vCenter is intended for companies that want to keep VMware management tools, procedures and workflows. For these companies, throwing away VMware and retooling the entire stack is not the answer. However, as they consider moving beyond virtualization toward a private cloud, they can choose to either invest more in VMware, or proceed on a tactically challenging but strategically rewarding path of open.

Architectural Overview
================================================================================

OpenNebula assumes that your physical infrastructure adopts a classical cluster-like architecture with a front-end, and a set of vCenter instances grouping ESX hosts where Virtual Machines (VM) will be executed. There is at least one physical network joining all the vCenters and ESX hosts with the front-end. Connection from the front-end to vCenter is for management purposes, whereas the connection from the front-end to the ESX hosts is to support the VNC connections.

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor. Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level, vCenter then uses the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine.

|high level architecture of cluster, its components and relationship|

A cloud architecture is defined by three components: storage, networking and virtualization. Therefore, the basic components of an OpenNebula cloud are:

-  **Front-end** that executes the OpenNebula services.
-  Hypervisor-enabled **hosts** that provide the resources needed by the VMs.
-  **Datastores** that hold the base images of the VMs.
-  Physical **networks** used to support basic services such as interconnection of the VMs.

OpenNebula presents a highly modular architecture that offers broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services. This Section briefly describes the different choices that you can make for the management of the different subsystems. If your specific services are not supported we recommend to check the drivers available in the `Add-on Catalog <http://opennebula.org/addons:catalog>`__. We also provide information and support about how to develop new drivers.

Dimensioning the Cloud
================================================================================

The dimension of a cloud infrastructure can be directly inferred from the expected workload in terms of VMs that the cloud infrastructure must sustain. This workload is also tricky to estimate, but this is a crucial exercise to build an efficient cloud.

Regarding the OpenNebula front-end, the minimum recommended specs are:

+-----------+-----------------------------------+
|           | Minimum Recommended configuration |
+===========+===================================+
| Memory    | 2 GB                              |
+-----------+-----------------------------------+
| CPU       | 1 CPU (2 cores)                   |
+-----------+-----------------------------------+
| Disk Size | 100 GB                            |
+-----------+-----------------------------------+
| Network   | 2 NICS                            |
+-----------+-----------------------------------+

When running on a front-end with the minimums described in the above table, OpenNebula is able to manage a vCenter infrastructure of the following characteristics:

- Up to 4 vCenters
- Up to 40 ESXs managed by each vCenter
- Up to 1.000 VMs in total, each vCenter managing up to 250 VMs

The main aspects to take into account at the time of dimensioning the OpenNebula cloud for a given workload are:

- **CPU**:

  - *without* overcommitment, each CPU core assigned to a VM must exists as a physical CPU core. By example, for a workload of 40 VMs with 2 CPUs, the cloud will need 80 physical CPUs. These 80 physical CPUs can be spread among different hosts: 10 servers with 8 cores each, or 5 server of 16 cores each;

  - *with* overcommitment, however, CPU dimension can be planned ahead, using the ``CPU`` and ``VCPU`` attributes: ``CPU`` states physical CPUs assigned to the VM, while ``VCPU`` states virtual CPUs to be presented to the guest OS.

- **MEMORY**: Planning for memory is straightforward, as by default *there is no overcommitment of memory* in OpenNebula. It is always a good practice to count 10% of overhead by the hypervisor (this is not an absolute upper limit, it depends on the hypervisor). So, in order to sustain a VM workload of 45 VMs with 2GB of RAM each, 90GB of physical memory is needed. The number of hosts is important, as each one will incur a 10% overhead due to the hypervisors. For instance, 10 hypervisors with 10GB RAM each will contribute with 9GB each (10% of 10GB = 1GB), so they will be able to sustain the estimated workload. The rule of thumb is having at least 1GB per core, but this also depends on the expected workload.

- **STORAGE**: Dimensioning storage is a critical aspect, as it is usually the cloud bottleneck. OpenNebula can manage any datastore that is mounted in the ESX and visible in vCenter. The datastore used by a VM can be fixed by the cloud admin or delegated to the cloud user. It is important to ensure that enough space is available for new VMs, otherwise its creation process will fail. One valid approach is to limit the storage available to users by defining quotas in the number of maximum VMs, and ensuring enough datastore space to comply with the limit set in the quotas. In any case, OpenNebula allows cloud administrators to add more datastores if needed.

- **NETWORK**: Networking needs to be carefully designed to ensure reliability in the cloud infrastructure. The recommendation is having 2 NICs in the front-end (service and public network) 4 NICs present in each ESX node: private, public, service and storage networks. Less NICs can be needed depending on the storage and networking configuration.

Importing Existing VMs
================================================================================

As soon as a new vCenter cluster or public cloud is added to OpenNebula, the monitoring subsystem will extract all the Virtual Machines running in that particular server or public cloud region and label them as *Wild VMs*. Wild VMs are therefore VMs running in a hypervisor controlled by OpenNebula that have not been launched through OpenNebula.

OpenNebula allows to import these Wild VMs in order to control their life-cycle just like any other VM launched by OpenNebula. Proceed to this :ref:`host section <import_wild_vms>` for more details.

Front-End
================================================================================

The machine that holds the OpenNebula installation is called the front-end. This machine needs network connectivity to all the vCenter and ESX hosts. The base installation of OpenNebula takes less than 150MB.

OpenNebula services include:

-  Management daemon (``oned``) and scheduler (``mm_sched``)
-  Web interface server (``sunstone-server``)
-  Optional  services: OneFlow, OneGate, econe, ...

.. warning:: Note that these components communicate through :ref:`XML-RPC <api>` and may be installed in different machines for security or performance reasons

There are several certified platforms to act as front-end for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that better fits your needs.

OpenNebula's default database uses **sqlite**. If you are planning a production or medium to large scale deployment, you should consider using :ref:`MySQL <mysql>`.

If you are interested in setting up a high available cluster for OpenNebula, check the :ref:`High Availability OpenNebula Section <oneha>`.

If you need to federate several datacenters, with a different OpenNebula instance managing the resources but needing a common authentication schema, check the :ref:`Federation Section <federation_section>`.

Monitoring
================================================================================

The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of probes in the front-end provided by OpenNebula. 

Please check the :ref:`the Monitoring Section <mon>` for more details.

Virtualization Hosts
================================================================================

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor. The Virtualization Subsystem is the component in charge of talking with vCenter and taking the actions needed for each step in the VM life-cycle. All the management operations are issued by the front-end to vCenter, except the VNC connection that is performed directly from the front-end to the ESX where a particular VM is running.

OpenNebula natively supports :ref:`vCenter <vcenterg>` hypervisor, vCenter drivers need to be configured in the OpenNebula front-end. 

If you are interested in fail-over protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Section <ftguide>`.

Storage
================================================================================

OpenNebula interacts as a consumer of vCenter storage, and as such, supports all the storage devices supported by `ESX <http://www.vmware.com/resources/compatibility/search.php?action=base&deviceCategory=san>`__. When a VM is instantiated from a VM Template, the datastore associated with the VM template is chosen. If DRS is enabled, then vCenter will pick the optimal Datastore to deploy the VM. Alternatively, the datastore used by a VM can be fixed by the cloud admin or delegated to the cloud user.

vCenter/ESX Datastores can be represented in OpenNebula to create, clone and/or upload VMDKs. The vCenter/ESX datastore representation in OpenNebula is described in the :ref:`vCenter datastore Section <vcenter_ds>`.

Networking
================================================================================

Networking in OpenNebula is handled by creating or importing Virtual Network representations of vCenter Networks and Distributed vSwitches. In this way, new VMs with defined network interfaces will be bound by OpenNebula to these Networks and/or Distributed vSwitches. OpenNebula can create a new logical layer of these vCenter Networks and Distributed vSwitches, in particular three types of Address Ranges can be defined per Virtual Network representing the vCenter network resources: plain Ethernet, IPv4 and IPv6. This networking information can be passed to the VMs through the :ref:`contextualization <bcont>` process.

Please check the :ref:`Networking Chapter <nm>` to find out more information about the networking support in vCenter infrastructures by OpenNebula.

Authentication
================================================================================

The following authentication methods are supported to access OpenNebula:

-  :ref:`Built-in User/Password <manage_users_adding_and_deleting_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>` (and Active Directory)

.. warning:: **Default:** OpenNebula comes by default with an internal built-in user/password authentication.

Please check the :ref:`Authentication Chapter <external_auth>` to find out more information about the authentication technologies supported by OpenNebula.

Advanced Components
================================================================================

Once you have an OpenNebula cloud up and running, you can install the following advanced components:

-  :ref:`Multi-VM Applications and Auto-scaling <oneapps_overview>`: OneFlow allows users and administrators to define, execute and manage multi-tiered applications, or services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management.
-  :ref:`Cloud Bursting <introh>`: Cloud bursting is a model in which the local resources of a Private Cloud are combined with resources from remote Cloud providers. Such support for cloud bursting enables highly scalable hosting environments.
-  :ref:`Public Cloud <introc>`: Cloud interfaces can be added to your Private Cloud if you want to provide partners or external users with access to your infrastructure, or to sell your overcapacity. The following interface provide a simple and remote management of cloud (virtual) resources at a high abstraction level: :ref:`Amazon EC2 and EBS APIs <ec2qcg>`.
-  :ref:`Application Insight <onegate_overview>`: OneGate allows Virtual Machine guests to push monitoring information to OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow auto-scaling rules.

.. |high level architecture of cluster, its components and relationship| image:: /images/one_vcenter_high.png
