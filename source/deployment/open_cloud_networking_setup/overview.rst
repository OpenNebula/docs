.. _nm:

====================
Overview
====================

.. todo::

    * Architect
    * KVM

When a new Virtual Machine is launched, OpenNebula will connect its network interfaces (defined by NIC attribute) to hypervisor physical devices as defined in the :ref:`Virtual Network <vgg>`. This will allow the VM to have access to different networks, public or private.

OpenNebula supports four different networking modes:

* :ref:`Bridged <bridged>`. The Virtual Machine is directly attached to an existing bridge in the hypervisor. This mode can be configured to use security groups and network isolation.

* :ref:`VLAN <hm-vlan>`. Virtual Networks are implemented through 802.1Q VLAN tagging.

* :ref:`VXLAN <vxlan>`. Virtual Networks implements VLANs using the VXLAN protocol that relies on a UDP encapsulation and IP multicast.

* :ref:`Open vSwitch <openvswitch>`. Similar to the VLAN mode but using an openvswitch instead of a Linux bridge.

When you create a new network you will need to add the attribute ``VN_MAD`` to the template, specifying which of the above networking modes you want to use.

.. note::

    Security Groups are not supported by the Open vSwitch mode.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Storage <storage>` chapter.

Read the specific section for the networking mode that you are interested in.

After reading this chapter you can complete your OpenNebula installation by optionally enabling an :ref:`External Authentication <authentication>` or configuring :ref:`Sunstone <sunstone>`. Otherwise you are ready to :ref:`Operate your Cloud <operation_guide>`.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.
