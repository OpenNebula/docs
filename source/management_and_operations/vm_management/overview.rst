.. _vm_management_overview:

================================================================================
Overview
================================================================================

This chapter contains documentation on how to create and manage Virtual Machines and their associated objects.

.. important:: Through these guides Virtual Machine or VM is used as a generic abstraction that may represents real VMs, micro-VMs or system containers.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` or :ref:`LXC Hosts <lxc_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This Chapter is structured as follows:

  - The :ref:`Virtual Machine Template <vm_guide>` Section shows how to define VM
  - Then you can create :ref:`VM instances <vm_instances>` out of the VM Template definition.
  - Specific procedures to :ref:`backup your VMs <vm_backup>` are explained in a dedicated Section.

For infrastructures based on vCenter, please read the :ref:`VMware vCenter Virtual Machine <vcenter_specifics>` Section first.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors, except for the VMware vCenter Section.
