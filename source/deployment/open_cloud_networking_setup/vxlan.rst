.. _vxlan:

============
VXLAN
============

This guide describes how to enable Network isolation provided through the VXLAN encapsulation protocol. This driver will create a bridge for each OpenNebula Virtual Network and attach a VXLAN tagged network interface to the bridge.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an VLAN_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

Additionally each VLAN has associated a multicast address to encapsulate L2 broadcast and multicast traffic. This address is assigned by default to the 239.0.0.0/8 range as defined by RFC 2365 (Administratively Scoped IP Multicast). In particular the multicast address is obtained by adding the VLAN_ID to the 239.0.0.0/8 base address.

Requirements
============

The hypervisors must run a Linux kernel (>3.7.0) that natively supports the VXLAN protocol and the associated iproute2 package.

When all the hypervisors are connected to the same broadcasting domain just be sure that the multicast traffic is not filtered by any iptable rule in the hypervisors. However if the multicast traffic needs to traverse routers a multicast protocol like IGMP needs to be configured in your network.

As this driver enables the security groups, make sure the :ref:`security groups requirements <security_groups_requirements>` are also met.

Considerations & Limitations
============================

This driver works with the default UDP server port 8472.

VXLAN traffic is forwarded to a physical device, this device can be set to be a VLAN tagged interface, but in that case you must make sure that the tagged interface is manually created first in all the hosts.

Configuration
=============

Frontend Configuration
------------------------

No specific configuration is required for the frontend.

Hosts Configuration
-------------------

No specific configuration is required for the hosts.

VXLAN Options
--------------

It is possible specify the start VLAN ID and the base multicast address by configuring ``/etc/one/oned.conf``:

.. code:: bash

    # VXLAN_IDS: Automatic VXLAN Network ID (VNI) assigment. This is used
    # for vxlan networks.
    #     start: First VNI to use

    VXLAN_IDS = [
        START = "2"
    ]

This driver accepts an ``MTU`` attribute that will be used when creating the tagged interface and bridge. Also ``TTL`` can be adjusted for routed multicast networks (IGMP).

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

To use this driver, use ``VN_MAD="vxlan"`` in the Network Template.

The attribute PHYDEV must be also defined, with the name of the physical network device that will be attached to the bridge. The BRIDGE attribute is not mandatory, if it isn't defined, OpenNebula will generate one automatically.

.. code::

    NAME    = "vxlan_net"
    VN_MAD  = "vxlan"
    PHYDEV  = "eth0"
    VLAN_ID = 50        # optional
    BRIDGE  = "vxlan50" # optional
    ...

In this scenario, the driver will check for the existence of the ``vxlan50`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.<vlan_id>``) and attached to ``vxlan`` (unless it's already attached). Note that eth0 can be a 802.1Q tagged interface if you want to isolate the OpenNebula VXLAN traffic.

Regular users in general should not be allowed to create networks, as it requires information about the underlying infrastructure. However, they may optionally be able to to safely make address reservations on the Networks.

Tuning & Extending
==================

The code can be enhanced and modified, by changing the following files in the
frontend:

* ``/var/lib/one/remotes/vnm/vxlan/vxlan_driver.rb``
* ``/var/lib/one/remotes/vnm/vxlan/post``
* ``/var/lib/one/remotes/vnm/vxlan/clean``
* ``/var/lib/one/remotes/vnm/vxlan/pre``

Remember to sync any changes to the hosts by running ``onehost sync`` and to backup the changes in order to re-apply them after upgrading to a new release of OpenNebula.
