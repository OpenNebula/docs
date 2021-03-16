.. _context_overview:

========
Overview
========

OpenNebula uses a method called contextualization to send information to the VM at boot time. Its most basic usage is to share networking configuration and login credentials with the VM so it can be configured. More advanced cases can be starting a custom script on VM boot or preparing configuration to use :ref:`OpenNebula Gate <onegate_usage>`.

How Should I Read This Chapter
================================================================================
Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>`, :ref:`LXD Hosts <lxd_node>`, :ref:`Firecracker Hosts <fc_node>` or :ref:`vCenter node <vcenter_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

To enable the use of contextualization there are two steps that you need to perform:

* Installing contextualization packages in your images
* Set contextualization data in the VM template

Learn how to do that in the contextualization guide linked below for the hypervisor configured.

Hypervisor Compatibility
================================================================================

+--------------------------------------------------------------+--------------------------------------------------------------------+
|                           Section                            |                 Compatibility                                      |
+==============================================================+====================================================================+
| :ref:`Open Cloud Contextualization <kvm_contextualization>`  | This Section applies to KVM, LXD and Firecracker.                  |
+--------------------------------------------------------------+--------------------------------------------------------------------+
| :ref:`vCenter Contextualization <vcenter_contextualization>` | This Section applies to vCenter.                                   |
+--------------------------------------------------------------+--------------------------------------------------------------------+
| :ref:`Adding Content to your Cloud <add_content>`            | This Section applies to all hypervisors.                           |
+--------------------------------------------------------------+--------------------------------------------------------------------+
