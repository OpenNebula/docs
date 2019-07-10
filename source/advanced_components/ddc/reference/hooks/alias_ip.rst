.. _ddc_hooks_alias_ip:

=================
NIC Alias IP Hook
=================

.. note::

    Feature available since **OpenNebula 5.8.5** only.

This hook ensures the IPAM managed IP addresses are assigned to the physical host where the particular Virtual Machines are running. Hook is triggered on significant Virtual Machine state changes - when it starts, when new NIC is hotplugged and when Virtual Machine is destroyed. Read more about :ref:`Using Hooks <hooks>` in the Integration Guide.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines and only if all following drivers and hook are used together:

    * IPAM driver for :ref:`Packet <ddc_ipam_packet>`
    * Hook for :ref:`NIC Alias IP <ddc_hooks_alias_ip>`
    * Virtual Network :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`

To enable hook, add the following sections into your ``oned.conf`` configuration file:

.. code::

    VM_HOOK = [
        name      = "alias_ip_running",
        on        = "RUNNING",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

    VM_HOOK = [
        name      = "alias_ip_hotplug",
        on        = "CUSTOM",
        state     = "ACTIVE",
        lcm_state = "HOTPLUG_NIC",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

    VM_HOOK = [
        name      = "alias_ip_done",
        on        = "DONE",
        command   = "alias_ip/alias_ip.rb",
        arguments = "$ID $TEMPLATE"
    ]

After that, you have to restart OpenNebula so the change takes effect.
