.. _vnet_template:

========================
Virtual Network Template
========================

This page describes how to define a new Virtual Network. A Virtual Network includes three different aspects:

* Physical network attributes.
* Address Range.
* Configuration attributes for the guests.

When writing a Virtual Network template in a file just follows the same syntax as the :ref:`VM template <template>`.

Physical Network Attributes
================================================================================

It defines the **underlying networking infrastructure** that will support the Virtual Network, such as the ``VLAN ID`` or the hypervisor interface to bind the Virtual Network.

+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| Attribute              | Description                                      | Value    | Mandatory                        | Drivers  |
+========================+==================================================+==========+==================================+==========+
| ``NAME``               | Name of the Virtual Network.                     | String   | **YES**                          | All      |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| ``VN_MAD``             | The network driver to implement the network.     | 802.1Q   | **YES**                          | All      |
|                        |                                                  | ebtables |                                  |          |
|                        |                                                  | fw       |                                  |          |
|                        |                                                  | ovswitch |                                  |          |
|                        |                                                  | vxlan    |                                  |          |
|                        |                                                  | vcenter  |                                  |          |
|                        |                                                  | dummy    |                                  |          |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| ``BRIDGE``             | Device to attach the virtual machines to,        | String   | ``YES`` for dummy, ovswitch,     | dummy    |
|                        | depending on the network driver it may refer to  |          | ebtables, fw and vcenter         | 802.1Q   |
|                        | different technologies or require host setups.   |          |                                  | vxlan    |
|                        |                                                  |          |                                  | ovswitch |
|                        |                                                  |          |                                  | ebtables |
|                        |                                                  |          |                                  | fw       |
|                        |                                                  |          |                                  | vcenter  |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| ``VLAN_ID``            | Identifier for the VLAN.                         | Integer  | ``YES`` unless                   | 802.1Q   |
|                        |                                                  |          | ``AUTOMATIC_VLAN_ID`` for 802.1Q | vxlan    |
|                        |                                                  |          |                                  | ovswitch |
|                        |                                                  |          |                                  | vcenter  |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| ``AUTOMATIC_VLAN_ID``  | If set to YES, OpenNebula will generate a VLAN ID| String   | ``YES`` unless ``VLAN_ID``       | 802.1Q   |
|                        | automatically if VLAN_ID is not defined.         |          | for 802.1Q                       | vxlan    |
|                        | Mandatory YES for 802.1Q if VLAN_ID is not       |          |                                  | ovswitch |
|                        | defined, optional otherwise.                     |          |                                  | vcenter  |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+
| ``PHYDEV``             | Name of the physical network device that will be | String   | ``YES``                          | 802.1Q   |
|                        | attached to the bridge.                          |          |                                  | vxlan    |
|                        |                                                  |          | Optional for vCenter             | vcenter  |
+------------------------+--------------------------------------------------+----------+----------------------------------+----------+

You have more information about the attributes used by the vCenter network driver in the :ref:`vCenter Network Overview <vcenter_network_attributes>` section.

Quality of Service Attributes
================================================================================

.. _vnet_template_qos:

This set of attributes limit the bandwidth of each NIC attached to the Virtual Network. Note that the limits are applied to each NIC individually and are not averaged over all the NICs (e.g. a VM with two interfaces in the same network).

+----------------------+-----------------------------------------------------------------------------+--------------------+
| Attribute            | Description                                                                 | Drivers            |
+======================+=============================================================================+====================+
| ``INBOUND_AVG_BW``   | Average bitrate for the interface in kilobytes/second for inbound traffic.  | All                |
+----------------------+-----------------------------------------------------------------------------+--------------------+
| ``INBOUND_PEAK_BW``  | Maximum bitrate for the interface in kilobytes/second for inbound traffic.  | All                |
+----------------------+-----------------------------------------------------------------------------+--------------------+
| ``INBOUND_PEAK_KB``  | Data that can be transmitted at peak speed in kilobytes.                    | All except vCenter |
+----------------------+-----------------------------------------------------------------------------+--------------------+
| ``OUTBOUND_AVG_BW``  | Average bitrate for the interface in kilobytes/second for outbound traffic. | All except ovswitch|
+----------------------+-----------------------------------------------------------------------------+--------------------+
| ``OUTBOUND_PEAK_BW`` | Maximum bitrate for the interface in kilobytes/second for outbound traffic. | All except ovswitch|
+----------------------+-----------------------------------------------------------------------------+--------------------+
| ``OUTBOUND_PEAK_KB`` | Data that can be transmitted at peak speed in kilobytes.                    | All except vCenter |
|                      |                                                                             | and ovswitch       |
+----------------------+-----------------------------------------------------------------------------+--------------------+

.. warning:: For Outbound QoS when using Open vSwitch, you can leverage the `Open vSwitch QoS <https://docs.openvswitch.org/en/latest/faq/qos/>`__ capabilities.


The Address Range
================================================================================

.. _vnet_template_ar4:

