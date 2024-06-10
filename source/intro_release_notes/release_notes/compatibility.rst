
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

Ruby gems opennebula and opennebula-cli
================================================================================
Opennebula and opennebula-cli gems both require Nokogiri gem as a running dependency. As nokogiri from 1.16 requires Ruby >= 3.0 we locked Nokogiri to 1.16 to avoid installation failure on systems such as AlmaLinux 8, Debian 10, Ubuntu 20.04. In next 7.0 we will revisit this issue.

Search Virtual Machines
================================================================================
Searching for Virtual Machines has new syntax, use ``onevm list --search "VM.NAME=abc"`` instead of ``onevm list --search "NAME=abc"``. See :ref:`Search Virtual Machines <vm_search>`.