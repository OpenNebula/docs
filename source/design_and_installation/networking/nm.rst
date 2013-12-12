.. _nm:

====================
Networking Overview
====================

Before diving into Network configuration in OpenNebula make sure that you've followed the steps described in the :ref:`Networking section of the Installation guide <ignc#step_8_networking_configuration>`.

When a new Virtual Machine is launched, OpenNebula will connect its network interfaces (defined in the NIC section of the template) to the bridge or physical device specified in the :ref:`Virtual Network definition <vgg>`. This will allow the VM to have access to different networks, public or private.

The OpenNebula administrator must take into account that although this is a powerful setup, it should be complemented with mechanisms to restrict network access only to the expected Virtual Machines, to avoid situations in which an OpenNebula user interacts with another user's VM. This functionality is provided through Virtual Network Manager drivers. The OpenNebula administrator may associate one of the following drivers to each Host, when the hosts are created with the :ref:`onehost command <host_guide>`:

-  **dummy**: Default driver that doesn't perform any network operation. Firewalling rules are also ignored.
-  **:ref:`fw <firewall>`**: Firewall rules are applied, but networking isolation is ignored.
-  **:ref:`802.1Q <hm-vlan>`**: restrict network access through VLAN tagging, which also requires support from the hardware switches.
-  **:ref:`ebtables <ebtables>`**: restrict network access through Ebtables rules. No special hardware configuration required.
-  **:ref:`ovswitch <openvswitch>`**: restrict network access with `Open vSwitch Virtual Switch <http://openvswitch.org/>`__.
-  **:ref:`VMware <vmwarenet>`**: uses the VMware networking infrastructure to provide an isolated and 802.1Q compatible network for VMs launched with the VMware hypervisor.

Note that some of these drivers also create the bridging device in the hosts.

The administrator must take into account the following matrix that shows the compatibility of the hypervisors with each networking driver:

Firewall

Open vSwitch

802.1Q

ebtables

VMware

KVM

Yes

Yes

Yes

Yes

No

Xen

Yes

Yes

Yes

Yes

No

VMware

No

No

No

No

Yes

The Virtual Network isolation is enabled with any of the 801.1Q, ebtables, vmware or ovswitch drivers. These drivers also enable the firewalling rules to allow a regular OpenNebula user to filter TCP, UDP or ICMP traffic.

OpenNebula also comes with a :ref:`Virtual Router appliance <router>` that provides networking services like DHCP, DNS, etc.

Tuning & Extending
==================

Customization of the Drivers
----------------------------

The network is dynamically configured in three diferent steps:

-  **Pre**: Right before the hypervisor launches the VM.
-  **Post**: Right after the hypervisor launches the VM.
-  **Clean**: Right after the hypervisor shuts down the VM.

Each driver execute different actions (or even none at all) in these phases depending on the underlying switching fabric. Note that, if either ``Pre`` or ``Post`` fail, the VM will be shut down and will be placed in a ``FAIL`` state.

You can easily customize the behavior of the driver for your infrastructure by modifying the files in located in ``/var/lib/one/remotes/vnm``. Each driver has its own folder that contains at least three programs ``pre``, ``post`` and ``clean``. These programs are executed to perform the steps described above.

Fixing Default Paths
--------------------

The default paths for the binaries/executables used during the network configuration may change depending on the distro. OpenNebula ships with the most common paths, however these may be wrong for your particular distro. In that case, please fix the proper paths in the ``COMMANDS`` hash of ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.rb``:

.. code::

    COMMANDS = {
      :ebtables => "sudo /sbin/ebtables",
      :iptables => "sudo /sbin/iptables",
      :brctl    => "sudo /sbin/brctl",
      :ip       => "sudo /sbin/ip",
      :vconfig  => "sudo /sbin/vconfig",
      :virsh    => "virsh -c qemu:///system",
      :xm       => "sudo /usr/sbin/xm",
      :ovs_vsctl=> "sudo /usr/local/bin/ovs-vsctl",
      :lsmod    => "/sbin/lsmod"
    }

