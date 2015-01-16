.. _vxlan:

============
VXLAN
============

This guide describes how to enable Network isolation provided through the VXLAN
encapsulation protocol. This driver will create a bridge for each OpenNebula Virtual Network and attach a VXLAN tagged network interface to the bridge.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an VLAN\_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

Additionally each VLAN has associated a multicast address to encapsulate L2 broadcast and multicast traffic. This address is assigned by default to the 239.0.0.0/8 range as defined by RFC 2365 (Administratively Scoped IP Multicast). In particular the multicast address is obtained by adding the VLAN\_ID to the 239.0.0.0/8 base address. 

Requirements
============

The hypervisors must run a Linux kernel (>3.7.0) that natively supports the VXLAN protocol and the associated iproute2 package.

When all the hypervisors are connected to the same broadcasting domain just be sure that the multicast traffic is not filtered by any iptable rule in the hypervisors. However if the multicast traffic needs to traverse routers a multicast protocol like IGMP needs to be configured in your network.

Considerations & Limitations
============================

This driver works with the default UDP server port 8472. 

VXLAN traffic is forwarded to a physical device, this device can be configured to be a VLAN tagged interface. The current version of the driver does not automatically create the 802.1Q interface, so you need to configured it in the hypervisors in case you need them. 

Configuration
=============

Hosts Configuration
-------------------

-  The ``sudoers`` file must be configured so ``oneadmin`` can execute ``brctl`` and ``ip`` in the hosts.

OpenNebula Configuration
------------------------

To enable this driver, use **vxlan** as the Virtual Network Manager driver parameter when the hosts are created with the :ref:`onehost command <host_guide>`:

.. code::

    $ onehost create host01 -i kvm -v kvm -n vxlan

VXLAN Options
--------------

It is possible specify the start VLAN ID and the base multicast address by editing ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``.

Driver Actions
--------------

+-----------+----------------------------------------------------------------------------------------------------------+
|   Action  |                                               Description                                                |
+===========+==========================================================================================================+
| **Pre**   | Creates a VXLAN interface through PHYDEV, creates a bridge (if needed) and attaches the vxlan device.    |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Post**  | When the VM is associated to a security group, the corresponding iptables rules are applied.             |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The VXLAN interface and bridge are kept in the Host to speed up future VMs       |
+-----------+----------------------------------------------------------------------------------------------------------+

Usage
=====

The driver will be automatically applied to every Virtual Machine deployed in the Host. However, this driver requires a special configuration in the :ref:`Virtual Network template <vnet_template>`: only the virtual networks with the attribute ``VLAN`` set to ``YES`` will be isolated. The attribute PHYDEV must be also defined, with the name of the physical network device that will be attached to the bridge. The BRIDGE attribute is not mandatory, if it isn't defined, OpenNebula will generate one automatically.

.. code::

    NAME    = "vxlan_net"
         
    PHYDEV  = "eth0"
    VLAN    = "YES"
    VLAN_ID = 50        # optional
    BRIDGE  = "vxlan50" # optional
     
    ...

In this scenario, the driver will check for the existence of the ``vxlan50`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.<vlan_id>``) and attached to ``vxlan`` (unless it's already attached). Note that eth0 can be a 802.1Q tagged interface if you want to isolate the OpenNebula VXLAN traffic.

.. warning:: Any user with Network creation/modification permissions may force a custom vlan id with the ``VLAN_ID`` parameter in the network template. You **MUST** restrict permissions on Network creation to admin groups with :ref:`ACL rules <manage_acl>`. Regular uses will then be able to safely make address reservations on the Networks.

Tuning & Extending
==================

.. warning:: Remember that any change in the ``/var/lib/one/remotes`` directory won't be effective in the Hosts until you execute, as oneadmin:

.. code::

    oneadmin@frontend $ onehost sync

