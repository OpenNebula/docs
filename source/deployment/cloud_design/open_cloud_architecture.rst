.. _open_cloud_architecture:
.. _plan:

================================================================================
Open Cloud Architecture
================================================================================

In order to get the most out of a OpenNebula Cloud, we recommend that you create a plan with the features, performance, scalability, and high availability characteristics you want in your deployment. This Section provides information to plan an OpenNebula cloud based on KVM, an open source hypervisor. With this information, you will be able to easily architect and dimension your deployment, as well as understand the technologies involved in the management of virtualized resources and their relationship.

Architectural Overview
================================================================================

OpenNebula assumes that your physical infrastructure adopts a classical cluster-like architecture with a front-end, and a set of hosts where Virtual Machines (VM) will be executed. There is at least one physical network joining all the hosts with the front-end.

|high level architecture of cluster, its components and relationship|

A cloud architecture is defined by three components: storage, networking and virtualization. Therefore, the basic components of an OpenNebula system are:

-  **Front-end** that executes the OpenNebula services.
-  Hypervisor-enabled **hosts** that provide the resources needed by the VMs.
-  **Datastores** that hold the base images of the VMs.
-  Physical **networks** used to support basic services such as interconnection of the storage servers and OpenNebula control operations, and VLANs for the VMs.

OpenNebula presents a highly modular architecture that offers broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services. This Section briefly describes the different choices that you can make for the management of the different subsystems. If your specific services are not supported we recommend to check the drivers available in the `Add-on Catalog <http://opennebula.org/addons:catalog>`__. We also provide information and support about how to develop new drivers.

.. todo::   Review architecture --> only for KVM??

|OpenNebula Cloud Platform Support|

Dimensioning the Cloud
================================================================================

The dimension of a cloud infrastructure can be directly inferred from the expected workload in terms of VMs that the cloud infrastructure must sustain. This workload is also tricky to estimate, but this is a crucial exercise to build an efficient cloud.

The main aspects to take into account at the time of dimensioning the OpenNebula cloud are:

- **CPU**:

  - *without* overcommitment, each CPU core assigned to a VM must exists as a physical CPU core. By example, for a workload of 40 VMs with 2 CPUs, the cloud will need 80 physical CPUs. These 80 physical CPUs can be spread among different hosts: 10 servers with 8 cores each, or 5 server of 16 cores each;

  - *with* overcommitment, however, CPU dimension can be planned ahead, using the ``CPU`` and ``VCPU`` attributes: ``CPU`` states physical CPUs assigned to the VM, while ``VCPU`` states virtual CPUs to be presented to the guest OS.

- **MEMORY**: Planning for memory is straightforward, as by default *there is no overcommitment of memory* in OpenNebula. It is always a good practice to count 10% of overhead by the hypervisor (this is not an absolute upper limit, it depends on the hypervisor). So, in order to sustain a VM workload of 45 VMs with 2GB of RAM each, 90GB of physical memory is needed. The number of hosts is important, as each one will incur a 10% overhead due to the hypervisors. For instance, 10 hypervisors with 10GB RAM each will contribute with 9GB each (10% of 10GB = 1GB), so they will be able to sustain the estimated workload. The rule of thumb is having at least 1GB per core, but this also depends on the expected workload.

- **STORAGE**: It is important to understand how OpenNebula uses storage, mainly the difference between system and image datastore.

  - The **image datastore** is where OpenNebula stores all the images registered that can be used to create VMs, so the rule of thumb is to devote enough space for all the images that OpenNebula will have registered.

  - The **system datastore** is where the VMs that are currently running store their disks. It is trickier to estimate correctly since volatile disks come into play with no counterpart in the image datastore (volatile disks are created on the fly in the hypervisor).

  - One valid approach is to limit the storage available to users by defining quotas in the number of maximum VMs and also the Max Volatile Storage a user can demand, and ensuring enough system and image datastore space to comply with the limit set in the quotas. In any case, OpenNebula allows cloud administrators to add more system and images datastores if needed.

  - Dimensioning storage is a critical aspect, as it is usually the cloud bottleneck. It very much depends on the underlying technology. As an example, in Ceph for a medium size cloud  at least three servers are needed for storage with 5 disks each of 1TB, 16Gb of RAM, 2 CPUs of 4 cores each and at least 2 NICs.

- **NETWORK**: Networking needs to be carefully designed to ensure reliability in the cloud infrastructure. The recommendation is having 2 NICs in the front-end (public and service) (or 3 NICs depending on the storage backend, access to the storage network may be needed) 4 NICs present in each virtualization node: private, public, service and storage networks. Less NICs can be needed depending on the storage and networking configuration.

Importing Existing VMs
================================================================================

As soon as a new hypervisor server or public cloud is added to OpenNebula, the monitoring subsystem will extract all the Virtual Machines running in that particular server or public cloud region and label them as *Wild VMs*. Wild VMs are therefore VMs running in a hypervisor controlled by OpenNebula that have not been launched through OpenNebula.

OpenNebula allows to import these Wild VMs in order to control their life-cycle just like any other VM launched by OpenNebula. Proceed to this :ref:`host section <import_wild_vms>` for more details.

Front-End
================================================================================

The machine that holds the OpenNebula installation is called the front-end. This machine needs network connectivity to all the hosts, and possibly access to the storage Datastores (either by direct mount or network). The base installation of OpenNebula takes less than 150MB.

OpenNebula services include:

