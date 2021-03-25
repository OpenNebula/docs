.. _numa:

================================================================================
Virtual Topology and CPU Pinning
================================================================================

Overview
================================================================================

In this guide you'll learn to setup OpenNebula to control how VM resources are mapped onto the hypervisor ones. These settings will help you to fine tune the performance of VMs. We will use the following concepts:

* **Cores, Threads and Sockets**. A computer processor is connected to the motherboard through a *socket*. A processor can pack one or more *cores*, each one implements a separated processing unit that share some cache levels, memory and I/O ports. CPU Cores performance can be improved by the use of hardware *multi-threading* (SMT) that permits multiple execution flows to run simultaneously on a single core.

* **NUMA**. Multi-processor servers are usually arranged in nodes or cells. Each *NUMA node* holds a fraction of the overall system memory. In this configuration, a processor accesses memory and I/O ports local to its node faster than to the non-local ones.

* **Hugepages**. Systems with big physical memory use also a big number of virtual memory pages. This big number makes the use of virtual-to-physical translation caches inefficient. Hugepages reduces the number of virtual pages in the system and optimize the virtual memory subsystem.

In OpenNebula the virtual topology of a VM is defined by the number of sockets, cores and threads. We assume that a NUMA node or cell is equivalent to a socket and they will be used interchangeably in this guide.

.. note:: Different limitations might exists regarding virtual topology definition and CPU pinning depending on the hypervisor. In order to get hypervisor specific information please check the corresponding hypervisor driver guide.

Defining a Virtual Topology
================================================================================

Basic Configuration
--------------------------------------------------------------------------------

The most basic configuration is to define just the number of vCPU (virtual CPU) and the amount of memory of the VM. In this case the guest OS will see ``VCPU`` sockets of 1 core and 1 thread each. The VM template in this case for 4 vCPUs VM is:

.. code::

   MEMORY = 1024
   VCPU   = 4

A VM running with this configuration will see the following topology:

.. code::

   # lscpu
   ...
   CPU(s):                4
   On-line CPU(s) list:   0-3
   Thread(s) per core:    1
   Core(s) per socket:    1
   Socket(s):             4
   NUMA node(s):          1

   # numactl -H
   available: 1 nodes (0)
   node 0 cpus: 0 1 2 3
   node 0 size: 1023 MB
   node 0 free: 607 MB
   node distances:
   node   0
     0:  10


CPU Topology
--------------------------------------------------------------------------------

You can give more detail to the previous scenario by defining a custom number of sockets, cores and threads for a given number of vCPUs. Usually, there is no significant difference between how you arrange the number of cores and sockets performance-wise. However some software products may require a specific topology setup in order to work.

For example a VM with 2 sockets and 2 cores per sockets and 2 threads per core is defined by the following template:

.. code::

   VCPU   = 8
   MEMORY = 1024

   TOPOLOGY = [ SOCKETS = 2, CORES = 2, THREADS = 2 ]

and the associated guest OS view:

.. code::

   # lscpu
   ...
   CPU(s):                8
   On-line CPU(s) list:   0-7
   Thread(s) per core:    2
   Core(s) per socket:    2
   Socket(s):             2
   NUMA node(s):          1
   ...

   # numactl -H
   available: 1 nodes (0)
   node 0 cpus: 0 1 2 3 4 5 6 7
   node 0 size: 1023 MB
   node 0 free: 600 MB
   node distances:
   node   0
     0:  10

.. important:: When defining a custom CPU Topology you need to set the number of sockets, cores and threads, and it must match the total number of vCPUS, i.e. ``VCPU = SOCKETS * CORES * THREAD``.


NUMA Topology
--------------------------------------------------------------------------------

You can provide further detail to the topology of your VM by defining the placement of the sockets (NUMA nodes) into the hypervisor NUMA nodes. In this scenario each VM ``SOCKET`` will be exposed to guest OS as a separated NUMA node with its own local memory.

The previous example can expose a 2 socket (NUMA node) by setting a ``PIN_POLICY`` (see below):

.. code::

   VCPU   = 8
   MEMORY = 1024

   TOPOLOGY = [ PIN_POLICY = thread, SOCKETS = 2, CORES = 2, THREADS = 2 ]

In this case OpenNebula will generate an entry for each NUMA node, extending the previous VM template with:

.. code::

   NUMA_NODE = [ MEMORY = 512, TOTAL_CPUS = 4 ]
   NUMA_NODE = [ MEMORY = 512, TOTAL_CPUS = 4 ]