IPv4 Address Range
--------------------------------------------------------------------------------

+-------------+-----------------------------------------------------+-----------+
| Attribute   | Description                                         | Mandatory |
+=============+=====================================================+===========+
| ``TYPE``    | ``IP4``                                             | **YES**   |
+-------------+-----------------------------------------------------+-----------+
| ``IP``      | First ``IP`` in the range in dot notation.          | **YES**   |
+-------------+-----------------------------------------------------+-----------+
| ``MAC``     | First ``MAC``, if not provided it will be           | **NO**    |
|             | generated using the ``IP`` and the ``MAC_PREFIX``   |           |
|             | in ``oned.conf``.                                   |           |
+-------------+-----------------------------------------------------+-----------+
| ``SIZE``    | Number of addresses in this range.                  | **YES**   |
+-------------+-----------------------------------------------------+-----------+

.. _vnet_template_ar6:

IPv6 Address Range
--------------------------------------------------------------------------------

+-------------------+------------------------------------------------------+-----------+
| Attribute         | Description                                          | Mandatory |
+===================+======================================================+===========+
| ``TYPE``          | ``IP6``                                              | **YES**   |
+-------------------+------------------------------------------------------+-----------+
| ``MAC``           | First ``MAC``, if not provided it will be generated. | **NO**    |
+-------------------+------------------------------------------------------+-----------+
| ``GLOBAL_PREFIX`` | A ``/64`` globally routable prefix.                  | **NO**    |
+-------------------+------------------------------------------------------+-----------+
| ``ULA_PREFIX``    | A ``/64`` unique local address (ULA)                 | **NO**    |
|                   | prefix corresponding to the ``fd00::/8`` block.      |           |
+-------------------+------------------------------------------------------+-----------+
| ``SIZE``          | Number of addresses in this range.                   | **YES**   |
+-------------------+------------------------------------------------------+-----------+


.. _vn_template_ar6_nslaac:

IPv6 Address Range (no-SLAAC)
--------------------------------------------------------------------------------

+-------------------+------------------------------------------------------+-----------+
| Attribute         | Description                                          | Mandatory |
+===================+======================================================+===========+
| ``TYPE``          | ``IP6_STATIC``                                       | **YES**   |
+-------------------+------------------------------------------------------+-----------+
| ``MAC``           | First ``MAC``, if not provided it will be generated. | **NO**    |
+-------------------+------------------------------------------------------+-----------+
| ``IP6``           | First ``IP6`` (full 128 bits) in the range .         | **YES**   |
+-------------------+------------------------------------------------------+-----------+
| ``PREFIX_LENGTH`` | Length of the prefix to configure VM interfaces.     | **YES**   |
+-------------------+------------------------------------------------------+-----------+
| ``SIZE``          | Number of addresses in this range.                   | **YES**   |
+-------------------+------------------------------------------------------+-----------+

.. _vnet_template_ar46:

Dual IPv4-IPv6 Address Range
--------------------------------------------------------------------------------

For the IPv6 SLAAC version the following attributes are supported:

+-------------------+-----------------------------------------------------+-----------+
| Attribute         | Description                                         | Mandatory |
+===================+=====================================================+===========+
| ``TYPE``          | ``IP4_6``                                           | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``IP``            | First IPv4 in the range in dot notation.            | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``MAC``           | First ``MAC``, if not provided it will be           | **NO**    |
|                   | generated using the ``IP`` and the ``MAC_PREFIX``   |           |
|                   | in ``oned.conf``.                                   |           |
+-------------------+-----------------------------------------------------+-----------+
| ``GLOBAL_PREFIX`` | A ``/64`` globally routable prefix.                 | **NO**    |
+-------------------+-----------------------------------------------------+-----------+
| ``ULA_PREFIX``    | A ``/64`` unique local address (ULA)                | **NO**    |
|                   | prefix corresponding to the ``fd00::/8`` block      |           |
+-------------------+-----------------------------------------------------+-----------+
| ``SIZE``          | Number of addresses in this range.                  | **YES**   |
+-------------------+-----------------------------------------------------+-----------+

The no-SLAAC IPv6 version supports the following attributes:

+-------------------+-----------------------------------------------------+-----------+
| Attribute         | Description                                         | Mandatory |
+===================+=====================================================+===========+
| ``TYPE``          | ``IP4_6_STATIC``                                    | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``IP``            | First ``IPv4`` in the range in dot notation.        | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``MAC``           | First ``MAC``, if not provided it will be           | **NO**    |
|                   | generated using the ``IP`` and the ``MAC_PREFIX``   |           |
|                   | in ``oned.conf``.                                   |           |
+-------------------+-----------------------------------------------------+-----------+
| ``IP6``           | First ``IP6`` (full 128 bits) in the range.         | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``PREFIX_LENGTH`` | Length of the prefix to configure VM interfaces.    | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``SIZE``          | Number of addresses in this range.                  | **YES**   |
+-------------------+-----------------------------------------------------+-----------+

.. _vnet_template_eth:

