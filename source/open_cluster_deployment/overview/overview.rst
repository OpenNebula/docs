.. _open_cluster_deployment_overview:

================================================================================
Overview
================================================================================

The Hosts are servers with a hypervisor installed (KVM, LXC or Firecracker) which execute the running Virtual Machines. These Hosts are managed by the KVM, LXC or Firecracker Driver, which will perform the actions needed to manage the VM and its life-cycle. This chapter analyses the KVM, LXC or Firecracker driver in detail, and will give you, amongst other things, the tools to configure and add KVM, LXC or Firecracker hosts into the OpenNebula Cloud.

After the Host sections, we will look into the Storage and Networking setup.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`.

* Read the :ref:`KVM node deployment <kvm_node>` section in order to understand the procedure of installing, configuring and managing KVM Hosts.
* Read the :ref:`LXC node deployment <lxc_node>` section in order to understand the procedure of installing, configuring and managing LXC Hosts.
* Read the :ref:`Firecracker driver <fc_node>` section in order to understand the procedure of installing, configuring and managing Firecracker Hosts.
* Read the :ref:`Open Cloud Storage Setup <storage>` section in order to understand the procedure of configuring and managing Storage.
* Read the :ref:`Open Cloud Networking Setup <nm>` section in order to understand the procedure of configuring and managing Networking.


Hypervisor Compatibility
================================================================================

This chapter applies to KVM, LXC and Firecracker.

Follow the :ref:`vCenter Node <vcenter_node>` section for a similar guide for vCenter.
