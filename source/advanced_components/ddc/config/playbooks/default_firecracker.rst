.. _ddc_config_playbooks_default_firecracker:

==============================
Playbook 'default_firecracker'
==============================

.. note::

    **Description:**
    Firecracker host with host-only networking and NAT

This configuration prepares the host with

* Firecracker hypervisor
* network 1: bridge ``br0`` for the private host-only networking and NAT
* masquerade (NAT) to allow VMs from **network 1** access the public services

.. important::

    If more physical hosts are created, the private traffic of the virtual machines isn't routed between them. Virtual machines on different hosts are isolated, despite sharing the same private address space! This is the simplest configuration type.

Networking 1 (host-only with NAT)
=================================

On the physical host, the IP configuration of prepared bridge ``br0`` (with TAP interface ``tap0``) is same on all hosts:

============= =================
Parameter     Value
============= =================
Interface     ``br0``
Slave         ``tap0``
IP address    ``192.168.150.1``
Netmask       ``255.255.255.0``
============= =================

For **virtual machines**, the following IP configuration can be used:

============= =================
Parameter     Value
============= =================
IP address    any from range ``192.168.150.2 - 192.168.150.254``
Netmask       ``255.255.255.0``
Gateway (NAT) ``192.168.150.1``
============= =================

Create OpenNebula Virtual Network
---------------------------------

From Provision Template
~~~~~~~~~~~~~~~~~~~~~~~

Put the full network definition into your provision template:

.. code::

    networks:
      - name: "nat"
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking with NAT"
        ar:
          - ip: "192.168.150.2"
            size: 253
            type: IP4

or, just easily extend the shipped template with the above definition by setting the ``extends`` attribute in the provision template:

.. code::

    extends: /usr/share/one/oneprovision/templates/default.yaml

Manually
~~~~~~~~

In the OpenNebula, the :ref:`virtual network <manage_vnets>` for the virtual machines can be defined by the following template:

.. code::

    NAME        = "nat"
    VN_MAD      = "dummy"
    BRIDGE      = "br0"
    DNS         = "8.8.8.8 8.8.4.4"
    GATEWAY     = "192.168.150.1"
    DESCRIPTION = "Host-only networking with NAT"

    AR=[
        TYPE = "IP4",
        IP   = "192.168.150.2",
        SIZE = "253"
    ]

Put the template above into a file and execute the following command to create a virtual network:

.. code::

    $ onevnet create net1.tpl
    ID: 1

Parameters
==========

Main configuration parameters:

=====================================  ========================================== ===========
Parameter                              Value                                      Description
=====================================  ========================================== ===========
``bridged_networking_static_ip``       192.168.150.1                              IP address of the bridge
``bridged_networking_static_netmask``  255.255.255.0                              Netmask of the bridge
``opennebula_repository_version``      5.10                                       OpenNebula repository version
``opennebula_repository_base``         ``https://downloads.opennebula.io/repo/``  Repository of the OpenNebula packages
                                       ``{{ opennebula_repository_version }}``
=====================================  ========================================== ===========

All parameters are covered in the :ref:`Configuration Roles <ddc_config_roles>`.

Configuration Steps
===================

The roles and tasks are applied during the configuration in the following order:

1. **python**: check and install Python required for Ansible
2. **ddc**: general asserts and cleanups
3. **opennebula-repository**: set up the OpenNebula package repository
4. **opennebula-node-firecracker**: install OpenNebula node Firecracker package
5. **opennebula-ssh**: deploy local SSH keys for the remote oneadmin
6. **tuntap**: create TAP ``tap0`` interface
7. **bridged-networking**: bridge Linux bridge ``br0`` with a TAP interface
8. **iptables**: create basic iptables rules and enable NAT

with the following configuration overrides to the :ref:`roles defaults <ddc_config_roles>`:

=================================== =====
Parameter                           Value
=================================== =====
``bridged_networking_iface``        tap0
``bridged_networking_iface_manage`` false
``bridged_networking_static_ip``    192.168.150.1
``iptables_masquerade_enabled``     true
``iptables_base_rules_strict``      false
=================================== =====
