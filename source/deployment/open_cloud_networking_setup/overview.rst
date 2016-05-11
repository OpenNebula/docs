.. _nm:

====================
Overview
====================

.. todo::

    * Architect
    * KVM

When a new Virtual Machine is launched, OpenNebula will connect its network interfaces (defined in the NIC section of the template) to the bridge or physical device specified in the :ref:`Virtual Network definition <vgg>`. This will allow the VM to have access to different networks, public or private.

* dummy: This driver will connect the NIC to the ``BRIDGE`` specified in the network. Security Group rules are ignored.
* :ref:`Security Groups <security_groups>`: Security Group rules are applied to filter specific traffic. Drivers based on Linux bridges (802.1Q, vxlan and ebtables) are prepared to work with the Security Groups driver.
* :ref:`802.1Q <hm-vlan>`: restrict network access through VLAN tagging, which also requires support from the hardware switches.
* :ref:`VXLAN <vxlan>`: implements VLANs using the VXLAN protocol that relies on a UDP encapsulation and IP multicast.
* :ref:`ebtables <ebtables>`: restrict network access through Ebtables rules. No special hardware configuration is required.
* :ref:`ovswitch <openvswitch>`: restrict network access with `Open vSwitch Virtual Switch <http://openvswitch.org/>`__.

The Virtual Network isolation is enabled with any of the ``801.1Q``, ``vxlan``, ``ebtables``, or ``ovswitch`` drivers. Additionally the drivers based on Linux bridges (``vxlan``, ``802.1Q`` and ``ebtables``) can be used with security groups driver to allow a regular OpenNebula user to filter TCP, UDP or ICMP traffic.

When you create a new network you will need to add the attribute ``VN_MAD`` to the template, specifying which of the above networking drivers you want to use.

.. note::

  Before OpenNebula 5.0, the networking driver was associated to the host, and not to the network.

Tuning & Extending
==================

Configuration
-------------

Some drivers have the ability to customize their behaviour by editing a configuration file. This file is located in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``.

Currently it supports the following options:

+---------------------+----------------------------+----------------------------------------------------------------------------------+
|      Parameter      |           Driver           |                                   Description                                    |
+=====================+============================+==================================================================================+
| arp_cache_poisoning | ovswitch                   | Enable ARP Cache Poisoning Prevention Rules.                                     |
+---------------------+----------------------------+----------------------------------------------------------------------------------+
| vxlan_mc            | vxlan                      | Base multicast address for each VLAN. The multicas sddress is vxlan_mc + vlan_id |
+---------------------+----------------------------+----------------------------------------------------------------------------------+
| vxlan_ttl           | vxlan                      | Time To Live (TTL) should be > 1 in routed multicast networks (IGMP)             |
+---------------------+----------------------------+----------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync`` to deploy the file to all the nodes.

Driver Files
------------

The network is dynamically configured in three diferent steps:

* **Pre**: Right before the hypervisor launches the VM.
* **Post**: Right after the hypervisor launches the VM.
* **Clean**: Right after the hypervisor shuts down the VM.

Each driver execute different actions (or even none at all) in these phases depending on the underlying switching fabric. Note that, if either ``pre`` or ``post`` fail, the VM will be placed in a ``FAIL`` state.

You can easily customize the behavior of the driver for your infrastructure by modifying the files in located in ``/var/lib/one/remotes/vnm``. Each driver has its own folder that contains at least three programs ``pre``, ``post`` and ``clean``. These programs are executed to perform the steps described above.

Fixing Default Paths
--------------------

The default paths for the binaries/executables used during the network configuration may change depending on the distro. OpenNebula ships with the most common paths, however these may be wrong for your particular distro. In that case, please fix the proper paths in the ``COMMANDS`` hash of ``/var/lib/one/remotes/vnm/command.rb``:

.. code::

    # Command configuration for common network commands. This CAN be adjusted
    # to local installations. Any modification requires to sync the hosts with
    # onehost sync command.
    COMMANDS = {
      :ebtables => "sudo ebtables",
      :iptables => "sudo iptables",
      :brctl    => "sudo brctl",
      :ip       => "sudo ip",
      :virsh    => "virsh -c qemu:///system",
      :ovs_vsctl=> "sudo ovs-vsctl",
      :ovs_ofctl=> "sudo ovs-ofctl",
      :lsmod    => "lsmod",
      :ipset    => "sudo ipset"
    }

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Open Cloud Storage <storage>` chapter.

Read the specific section for the driver that you are interested in.

After reading this chapter you can complete your OpenNebula installation by optionally enabling an :ref:`External Authentication <authentication>` or configuring :ref:`Sunstone <sunstone>`. Otherwise you are ready to :ref:`Operate your Cloud <operation_guide>`.

Hypervisor Compatibility
================================================================================

This chapter applies only to KVM.
