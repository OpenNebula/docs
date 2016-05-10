.. _hm-vlan:

============
802.1Q VLAN
============

This guide describes how to enable Network isolation provided through host-managed VLANs. This driver will create a bridge for each OpenNebula Virtual Network and attach an VLAN tagged network interface to the bridge. This mechanism is compliant with `IEEE 802.1Q <http://en.wikipedia.org/wiki/IEEE_802.1Q>`__.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

Requirements
============

A network switch capable of forwarding VLAN tagged traffic. The physical switch ports should be VLAN trunks.

As this driver enables the security groups, make sure the :ref:`security groups requirements <security_groups_requirements>` are also met.

Considerations & Limitations
============================

This driver requires some previous work on the network components, namely the switches, to enable VLAN trunking in the network interfaces connected to the OpenNebula hosts. If this is not activated the VLAN tags will not get trough and the network will behave erratically.

Configuration
=============

OpenNebula Configuration
------------------------

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

By modifying that parameter you can reserve some VLANs so they aren't assigned to a Network. You can also define the first VLAN_ID. When a new isolatad network is created, OpenNebula will find a free VLAN_ID from the VLAN pool. This pool is global, and it's also shared with the :ref:`Open vSwitch <openvswitch>` driver.

.. warning::

    A reserved VLAN_ID will be reserved forever, even if you remove it from the list, it will still be reserved. There is no mechanism to un-reserve a VLAN_ID.


Hosts Configuration
-------------------

* The ``8021q`` module must be loaded in the kernel.

802.1Q Options
--------------

It is possible specify the start VLAN ID by editing ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``.

This driver accepts an ``MTU`` attribute that will be used when creating the tagged interface and bridge.

Driver Actions
--------------

+-----------+----------------------------------------------------------------------------------------------------------+
|   Action  |                                               Description                                                |
+===========+==========================================================================================================+
| **Pre**   | Creates a VLAN interface through PHYDEV, creates a bridge (if needed) and attaches the vxlan device.     |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Post**  | When the VM is associated to a security group, the corresponding iptables rules are applied.             |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The VLAN tagged interface and bridge are kept in the Host to speed up future VMs |
+-----------+----------------------------------------------------------------------------------------------------------+

Usage
=====

To use this driver, use ``VN_MAD="802.1Q"`` in the Network Template.

The attribute PHYDEV must be also defined, with the name of the physical network device that will be attached to the bridge. The BRIDGE attribute is not mandatory, if it isn't defined, OpenNebula will generate one automatically.

.. code::

    NAME    = "hmnet"
    VN_MAD  = "802.1Q"
    PHYDEV  = "eth0"
    VLAN_ID = 50        # optional
    BRIDGE  = "brhm"    # optional

In this scenario, the driver will check for the existence of the ``brhm`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.<vlan_id>``) and attached to ``brhm`` (unless it's already attached).

Tuning & Extending
==================

The code can be enhanced and modified, by chaning the following files in the
frontend:

* ``/var/lib/one/remotes/vnm/802.1Q/post``
* ``/var/lib/one/remotes/vnm/802.1Q/vlan_tag_driver.rb``
* ``/var/lib/one/remotes/vnm/802.1Q/clean``
* ``/var/lib/one/remotes/vnm/802.1Q/pre``

Remember to sync any changes to the hosts by running ``onehost sync`` and to backup the changes in order to re-apply them after upgrading to a new release of OpenNebula.