The *in-guest* OS view is for this example:

.. code::

   # lscpu
   ...
   CPU(s):                8
   On-line CPU(s) list:   0-7
   Thread(s) per core:    2
   Core(s) per socket:    2
   Socket(s):             2
   NUMA node(s):          2
   ...

   # numactl -H
   available: 2 nodes (0-1)
   node 0 cpus: 0 1 2 3
   node 0 size: 511 MB
   node 0 free: 235 MB
   node 1 cpus: 4 5 6 7
   node 1 size: 511 MB
   node 1 free: 359 MB
   node distances:
   node   0   1
     0:  10  20
     1:  20  10

Asymmetric topology
--------------------------------------------------------------------------------

For some applications you may need an asymmetric NUMA configuration, i.e. not distributing the VM resources evenly across the nodes. You can define each node configuration by manually setting the ``NUMA_NODE`` attributes. For example:

.. code::

   MEMORY = 3072
   VCPU = 6
   CPU  = 6
   TOPOLOGY = [ PIN_POLICY = CORE, SOCKETS = 2 ]

   NUMA_NODE = [ MEMORY = 1024, TOTAL_CPUS = 2 ]
   NUMA_NODE = [ MEMORY = 2048, TOTAL_CPUS = 4 ]

.. important:: OpenNebula will also check that the total MEMORY in all the nodes matches to that set in the VM.

CPU and NUMA Pinning
================================================================================

When you need to expose the NUMA topology to the guest you have to set a pinning policy to map each virtual NUMA node resources (memory and vCPUs) onto the hypervisor nodes. OpenNebula can work with four different policies:

* ``CORE``: each vCPU is assigned to a whole hypervisor core. No other threads in that core will be used. This policy can be useful to isolate the VM workload for security reasons.
* ``THREAD``: each vCPU is assigned to a hypervisor CPU thread.
* ``SHARED``: the VM is assigned a set of the hypervisor CPUS shared by all the VM vCPUs.
* ``NONE``: the VM is not assigned to any hypervisor CPUs. The access to the resources (i.e cpu time) will be limited by the `CPU` attribute.

VM memory is assigned to the closet hypervisor NUMA node where the vCPUs are pinned, trying to prioritize local memory accesses.

When using a pinning policy it is recommended to fix only the number of vCPUs letting the scheduler pick the number of cores and threads of the virtual topology. OpenNebula will try to optimize the VM performance by selecting the threads per core according to:

* For the ``CORE`` pin policy the number of ``THREADS`` is set to 1.
* Prefer as close as possible to the hardware configuration of the host and so be power of 2.
* The threads per core will not exceed that of the hypervisor.
* Prefer the configuration with the highest number of threads/core that fits in the host.

.. important:: When ``THREADS`` is set OpenNebula will look for a host that can allocate that number of threads per core; if not found the VM will remain in ``PENDING`` state. This may be required if you want the VM to run with a fixed number of threads per core.

For example to run a 2 NUMA node VM with 8 vCPUS and 4G of memory, using the ``THREAD`` policy you can use:

.. code::

	VCPU   = 8
	MEMORY = 4096

	TOPOLOGY = [ PIN_POLICY = thread, SOCKETS = 2 ]

.. important:: For pinned VMs the CPU (assigned hypervisor capacity) is automatically set to the vCPU number. No overcommitment is allowed for pinned workloads.

PCI Passthrough
--------------------------------------------------------------------------------

The scheduling process is slightly modified when a pinned VM includes PCI passthrough devices. In this case the NUMA nodes where the PCI devices are attached to are prioritized to pin the VM vCPUs and memory to speed-up I/O operations. No additional configuration is needed.

Using Hugepages
================================================================================

To enable the use of hugepages for the memory allocation of the VM just add the desired page size in the ``TOPOLOGY`` attribute, the size must be expressed in megabytes. For example to use 2M hugepages use:

.. code::

	TOPOLOGY = [ HUGEPAGE_SIZE = 2 ]

OpenNebula will look for a host with enough free pages of the requested size to allocate the VM. The resources of each virtual node will be placed as close as possible to the node providing the hugepages.

Summary of Virtual Topology Attributes
================================================================================

