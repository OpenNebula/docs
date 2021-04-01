.. _hm-vlan:

================================================================================
802.1Q VLAN Networks
================================================================================

This guide describes how to enable network isolation provided through Host-managed VLANs. This driver will create a bridge for each OpenNebula Virtual Network and attach a VLAN tagged network interface to the bridge. This mechanism is compliant with `IEEE 802.1Q <http://en.wikipedia.org/wiki/IEEE_802.1Q>`__.

The VLAN ID will be the same for every interface in a given network, automatically computed by OpenNebula. It may also be forced by specifying a ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

OpenNebula Configuration
================================================================================

The VLAN ID is calculated according to this configuration option of :ref:`/etc/one/oned.conf <oned_conf>`:

.. code::

    #  VLAN_IDS: VLAN ID pool for the automatic VLAN_ID assigment. This pool
    #  is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver
    #  will try first to allocate VLAN_IDS[START] + VNET_ID
    #     start: First VLAN_ID to use
    #     reserved: Comma separated list of VLAN_IDs or ranges. Two numbers
    #     separated by a colon indicate a range.

    VLAN_IDS = [
        START    = "2",
        RESERVED = "0, 1, 4095"
    ]

By modifying this section, you can reserve some VLANs so they aren't assigned to a Virtual Network. You can also define the first VLAN ID. When a new isolated network is created, OpenNebula will find a free VLAN ID from the VLAN pool. This pool is global and it's also shared with the :ref:`Open vSwitch Networks <openvswitch>` network mode.

The following configuration parameters can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------------+-------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                           |
+========================+=======================================================================================================+
| ``:validate_vlan_id``  | Set to ``true`` to check that no other VLANs are connected to the bridge                              |
+------------------------+-------------------------------------------------------------------------------------------------------+
| ``:keep_empty_bridge`` | Set to ``true`` to preserve bridges with no virtual interfaces left.                                  |
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

.. _hm-vlan_net:

Defining 802.1Q Network
================================================================================

To create an 802.1Q network, include the following information in the template:

+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
|       Attribute       |                                       Value                                                |               Mandatory                |
+=======================+============================================================================================+========================================+
| ``VN_MAD``            | Set ``802.1Q``                                                                             | **YES**                                |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
| ``PHYDEV``            | Name of the physical network device that will be attached to the bridge.                   | **YES**                                |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
| ``BRIDGE``            | Name of the Linux bridge, defaults to ``onebr<net_id>`` or ``onebr.<vlan_id>``             | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
| ``VLAN_ID``           | The VLAN ID, will be generated if not defined and ``AUTOMATIC_VLAN_ID=YES``                | **YES** (unless ``AUTOMATIC_VLAN_ID``) |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
| ``AUTOMATIC_VLAN_ID`` | Mandatory and must be set to ``YES`` if ``VLAN_ID`` hasn't been defined                    | **YES** (unless ``VLAN_ID``)           |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+
| ``MTU``               | The MTU for the tagged interface and bridge                                                | NO                                     |
+-----------------------+--------------------------------------------------------------------------------------------+----------------------------------------+

For example, you can define a *802.1Q Network* with the following template:

.. code::

    NAME    = "private2"
    VN_MAD  = "802.1Q"
    PHYDEV  = "eth0"
    BRIDGE  = "br0"         # Optional
    VLAN_ID = 50            # Optional. If not setting VLAN_ID set AUTOMATIC_VLAN_ID = "YES"

In this example, the driver will check for the existence of the ``br0`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.50``) and attached to ``br0`` (unless it's already attached).
