.. _schg:

================================================================================
Scheduler Configuration
================================================================================

The Scheduler is in charge of the assignment between pending Virtual Machines and known Hosts. OpenNebula's architecture defines this module as a separate process that can be started independently of ``oned`` (it is however started automatically when you start the ``opennebula`` service).

.. _schg_the_match_making_scheduler:

Match-making
================================================================================

OpenNebula comes with a **match making** scheduler (``mm_sched``) that implements the **Rank Scheduling Policy**. The goal of this policy is to prioritize those resources more suitable for the VM.

The match-making algorithm works as follows:

* Each disk of a running VM consumes storage from an Image Datastore. The VMs that require more storage than there is currently available are filtered out, and will remain in the ``pending`` state.
* Those hosts that do not meet the VM requirements (see the :ref:`SCHED_REQUIREMENTS attribute <template_placement_section>`) or do not have enough resources (available CPU and memory) to run the VM are filtered out (see below for more information).
* The same happens for System Datastores: the ones that do not meet the DS requirements (see the :ref:`SCHED_DS_REQUIREMENTS attribute <template>`) or do not have enough free storage are filtered out.
* Finally if the VM uses automatic network selection, the virtual networks that do not meet the NIC requirements (see the :ref:`SCHED_REQUIREMENTS attribute for NICs <template>`) or do not have enough free leases are filtered out.
* The :ref:`SCHED_RANK and SCHED_DS_RANK expressions <template_placement_section>` are evaluated upon the Host and Datastore list using the information gathered by the monitor drivers. Also the :ref:`NIC/SCHED_RANK expression <template_network_section>` are evaluated upon the Network list using the information in the Virtual Network template. Any variable reported by the monitor driver (or manually set in the Host, Datastore or Network template) can be included in the rank expressions.
* Those resources with a higher rank are used first to allocate VMs.

This scheduler algorithm easily allows the implementation of several placement heuristics (see below) depending on the RANK expressions used.

Configuring the Scheduling Policies
-----------------------------------

The policy used to place a VM can be configured in two places:

* For each VM, as defined by the ``SCHED_RANK`` and ``SCHED_DS_RANK`` attributes in the VM template. And ``SCHED_RANK`` in each VM NIC.
* Globally for all the VMs in the ``sched.conf`` file (OpenNebula restart required).

.. _schg_re-scheduling_virtual_machines:

Re-Scheduling Virtual Machines
------------------------------

When a VM is in the running or poweroff state it can be rescheduled. By issuing the ``onevm resched`` command the VM's recheduling flag is set. In a subsequent scheduling interval, the VM will be consider for rescheduling, if:

* There is a suitable host for the VM.
* The VM is not already running in it.

This feature can be used by other components to trigger rescheduling action when certain conditions are met.

Scheduling VM Actions
---------------------

Users can schedule one or more VM actions to be executed at a certain date and time. The :ref:`onevm schedule <cli>` command will add a new SCHED_ACTION attribute to the Virtual Machine editable template. Visit :ref:`the VM guide <vm_guide2_scheduling_actions>` for more information.

.. _schg_configuration:

Configuration
=============

The behavior of the scheduler can be tuned to adapt it to your infrastructure with the following configuration parameters defined in /etc/one/sched.conf:

* ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses.
* ``ONE_XMLRPC``: URL to connect to the OpenNebula daemon (oned) (Default: http://localhost:2633/RPC2)
* ``HTTP_PROXY``: Proxy for ONE_XMLRPC (Default empty)
* ``SCHED_INTERVAL``: Seconds between two scheduling actions (Default: 15)
* ``MAX_VM``: Maximum number of Virtual Machines scheduled in each scheduling action (Default: 5000). Use 0 to schedule all pending VMs each time.
* ``MAX_DISPATCH``: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action (Default: 30)
* ``MAX_HOST``: Maximum number of Virtual Machines dispatched to a given host in each scheduling action (Default: 1)
* ``LIVE_RESCHEDS``: Perform live (1) or cold migrations (0) when rescheduling a VM
* ``COLD_MIGRATION_MODE``: In case of cold migration, defines the type of VM migration. Possible values are 0 save, 1 poweroff, 2 poweroff hard. :ref:`See one.vm.migrate <one_vm_migrate>`
* ``MEMORY_SYSTEM_DS_SCALE``: This factor scales the VM usage of the system DS with the memory size. This factor can be use to make the scheduler consider the overhead of checkpoint files: system_ds_usage = system_ds_usage + memory_system_ds_scale * memory
* ``DIFFERENT_VNETS``: When set (YES) the NICs of a VM will be forced to be in different Virtual Networks.

The default scheduling policies for hosts, datastores and virtual networks are defined as follows:

* ``DEFAULT_SCHED``: Definition of the default scheduling algorithm.

   * ``RANK``: Arithmetic expression to rank suitable **hosts** based on their attributes.
   * ``POLICY``: A predefined policy, it can be set to:

+--------+-------------------------------------------------------------------------------------------------------------+
| POLICY |                                                 DESCRIPTION                                                 |
+========+=============================================================================================================+
|      0 | **Packing**: Minimize the number of hosts in use by packing the VMs in the hosts to reduce VM fragmentation |
+--------+-------------------------------------------------------------------------------------------------------------+
|      1 | **Striping**: Maximize resources available for the VMs by spreading the VMs in the hosts                    |
+--------+-------------------------------------------------------------------------------------------------------------+
|      2 | **Load-aware**: Maximize resources available for the VMs by using those nodes with less load                |
+--------+-------------------------------------------------------------------------------------------------------------+
|      3 | **Custom**: Use a custom RANK                                                                               |
+--------+-------------------------------------------------------------------------------------------------------------+
|      4 | **Fixed**: Hosts will be ranked according to the PRIORITY attribute found in the Host or Cluster template   |
+--------+-------------------------------------------------------------------------------------------------------------+

* ``DEFAULT_DS_SCHED``: Definition of the default storage scheduling algorithm.

  * ``RANK``: Arithmetic expression to rank suitable **datastores** based on their attributes.
  * ``POLICY``: A predefined policy, it can be set to:

+--------+----------------------------------------------------------------------------------------------------------+
| POLICY |                                               DESCRIPTION                                                |
+========+==========================================================================================================+
|      0 | **Packing**:: Tries to optimize storage usage by selecting the DS with less free space                   |
+--------+----------------------------------------------------------------------------------------------------------+
|      1 | **Striping**: Tries to optimize I/O by distributing the VMs across datastores                            |
+--------+----------------------------------------------------------------------------------------------------------+
|      2 | **Custom**: Use a custom RANK                                                                            |
+--------+----------------------------------------------------------------------------------------------------------+
|      3 | **Fixed**: Datastores will be ranked according to the PRIORITY attribute found in the Datastore template |
+--------+----------------------------------------------------------------------------------------------------------+

* ``DEFAULT_NIC_SCHED``: Definition of the default virtual network scheduling algorithm.

  * ``RANK``: Arithmetic expression to rank suitable **networks** based on their attributes.
  * ``POLICY``: A predefined policy, it can be set to:

+--------+----------------------------------------------------------------------------------------------------------+
| POLICY |                                               DESCRIPTION                                                |
+========+==========================================================================================================+
|      0 | **Packing**:: Tries to pack address usage by selecting the virtual networks with less free leases        |
+--------+----------------------------------------------------------------------------------------------------------+
|      1 | **Striping**: Tries to distribute address usage across virtual networks                                  |
+--------+----------------------------------------------------------------------------------------------------------+
|      2 | **Custom**: Use a custom RANK                                                                            |
+--------+----------------------------------------------------------------------------------------------------------+
|      3 | **Fixed**: Networks will be ranked according to the PRIORITY attribute found in the Network template     |
+--------+----------------------------------------------------------------------------------------------------------+

The optimal values of the scheduler parameters depend on the hypervisor, storage subsystem and number of physical hosts. The values can be derived by finding out the max number of VMs that can be started in your set up with out getting hypervisor related errors.

Sample Configuration:

.. code::

    MESSAGE_SIZE = 1073741824

    ONE_XMLRPC = "http://localhost:2633/RPC2"

    SCHED_INTERVAL = 30

    MAX_VM       = 5000
    MAX_DISPATCH = 30
    MAX_HOST     = 1

    LIVE_RESCHEDS  = 0

    DEFAULT_SCHED = [
       policy = 3,
       rank   = "- (RUNNING_VMS * 50  + FREE_CPU)"
    ]

    DEFAULT_DS_SCHED = [
       policy = 1
    ]

    DEFAULT_NIC_SCHED = [
       policy = 1
    ]

    MEMORY_SYSTEM_DS_SCALE = 0

    DIFFERENT_VNETS = YES


Pre-defined Placement Policies
------------------------------

The following list describes the predefined policies (``DEFAULT_SCHED``) that can be configured through the ``sched.conf`` file.

Packing Policy
~~~~~~~~~~~~~~

* **Target**: Minimize the number of cluster nodes in use
* **Heuristic**: Pack the VMs in the cluster nodes to reduce VM fragmentation
* **Implementation**: Use those nodes with more VMs running first

.. code::

    RANK = RUNNING_VMS

Striping Policy
~~~~~~~~~~~~~~~

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Spread the VMs in the cluster nodes
* **Implementation**: Use those nodes with less VMs running first

.. code::

    RANK = "- RUNNING_VMS"

Load-aware Policy
~~~~~~~~~~~~~~~~~

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Use those nodes with less load
* **Implementation**: Use those nodes with more FREE_CPU first

.. code::

    RANK = FREE_CPU

Fixed Policy
~~~~~~~~~~~~

* **Target**: Sort the hosts manually
* **Heuristic**: Use the PRIORITY attribute
* **Implementation**: Use those nodes with more PRIORITY first

.. code::

    RANK = PRIORITY

Pre-defined Storage Policies
----------------------------

The following list describes the predefined storage policies (``DEFAULT_DS_SCHED``) that can be configured through the ``sched.conf`` file.

Packing Policy
~~~~~~~~~~~~~~

Tries to optimize storage usage by selecting the DS with less free space

* **Target**: Minimize the number of system datastores in use
* **Heuristic**: Pack the VMs in the system datastores to reduce VM fragmentation
* **Implementation**: Use those datastores with less free space first

.. code::

    RANK = "- FREE_MB"

Striping Policy
~~~~~~~~~~~~~~~

* **Target**: Maximize the I/O available to VMs
* **Heuristic**: Spread the VMs in the system datastores
* **Implementation**: Use those datastores with more free space first

.. code::

    RANK = "FREE_MB"

Fixed Policy
~~~~~~~~~~~~

* **Target**: Sort the datastores manually
* **Heuristic**: Use the PRIORITY attribute
* **Implementation**: Use those datastores with more PRIORITY first

.. code::

    RANK = PRIORITY

.. _schg_limit:

VM Policies
-----------
VMs are dispatched to hosts in a FIFO fashion. You can alter this behavior by giving each VM (or the base template) a priority. Just set the attribute ``USER_PRIORITY`` to sort the VMs based on this attribute, and so alter the dispatch order. The ``USER_PRIORITY`` can be set for example in the VM templates for a user group if you want prioritize those templates. Note that this priority is also used for rescheduling.

Limiting the Resources Exposed by a Host
========================================

Prior to assigning a VM to a Host, the available capacity is checked to ensure that the VM fits in the host. The capacity is obtained by the monitor probes. You may alter this behavior by reserving an amount of capacity (MEMORY and CPU). You can reserve this capacity:

* Cluster-wise, by updating the cluster template (e.g. ``onecluster update``). All the host of the cluster will reserve the same amount of capacity.
* Host-wise, by updating the host template (e.g. ``onehost update``). This value will override those defined at cluster level.

In particular the following capacity attributes can be reserved:

* ``RESERVED_CPU`` in percentage. It will be subtracted from the ``TOTAL CPU``
* ``RESERVED_MEM`` in KB. It will be subtracted from the ``TOTAL MEM``

.. note:: These values can be negative, in that case you'll be actually increasing the overall capacity so overcommiting host capacity.
