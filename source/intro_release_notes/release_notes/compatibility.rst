
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.1.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`.

The following components have been deprecated:

- XXXXXXX


Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.1.

Data Model
=========================

- Virtual Machine. Scheduled Actions have been moved from ``USER_TEMPLATE/SCHED_ACTION`` to ``TEMPLATE/SCHED_ACTION``.

XMLRPC API
=========================

- Scheduled Actions now includes a dedicated API for its management. Applications
that manages the Scheduled Actions through the ``one.vm.update`` method needs to update to the new ``one.vm.schedadd``, ``one.vm.scheddel`` and ``one.vm.schedupdate``.

Ruby API
========


Distributed Edge Provisioning
=============================


Datastore Driver Changes
=============================

.. _compatibility_kvm:

KVM Driver Defaults Changed
===========================

.. _compatibility_pkg:

Distribution Packages Renamed
=============================


.. _compatibility_sunstone:

Sunstone SELinux Requirement
=============================


.. _compatibility_virtualization:

Drivers Virtualization
========================

