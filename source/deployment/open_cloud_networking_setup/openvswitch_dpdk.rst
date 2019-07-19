.. _openvswitch_dpdk:

================================================================================
Open vSwitch with DPDK
================================================================================

This guide describes how to use a DPDK datapath with the Open vSwitch drivers. When using the DPDK backend, the OpenNebula drivers will automatically configure the bridges and ports accordingly.


.. warning:: This guide is only relevant for KVM guests

Requirements & Limitations
================================================================================

Please consider the following when using the DPDK datapath for Open vSwitch:

* An Open vSwitch version compiled with DPDK support is required.
* This mode cannot be combined with non-DPDK switches.
* The VMs need to use the virtio interface for its NICs.
* Although not needed to make it work, you'd probably be interested in configuring NUMA pinning and hugepages in your hosts. :ref:`You can read more here <numa>`.

OpenNebula Configuration
================================================================================

Follow these steps to configure OpenNebula:

* **Select the DPDK backend for the switches**. Edit the configuration of the openvswtich driver in ``/ect/one/oned.conf`` to read:

.. code:: bash

   VN_MAD_CONF = [
       NAME = "ovswitch",
       BRIDGE_TYPE = "openvswitch_dpdk"
   ]

After making this change you need to restart OpenNebula

* **Set the datapath type for the bridges**. Edit the bridge configuration options in ``/var/lib/one/remotes/etc/OpenNebulaNetwork.conf``:

.. code:: bash

   :ovs_bridge_conf:
       :datapath_type: netdev

After making this change you need to synchronize the changes with your hosts using the ``onehost sync`` command.

Note that the sockets used by the vhost interface are created in the VM directory (``/var/lib/one/datastores/<ds_id>/<vm_id>``) and named after the switch port.

Using Open vSwtich and DPDK
================================================================================

There are no additional changes, simply:

* Create your networks using the ``ovswitch`` driver, :ref:`more details here <openvswitch>`.
* Make sure that the NIC model is set to ``virtio``. This setting can be added as a default in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``.

You can verify that the VMs are using the vhost interface by looking at their domain definition in the host. You should see something like:

.. code:: bash

   <domain type='kvm' id='417'>
     <name>one-10</name>
     ...
     <devices>
       ...
       <interface type='vhostuser'>
         <mac address='02:00:c0:a8:7a:02'/>
         <source type='unix' path='/var/lib/one//datastores/0/10/one-10-0' mode='server'/>
         <target dev='one-10-0'/>
         <model type='virtio'/>
         <alias name='net0'/>
         <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
       </interface>
     ...
   </domain>

And the associated port in the bridge:

.. code:: bash

    Bridge br0
        Port "one-10-0"
            Interface "one-10-0"
                type: dpdkvhostuserclient
                options: {vhost-server-path="/var/lib/one//datastores/0/10/one-10-0"}

