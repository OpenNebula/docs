.. _openvswitch:

================================================================================
Open vSwitch Networks
================================================================================

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ network drives. They provide network isolation using VLANs by tagging ports and basic network filtering using OpenFlow. Other traffic attributes that may be configured through Open vSwitch are not modified.

The VLAN id will be the same for every interface in a given network, calculated automatically by OpenNebula. It may also be forced by specifying an ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

.. warning:: This driver is not compatible with Security Groups.

OpenNebula Configuration
================================================================================

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

By modifying that parameter you can reserve some VLANs so they aren't assigned to a Virtual Network. You can also define the first VLAN_ID. When a new isolatad network is created, OpenNebula will find a free VLAN_ID from the VLAN pool. This pool is global, and it's also shared with the :ref:`802.1Q VLAN <hm-vlan>` network mode.

The following configuration attributes can be adjusted in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``:

+---------------------+----------------------------------------------------------------------------------+
|      Parameter      |                                   Description                                    |
+=====================+==================================================================================+
| arp_cache_poisoning | Enable ARP Cache Poisoning Prevention Rules.                                     |
+---------------------+----------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync`` to deploy the file to all the nodes.

.. _ovswitch_net:

Defining an Open vSwitch Network
================================================================================

To create a VXLAN network include the following information:

+-------------+-------------------------------------------------------------------------+-----------+
| Attribute   | Value                                                                   | Mandatory |
+=============+=========================================================================+===========+
| **VN_MAD**  | ovswitch                                                                |  **YES**  |
+-------------+-------------------------------------------------------------------------+-----------+
| **BRIDGE**  | Name of the Open vSwitch switch to use                                  |  **YES**  |
+-------------+-------------------------------------------------------------------------+-----------+
| **VLAN_ID** | The VLAN ID, will be generated if not defined                           |  NO       |
+-------------+-------------------------------------------------------------------------+-----------+

The following example defines a VXLAN network

.. code::

    NAME    = "ovswitch_net"
    VN_MAD  = "ovswitch"
    BRIDGE  = vbr1
    VLAN_ID = 50 # optional
    ...

Multiple VLANs (VLAN trunking)
------------------------------

VLAN trunking is also supported by adding the following tag to the ``NIC`` element in the VM template or to the virtual network template:

-  ``VLAN_TAGGED_ID``: Specify a range of VLANs to tag, for example: ``1,10,30,32``.


OpenFlow Rules
================================================================================

This section lists de default openflow rules installed in the open vswitch.

Mac-spoofing
--------------------------------------------------------------------------------

These rules prevent any traffic to come out of the port the MAC address has changed.

.. code::

    in_port=<PORT>,dl_src=<MAC>,priority=40000,actions=normal
    in_port=<PORT>,priority=39000,actions=normal

IP hijacking
--------------------------------------------------------------------------------

These rules prevent any traffic to come out of the port for IPv4 IP's not configured for a VM

.. code::

    in_port=<PORT>,arp,dl_src=<MAC>priority=45000,actions=drop
    in_port=<PORT>,arp,dl_src=<MAC>,nw_src=<IP>,priority=46000,actions=normal

Black ports (one rule per port)
--------------------------------------------------------------------------------

.. code::

    tcp,dl_dst=<MAC>,tp_dst=<PORT>,actions=drop

ICMP Drop
--------------------------------------------------------------------------------

.. code::

    icmp,dl_dst=<MAC>,actions=drop
