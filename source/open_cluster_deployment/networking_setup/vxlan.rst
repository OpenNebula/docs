.. _vxlan:

================================================================================
VXLAN Networks
================================================================================

This guide describes how to enable Network isolation provided through the VXLAN encapsulation protocol. This driver will create a bridge for each OpenNebula Virtual Network and attach a VXLAN tagged network interface to the bridge.

The VXLAN ID will be the same for every interface in a given network, calculated automatically by OpenNebula. It may also be forced by setting the ``VLAN_ID`` attribute in the :ref:`Virtual Network template <vnet_template>`.

Additionally, each VXLAN has an associated multicast address to encapsulate L2 broadcast and multicast traffic. By default, the address assigned will belong to the ``239.0.0.0/8`` range as defined by RFC 2365 (Administratively Scoped IP Multicast). The multicast address is obtained by adding the value of the attribute ``VLAN_ID`` to ``239.0.0.0/8`` base address.

Considerations & Limitations
================================================================================

This driver works with the default UDP server port 8472.

VXLAN traffic is forwarded to a physical device; this device can be set (optionally) to be a VLAN tagged interface, but in that case you must make sure that the tagged interface is manually created first in all the Hosts.

.. important::

    The network interface that will act as the physical device **must** have an IP.

Limited Count of VXLANs on Host
--------------------------------------------------------------------------------

Each VXLAN is associated with one multicast group. There is a limit on how many multicast groups can be a physical Host member of at the same time, which also means how many **different** VXLANs can be used on a physical Host concurrently. The default value is 20 and can be changed via ``sysctl`` through the kernel runtime parameter ``net.ipv4.igmp_max_memberships``.

For permanent change to e.g. 150, place the following settings inside the ``/etc/sysctl.conf``:

.. code::

    net.ipv4.igmp_max_memberships=150

and reload the configuration

.. prompt:: bash # auto

    # sysctl -p

OpenNebula Configuration
================================================================================

It is possible specify the start VXLAN ID by configuring :ref:`/etc/one/oned.conf <oned_conf>`:

.. code:: bash

    # VXLAN_IDS: Automatic VXLAN Network ID (VNI) assigment. This is used
    # for vxlan networks.
    #     start: First VNI to use

    VXLAN_IDS = [
        START = "2"
    ]

The following configuration parameters can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------------+-------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                           |
+========================+=======================================================================================================+
| ``:vxlan_mc``          | Base multicast address for each VLAN. The multicas address is vxlan_mc + vlan_id                      |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:vxlan_ttl``         | Time To Live (TTL) should be > 1 in routed multicast networks (IGMP)                                  |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:validate_vlan_id``  | Set to true to check that no other VLANs are connected to the bridge                                  |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:keep_empty_bridge`` | Set to true to preserve bridges with no virtual interfaces left.                                      |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:ip_bridge_conf``    | *(Hash)* Options passed to ``ip`` cmd. on bridge create (``ip link add <bridge> type bridge ...``)    |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:ip_link_conf``      | *(Hash)* Options passed to ``ip`` cmd. on VLAN interface create (``ip link add``)                     |
+------------------------+-------------------------------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync -f`` to synchonize the changes to all the nodes.

Example:

.. code::

    # Following options will be added when creating bridge. For example:
    #
    #     ip link add name <bridge name> type bridge stp_state 1
    #
    # :ip_bridge_conf:
    #     :stp_state: on


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

To create a VXLAN network, include the following information in the template:

+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
|       Attribute       |                                     Value                                            | Mandatory                              |
+=======================+======================================================================================+========================================+
| ``VN_MAD``            | Set ``vxlan``                                                                        | **YES**                                |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``PHYDEV``            | Name of the physical network device that will be attached to the bridge.             | **YES**                                |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``BRIDGE``            | Name of the linux bridge, defaults to onebr<net_id> or onebr.<vlan_id>               | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``VLAN_ID``           | The VXLAN ID, will be generated if not defined and ``AUTOMATIC_VLAN_ID=YES``         | **YES** (unless ``AUTOMATIC_VLAN_ID``) |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``AUTOMATIC_VLAN_ID`` | Mandatory and must be set to ``YES`` if ``VLAN_ID`` hasn't been defined              | **YES** (unless ``VLAN_ID``)           |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``MTU``               | The MTU for the tagged interface and bridge                                          | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``VXLAN_MODE``        | Multicast protocol for multi destination BUM traffic:``evpn`` or ``multicast``       | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``VXLAN_TEP``         | Tunnel endpoint communication type (only for ``evpn``): ``dev`` or ``local_ip``      | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``VXLAN_MC``          | Base multicast address for each VLAN. The MC address is ``:vxlan_mc`` + ``:vlan_id`` | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+
| ``IP_LINK_CONF``      | Options passed to ``ip`` cmd. on operations specific to this Virtual Network.        | NO                                     |
|                       | Syntax: ``IP_LINK_CONF="option1=value1,option2=,option3=value3,..."``                |                                        |
+-----------------------+--------------------------------------------------------------------------------------+----------------------------------------+