Ethernet Address Range
--------------------------------------------------------------------------------

+-------------------+-----------------------------------------------------+-----------+
| Attribute         | Description                                         | Mandatory |
+===================+=====================================================+===========+
| ``TYPE``          | ``ETHER``                                           | **YES**   |
+-------------------+-----------------------------------------------------+-----------+
| ``MAC``           | First ``MAC``, if not provided it will be           | **NO**    |
|                   | generated randomly.                                 |           |
+-------------------+-----------------------------------------------------+-----------+
| ``SIZE``          | Number of addresses in this range.                  | **YES**   |
+-------------------+-----------------------------------------------------+-----------+

.. _vnet_template_context:

Contextualization Attributes
================================================================================

+--------------------------+-------------------------------------------------------+
| Attribute                | Description                                           |
+==========================+=======================================================+
| ``NETWORK_ADDRESS``      | Base network address.                                 |
+--------------------------+-------------------------------------------------------+
| ``NETWORK_MASK``         | Network mask.                                         |
+--------------------------+-------------------------------------------------------+
| ``GATEWAY``              | Default gateway for the network.                      |
+--------------------------+-------------------------------------------------------+
| ``GATEWAY6``             | ``IPv6`` router for this network.                     |
+--------------------------+-------------------------------------------------------+
| ``DNS``                  | DNS servers, a space separated list of servers.       |
+--------------------------+-------------------------------------------------------+
| ``GUEST_MTU``            | Sets the ``MTU`` for the NICs in this network.        |
+--------------------------+-------------------------------------------------------+
| ``CONTEXT_FORCE_IPV4``   | When a vnet is IPv6 the IPv4 is not configured unless |
|                          | this attribute is set.                                |
+--------------------------+-------------------------------------------------------+
| ``SEARCH_DOMAIN``        | Default search domains for DNS resolution.            |
+--------------------------+-------------------------------------------------------+

.. _vnet_template_interface_creation:

Interface Creation Options
================================================================================

For ``802.1Q``, ``VXLAN`` and ``Open vSwitch`` drivers you can specify parameters in the VNET template. Option can be overridden or added per network.

+---------------------+--------------------------------------------------+
| Attribute           | Description                                      |
+=====================+==================================================+
| ``CONF``            | Driver configuration options.                    |
+---------------------+--------------------------------------------------+
| ``BRIDGE_CONF``     | Parameters for Linux bridge creation.            |
+---------------------+--------------------------------------------------+
| ``OVS_BRIDGE_CONF`` | Parameters for Open vSwitch bridge creation.     |
+---------------------+--------------------------------------------------+
| ``IP_LINK_CONF``    | Parameters for link creation.                    |
+---------------------+--------------------------------------------------+

.. code::

    CONF="vxlan_mc=239.0.100.0,test=false,validate_vlan_id=true"
    BRIDGE_CONF="sethello=6"
    OVS_BRIDGE_CONF="stp_enable=true"
    IP_LINK_CONF="tos=10,udpcsum=,udp6zerocsumrx=__delete__"

Options can have empty value when they don't need a parameter. Also the special value "__delete__" can be used to delete parameters set here.

You can find more information about these parameters in :ref:`802.1Q <hm-vlan>` and :ref:`VXLAN <vxlan>` documentation.

.. _vnet_template_example:

Virtual Network Definition Examples
================================================================================

Sample IPv4 VNet:

.. code::

    # Configuration attributes (dummy driver)
    NAME        = "Private Network"
    DESCRIPTION = "A private network for VM inter-communication"

    BRIDGE = "bond-br0"

    # Context attributes
    NETWORK_ADDRESS = "10.0.0.0"
    NETWORK_MASK    = "255.255.255.0"
    DNS             = "10.0.0.1"
    GATEWAY         = "10.0.0.1"

    #Address Ranges, only these addresses will be assigned to the VMs
    AR=[TYPE = "IP4", IP = "10.0.0.10", SIZE = "100" ]

    AR=[TYPE = "IP4", IP = "10.0.0.200", SIZE = "10" ]


Sample IPv4 VNet, using AR of just one IP:

.. code::

    # Configuration attributes (OpenvSwitch driver)
    NAME        = "Public"
    DESCRIPTION = "Network with public IPs"

    BRIDGE  = "br1"
    VLAN    = "YES"
    VLAN_ID = 12

    DNS           = "8.8.8.8"
    GATEWAY       = "130.56.23.1"
    LOAD_BALANCER = 130.56.23.2

    AR=[ TYPE = "IP4", IP = "130.56.23.2", SIZE = "1"]
    AR=[ TYPE = "IP4", IP = "130.56.23.34", SIZE = "1"]
    AR=[ TYPE = "IP4", IP = "130.56.23.24", SIZE = "1"]
    AR=[ TYPE = "IP4", IP = "130.56.23.17", MAC= "50:20:20:20:20:21", SIZE = "1"]
    AR=[ TYPE = "IP4", IP = "130.56.23.12", SIZE = "1"]
