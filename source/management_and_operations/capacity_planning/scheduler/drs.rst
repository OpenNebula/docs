.. _scheduler_drs:

================================================================================
OpenNebula Distributed Resource Scheduler (DRS)
================================================================================

The **OpenNebula Distributed Resource Scheduler (DRS)** optimizes resource allocation and prevents resource contention within a single OpenNebula :ref:`cluster <cluster_guide>`. It integrates with OpenNebula’s built-in monitoring and forecasting systems, considering real-time Virtual Machine (VM) and Host usage metrics, as well as predictions of future resource consumption.

OpenNebula DRS offers flexible automation levels, allowing recommendations to be generated and applied either automatically or manually. Administrators can review and execute migration suggestions through the OpenNebula Sunstone GUI.

Overview
================================================================================

OpenNebula DRS employs an integer linear programming (ILP) solver to optimize cluster workload distribution. Key features include:

- **Cluster Load Balancing**: Distributes VM workloads across hosts to balance resource usage, reducing contention and improving performance.
- **Predictive DRS**: Uses forecasted resource utilization to provide proactive migration recommendations.
- **Migration Recommendations**: Generates migration suggestions, allowing administrators to manually approve or automate actions.

Configuration and Usage
================================================================================

To enable OneDRS, navigate to the **Cluster Tab** in Sunstone and enable OneDRS, or alternatively set the ``ONE_DRS`` configuration attribute in the Cluster template. The configuration of OneDRS for the cluster requires setting the following options:

- **Policies**: Defines how workloads are distributed across hosts.
- **Usage Metrics and Predictions**: Specifies which resource metrics (CPU, Memory, Network, Disk) to consider for balancing.
- **Migration Threshold**: Limits the number of migrations generated in an optimization cycle.

Policy Configuration
--------------------------------------------------------------------------------

OpenNebula DRS migrates VMs according to the defined policy:

- **Packing**: Minimizes the number of active hosts to save energy or prepare for maintenance.
- **Load Balancing**: Distributes VMs across available hosts to prevent resource contention.

Load Balancing Objectives
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The load balancing goal can combine multiple performance indicators:

- **CPU Usage**: Load distribution based on actual CPU utilization of the VM.
- **CPU Capacity**: Allocation based on requested CPU (the VM template attribute).
- **Memory Usage**: Balancing based on requested memory.
- **Disk I/O**: Consideration of read/write operations.
- **Network Traffic**: Optimization based on network throughput.

For example, you can balance CPU and disk usage equally, setting CPU and disk associated weights to 50% each.

Predictive DRS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OneDRS allows balancing based on monitored or predicted values. A **prediction weight** between `0` and `1` determines the influence of forecasts:

- `0`: Only monitored values are used.
- `1`: Only forecasted values are used.
- Between `0` and `1` a linear combination of both is used.

By default, DRS uses only monitored values.

Migration Threshold Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Since migrations add overhead, administrators can set a **migration threshold** to limit the number of migrations per optimization cycle. You need to balance this setting: an aggressive threshold may negatively impact performance, while a conservative approach could overlook opportunities for improving the performance of the cluster.

By default, the number of migrations is not limited, that is the migration threshold is `-1`.

Automation Levels
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Administrators can choose different automation levels:

- **Manual**: Recommendations are displayed, but migrations must be manually approved.
- **Partial**: Migrations are periodically generated and require approval before execution.
- **Fulld**: Migrations are generated and applied automatically based on recommendations.

Initial Placement
================================================================================

OneDRS can also handle the **initial placement** of pending VMs, selecting the most suitable hosts. Unlike the default Rank Scheduler, which considers one VM at a time, OneDRS evaluates all pending VMs together for optimal placement.

Initial placement is configured in ``/etc/one/oned.conf`` by modifying the ``SCHED_MAD`` section:

.. code-block:: ini

    SCHED_MAD = [
      EXECUTABLE = "one_sched",
      ARGUMENTS  = "-t 15 -p one_drs -o one_drs"
    ]

When using OneDRS for placement, the following differences from workload optimization apply:

- Only **CPU** and **Memory** balancing is available. There are no monitoring data for pending VMs.
- Predictive DRS is **not applicable** (forecasts are unavailable for pending VMs).
- Migration threshold settings **do not apply**.

OneDRS Configuration File
================================================================================

The main DRS configuration file is ``/etc/one/schedulers/one_drs.conf``. This file defines default behavior, which can be overridden per cluster.The following options can be defined:

- ``DEFAULT_SCHED``: Defines the ILP solver used.
- ``PLACE``: Configures initial VM placement policies.
- ``OPTIMIZE``: Defines workload optimization settings.
- ``PREDICTIVE``: Weight of forecasted resource usage.
- ``MEMORY_SYSTEM_DS_SCALE``: Adjusts for system datastore overhead.
- ``DIFFERENT_VNETS``: Ensures NICs are assigned to different virtual networks.

Solver Configuration
--------------------------------------------------------------------------------

OneDRS uses the **PuLP** library for ILP solvers, supporting:

- **CBC Solver** (default)
- **GLPK**
- **Gurobi** (commercial option with better performance)

Configuration:

- ``SOLVER``: Defines the solver (e.g., ``CBC``, ``GLPK``, ``Gurobi``).
- ``SOLVER_PATH``: Specifies the path to the solver binary.

Scheduling Policies
--------------------------------------------------------------------------------

Scheduling policies define optimization objectives:

- ``PACK``: Consolidates VMs on fewer hosts to minimize active hardware.
- ``BALANCE``: Distributes VMs across hosts to reduce resource contention.

Example:

.. code-block:: yaml

    OPTIMIZE:
      POLICY: "BALANCE"
      WEIGHTS:
        CPU_USAGE: 1.0

Multi-metric placement example (CPU 60%, Memory 40%):

.. code-block:: yaml

    PLACE:
      POLICY: "BALANCE"
      WEIGHTS:
        CPU: 0.6
        MEMORY: 0.4

``MIGRATION_THRESHOLD`` limits the number of migrations per cycle.

The following shows a complete configuration file for the OneDRS scheduler:

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

