.. _openvswitch:

=============
Open vSwitch
=============

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ network drives. They provide two indepent functionalities that can be used together: network isolation using VLANs, and network filtering using OpenFlow. Each Virtual Network interface will receive a VLAN tag enabling network isolation. Other traffic attributes that may be configured through Open vSwitch are not modified.

The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an VLAN\_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

The network filtering functionality is very similar to the :ref:`Firewall <firewall>` drivers, with a few limitations discussed below.

Requirements
============

This driver requires Open vSwitch to be installed on each OpenNebula Host. Follow the resources specified in :ref:`hosts\_configuration <openvswitch_hosts_configuration>` to install it.

Considerations & Limitations
============================

Integrating OpenNebula with Open vSwitch brings a long list of benefits to OpenNebula, read `Open vSwitch Features <http://openvswitch.org/features/>`__ to get a hold on these features.

This guide will address the usage of VLAN tagging and OpenFlow filtering of OpenNebula Virtual Machines. On top of that any other Open vSwitch feature may be used, but that's outside of the scope of this guide.

ovswitch and ovswitch\_brcompat
-------------------------------

OpenNebula ships with two sets of drivers that provide the same functionality: **ovswitch** and **ovsvswitch\_brcompat**. The following list details the differences between both drivers:

-  ``ovswitch``: Recommended for ``kvm`` hosts. Only works with ``kvm``. Doesn't require the `Open vSwitch compatibility layer for Linux bridging <http://openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob_plain;f=INSTALL.bridge;hb=HEAD>`__.
-  ``ovswitch_brcompat``: Works with ``kvm`` and ``xen``. This is the only set that currently works with ``xen``. Not recommended for ``kvm``. Requires `Open vSwitch compatibility layer for Linux bridging <http://openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob_plain;f=INSTALL.bridge;hb=HEAD>`__.

Configuration
=============

.. _openvswitch_hosts_configuration:

Hosts Configuration
-------------------

-  You need to install Open vSwitch on each OpenNebula Host. Please refer to the `Open vSwitch documentation <http://openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob_plain;f=INSTALL.Linux;hb=HEAD>`__ to do so.
-  If using ``ovswitch_brcompat`` it is also necessary to install the `Open vSwitch compatibility layer for Linux bridging <http://openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob_plain;f=INSTALL.bridge;hb=HEAD>`__.
-  The ``sudoers`` file must be configured so ``oneadmin`` can execute ``ovs_vsctl`` in the hosts.

OpenNebula Configuration
------------------------

To enable this driver, use **ovswitch** or **ovswitch\_brcompat** as the Virtual Network Manager driver parameter when the hosts are created with the :ref:`onehost command <host_guide>`:

.. code::

    # for kvm hosts
    $ onehost create host01 -i kvm -v kvm -n ovswitch

    # for xen hosts
    $ onehost create host02 -i xen -v xen -n ovswitch_brcompat

Open vSwitch Options
--------------------

It is possible to disable the ARP Cache Poisoning prevention rules by changing this snippet in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``:

.. code::

    # Enable ARP Cache Poisoning Prevention Rules
    :arp_cache_poisoning: true

The start VLAN id can also be set in that file.

Driver Actions
--------------

+-----------+--------------------------------------------------------------------------------------------------------------+
|   Action  |                                                 Description                                                  |
+===========+==============================================================================================================+
| **Pre**   | N/A                                                                                                          |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Post**  | Performs the appropriate Open vSwitch commands to tag the virtual tap interface.                             |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The virtual tap interfaces will be automatically discarded when the VM is shut down. |
+-----------+--------------------------------------------------------------------------------------------------------------+

Multiple VLANs (VLAN trunking)
------------------------------

VLAN trunking is also supported by adding the following tag to the ``NIC`` element in the VM template or to the virtual network template:

-  ``VLAN_TAGGED_ID``: Specify a range of VLANs to tag, for example: ``1,10,30,32``.

Usage
=====

