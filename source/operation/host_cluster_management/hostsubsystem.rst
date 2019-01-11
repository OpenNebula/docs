.. _hostsubsystem:

==========================
Overview
==========================

A **Host** is a server that has the ability to run Virtual Machines and that is connected to OpenNebula's Front-end server. OpenNebula can work with Hosts with a heterogeneous configuration, i.e. you can connect Hosts to the same OpenNebula with different hypervisors or Linux distributions. To learn how to prepare the hosts you can read the :ref:`Node Installation guide <node_installation_overview>`.

**Clusters** are pools of hosts that share datastores and virtual networks.

How Should I Read This Chapter
================================================================================

In this chapter there are four guides describing these objects.

* **Host Management**: Host management is achieved through the ``onehost`` CLI command or through the Sunstone GUI. You can read about Host Management in more detail in the :ref:`Managing Hosts <host_guide>` guide.
* **Cluster Management**: Hosts can be grouped in Clusters. These Clusters are managed with the ``onecluster`` CLI command, or through the Sunstone GUI. You can read about Cluster Management in more detail in the :ref:`Managing Clusters <cluster_guide>` guide.
* **Scheduler**: Where you'll learn how to change the scheduling configuration to suit your needs. For example changing the scheduling policies or the number of VMs that will be sent per host.
* **Datastore**: Where you'll learn about how to confgure and manage the different types of datastore types.


You should read all the guides in this chapter to familiarize with these objects. For small and homogeneous clouds you may not need to create new clusters.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.

.. note:: Linux hosts will be mentioned when the information is applicable to LXD and KVM
