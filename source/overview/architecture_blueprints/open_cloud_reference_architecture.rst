.. _open_cloud_architecture:
.. _plan:

================================================================================
Open Cloud Reference Architecture
================================================================================

Enterprise cloud computing is the next step in the evolution of data center (DC) virtualization. OpenNebula is a simple but feature-rich and flexible solution to build and manage enterprise clouds and virtualized DCs, that combines existing virtualization technologies with advanced features for multi-tenancy, automatic provision and elasticity. OpenNebula follows a bottom-up approach driven by sysadmins, devops and users real needs.

Architectural Overview
================================================================================

OpenNebula assumes that your physical infrastructure adopts a classical cluster-like architecture with a front-end, and a set of hosts where Virtual Machines (VM) will be executed. There is at least one physical network joining all the hosts with the front-end.

|high level architecture of cluster, its components and relationship|

A cloud architecture is defined by three components: storage, networking and virtualization. Therefore, the basic components of an OpenNebula system are:

-  **Front-end** that executes the OpenNebula services.
-  Hypervisor-enabled **hosts** that provide the resources needed by the VMs.
-  **Datastores** that hold the base images of the VMs.
-  Physical **networks** used to support basic services such as interconnection of the storage servers and OpenNebula control operations, and VLANs for the VMs.

OpenNebula presents a highly modular architecture that offers broad support for commodity and enterprise-grade hypervisors, monitoring, storage, networking and user management services. This Section briefly describes the different choices that you can make for the management of the different subsystems. If your specific services are not supported we recommend checking the drivers available in the `Add-on Catalog <https://github.com/OpenNebula/one/wiki/Add_ons-Catalog>`__. We also provide information and support about how to develop new drivers.

.. _dimensioning_the_cloud:

Dimensioning the Cloud
================================================================================

The dimension of a cloud infrastructure can be directly inferred from the expected workload in terms of VMs that the cloud infrastructure must sustain. This workload is also tricky to estimate, but this is a crucial exercise to build an efficient cloud.

The main aspects to take into account at the time of dimensioning the OpenNebula cloud follow.

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

Please take into account that these recommendations are meant as a guidance and may be relaxed or increased depending on the size and workload of your cloud.

The maximum number of servers (virtualization hosts) that can be managed by a single OpenNebula instance strongly depends on the performance and scalability of the underlying platform infrastructure, mainly the storage subsystem. The general recommendation is no more than 2,500 servers and 10,000 VMs managed by a single instance. Related to this, read the section about :ref:`how to tune OpenNebula for large deployments <one_scalability>`.

**KVM nodes**

Regarding the dimensions of the Linux virtualization nodes:

- **CPU**: without overcommitment, each CPU core assigned to a VM must exists as a physical CPU core. By example, for a workload of 40 VMs with 2 CPUs, the cloud will need 80 physical CPUs. These 80 physical CPUs can be spread among different hosts: 10 servers with 8 cores each, or 5 server of 16 cores each. With overcommitment, however, CPU dimension can be planned ahead, using the ``CPU`` and ``VCPU`` attributes: ``CPU`` states physical CPUs assigned to the VM, while ``VCPU`` states virtual CPUs to be presented to the guest OS.

- **MEMORY**: Planning for memory is straightforward, as by default *there is no overcommitment of memory* in OpenNebula. It is always a good practice to count 10% of overhead for the hypervisor. (This is not an absolute upper limit, it depends on the hypervisor, however, since containers have a very low overhead, this metric is negligible for LXD nodes.) So, in order to sustain a VM workload of 45 VMs with 2GB of RAM each, 90GB of physical memory is needed. The number of hosts is important, as each one will incur a 10% overhead due to the hypervisors. For instance, 10 hypervisors with 10GB RAM each will contribute with 9GB each (10% of 10GB = 1GB), so they will be able to sustain the estimated workload. The rule of thumb is having at least 1GB per core, but this also depends on the expected workload.

**LXD nodes**

