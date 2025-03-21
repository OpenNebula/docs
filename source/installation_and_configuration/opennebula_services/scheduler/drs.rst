.. _scheduler_drs:

==============================
Distributed Resource Scheduler
==============================

The main aim of OpenNebula **OpenNebula Distributed Resource Scheduler** (DRS) is to optimize resource allocation and prevent resource contention within a single OpenNebula :ref:`cluster <cluster_guide>`. 
DRS is integrated with the OpenNebula Built-in Monitoring [ref here] and Forecasting system [ref here], allowing to take into account real-time Virtual Machine and Host usage metrics as well as predictions of future resource consumption. OpenNebula DRS operates in a recommendatiom mode, meaning migrations are suggested but not automatically applied. Users can manually review and execute migrations based on system recommendations using the OpenNebula Sunstone GUI.

Key Features
============

The key features of OpenNebula DRS are:

- **Cluster Load Balancing**: DRS operates optimizing the workload (i.e., allocation of Virtual Machines on Hosts) considering a single OpenNebula cluster.
- **Migration Recommendations**: Suggested VM migrations are displayed in Sunstone GUI to be approved by the user.
- **Customizable Balancing Metrics**: Users can define balancing strategies based on CPU, Memory, Network, and Disk usage and can assign weights to different metrics to fine-tune the load balancing and resource contention.
- **Scheduling Policies**: Users can specify a :ref:`scheduling policy <scheduler_drs_policies>` which either powers off some running hosts during the periods of low workload, or balances resource utilization across the host of a cluster.
- **Predictive DRS**: Users can integrate monitoring forecasts of resource utilization to provide proactive recommendations when load balancing Virtual Machines within a cluster.
- **Integration within Sunstone**: Users can easily enable DRS, select policies, and review migration recommendations via the Sunstone GUI.
- **CLI**: Users can use the CLI to perform load balancing operations on the clusters and apply recommendatiom [TO CHECK]

DRS Usage
=========

Step 1. Enable DRS on the Cluster
---------------------------------

To enable DRS, first go to the Cluster Tab in Sunstone and enable DRS as shown here:

[Image: Enabling DRS in Sunstone]

Step 2. Configure DRS
---------------------

The DRS can be configured considering different options:

- Policies
- Virtual Machine usage metrics and predictions
- Migration Threshold

Policy Configuration
~~~~~~~~~~~~~~~~~~~~

OpenNebula DRS supports workload optimization within a cluster. DRS migrates virtual machines across the hosts of a cluster according to the preferences of a user, i.e. user-defined :ref:`scheduling policy <scheduler_drs_policies>`. Available policies are:

* **Packing:** reducing the number of running physical servers when the workload requirements are low, which can contribute to energy savings.
* **Load balancing:** scattering virtual machines across the available hosts to reduce contention and interference, and improve the performance of hosts and virtual machines. 

To define the scheduling policy from Sunstone, ... .

[Image: Sunstone, scheduling policy]

**Load Balance Metrics Configuration**

A user can choose to perform load balancing according to different types of loads:

  * CPU usage of all virtual machines allocated to a host,
  * CPU required by all virtual machines allocated to a host,
  * Memory required by all virtual machines allocated to a host,
  * Disk usage of all virtual machines allocated to a host,
  * Network usage all virtual machines allocated to a host,
  * Combination of multiple metrics.

For example, when balancing CPU usage, DRS tends to reduce the load of the hosts with high CPU usage and move a part of the workload to the hosts with lower CPU usage. It is possible to balance load according to multiple metrics at once. For example, specifying that DRS should consider the CPU usage with 50% and the memory with 50%, takes into account both CPU and memory contention with equal weights.

By default, workload optimization will balance the CPU usage. [TODO: Check this!]

To define the metric weights from Sunstone, ... .

[IMAGE: Insert how to set weight for load balancing - CPU 50% and MEM 50%]

Predictive DRS Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DRS can perform load balancing either using measured values of the metrics like CPU or memory or with the predicted values of these metrics. It is also possible to combine measured and predicted values by specifying the prediction weight. When the weight is ``0``, only the measured values are used. When the weight is ``1``, only the forecasts are used. A weight value between ``0`` and ``1`` means that DRS uses a linear combination of the past and predicted value.

