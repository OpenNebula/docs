.. _vmmg:

================================================================================
Overview
================================================================================

The Hosts are servers with a hypervisor installed (KVM) which execute the running Virtual Machines. These Hosts are managed by the KVM Driver, which will perform the actions needed to manage the VM and its life-cycle. This chapter analyses the KVM driver in detail, and will give you, amongst other things, the tools to configure and add KVM hosts into the OpenNebula Cloud.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This chapter will focus on the configuration options for the Hosts.

* Read the :ref:`KVM driver <kvmg>` section in order to understand the procedure of configuring and managing kvm Hosts.
* In the :ref:`Monitoring <mon>` section, you can find information about how OpenNebula is monitoring its Hosts and Virtual Machines, and changes you can make in the configuration of that subsystem.
* You can read this section if you are interested in performing :ref:`PCI Passthrough <kvm_pci_passthrough>`.

After reading this chapter, you should read the :ref:`Open Cloud Storage <storage>` chapter.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.

Follow the :ref:`vCenter Node <vcenter_node>` section for a similar guide for vCenter.
