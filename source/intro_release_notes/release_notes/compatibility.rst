
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.0.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatiblity Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.2.

Data Model
=========================

- Virtual Machine. VM now includes ``SNAPSHOT/SYSTEM_DISK_SIZE`` to count system DS disk usage occupied by VM snapshot. The size is used to count ``SYSTEM_DISK_SIZE`` quota. This attributes applies only for newly created VM snapshots.
- Virtual Network. VN now include ``STATE``. After successful ``onevnet create`` command or API call you may need to wait until the VN state changes to ``READY`` to be able to use the VN. When a network operation ``onevnet create`` or ``onevnet delete`` fails the VN state will end in ``ERROR``, a description of the error will be added to the VNET  template in an ``ERROR`` attribute.

OneFlow
================================================================================

There are four new states in services. Now after ``PENDING`` the service goes to ``DEPLOYING_NETS`` and after ``UNDEPLOYING`` the service goes to ``UNDEPLOYING_NETS``.

XMLRPC API
=========================

Contextualization
========================

Go API
======

Distributed Edge Provisioning
=============================

PyONE
========================

FireEdge
========================
