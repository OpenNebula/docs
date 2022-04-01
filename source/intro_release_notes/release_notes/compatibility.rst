
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.0.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatiblity Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.2.

Data Model
=========================

- Virtual Machine. VM now includes ``SNAPSHOT/SYSTEM_DISK_SIZE`` to count system DS disk usage occupied by VM snapshot. The size is used to count ``SYSTEM_DISK_SIZE`` quota. This attributes applies only for newly created VM snapshots.

XMLRPC API
=========================

Contextualization
========================

Go API
======

Distributed Edge Provisioning
================================================================================

The following providers has been disabled by default:

- DigitalOcean
- Google
- Vultr (Metal & virrtual)

If you want to use them, please check their specific documentation section.

PyONE
========================

FireEdge
========================
