.. _networking_node:

====================
Node Setup
====================

This guide includes specific node setup steps to enable each network mode. You **only need** to apply the corresponding section to the selected mode.

Bridged Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages are installed. See the :ref:`KVM node <kvm_node>`, the :ref:`LXC node <lxc_node>` and the :ref:`Firecracker node <fc_node>` installation sections for more details.

* By default, network isolation is provided through ``ebtables``. This package needs to be installed on nodes.

Configuration
--------------------------------------------------------------------------------
* No additional configuration is needed. If ``BRIDGE`` configured in the Virtual Network does not exist, a new Linux bridge will be created when the VM is instantiated.

802.1Q VLAN Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages are installed. See the :ref:`KVM node <kvm_node>`, the :ref:`LXC node <lxc_node>` and the :ref:`Firecracker node <fc_node>` installation sections for more details.

* The ``8021q`` module must be loaded in the kernel.

* A network switch capable of forwarding VLAN tagged traffic. The physical switch ports should be VLAN trunks.


Configuration
--------------------------------------------------------------------------------

No additional configuration is needed.


VXLAN Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages are installed. See the :ref:`KVM node <kvm_node>`, the :ref:`LXC node <lxc_node>` and the :ref:`Firecracker node <fc_node>` installation sections for more details.

* The node must run a Linux kernel (>3.7.0) that natively supports the VXLAN protocol and the associated iproute2 package.

* When all the nodes are connected to the same broadcasting domain, be sure that the multicast traffic is not filtered by any iptable rule in the nodes. Note that if the multicast traffic needs to traverse routers a multicast protocol like IGMP needs to be configured in your network.

Configuration
--------------------------------------------------------------------------------

No additional configuration is needed.

Open vSwitch Networking Mode
================================================================================

Requirements
--------------------------------------------------------------------------------
* The OpenNebula node packages are installed. See the :ref:`KVM node <kvm_node>`, the :ref:`LXC node <lxc_node>` and the :ref:`Firecracker node <fc_node>` installation sections for more details.

* You need to install Open vSwitch on each node. Please refer to the Open vSwitch documentation to do so.

Configuration
--------------------------------------------------------------------------------
* No additional configuration is needed. If ``BRIDGE`` configured in the Virtual Network does not exist, a Linux bridge and a Open vSwitch bridge will be created when the VM is instantiated. For example:

.. prompt:: text # auto

    # ovs-vsctl show
    61a35859-c8a3-4fd0-a30e-185aa568956f
        Bridge "ovsbr0"
            Port "enp0s8"
                Interface "enp0s8"
            Port "one-19-0"
                tag: 4
                Interface "one-19-0"
            Port "ovsbr0"
                Interface "ovsbr0"
                    type: internal