Network Isolation
-----------------

The driver will be automatically applied to every Virtual Machine deployed in the Host. Only the virtual networks with the attribute ``VLAN`` set to ``YES`` will be isolated. There are no other special attributes required.

.. code::

    NAME    = "ovswitch_net"
    BRIDGE  = vbr1
     
    VLAN    = "YES"
    VLAN_ID = 50        # optional
     
    ...

.. warning:: Any user with Network creation/modification permissions may force a custom vlan id with the ``VLAN_ID`` parameter in the network template. In that scenario, any user may be able to connect to another network with the same network id. Techniques to avoid this are explained under the Tuning & Extending section.

Network Filtering
-----------------

The first rule that is always applied when using the Open vSwitch drivers is the MAC-spoofing rule, that prevents any traffic coming out of the VM if the user changes the MAC address.

The firewall directives must be placed in the :ref:`network section <template_network_section>` of the Virtual Machine template. These are the possible attributes:

-  ``BLACK_PORTS_TCP = iptables_range``: Doesn't permit access to the VM through the specified ports in the TCP protocol. Superseded by WHITE\_PORTS\_TCP if defined.
-  ``BLACK_PORTS_UDP = iptables_range``: Doesn't permit access to the VM through the specified ports in the UDP protocol. Superseded by WHITE\_PORTS\_UDP if defined.
-  ``ICMP = drop``: Blocks ICMP connections to the VM. By default it's set to accept.

``iptables_range``: a list of ports separated by commas, e.g.: ``80,8080``. Currently no ranges are supporteg, e.g.: ``5900:6000`` is **not** supported.

Example:

.. code::

    NIC = [ NETWORK_ID = 3, BLACK_PORTS_TCP = "80, 22", ICMP = drop ]

Note that WHITE\_PORTS\_TCP and BLACK\_PORTS\_TCP are mutually exclusive. In the event where they're both defined the more restrictive will prevail i.e. WHITE\_PORTS\_TCP. The same happens with WHITE\_PORTS\_UDP and BLACK\_PORTS\_UDP.

Tuning & Extending
==================

.. warning:: Remember that any change in the ``/var/lib/one/remotes`` directory won't be effective in the Hosts until you execute, as oneadmin:

.. code::

    oneadmin@frontend $ onehost sync

This way in the next monitoring cycle the updated files will be copied again to the Hosts.

Restricting Manually the VLAN ID
--------------------------------

You can either restrict permissions on Network creation with :ref:`ACL rules <manage_acl>`, or you can entirely disable the possibility to redefine the VLAN\_ID by modifying the source code of ``/var/lib/one/remotes/vnm/ovswitch/OpenvSwitch.rb``. Change these lines:

.. code::

                    if nic[:vlan_id]
                        vlan = nic[:vlan_id]
                    else
                        vlan = CONF[:start_vlan] + nic[:network_id].to_i
                    end

with this one:

.. code::

                    vlan = CONF[:start_vlan] + nic[:network_id].to_i

OpenFlow Rules
--------------

To modify these rules you have to edit: ``/var/lib/one/remotes/vnm/ovswitch/OpenvSwitch.rb``.

**Mac-spoofing**

These rules prevent any traffic to come out of the port the MAC address has changed.

.. code::

    in_port=<PORT>,dl_src=<MAC>,priority=40000,actions=normal
    in_port=<PORT>,priority=39000,actions=normal

**IP hijacking**

These rules prevent any traffic to come out of the port for IPv4 IP's not configured for a VM

.. code::

    in_port=<PORT>,arp,dl_src=<MAC>priority=45000,actions=drop
    in_port=<PORT>,arp,dl_src=<MAC>,nw_src=<IP>,priority=46000,actions=normal

**Black ports (one rule per port)**

.. code::

    tcp,dl_dst=<MAC>,tp_dst=<PORT>,actions=drop

**ICMP Drop**

.. code::

    icmp,dl_dst=<MAC>,actions=drop

