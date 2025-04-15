
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.10.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 7.0.

Resize Operation
================================================================================
The enforcement parameter was deprecated to ensure NUMA consistency for the VM during a resize. Instead, it has been reinstated to control capacity attributes, such as memory and CPU.

New default Local datastore driver
================================================================================

Since OpenNebula 6.10.2, the default Local driver is ``local`` instead of ``ssh`` (see :ref:`Local Storage datastore drivers <local_ds_drivers>`). The legacy ``ssh`` driver is still supported and nothing needs to be done for already existing datastores to keep working. As supporting qcow2 features such as thin provisioning required breaking compatibility with existing datastores, we decided to take the opportunity to write the ``local`` driver from scratch, making the driver more maintainable and easing new feature development.

Check Datastore Capacity During Image Create
================================================================================

We fixed and synchronized usage of the ``no_check_capacity`` flag across all APIs (XML-RPC, CLI, Ruby, Java, Python). Now it works as described in the :ref:`XML-RPC API documentation <api>`. If you are using this flag in any of the API bindings provided for OpenNebula please make sure you update your code.

VM Drivers
================================================================================
We changed default for ``CLEANUP_MEMORY_ON_STOP`` to ``no`` as it could potentially lead to heavy workload on hosts when multiple VMs were stopped or migrated in parallel, e.g. when running ``onehost flush``.

Ruby gems opennebula and opennebula-cli
================================================================================
OpenNebula and opennebula-cli gems both require Nokogiri gem as a running dependency. As nokogiri from 1.16 requires Ruby >= 3.0 we locked Nokogiri to 1.16 to avoid installation failure on systems such as AlmaLinux 8, Debian 10, Ubuntu 20.04. In next 7.0 we will revisit this issue.

Search Virtual Machines
================================================================================
VM search uses has new pattern-based syntax. The following table includes some examples to move from old search format to the new one, see :ref:`Search Virtual Machines <vm_search>` for more info:

=======================   ============    ===============================================================
Search Description        Old syntax      New syntax
=======================   ============    ===============================================================
VM name                   NAME=abc        VM.NAME=abc
VM with disk target vda   TARGET=vda      VM.TEMPLATE.DISK[*].TARGET=vda
IP matching               IP=10.10.0.5    VM.TEMPLATE.NIC[*].IP=10.10.0.5
IP starts with 10.10      ---             VM.TEMPLATE.NIC[*].IP=10.10
=======================   ============    ===============================================================

Labels on Sunstone
================================================================================
Only persistent user labels that were created in old Sunstone will be showed :ref:`in new Sunstone <sunstone_labels>`. We are working to offer you a better experience in new Sunstone with the system and user labels in future versions of OpenNebula.

Remember that in new Sunstone you need to create the user label in the Settings section before apply a label to a resource. See :ref:`Sunstone labels guide <sunstone_labels>` to get more information.

OneProvision on Sunstone
================================================================================
We have integrated the OneProvision app into Sunstone, for convenience. Now users don't have to switch sessions to be able to manage provisions and see the equivalent resources in Sunstone. Both the Provision and the Provider can be found in the Sunstone Infrastructure left-side menu category.
