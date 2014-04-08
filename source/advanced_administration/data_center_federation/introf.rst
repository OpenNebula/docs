.. _introf:

======================
Data Center Federation
======================

Several OpenNebula instances can be configured as a **Federation**. Each instance of the Federation is called a **Zone**, and they are configured as one master and several slaves.

An OpenNebula Federation is a tightly coupled integration. All the instances will share the same user accounts, groups, and permissions configuration. Of course, access can be restricted to certain Zones, and also to specific Clusters inside that Zone.

The typical scenario for an OpenNebula Federation is a company with several Data Centers, distributed in different geographic locations. This low-level integration does not rely on APIs, administrative employees of all Data Centers will collaborate on the maintenance of the infrastructure. If your use case requires a synergy with an external cloud infrastructure, that would fall into the cloudbursting scenario.

For the end users, a Federation allows them to use the resources allocated by the Federation Administrators no matter where they are. The integration is seamless, meaning that a user logged into the Sunstone web interface of a Zone will not have to log out and enter the address of the other Zone. Sunstone allows to change the active Zone at any time, and it will automatically redirect the requests to the right OpenNebula at the target Zone.

Benefits
================================================================================

.. todo::

Architecture
================================================================================

In a Federation, there is a master OpenNebula zone and several slaves sharing the database tables for users, groups, ACL rules, and zones. The master OpenNebula is the only one that writes in the shared tables, while the slaves keep a read-only local copy, and proxy any writing actions to the master. This allows us to guarantee data consistency, without any impact on the speed of read-only actions.

The synchronization is achieved configuring MySQL to replicate certain tables only. MySQL's replication is able to perform over long-distance or unstable connections. Even if the master zone crashes and takes a long time to reboot, the slaves will be able to continue working normally except for a few actions such as new user creation or password updates.

New slaves can be added to an existing Federation at any moment. Moreover, the administrator can add a clean new OpenNebula, or import an existing deployment into the Federation keeping the current users, groups, configuration, and virtual resources.

Regarding the OpenNebula updates, we have designed the database in such a way that different OpenNebula versions will be able to be part of the same Federation. While an upgrade of the local tables (VM, Image, VNet objects) will be needed, new versions will keep compatibility with the shared tables. In practice, this means that when a new OpenNebula version comes out each zone can be updated at a different pace, and the Federation will not be affected.

.. todo:: figure of the architecture

To enable users to change zones, Sunstone server is connected to all the oned daemons in the Federation. You can have one Sunstone for all the Federation, or run one Sunstone for each Zone.

.. todo::

- oneadmin account. one oneadmin per zone, one federation admin?
- Mention marketplace as the method to share images across zones?

Next Steps
================================================================================

Continue to the following guides to learn how to configure and manage a Federation:

* :ref:`Federation Configuration <federationconfig>`
* :ref:`Federation Management <federationmng>`
