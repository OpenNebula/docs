.. _plan:

==========================
Planning the Installation
==========================

In order to get the most out of a OpenNebula Cloud, we recommend that you create a plan with the features, performance, scalability, and high availability characteristics you want in your deployment. This guide provides information to plan an OpenNebula installation, so you can easily architect your deployment and understand the technologies involved in the management of virtualized resources and their relationship.

Architectural Overview
======================

OpenNebula assumes that your physical infrastructure adopts a classical cluster-like architecture with a front-end, and a set of hosts where Virtual Machines (VM) will be executed. There is at least one physical network joining all the hosts with the front-end.

|high level architecture of cluster, its components and relationship|

The basic components of an OpenNebula system are:

-  **Front-end** that executes the OpenNebula services.
-  Hypervisor-enabled **hosts** that provide the resources needed by the VMs.
-  **Datastores** that hold the base images of the VMs.
-  Physical **networks** used to support basic services such as interconnection of the storage servers and OpenNebula control operations, and VLANs for the VMs.

OpenNebula presents a highly modular architecture that offers broad support for commodity and enterprise-grade hypervisor, monitoring, storage, networking and user management services. This guide briefly describes the different choices that you can make for the management of the different subsystems. If your specific services are not supported we recommend to check the drivers available in the `Add-on Catalog <http://opennebula.org/addons:catalog>`__. We also provide information and support about how to develop new drivers.

|OpenNebula Cloud Platform Support|

Dimensioning the Cloud
======================

The dimension of a cloud infrastructure can be directly inferred from the expected workload in terms of VM that the cloud infrastructure must sustain. This workload is also tricky to estimate, but this is a crucial exercise to build an efficient cloud.

The main aspects to take into account at the time of dimensioning the OpenNebula cloud are:

- **CPU**: unless overcommitment is planned the relation is that for each CPU core that one VM wants to use, a physical CPU core must exist. For instance, for a workload of 40 VMs with 2 CPUs the cloud will need 80 physical CPUs. These physical CPUs can be spread among different phyisical servers, for instance 10 servers with 8 cores each, or 5 server of 16 cores each. CPU dimension can be planned ahead with overcommitment, achieved using the CPU and VCPU attributes (CPU states physical CPUs assigned to this VM, whereas VCPU stated virtual CPUs to be presented to the guest OS)

- **MEMORY**: Planning for memory is straightforward, as there are no overcommitment of memory in OpenNebula. It is always a good practice to count for a 10% overhead of the hypervisor (this is an absolut upper limit, depending on the hypervisor this can be adjusted). So, in order to sustain a VM workload of 45 VMs with 2Gb of RAM each, 90Gb of physical memory is needed. The number of physical servers is important as each one will incur on a 10% overhead due to the hypersors. For instance, 10 hypervisors with 10Gb RAM each will contribute with 9Gb each (10% of 10Gb = 1Gb), so they will be able to sustain the estimated workload.

- **STORAGE**: It is important to understand how OpenNebula uses storage, mainly the difference between system and image datastore. The image datastore is where OpenNebula stores all the images registered that can be used to create VMs, so the rule of thumb is to devote enough space for all the images that OpenNebula will have registered. The system datastore is where the VMs that are currently running store their disks, and it is trickier to estimate correctly since volatile disks come into play with no counterpart in the image datastore (volatile disks are created on the fly in the hypervisor). One valid approach is to limit the storage available to users by defining quotas in the number of maximum VMs and also the Max Volatile Storage a user can demand, and ensuring enough system and image datastore space to comply with the limit set in the quotas. In any case, currently, OpenNebula allows cloud administrators to add more system and images datastores if needed.

Front-End
=========

The machine that holds the OpenNebula installation is called the front-end. This machine needs network connectivity to each host, and possibly access to the storage Datastores (either by direct mount or network). The base installation of OpenNebula takes less than 50MB.

OpenNebula services include:

