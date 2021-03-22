================================================================================
Overview
================================================================================

No host or service is absolutely reliable, we experience failures across various areas every day. To avoid the down-time and the consequent damages, we try to avoid a single point of failure by running several instances of same service. Failure of one instance doesn't mean complete service unavailability, as there are other instances that can handle the workload. Such deployment is **highly available**, resilient to partial failure.

OpenNebula provides high availability mechanisms both for the Front-end and for the Virtual Machines.

How Should I Read This Chapter
================================================================================

Before starting, it's required to have running :ref:`OpenNebula Front-end <opennebula_installation>`.

Read section :ref:`Front-end HA Setup <frontend_ha_setup>` section to learn how to setup a highly available (HA) OpenNebula Front-end. Continue with :ref:`Virtual Machines High Availability <ftguide>` if you are interested in a way to provide high availability to your Virtual Machines.

Hypervisor Compatibility
================================================================================

+----------------------------------------------+-------------------------------------------------------------------------------------------------------------+
|                       Section                |                 Compatibility                                                                               |
+==============================================+=============================================================================================================+
| :ref:`Front-end HA <frontend_ha_setup>`      | This section applies to all hypervisors.                                                                    |
+----------------------------------------------+-------------------------------------------------------------------------------------------------------------+
| :ref:`Virtual Machines HA <ftguide>`         | This section applies only to KVM, LXC and Firecracker.                                                      |
+----------------------------------------------+-------------------------------------------------------------------------------------------------------------+
