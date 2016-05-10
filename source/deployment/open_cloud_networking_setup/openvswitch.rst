.. _openvswitch:

=============
Open vSwitch
=============

.. todo:: this guide must be reviewed because of the deprecation of black_ports

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ network drives. They provide two independent functionalities that can be used together: network isolation using VLANs, and network filtering using OpenFlow. Each Virtual Network interface will receive a VLAN tag enabling network isolation. Other traffic attributes that may be configured through Open vSwitch are not modified.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

.. warning:: This driver is not compatible with Security Groups.

Requirements
============

This driver requires Open vSwitch to be installed on each OpenNebula Host. Follow the resources specified in :ref:`hosts configuration <openvswitch_hosts_configuration>` to install it.

Considerations & Limitations
============================

Integrating OpenNebula with Open vSwitch brings a long list of benefits to OpenNebula, read `Open vSwitch Features <http://openvswitch.org/features/>`__ to get a hold on these features.

This guide will address the usage of VLAN tagging and OpenFlow filtering of OpenNebula Virtual Machines. On top of that any other Open vSwitch feature may be used, but that's outside of the scope of this guide.

Configuration
=============

OpenNebula Configuration
------------------------

The VLAN_ID is calculated according to this configuration option of ``oned.conf``:

.. code:: bash

    #  VLAN_IDS: VLAN ID pool for the automatic VLAN_ID assigment. This pool
    #  is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver
    #  will try first to allocate VLAN_IDS[START] + VNET_ID
    #     start: First VLAN_ID to use
    #     reserved: Comma separated list of VLAN_IDs

    VLAN_IDS = [
        START    = "2",
        RESERVED = "0, 1, 4095"
    ]

By modifying that parameter you can reserve some VLANs so they aren't assigned to a Network. You can also define the first VLAN_ID. When a new isolatad network is created, OpenNebula will find a free VLAN_ID from the VLAN pool. This pool is global, and it's also shared with the :ref:`802.1Q <hm-vlan>` driver.

.. warning::

    A reserved VLAN_ID will be reserved forever, even if you remove it from the list, it will still be reserved. There is no mechanism to un-reserve a VLAN_ID.

.. _openvswitch_hosts_configuration:

Hosts Configuration
-------------------

You need to install Open vSwitch on each OpenNebula Host. Please refer to the `Open vSwitch documentation <https://github.com/openvswitch/ovs/blob/master/INSTALL.md>`__ to do so.

Open vSwitch Options
--------------------

.. _openvswitch_arp_cache_poisoning:

It is possible to disable the ARP Cache Poisoning prevention rules by changing this snippet in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``:

.. code::

    # Enable ARP Cache Poisoning Prevention Rules
    :arp_cache_poisoning: true



Driver Actions
--------------

+-----------+--------------------------------------------------------------------------------------------------------------+
|   Action  |                                                 Description                                                  |
+===========+==============================================================================================================+
| **Pre**   | N/A                                                                                                          |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Post**  | Performs the appropriate Open vSwitch commands to tag the virtual tap interface.                             |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The virtual tap interfaces will be automatically discarded when the VM is shut down. |
+-----------+--------------------------------------------------------------------------------------------------------------+

Multiple VLANs (VLAN trunking)
------------------------------

VLAN trunking is also supported by adding the following tag to the ``NIC`` element in the VM template or to the virtual network template:

-  ``VLAN_TAGGED_ID``: Specify a range of VLANs to tag, for example: ``1,10,30,32``.

.. _openvswitch_different_bridge:

Usage
=====

To use this driver, use **VN_MAD="ovswitch"** in the Network Template.

.. code::

    NAME    = "ovswitch_net"
    VN_MAD  = "ovswitch"
    BRIDGE  = vbr1
    VLAN_ID = 50 # optional
    ...

Network Filtering
-----------------

The first rule that is always applied when using the Open vSwitch drivers is the MAC-spoofing rule, that prevents any traffic coming out of the VM if the user changes the MAC address.

The firewall directives must be placed in the :ref:`network section <template_network_section>` of the Virtual Machine template. These are the possible attributes:

* ``BLACK_PORTS_TCP = iptables_range``: Doesn't permit access to the VM through the specified ports in the TCP protocol.
* ``BLACK_PORTS_UDP = iptables_range``: Doesn't permit access to the VM through the specified ports in the UDP protocol.
* ``ICMP = drop``: Blocks ICMP connections to the VM. By default it's set to accept.

``iptables_range``: a list of ports separated by commas, e.g.: ``80,8080``. Currently no ranges are supported, e.g.: ``5900:6000`` is **not** supported.

Example:

.. code::

    NIC = [ NETWORK_ID = 3, BLACK_PORTS_TCP = "80, 22", ICMP = drop ]

Tuning & Extending
==================

Remember to sync any changes to the hosts by running ``onehost sync`` and to backup the changes in order to re-apply them after upgrading to a new release of OpenNebula.

OpenFlow Rules
--------------

To modify these rules you have to edit: ``/var/lib/one/remotes/vnm/ovswitch/OpenvSwitch.rb``.

**Mac-spoofing**

These rules prevent any traffic to come out of the port the MAC address has changed.

.. code::

    in_port=<PORT>,dl_src=<MAC>,priority=40000,actions=normal
    in_port=<PORT>,priority=39000,actions=normal

**IP hijacking**

These rules prevent any traffic to come out of the port for IPv4 IP's not configured for a VM

.. code::

    in_port=<PORT>,arp,dl_src=<MAC>priority=45000,actions=drop
    in_port=<PORT>,arp,dl_src=<MAC>,nw_src=<IP>,priority=46000,actions=normal

**Black ports (one rule per port)**

.. code::

    tcp,dl_dst=<MAC>,tp_dst=<PORT>,actions=drop

**ICMP Drop**

.. code::

    icmp,dl_dst=<MAC>,actions=drop

