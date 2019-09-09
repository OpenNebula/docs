.. _networking_node:

====================
Node Setup
====================

This guide includes specific node setup steps to enable each network mode. You **only need** to apply the corresponding section to the select mode.

Bridged Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages has been installed, see :ref:`the KVM node installation section <kvm_node>` for more details.

* By default, network isolation is provided through ``ebtables``, this package needs to be installed in the nodes.

Configuration
--------------------------------------------------------------------------------
* Create a linux bridge for each network that would be expose to Virtual Machines. Use the same name in all the nodes.

* Add the physical network interface to the bridge.

For example, a node with two networks one for public IP addresses (attached to eth0) and another one for private traffic (NIC eth1) should have two bridges:

.. prompt:: bash $ auto

    $ ip link show type bridge
    4: br0: ...
    5: br1: ...

    $ ip link show master br0
    2: eth0: ...

    $ ip link show master br1
    3: eth1: ...


.. note:: It is recommended that this configuration is made persistent. Please refer to the network configuration guide of your system to do so.


VLAN Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages has been installed, see :ref:`the KVM node installation section <kvm_node>` for more details.

* The ``8021q`` module must be loaded in the kernel.

* A network switch capable of forwarding VLAN tagged traffic. The physical switch ports should be VLAN trunks.


Configuration
--------------------------------------------------------------------------------

No additional configuration is needed.


VXLAN Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages has been installed, see :ref:`the KVM node installation section <kvm_node>` for more details.

* The node  must run a Linux kernel (>3.7.0) that natively supports the VXLAN protocol and the associated iproute2 package.

* When all the nodes are connected to the same broadcasting domain be sure that the multicast traffic is not filtered by any iptable rule in the nodes. Note that if the multicast traffic needs to traverse routers a multicast protocol like IGMP needs to be configured in your network.

Configuration
--------------------------------------------------------------------------------

No additional configuration is needed.

Open vSwitch Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages has been installed, see :ref:`the KVM node installation section <kvm_node>` for more details.

* You need to install Open vSwitch on each node. Please refer to the Open vSwitch documentation to do so.

For example, a node that forwards Virtual Networks traffic through the ``enp0s8`` network interface should create an openvswitch like:

.. prompt:: text # auto

    # ovs-vsctl show
    c61ba96f-fc11-4db9-9636-408e763f529e
        Bridge "ovsbr0"
            Port "ovsbr0"
                Interface "ovsbr0"
                    type: internal
            Port "enp0s8"
                Interface "enp0s8"

Configuration
--------------------------------------------------------------------------------
* Create a openvswitch for each network that would be expose to Virtual Machines. Use the same name in all the nodes.

* Add the physical network interface to the openvswitch.

.. note:: It is recommended that this configuration is made persistent. Please refer to the network configuration guide of your system to do so.

