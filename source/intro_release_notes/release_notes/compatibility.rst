
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.0.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatiblity Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.2.

Data Model
=========================

- Virtual Machine. VM now includes ``SNAPSHOT/SYSTEM_DISK_SIZE`` to count system DS disk usage occupied by VM snapshot. The size is used to count ``SYSTEM_DISK_SIZE`` quota. This attributes applies only for newly created VM snapshots.
- Virtual Network. VN now include ``STATE``. After succesful ``onevnet create`` command you should wait until the VN state changes to ``READY`` to be able to use the VN. If the ``onevnet create`` and ``onevnet delete`` operations failed in previous version, they may now succeed, but the VN state will end in ``ERROR`` state, with error message in ``ERROR`` attribute.

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
