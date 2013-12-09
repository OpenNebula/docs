========
Ebtables
========

This guide describes how to enable Network isolation provided through
ebtables rules applied on the bridges. This method will only permit
isolation with a mask of 255.255.255.0.

Requirements
============

This hook requires ``ebtables`` to be available in all the OpenNebula
Hosts.

Considerations & Limitations
============================

Although this is the most easily usable driver, since it doesn't require
any special hardware or any software configuration, it lacks the ability
of sharing IPs amongst different VNETs, that is, if an VNET is using
leases of 192.168.0.0/24, another VNET can't be using IPs in the same
network.

Configuration
=============

Hosts Configuration
-------------------

-  The package **``ebtables``** must be installed in the hosts.
-  The **``sudoers``** file must be configured so **``oneadmin``** can
execute **``ebtables``** in the hosts.

OpenNebula Configuration
------------------------

To enable this driver, use **ebtables** as the Virtual Network Manager
driver parameter when the hosts are created with the `onehost
command </./host_guide>`__:

.. code::

$ onehost create host01 -i kvm -v kvm -n ebtables

Driver Actions
--------------

+-------------+--------------------------------------------------------------------+
| Action      | Description                                                        |
+=============+====================================================================+
| **Pre**     | -                                                                  |
+-------------+--------------------------------------------------------------------+
| **Post**    | Creates EBTABLES rules in the Host where the VM has been placed.   |
+-------------+--------------------------------------------------------------------+
| **Clean**   | Removes the EBTABLES rules created during the ``Post`` action.     |
+-------------+--------------------------------------------------------------------+

Usage
=====

The driver will be automatically applied to every Virtual Machine
deployed in the Host. Only the virtual networks with the attribute
**``VLAN``** set to **``YES``** will be isolated. There are no other
special attributes required.

.. code:: code

NAME    = "ebtables_net"
TYPE    = "fixed"
BRIDGE  = vbr1
 
VLAN    = "YES"
 
LEASES = ...

Tuning & Extending
==================

EBTABLES Rules
--------------

This section lists the EBTABLES rules that are created:

.. code:: code

# Drop packets that don't match the network's MAC Address
-s ! <mac_address>/ff:ff:ff:ff:ff:0 -o <tap_device> -j DROP
# Prevent MAC spoofing
-s ! <mac_address> -i <tap_device> -j DROP

