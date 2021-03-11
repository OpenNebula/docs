.. _firecracker_node_deployment_overview:

.. todo:: Review and adapt

================================================================================
Overview
================================================================================

The Hosts are servers with a hypervisor installed (KVM, LXD or Firecracker) which execute the running Virtual Machines. These Hosts are managed by the KVM, LXD or Firecracker Driver, which will perform the actions needed to manage the VM and its life-cycle. This chapter analyses the KVM, LXD or Firecracker driver in detail, and will give you, amongst other things, the tools to configure and add KVM, LXD or Firecracker hosts into the OpenNebula Cloud.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` and/or :ref:`LXD Hosts <lxd_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This chapter will focus on the configuration options for the Hosts.

* Read the :ref:`KVM driver <kvmg>` section in order to understand the procedure of configuring and managing KVM Hosts.
* Read the :ref:`LXD driver <lxdmg>` section in order to understand the procedure of configuring and managing LXD Hosts.
* Read the :ref:`Firecracker driver <fcmg>` section in order to understand the procedure of configuring and managing Firecracker Hosts.
* In the :ref:`Monitoring <mon>` section, you can find information about how OpenNebula is monitoring its Hosts and Virtual Machines, and changes you can make in the configuration of that subsystem.
* You can read this section if you are interested in performing :ref:`PCI Passthrough <kvm_pci_passthrough>`.

After reading this chapter, you should read the :ref:`Open Cloud Storage <storage>` chapter.

Hypervisor Compatibility
================================================================================

This chapter applies to KVM, LXD and Firecracker.

Follow the :ref:`vCenter Node <vcenter_node>` section for a similar guide for vCenter.
