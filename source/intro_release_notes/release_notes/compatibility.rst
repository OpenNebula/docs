
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.2.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.4.

Data Model
=========================
- Virtual Machine. VM now includes ``SNAPSHOT/SYSTEM_DISK_SIZE`` to count system DS disk usage occupied by VM snapshot. The size is used to count ``SYSTEM_DISK_SIZE`` quota. This attributes applies only for newly created VM snapshots.
- Virtual Network. VNet now includes state (``STATE``), this is automatically managed by the upgrade process. However if you have any custom integration that create a network and afterwards create VMs in the network you may need some synchronization (state ``READY``), even for dummy creation/delete actions. . When a network operation ``onevnet create`` or ``onevnet delete`` fails the VN state will end in ``ERROR``, a description of the error will be added to the VNET  template in an ``ERROR`` attribute.

OneFlow
================================================================================
There are four new states in services. Now after ``PENDING`` the service goes to ``DEPLOYING_NETS`` and after ``UNDEPLOYING`` the service goes to ``UNDEPLOYING_NETS``.

KVM
========================
Cgroups version is obtained by the monitor probes. The ``shares`` assigned to each VM is computed based on this version and the ``CPU`` parameter. If you are using cgroups version 2 hosts, after you upgrade the new VMs will use a base priority of ``100``. This may lead to inconsistent resource distribution between new and old VMs, it is recommend to reboot existing VMs to use the new values.

Distributed Edge Provisioning
================================================================================

The following providers has been disabled by default:

- DigitalOcean
- Google
- Vultr (Metal & virrtual)

If you want to use them, please check their specific documentation section.

vCenter
========================

This version introduces a `change in the deploy ID used to identify vCenter VMs <https://github.com/OpenNebula/one/issues/5689>`__. Its purpose is to avoid the collision of the Managed Object References in different vCenter instances, since their uniqueness is not guaranteed. Due to its sensitivity, we recommend first backing up the database and configuration files so you can :ref:`restore your previous version if needed <restoring_version>`.

Also worth noting that Debian front-ends are no longer certified over VMware. We advise OpenNebula users managing vCenter-based infrastructures with Debian front-ends to switch to any of the other :ref:`supported platforms <uspng>`.
