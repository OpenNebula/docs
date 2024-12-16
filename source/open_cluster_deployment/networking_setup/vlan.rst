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

.. note:: Remember to run ``onehost sync -f`` to synchronize the changes to all the nodes.

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

Using 802.1Q driver with Q-in-Q
================================================================================

Q-in-Q is not natively supported by Linux bridges, as compared to Open vSwitch, and presents some limitations:

- The service VLAN tag (also referred as transport or outer) cannot be preserved in the VMs,
- The bridge cannot be fully configured using both VLAN tags.

However, for the most common scenarios the 802.1Q driver can produce the double tag and filter out VLANs not included in the customer VLAN set. In this configuration the bridge works as follow:

- Untagged traffic from the VM will be tagged using the transport VLAN.
- Tagged traffic from the VM using the CVLANS will be also tagged with the transport VLAN.
- Tagged traffic from the VM using any other VLAN ID will be discarded.

.. note::

   When ``CVLANS`` is not configured the bridge will add the VLAN ID tag to any traffic comming from the VM (tagged or not). There is no filtering of the VLAN IDs used by the VM.

OpenNebula Configuration
------------------------

There is no configuration specific for this use case, just consider the general options specified above.

Defining a Q-in-Q Network
----------------------------------------

The Q-in-Q behavior is controlled by the following attributes (**please, also refer to the attributes defined above**):

+-----------------------+----------------------------------------------------------------+----------------------------------------+
|       Attribute       |                                       Value                    |               Mandatory                |
+=======================+================================================================+========================================+
| ``VLAN_ID``           | The VLAN ID for the transport/outer VLAN.                      | **YES** (unless ``AUTOMATIC_VLAN_ID``) |
+-----------------------+----------------------------------------------------------------+----------------------------------------+
| ``CVLANS``            | The customer VLAN set. A comma separated list, supports ranges | **YES**                                |
+-----------------------+----------------------------------------------------------------+----------------------------------------+

For example, you can define an *QinQ aware Network* with the following template:

.. code::

    NAME     = "qinq_net"
    VN_MAD   = "802.1Q"
    PHYDEV   = eth0
    VLAN_ID  = 50                 # Service VLAN ID
    CVLANS   = "101,103,110-113"  # Customer VLAN ID list

.. note::

   ``CVLANS`` can be updated and will be dynamically reconfigured in any existing bridge

Implementation Details
----------------------

When the ``CVLANS`` attribute is defined the 802.1Q perform the following configurations on the bridge:

- Activate the VLAN filtering flag
- Installs a VLAN filter that includes all the VLANs in the ``CVLANS`` set in all VM ports in the network. In this way only tagged traffic in the customer set will be allowed in the bridge.
- All untagged traffic is associated to the transport (outer) VLAN.
- As in the other configurations, a tagged link for the transport VLAN is added to the bridge. This link is the one that will add the transport tag.

The following example shows the main configurations performed in the bridge:

.. code::

    # - Transport / outer / S-VLAN : 100
    # - Customer / inner / C-VLAN  : 200,300

    # "Transport" link
    ip link add link eth1 name eth1.100 type vlan id 100
    ip link set eth1.100 master onebr.23
    ip link set eth1.100 up

    # Bridge Configuration:
    ip link set dev onebr.23 type bridge vlan_filtering 1

    # VM port configuration (NIC 1 of VM 20, and transport link):
    bridge vlan add dev one-20-1 vid 100 pvid untagged
    bridge vlan add dev one-20-1 vid 200
    bridge vlan add dev one-20-1 vid 300

    bridge vlan add dev eth1.100 vid 100 pvid untagged
    bridge vlan add dev eth1.100 vid 200
    bridge vlan add dev eth1.100 vid 300

