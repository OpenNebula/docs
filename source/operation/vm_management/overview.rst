.. _vm_management_overview:

================================================================================
Overview
================================================================================

This chapter contains documentation on how to create and manage Virtual Machine :ref:`templates <vm_guide>`, :ref:`instances <vm_instances>`, and :ref:`Images <img_guide>` (VM disks).

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>`, :ref:`LXD Hosts <lxd_node>`, :ref:`Firecracker Hosts <fc_node>` or :ref:`vCenter node <vcenter_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

For vCenter based infrastructures read first the :ref:`vCenter Specifics <vcenter_specifics>` Section.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------+-----------------------------------------------+
|                     Section                     |                 Compatibility                 |
+=================================================+===============================================+
| :ref:`Virtual Machine Images <img_guide>`       | This Section applies to all Hypervisors.      |
+-------------------------------------------------+-----------------------------------------------+
| :ref:`Virtual Machine Templates <vm_templates>` | This Section applies to all Hypervisors.      |
+-------------------------------------------------+-----------------------------------------------+
| :ref:`Virtual Machine Instances <vm_instances>` | This Section applies to all Hypervisors.      |
+-------------------------------------------------+-----------------------------------------------+
| :ref:`vCenter Specifics <vcenter_specifics>`    | This Section applies to vCenter.              |
+-------------------------------------------------+-----------------------------------------------+
