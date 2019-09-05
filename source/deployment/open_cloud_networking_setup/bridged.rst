.. _bridged:
.. _ebtables:

================================================================================
Bridged Networking
================================================================================

This guide describes how to deploy Bridged networks. In this mode, the virtual machine traffic is directly bridged through the Linux bridge in the nodes. Bridged networks can operate in four different modes depending on the additional traffic filtering made by the OpenNebula:

* **Dummy Bridged**, no filtering, no bridge setup (legacy no-op driver).
* **Bridged**, no filtering is made, managed bridge.
* **Bridged with Security Groups**, iptables rules are installed to implement security groups rules.
* **Bridged with ebtables VLAN**, same as above plus additional ebtables rules to isolate (L2) each Virtual Networks.

Considerations & Limitations
================================================================================

The following needs to be considered regarding traffic isolation:

* In the **Dummy Bridged**, **Bridged** and **Bridged with Security Groups** modes you can add tagged network interfaces to achieve network isolation. This is the **recommended** deployment strategy in production environments in this mode.

* The **Bridged with ebtables VLAN** mode is targeted to small environments without proper hardware support to implement VLANS. Note that it is limited to /24 networks and that IP addresses cannot overlap between Virtual Networks. This mode is only recommended for testing purposes.

.. _bridged_conf:

OpenNebula Configuration
================================================================================

The following configuration attributes can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------+-------------------------------------------------------------------------------------------+
| Parameter        | Description                                                                               |
+==================+===========================================================================================+
| ipset_maxelem    | Maximal number of entries in the IP set (used for the security group rules)               |
+------------------+-------------------------------------------------------------------------------------------+
| keep_empty_bridge| Set to true to preserve bridges with no virtual interfaces left.                          |
+------------------+-------------------------------------------------------------------------------------------+
| bridge_conf      | *Hash* Options for ``brctl`` (deprecated, will be translated to ip-route2 options)        |
+------------------+-------------------------------------------------------------------------------------------+
| ip_bridge_conf   | *Hash* Options for ip-route2 ``ip link add <bridge> type bridge ...``                     |
+------------------+-------------------------------------------------------------------------------------------+

.. _bridged_net:

Defining a Bridged Network
================================================================================

To create a virtual network include the following information:

+-------------+-------------------------------------------------------------------------+-----------+
| Attribute   | Value                                                                   | Mandatory |
+=============+=========================================================================+===========+
| **VN_MAD**  | * ``dummy`` for the Dummy Bridged mode                                  |  **YES**  |
|             | * ``bridge`` for the Bridged mode                                       |           |
|             | * ``fw`` for Bridged with Security Groups                               |           |
|             | * ``ebtables`` for Bridged with ebtables isolation                      |           |
+-------------+-------------------------------------------------------------------------+-----------+
| **BRIDGE**  | Name of the linux bridge in the nodes                                   |  **YES**  |
+-------------+-------------------------------------------------------------------------+-----------+
| **PHYDEV**  | Name of the physical network device that will be attached to the bridge |    NO     |
|             | (does not apply for ``dummy`` driver)                                   |           |
+-------------+-------------------------------------------------------------------------+-----------+

The following example defines Bridged network with the Security Groups mode:

.. code::

    NAME    = "bridged_net"
    VN_MAD  = "fw"
    BRIDGE  = vbr1
    ...

ebtables VLAN Mode: default rules
================================================================================

This section lists the ebtables rules that are created, in case you need to debug your setup

.. code::

    # Drop packets that don't match the network's MAC Address
    -s ! <mac_address>/ff:ff:ff:ff:ff:0 -o <tap_device> -j DROP
    # Prevent MAC spoofing
    -s ! <mac_address> -i <tap_device> -j DROP

