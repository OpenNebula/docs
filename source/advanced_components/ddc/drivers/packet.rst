.. _ddc_driver_packet:

=============
Packet Driver
=============

Requirements:

* existing Packet project
* generated Packet `API token <https://help.packet.net/quick-start/api-integrations>`_

Supported Packet hosts:

* operating systems: ``centos_7``, ``ubuntu_16_04``, ``ubuntu_18_04``
* plans: all plans are supported. You can check `here <https://www.packet.com/cloud/locations/>`__ the plans availables per facility.

.. _ddc_driver_packet_params:

Provision parameters
====================

The parameters specifying the Packet provision are set in the **provision section** of the :ref:`provision template <ddc_provision_template>`. The following table shows mandatory and optional provision parameters for the Packet driver. No other options/features are supported.

================== ========= ===========
Parameter          Mandatory Description
================== ========= ===========
``packet_project`` **YES**   ID of the existing project you want to deploy the new host
``packet_token``   **YES**   API token
``facility``       **YES**   Datacenter to deploy the host
``plan``           **YES**   Type of HW plan (Packet ID or slug)
``os``             **YES**   Operating system (Packet ID or slug)
``hostname``       NO        Hostname set in the booted operating system (and on Packet dashboard)
``billing_cycle``  NO        Billing period
``userdata``       NO        Custom EC2-like user data passed to the ``cloud-init`` running on host
``tags``           NO        Host tags in the Packet inventory
================== ========= ===========

Example
=======

Example of a minimal Packet provision template:

.. code::

    ---
    name: myprovision

    defaults:
      provision:
        driver: packet
        packet_token: ********************************
        packet_project: ************************************
        facility: ams1
        plan: baremetal_0
        os: ubuntu_18_04

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "host1"


Public Networking
=================

.. note::

    Feature available since **OpenNebula 5.8.5** only.

OpenNebula provides means to allow the public networking for the Virtual Machines running on OpenNebula-managed hosts on Packet.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines and only if all the following drivers and hooks are configured:

    * IPAM driver for :ref:`Packet <ddc_ipam_packet>`
    * Hook for :ref:`NIC Alias IP <ddc_hooks_alias_ip>`
    * Virtual Network :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`

It's expected that you have the private host-only network in OpenNebula and a Linux bridge configured with the private IP address on the host. Any IP Masquerade (NAT) should be disabled, so as not to clash with the SNAT / DNAT ad-hoc rules created by the :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`.

Example provision template with network-only-related configuration:

.. code::

    ---
    playbook: default

    defaults:
      provision:
        driver: packet
        packet_token: ********************************
        packet_project: ************************************
        facility: ams1
        plan: baremetal_0
        os: ubuntu_18_04
      configuration:
        iptables_masquerade_enabled: False

    networks:
      - name: "host-only"
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking"
        ar:
          - ip: "192.168.150.2"
            size: 253
            type: IP4

      - name: "public"
        vn_mad: alias_sdnat
        external: yes
        description: "Public networking"
        ar:
          - size: 2
            type: IP4
            ipam_mad: packet
            packet_ip_type: public_ipv4
            facility: ams1
            packet_token: ********************************
            packet_project: ********************************
