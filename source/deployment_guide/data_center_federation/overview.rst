.. _introf:

======================
Overview
======================

Several OpenNebula instances can be configured as a **Federation**. Each instance of the Federation is called a **Zone**, and they are configured as one master and several slaves. Any other federation configurations (e.g. deeper master-slave hierarchy) aren't supported.

An OpenNebula Federation is a tightly coupled integration. All the Zones will share the same user accounts, groups, and permissions configuration. Moreover, you can define access policies federation-wide so users can be restricted to certain Zones, or to specific Clusters inside a Zone.

For the end users, a Federation allows them to use the resources no matter where they are. The integration is seamless, meaning that a user logged into the Sunstone web interface of a Zone just need to select the zone where she wants to work.

.. _introf_architecture:

Architecture
================================================================================

The master Zone is responsible for updating the federated information and replicating the updates in the slaves. The federated information shared across zones includes users, groups, VDCs, ACL rules, marketplace, marketplace apps, and zones.

The slave Zones have read-only access to the local copy of the federated information. Write operations on the slaves are redirected to the master Zone. Note that you may suffer from stale reads while the data is replicating from the master to the slaves. However, this approach ensures sequential consistency across zones (each zone will replicate operations in the same order) without any impact on the speed of read-only actions.

The federated information replication is implemented with a log that includes a sequence of SQL statements applied to the shared tables. This log is replicated and applied in each Zone database. This replication model tolerates faulty connections, and even zone crashes without impacting the federation.

The administrators can share appliances across Zones deploying a private :ref:`OpenNebula Marketplace <private_marketplaces>`.

Other Services
================================================================================

Although a single Sunstone server can connect to different Zones, all the other OpenNebula services will only work with the local Zone resources. This includes the :ref:`Scheduler <schg>`, :ref:`OneFlow <oneapps_overview>`, and :ref:`OneGate <onegate_overview>`.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`Federation Configuration <federationconfig>` section to learn how to setup a federation, and the :ref:`Federation Management <federationmng>` section to learn how to manage zones in OpenNebula.

After reading this chapter, you can continue configuring more :ref:`Advanced Components <advanced_components>`.

Hypervisor Compatibility
================================================================================

This chapter applies both to KVM and vCenter.