+--------------------+---------------------------------------------------------------------+
+ TOPOLOGY attribute | Meaning                                                             |
+====================+=====================================================================+
| PIN_POLICY         | vCPU pinning preference: ``CORE``, ``THREAD``, ``SHARED``, ``NONE`` |
+--------------------+---------------------------------------------------------------------+
| SOCKETS            | Number of sockets or NUMA nodes.                                    |
+--------------------+---------------------------------------------------------------------+
| CORES              | Number of cores per node                                            |
+--------------------+---------------------------------------------------------------------+
| THREADS            | Number of threads per core                                          |
+--------------------+---------------------------------------------------------------------+
| HUGEPAGE_SIZE      | Size of the hugepages (MB). If not defined no hugepages will be used|
+--------------------+---------------------------------------------------------------------+
| MEMORY_ACCESS      | Control if the memory is to be mapped ``shared`` or ``private``     |
+--------------------+---------------------------------------------------------------------+

Configuring the Host
================================================================================

When running VMs with a specific topology it is important to map (*pin*) it as close as possible to that on the hypervisor, so vCPUs and memory are allocated into the same NUMA node. However, by default a VM is assigned to all the resources in the system making incompatible running pinned and no-pinned workloads in the same host.

First you need to define which hosts are going to be used to run pinned workloads, and define the ``PIN_POLICY`` tag through Sunstone or using ``onehost update`` command. A Host can operate in two modes:

* ``NONE``. Default mode where no NUMA or hardware characteristics are considered. Resources are assigned and balanced by an external component, e.g. numad or kernel.

* ``PINNED``. VMs are allocated and pinned to specific nodes according to different policies.

.. note:: You can also create an OpenNebula Cluster including all the Host devoted to run pinned workloads, and set the ``PIN_POLICY`` at the cluster level.

The host monitoring probes should also return the NUMA topology and usage status of the hypervisors. The following command shows a single node hypervisor with 4 cores and 2 threads running a 2 vCPU VM:

.. code::

   $ onehost show 0
   ...
   MONITORING INFORMATION
   PIN_POLICY="PINNED"
   ...

   NUMA NODES

     ID CORES                                              USED FREE
      0 X- X- -- --                                        4    4

   NUMA MEMORY

    NODE_ID TOTAL    USED_REAL            USED_ALLOCATED       FREE
	  0 7.6G     6.8G                 1024M                845.1M

In this output, the string ``X- X- -- --`` represents the NUMA allocation: each group is a core, when a thread is free is shown as ``-``, ``x`` means the thread is in use and ``X`` means that the thread is used *and* the core has no free threads. In this case the VM is using the ``CORE`` pin policy.

.. note:: If you want to use hugepages of a given size you need to allocate them first. This can be done either at boot time or dynamically. Also you may need need to mount the `hugetlbfs` filesystem. Please refer to your OS documentation to learn how to do this.

You can also isolate some hypervisor CPUS from the NUMA scheduler. Isolated CPUs will not be used to pin any VM. The isolated CPUs are defined with the ``ISOLCPUS`` attribute, the attribute is a comma separated list of CPU IDs. For example ``ISOLCPUS="0,5"`` will isolated CPUs 0,5 and hence will not be used to pin any VM.


CPU Pinning and Overcommitment
--------------------------------------------------------------------------------

When using a pinned policy, overcommitment is disabled by default (``CPU = 1`` in the VM template). However, some scenarios may require to fix the CPU thread where a VM is running while letting more VMs run in the very same CPU thread.

You can configure the number of VMS per physical thread for each host by setting the ``VMS_THREAD`` (defaults to 1) variable in the host template. For example ``VMS_THREAD = 4`` will pin up to 4 VMS per physical thread in each core.