-  Management daemon (``oned``) and scheduler (``mm_sched``)
-  Web interface server (``sunstone-server``)
-  Optional  services: OneFlow, OneGate, econe, ...

.. warning:: Note that these components communicate through :ref:`XML-RPC <api>` and may be installed in different machines for security or performance reasons

There are several certified platforms to act as front-end for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that better fits your needs.

OpenNebula's default database uses **sqlite**. If you are planning a production or medium to large scale deployment, you should consider using :ref:`MySQL <mysql>`.

If you are interested in setting up a high available cluster for OpenNebula, check the :ref:`High Availability OpenNebula Section <oneha>`.

If you need to federate several datacenters, with a different OpenNebula instance managing the resources but needing a common authentication schema, check the :ref:`Federation Section <federation_section>`.

The maximum number of servers (virtualization hosts) that can be managed by a single OpenNebula instance (zone) strongly depends on the performance and scalability of the underlying platform infrastructure, mainly the storage subsystem. We do not recommend more than 500 servers within each zone, but there are users with 1,000 servers in each zone. You may find interesting the following section about :ref:`how to tune OpenNebula for large deployments <one_scalability>`.

Monitoring
================================================================================

The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of static probes provided by OpenNebula. The information is sent according to the following process: each host periodically sends monitoring data via UDP to the front-end which collects it and processes it in a dedicated module. This model is highly scalable and its limit (in terms of number of VMs monitored per second) is bounded to the performance of the server running oned and the database server. Please read the :ref:`UDP-push Section <imudppushg>` for more information.

Please check the :ref:`the Monitoring Section <mon>` for more details.

Virtualization Hosts
================================================================================

The hosts are the physical machines that will run the VMs. There are several certified platforms to act as nodes for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that better fits your needs. The Virtualization Subsystem is the component in charge of talking with the hypervisor installed in the hosts and taking the actions needed for each step in the VM life-cycle.

OpenNebula natively supports one open source hypervisor, the :ref:`KVM <kvmg>` hypervisor, and OpenNebula is configured by default to interact with hosts running KVM.

Ideally, the configuration of the nodes will be homogeneous in terms of the software components installed, the oneadmin administration user, accessible storage and network connectivity. This may not always be the case, and homogeneous hosts can be grouped in OpenNebula :ref:`clusters <cluster_guide>`

If you are interested in fail-over protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Section <ftguide>`.

Storage
================================================================================

OpenNebula uses *Datastores* to store VMs' disk images. A datastore is any storage medium, typically backed by SAN/NAS servers. In general, each datastore has to be accessible through the front-end using any suitable technology NAS, SAN or direct attached storage.

|image3|

When a VM is deployed, its images are *transferred* from the datastore to the hosts. Depending on the actual storage technology used, it can mean a real transfer, a symbolic link or setting up an LVM volume.

OpenNebula is shipped with 3 different datastore classes:

-  :ref:`System Datastores <system_ds>`: to hold images for running VMs. Depending on the storage technology used, these temporal images can be complete copies of the original image, qcow deltas or simple filesystem links.

-  **Image Datastores**: to store the disk images repository. Disk images are moved, or cloned to/from the System Datastore when the VMs are deployed or shutdown, or when disks are attached or snapshotted.

-  :ref:`File Datastore <file_ds>`: a special datastore used to store plain files, not disk images. These files can be used as kernels, ramdisks or context files.

Image datastores can be of different types, depending on the underlying storage technology:

-  :ref:`Filesystem <fs_ds>`: to store disk images in a file form. The files are stored in a shared filesystem mounted from a SAN/NAS server.

-  :ref:`LVM <lvm_drivers>`: to use LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance.

-  :ref:`Ceph <ceph_ds>`: to store disk images using Ceph block devices.

.. warning:: **Default:** The system and images datastores are configured to use a shared filesystem.

Please check the :ref:`Storage Chapter <sm>` for more details.

Networking
================================================================================

OpenNebula provides an easily adaptable and customizable network subsystem in order to integrate the specific network requirements of existing datacenters. **At least two different physical networks are needed**:

-  **Service Network**: used by the OpenNebula front-end daemons to access the hosts in order to manage and monitor the hypervisors, and move image files. It is highly recommended to install a dedicated network for this purpose;
-  **Instance Network**: offers network connectivity to the VMs across the different hosts. To make an effective use of your VM deployments, you will probably need to make one or more physical networks accessible to them.

The OpenNebula administrator may associate one of the following drivers to each Host:

-  **dummy** (default): doesn't perform any network operation, and firewalling rules are also ignored.
-  :ref:`fw <firewall>`: firewalling rules are applied, but networking isolation is ignored.
-  :ref:`802.1Q <hm-vlan>`: restrict network access through VLAN tagging, which requires support by the hardware switches.
-  :ref:`ebtables <ebtables>`: restrict network access through Ebtables rules. No special hardware configuration required.
-  :ref:`ovswitch <openvswitch>`: restrict network access with `Open vSwitch Virtual Switch <http://openvswitch.org/>`__.

.. warning:: **Default:** The default configuration connects the VM network interface to a bridge in the physical host.

Please check the :ref:`Networking Chapter <nm>` to find out more information about the networking technologies supported by OpenNebula.

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

.. |high level architecture of cluster, its components and relationship| image:: /images/one_high.png
.. |OpenNebula Cloud Platform Support| image:: /images/overview_builders.png
.. |image3| image:: /images/datastoreoverview.png
