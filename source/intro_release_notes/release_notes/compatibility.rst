
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.2.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.2.

Data Model
=========================

- Virtual Machine. VM now includes SNAPSHOT/SYSTEM_DISK_SIZE to count system DS disk usage occupied by VM snapshot. The size is used to count SYSTEM_DISK_SIZE quota. This attributes applies only for newly created VM snapshots.

- Virtual Networks. VNet now includes state, this is automatically managed by the upgrade process. However if you have any custom integration that create a network and afterwards create VMs in the network you may need some synchronization (even for dummy creation/delete actions).


XMLRPC API
=========================


Contextualization
========================


Distributed Edge Provisioning
=============================


FireEdge
========================

vCenter
========================

This version introduces a `change in the deploy ID used to identify vCenter VMs <https://github.com/OpenNebula/one/issues/5689>`__. Its purpose is to avoid the collision of the Managed Object References in different vCenter instances, since their uniqueness is not guaranteed. Due to its sensitivity, we recommend first backing up the database and configuration files so you can :ref:`restore your previous version if needed <restoring_version>`.
