.. _openvswitch:

================================================================================
Open vSwitch Networks
================================================================================

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ network drives. They provide network isolation using VLANs by tagging ports and basic network filtering using OpenFlow. Other traffic attributes that may be configured through Open vSwitch are not modified.

The VLAN id will be the same for every interface in a given network, calculated automatically by OpenNebula. It may also be forced by specifying an ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

.. warning:: This driver is not compatible with Security Groups.

OpenNebula Configuration
================================================================================

The VLAN_ID is calculated according to this configuration option of ``oned.conf``:

.. code:: bash

    #  VLAN_IDS: VLAN ID pool for the automatic VLAN_ID assigment. This pool
    #  is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver
    #  will try first to allocate VLAN_IDS[START] + VNET_ID
    #     start: First VLAN_ID to use
    #     reserved: Comma separated list of VLAN_IDs or ranges. Two numbers
    #     separated by a colon indicate a range.

    VLAN_IDS = [
        START    = "2",
        RESERVED = "0, 1, 4095"
    ]

By modifying that parameter you can reserve some VLANs so they aren't assigned to a Virtual Network. You can also define the first VLAN_ID. When a new isolated network is created, OpenNebula will find a free VLAN_ID from the VLAN pool. This pool is global, and it's also shared with the :ref:`802.1Q VLAN <hm-vlan>` network mode.

The following configuration attributes can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+---------------------+----------------------------------------------------------------------------------+
|      Parameter      |                                   Description                                    |
+=====================+==================================================================================+
| arp_cache_poisoning | Enable ARP Cache Poisoning Prevention Rules                                      |
|                     | (effective only if Virtual Network IP/MAC spoofing filters are enabled).         |
+---------------------+----------------------------------------------------------------------------------+
| keep_empty_bridge   | Set to true to preserve bridges with no virtual interfaces left.                 |
+---------------------+----------------------------------------------------------------------------------+
| ovs_bridge_conf     | *Hash* Options for Open vSwitch bridge creation                                  |
+---------------------+----------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync`` to deploy the file to all the nodes.

.. _ovswitch_net:

Defining an Open vSwitch Network
================================================================================

To create an Open vSwitch network, include the following information:

+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+
|       Attribute       |                                       Value                                       |               Mandatory                |
+=======================+===================================================================================+========================================+
| **VN_MAD**            | ovswitch                                                                          | **YES**                                |
+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+
| **PHYDEV**            | Name of the physical network device that will be attached to the bridge           | NO                                     |
+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+
| **BRIDGE**            | Name of the Open vSwitch bridge to use                                            | **YES**                                |
+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+
| **VLAN_ID**           | The VLAN ID. If this attribute is not defined a VLAN ID will be generated if      | NO                                     |
|                       | AUTOMATIC_VLAN_ID is set to YES.                                                  |                                        |
+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+
| **AUTOMATIC_VLAN_ID** | If VLAN_ID has been defined, this attribute is ignored.                           | NO                                     |
|                       | Set to YES if you want OpenNebula to generate an automatic VLAN ID.               |                                        |
+-----------------------+-----------------------------------------------------------------------------------+----------------------------------------+

The following example defines an Open vSwitch network

.. code::

    NAME    = "ovswitch_net"
    VN_MAD  = "ovswitch"
    BRIDGE  = vbr1
    VLAN_ID = 50 # optional
    ...

Multiple VLANs (VLAN trunking)
------------------------------

VLAN trunking is also supported by adding the following tag to the ``NIC`` element in the VM template or to the virtual network template:

-  ``VLAN_TAGGED_ID``: Specify a range of VLANs to tag, for example: ``1,10,30,32,100-200``.

.. _openvswitch_vxlan:


Using Open vSwitch on VXLAN Networks
================================================================================

This section describes how to use `Open vSwitch <http://openvswitch.org/>`__ on VXLAN networks. To use VXLAN you need to use a specialized version of the Open vSwtich driver that incorporates the features of the :ref:`VXLAN <vxlan>` driver. It's necessary to be familiar with these two drivers, their configuration options, benefits, and drawbacks.

