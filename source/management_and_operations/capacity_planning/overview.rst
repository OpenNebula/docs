.. _cappacity_overview:

================================================================================
Overview
================================================================================

How Should I Read This Chapter
================================================================================

This Chapter shows different mechanism available to administrators to control the capacity assigned to Virtual Machines as well as that available to the users:

  - First you can control the apparent capacity of :ref:`Hosts configuring its overcommitment <overcommitment>`.
  - Also you can fine tune :ref:`the scheduling policies <scheduling>` that controls how resources from Hosts, Datastores, and Virtual Networks are allocated to Virtual Machines.
  - Similarly, you can limit the resources that are made available to :ref:`users with the quota system <quota_auth>`.
  - Finally, some workloads may require that you co-allocate or coordinate the capacity assigned to a group of Virtual Machines. :ref:`Affinity and placement rules can be set for VM groups <vmgroups>`.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
