.. _vnet_template:

================================
Virtual Network Definition File
================================

This page describes how to define a new Virtual Network template. A Virtual Network template follows the same syntax as the :ref:`VM template <template>`.

If you want to learn more about the Virtual Network management, you can do so :ref:`here <vgg>`.

A VNET is defined by three parts: the physical network, the address space and the contextualization parameters. The following sections details each part.

Physical Network Attributes
===========================

It defines the **underlying networking infrastructure** that will support the VNET. These section includes the following values:

+--------------+-----------------------------------------------------+---------------------+
| Attribute    |                     Description                     |  Value  | Mandatory |
+==============+=====================================================+=====================+
| **NAME**     | Name of the Virtual Network                         | String  | YES       |
+--------------+-----------------------------------------------------+---------+-----------+
| **BRIDGE**   | Device to bind the virtual and physical network,    | String  | YES if no |
|              | depending on the network driver it may refer to     |         | PHYDEV    |
|              | different technologies or require host setups.      |         |           |
+--------------+-----------------------------------------------------+---------+-----------+
| **VLAN**     | Set to YES to activate VLAN isolation when          | YES/NO  | NO        |
|              | supported by the network drivers, see               |         |           |
|              | :ref:`Virtual Network Manager drivers <nm>`.        |         |           |
|              | Defaults to NO                                      |         |           |
+--------------+-----------------------------------------------------+---------+-----------+
| **VLAN\_ID** | Identifier for the VLAN                             | Integer | NO        |
+--------------+-----------------------------------------------------+---------+-----------+
| **PHYDEV**   | Name of the physical network device that will be    | String  | YES for   |
|              | attached to the bridge.                             |         | 802.1Q    |
+--------------+-----------------------------------------------------+---------+-----------+


The Address Range
=================

The addresses available in a VNET are defined by one or more Address Ranges (AR). Each address range is defined in an AR attribute to set a continuous address range.

Optionally, each AR can include configuration attributes (context or physical network attributes) that will override those provided by the VNET.

.. note:: When not manually set, MAC addresses are derived from the IPv4 address. A VNET lease for a given IP will have a MAC address in the form MAC_PREFIX:IP where MAC_PREFIX is defined in oned.conf.

IPv4 Address Range
------------------

+-------------+-----------------------------------------------------+-----------+
| Attribute   |                     Description                     | Mandatory |
+=============+=====================================================+===========+
| **TYPE**    | ``IP4``                                             |  YES      |
+-------------+-----------------------------------------------------+-----------+
| **IP**      | First IP in the range in dot notation.              |  YES      |
+-------------+-----------------------------------------------------+-----------+
| **MAC**     | First MAC, if not provided it will be               |  NO       |
|             | generated using the IP and the MAC_PREFIX in        |           |
|             | ``oned.conf``.                                      |           |
+-------------+-----------------------------------------------------+-----------+
| **SIZE**    | Number of addresses in this range.                  |  YES      |
+-------------+-----------------------------------------------------+-----------+

IPv6 Address Range
------------------

+-------------------+-----------------------------------------------------+-----------+
| Attribute         |                     Description                     | Mandatory |
+===================+=====================================================+===========+
| **TYPE**          | ``IP6``                                             |  YES      |
+-------------------+-----------------------------------------------------+-----------+
| **MAC**           | First MAC, if not provided it will be generated.    |  YES      |
+-------------------+-----------------------------------------------------+-----------+
| **GLOBAL_PREFIX** | A /64 globally routable prefix                      |  NO       |
+-------------------+-----------------------------------------------------+-----------+
| **ULA_PREFIX**    | A /64 unique local address (ULA)                    |  NO       |
|                   | prefix corresponding to the ``fd00::/8`` block      |           |
+-------------------+-----------------------------------------------------+-----------+
| **SIZE**          | Number of addresses in this range.                  |  YES      |
+-------------------+-----------------------------------------------------+-----------+

Dual IPv4-IPv6 Address Range
----------------------------

+-------------------+-----------------------------------------------------+-----------+
| Attribute         |                     Description                     | Mandatory |
+===================+=====================================================+===========+
| **TYPE**          | ``IP4_6``                                           | YES       |
+-------------------+-----------------------------------------------------+-----------+
| **IP**            | First IP in the range in dot notation.              | YES       |
+-------------------+-----------------------------------------------------+-----------+
| **MAC**           | First MAC, if not provided it will be               | NO        |
|                   | generated using the IP and the MAC_PREFIX in        |           |
|                   | ``oned.conf``.                                      |           |
+-------------------+-----------------------------------------------------+-----------+
| **GLOBAL_PREFIX** | A /64 globally routable prefix                      | NO        |
+-------------------+-----------------------------------------------------+-----------+
| **ULA_PREFIX**    | A /64 unique local address (ULA)                    | NO        |
|                   | prefix corresponding to the ``fd00::/8`` block      |           |
+-------------------+-----------------------------------------------------+-----------+
| **SIZE**          | Number of addresses in this range.                  | YES       |
+-------------------+-----------------------------------------------------+-----------+

Ethernet Address Range
----------------------

+-------------------+-----------------------------------------------------+-----------+
| Attribute         |                     Description                     | Mandatory |
+===================+=====================================================+===========+
| **TYPE**          | ``ETHER``                                           | YES       |
+-------------------+-----------------------------------------------------+-----------+
| **MAC**           | First MAC, if not provided it will be               | NO        |
|                   | generated randomly.                                 |           |
+-------------------+-----------------------------------------------------+-----------+
| **SIZE**          | Number of addresses in this range.                  | YES       |
+-------------------+-----------------------------------------------------+-----------+


Contextualization Attributes
============================

+----------------------------+-------------------------------------------------------------------------------+
| Attribute                  | Description                                                                   |
+============================+===============================================================================+
| **NETWORK\_ADDRESS**       | Base network address                                                          |
+----------------------------+-------------------------------------------------------------------------------+
| **NETWORK\_MASK**          | Network mask                                                                  |
+----------------------------+-------------------------------------------------------------------------------+
| **GATEWAY**                | Router for this network, do not set when the network is not routable          |
+----------------------------+-------------------------------------------------------------------------------+
| **DNS**                    | Specific DNS for this network                                                 |
+----------------------------+-------------------------------------------------------------------------------+
| **GATEWAY6**               | IPv6 router for this network                                                  |
+----------------------------+-------------------------------------------------------------------------------+
| **CONTEXT\_FORCE\_IPV4**   | When a vnet is IPv6 the IPv4 is not configured unless this attribute is set   |
+----------------------------+-------------------------------------------------------------------------------+

Examples
========

Sample IPv4 VNet:

.. code::

    # Confgiuration attributes (dummy driver)
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

    # Confgiuration attributes (OpenvSwtich driver)
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