The VXLAN overlay network is used as a base with the Open vSwitch (instead of regular Linux bridge) on top. Traffic on the lowest level is isolated by the VXLAN encapsulation protocol, and Open vSwitch still allows to use the second level isolation by 802.1Q VLAN tags **inside the encapsulated traffic**. Main isolation is always provided by VXLAN, not 802.1Q VLANs. If 802.1Q is required to isolate the VXLAN, the driver needs to be configured with user-created 802.1Q tagged physical interface.

This hierarchy is important to understand.

OpenNebula Configuration
--------------------------------------------------------------------------------

There is no configuration specific to this driver, except the options specified above and in the :ref:`VXLAN guide <vxlan>`.

Defining an Open vSwitch - VXLAN Network
--------------------------------------------------------------------------------

To create a network include the following information:

+-----------------------------+-------------------------------------------------------------------------+-----------+
| Attribute                   | Value                                                                   | Mandatory |
+=============================+=========================================================================+===========+
| **VN_MAD**                  | ovswitch_vxlan                                                          |  **YES**  |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **PHYDEV**                  | Name of the physical network device that will be attached to the bridge.|  **YES**  |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **BRIDGE**                  | Name of the Open vSwitch bridge to use                                  |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **OUTER_VLAN_ID**           | The outer VXLAN network ID.                                             |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **AUTOMATIC_OUTER_VLAN_ID** | If OUTER_VLAN_ID has been defined, this attribute is ignored.           |  NO       |
|                             | Set to YES if you want OpenNebula to generate an automatic ID.          |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **VLAN_ID**                 | The inner 802.1Q VLAN ID. If this attribute is not defined a VLAN ID    |  NO       |
|                             | will be generated if AUTOMATIC_VLAN_ID is set to YES.                   |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **AUTOMATIC_VLAN_ID**       | If VLAN_ID has been defined, this attribute is ignored.                 |  NO       |
|                             | Set to YES if you want OpenNebula to generate an automatic VLAN ID.     |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **MTU**                     | The MTU for the VXLAN interface and bridge                              |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+

The following example defines an Open vSwitch network

.. code::

    NAME    = "ovsvx_net"
    VN_MAD  = "ovswitch_vxlan"
    PHYDEV  = eth0
    BRIDGE  = ovsvxbr0.10000
    OUTER_VLAN_ID = 10000  # VXLAN VNI
    VLAN_ID = 50           # optional
    ...

In this scenario, the driver will check for the existence of bridge ``ovsvxbr0.10000``.  If it doesn't exist, it will be created. Also, the VXLAN interface ``eth0.10000`` will be created and attached to the Open vSwitch bridge ``ovsvxbr0.10000``. When a virtual machine is instantiated, its bridge ports will be tagged with 802.1Q VLAN 50.

.. _openvswitch_dpdk:


Open vSwitch with DPDK
================================================================================

This section describes how to use a DPDK datapath with the Open vSwitch drivers. When using the DPDK backend, the OpenNebula drivers will automatically configure the bridges and ports accordingly.

.. warning:: This section is only relevant for KVM guests

Requirements & Limitations
--------------------------------------------------------------------------------

Please consider the following when using the DPDK datapath for Open vSwitch:

* An Open vSwitch version compiled with DPDK support is required.
* This mode cannot be combined with non-DPDK switches.
* The VMs need to use the virtio interface for its NICs.
* Although not needed to make it work, you'd probably be interested in configuring NUMA pinning and hugepages in your hosts. :ref:`You can read more here <numa>`.

OpenNebula Configuration
--------------------------------------------------------------------------------

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

Using DPDK in your Virtual Networks
--------------------------------------------------------------------------------

There are no additional changes, simply:

* Create your networks using the ``ovswitch`` driver, :ref:`see above <openvswitch>`.
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

And the associated port in the bridge using the qemu vhost interface:

.. code:: bash

    Bridge br0
        Port "one-10-0"
            Interface "one-10-0"
                type: dpdkvhostuserclient
                options: {vhost-server-path="/var/lib/one//datastores/0/10/one-10-0"}

