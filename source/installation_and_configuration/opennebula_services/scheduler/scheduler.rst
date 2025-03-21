.. _scheduler_main:

=====================
Scheduling Framework
=====================

The OpenNebula Scheduling Framework for virtual machine allocation and cluster optimization is designed to:

- **Perform initial placement** of VMs by enforcing capacity control, resource compatibility, affinity groups, and specific placement requirements.
- **Enable cluster-wide load balancing** by dynamically generating placement plans that evenly distribute workloads across available hypervisor nodes.
- **Support user-driven optimization** by allowing administrators to modify or review optimization plans, as well as define custom policies and parameters for workload management.


Initial Placement
=================

When a VM is instantiated, OpenNebula finds the most suitable host for deployment based on resource availability and specific requirements. By default, the :ref:`scheduler_rank` is used. This scheduler uses a match-making algorithm that filters and ranks hosts to ensure optimal placement:

- **Filtering Hosts**: Hosts that do not meet the VM's resource requirements (CPU, memory) or do not satisfy other constraints are excluded.
- **Ranking Hosts**: The remaining hosts are ranked based on predefined policies or custom expressions, such as minimizing the number of running VMs.

Alternatively, the :ref:`OpenNebula Distributed Resource Scheduler <scheduler_drs_placement>` (DRS) can be used for initial placement. DRS considers the current resource utilization and workload distribution across the cluster to make informed placement decisions.

Cluster Workload Optimization
=============================

Beyond initial placement, OpenNebula supports ongoing cluster workload optimization to maintain balanced resource utilization and improve overall cluster performance. The :ref:`scheduler_drs` is the exclusive scheduler for cluster optimization in OpenNebula. It provides:

- **Migration suggestions**: These suggestions can be applied automatically or be reviewed and executed manually by administrators.
- **Customizable balancing metrics**: Assign weights to key resources like CPU, memory, disk, and network, to customize the optimization process.
- **Predictive Optimization**: Combines current usage metrics with predicted metrics to adjust the placements.


Architecture
============

The diagram below illustrates the architecture of the OpenNebula Scheduling Framework, highlighting the main components involved in VM allocation and cluster optimization.

|scheduler_architecture|

There are three main components related to **OpenNebula virtual machine allocation**:

1. :ref:`scheduler_manager`
2. :ref:`scheduler_plan_manager` (internal component)
3. Schedulers (:ref:`scheduler_rank` and :ref:`scheduler_drs`)

OpenNebula has two schedulers that allocate virtual machines on available hypervisor nodes:

* :ref:`Rank Scheduler <scheduler_rank>`, which is used for the initial placement of pending virtual machines, as the default option
* :ref:`Distributed Resource Scheduler <scheduler_drs>`, which can be used for:

  * Initial placement of pending virtual machines
  * Cluster-wise workload optimization, as the default option

.. |scheduler_architecture| image:: /images/scheduler_architecture.png
