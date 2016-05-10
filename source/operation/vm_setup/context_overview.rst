.. _context_overview:

========
Overview
========

* Architect
* Administrator
* KVM
* vCenter

OpenNebula uses a method called contextualization to send information to the VM at boot time. Its most basic usage is to share networking configuration and login credentials with the VM so it can be configured. More advanced cases can be starting a custom script on VM boot or preparing configuration to use :ref:`OpenNebula Gate <onegate_usage>`.


How Should I Read This Chapter
================================================================================

To enable the use of contextualization there are two steps that you need to perform:

* Installing contextualization packages in your images
* Set contextualization data in the VM template

Learn how to do that in the contextualization guide linked below for the hypervisor configured.

Hypervisor Compatibility
================================================================================

+--------------------------------------------------------------+-----------------------------------------------+
|                           Section                            |                 Compatibility                 |
+==============================================================+===============================================+
| :ref:`KVM Contextualization <kvm_contextualization>`         | This Section applies to KVM.                  |
+--------------------------------------------------------------+-----------------------------------------------+
| :ref:`vCenter Contextualization <vcenter_contextualization>` | This Section applies to vCenter.              |
+--------------------------------------------------------------+-----------------------------------------------+
| :ref:`Adding Content to your Cloud <add_content>`            | This Section applies to both KVM and vCenter. |
+--------------------------------------------------------------+-----------------------------------------------+


