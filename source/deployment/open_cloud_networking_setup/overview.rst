.. _nm:

====================
Overview
====================

When a new Virtual Machine is launched, OpenNebula will connect its network interfaces (defined by NIC attribute) to hypervisor physical devices as defined in the :ref:`Virtual Network <vgg>`. This will allow the VM to have access to different networks, public or private.

OpenNebula supports four different networking modes:

* :ref:`Bridged <bridged>`. The Virtual Machine is directly attached to an existing bridge in the hypervisor. This mode can be configured to use security groups and network isolation.

* :ref:`VLAN <hm-vlan>`. Virtual Networks are implemented through 802.1Q VLAN tagging.

* :ref:`VXLAN <vxlan>`. Virtual Networks implements VLANs using the VXLAN protocol that relies on a UDP encapsulation and IP multicast.

* :ref:`Open vSwitch <openvswitch>`. Similar to the VLAN mode but using an openvswitch instead of a Linux bridge.

* :ref:`Open vSwitch on VXLAN <openvswitch_vxlan>`. Similar to the VXLAN mode but using an openvswitch instead of a Linux bridge.

When you create a new network you will need to add the attribute ``VN_MAD`` to the template, specifying which of the above networking modes you want to use.

.. note::

    Security Groups are not supported by the Open vSwitch mode.

Each network driver has 3 different configuration actions executed before (`pre`) and after(`post`) the VM is booted, and when the VM leaves (`clean`) the host. Each one of those driver actions :ref:`can be extended with custom programs <devel-nm>` by placing executable files inside the corresponding action folders (`pre.d`, `post.d` and `clean.d`) within the network driver directory.

Finally, the networking stack of OpenNebula can be integrated with an external IP
address manager (IPAM). To do so, you need to develop the needed glue, :ref:`for more details refer to the IPAM driver guide. <devel-ipam>`

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Storage <storage>` chapter.

**Start by reading** the common :ref:`Node Setup <networking_node>` section to learn how to configure your hosts, and then proceed to the specific section for the networking mode that you are interested in.

After reading this chapter you can complete your OpenNebula installation by optionally enabling an :ref:`External Authentication <authentication>` or configuring :ref:`Sunstone <sunstone>`. Otherwise you are ready to :ref:`Operate your Cloud <operation_guide>`.

Hypervisor Compatibility
================================================================================

This chapter applies to KVM, LXD and Firecracker.