By default, DRS will use measured values for workload optimization. [TODO: Check this!]

To define the prediction weight in Sunstone, ... .

[Image: Sunstone, prediction weight set to 1.0]

Migration Threshold Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Workload optimization is realized by migrating virtual machines across the hosts of a cluster. However, the migrations contribute to CPU, memory, and network usage, as well as to the energy consumption. A user can specify the migration policy, that is migration threshold, and constrain the number of allowed migrations. An aggressive migration strategy could involve a large number of migrations and worsen the overall performance in some cases. A conservative approach might miss some good opportunities to improve the state of the system or result in late migrations.

By default, the number of migrations is not limited, that is the migration threshold is ``-1``.

To define the migration threshold from Sunstone, ... .

[Image: Sunstone, migration threshold set to ???]

Step 3. Optimize Cluster Workload using DRS
-------------------------------------------

After setting the scheduling options, a user can start optimizing the workload of a cluster from Sunstone, ... .

[Image: Triggering optimization.]

Step 4. Review DRS Recommendations
----------------------------------

Once the optimization is finished, a user can review the obtained migration recommendations with ... .

[Image Recommendations from DRS]

Step 5. Apply Migrations
------------------------

Finally, if satisfied with the recommended solution, a user can apply the migrations by clicking ... .

[Image: Apply migrations]

Advanced Configuration
=======================

The configuiration file of DRS that is available in the Front-End is ``/etc/one/schedulers/one_drs.conf``. This file defines the default behavior, which can be overridden by the user settings from Sunstone. Its options are:

* ``DEFAULT_SCHED``: Default ILP solver used for scheduling. See `Solver Configuration`_ for more details.
* ``PLACE``: Settings for the initial placement of virtual machines. See `Scheduling Policies`_ for more details.
* ``OPTIMIZE``: Settings for workload optimization. See `Scheduling Policies`_ for more details.
* ``PREDICTIVE``: Weight of forecasted resource usage in the scheduling process. For example, the value ``0.3`` means that the predicted resource usage is accounted with 30% and current usage with 70%. See [LINK HERE] for more details.
* ``MEMORY_SYSTEM_DS_SCALE``: Scaling factor for the system datastore usage by a virtual machine, according to the size of memory. It can be applied to force the scheduler to consider the overhead of checkpoint files.
* ``DIFFERENT_VNETS``: Whether all NICs of a virtual machine should be assigned to different virtual networks. The allowed options are ``YES`` and ``NO``.

This is an example of a configuration file:

.. code-block:: yaml

    DEFAULT_SCHED:
      SOLVER: "CBC"
      SOLVER_PATH: "/usr/lib/one/python/pulp/solverdir/cbc/linux/64/cbc"

    PLACE:
      POLICY: "PACK"

    OPTIMIZE:
      POLICY: "BALANCE"
      MIGRATION_THRESHOLD: 10
      WEIGHTS:
        CPU_USAGE: 0.2
        CPU: 0.2
        MEMORY: 0.4
        DISK: 0.1
        NET: 0.1

    PREDICTIVE: 0.3

    MEMORY_SYSTEM_DS_SCALE: 0

    DIFFERENT_VNETS: YES

Solver Configuration
--------------------

OpenNebula DRS uses the Python package PuLP to communicate with ILP solvers. It can use `the solvers supported by PuLP <https://coin-or.github.io/pulp/technical/solvers.html>`_. Currently, DRS uses `CBC Solver <https://coin-or.github.io/Cbc/>`_ by default, but it can also use `GLPK <https://www.gnu.org/software/glpk/>`_. Commercial solutions supported by PuLP, like `Gurobi Optimizer <https://www.gurobi.com/>`_, are also applicable. Commercial solvers might have significantly better performance, especially for larger problems, with a lot of virtual machines and hosts.

Solver options are configured in the ``DEFAULT_SCHED`` section of the configuration file. The available settings are:

* ``SOLVER``: Name of the solver, e.g. ``"CBC"``, ``"GLPK"``, or ``"COINMP"``.
* ``SOLVER_PATH``: Path to the solver library.

.. _scheduler_drs_policies:

Scheduling Policies
-------------------

Scheduling policies define the objective of the optimization process.

They are specified in the sections ``PLACE`` and ``OPTIMIZE``, with the attribute ``POLICY``. Currently supported policies are:

