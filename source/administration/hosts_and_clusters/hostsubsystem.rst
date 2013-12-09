=========================
Hosts & Clusters Overview
=========================

A **Host** is a server that has the ability to run Virtual Machines and
that is connected to OpenNebula's Frontend server. OpenNebula can work
with Hosts with a heterogeneous configuration, i.e. you can connect
Hosts to the same OpenNebula with different hypervisors or Linux
distributions as long as these requirements are fulfilled:

-  Every Host need to have a ``oneadmin`` account.
-  OpenNebula's Frontend and all the Hosts need to be able to resolve,
either by DNS or by ``/etc/hosts`` the names of all the other Hosts
and Frontend.
-  The ``oneadmin`` account in any Host or the Frontend should be able
to ssh passwordlessly to any other Host or Frontend. This is achieved
either by sharing the ``$HOME`` of ``oneadmin`` accross all the
servers with NFS or by manually copying the ``~/.ssh`` directory.
-  It needs to have a hypervisor supported by OpenNebula installed and
properly configured. The correct way to achieve this is to follow the
specific guide for each hypervisor.
-  **ruby** >= 1.8.7

**Clusters** are pools of hosts that share datastores and virtual
networks. Clusters are used for load balancing, high availability, and
high performance computing.

Overview of Components
======================

There are three components regarding Hosts:

-  **Host Management**: Host management is achieved through the
``onehost`` CLI command or through the Sunstone GUI. You can read
about Host Management in more detail in the `Managing
Hosts </./host_guide>`__ guide.
-  **Host Monitorization**: In order to keep track of the available
resources in the Hosts, OpenNebula launches a Host Monitoring driver,
called IM (Information Driver), which gathers all the required
information and submits it to the Core. The default IM driver
executes ``ssh`` commands in the host, but other mechanism are
possible, name the `Ganglia Monitoring System </./ganglia>`__. There
is further information on this topic in the `Monitoring
Subsystem </./img>`__ guide
-  **Cluster Management**: Hosts can be grouped in Clusters. These
Clusters are managed with the ``onecluster`` CLI command, or through
the Sunstone GUI. You can read about Cluster Management in more
detail in the `Managing Clusters </./cluster_guide>`__ guide..

