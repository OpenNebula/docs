===========
802.1Q VLAN
===========

This guide describes how to enable Network isolation provided through
host-managed VLANs. This driver will create a bridge for each OpenNebula
Virtual Network and attach an VLAN tagged network interface to the
bridge. This mechanism is compliant with `IEEE
802.1Q <http://en.wikipedia.org/wiki/IEEE_802.1Q>`__.

The VLAN id will be the same for every interface in a given network,
calculated by adding a constant to the network id. It may also be forced
by specifying an VLAN\_ID parameter in the `Virtual Network
template </./vnet_template>`__.

Requirements
============

A network switch capable of forwarding VLAN tagged traffic. The physical
switch ports should be VLAN trunks.

Considerations & Limitations
============================

This driver requires some previous work on the network components,
namely the switches, to enable VLAN trunking in the network interfaces
connected to the OpenNebula hosts. If this is not activated the VLAN
tags will not get trough and the network will behave erratically.

In OpenNebula 3.0, this functionality was provided through a hook, and
it wasn't effective after a migration. Since OpenNebula 3.2 this
limitation does not apply.

Configuration
=============

Hosts Configuration
-------------------

-  The **``sudoers``** file must be configured so **``oneadmin``** can
execute **``vconfig``**, **``brctl``** and **``ip``** in the hosts.
-  The package **``vconfig``** must be installed in the hosts.
-  Hosts must have the module **``8021q``** loaded.

To enable VLAN (802.1Q) support in the kernel, one must load the 8021q
module:

.. code::

$ modprobe 8021q

If the module is not available, please refer to your distribution's
documentation on how to install it. This module, along with the
``vconfig`` binary which is also required by the script, is generally
supplied by the ``vlan`` package.

OpenNebula Configuration
------------------------

To enable this driver, use **802.1Q** as the Virtual Network Manager
driver parameter when the hosts are created with the `onehost
command </./host_guide>`__:

.. code::

$ onehost create host01 -i kvm -v kvm -n 802.1Q

Driver Actions
--------------

+-------------+------------------------------------------------------------------------------------------------------------+
| Action      | Description                                                                                                |
+=============+============================================================================================================+
| **Pre**     | Creates a VLAN tagged interface in the Host and a attaches it to a dynamically created bridge.             |
+-------------+------------------------------------------------------------------------------------------------------------+
| **Post**    | -                                                                                                          |
+-------------+------------------------------------------------------------------------------------------------------------+
| **Clean**   | It doesn't do anything. The VLAN tagged interface and bridge are kept in the Host to speed up future VMs   |
+-------------+------------------------------------------------------------------------------------------------------------+

Usage
=====

The driver will be automatically applied to every Virtual Machine
deployed in the Host. However, this driver requires a special
configuration in the `Virtual Network template </./vnet_template>`__:
only the virtual networks with the attribute **``VLAN``** set to
**``YES``** will be isolated. The attribute PHYDEV must be also defined,
with the name of the physical network device that will be attached to
the bridge. The BRIDGE attribute is not mandatory, if it isn't defined,
OpenNebula will generate one automatically.

.. code:: code

NAME    = "hmnet"
TYPE    = "fixed"
 
PHYDEV  = "eth0"
VLAN    = "YES"
VLAN_ID = 50        # optional
BRIDGE  = "brhm"    # optional
 
LEASES = ...

In this scenario, the driver will check for the existence of the
``brhm`` bridge. If it doesn't exist it will be created. ``eth0`` will
be tagged (``eth0.<vlan_id>``) and attached to ``brhm`` (unless it's
already attached).

|:!:| Any user with Network creation/modification permissions may force
a custom vlan id with the ``VLAN_ID`` parameter in the network template.
In that scenario, any user may be able to connect to another network
with the same network id. Techniques to avoid this are explained under
the Tuning & Extending section.

Tuning & Extending
==================

|:!:| Remember that any change in the ``/var/lib/one/remotes`` directory
won't be effective in the Hosts until you execute, as oneadmin:

.. code::

oneadmin@frontend $ onehost sync

This way in the next monitoring cycle the updated files will be copied
again to the Hosts.

Calculating VLAN ID
-------------------

The vlan id is calculated by adding the network id to a constant defined
in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.rb``. You can customize
that value to your own needs:

.. code:: code

CONF = {
:start_vlan => 2
}

Restricting Manually the VLAN ID
--------------------------------

You can either restrict permissions on Network creation with `ACL
rules </./manage_acl>`__, or you can entirely disable the possibility to
redefine the VLAN\_ID by modifying the source code of
``/var/lib/one/remotes/vnm/802.1Q/HostManaged.rb``. Change these lines:

.. code:: code

if nic[:vlan_id]
vlan = nic[:vlan_id]
else
vlan = CONF[:start_vlan] + nic[:network_id].to_i
end

with this one:

.. code:: code

vlan = CONF[:start_vlan] + nic[:network_id].to_i

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
