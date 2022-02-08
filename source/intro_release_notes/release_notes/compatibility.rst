
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.0.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatiblity Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.2.

Data Model
=========================

- Virtual Machine. Scheduled Actions have been moved from ``USER_TEMPLATE/SCHED_ACTION`` to ``TEMPLATE/SCHED_ACTION``.

XMLRPC API
=========================

- Scheduled Actions now includes a dedicated API for its management. Applications that manage the Scheduled Actions through the ``one.vm.update`` method need to update to the new ``one.vm.schedadd``, ``one.vm.scheddel`` and ``one.vm.schedupdate``.

Contextualization
========================

- Network (and NIC) template attribute ``CONTEXT_FORCE_IPV4`` was deprecated  and removed from the Context variables.
- ``GATEWAY6`` is planned to be deprecated in a future release (OpenNebula 6.6). To prepare for this transition, the replacement ``IP6_GATEWAY`` is already generated as part of the context section.

Go API
======

- The constant ``ContextForceIPV4`` from Go API (GOCA) in consonance with the context changes outlined above.

Distributed Edge Provisioning
=============================

- OneProvision is able to load providers dynamically, so all the providers in the folder ``/usr/lib/one/oneprovision/lib/terraform/providers`` are loaded.
- RHEL 7 does not support Equnix for edge clusters provisioning from OpenNebula version 6.2.1

PyONE
========================
As Python 2 is no longer supported the system packcage python-pyone is not released any more.

FireEdge
========================
Separate the configuration files by application: ``provision-server.conf``, ``sunstone-server.conf`` and the global configuration of the server is kept in ``firedge-server.conf``
