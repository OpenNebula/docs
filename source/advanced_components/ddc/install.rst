.. _ddc_install:

=============================
Introduction and Installation
=============================

Introduction
============

This tool allows you to deploy a fully operational OpenNebula cluster in a remote provider. Each new provision is described by the :ref:`provision template <ddc_provision_template>`, a YAML document specifying the OpenNebula resources to add (cluster, hosts, datastores, virtual networks), physical resources to provision from the remote infrastructure provider, the connection parameters for SSH and configuration steps (playbook) with tunables. The template is prepared by an experienced Cloud Administrator and passed to the command line tool ``oneprovision``. At the end of the process, there is a new cluster available in OpenNebula.

.. image:: /images/ddc_create.png
    :width: 50%
    :align: center

All operations with the provision and physical resources are performed only with the command line tool ``oneprovision``: create a new provision, manage (reboot, reset, power off, resume) the existing provisions, and delete the provision at the end.

In this chapter we will cover the installation of the tool and also the extra configuration steps that need to be done in OpenNebula in order to use a part of the functionality.

Installation
============

All functionality is distributed as an optional operating system package ``opennebula-provision``, which must be installed on your **frontend alongside with the server packages**.

.. important::

    The tool requires `Ansible <https://www.ansible.com/>`__ to be installed on the same host(s) as well. There is **no automatic dependency** which would install Ansible automatically; you have to manage the installation of the required Ansible version on your own.

    Supported versions: Ansible 2.8.x and 2.9.x.

Tools
-----

Installation of the tools is as easy as the installation of any operating system package. Choose from the sections below based on your operating system. You also need to have installed the OpenNebula :ref:`front-end packages <frontend_installation>`.

CentOS/RHEL 7
-------------

.. prompt:: bash $ auto

   $ sudo yum install opennebula-provision

Debian/Ubuntu
-------------

.. prompt:: bash $ auto

   $ sudo apt-get install opennebula-provision

Ansible
-------

It's necessary to have Ansible installed. You can use a distribution package if there is a suitable version. Otherwise, you can install the required version via ``pip`` the following way:

CentOS/RHEL 7
-------------

.. prompt:: bash $ auto

   $ sudo yum install python-pip

Debian/Ubuntu
-------------

.. prompt:: bash $ auto

   $ sudo apt-get install python-pip

and, then install Ansible:

.. prompt:: bash $ auto

   $ sudo pip install 'ansible>=2.8.0,<2.10.0'

Check that Ansible is installed properly:

.. prompt:: bash $ auto

    ansible 2.9.9
      config file = None
      configured module search path = [u'/var/lib/one/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /bin/ansible
      python version = 2.7.5 (default, Apr  2 2020, 13:16:51) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)]

.. note:: You need to have Jinja2 version 2.10.0 (or higher). If your operating system is shipped with older, do upgrade with the following command:

    .. prompt:: bash $ auto

        $ sudo pip install 'Jinja2>=2.10.0'

OpenNebula Configuration
========================

.. important:: These steps are only needed if you are going to use Packet and you want that virtual machines have public connectivity. If you are going to use a different scenario you can skip it.

.. _ddc_hooks_alias_ip:

NIC Alias IP Hook
-----------------

.. note::

    Feature available since **OpenNebula 5.8.5** only.

This hook ensures the IPAM-managed IP addresses are assigned to the physical host where the particular Virtual Machines are running. The hook is triggered on significant Virtual Machine state changes — when it starts, when a new NIC is hotplugged and when the Virtual Machine is destroyed. Read more about :ref:`Using Hooks <hooks>` in the Integration Guide.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines, and only if all the following drivers and hook are used together:

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
    ON              = "CUSTOM"
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

You can find all the templates in ``/usr/share/one/examples/alias_ip``.

.. _ddc_vnet_alias_sdnat:

NAT Mapping Driver for Aliased NICs
-----------------------------------

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

.. _ddc_ipam_packet:

Packet IPAM driver
------------------

.. note::

    Feature available since **OpenNebula 5.8.5** only.

This IPAM driver is responsible for managing the public IPv4 ranges on Packet as IPv4 Address Ranges within the OpenNebula Virtual Networks. It manages full lifecycles of the Address Range from allocation of a new custom range to its release. Read more about the :ref:`IPAM Driver <devel-ipam>` in the Integration Guide.

.. important::

    The functionality can be used **only for external NIC aliases** (secondary addresses) of the virtual machines, and only if all the following drivers and hooks are used together:

    * IPAM driver for :ref:`Packet <ddc_ipam_packet>`
    * Hook for :ref:`NIC Alias IP <ddc_hooks_alias_ip>`
    * Virtual Network :ref:`NAT Mapping Driver for Aliased NICs <ddc_vnet_alias_sdnat>`

To enable the Packet IPAM, you need to update the ``IPAM_MAD`` section in your ``oned.conf`` configuration file to look like:

.. code::

    IPAM_MAD = [
        EXECUTABLE = "one_ipam",
        ARGUMENTS  = "-t 1 -i dummy,packet"
    ]

After that, you have to restart OpenNebula so the change takes effect.

Create Address Range
--------------------

An IPAM-managed Address Range can be created during the creation of a new Virtual Network, or any time later as an additional Address Range in an existing Virtual Network. Follow the :ref:`Virtual Network Management <manage_vnets>` documentation.

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