.. important:: When using overcommitment and NUMA you need to set the host overcommitment in the same way, so the total CPU number accounts for the new ``VMS_THREAD`` value. For example, a host with 8 CPUs (``TOTAL_CPU=800``) and ``VMS_THREAD=4`` need to overcommit the CPU number so the ``TOTAL_CPU`` at most 3200 (8 * 4 = 32 CPUs, max.). You can do this with the ``RESERVED_CPU`` attribute for the host, ``RESERVED_CPU = "-2400"`` in this case (``3200 = 800 - (-2400``).

A Complete Example
================================================================================

Let us define a VM with two NUMA nodes using 2M hugepages, 4 vCPUs and 1G of memory. The template is as follows:

.. code::

   MEMORY = "1024"

   CPU  = "4"
   VCPU = "4"
   CPU_MODEL = [ MODEL="host-passthrough" ]

   TOPOLOGY = [
     HUGEPAGE_SIZE = "2",
     MEMORY_ACCESS = "shared",
     NUMA_NODES    = "2",
     PIN_POLICY    = "THREAD" ]

   DISK = [ IMAGE="CentOS7" ] 
   NIC  = [ IP="10.4.4.11", NETWORK="Management" ]

   CONTEXT = [ NETWORK="YES", SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]" ]

The VM is deployed in a hypervisor with the following characteristics, 1 node, 8 CPUs and 4 cores:

.. code::

   # numactl -H
   available: 1 nodes (0)
   node 0 cpus: 0 1 2 3 4 5 6 7
   node 0 size: 7805 MB
   node 0 free: 2975 MB
   node distances:
   node   0
     0:  10

and 8G of memory with a total of 2048 2M hugepages:

.. code::

   # numastat -m
                             Node 0           Total
                    --------------- ---------------
   MemTotal                 7805.56         7805.56
   MemFree                   862.80          862.80
   MemUsed                  6942.76         6942.76
   ...
   HugePages_Total          2048.00         2048.00
   HugePages_Free           1536.00         1536.00
   HugePages_Surp              0.00            0.00

This characteristics can be also queried trough the OpenNebula CLI:

.. code::

   $ onehost show 0
   ...

   NUMA NODES

     ID CORES                                              USED FREE
      0 XX XX -- --                                        4    4

   NUMA MEMORY

    NODE_ID TOTAL    USED_REAL            USED_ALLOCATED       FREE
          0 7.6G     6.8G                 1024M                845.1M

   NUMA HUGEPAGES

    NODE_ID SIZE     TOTAL    FREE     USED
          0 2M       2048     1536     512
          0 1024M    0        0        0
   ...

Note that in this case the previous VM has been pinned to 4 CPUS (0,4,1,5) and it
is using 512 pages of 2M. You can verified that the VM is actually running in this resources through libvirt:

.. code::

   virsh # vcpuinfo 1
   VCPU:           0
   CPU:            0
   State:          running
   CPU time:       13.0s
   CPU Affinity:   y-------

   VCPU:           1
   CPU:            4
   State:          running
   CPU time:       5.8s
   CPU Affinity:   ----y---

   VCPU:           2
   CPU:            1
   State:          running
   CPU time:       39.1s
   CPU Affinity:   -y------

   VCPU:           3
   CPU:            5
   State:          running
   CPU time:       25.4s
   CPU Affinity:   -----y--

You can also check the Guest OS point of view by executing the previous commands in the VM. It should show 2 nodes with 2 CPUs (threads) per core and 512M each:

.. code::

   # numactl -H
   available: 2 nodes (0-1)
   node 0 cpus: 0 1
   node 0 size: 511 MB
   node 0 free: 401 MB
   node 1 cpus: 2 3
   node 1 size: 511 MB
   node 1 free: 185 MB
   node distances:
   node   0   1
     0:  10  20
     1:  20  10

   # numastat -m

   Per-node system memory usage (in MBs):
                             Node 0          Node 1           Total
                    --------------- --------------- ---------------
   MemTotal                  511.62          511.86         1023.48
   MemFree                   401.13          186.23          587.36
   MemUsed                   110.49          325.62          436.11
   ...

If you prefer the OpenNebula CLI will show this information:

.. code::

   $ onevm show 0
   ...
   NUMA NODES

     ID   CPUS     MEMORY TOTAL_CPUS
      0    0,4       512M          2
      0    1,5       512M          2

   TOPOLOGY

   NUMA_NODES  CORES  SOCKETS  THREADS
            2      2        1        2

Considerations and Limitations
================================================================================

Please consider the following limitations when using pinned VMs:

* VM Migration. Pinned VMs cannot VM live migrated, you need to migrate the VMs through a power off - power on cycle.

* Re-sizing of asymmetric virtual topologies is not supported, as the NUMA nodes are re-generated with the new ``VCPU`` and ``MEMORY`` values. Also note that the pinned CPUs may change.

* Asymmetric configurations. As for qemu 4.0 and libvirt 5.4 NUMA nodes cannot be defined with no memory or without any CPU, you'll get the followign errors:

.. code::

   error: Failed to create domain from deployment.0
   error: internal error: process exited while connecting to monitor:  qemu-system-x86_64: -object memory-backend-ram,id=ram-node1,size=0,host-nodes=0,policy=bind: property 'size' of memory-backend-ram doesn't take value '0'

   virsh create deployment.0
   error: Failed to create domain from deployment.0
   error: XML error: Missing 'cpus' attribute in NUMA cell

