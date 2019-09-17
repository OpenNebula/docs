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

To enable hooks, you have to create the following hooks using the command ``onehook create``:

.. code::

    $ cat running_hook

    ARGUMENTS       = "$TEMPLATE"
    ARGUMENTS_STDIN = "yes"
    COMMAND         = "alias_ip/alias_ip.rb"
    LCM_STATE       = "RUNNING"
    NAME            = "alias_ip_running"
    REMOTE          = "NO"
    RESOURCE        = "VM"
    STATE           = "ACTIVE"
    TYPE            = "state"

    $ onehook create running_hook

.. code::

    $ cat hotplug_hook

    ARGUMENTS       = "$TEMPLATE"
    ARGUMENTS_STDIN = "yes"
    COMMAND         = "alias_ip/alias_ip.rb"
    LCM_STATE       = "HOTPLUG_NIC"
    NAME            = "alias_ip_hotplug"
    ON              = "CUSTOM"
    REMOTE          = "NO"
    RESOURCE        = "VM"
    STATE           = "ACTIVE"
    TYPE            = "state"

    $ onehook create hotplug_hook

.. code::

    $ cat done_hook

    ARGUMENTS       = "$TEMPLATE"
    ARGUMENTS_STDIN = "yes"
    COMMAND         = "alias_ip/alias_ip.rb"
    NAME            = "alias_ip_done"
    ON              = "DONE"
    REMOTE          = "NO"
    RESOURCE        = "VM"
    TYPE            = "state"

    $ onehook create done_hook
