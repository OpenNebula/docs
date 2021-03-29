.. _introf:

========
Overview
========

The OpenNebula **Federation** is a tightly coupled integration of several instances of OpenNebula Front-end (called **Zones**), where each instance (Zone) shares the same user accounts, groups, and permissions configuration. You can define access policies federation-wide where users can be restricted to certain Zones, or to specific Clusters inside a Zone. Federation topology consists of one master and several slave Front-ends (any other federation configurations, e.g. deeper master-slave hierarchy, aren't supported).

For the End-users, the Federation allows them to use the resources no matter where they are. The integration is seamless; a user logged into the Sunstone web interface of a Zone just needs to select the Zone where he or she wants to work.

.. _introf_architecture:

Architecture
============

The *master* Zone is responsible for updating the federated information and replicating the updates in the *slaves*. The federated information shared across Zones includes Users, Groups, VDCs, ACL rules, Marketplace, Marketplace Apps., and Zones.

The *slave* Zones have read-only access to the local copy of the federated information. Write operations on the *slaves* are redirected to the master Zone. Note that you may suffer from stale reads while the data is replicating from the *master* to the *slaves*. However, this approach ensures sequential consistency across Zones (each Zone will replicate operations in the same order) without any impact on the speed of read-only actions.

The federated information replication is implemented with a log that includes a sequence of SQL statements applied to the shared tables. This log is replicated and applied in each Zone database. This replication model tolerates faulty connections, and even Zone crashes without impacting the federation.

The cloud administrators can share appliances across different Zones with :ref:`Private Marketplaces <private_marketplaces>`.

.. important::

    Although a single Sunstone server can connect to different Zones, all the other OpenNebula services will only work with the local Zone resources. This includes the :ref:`Scheduler <schg>`, :ref:`OneFlow <oneapps_overview>`, and :ref:`OneGate <onegate_overview>`.

How Should I Read This Chapter
================================================================================

Before starting, it's required to have at least two new instances of :ref:`OpenNebula Front-end <opennebula_installation>` ready to configure as Federation.

Start by reading the :ref:`Federation Configuration <federationconfig>` section to learn how to set-up the OpenNebula Federation, and continue with :ref:`Federation Usage <federationmng>` to learn how to use the Zones with CLI and Sunstone GUI.

Hypervisor Compatibility
================================================================================

This chapter applies to all hypervisors.
