.. _ddc_config_playbooks:

=============
Configuration
=============

Newly provisioned physical resources are mostly running only a base operating system without any additional services. Hosts need to pass the configuration phase to setup the additional software repositories, install packages, and configure and run necessary services to comply with the intended host purpose. This configuration process is fully handled by the ``oneprovision`` tool as part of the initial deployment (``oneprovision create``) or independent run anytime later (``oneprovision configure``).

.. note::

    Tool ``oneprovision`` has a seamless integration with `Ansible <https://www.ansible.com/>`__ (which needs to be already installed on the system). It's not necessary to be familiar with Ansible unless you need to make changes deep inside the configuration process.

As we use Ansible for host configuration, we'll share its terminology in this section.

* **task**: A single configuration step (e.g. package installation, service start)
* **role**: A set of related tasks (e.g. a role to deal with Linux bridges: utilities installation, bridge configure, and activation)
* **playbook**: A set of roles/tasks to configure several components at once (e.g. fully prepare a host as a KVM hypervisor)

The configuration phase can be parameterized to slightly change the configuration process (e.g. enable or disable particular OS features, or force a different repository location or version). These custom parameters are specified in the :ref:`configuration <ddc_provision_template_configuration>` section of the provision template. In most cases, the general defaults should meet requirements.

All code for Ansible (tasks, roles, playbooks) is installed into ``/usr/share/one/oneprovision/ansible/`` with the following high-level structure:

.. code::

    /usr/share/one/oneprovision/ansible
    |-- inventories
    |   |-- default
    |   |-- default_firecracker
    |   |-- default_lxd
    |   `-- static_vxlan
    |-- roles
    |   |-- bridged-networking
    |   |-- ddc
    |   |-- iptables
    |   |-- opennebula-node-firecracker
    |   |-- opennebula-node-kvm
    |   |-- opennebula-node-lxd
    |   |-- opennebula-p2p-vxlan
    |   |-- opennebula-repository
    |   |-- opennebula-ssh
    |   |-- python
    |   `-- tuntap
    |-- ansible.cfg.erb
    |-- default_firecracker.yml
    |-- default_lxd.yml
    |-- default.yml
    |-- dummy.yml
    `-- static_vxlan.yml

Description:

* ``*.yml``: playbooks
* ``inventories/``: parameters for each playbook
* ``roles/``: roles with tasks

The detailed description of all roles and their configuration parameters is in the separate chapter :ref:`Roles <ddc_config_roles>`, which is intended for advanced users.

.. _ddc_config_playbooks_overview:

=========
Playbooks
=========

Playbooks are extensive descriptions of the configuration process (what and how is installed and configured on the physical host). Each configuration description prepares a physical host from the initial to the final ready-to-use state. Each description can configure the host in a completely different way (e.g. KVM host with private networking, KVM host with shared NFS filesystem, or KVM host supporting Packet elastic IPs, etc.). :ref:`Configuration parameters <ddc_provision_template_configuration>` are only small tunables to the configuration process driven by the playbooks.

Before the deployment, a user must choose from the available playbooks to apply on the host(s).

You can use multiple playbooks at once, you just need to add a list in your provision template, e.g:

.. code::

    ---
    playbook:
      - default
      - mycustom

.. _ddc_config_playbooks_default:

Playbook 'default'
==================

.. note::

    **Description:**
    KVM host with host-only networking and NAT

This configuration prepares the host with

* KVM hypervisor
* network 1: bridge ``br0`` for the private host-only networking and NAT
* masquerade (NAT) to allow VMs from **network 1** to access public services

.. important::

    If more physical hosts are created, the private traffic of the virtual machines isn't routed between them. Virtual machines on different hosts are isolated, despite sharing the same private address space! This is the simplest configuration type.

Networking 1 (host-only with NAT)
---------------------------------

On the physical host, the IP configuration of prepared bridge ``br0`` (with TAP interface ``tap0``) is the same on all hosts:

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

In OpenNebula, the :ref:`virtual network <manage_vnets>` for the virtual machines can be defined by the following template:

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
----------

Main configuration parameters:

=====================================  ========================================== ===========
Parameter                              Value                                      Description
=====================================  ========================================== ===========
``bridged_networking_static_ip``       192.168.150.1                              IP address of the bridge
``bridged_networking_static_netmask``  255.255.255.0                              Netmask of the bridge
``opennebula_node_kvm_use_ev``         **True** or False                          Whether to use the ev package for kvm
``opennebula_node_kvm_param_nested``   True or **False**                          Enable nested KVM virtualization
``opennebula_repository_version``      5.10                                       OpenNebula repository version
``opennebula_repository_base``         ``https://downloads.opennebula.io/repo/``  Repository of the OpenNebula packages
                                       ``{{ opennebula_repository_version }}``
=====================================  ========================================== ===========

All parameters are covered in the :ref:`Configuration Roles <ddc_config_roles>`.

Configuration Steps
-------------------

The roles and tasks are applied during the configuration in the following order:

1. **python**: check and install Python required for Ansible
2. **ddc**: general asserts and cleanups
3. **opennebula-repository**: set up the OpenNebula package repository
4. **opennebula-node-kvm**: install OpenNebula node KVM package
5. **opennebula-ssh**: deploy local SSH keys for the remote oneadmin
6. **tuntap**: create TAP ``tap0`` interface
7. **bridged-networking**: bridge Linux bridge ``br0`` with a TAP interface
8. **iptables**: create basic iptables rules and enable NAT

with the following configuration overrides to the :ref:`roles defaults <ddc_config_roles>`:

=================================== =====
Parameter                           Value
=================================== =====
``opennebula_node_kvm_use_ev``      true
``bridged_networking_iface``        tap0
``bridged_networking_iface_manage`` false
``bridged_networking_static_ip``    192.168.150.1
``iptables_masquerade_enabled``     true
``iptables_base_rules_strict``      false
=================================== =====

.. _ddc_config_playbooks_default_firecracker:

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
---------------------------------

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
----------

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
-------------------

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

.. _ddc_config_playbooks_default_lxd:

Playbook 'default_lxd'
======================

.. note::

    **Description:**
    LXD host with host-only networking and NAT

This configuration prepares the host with

* LXD hypervisor
* network 1: bridge ``br0`` for the private host-only networking and NAT
* masquerade (NAT) to allow VMs from **network 1** access the public services

.. important::

    If more physical hosts are created, the private traffic of the virtual machines isn't routed between them. Virtual machines on different hosts are isolated, despite sharing the same private address space! This is the simplest configuration type.

Networking 1 (host-only with NAT)
---------------------------------

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
----------

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
-------------------

The roles and tasks are applied during the configuration in the following order:

1. **python**: check and install Python required for Ansible
2. **ddc**: general asserts and cleanups
3. **opennebula-repository**: set up the OpenNebula package repository
4. **opennebula-node-lxd**: install OpenNebula node LXD package
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

.. _ddc_config_playbooks_static_vxlan:

Playbook 'static_vxlan'
=======================

.. note::

    **Description:**
    KVM host with static private networking and NAT.

This configuration prepares the host with

* KVM hypervisor
* network 1: bridge ``br0`` for the private host-only networking and NAT
* network 2: bridge ``vxbr100`` with static VXLAN connections among all provisioned hosts
* masquerade (NAT) to allow VMs from **network 1** access the public services

Networking 1 (host-only with NAT)
---------------------------------

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

Put the first network definition into your provision template:

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

or, just easily extend the shipped template with both network definitions by setting the ``extends`` attribute in the provision template:

.. code::

    extends: /usr/share/one/oneprovision/templates/static_vxlan.yaml

Manually
~~~~~~~~

In OpenNebula, the :ref:`virtual network <manage_vnets>` for the virtual machines can be defined by the following template:

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

Networking 2 (private among hosts)
----------------------------------

On the physical host, another bridge ``vxbr100`` will be created without any IP configuration.

============= =================
Parameter     Value
============= =================
Interface     ``vxbr100``
Slave         ``vxlan100``
Physical      ``bond0:0`` or ``eth0``
IP address    none
Netmask       none
============= =================

For **virtual machines**, any IPs distinct to existing IP ranges configured on the host can be used. For example:

============= =================
Parameter     Value
============= =================
IP address    any from range ``192.168.160.2 - 192.168.160.254``
Netmask       ``255.255.255.0``
Gateway (NAT) none
============= =================

Create OpenNebula Virtual Network
---------------------------------

From Provision Template
~~~~~~~~~~~~~~~~~~~~~~~

Put the second network definition into your provision template:

.. code::

    networks:
      - name:        "private"
        vn_mad:      "dummy"
        bridge:      "vxbr100"
        mtu:         "1450"
        description: "Private networking"
        ar:
          - ip:   "192.168.160.2"
            size: "253"
            type: "IP4"

or, just easily extend the shipped template with both network definitions by setting the ``extends`` attribute in the provision template:

.. code::

    extends: /usr/share/one/oneprovision/templates/static_vxlan.yaml

Manually
~~~~~~~~

In the OpenNebula, the :ref:`virtual network <manage_vnets>` for the virtual machines can be defined by the following template:

.. code::

    NAME        = "private"
    VN_MAD      = "dummy"
    BRIDGE      = "vxbr100"
    MTU         = 1450
    DESCRIPTION = "Private networking"

    AR=[
        TYPE = "IP4",
        IP   = "192.168.160.2",
        SIZE = "253"
    ]

Put the template above into a file and execute the following command to create a virtual network:

.. code::

    $ onevnet create net2.tpl
    ID: 2

Parameters
----------

Main configuration parameters:

=====================================  ========================================== ===========
Parameter                              Value                                      Description
=====================================  ========================================== ===========
``bridged_networking_static_ip``       192.168.150.1                              IP address of the bridge
``bridged_networking_static_netmask``  255.255.255.0                              Netmask of the bridge
``opennebula_node_kvm_use_ev``         **True** or False                          Whether to use the ev package for kvm
``opennebula_node_kvm_param_nested``   True or **False**                          Enable nested KVM virtualization
``opennebula_repository_version``      5.10                                       OpenNebula repository version
``opennebula_repository_base``         ``https://downloads.opennebula.io/repo/``  Repository of the OpenNebula packages
                                       ``{{ opennebula_repository_version }}``
=====================================  ========================================== ===========

All parameters are covered in the :ref:`Configuration Roles <ddc_config_roles>`.

Configuration Steps
-------------------

The roles and tasks are applied during the configuration in the following order:

1. **python**: check and install Python required for Ansible
2. **ddc**: general asserts and cleanups
3. **opennebula-repository**: set up the OpenNebula package repository
4. **opennebula-node-kvm**: install OpenNebula node KVM package
5. **opennebula-ssh**: deploy local SSH keys for the remote oneadmin
6. **tuntap**: create TAP ``tap0`` interface
7. **bridged-networking**: bridge Linux bridge ``br0`` with a TAP interface
8. **opennebula-p2p-vxlan**: bridge ``vxlan100`` with static VXLAN connections among hosts
9. **iptables**: create basic iptables rules and enable NAT

with the following configuration overrides to the :ref:`roles defaults <ddc_config_roles>`:

========================================= =====
Parameter                                 Value
========================================= =====
``opennebula_node_kvm_use_ev``            true
``bridged_networking_iface``              tap0
``bridged_networking_iface_manage``       false
``bridged_networking_static_ip``          192.168.150.1
``iptables_masquerade_enabled``           true
``iptables_base_rules_strict``            false
``opennebula_p2p_vxlan_bridge``           vxbr100
``opennebula_p2p_vxlan_phydev``           bond0:0 or eth0
``opennebula_p2p_vxlan_vxlan_vni``        100
``opennebula_p2p_vxlan_vxlan_dev``        vxlan100
``opennebula_p2p_vxlan_vxlan_local_ip``   autodetect IPv4 address on bond0:0 or eth0
``opennebula_p2p_vxlan_remotes``          autodetect list of IPv4 on bond0:0 or eth0 from all hosts
========================================= =====
