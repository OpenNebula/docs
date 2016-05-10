.. _hostsubsystem:

==========================
Overview
==========================

* Architect
* Administrator
* KVM
* vCenter

A **Host** is a server that has the ability to run Virtual Machines and that is connected to OpenNebula's Front-end server. OpenNebula can work with Hosts with a heterogeneous configuration, i.e. you can connect Hosts to the same OpenNebula with different hypervisors or Linux distributions. To learn how to prepare the hosts you can read the :ref:`Node Installation guide <node_installation_overview>`.

**Clusters** are pools of hosts that share datastores and virtual networks. Clusters are used for load balancing, high availability, and high performance computing.

Overview of Components
======================

There are three components regarding Hosts:

* **Host Management**: Host management is achieved through the ``onehost`` CLI command or through the Sunstone GUI. You can read about Host Management in more detail in the :ref:`Managing Hosts <host_guide>` guide.
* **Host Monitoring**: In order to keep track of the available resources in the Hosts, OpenNebula launches a Host Monitoring driver, called IM (Information Driver), which gathers all the required information and submits it to the Core. The default IM driver executes ``ssh`` commands in the host, but other mechanism are possible. There is further information on this topic in the :ref:`Monitoring Subsystem <devel-im>` guide.
* **Cluster Management**: Hosts can be grouped in Clusters. These Clusters are managed with the ``onecluster`` CLI command, or through the Sunstone GUI. You can read about Cluster Management in more detail in the :ref:`Managing Clusters <cluster_guide>` guide.



How Should I Read This Chapter
================================================================================

You should read all the guides in this chapter to familiarize with these objects. For small and homogeneous clouds you may not need to create new clusters.

Hypervisor Compatibility
================================================================================

These guides are compatible with both KVM and vCenter hypervisors.

