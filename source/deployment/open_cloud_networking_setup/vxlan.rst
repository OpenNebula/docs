.. _vxlan:

================================================================================
VXLAN Networks
================================================================================

This guide describes how to enable Network isolation provided through the VXLAN encapsulation protocol. This driver will create a bridge for each OpenNebula Virtual Network and attach a VXLAN tagged network interface to the bridge.

The VLAN id will be the same for every interface in a given network, calculated automatically by OpenNebula. It may also be forced by specifying an VLAN_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

Additionally each VLAN has associated a multicast address to encapsulate L2 broadcast and multicast traffic. This address is assigned by default to the 239.0.0.0/8 range as defined by RFC 2365 (Administratively Scoped IP Multicast). In particular the multicast address is obtained by adding the VLAN_ID to the 239.0.0.0/8 base address.


Considerations & Limitations
================================================================================

This driver works with the default UDP server port 8472.

VXLAN traffic is forwarded to a physical device, this device can be set (optionally) to be a VLAN tagged interface, but in that case you must make sure that the tagged interface is manually created first in all the hosts.

The physical device that will act as the physical device **must** have an IP.

Concurrent VXLANs host limit
--------------------------------------------------------------------------------

Each VXLAN is associated with one multicast group. There is a limit on how many multicast groups can be a physical host member of at the same time. That also means, how many **different** VXLANs can be used on a physical host concurrently. The default value is 20 and can be changed via ``sysctl`` through kernel runtime parameter ``net.ipv4.igmp_max_memberships``.

For permanent change to e.g. 150, place following settings inside the ``/etc/sysctl.conf``:

.. code::

    net.ipv4.igmp_max_memberships=150

and reload the configuration

.. prompt:: bash $ auto

    $ sudo sysctl -p

OpenNebula Configuration
================================================================================

It is possible specify the start VLAN ID by configuring ``/etc/one/oned.conf``:

.. code:: bash

    # VXLAN_IDS: Automatic VXLAN Network ID (VNI) assigment. This is used
    # for vxlan networks.
    #     start: First VNI to use

    VXLAN_IDS = [
        START = "2"
    ]

The following configuration attributes can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------+----------------------------------------------------------------------------------+
| Parameter        | Description                                                                      |
+==================+==================================================================================+
| vxlan_mc         | Base multicast address for each VLAN. The multicas sddress is vxlan_mc + vlan_id |
+------------------+----------------------------------------------------------------------------------+
| vxlan_ttl        | Time To Live (TTL) should be > 1 in routed multicast networks (IGMP)             |
+------------------+----------------------------------------------------------------------------------+
| validate_vlan_id | Set to true to check that no other vlans are connected to the bridge             |
+------------------+----------------------------------------------------------------------------------+
| bridge_conf      | *Hash* Options for ``brctl``                                                     |
+------------------+----------------------------------------------------------------------------------+
| ip_link_conf     | *Hash* Arguments passed to ``ip link add``                                       |
+------------------+----------------------------------------------------------------------------------+

Example:

.. code::

	# These options will execute brctl commands with these values. For example,
	# this option will execute:
	#
	#     brctl stp <bridge name> on
	#
	:bridge_conf:
	    :stp: on

	# These options will be added to the ip link add command. For example:
	#
	#     sudo ip link add lxcbr0.260  type vxlan id 260 group 239.0.101.4 \
	#       ttl 16 dev lxcbr0 udp6zerocsumrx  tos 3
	#
	:ip_link_conf:
	    :udp6zerocsumrx:
	    :tos: 3


.. _vxlan_net:

Defining a VXLAN Network
=========================

To create a VXLAN network include the following information:

+-------------+-------------------------------------------------------------------------+-----------+
| Attribute   | Value                                                                   | Mandatory |
+=============+=========================================================================+===========+
| **VN_MAD**  | vxlan                                                                   |  **YES**  |
+-------------+-------------------------------------------------------------------------+-----------+
| **PHYDEV**  | Name of the physical network device that will be attached to the bridge.|  **YES**  |
+-------------+-------------------------------------------------------------------------+-----------+
| **BRIDGE**  | Name of the linux bridge, defaults to onebr<net_id> or onebr.<vlan_id>  |  NO       |
+-------------+-------------------------------------------------------------------------+-----------+
| **VLAN_ID** | The VLAN ID, will be generated if not defined                           |  NO       |
+-------------+-------------------------------------------------------------------------+-----------+
| **MTU**     | The MTU for the tagged interface and bridge                             |  NO       |
+-------------+-------------------------------------------------------------------------+-----------+

The following example defines a VXLAN network

.. code::

    NAME    = "vxlan_net"
    VN_MAD  = "vxlan"
    PHYDEV  = "eth0"
    VLAN_ID = 50        # optional
    BRIDGE  = "vxlan50" # optional
    ...

In this scenario, the driver will check for the existence of the ``vxlan50`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.50``) and attached to ``vxlan50`` (unless it's already attached). Note that eth0 can be a 802.1Q tagged interface if you want to isolate the OpenNebula VXLAN traffic.


