.. _ddc_ipam_packet:

==================
Packet IPAM driver
==================

.. note::

    Feature available since **OpenNebula 5.8.5** only.

This IPAM driver is responsible for managing the public IPv4 ranges on Packet as IPv4 Address Ranges within the OpenNebula Virtual Networks. Manages full lifecycles of the Address Range from allocation of new custom range to its releasing. Read more about :ref:`IPAM Driver <devel-ipam>` in the Integration Guide.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines and only if all following drivers and hook are used together:

    * IPAM driver for :ref:`Packet <ddc_ipam_packet>`
    * Hook for :ref:`NIC Alias IP <ddc_hooks_alias_ip>`
    * Virtual Network :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`

To enable the Packet IPAM, you need to update ``IPAM_MAD`` section in your ``oned.conf`` configuration file to look like:

.. code::

    IPAM_MAD = [
        EXECUTABLE = "one_ipam",
        ARGUMENTS  = "-t 1 -i dummy,packet"
    ]

After that, you have to restart OpenNebula so the change takes effect.

Create Address Range
====================

IPAM managed Address Range can be created during the creation of new Virtual Network or any time later as additional Address Range into existing Virtual Network. Follow the :ref:`Virtual Network Management <manage_vnets>` documentation.

The Packet IPAM managed Address Range requires following template parameters to be provided:

================== =============== ===========
Parameter          Value           Description
================== =============== ===========
``IP``                             Random fake starting IP address of the range
``TYPE``           ``IPV4``        OpenNebula Address Range type
``SIZE``                           Number of IPs to request
``IPAM_MAD``       ``packet``      IPAM driver name
``PACKET_IP_TYPE`` ``public_ipv4`` Types of IPs to request
``FACILITY``                       Packet datacenter name
``PACKET_PROJECT``                 Packet project ID
``PACKET_TOKEN``                   Packet API token
================== =============== ===========

.. warning::

    Due to a `bug in OpenNebula <https://github.com/OpenNebula/one/issues/3615>`__, you need to always provide fake starting ``IP`` for the new address range. Unfortunately, this IP address won't be respected and only the IPs provided by Packet will be always used.

To create the address range:

.. code::

    $ cat packet_ar
        AR = [
            IP             = "192.0.2.0",
            TYPE           = IP4,
            SIZE           = 2,
            IPAM_MAD       = "packet",
            PACKET_IP_TYPE = "public_ipv4",
            FACILITY       = "ams1",
            PACKET_PROJECT = "****************",
            PACKET_TOKEN   = "****************",
        ]

    $ onevnet addar <vnetid> --file packet_ar
