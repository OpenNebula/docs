.. _bridged:
.. _ebtables:

================================================================================
Bridged Networking
================================================================================

This guide describes how to deploy Bridged networks. In this mode, the virtual machine traffic is directly bridged through the Linux bridge on the hypervisor Nodes. Bridged networks can operate in four different modes depending on the additional traffic filtering made by the OpenNebula:

* **Dummy Bridged**, no filtering, no bridge setup (legacy no-op driver).
* **Bridged**, no filtering is made, managed bridge.
* **Bridged with Security Groups**, iptables rules are installed to implement security groups rules.
* **Bridged with ebtables VLAN**, same as above plus additional ebtables rules to provide L2 isolation for Virtual Networks.

Considerations & Limitations
================================================================================

The following needs to be considered regarding traffic isolation:

* In the **Dummy Bridged**, **Bridged** and **Bridged with Security Groups** modes you can add tagged network interfaces to achieve network isolation. This is the **recommended** deployment strategy in production environments in this mode.

* The **Bridged with ebtables VLAN** mode is targeted to small environments without proper hardware support to implement VLANs. Note that it is limited to ``/24`` networks and that IP addresses cannot overlap between Virtual Networks. This mode is only recommended for testing purposes.

.. _bridged_conf:

OpenNebula Configuration
================================================================================

The following configuration parameters can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------------+---------------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                                   |
+========================+===============================================================================================================+
| ``:ipset_maxelem``     | Maximal number of entries in the IP set (used for the security group rules)                                   |
+------------------------+---------------------------------------------------------------------------------------------------------------+
| ``:keep_empty_bridge`` | Set to ``true`` to preserve bridges with no virtual interfaces left.                                          |
+------------------------+---------------------------------------------------------------------------------------------------------------+
| ``:ip_bridge_conf``    | *(Hash)* Options passed to ``ip`` cmd. on bridge create (``ip link add <bridge> type bridge ...``)            |
+------------------------+---------------------------------------------------------------------------------------------------------------+

.. _bridged_net:

Defining Bridged Network
================================================================================

To create a Virtual Network, include the following information in the template:

+-------------+-------------------------------------------------------------------------+-----------------------+
| Attribute   | Value                                                                   | Mandatory             |
+=============+=========================================================================+=======================+
|             | Driver:                                                                 |                       |
|             |                                                                         |                       |
| ``VN_MAD``  | * ``dummy`` for the Dummy Bridged mode                                  |  **YES**              |
|             | * ``bridge`` for the Bridged mode                                       |                       |
|             | * ``fw`` for Bridged with Security Groups                               |                       |
|             | * ``ebtables`` for Bridged with ebtables isolation                      |                       |
+-------------+-------------------------------------------------------------------------+-----------------------+
| ``BRIDGE``  | Name of the Linux bridge on the Nodes                                   | NO (unless ``dummy``) |
+-------------+-------------------------------------------------------------------------+-----------------------+
| ``PHYDEV``  | Name of the physical network device that will be attached to the bridge | NO                    |
|             | (does not apply for ``dummy`` driver)                                   |                       |
+-------------+-------------------------------------------------------------------------+-----------------------+

For example, you can define a *Bridged with Security Groups* type network with following template:

.. code::

    NAME    = "private1"
    VN_MAD  = "fw"

Bridged and ebtables VLAN
================================================================================

The ``ebtables`` program on the Node will set up tables of rules (at Linux kernel level) to inspect the Ethernet frames. Running the command ``ebtables -L`` on the Node will display rules similiar to the ones shown here:

.. code::

   Bridge table: filter

   Bridge chain: INPUT, entries: 0, policy: ACCEPT

   Bridge chain: FORWARD, entries: 2, policy: ACCEPT
   # Drop packets that don't match the network's MAC Address
   -s ! <mac_address>/ff:ff:ff:ff:ff:0 -o <tap_device> -j DROP
   # Prevent MAC spoofing
   -s ! <mac_address> -i <tap_device> -j DROP

   Bridge chain: OUTPUT, entries: 0, policy: ACCEPT
