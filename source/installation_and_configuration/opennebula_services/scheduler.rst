.. _schg:
.. _sched_configure:
.. _schg_configuration:

=======================
Scheduler Configuration
=======================

The OpenNebula Scheduler is responsible for **planning of the pending Virtual Machines on available hypervisor Nodes**. It's a dedicated daemon installed alongside the OpenNebula Daemon (``oned``), but can be deployed independently on a different machine. The Scheduler is distributed as an operating system package ``opennebula`` with system service ``opennebula-scheduler``.

.. _schg_the_match_making_scheduler:

Scheduling Algorithm
====================

OpenNebula comes with a **match-making** scheduler (``/usr/bin/mm_sched``) that implements the **Rank Scheduling Policy**. The goal of this policy is to prioritize those resources more suitable for the VM.

The match-making algorithm works as follows:

* Each disk of a running VM consumes storage from an Image Datastore. The VMs that require more storage than it is currently available are filtered out and will remain in the ``pending`` state.
* The hosts that do not meet the VM requirements (see the :ref:`SCHED_REQUIREMENTS attribute <template_placement_section>`) or do not have enough resources (available CPU and memory) to run the VM are filtered out (see below for more information).
* The same happens for System Datastores: the ones that do not meet the DS requirements (see the :ref:`SCHED_DS_REQUIREMENTS attribute <template>`) or do not have enough free storage are filtered out.
* Finally, if the VM uses automatic network selection, the Virtual Networks that do not meet the NIC requirements (see the :ref:`SCHED_REQUIREMENTS attribute for NICs <template>`) or do not have enough free leases are filtered out.
* The :ref:`SCHED_RANK and SCHED_DS_RANK expressions <template_placement_section>` are evaluated upon the Host and Datastore list using the information gathered by the monitor drivers. Also, the :ref:`NIC/SCHED_RANK expressions <template_network_section>` are evaluated upon the Network list using the information in the Virtual Network template. Any variable reported by the monitor driver (or manually set in the Host, Datastore, or Network template) can be included in the rank expressions.
* The resources with a higher rank are used first to allocate VMs.

Scheduling algorithm easily allows implementing several placement heuristics (see below) depending on the selected ``RANK`` expressions.

The policy used to place a VM can be configured in two places:

* Globally, for all the VMs in the configuration file ``/etc/one/sched.conf`` of Scheduler.
* For each VM, as defined by the general ``SCHED_RANK`` and ``SCHED_DS_RANK`` and NIC-specific ``SCHED_RANK`` in the VM template.

Configuration
=============

The Scheduler configuration file is in ``/etc/one/sched.conf`` on the Front-end and can be adapted to your needs with folowing parameters:

.. note::

    After a configuration change, the OpenNebula Scheduler must be :ref:`restarted <sched_configure_service>` to take effect.

* ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses (Default: ``1073741824``).
* ``TIMEOUT``: Seconds to timeout XML-RPC calls to oned (Default: ``60``).
* ``ONE_XMLRPC``: Endpoint of the OpenNebula XML-RPC API (Default: ``http://localhost:2633/RPC2``)
* ``HTTP_PROXY``: Proxy for ``ONE_XMLRPC`` (Default empty)
* ``SCHED_INTERVAL``: Seconds between two scheduling actions (Default: ``15``)
* ``MAX_VM``: Maximum number of VMs scheduled in each scheduling action (Default: ``5000``). Use ``0`` to schedule all pending VMs each time.
* ``MAX_DISPATCH``: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action (Default: 30)
* ``MAX_HOST``: Maximum number of Virtual Machines dispatched to a given host in each scheduling action (Default: 1)
* ``LIVE_RESCHEDS``: Rescheduling VMs performs migrations as ``1`` - live, ``0`` - cold.
* ``COLD_MIGRATION_MODE``: Defines mode of cold VM migration. Options ``0`` - save, ``1`` - poweroff, ``2`` - poweroff hard. See :ref:`one.vm.migrate <one_vm_migrate>`.
* ``MEMORY_SYSTEM_DS_SCALE``: This factor scales the VM usage of the system DS with the memory size. This factor can be use to make the scheduler consider the overhead of checkpoint files (*system_ds_usage = system_ds_usage + memory_system_ds_scale * memory*).
* ``DIFFERENT_VNETS``: When set (``YES``) the NICs of a VM will be forced to be in different Virtual Networks.

The default scheduling policies for hosts, datastores and virtual networks are defined as follows:

* ``DEFAULT_SCHED``: Definition of the default scheduling algorithm.

   * ``RANK``: Arithmetic expression to rank suitable **hosts** based on their attributes.
   * ``POLICY``: A predefined policy, it can be set to:

+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
| Policy |                                                 Description                                                                                |
+========+============================================================================================================================================+
|      0 | :ref:`Packing <sched_configure_packing>`: Minimize the number of hosts in use by packing the VMs in the hosts to reduce VM fragmentation   |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      1 | :ref:`Striping <sched_configure_striping>`: Maximize resources available for the VMs by spreading the VMs in the hosts                     |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      2 | :ref:`Load-aware <sched_configure_load>`: Maximize resources available for the VMs by using those nodes with less load                     |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      3 | **Custom**: Use a custom ``RANK``, see :ref:`Rank Expression Syntax <template_rank>`. Example: ``RANK="- (RUNNING_VMS * 50  + FREE_CPU)"`` |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      4 | :ref:`Fixed <sched_configure_fixed>`: Hosts will be ranked according to the PRIORITY attribute found in the Host or Cluster template       |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+

* ``DEFAULT_DS_SCHED``: Definition of the default storage scheduling algorithm.

  * ``RANK``: Arithmetic expression to rank suitable **datastores** based on their attributes.
  * ``POLICY``: A predefined policy, it can be set to:

+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
| Policy |                                               Description                                                                                  |
+========+============================================================================================================================================+
|      0 | :ref:`Packing <sched_configure_ds_packing>`: Tries to optimize storage usage by selecting the DS with less free space                      |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      1 | :ref:`Striping <sched_configure_ds_striping>`: Tries to optimize I/O by distributing the VMs across datastores                             |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      2 | **Custom**: Use a custom RANK, see :ref:`Rank Expression Syntax <template_rank>`                                                           |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+
|      3 | :ref:`Fixed <sched_configure_ds_fixed>`: Datastores will be ranked according to the PRIORITY attribute found in the Datastore template     |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------+

* ``DEFAULT_NIC_SCHED``: Definition of the default virtual network scheduling algorithm.

  * ``RANK``: Arithmetic expression to rank suitable **networks** based on their attributes.
  * ``POLICY``: A predefined policy, it can be set to:

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

* ``LOG``: Configuration for the logging system.

  * ``SYSTEM``: Defines logging system. Use ``file`` to log in the ``sched.log`` file, ``syslog`` to use syslog, ``std`` to use default log stream (stderr).
  * ``DEBUG_LEVEL``: Logging level. Use ``0`` for ERROR, ``1`` for WARNING, ``2`` for INFO, ``3`` for DEBUG, ``4`` for DDEBUG, ``5`` for DDDEBUG.

The optimal values of the scheduler parameters depend on the hypervisor, storage subsystem, and a number of physical hosts. The values can be derived by finding out the max. number of VMs that can be started in your setup without getting hypervisor-related errors.

.. _sched_configure_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula-scheduler``.

To start, restart, stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-scheduler
    # systemctl restart opennebula-scheduler
    # systemctl stop    opennebula-scheduler

.. note::

   Service is automatically started (unless masked) with the start of OpenNebula Daemon.

Server **logs** are located in ``/var/log/one`` in following file:

- ``/var/log/one/sched.log``

Other logs are also available in Journald, use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula-scheduler.service

Advanced Usage
==============

VM Policies
-----------
VMs are dispatched to hosts in a FIFO fashion. You can alter this behavior by giving each VM (or the base template) a priority. Just set the attribute ``USER_PRIORITY`` to sort the VMs based on this attribute, and so alter the dispatch order. The ``USER_PRIORITY`` can be set for example in the VM templates for a user group if you want to prioritize those templates. Note that this priority is also used for rescheduling.

.. _schg_re-scheduling_virtual_machines:

Reschedule VM
-------------

When a Virtual Machine is in the ``running`` or ``poweroff`` state, it can be rescheduled to a different host. By issuing the ``onevm resched`` command, the VM is labeled for rescheduling. In the next scheduling interval, the VM will be rescheduled to a different host, if:

* There is a suitable host for the VM.
* The VM is not already running in it.

This feature can be used by other components to trigger rescheduling action when certain conditions are met.

Scheduling VM Actions
---------------------

Users can schedule one or more VM actions to be executed at a certain date and time. The :ref:`onevm schedule <cli>` command will add a new ``SCHED_ACTION`` attribute to the Virtual Machine editable template. Visit the :ref:`VM guide <vm_guide2_scheduling_actions>` for more information.

.. _schg_limit:

Limit/Overprovision Host Capacity
---------------------------------

Prior to assigning a VM to a Host, the available capacity is checked to ensure that the VM fits in the host. The capacity is obtained by the monitor probes. You may alter this behavior by reserving an amount of capacity (``MEMORY`` and ``CPU``). You can reserve this capacity:

* **Cluster-wise**, by updating the cluster template (e.g. ``onecluster update``). All the hosts of the cluster will reserve the same amount of capacity.
* **Host-wise**, by updating the host template (e.g. ``onehost update``). This value will override those defined at the cluster level.

Following capacity attributes can be set:

* ``RESERVED_CPU`` in percentage. It will be subtracted from the ``TOTAL CPU``.
* ``RESERVED_MEM`` in KB. It will be subtracted from the ``TOTAL MEM``.

.. note::

    These values can be **negative to virtually increase the overall capacity** (to overcommit/overprovision CPU or memory).

Pre-defined Placement Policies
------------------------------

The following list describes the predefined policies for ``DEFAULT_SCHED`` configuration parameter:

.. _sched_configure_packing:

Packing Policy
~~~~~~~~~~~~~~

* **Target**: Minimize the number of cluster nodes in use
* **Heuristic**: Pack the VMs in the cluster nodes to reduce VM fragmentation
* **Implementation**: Use those nodes with more VMs running first

.. code::

    RANK = RUNNING_VMS

.. _sched_configure_striping:

Striping Policy
~~~~~~~~~~~~~~~

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Spread the VMs in the cluster nodes
* **Implementation**: Use those nodes with less VMs running first

.. code::

    RANK = "- RUNNING_VMS"

.. _sched_configure_load:

Load-aware Policy
~~~~~~~~~~~~~~~~~

* **Target**: Maximize the resources available to VMs in a node
* **Heuristic**: Use those nodes with less load
* **Implementation**: Use those nodes with more FREE_CPU first

.. code::

    RANK = FREE_CPU

.. _sched_configure_fixed:

Fixed Policy
~~~~~~~~~~~~

* **Target**: Sort the hosts manually
* **Heuristic**: Use the PRIORITY attribute
* **Implementation**: Use those nodes with more PRIORITY first

.. code::

    RANK = PRIORITY

Pre-defined Storage Policies
----------------------------

The following list describes the predefined storage policies for ``DEFAULT_DS_SCHED`` configuration parameter:

.. _sched_configure_ds_packing:

Packing Policy
~~~~~~~~~~~~~~

Tries to optimize storage usage by selecting the DS with less free space

* **Target**: Minimize the number of system datastores in use
* **Heuristic**: Pack the VMs in the system datastores to reduce VM fragmentation
* **Implementation**: Use those datastores with less free space first

.. code::

    RANK = "- FREE_MB"

.. _sched_configure_ds_striping:

Striping Policy
~~~~~~~~~~~~~~~

* **Target**: Maximize the I/O available to VMs
* **Heuristic**: Spread the VMs in the system datastores
* **Implementation**: Use those datastores with more free space first

.. code::

    RANK = "FREE_MB"

.. _sched_configure_ds_fixed:

Fixed Policy
~~~~~~~~~~~~

* **Target**: Sort the datastores manually
* **Heuristic**: Use the PRIORITY attribute
* **Implementation**: Use those datastores with more PRIORITY first

.. code::

    RANK = PRIORITY