Since LXD avoids using virtual hardware, the amount of resources dedicated to the hypervisor are much lower when compared to KVM. There is no exact figure but you can get an idea from `this resource usage comparison vs KVM <https://insights.ubuntu.com/2015/05/18/lxd-crushes-kvm-in-density-and-speed/>`_

**Firecracker nodes**

Firecracker is a lightweight and optimized VMM. The amount of resources dedicated required for it are much lower when compared to Qemu/KVM. Check the :ref:`the microVM density tests result guide <hv_scalability>` for an overview of the related required resources.

**Storage**

It is important to understand how OpenNebula uses storage, mainly the difference between system and image datastores.

- The **image datastore** is where OpenNebula stores all the images registered that can be used to create VMs, so the rule of thumb is to devote enough space for all the images that OpenNebula will have registered.

- The **system datastore** is where the VMs that are currently running store their disks. It is trickier to estimate correctly since volatile disks come into play with no counterpart in the image datastore; (volatile disks are created on the fly in the hypervisor).

One valid approach is to limit the storage available to users by defining quotas in the number of maximum VMs and also the Max Volatile Storage a user can demand, and ensuring enough system and image datastore space to comply with the limit set in the quotas. In any case, OpenNebula allows cloud administrators to add more system and images datastores if needed.

Dimensioning storage is a critical aspect, as it is usually the cloud bottleneck. It very much depends on the underlying technology. As an example, in Ceph for a medium size cloud  at least three servers are needed for storage with 5 disks each of 1TB, 16Gb of RAM, 2 CPUs of 4 cores each and at least 2 NICs.

**Network**

Networking needs to be carefully designed to ensure reliability in the cloud infrastructure. The recommendation is to have 2 NICs in the front-end (public and service), or 3 NICs depending on the storage backend, as access to the storage network may be needed, and 4 NICs present in each virtualization node (private, public, service and storage networks). Fewer NICs may be needed, depending on the storage and networking configuration.

Front-End
================================================================================

The machine that holds the OpenNebula installation is called the front-end. This machine needs network connectivity to all the hosts, and possibly access to the storage Datastores (either by direct mount or network). The base installation of OpenNebula takes less than 150MB.

OpenNebula services include:

-  Management daemon (``oned``) and scheduler (``mm_sched``)
-  Web interface server (``sunstone-server``)
-  Advanced components: OneFlow, OneGate, econe, ...

.. note:: Note that these components communicate through :ref:`XML-RPC <api>` and may be installed in different machines for security or performance reasons.

There are several certified platforms to act as front-end for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that best fits your needs.

OpenNebula's default database uses **sqlite**. If you are planning a production or medium to large scale deployment, you should consider using :ref:`MySQL <mysql>`.

If you are interested in setting up a highly available cluster for OpenNebula, check the :ref:`High Availability OpenNebula Section <oneha>`.

If you need to federate several datacenters, with a different OpenNebula instance managing the resources, but needing a common authentication schema, check the :ref:`Federation Section <federation_section>`.

Monitoring
================================================================================

The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of static probes provided by OpenNebula. The information is sent according to the following process: each host periodically sends monitoring data to the front-end which collects it and processes it in a dedicated module. This model is highly scalable and its limit (in terms of number of VMs monitored per second) is bounded to the performance of the server running ``oned`` and the database server.

Please check the :ref:`the Monitoring Section <mon>` for more details.

Virtualization Hosts
================================================================================

The hosts are the physical machines that will run the VMs. There are several certified platforms to act as nodes for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that best fits your needs. The Virtualization Subsystem is the component in charge of talking to the hypervisor installed in the hosts and taking the actions needed for each step in the VM life-cycle.

OpenNebula natively supports three open source hypervisors, the :ref:`KVM <kvmg>`, :ref:`LXD <lxdmg>` and :ref:`Firecracker <fcmg>`.

Ideally, the configuration of the nodes will be homogeneous in terms of the software components installed, the oneadmin administration user, accessible storage and network connectivity. This may not always be the case, and homogeneous hosts can be grouped in OpenNebula :ref:`clusters <cluster_guide>`, e.g. LXD cluster and KVM cluster.

