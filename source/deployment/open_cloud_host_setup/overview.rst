.. _vmmg:

================================================================================
Open Cloud Host Setup
================================================================================

* Architect
* KVM

The Virtualization Subsystem is the component in charge of talking with the hypervisor installed in the hosts and taking the actions needed for each step in the VM lifecycle. This chapter focuses on the procedure to configure and add KVM hosts into the OpenNebula Cloud.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.

Follow the :ref:`vCenter Node <vcenter_node>` section for a similar guide for vCenter.

How Should I Read This Chapter
================================================================================

* Read the :ref:`KVM driver <kvmg>` section in order to understand the procedure of configuring and managing kvm Hosts.
* In the :ref:`Monitoring <mon>` section, you can find information about how OpenNebula is monitoring its Hosts and Virtual Machines, and changes you can make in the configuration of that subsystem.
* Optionally, you can enable :ref:`Virtual Machine HA <ftguide>`.
* You can read this section if you are interested in performing :ref:`PCI Passthrough <kvm_pci_passthrough>`.
* If you are interested in very fast deployment times you might want to read the :ref:`Multiple Actions <kvm_multiple_actions>` section in order to perform multiple operations concurrently in each Host.

Other Hypervisors
================================================================================

Support for Xen 4 is provided through the `Xen Add-on <https://github.com/OpenNebula/addon-xen>`__ .