.. note:: ``VXLAN_MODE``, ``VXLAN_TEP`` and ``VXLAN_MC`` can be defined system-wide in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``. To use per network configuration you may need the ``IP_LINK_CONF`` attribute.

For example, you can define a *VXLAN Network* with the following template:

.. code::

    NAME    = "private3"
    VN_MAD  = "vxlan"
    PHYDEV  = "eth0"
    VLAN_ID = 50            # Optional
    BRIDGE  = "vxlan50"     # Optional

In this example, the driver will check for the existence of the ``vxlan50`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.50``) and attached to ``vxlan50`` (unless it's already attached). Note that ``eth0`` can be a 802.1Q tagged interface, if you want to isolate the VXLAN traffic by 802.1Q VLANs.

Using VXLAN with BGP EVPN
================================================================================

By default, VXLAN relies on multicast to discover tunnel endpoints; alternatively you can use MP-BGP EVPN for the control plane and hence increase the scalability of your network. This section describes the main configuration steps to deploy such a setup.

Configuring the Hypervisors
--------------------------------------------------------------------------------
The hypervisor needs to run a BGP EVPN capable routing software like `FFRouting (FRR) <https://frrouting.org/>`_. Its main purpose is to send BGP updates with the MAC address and IP (optional) for each VXLAN tunnel endpoint (i.e. the VM interfaces in the VXLAN network) running in the Host. The updates need to be distributed to all other hypervisors in the cloud to achieve full route reachability. This second step is usually performed by one or more BGP route reflectors.

As an example, consider two hypervisors ``10.4.4.11`` and ``10.4.4.12``, and a route reflector at ``10.4.4.13``. The FRR configuration file for the hypervisors could be (to be announced to all VXLAN networks):

.. code::

   router bgp 7675
    bgp router-id 10.4.4.11
    no bgp default ipv4-unicast
    neighbor 10.4.4.13 remote-as 7675
    neighbor 10.4.4.13  capability extended-nexthop
    address-family l2vpn evpn
     neighbor 10.4.4.13 activate
     advertise-all-vni
    exit-address-family
   exit

And the reflector for our AS 7675 and hypervisors in ``10.4.4.0/24``:

.. code::

   router bgp 7675
     bgp router-id 10.4.4.13
     bgp cluster-id 10.4.4.13
     no bgp default ipv4-unicast
     neighbor kvm_hosts peer-group
     neighbor kvm_hosts remote-as 7675
     neighbor kvm_hosts capability extended-nexthop
     neighbor kvm_hosts update-source 10.4.4.13
     bgp listen range 10.4.4.0/24 peer-group kvm_hosts
     address-family l2vpn evpn
      neighbor fabric activate
      neighbor fabric route-reflector-client
     exit-address-family
   exit

Note that this a simple scenario using the same configuration for all the VNIs. Once the routing software is configured you should see the updates in each hypervisor for the VMs running in it, for example:

.. code::

   10.4.4.11# show bgp evpn route
      Network          Next Hop            Metric LocPrf Weight Path
   Route Distinguisher: 10.4.4.11:2
   *> [2]:[0]:[0]:[48]:[02:00:0a:03:03:c9]
                       10.4.4.11                          32768 i
   *> [3]:[0]:[32]:[10.4.4.11]
                      10.4.4.11                           32768 i
   Route Distinguisher: 10.4.4.12:2
   *>i[2]:[0]:[0]:[48]:[02:00:0a:03:03:c8]
                      10.4.4.12                0    100      0 i
   *>i[3]:[0]:[32]:[10.4.4.12]
                      10.4.4.12                0    100      0 i

Configuring OpenNebula
--------------------------------------------------------------------------------

You need to update the ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf`` file by:

1. Setting BGP EVPN as the control plane for your BUM traffic, ``:vxlan_mode``.
2. Selecting the hypervisor that is going to send the traffic to the VTEP. This can be either ``dev``, to forward the traffic through the ``PHY_DEV`` interface defined in the Virtual Network template, or ``local_ip`` to route the traffic using the first IP configured in ``PHY_DEV``.
3. Finally, you may want to add the nolearning option to the VXLAN link.

.. code::

   # Multicast protocol for multi destination BUM traffic. Options:
   #   - multicast, for IP multicast
   #   - evpn, for BGP EVPN control plane
   :vxlan_mode: evpn

   # Tunnel endpoint communication type. Only for evpn vxlan_mode.
   #   - dev, tunnel endpoint communication is sent to PHYDEV
   #   - local_ip, first ip addr of PHYDEV is used as address for the communiation
   :vxlan_tep: local_ip

   # Additional ip link options, uncomment the following to disable learning for
   # EVPN mode
   :ip_link_conf:
       :nolearning:

After updating the configuration file on the Front-end, don't forget to execute ``onehost sync -f`` to distribute the changes on the hypervisor nodes.

.. note::

    It is not recommended to set ``:nolearing:`` in ``:ip_link_conf:`` system-wide attribute in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf`` because that doesn't allow the coexistence of VLAN and VXLAN with BGP EVPN Virtual Networks on Hosts. For VXLAN with BGP EVPN, set ``IP_LINK_CONF="nolearning="`` attribute in the Virtual Network definition instead.
