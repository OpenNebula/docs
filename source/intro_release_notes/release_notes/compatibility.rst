
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

- Scheduled Actions now includes a dedicated API for its management. Applications that manages the Scheduled Actions through the ``one.vm.update`` method needs to update to the new ``one.vm.schedadd``, ``one.vm.scheddel`` and ``one.vm.schedupdate``.

Contextualization
========================

- Network (and NIC) template attribute ``CONTEXT_FORCE_IPV4`` was deprecated  and removed from the Context variables.
- ``GATEWAY6`` is planned to be deprecated in a future release (OpenNebula 6.6). To prepare for this transition, the replacement ``IP6_GATEWAY`` is already generated as part of the context section.

Ruby API
========

Go API
======

- The constant ``ContextForceIPV4`` from Go API (GOCA) in consonance with the context changes outlined above.

Distributed Edge Provisioning
=============================

- OneProvision is able to load providers dinamically, so all the providers in the folder ``/usr/lib/one/oneprovision/lib/terraform/providers`` are loaded.

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

PyONE
========================
As Python 2 is no longer supported the system packcage python-pyone is not released any more.
