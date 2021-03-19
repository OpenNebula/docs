.. _kvm_node_deployment_overview:

================================================================================
Overview
================================================================================

`KVM <https://www.linux-kvm.org/>`__ is a main Linux virutalization technology. KVM (for Kernel-based Virtual Machine) is a full virtualization solution for Linux on x86 hardware containing virtualization extensions (Intel VT or AMD-V). It consists of a loadable kernel module, kvm.ko, that provides the core virtualization infrastructure and a processor specific module, kvm-intel.ko or kvm-amd.ko.

Using KVM, one can run multiple virtual machines running unmodified Linux or Windows images. Each virtual machine has private virtualized hardware: a network card, disk, graphics adapter, etc.

How Should I Read This Chapter
================================================================================

This chapter focuses on the configuration options for an KVM based Hosts. Read the :ref:`installation <kvm_node>` section to add a KVM host to your OpenNebula cloud to start deploying VMs. Continue with :ref:`driver <kvmg>` section in order to understand the specific requirements, functionalities, and limitations of the KVM driver.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.
