.. _nm:

====================
Overview
====================

When a new Virtual Machine is launched, OpenNebula will connect its virtual network interfaces (defined by ``NIC`` attributes) to hypervisor network link devices as defined in the corresponding :ref:`Virtual Network <manage_vnets>`. This will allow the VM to have access to public and private networks.

OpenNebula supports following networking modes:

* :ref:`Bridged <bridged>`. The VM NIC is added to a Linux bridge on the host. This mode can be configured to use Security Groups and network isolation.

* :ref:`802.1Q VLAN <hm-vlan>`. The VM NIC is added to a Linux bridge on the host and the Virtual Network is configured to handle 802.1Q VLAN isolation.

* :ref:`VXLAN <vxlan>`. The VM NIC is added to a Linux bridge on the host and the Virtual Network implements isolation using the VXLAN encapsulation.

* :ref:`Open vSwitch <openvswitch>`. The VM NIC is added to a Open vSwitch bridge on the host and the Virtual Network optionally handles 802.1Q VLAN isolation.

* :ref:`Open vSwitch on VXLAN <openvswitch_vxlan>`. The VM NIC is added to a Open vSwitch bridge on the host and the Virtual Network is configured to provide both isolation with VXLAN encapsulation and optionally 802.1Q VLAN.

The attribute ``VN_MAD`` of a Virtual Network determines which of the above networking modes is used.

.. note::

    Security Groups are not supported in the Open vSwitch modes.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you are familiar with the :ref:`Open Cloud Storage <storage>`. It's necessary to be aware of requirements for your selected storage solution in order to be able to design a network architecture of you hypervisor nodes.

Read the common :ref:`Node Setup <networking_node>` section to learn how to configure your hosts, and then proceed to the specific section for the networking mode that you are interested in.

Next, if you are interested in optional integration with the IP Address Manager (IPAM), the external mechanism which allocates and assigns the IP addresses for the Virtual Machines, you can continue to the section about :ref:`developing IPAM driver <devel-ipam>`.

Hypervisor Compatibility
================================================================================

This chapter applies to KVM, LXC and Firecracker.