-  Management daemon (``oned``) and scheduler (``mm_sched``)
-  Web interface server (``sunstone-server``)

.. warning:: Note that these components communicate through :ref:`XML-RPC <api>` and may be installed in different machines for security or performance reasons

There are several certified platforms to act as front-end for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that better fits your needs.

OpenNebula's default database uses **sqlite**. If you are planning a production or medium to large scale deployment, you should consider using :ref:`MySQL <mysql>`.

If you are interested in setting up a high available cluster for OpenNebula, check the :ref:`High OpenNebula Availability Guide <oneha>`.

The maximum number of servers (virtualization hosts) that can be managed by a single OpenNebula instance (zone) strongly depends on the performance and scalability of the underlying platform infrastructure, mainly the storage subsystem. We do not recommend more than 500 servers within each zone, but there are users with 1,000 servers in each zone. You may find interesting the following guide about :ref:`how to tune OpenNebula for large deployments <one_scalability>`.

Monitoring
==========

The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of static probes provided by OpenNebula. The output of these probes is sent to OpenNebula in two different ways:

-  **UDP-push Model**: Each host periodically sends monitoring data via UDP to the frontend which collects it and processes it in a dedicated module. This model is highly scalable and its limit (in terms of number of VMs monitored per second) is bounded to the performance of the server running oned and the database server. Please read the :ref:`UDP-push guide <imudppushg>` for more information.
-  **Pull Model**: OpenNebula periodically actively queries each host and executes the probes via ``ssh``. This mode is limited by the number of active connections that can be made concurrently, as hosts are queried sequentially. Please read the :ref:`KVM and Xen SSH-pull guide <imsshpullg>` or the :ref:`ESX-pull guide <imesxpullg>` for more information.

.. warning:: **Default**: UDP-push Model is the default IM for KVM and Xen in OpenNebula >= 4.4.

Please check the :ref:`the Monitoring Guide <mon>` for more details.

Virtualization Hosts
====================

The hosts are the physical machines that will run the VMs. There are several certified platforms to act as nodes for each version of OpenNebula. Refer to the :ref:`platform notes <uspng>` and chose the one that better fits your needs. The Virtualization Subsystem is the component in charge of talking with the hypervisor installed in the hosts and taking the actions needed for each step in the VM lifecycle.

OpenNebula natively supports three hypervisors:

-  :ref:`Xen <xeng>`
-  :ref:`KVM <kvmg>`
-  :ref:`VMware <evmwareg>`

.. warning:: **Default**: OpenNebula is configured to interact with hosts running KVM.

Please check the :ref:`Virtualization Guide <vmmg>` for more details of the supported virtualization technologies.

