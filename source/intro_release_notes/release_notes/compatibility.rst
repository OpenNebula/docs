
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.8.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.10.


Check Datastore Capacity During Image Create
================================================================================

We fixed and synchronized usage of the ``no_check_capacity`` flag across all APIs (XML-RPC, CLI, Ruby, Java, Python). Now it works as described in the :ref:`XML-RPC API documentation <api>`. If you are using this flag in any of the API bindings provided for OpenNebula please make sure you update your code.

VM Drivers
================================================================================
We changed default for `CLEANUP_MEMORY_ON_STOP` to `no` as it could potentially lead to heavy workload on hosts when multiple VMs were stopped or migrated in parallel, e.g. when running `onehost flush`.
