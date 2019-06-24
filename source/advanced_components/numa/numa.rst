.. _numa:

================================================================================
NUMA and CPU Pinning
================================================================================

Overview
================================================================================

In this guide you'll learn how to setup OpenNebula to control how VM resources are mapped onto the hypervisor ones. These settings will help you to fine tune the performance of VMs. We will use the following concepts:

* **Cores, Threads and Sockets**. A computer processor is connected to the motherboard through a *socket*. A processor can pack one or more *cores*, each one implements a separated processing unit that share cache, memory and I/O ports. CPU Cores performance can be improved by the use of hardware *multi-threading* (SMT) that permits multiple execution flows to run simultaneously on a single core.

* **NUMA**. Multi-processor servers are arranged in nodes or cells. Each *NUMA node* holds a fraction of the overall system memory. In this configuration, a processor accesses memory and I/O ports local to its node faster than to the non-local ones.

* **Hugepages**. Systems with big physical memory use also a big number of virtual memory pages. This big number makes the use of virtual-to-physical translation caches inefficient. Hugepages reduces the number of virtual pages in the system and optimize the virtual memory subsystem.

In OpenNebula the virtual topology of a VM is defined by the number of sockets, cores, threads and NUMA nodes.

Configuring the Hosts
================================================================================

When running VMs with a specific topology it is important to map (*pin*) it as close as possible to the that on the hypervisor, so vCPUs and memory are allocated to the same NUMA node. However, by default a VM is assigned to all the resources in the system making incompatible running pinned and no-pinned workloads in the same host.

First you need to define which hosts are going to be used to run pinned workloads, and define the ``PIN_POLICY`` tag. A Host can operate in two modes:

* ``NONE``. Standard mode where no NUMA or HW characteristics are considered. Resources are assigned and balanced by an external component, e.g. numad or kernel.

* ``PINNED``. VMs are allocated and pinned to specific nodes according to different policies.

.. note:: You can also create cluster including all the Host devoted to run pinned workloads, and set the ``PIN_POLICY`` at the cluster level.

The host monitoring probes should also return the NUMA topology and usage status of the hypervisors. The following command shows a single node hypervisor with 4 cores and 2 threads running a 4 vCPU VM with 2M hugepages:

.. code::

   $ onehost show 0
   ...
   MONITORING INFORMATION
   PIN_POLICY="PINNED"
   ...
   TOPOLOGY

   NUMA_NODES  CORES  SOCKETS  THREADS
	    2      2        1        2

   NUMA NODES

     ID CORES                                              USED FREE
      0 XX XX -- --                                        4    4

   NUMA MEMORY

    NODE_ID TOTAL    USED_REAL            USED_ALLOCATED       FREE
	  0 7.6G     6.8G                 1024M                845.1M

   NUMA HUGEPAGES

    NODE_ID SIZE     TOTAL    FREE     USED
	  0 2K       768      1024     512
	  0 1024K    0        0        0

In this output (``XX XX -- --``) each group represents a core, when a thread is free is shown as ``-``, ``x`` means a thread is used and ``X`` means that the core has no free threads.

Defining a Virtual Topology
================================================================================

By default VMs will take a number of sockets equal to the ``VCPU`` attribute with 1 core and 1 thread. The topology of the VM can be fine tuned with the ``TOPOLOGY`` attribute as follows:

+--------------------+---------------------------------------------------------------------+
+ TOPOLOGY attribute | Meaning                                                             |
+====================+=====================================================================+
| PIN_POLICY         | Defines how the VCPUS are pinned:                                   |
|                    |                                                                     |
|                    | * ``CORE``: Each VCPU uses a whole core.                            |
|                    | * ``THREAD``: Each VCPU is pinned to a host thread.                 |
|                    | * ``SHARED``: VCPUs can float across the assigned threads.          |
|                    | * ``NONE``: No pinning is made                                      |
+--------------------+---------------------------------------------------------------------+
| NUMA_NODES         | Number of virtual NUMA nodes. Memory and VCPUs are distributed      |
|                    | across the nodes.                                                   |
+--------------------+---------------------------------------------------------------------+
| SOCKETS            | Number of sockets.                                                  |
+--------------------+---------------------------------------------------------------------+
| CORES              | Number of cores.                                                    |
+--------------------+---------------------------------------------------------------------+
| THREADS            | Number of threads.                                                  |
+--------------------+---------------------------------------------------------------------+
| HUGEPAGE_SIZE      | Size of the hugepages (MB). If not defined no hugepages will be used|
+--------------------+---------------------------------------------------------------------+
| MEMORY_MAPPING     | Control if the memory is to be mapped ``shared`` or ``private``     |
+--------------------+---------------------------------------------------------------------+

The pinning policy defines how the VCPU are pinned to the hypervisor CPUs. When using the ``CORE`` policy each VCPU will be assigned to a whole core. No other threads in that core will be used. The ``THREAD`` policy assigns each VCPU to a hypervisor CPU thread. Finally, you can share all the assigned hypervisor threads between the VM VCPUS with the ``SHARED`` policy.

For example, to define a VM with two NUMA nodes, with 2G of memory and 4 VCPUS each using a ``THREAD`` policy add to the VM Template:

.. code::

   MEMORY = 4096
   CPU  = 8
   VCPU = 8
   TOPOLOGY = [ PIN_POLICY = 'THREAD', NUM_NODES = 2 ]

.. important:: When using a pinning policy the CPU capacity is set to the number of VCPU automatically if they differ

When the VM is created a ``NUMA_NODE`` stanza is set for each node. For the previous example the following will be generated:

.. code::

   NUMA_NODE = [ MEMORY = 2048, TOTAL_CPUS = 4 ]
   NUMA_NODE = [ MEMORY = 2048, TOTAL_CPUS = 4 ]

The ``NUMA_NODE`` attribute can be used to define asymmetric configurations, for example:

.. code::

   MEMORY = 3072
   VCPU = 6
   CPU  = 6
   TOPOLOGY = [ NUM_NODES = 2, PIN_POLICY = 'CORE' ]
   NUMA_NODE = [ MEMORY = 1024, TOTAL_CPUS = 4 ]
   NUMA_NODE = [ MEMORY = 2048, TOTAL_CPUS = 4 ]

For any configuration, you can set the number of sockets, cores and threads, but it should match the total number of VCPUS, i.e. ``VCPU = SOCKETS * CORES * THREAD``. Considering a target VCPU number, there is no significant difference ``CORES`` or ``SOCKETS`` performance-wise, although some software products may require an specific setup.

It is recommended to let the scheduler pick the number of ``THREADS`` of the virtual topology so it can be adjusted to the selected host. OpenNebula will select the threads per core according to:

* Prefer as close as possible to hardware configuration, power of 2.
* The threads/core will not exceed that of the hypervisor.
* Prefer the configuration with the highest number of threads/core that fits in the host.

Using Hugepages
================================================================================

To enable the use of hugepages for the memory allocation of the VM just add the desired page size in the ``TOPOLOGY`` attribute, the size must be expressed in megabytes. For example to use 2M hugepages use:

.. code::

	TOPOLOGY = [ PIN_POLICY = "share", HUGEPAGE_SIZE = "2" ]

Additionally you can define how the memory is mapped with the ``MEMORY_MAPPING``.

OpenNebula will look for a host with enough free pages of the requested size.

Considerations and Limitations
================================================================================
* VM Migration
* Asymmetric configurations
