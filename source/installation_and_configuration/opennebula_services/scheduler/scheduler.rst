.. _scheduler_main:

=======================
Scheduler Configuration
=======================

There are three main components related to **OpenNebula virtual machine allocation**:

1. :ref:`scheduler_scheduler_manager`
2. :ref:`scheduler_plan_manager`
3. Schedulers (:ref:`scheduler_rank` and :ref:`scheduler_drs`)

OpenNebula has two schedulers that allocate virtual machines on available hypervisor nodes:

* :ref:`Rank Scheduler <scheduler_rank>`, which is used for the initial placement of pending virtual machines, as the default option
* :ref:`Distributed Resource Scheduler <scheduler_drs>`, which can be used for:

  * Initial placement of pending virtual machines
  * Cluster-wise workload optimization, as the default option