If you are interested in failover protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Guide <ftguide>`.

Storage
=======

OpenNebula uses Datastores to handle the VM disk Images. A Datastore is any storage medium used to store disk images for VMs, previous versions of OpenNebula refer to this concept as Image Repository. Typically, a datastore will be backed by SAN/NAS servers. In general, each Datastore has to be accessible through the front-end using any suitable technology NAS, SAN or direct attached storage.

|image3|

When a VM is deployed the Images are *transferred* from the Datastore to the hosts. Depending on the actual storage technology used it can mean a real transfer, a symbolic link or setting up an LVM volume.

OpenNebula is shipped with 3 different datastore classes:

-  :ref:`System Datastores <system_ds>` to hold images for running VMs, depending on the storage technology used these temporal images can be complete copies of the original image, qcow deltas or simple filesystem links.

-  **Image Datastores** store the disk images repository. Disk images are moved, or cloned to/from the System datastore when the VMs are deployed or shutdown; or when disks are attached or snapshoted.

-  :ref:`File Datastore <file_ds>` is a special datastore used to store plain files and not disk images. The plain files can be used as kernels, ramdisks or context files.

Image datastores can be of different type depending on the underlying storage technology:

-  :ref:`File-system <fs_ds>`, to store disk images in a file form. The files are stored in a directory mounted from a SAN/NAS server.

-  :ref:`vmfs <vmware_ds_datastore_configuration>`, a datastore specialized in VMFS format to be used with VMware hypervisors. Cannot be mounted in the OpenNebula front-end since VMFS is not \*nix compatible.

-  :ref:`LVM <lvm_drivers>`, The LVM datastore driver provides OpenNebula with the possibility of using LVM volumes instead of plain files to hold the Virtual Images. This reduces the overhead of having a file-system in place and thus increases performance..

-  :ref:`Ceph <ceph_ds>`, to store disk images using Ceph block devices.

.. warning:: **Default:** The system and images datastores are configured to use a shared filesystem.

Please check the :ref:`Storage Guide <sm>` for more details.

Networking
==========

OpenNebula provides an easily adaptable and customizable network subsystem in order to better integrate with the specific network requirements of existing datacenters. At least two different physical networks are needed:

-  A **service network** is needed by the OpenNebula front-end daemons to access the hosts in order to manage and monitor the hypervisors, and move image files. It is highly recommended to install a dedicated network for this purpose.
-  A **instance network** is needed to offer network connectivity to the VMs across the different hosts. To make an effective use of your VM deployments you'll probably need to make one or more physical networks accessible to them.

The OpenNebula administrator may associate one of the following drivers to each Host:

-  **dummy**: Default driver that doesn't perform any network operation. Firewalling rules are also ignored.
-  :ref:`fw <firewall>`: Firewall rules are applied, but networking isolation is ignored.
-  :ref:`802.1Q <hm-vlan>`: restrict network access through VLAN tagging, which also requires support from the hardware switches.
-  :ref:`ebtables <ebtables>`: restrict network access through Ebtables rules. No special hardware configuration required.
-  :ref:`ovswitch <openvswitch>`: restrict network access with `Open vSwitch Virtual Switch <http://openvswitch.org/>`__.
-  :ref:`VMware <vmwarenet>`: uses the VMware networking infrastructure to provide an isolated and 802.1Q compatible network for VMs launched with the VMware hypervisor.

.. warning:: **Default:** The default configuration connects the virtual machine network interface to a bridge in the physical host.

Please check the :ref:`Networking Guide <nm>` to find out more information of the networking technologies supported by OpenNebula.

Authentication
==============

You can choose from the following authentication models to access OpenNebula:

-  :ref:`Built-in User/Password <manage_users_adding_and_deleting_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>`

.. warning:: **Default:** OpenNebula comes by default with an internal built-in user/password authentication.

Please check the :ref:`Authentication Guide <external_auth>` to find out more information of the auth technologies supported by OpenNebula.

Advanced Components
===================

Once you have an OpenNebula cloud up and running, you can install the following advanced components:

-  :ref:`Multi-VM Applications and Auto-scaling <oneapps_overview>`: OneFlow allows users and administrators to define, execute and manage multi-tiered applications, or services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management.
-  :ref:`Cloud Bursting <introh>`: Cloud bursting is a model in which the local resources of a Private Cloud are combined with resources from remote Cloud providers. Such support for cloud bursting enables highly scalable hosting environments.
-  :ref:`Public Cloud <introc>`: Cloud interfaces can be added to your Private Cloud if you want to provide partners or external users with access to your infrastructure, or to sell your overcapacity. The following interface provide a simple and remote management of cloud (virtual) resources at a high abstraction level: :ref:`Amazon EC2 and EBS APIs <ec2qcg>`.
-  :ref:`Application Insight <onegate_overview>`: OneGate allows Virtual Machine guests to push monitoring information to OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow auto-scaling rules.

.. |high level architecture of cluster, its components and relationship| image:: /images/one_high.png
.. |OpenNebula Cloud Platform Support| image:: /images/overview_builders.png
.. |image3| image:: /images/datastoreoverview.png
