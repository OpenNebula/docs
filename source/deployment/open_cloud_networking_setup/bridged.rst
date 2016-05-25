.. _bridged:

=========
Ebtables
=========

This guide describes how to enable Network isolation provided through ebtables rules applied on the bridges. This method will only permit isolation with a mask of 255.255.255.0.

Requirements
============

This hook requires ``ebtables`` to be available in all the OpenNebula Hosts.

Considerations & Limitations
============================

Although this is the most easily usable driver, since it doesn't require any special hardware or any software configuration, it lacks the ability of sharing IPs amongst different VNETs, that is, if an VNET is using leases of 192.168.0.0/24, another VNET must not use the same IPs in the same network. Note that OpenNebula will not prevent you to create

Configuration
=============

Frontend Configuration
------------------------

No specific configuration is required for the frontend.

Hosts Configuration
-------------------

The package ``ebtables`` must be installed in the hosts.

Driver Actions
--------------

+-----------+------------------------------------------------------------------+
|   Action  |                           Description                            |
+===========+==================================================================+
| **Pre**   | N/A                                                              |
+-----------+------------------------------------------------------------------+
| **Post**  | Creates EBTABLES rules in the Host where the VM has been placed. |
+-----------+------------------------------------------------------------------+
| **Clean** | Removes the EBTABLES rules created during the ``Post`` action.   |
+-----------+------------------------------------------------------------------+

Usage
=====

To use this driver, use ``VN_MAD="ebtables"`` in the Network Template.

The driver will be automatically applied to every Virtual Machine deployed in the Host.

.. code::

    NAME    = "ebtables_net"
    VN_MAD  = "ebtables"
    BRIDGE  = vbr1
    ...

Tuning & Extending
==================

Ebtables Rules
--------------

This section lists the ebtables rules that are created:

.. code::

    # Drop packets that don't match the network's MAC Address
    -s ! <mac_address>/ff:ff:ff:ff:ff:0 -o <tap_device> -j DROP
    # Prevent MAC spoofing
    -s ! <mac_address> -i <tap_device> -j DROP

