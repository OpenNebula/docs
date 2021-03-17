.. _nm:

====================
Overview
====================

When a new Virtual Machine is launched, OpenNebula will connect its virtual network interfaces (defined by ``NIC`` attributes) to hypervisor network link devices as defined in the corresponding :ref:`Virtual Network <vgg>`. This will allow the VM to have access to public and private networks.

OpenNebula supports following networking modes:

* :ref:`Bridged <bridged>`. The VM NIC is added to a Linux bridge on the hypervisor. This mode can be configured to use security groups and network isolation.

* :ref:`802.1Q VLAN <hm-vlan>`. The VM NIC is added to a Linux bridge on the hypervisor and the Virtual Network is configured to handle 802.1Q VLAN tagging traffic.

* :ref:`VXLAN <vxlan>`. The VM NIC is added to a Linux bridge on the hypervisor and the Virtual Network implements VLANs using the VXLAN protocol that relies on a UDP encapsulation and IP multicast.

* :ref:`Open vSwitch <openvswitch>`. The VM NIC is added to a Open vSwitch bridge on the hypervisor and the Virtual Network is configured to handle 802.1Q VLAN tagging traffic.

* :ref:`Open vSwitch on VXLAN <openvswitch_vxlan>`. The VM NIC is added to a Open vSwitch bridge on the hypervisor and the Virtual Network is configured to handle VXLAN traffic.

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
