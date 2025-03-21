.. _scheduler_drs:

==============================
Distributed Resource Scheduler
==============================

The main aim of OpenNebula **OpenNebula Distributed Resource Scheduler** (DRS) is to optimize resource allocation and prevent resource contention within a OpenNebula :ref:`cluster <cluster_guide>`. 
DRS is integrated with the OpenNebula Built-in Monitoring [ref here] and Forecasting system [ref here], allowing to take into account real-time Virtual Machine and Host usage metrics as well as predictions of future resource consumption. OpenNebula DRS operates in a recommendatiom mode, meaning migrations are suggested but not automatically applied. Users can manually review and execute migrations based on system recommendations using the OpenNebula Sunstone GUI.

Key Features
==============================
- **Cluster Load Balancing**: DRS operates optimizing the workload (i.e., allocation of Virtual Machines on Hosts) considering a single OpenNebula cluster.
- **Migration Recommendations**: Suggested VM migrations are displayed in Sunstone GUI to be approved by the user.
- **Customizable Balancing Metrics**: Users can define balancing strategies based on CPU, Memory, Network, and Disk usage and can assign weights to different metrics to fine-tune the load balancing and resource contention.
- **Scheduling Policies**: packing and load balancing (TO IMPROVE)
- **Predictive DRS**: Users can integrate monitoring forecasts of resource utilization to provide proactive recommendations when load balancing Virtual Machines within a cluster
- **Integration within SUNSTONE** - Users can easily enable DRS, select policies, and review migration recommendations via the Sunstone GUI
- **CLI**: Users can use the CLI to perform load balancing operations on the clusters and apply recommendatiom [TO CHECK]

DRS Usage
==============================

**Step 1. Enable DRS on the Cluster**

To enable DRS, first go to the Cluster Tab in Sunstone and enable DRS as shown here

[Image: Enabling DRS in Sunstone]

**Step 2. Configure DRS**

The DRS can be configured considering different options:

- Policies
- Virtual Machine usage metrics and predictions
- Migration Threshold

**Policy Configuration**

OpenNebula DRS supports workload optimization within a . DRS migrates virtual machines across the hosts of a cluster according to the preferences of a user, i.e. user-defined :ref:`scheduling policy <scheduler_drs_policies>`. Available policies are:

* **Packing:** reducing the number of running physical servers when the workload requirements are low, which can contribute to energy savings.
* **Load balancing:** scattering virtual machines across the available hosts to reduce contention and interference, and improve the performance of hosts and virtual machines. 


To define the scheduling policy from Sunstone, ... .

[Image: Sunstone, scheduling policy]

**Load Balance Metrics Configuration**

A user can choose to perform balancing according to:

  * CPU usage of all virtual machines allocated to a host,
  * CPU required by all virtual machines allocated to a host,
  * Memory required by all virtual machines allocated to a host,
  * Disk usage of all virtual machines allocated to a host,
  * Network usage all virtual machines allocated to a host,
  * Combination of multiple metrics.

For example, when balancing CPU usage, DRS tends to reduce the load of the hosts with high CPU usage and move a part of the workload to the hosts with lower CPU usage. It is possible to balance load according to multiple metrics at once. For example, specifying that DRS should consider the CPU usage with 50% and the memory with 50%, takes into account both CPU and memory contention with equal weights.

[IMAGE: Insert how to set weight for load balancing - CPU 50% and MEM 50%]

**Predictive DRS Configuration**

DRS can perform load balancing either using measured values of the metrics like CPU or memory or with the predicted values of these metrics. It is also possible to combine measured and predicted values by specifying the prediction weight.

To define the prediction weight in Sunstone, ... .

[Image: Sunstone, prediction weight set to 1.0]

**Migration Threshold Configuration**

Workload optimization is realized by migrating virtual machines across the hosts of a cluster. However, the migrations contribute to CPU, memory, and network usage, as well as to the energy consumption. A user can specify the migration policy, that is migration threshold, and constrain the number of allowed migrations. An aggressive migration strategy could involve a large number of migrations and worsen the overall performance in some cases. A conservative approach might miss some good opportunities to improve the state of the system or result in late migrations.

To define the migration threshold from Sunstone, ... .

[Image: Sunstone, migration threshold set to ???]

**Step 3. Optimize Cluster Workload using DRS**
(description + image)

**Step 4. Review DRS recommendations**
(description + image)

**Step 5. Apply migrations**
(description + image)

Advanced Configuration
=======================

The Front-End configuration file of DRS is ``/etc/one/schedulers/one_drs.conf``. Its options are:

* ``DEFAULT_SCHED``: Default ILP solver used for scheduling. See `Solvers`_ for more details.
* ``PLACE``: Settings for the initial placement of virtual machines. See `Scheduling Policies`_ for more details.
* ``OPTIMIZE``: Settings for workload optimization. See `Scheduling Policies`_ for more details.
* ``PREDICTIVE``: Weight of forecasted resource usage in the scheduling process. For example, the value ``0.3`` means that the predicted resource usage is accounted with 30% and current usage with 70%. See `Predictive DRS`_ for more details.
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

Solvers Configuration
-----------------------

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
-----------------------

OpenNebula DRS uses integer linear programming (ILP) to determine the optimal or a nearly-optimal virtual machine placements according to the :ref:`scheduling policies <scheduler_drs_policies>` and the obeying the constraints related to:

* CPU availability
* Memory availability
* Local or shared storage availability
* PCI devices
* Virtual networks
* Affinity rules
* Allowed number of migrations

Initial Placement
==================
