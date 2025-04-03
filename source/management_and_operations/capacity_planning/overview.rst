.. _cappacity_overview:

================================================================================
Overview
================================================================================

How Should I Read This Chapter
================================================================================

This Chapter shows the different mechanisms available to administrators and users for controlling the capacity assigned to Virtual Machines:

  - First, you can control the apparent capacity of Hosts by :ref:`configuring host overcommitment <overcommitment>`.
  - You can also fine-tune :ref:`the scheduling policies <scheduler_overview>` that control how resources from Hosts, Datastores, and Virtual Networks are allocated to Virtual Machines.
  - Similarly, you can limit the resources that are made available to users, by using the :ref:`quota system <quota_auth>`.
  - Finally, some workloads may require that you co-allocate or coordinate the capacity assigned to a group of Virtual Machines. :ref:`Affinity and placement rules can be set for VM groups <vmgroups>`.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
