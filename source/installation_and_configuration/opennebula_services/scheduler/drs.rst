.. _scheduler_drs:

==============================
Distributed Resource Scheduler
==============================

The **OpenNebula Distributed Resource Scheduler** (DRS) is responsible for:

* Initial placement of virtual machines according to the system requirements, including: capacity control, resource compatibility, and affinity groups
* Cluster-wise workload optimization, according to the balancing policies specified by the user

Scheduling Algorithm
====================

OpenNebula DRS uses the integer linear programming (ILP) optimizer.
Details about host filtering, storage, VNets, PCI devices, etc.

Configuration
=============

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

Solvers
=======

OpenNebula DRS uses the Python package PuLP to communicate with ILP solvers. It can use any `solver supported by PuLP <https://coin-or.github.io/pulp/technical/solvers.html>`_. Currently, DRS comes with `GLPK Solver <https://www.gnu.org/software/glpk/>`_, but a user can also install and apply `CBC Solver <https://coin-or.github.io/Cbc/>`_, or some commercial solver like `Gurobi Optimizer <https://www.gurobi.com/>`_.

Solver options are configured in the ``DEFAULT_SCHED`` section of the configuration file. The available settings are:

* ``SOLVER``: Name of the solver, e.g. ``"GLPK"``, ``"CBC"``, or ``"COINMP"``.
* ``SOLVER_PATH``: Path to the solver library.

Scheduling Policies
===================

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

Service Control and Logs
========================

systemctl … .

Predictive DRS
==============

Explain predictions.

Using Distributed Resource Scheduler from Sunstone
==================================================

Is this applicable already?

