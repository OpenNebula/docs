================================================================================
Overview
================================================================================

This chapter contains documentation on how to create and manage :ref:`Virtual Networks <manage_vnets>`, how to define and manage :ref:`Security Groups <security_groups>`, which will allow users and administrators to define firewall rules and apply them to the Virtual Machines, and how to create and manage :ref:`Virtual Routers <vrouter>` which are an OpenNebula resource that provide routing across Virtual Networks.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>`, :ref:`Firecracker Hosts <fc_node>` or :ref:`vCenter node <vcenter_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------+-----------------------------------------------------------------+
|                     Section                     |                 Compatibility                                   |
+=================================================+=================================================================+
| :ref:`Virtual Networks <manage_vnets>`          | This Section applies to all Hypervisors                         |
+-------------------------------------------------+-----------------------------------------------------------------+
| :ref:`Security Groups <security_groups>`        | This Section applies to KVM, LXD and Firecracker                |
+-------------------------------------------------+-----------------------------------------------------------------+
| :ref:`Virtual Routers <vrouter>`                | This Section applies to all Hypervisors                         |
+-------------------------------------------------+-----------------------------------------------------------------+