If you are interested in fail-over protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Section <ftguide>`.

Storage
================================================================================

OpenNebula uses *Datastores* to store VMs' disk images. A datastore is any storage medium, typically backed by SAN/NAS servers. In general, each datastore has to be accessible through the front-end using any suitable technology — NAS, SAN or direct attached storage.

|image3|

When a VM is deployed, its images are *transferred* from the datastore to the hosts. Depending on the actual storage technology used, it can mean a real transfer, a symbolic link or setting up an LVM volume.

OpenNebula is shipped with 3 different datastore classes:

-  **System Datastores**: to hold images for running VMs. Depending on the storage technology used, these temporary images can be complete copies of the original image, qcow deltas or simple filesystem links.

-  **Image Datastores**: to store the disk images repository. Disk images are moved, or cloned, to/from the System Datastore when the VMs are deployed or shutdown, or when disks are attached or snapshotted.

-  :ref:`File Datastore <file_ds>`: a special datastore used to store plain files, not disk images. These files can be used as kernels, ramdisks or context files.

Image datastores can be of different types, depending on the underlying storage technology:

-  :ref:`Filesystem <fs_ds>`: to store disk images in a file form. There are three types: ssh, shared and qcow.

-  :ref:`LVM <lvm_drivers>`: to use LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance.

-  :ref:`Ceph <ceph_ds>`: to store disk images using Ceph block devices.

.. warning:: **Default:** The default system and images datastores are configured to use a filesystem with the ssh transfer drivers.

Please check the :ref:`Storage Chapter <sm>` for more details.

Networking
================================================================================

OpenNebula provides an easily adaptable and customizable network subsystem in order to integrate the specific network requirements of existing datacenters. **At least two different physical networks are needed**:

-  **Service Network**: used by the OpenNebula front-end daemons to access the hosts in order to manage and monitor the hypervisors, and move image files. It is highly recommended to install a dedicated network for this purpose;
-  **Instance Network**: offers network connectivity to the VMs across the different hosts. To make effective use of your VM deployments, you will probably need to make one or more physical networks accessible to them.

The OpenNebula administrator may associate one of the following drivers to each Host:

-  **dummy** (default): doesn't perform any network operation, and firewalling rules are also ignored.
-  :ref:`fw <firewall>`: firewalling rules are applied, but networking isolation is ignored.
-  :ref:`802.1Q <hm-vlan>`: restrict network access through VLAN tagging, which requires support by the hardware switches.
-  :ref:`ebtables <ebtables>`: restrict network access through Ebtables rules. No special hardware configuration required.
-  :ref:`ovswitch <openvswitch>`: restrict network access with `Open vSwitch Virtual Switch <http://openvswitch.org/>`__.
-  :ref:`vxlan <vxlan>`: segment a VLAN into isolated networks using the VXLAN encapsulation protocol.

Please check the :ref:`Networking Chapter <nm>` to find out more about the networking technologies supported by OpenNebula.

Authentication
================================================================================

The following authentication methods are supported to access OpenNebula:

-  :ref:`Built-in User/Password <manage_users_adding_and_deleting_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>` (and Active Directory)

.. warning:: **Default:** OpenNebula comes by default with an internal built-in user/password authentication.

Please check the :ref:`Authentication Chapter <external_auth>` to find out more about the authentication technologies supported by OpenNebula.

Advanced Components
================================================================================

Once you have an OpenNebula cloud up and running, you can install the following advanced components:

.. todo:: Add more?

-  :ref:`Multi-VM Applications and Auto-scaling <oneapps_overview>`: OneFlow allows users and administrators to define, execute and manage multi-tiered applications, or services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management.
-  :ref:`Application Insight <onegate_overview>`: OneGate allows Virtual Machine guests to push monitoring information to OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow auto-scaling rules.

.. |high level architecture of cluster, its components and relationship| image:: /images/one_high.png
.. |image3| image:: /images/datastoreoverview.png