* ``"PACK"``: Packing policy that minimizes the number of running hosts, to reduce the fragmentation of virtual machines.
* ``"BALANCE"``: Load balancing policy that tends to spread virtual machines accross hosts. It minimizes the utilization of the host with the highest usage. DRS can consider several metrics when balancing the load using their relative weights with the attribute ``WEIGHTS`` and the options:

  * ``"CPU_USAGE"`` for the current or forecasted CPU usage of the hosts
  * ``"CPU"``: for the requested CPU ratio of the hosts
  * ``"MEMORY"``: for the requested memory amount of the hosts
  * ``"DISK"``: for the disk usage
  * ``"NET"``: for the network usage

For example, to balance the CPU usage of all the hosts in a cluster, one can specify the policy as:

.. code-block:: yaml

    OPTIMIZE:
      POLICY: "BALANCE"
      WEIGHTS:
        CPU_USAGE: 1.0

To balance the ratio of requested CPU and memory of all the hosts in a cluster simultaneously, the following setting can be used:

.. code-block:: yaml

    OPTIMIZE:
      POLICY: "BALANCE"
      WEIGHTS:
        CPU: 0.6
        MEMORY: 0.4

In the previous example, the CPU requirement is weighted with 60% and memory with 40%.

The option ``MIGRATION_THRESHOLD`` is used only for workload optimization and can be used to specify the maximal allowed number of virtual machine migrations.

DRS Scheduling Algorithm
------------------------

OpenNebula DRS uses integer linear programming (ILP) to determine the optimal or a nearly-optimal virtual machine placements according to the :ref:`scheduling policies <scheduler_drs_policies>` and the obeying the constraints related to:

* CPU availability
* Memory availability
* Local or shared storage availability
* PCI devices
* Virtual networks
* Affinity rules
* Allowed number of migrations

Initial Placement
=================

In addition to cluster-wise workload optimization, OpenNebula DRS can perform the **initial placement** of pending Virtual Machines to the most suitable Hosts.

This is an alternative to the default approach that uses :ref:`Rank Scheduler <scheduler_rank>`. The main advantage of DRS is the fact that it considers all pending Virtual Machines at once and tries to allocate all of them to the suitable Hosts in the best possible way. Contrary, Rank Scheduler considers one Virtual Machine at the time and the quality of the solution might depend on the order of allocation.

Rank Scheduler, as a fast and stable approach, might be more convenient when:

* Performing the initial placement of one or a small number of Virtual Machines. In such cases, the order of placement is less important.
* Working with a very high number of Virtual Machines, Hosts, PCI devices, affinity rules, an so on. In such cases, the DRS optimization problems might be to large for solving in an acceptable amount of time.

[TODO: Consider putting here more specific details related to the scalability issues]

A user can specify DRS as the default option for initial placement by ... .

[Image: Setting DRS for initial placement]

Alternatively, this behavior can be specified in the OpenNebula Daemon configuration file (``/etc/one/oned.conf``) by changing the section ``SCHED_MAD`` and its attribute ``ARGUMENTS`` to include the option ``"-p one_drs"``, for example:

.. code-block:: ini

    SCHED_MAD = [
      EXECUTABLE = "one_sched",
      ARGUMENTS  = "-t 15 -p one-drs -o one_drs"
    ]

For more information, see :ref:`Scheduler Manager <scheduler_manager>`.

Selecting the options for the initial placement with DRS is similar as for the workload optimization, with the following differences:

* Only ``CPU``, ``MEMORY``, and their combinations are acceptable for load balancing, because the usage is not known for pending Virtual Machines
* Using Predictive DRS is not allowed, because forecasts are not available for pending Virtual Machines
* Migrations are not allowed and consequently migration thresholds are not applicable.

By default, DRS uses the load-balancing policy with CPU only for the initial placement.

In the configuration file, the options for the initial placement are given in the section ``PLACE``. For example, load balancing with respect to CPU and memory, weighting both of the equally, might look like this:

.. code-block:: yaml

    PLACE:
      POLICY: "BALANCE"
      WEIGHTS:
        CPU: 0.5
        MEMORY: 0.5

The sections ``OPTIMIZE`` and ``PREDICTIVE`` [TODO: Check this] are not applicable for the initial placement and the other sections are common for both use cases.

