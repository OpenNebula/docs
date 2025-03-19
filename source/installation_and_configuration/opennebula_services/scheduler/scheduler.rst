.. _scheduler_main:

=======================
Scheduler Configuration
=======================

There are three main components related to OpenNebula virtual machine allocation:

* Scheduler Manager
* Plan Manager
* Schedulers (Rank Scheduler and Distributed Resource Scheduler)

OpenNebula has two schedulers that allocate virtual machines on available hypervisor nodes:

* Rank Scheduler, which is used for the initial placement of pending virtual machines, as the default option
* Distributed Resource Scheduler, which can be used for:

  * Initial placement of pending virtual machines
  * Cluster-wise workload optimization, as the default option
