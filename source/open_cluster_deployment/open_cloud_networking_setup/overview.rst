.. _nm:

====================
Overview
====================

When a new Virtual Machine is launched, OpenNebula will connect its virtual network interfaces (defined by ``NIC`` attributes) to hypervisor link devices as defined in the corresponding :ref:`Virtual Network <vgg>`. This will allow the VM to have access to public and private networks.

OpenNebula supports four different networking modes:

* :ref:`Bridged <bridged>`. The VM NIC is added to a Linux bridge on the hypervisor. This mode can be configured to use security groups and network isolation.

* :ref:`VLAN <hm-vlan>`. The VM NIC is added to a Linux bridge on the hypervisor and the Virtual Network is configured to handle 802.1Q VLAN tagging traffic.

* :ref:`VXLAN <vxlan>`. The VM NIC is added to a Linux bridge on the hypervisor and the Virtual Network implements VLANs using the VXLAN protocol that relies on a UDP encapsulation and IP multicast.

* :ref:`Open vSwitch <openvswitch>`. The VM NIC is added to a Open vSwitch bridge on the hypervisor and the Virtual Network is configured to handle 802.1Q VLAN tagging traffic.

* :ref:`Open vSwitch on VXLAN <openvswitch_vxlan>`. The VM NIC is added to a Open vSwitch bridge on the hypervisor and the Virtual Network is configured to handle VXLAN traffic.

The attribute ``VN_MAD`` attribute of a Virtual Network determines which of the above networking modes is used.

.. note::

    Security Groups are not supported by the Open vSwitch mode.

Network drivers run three different action scripts: ``pre`` before the VM boot, ``post`` after the VM is booted, and ``clean`` when the VM is removed from the host. Each one of those driver actions :ref:`can be extended with custom programs <devel-nm>` by placing executable files inside the corresponding action folders (``pre.d``, ``post.d`` and ``clean.d``) within the network driver directory.

Finally, the networking stack of OpenNebula can be integrated with an external IP
address manager (IPAM). To do so, you need to develop the needed glue, :ref:`for more details refer to the IPAM driver guide. <devel-ipam>`

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Storage <storage>` chapter.

**Start by reading** the common :ref:`Node Setup <networking_node>` section to learn how to configure your hosts, and then proceed to the specific section for the networking mode that you are interested in.

After reading this chapter you can complete your OpenNebula installation by optionally enabling an :ref:`External Authentication <authentication>` or configuring :ref:`Sunstone <sunstone>`. Otherwise you are ready to :ref:`Operate your Cloud <operation_guide>`.

Hypervisor Compatibility
================================================================================

This chapter applies to KVM, LXC and Firecracker.
