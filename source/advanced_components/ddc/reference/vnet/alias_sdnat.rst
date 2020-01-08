.. _ddc_vnet_alias_sdnat:

===================================
NAT Mapping Driver for Aliased NICs
===================================

.. note::

    Feature available since **OpenNebula 5.8.5** only.

This driver configures SNAT and DNAT firewall rules on the hypervisor host to seamlessly translate traffic between Virtual Machines' **external NIC aliased** (public) IP addresses and directly attached main NIC private IP addresses. It provides an "elastic IP"-like functionality. When a Virtual Machine is reachable over different (external NIC aliased) IP address, then that is directly configured in the Virtual Machine.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines, and only if all the following drivers and hook are used together:

    * IPAM driver for :ref:`Packet <ddc_ipam_packet>`
    * Hook for :ref:`NIC Alias IP <ddc_hooks_alias_ip>`
    * Virtual Network :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`

The schema of traffic flow:

.. image:: /images/ddc_alias_sdnat.png
    :width: 80%
    :align: center

When a client contacts the Virtual Machine over its public IP, the traffic arrives on the Hypervisor Host. The mapping driver creates rules which transparently translate the destination address to the VM's private IP, which is sent to the Virtual Machine. Virtual Machines receive the traffic with the original source address of the client, but the destination address is rewritten to its private IP. If a Virtual Machine initiates communication with the public Internet, the source address in the traffic outgoing from the Virtual Machine is rewritten to the public IP of the Hypervisor Host.

To enable the driver, add the following section into your ``oned.conf`` configuration file:

.. code::

    VN_MAD_CONF = [
        NAME = "alias_sdnat",
        BRIDGE_TYPE = "linux"
    ]

After that, you have to restart OpenNebula so the change takes effect.
