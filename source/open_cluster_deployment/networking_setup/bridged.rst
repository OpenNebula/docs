.. _bridged:

================================================================================
Bridged Networking
================================================================================

This guide describes how to deploy Bridged networks. In this mode, the virtual machine traffic is directly bridged through the Linux bridge on the hypervisor Nodes. Bridged networks can operate in four different modes depending on the additional traffic filtering made by OpenNebula:

* **Dummy Bridged**, no filtering, no bridge setup (legacy no-op driver).
* **Bridged**, no filtering is made, managed bridge.
* **Bridged with Security Groups**, iptables rules are installed to implement security groups rules.

.. _bridged_conf:

OpenNebula Configuration
================================================================================

The following configuration parameters can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+------------------------+---------------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                                   |
+========================+===============================================================================================================+
| ``:ipset_maxelem``     | Maximum number of entries in the IP set (used for the security group rules)                                   |
+------------------------+---------------------------------------------------------------------------------------------------------------+
| ``:keep_empty_bridge`` | Set to ``true`` to preserve bridges with no virtual interfaces left.                                          |
+------------------------+---------------------------------------------------------------------------------------------------------------+
| ``:ip_bridge_conf``    | *(Hash)* Options passed to ``ip`` cmd. on bridge create (``ip link add <bridge> type bridge ...``)            |
+------------------------+---------------------------------------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync -f`` to synchonize the changes to all the Nodes.

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
+-------------+-------------------------------------------------------------------------+-----------------------+
| ``BRIDGE``  | Name of the Linux bridge on the Nodes                                   | NO (unless ``dummy``) |
+-------------+-------------------------------------------------------------------------+-----------------------+
| ``PHYDEV``  | Name of the physical network device that will be attached to the bridge | NO                    |
|             | (does not apply for ``dummy`` driver)                                   |                       |
+-------------+-------------------------------------------------------------------------+-----------------------+

For example, you can define a *Bridged with Security Groups* type network with the following template:

.. code::

    NAME    = "private1"
    VN_MAD  = "fw"
