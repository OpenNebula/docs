.. _vnet_template:

================================
Virtual Network Definition File
================================

This page describes how to define a new Virtual Network template. A Virtual Network template follows the same syntax as the :ref:`VM template <template>`.

If you want to learn more about the Virtual Network management, you can do so :ref:`here <vgg>`.

Common Attributes
=================

There are two types of Virtual Networks, ranged and fixed. Their only difference is how the leases are defined in the template.

These are the common attributes for both types of VNets:

+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
|     Attribute      |    Value     |                                                                Description                                                                 |               Mandatory                |
+====================+==============+============================================================================================================================================+========================================+
| **NAME**           | String       | Name of the Virtual Network                                                                                                                | YES                                    |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **BRIDGE**         | String       | Name of the physical bridge in the physical host where the VM should connect its network interface                                         | YES if PHYDEV is not set               |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **TYPE**           | RANGED/FIXED | Type of this VNet                                                                                                                          | YES                                    |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **VLAN**           | YES/NO       | Whether or not to isolate this virtual network using the :ref:`Virtual Network Manager drivers <nm>`. If omitted, the default value is NO. | NO                                     |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **VLAN\_ID**       | Integer      | Optional VLAN id for the :ref:`802.1Q <hm-vlan>` and :ref:`Open vSwitch <openvswitch>` networking drivers.                                 | NO                                     |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **PHYDEV**         | String       | Name of the physical network device that will be attached to the bridge.                                                                   | YES for :ref:`802.1Q <hm-vlan>` driver |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **SITE\_PREFIX**   | String       | IPv6 unicast local addresses (ULAs). Must be a valid IPv6                                                                                  | Optional                               |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+
| **GLOBAL\_PREFIX** | String       | IPv6 global unicast addresses. Must be a valid IPv6                                                                                        | Optional                               |
+--------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------+

Please note that any arbitrary value can be set in the Virtual Network template, and then used in the :ref:`contextualization <cong>` section of the VM. For instance, NETWORK\_GATEWAY="x.x.x.x" might be used to define the Virtual Network, and then used in the context section of the VM to configure its network to connect through the GATEWAY.

If you need OpenNebula to generate IPv6 addresses, that can be later used in context or for Virtual Router appliances, you can use the ``GLOBAL_PREFIX`` and ``SITE_PREFIX`` attributes

Attributes Used for Contextualization
-------------------------------------

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

Leases
======

A lease is a definition of an IP-MAC pair. From an IP address, OpenNebula generates an associated MAC using the following rule: ``MAC = MAC_PREFFIX:IP``. All Virtual Networks share a default value for the MAC\_PREFIX, set in the ``oned.conf`` file.

So, for example, from IP 10.0.0.1 and MAC\_PREFFIX 02:00, we get 02:00:0a:00:00:01.

The available leases for new VNets are defined differently for each type.

Fixed Virtual Networks
----------------------

Fixed VNets need a series of ``LEASES`` vector attributes, defined with the following sub-attributes:

+-----------------+---------------+-----------------------------+-------------+
| Sub-Attribute   | Value         | Description                 | Mandatory   |
+=================+===============+=============================+=============+
| **IP**          | IP address    | IP for this lease           | YES         |
+-----------------+---------------+-----------------------------+-------------+
| **MAC**         | MAC address   | MAC associated to this IP   | NO          |
+-----------------+---------------+-----------------------------+-------------+

.. warning:: The optional MAC attribute will overwrite the default MAC\_PREFIX:IP rule. Be aware that this will break the default :ref:`contextualization mechanism <cong>`.

Ranged Virtual Networks
-----------------------

Instead of a list of ``LEASES``, ranged Virtual Networks contain a range of IPs that can be defined in a flexible way using these attributes:

+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Attribute              | Value                                     | Description                                                                                                                                                                                             |
+========================+===========================================+=========================================================================================================================================================================================================+
| **NETWORK\_ADDRESS**   | IP address, optionally in CIDR notation   | Base network address to generate IP addresses.                                                                                                                                                          |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **NETWORK\_SIZE**      | ``A``, ``B``, ``C``, or Number            | Number of VMs that can be connected using this network. It can be defined either using a number or a network class (A, B or C). The default value for the network size can be found in ``oned.conf``.   |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **NETWORK\_MASK**      | Mask in dot-decimal notation              | Network mask for this network.                                                                                                                                                                          |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **IP\_START**          | IP address                                | First IP of the range.                                                                                                                                                                                  |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **IP\_END**            | IP address                                | Last IP of the range.                                                                                                                                                                                   |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **MAC\_START**         | MAC address                               | First MAC of the range.                                                                                                                                                                                 |
+------------------------+-------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

The following examples define the same network range, from 10.10.10.1 to 10.10.10.254:

.. code::

    NETWORK_ADDRESS = 10.10.10.0
    NETWORK_SIZE    = C

.. code::

    NETWORK_ADDRESS = 10.10.10.0
    NETWORK_SIZE    = 254

.. code::

    NETWORK_ADDRESS = 10.10.10.0/24

.. code::

    NETWORK_ADDRESS = 10.10.10.0
    NETWORK_MASK    = 255.255.255.0

You can change the first and/or last IP of the range:

.. code::

    NETWORK_ADDRESS = 10.10.10.0/24
    IP_START        = 10.10.10.17

Or define the range manually:

.. code::

    IP_START        = 10.10.10.17
    IP_END          = 10.10.10.41

Finally, you can define the network by just specifying the MAC address set (specially in IPv6). The following is equivalent to the previous examples but with MACs:

.. code::

    MAC_START    = 02:00:0A:0A:0A:11
    NETWORK_SIZE = 254

.. warning:: With either of the above procedures, no matter if you are defining the set using IPv4 networks, OpenNebula will generate IPv6 addresses if the GLOBAL\_PREFIX and/or SITE\_PREFIX is added to the network template. Note that the link local IPv6 address will be always generated.

Examples
========

Sample fixed VNet:

.. code::

    NAME    = "Blue LAN"
    TYPE    = FIXED
     
    # We have to bind this network to ''virbr1'' for Internet Access
    BRIDGE  = vbr1
     
    LEASES  = [IP=130.10.0.1]
    LEASES  = [IP=130.10.0.2, MAC=50:20:20:20:20:21]
    LEASES  = [IP=130.10.0.3]
    LEASES  = [IP=130.10.0.4]
     
    # Custom Attributes to be used in Context
    GATEWAY = 130.10.0.1
    DNS     = 130.10.0.1
     
    LOAD_BALANCER = 130.10.0.4

Sample ranged VNet:

.. code::

    NAME    = "Red LAN"
    TYPE    = RANGED
     
    # Now we'll use the host private network (physical)
    BRIDGE  = vbr0
     
    NETWORK_ADDRESS = 192.168.0.0/24
    IP_START        = 192.168.0.3
     
    # Custom Attributes to be used in Context
    GATEWAY = 192.168.0.1
    DNS     = 192.168.0.1
     
    LOAD_BALANCER = 192.168.0.2

