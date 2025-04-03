.. _scheduler_rank:

================================================================================
Rank Scheduler
================================================================================

The OpenNebula Rank Scheduler is responsible for **allocating pending Virtual Machines to available hypervisor Nodes**. It's a dedicated daemon installed alongside the OpenNebula Daemon (``oned``), but can be deployed independently on a different machine. The Scheduler is distributed as part of the operating system package ``opennebula`` with the system service ``opennebula-scheduler``.

.. _scheduler_rank_matchmaking:

Overview
================================================================================

The Rank Scheduler implements a **match-making** algorithm for VM allocation. The goal of this policy is to prioritize the resources that are more suitable for the VM.

The match-making algorithm works as follows:

* Each disk of a running VM uses storage from an Image Datastore. VMs that require more storage than is currently available are filtered out, and will remain in the ``pending`` state.
* Hosts that do not meet VM requirements (see the :ref:`SCHED_REQUIREMENTS attribute <template_placement_section>`) or do not have enough resources (available CPU and memory) to run the VM are filtered out (see below for more information).
* The same happens for System Datastores: those that do not meet the DS requirements (see the :ref:`SCHED_DS_REQUIREMENTS attribute <template>`) or do not have enough free storage are filtered out.
* Finally, if the VM uses automatic network selection, the Virtual Networks that do not meet the NIC requirements (see the :ref:`SCHED_REQUIREMENTS attribute for NICs <template>`) or do not have enough free leases are filtered out.
* The :ref:`SCHED_RANK and SCHED_DS_RANK expressions <template_placement_section>` are evaluated upon the Host and Datastore list using the information gathered by the monitor drivers. Also, the :ref:`NIC/SCHED_RANK expressions <template_network_section>` are evaluated upon the Network list using the information in the Virtual Network template. Any variable reported by the monitor driver (or manually set in the Host, Datastore, or Network template) can be included in the rank expressions.
* Resources with a higher rank are used first to allocate VMs.

The Scheduling algorithm allows us to easily implement several placement heuristics (see below) depending on the selected ``RANK`` expressions.

You can define the policy to place a VM in one of two places:

* Globally, for all VMs: in the configuration file ``/etc/one/schedulers/rank.conf`` for the scheduler.
* For each VM: as defined by the general ``SCHED_RANK`` and ``SCHED_DS_RANK``, and the NIC-specific ``SCHED_RANK`` in the VM template.

.. _scheduler_rank_configuration:

Configuration
================================================================================

The Scheduler configuration file is ``/etc/one/schedulers/rank.conf`` on the Front-end, and can be customized with the parameters listed in the table below.

* ``MAX_HOST``: Maximum number of Virtual Machines dispatched to a given host in each scheduling action (Default: 1)
* ``MEMORY_SYSTEM_DS_SCALE``: This factor scales the VM’s usage of the system DS according to memory size. This factor can be used to make the scheduler consider the overhead caused by checkpoint files (*system_ds_usage = system_ds_usage + memory_system_ds_scale * memory*).
* ``DIFFERENT_VNETS``: When set (``YES``) the NICs of a VM will be assigned to different Virtual Networks.

The default scheduling policies for hosts, datastores and virtual networks are defined as follows:

* ``DEFAULT_SCHED``: Definition of the default scheduling algorithm.

   * ``RANK``: Arithmetic expression to rank suitable *hosts* based on their attributes.
   * ``POLICY``: A predefined policy, can be set to:

+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
| Policy |                                                 Description                                                                                |
+========+============================================================================================================================================+
|      0 | :ref:`Packing <sched_conf_packing>`: Minimize the number of hosts in use by packing the VMs in the hosts to reduce VM fragmentation        |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      1 | :ref:`Striping <sched_conf_striping>`: Maximize resources available for the VMs by spreading the VMs in the hosts                          |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      2 | :ref:`Load-aware <sched_conf_load>`: Maximize resources available for the VMs by using those nodes with less load                          |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      3 | **Custom**: Use a custom ``RANK``, see :ref:`Rank Expression Syntax <template_rank>`. Example: ``RANK="- (RUNNING_VMS * 50  + FREE_CPU)"`` |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      4 | :ref:`Fixed <sched_conf_fixed>`: Hosts will be ranked according to the PRIORITY attribute found in the Host or Cluster template            |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+

* ``DEFAULT_DS_SCHED``: Definition of the default storage scheduling algorithm. **IMPORTANT:** storage policies work only for shared datastores.

  * ``RANK``: Arithmetic expression to rank suitable **datastores** based on their attributes.
  * ``POLICY``: A predefined policy, can be set to:

+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
| Policy |                                               Description                                                                                  |
+========+============================================================================================================================================+
|      0 | :ref:`Packing <sched_conf_ds_packing>`: Tries to optimize storage usage by selecting the DS with less free space                           |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      1 | :ref:`Striping <sched_conf_ds_striping>`: Tries to optimize I/O by distributing the VMs across datastores                                  |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      2 | **Custom**: Use a custom RANK, see :ref:`Rank Expression Syntax <template_rank>`                                                           |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      3 | :ref:`Fixed <sched_conf_ds_fixed>`: Datastores will be ranked according to the PRIORITY attribute found in the Datastore template          |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+

* ``DEFAULT_NIC_SCHED``: Definition of the default virtual network scheduling algorithm.

  * ``RANK``: Arithmetic expression to rank suitable **networks** based on their attributes.
  * ``POLICY``: A predefined policy, can be set to:

+--------+----------------------------------------------------------------------------------------------------------+
| Policy |                                               Description                                                |
+========+==========================================================================================================+
|      0 | **Packing**:: Tries to pack address usage by selecting the virtual networks with less free leases        |
+--------+----------------------------------------------------------------------------------------------------------+
|      1 | **Striping**: Tries to distribute address usage across virtual networks                                  |
+--------+----------------------------------------------------------------------------------------------------------+
|      2 | **Custom**: Use a custom RANK                                                                            |
+--------+----------------------------------------------------------------------------------------------------------+
|      3 | **Fixed**: Networks will be ranked according to the PRIORITY attribute found in the Network template     |
+--------+----------------------------------------------------------------------------------------------------------+

* ``EXTERNAL_SCHEDULER``: Configuration to contact an external scheduler module:

   * ``SERVER``, the http URL to perform the POST operation
   * ``PROXY``, if needed to contact the external scheduler
   * ``TIMEOUT``, how long to wait for a response

* ``VM_ATTRIBUTE``: Attributes serialized to External Scheduler. The format is ``XPATH:<NAME>`` where:

    * ``XPATH`` is the xpath of the attribute
    * ``NAME`` (optional) is the name of the attribute used in the JSON doc sent to the external scheduler (if not set, the original name will be used).
    * Examples:

        - ``VM_ATTRIBUTE = "/VM/TEMPLATE/CPU"``
        - ``VM_ATTRIBUTE = "//CPU"``
        - ``VM_ATTRIBUTE = "/VM/TEMPLATE/VMGROUP/ROLE:GROUP_ROLE"``

* ``LOG``: Configuration for the logging system.

  * ``SYSTEM``: Defines the logging system. Use ``file`` to log to the ``sched.log`` file, ``syslog`` to use syslog, ``std`` to use the default log stream (stderr).
  * ``DEBUG_LEVEL``: Logging level. Use ``0`` for ERROR, ``1`` for WARNING, ``2`` for INFO, ``3`` for DEBUG, ``4`` for DDEBUG, ``5`` for DDDEBUG.

The optimal values of the scheduler parameters depend on the hypervisor, storage subsystem, and a number of physical hosts. The values can be derived by finding out the max. number of VMs that can be started in your setup without getting hypervisor-related errors.

User Policies
--------------------------------------------------------------------------------
VMs are dispatched to hosts in a FIFO fashion. You can alter this behavior by giving each VM (or the base template) a priority. Just set the attribute ``USER_PRIORITY`` to sort the VMs based on this attribute and so alter the dispatch order. For example, the ``USER_PRIORITY`` can be set in the VM templates for a specific user group if you want to prioritize the templates in that group. Note that this priority is also used for rescheduling.


Pre-defined Placement Policies
================================================================================

The following list describes the predefined policies for ``DEFAULT_SCHED`` configuration parameter:

.. _sched_conf_packing:

Packing Policy
--------------------------------------------------------------------------------

* **Target**: Minimize the number of cluster nodes in use
* **Heuristic**: Pack the VMs in the cluster nodes to reduce VM fragmentation
* **Implementation**: Use those nodes with more VMs running first

.. code::

    RANK = RUNNING_VMS

.. _sched_conf_striping:

Striping Policy
--------------------------------------------------------------------------------

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Spread the VMs in the cluster nodes
* **Implementation**: Use those nodes with less VMs running first

.. code::

    RANK = "- RUNNING_VMS"

.. _sched_conf_load:

Load-aware Policy
--------------------------------------------------------------------------------

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Use those nodes with less load
* **Implementation**: Use those nodes with more FREE_CPU first

.. code::

    RANK = FREE_CPU

.. _sched_conf_fixed:

Fixed Policy
--------------------------------------------------------------------------------

* **Target**: Sort the hosts manually
* **Heuristic**: Use the ``PRIORITY`` attribute
* **Implementation**: Use those nodes with more ``PRIORITY`` first

.. code::

    RANK = PRIORITY

Pre-defined Storage Policies
--------------------------------------------------------------------------------

The following list describes the predefined storage policies for ``DEFAULT_DS_SCHED`` configuration parameter:

.. _sched_conf_ds_packing:

Packing Policy
--------------------------------------------------------------------------------

Tries to optimize storage usage by selecting the DS with less free space

* **Target**: Minimize the number of system datastores in use
* **Heuristic**: Pack the VMs in the system datastores to reduce VM fragmentation
* **Implementation**: Use those datastores with less free space first

.. code::

    RANK = "- FREE_MB"

.. _sched_conf_ds_striping:

Striping Policy
--------------------------------------------------------------------------------

* **Target**: Maximize the I/O available to VMs
* **Heuristic**: Spread the VMs in the system datastores
* **Implementation**: Use those datastores with more free space first

.. code::

    RANK = "FREE_MB"

.. _sched_conf_ds_fixed:

Fixed Policy
--------------------------------------------------------------------------------

* **Target**: Sort the datastores manually
* **Heuristic**: Use the ``PRIORITY`` attribute
* **Implementation**: Use those datastores with more ``PRIORITY`` first

.. code::

    RANK = PRIORITY

Logging
================================================================================

The Rank Scheduler **logs** are located in ``/var/log/one/rank_sched.log``. This file is truncated on each scheduler invocation.

