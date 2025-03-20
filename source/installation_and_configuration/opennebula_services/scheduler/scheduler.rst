.. _scheduler_main:

=======================
Scheduler Configuration
=======================

The OpenNebula scheduling framework for virtual machine allocation and cluster optimization is designed to:

- **Perform initial placement** of VMs by enforcing capacity control, resource compatibility, affinity groups, and specific placement requirements.
- **Enable cluster-wide load balancing** by dynamically generating placement plans that evenly distribute workloads across available hypervisor nodes.
- **Support user-driven optimization** by allowing administrators to modify or review optimization plans, as well as define custom policies and parameters for workload management.

There are three main components related to **OpenNebula virtual machine allocation**:

1. :ref:`scheduler_scheduler_manager`
2. :ref:`scheduler_plan_manager`
3. Schedulers (:ref:`scheduler_rank` and :ref:`scheduler_drs`)

OpenNebula has two schedulers that allocate virtual machines on available hypervisor nodes:

* :ref:`Rank Scheduler <scheduler_rank>`, which is used for the initial placement of pending virtual machines, as the default option
* :ref:`Distributed Resource Scheduler <scheduler_drs>`, which can be used for:

  * Initial placement of pending virtual machines
  * Cluster-wise workload optimization, as the default option
