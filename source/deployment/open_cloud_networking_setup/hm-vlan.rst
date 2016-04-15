.. _hm-vlan:

============
802.1Q VLAN
============

This guide describes how to enable Network isolation provided through host-managed VLANs. This driver will create a bridge for each OpenNebula Virtual Network and attach an VLAN tagged network interface to the bridge. This mechanism is compliant with `IEEE 802.1Q <http://en.wikipedia.org/wiki/IEEE_802.1Q>`__.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an VLAN\_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

Requirements
============

A network switch capable of forwarding VLAN tagged traffic. The physical switch ports should be VLAN trunks.

As this driver enables the security groups, make sure the :ref:`security groups requirements <security_groups_requirements>` are also met.

Considerations & Limitations
============================

This driver requires some previous work on the network components, namely the switches, to enable VLAN trunking in the network interfaces connected to the OpenNebula hosts. If this is not activated the VLAN tags will not get trough and the network will behave erratically.

Configuration
=============

Hosts Configuration
-------------------

-  The ``sudoers`` file must be configured so ``oneadmin`` can execute ``brctl`` and ``ip`` in the hosts.
-  Hosts must have the module ``8021q`` loaded.

To enable VLAN (802.1Q) support in the kernel, one must load the 8021q module:

.. code::

    $ modprobe 8021q

If the module is not available, please refer to your distribution's documentation on how to install it.

OpenNebula Configuration
------------------------

To enable this driver, use **802.1Q** as the Virtual Network Manager driver parameter when the hosts are created with the :ref:`onehost command <host_guide>`:

.. code::

    $ onehost create host01 -i kvm -v kvm -n 802.1Q

802.1Q Options
--------------

It is possible specify the start VLAN ID by editing ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``.

This driver accepts an ``MTU`` attribute that will be used when creating the tagged interface and bridge.

Driver Actions
--------------

+-----------+----------------------------------------------------------------------------------------------------------+
|   Action  |                                               Description                                                |
+===========+==========================================================================================================+
| **Pre**   | Creates a VAN interface through PHYDEV, creates a bridge (if needed) and attaches the vxlan device.      |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Post**  | When the VM is associated to a security group, the corresponding iptables rules are applied.             |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The VLAN tagged interface and bridge are kept in the Host to speed up future VMs |
+-----------+----------------------------------------------------------------------------------------------------------+

Usage
=====

The driver will be automatically applied to every Virtual Machine deployed in the Host. However, this driver requires a special configuration in the :ref:`Virtual Network template <vnet_template>`: only the virtual networks with the attribute ``VLAN`` set to ``YES`` will be isolated. The attribute PHYDEV must be also defined, with the name of the physical network device that will be attached to the bridge. The BRIDGE attribute is not mandatory, if it isn't defined, OpenNebula will generate one automatically.

.. code::

    NAME    = "hmnet"
         
    PHYDEV  = "eth0"
    VLAN    = "YES"
    VLAN_ID = 50        # optional
    BRIDGE  = "brhm"    # optional
     
    ...

In this scenario, the driver will check for the existence of the ``brhm`` bridge. If it doesn't exist it will be created. ``eth0`` will be tagged (``eth0.<vlan_id>``) and attached to ``brhm`` (unless it's already attached).

.. warning:: Any user with Network creation/modification permissions may force a custom vlan id with the ``VLAN_ID`` parameter in the network template. You **MUST** restrict permissions on Network creation to admin groups with :ref:`ACL rules <manage_acl>`. Regular uses will then be able to safely make address reservations on the Networks.

Tuning & Extending
==================

.. warning:: Remember that any change in the ``/var/lib/one/remotes`` directory won't be effective in the Hosts until you execute, as oneadmin:

The code can be enhanced and modified, by chaning the following files in the
frontend:

* /var/lib/one/remotes/vnm/802.1Q/post
* /var/lib/one/remotes/vnm/802.1Q/vlan_tag_driver.rb
* /var/lib/one/remotes/vnm/802.1Q/clean
* /var/lib/one/remotes/vnm/802.1Q/pre

Remember to sync any changes to the notes and to backup the changes in order to re-apply them after upgrading to a new release of OpenNebula:

.. code::

    oneadmin@frontend $ onehost sync
