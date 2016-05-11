.. _vmmg:

================================================================================
Overview
================================================================================

.. todo::

    * Architect
    * KVM

The Virtualization Subsystem is the component in charge of talking with the hypervisor installed in the hosts and taking the actions needed for each step in the VM life-cycle. This chapter focuses on the procedure to configure and add KVM hosts into the OpenNebula Cloud.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This chapter will focus on the configuration options for the hosts.

* Read the :ref:`KVM driver <kvmg>` section in order to understand the procedure of configuring and managing kvm Hosts.
* In the :ref:`Monitoring <mon>` section, you can find information about how OpenNebula is monitoring its Hosts and Virtual Machines, and changes you can make in the configuration of that subsystem.
* Optionally, you can enable :ref:`Virtual Machine HA <ftguide>`.
* You can read this section if you are interested in performing :ref:`PCI Passthrough <kvm_pci_passthrough>`.

After reading this chapter, you should read the :ref:`Open Cloud Storage <storage>` chapter.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.

Follow the :ref:`vCenter Node <vcenter_node>` section for a similar guide for vCenter.
