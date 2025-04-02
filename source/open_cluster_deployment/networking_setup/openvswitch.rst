.. _openvswitch:

================================================================================
Open vSwitch Networks
================================================================================

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ network drivers. They provide network isolation using VLANs by tagging ports and basic network filtering using OpenFlow. Other traffic attributes that may be configured through Open vSwitch are not modified.

The VLAN ID will be the same for every interface in a given network, calculated automatically by OpenNebula. It may also be forced by specifying an ``VLAN_ID`` parameter in the :ref:`Virtual Network template <vnet_template>`.

.. warning:: This driver doesn't support Security Groups.

OpenNebula Configuration
================================================================================

The VLAN ID is calculated according to this configuration option :ref:`/etc/one/oned.conf <oned_conf>`:

.. code::

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

By modifying this section, you can reserve some VLANs so they aren't assigned to a Virtual Network. You can also define the first VLAN ID. When a new isolated network is created, OpenNebula will find a free VLAN ID from the VLAN pool. This pool is global and it's also shared with the :ref:`802.1Q Networks <hm-vlan>`.

The following configuration parameters can be adjusted in ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``:

+--------------------------+----------------------------------------------------------------------------------+
|      Parameter           |                                   Description                                    |
+==========================+==================================================================================+
| ``:arp_cache_poisoning`` | Set to ``true`` to enable ARP Cache Poisoning Prevention Rules                   |
|                          | (effective only with IP/MAC spoofing filters enabled on Virtual Network).        |
+--------------------------+----------------------------------------------------------------------------------+
| ``:keep_empty_bridge``   | Set to ``true`` to preserve bridges with no virtual interfaces left.             |
+--------------------------+----------------------------------------------------------------------------------+
| ``:ovs_bridge_conf``     | *(Hash)* Options for Open vSwitch bridge creation                                |
+--------------------------+----------------------------------------------------------------------------------+

.. note:: Remember to run ``onehost sync -f`` to synchronize the changes to all the nodes.

.. _ovswitch_net:

Defining Open vSwitch Network
==============================

To create an Open vSwitch network, include the following information:

+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
|       Attribute       |                                       Value                                        |   Mandatory                   |
+=======================+====================================================================================+===============================+
| ``VN_MAD``            | Set ``ovswitch``                                                                   | **YES**                       |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
| ``PHYDEV``            | Name of the physical network device that will be attached to the bridge            | NO (unless using VLANs)       |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
| ``BRIDGE``            | Name of the Open vSwitch bridge to use                                             | NO                            |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
| ``VLAN_ID``           | The VLAN ID, will be generated if not defined and ``AUTOMATIC_VLAN_ID=YES``        | NO                            |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
| ``AUTOMATIC_VLAN_ID`` | Ignored if ``VLAN_ID`` defined. Set to ``YES`` to automatically assign ``VLAN_ID`` | NO                            |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+
| ``MTU``               | The MTU for the Open vSwitch port                                                  | NO                            |
+-----------------------+------------------------------------------------------------------------------------+-------------------------------+

For example, you can define an *Open vSwitch Network* with the following template:

.. code::

    NAME    = "private4"
    VN_MAD  = "ovswitch"
    BRIDGE  = vbr1
    VLAN_ID = 50          # Optional
    ...

.. warning:: Currently, if IP Spoofing enabled, only one NIC per VM for the same Open vSwith network can be attached.

Multiple VLANs (VLAN trunking)
------------------------------

VLAN trunking is also supported by adding the following tag to the ``NIC`` element in the VM template or to the virtual network template:

-  ``VLAN_TAGGED_ID``: Specify a range of VLANs to tag, for example: ``1,10,30,32,100-200``.

.. _openvswitch_vxlan:

Using Open vSwitch on VXLAN Networks
====================================

This section describes how to use `Open vSwitch <http://openvswitch.org/>`__ on VXLAN networks. To use VXLAN you need to use a specialized version of the Open vSwitch driver that incorporates the features of the :ref:`VXLAN <vxlan>` driver. It's necessary to be familiar with these two drivers, their configuration options, benefits, and drawbacks.

The VXLAN overlay network is used as a base with the Open vSwitch (instead of regular Linux bridge) on top. Traffic on the lowest level is isolated by the VXLAN encapsulation protocol and Open vSwitch still allows second level isolation by 802.1Q VLAN tags **inside the encapsulated traffic**. The main isolation is always provided by VXLAN, not 802.1Q VLANs. If 802.1Q is required to isolate the VXLAN, the driver needs to be configured with user-created 802.1Q tagged physical interface.

This hierarchy is important to understand.

OpenNebula Configuration
------------------------

There is no configuration specific to this driver, except the options specified above and in the :ref:`VXLAN Networks <vxlan>` guide.

Defining an Open vSwitch - VXLAN Network
----------------------------------------

To create a network, include the following information:

+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| Attribute                   | Value                                                                   | Mandatory                                      |
+=============================+=========================================================================+================================================+
| ``VN_MAD``                  | Set ``ovswitch_vxlan``                                                  |  **YES**                                       |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``PHYDEV``                  | Name of the physical network device that will be attached to the bridge.|  **YES**                                       |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``BRIDGE``                  | Name of the Open vSwitch bridge to use                                  |  NO                                            |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``OUTER_VLAN_ID``           | The outer VXLAN network ID.                                             |  **YES** (unless ``AUTOMATIC_OUTER_VLAN_ID``)  |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``AUTOMATIC_OUTER_VLAN_ID`` | If ``OUTER_VLAN_ID`` has been defined, this attribute is ignored.       |  **YES** (unless ``OUTER_VLAN_ID``)            |
|                             | Set to ``YES`` if you want OpenNebula to generate an automatic ID.      |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``VLAN_ID``                 | The inner 802.1Q VLAN ID. If this attribute is not defined a VLAN ID    |  NO                                            |
|                             | will be generated if AUTOMATIC_VLAN_ID is set to YES.                   |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``AUTOMATIC_VLAN_ID``       | Ignored if ``VLAN_ID`` defined. Set to ``YES`` to automatically         |  NO                                            |
|                             | assign ``VLAN_ID``                                                      |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``MTU``                     | The MTU for the VXLAN interface and bridge                              |  NO                                            |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+

For example, you can define an *Open vSwitch - VXLAN Network* with the following template:

.. code::

    NAME          = "private5"
    VN_MAD        = "ovswitch_vxlan"
    PHYDEV        = eth0
    BRIDGE        = ovsvxbr0.10000
    OUTER_VLAN_ID = 10000               # VXLAN VNI
    VLAN_ID        = 50                 # Optional VLAN ID
    ...

In this example, the driver will check for the existence of bridge ``ovsvxbr0.10000``.  If it doesn't exist, it will be created. Also, the VXLAN interface ``eth0.10000`` will be created and attached to the Open vSwitch bridge ``ovsvxbr0.10000``. When a virtual machine is instantiated, its bridge ports will be tagged with 802.1Q VLAN ID ``50``.

.. _openvswitch_dpdk:

Open vSwitch with DPDK
================================================================================

.. warning:: This section is only relevant for KVM guests.

This section describes how to use a DPDK datapath with the Open vSwitch drivers. When using the DPDK backend, the OpenNebula drivers will automatically configure the bridges and ports accordingly.

Please consider the following when using the DPDK datapath for Open vSwitch:

* An Open vSwitch version compiled with DPDK support is required.
* The VMs need to use the virtio interface for its NICs.
* Hugepages needs to be configured in the Hosts
* VMs needs to use be configured to use NUMA pinning and hugepages. See :ref:`here <numa>`.

Host Configuration
--------------------------------------------------------------------------------

.. note:: This section will use an Ubuntu22.04 server to show working configurations. You may need to adapt them to other Linux distributions.

Setup Hugepages and iommu
********************************************************************************

`Hugepages <https://wiki.debian.org/Hugepages>`_ are virtual memory pages of a size greater than the 4K default. Increasing the size of the page reduces the number of pages in the system and hence the entries needed in the TLB to perform virtual address translations.

The size of virtual pages supported by the system can be check from the CPU flags:

* ``pse`` for 2M
* ``pdpe1gb`` for 1G

For 64-bit applications it is recommended to use 1G. Note that on NUMA systems, the pages reserved are divided equally between sockets.

For example, to configure default page size of **1G** and **250** hugepages with `iommu <https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit#:~:text=In%20computing%2C%20an%20input%E2%80%93output,bus%20to%20the%20main%20memory.>`_ enabled at boot time on a host with an **Intel CPU**, you have to append ``"intel_iommu=on default_hugepagesz=1G hugepagesz=1G hugepages=250"`` to the bootloader configuration.

.. prompt:: bash # auto

    # grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on default_hugepagesz=1G hugepagesz=1G hugepages=250"

    # update-grub

.. tip:: Use ``intel_iommu=on`` instead for hosts with an AMD CPU

Then reboot the system. After rebooting, make sure that the hugepages mount can be seen so the applications can access them.

If you see the following, you don't need to setup a mount as the mounts are already handled

.. prompt:: bash # auto

    # mount | grep huge
    hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,pagesize=1G)
    # systemctl list-units --type=mount | grep hugepages
    dev-hugepages.mount                                    loaded active mounted Huge Pages File System

If not, you have to set it up yourself. To do this, create a mount point, for example, ``/mnt/hugepages1G`` and append ``nodev	/mnt/hugepages1G hugetlbfs pagesize=1GB 0 0`` as an entry to ``/etc/fstab``

.. prompt:: bash # auto

    # mkdir /mnt/hugepages1G
    # grep huge /etc/fstab
    nodev	/mnt/hugepages1G hugetlbfs pagesize=1GB 0 0
    # mount /mnt/hugepages1G

Now check hugepages are allocated to NUMA nodes, for example (or with ``numastat -m``):

.. prompt:: bash # auto

    # grep -i '\<huge' /sys/devices/system/node/node*/meminfo
    Node 0 HugePages_Total:   125
    Node 0 HugePages_Free:    125
    Node 0 HugePages_Surp:      0
    Node 1 HugePages_Total:   125
    Node 1 HugePages_Free:    125
    Node 1 HugePages_Surp:      0

.. tip:: You can install ``numactl`` to run the ``numastat -m`` command

And finally iommu should be also enabled:

.. prompt:: bash # auto

    # dmesg | grep -i dmar
    [    0.010651] kernel: ACPI: DMAR 0x000000007BAFE000 0000F0 (v01 DELL   PE_SC3   00000001 DELL 00000001)
    [    0.010695] kernel: ACPI: Reserving DMAR table memory at [mem 0x7bafe000-0x7bafe0ef]
    [    1.837579] kernel: DMAR: IOMMU enabled

Install OVS with DPDK support
********************************************************************************

We just need to install the dpdk version of the package and update alternatives accordingly:

.. prompt:: bash # auto

    # apt install openvswitch-switch-dpdk

    # update-alternatives --set ovs-vswitchd /usr/lib/openvswitch-switch-dpdk/ovs-vswitchd-dpdk

    # ovs-vsctl set Open_vSwitch . other_config:dpdk-init=true

.. warning:: Make sure the openvswitch software you install has been compiled with dpdk support. You should be able to see if this is the case by querying its dependencies with the package manager.

Now, restart openvswitch service and check dpdk is enabled:

.. prompt:: bash # auto

    # systemctl restart openvswitch-switch.service

    # grep DPDK openvswitch/ovs-vswitchd.log
    2022-11-24T12:30:24.500Z|00041|dpdk|ERR|DPDK not supported in this copy of Open vSwitch.
    2022-11-24T12:33:02.905Z|00007|dpdk|INFO|Using DPDK 21.11.2
    2022-11-24T12:33:02.905Z|00008|dpdk|INFO|DPDK Enabled - initializing...
    2022-11-24T12:33:02.905Z|00012|dpdk|INFO|Per port memory for DPDK devices disabled.
    2022-11-24T12:33:02.914Z|00016|dpdk|INFO|EAL: Detected shared linkage of DPDK
    2022-11-24T12:33:04.303Z|00032|dpdk|INFO|DPDK Enabled - initialized

    # ovs-vsctl get Open_vSwitch . dpdk_initialized
    true

Configure Open vSwitch
********************************************************************************

Next step is to tune the execution parameters of the polling mode drivers (PMD) threads by pinning them into specific CPUs and assigning some hugepages.

To specify the CPU cores we need to set a binary mask, where each bit represents a CPU core by its ID. For example ``0xF0`` is ``11110000``, bits 7,6,5,4 are set to 1 so CPU cores 7,6,5,4 would be use for PMDs. Usually, it is recommended to allocate same number of cores across NUMA nodes.

For example to set cores **0,28,1,29** and **2G** of hugepages per NUMA node on a host with two sockets, execute the following commands:

.. prompt:: bash # auto

    # ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0x30000003
    # ovs-vsctl set Open_vSwitch . other_config:dpdk-socket-mem="2048,2048" # socket-mem=socket0_mem,socket1_mem
    # ovs-vsctl set Open_vSwitch . other_config:dpdk-hugepage-dir="/mnt/hugepages1G"

    # systemctl restart openvswitch-switch.service


Configure Open vSwitch Bridge
********************************************************************************

OpenNebula does not support adding and configuring DPDK physical devices. Binding cards to vfio-pci driver needs to be configured before using the DPDK network in OpenNebula. Usually, Open vSwitch setups only requires one bridge so these steps can be easily automated during the host installation.

In this example, we'll be creating a bond with two cards (each one attached to a different NUMA node). Let's first trace the cards with the ``dpdk-debind.py`` tool, and then bind the cards to the **vfio-pci** driver.

.. prompt:: bash # auto

    # dpdk-devbind.py --status
    ...
    Network devices using kernel driver
    ===================================
    0000:01:00.1 'Ethernet Controller X710 for 10GbE SFP+ 1572' if=eno2 drv=i40e unused=vfio-pci
    0000:83:00.1 'Ethernet Controller X710 for 10GbE SFP+ 1572' if=enp131s0f1 drv=i40e unused=vfio-pci

    # dpdk-devbind.py --bind=vfio-pci enp131s0f1

    # dpdk-devbind.py --bind=vfio-pci eno2

    # dpdk-devbind.py --status
    ...
    Network devices using DPDK-compatible driver
    ============================================
    0000:01:00.1 'Ethernet Controller X710 for 10GbE SFP+ 1572' drv=vfio-pci unused=i40e
    0000:83:00.1 'Ethernet Controller X710 for 10GbE SFP+ 1572' drv=vfio-pci unused=i40e

.. tip:: For this operation to work, you might need to enable the ``vfio-pci`` kernel module

Now we can add the cards to an Open vSwitch port, or in this example create a bond port with both:

.. prompt:: bash # auto

    # ovs-vsctl add-br onebr.dpdk -- set bridge onebr.dpdk datapath_type=netdev

    # ovs-vsctl add-bond onebr.dpdk bond1 x710_1 x710_83 \
        -- set Interface x710_1 type=dpdk options:dpdk-devargs=0000:01:00.1 \
        -- set Interface x710_83 type=dpdk options:dpdk-devargs=0000:83:00.1

    # ovs-vsctl show
       Bridge onebr.dpdk
            datapath_type: netdev
            Port onebr.dpdk
                Interface onebr.dpdk
                    type: internal
            Port bond1
                Interface x710_83
                    type: dpdk
                    options: {dpdk-devargs="0000:83:00.1"}
                Interface x710_1
                    type: dpdk
                    options: {dpdk-devargs="0000:01:00.1"}
        ovs_version: "2.17.2"

We are all set now, the bridge ``onebr.dpdk`` is ready to be used by OpenNebula.


OpenNebula Configuration
--------------------------------------------------------------------------------

There are no special configuration on the OpenNebula server. Note that the sockets used by the vhost interface are created in the VM directory (``/var/lib/one/datastores/<ds_id>/<vm_id>``) and named after the switch port.

Using DPDK in your Virtual Networks
********************************************************************************

There are no additional changes, simply:

* Create your networks using the ``ovswitch`` driver, :ref:`see above <openvswitch>`.
* Change configuration of the ``BRIDGE_TYPE`` of the network to ``openvswitch_dpdk`` using either the CLI command ``onevnet update`` or Sunstone.

An example of a Virtual Network template for the previous configuration could be:

.. code:: bash

    NAME = "DPDK_VSBC_HA2"
    BRIDGE = "onebr.dpdk"
    BRIDGE_TYPE = "openvswitch_dpdk"
    SECURITY_GROUPS = "0"
    VLAN_ID = "1402"
    VN_MAD = "ovswitch"

    # note there is no PHYDEV, after creation it will show PHYDEV = ""

Using DPDK in your Virtual Machines
********************************************************************************

The following settings needs to be enabled:

    * Make sure that the NIC model is set to ``virtio``. This setting can be added as a default in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``.
    * In order to use the vhost-user interface in libvirt hugepages needs to be enabled. OVS reads/write network packages from/to the memory (hugepages) of the guest. The memory access mode **MUST** be shared, and the VM **MUST** configure huge pages.

An example of a Virtual Machine template for the previous configuration could be:

.. code:: bash

    NAME   = "DPDK_VM"
    MEMORY = "4096"

    NIC = [ NETWORK = "DPDK_VSBC_HA2" ]

    TOPOLOGY = [
       CORES = "2",
       HUGEPAGE_SIZE = "1024",
       MEMORY_ACCESS = "shared",
       PIN_POLICY    = "THREAD",
       SOCKETS = "1",
       THREADS = "2"
    ]

You can verify that the VMs are using the vhost interface by looking at their domain definition in the Host. You should see something like:

.. code:: bash

   <domain type='kvm' id='417'>
     <name>one-10</name>
     ...
     <devices>
       ...
       <interface type='vhostuser'>
         <mac address='02:00:c0:a8:7a:02'/>
         <source type='unix' path='/var/lib/one//datastores/0/10/one-10-0' mode='server'/>
         <target dev=''/>
         <model type='virtio'/>
         <alias name='net0'/>
         <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
       </interface>
     ...
   </domain>

And the associated port in the bridge using the qemu vhost interface:

.. code:: bash

    Bridge onebr.dpdk
        datapath_type: netdev
        Port "one-10-0"
            tag: 1420
            Interface "one-10-0"
                type: dpdkvhostuserclient
                options: {vhost-server-path="/var/lib/one//datastores/0/10/one-10-0"}
    ...

.. _openvswitch_qinq:

Using Open vSwitch with Q-in-Q
================================================================================

Q-in-Q is an amendment to the IEEE 802.1Q specification that provides the capability for multiple VLAN tags to be inserted into a single Ethernet frame. Using Q-in-Q (aka C-VLAN, customer VLAN) tunneling allows to create Layer 2 Ethernet connection between customers cloud infrastructure and OpenNebula VMs, or use a single service VLAN to bundle different customer VLANs.

OpenNebula Configuration
------------------------

There is no configuration specific for this use case, just consider the general options specified above.

Defining a Q-in-Q Open vSwitch Network
----------------------------------------

To create a network you need to include the following information:

+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| Attribute                   | Value                                                                   | Mandatory                                      |
+=============================+=========================================================================+================================================+
| ``VN_MAD``                  | Set ``ovswitch``                                                        |  **YES**                                       |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``PHYDEV``                  | Name of the physical network device that will be attached to the bridge.|  **YES**                                       |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``BRIDGE``                  | Name of the Open vSwitch bridge to use                                  |  NO                                            |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``VLAN_ID``                 | The service 802.1Q VLAN ID. If not defined the VLAN ID tag              |  NO                                            |
|                             | will be generated if AUTOMATIC_VLAN_ID is set to YES.                   |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``AUTOMATIC_VLAN_ID``       | Ignored if ``VLAN_ID`` defined. Set to ``YES`` to automatically         |  NO                                            |
|                             | assign ``VLAN_ID``                                                      |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``CVLANS``                  | Customer VLAN IDs, as a comma separated list (ranges supported)         |  **YES**                                       |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``QINQ_TYPE``               | Tag Protocol Identifier (TPID) for the service VLAN tag. Use ``802.1ad``|  NO                                            |
|                             | for TPID 0x88a8 or ``802.1q`` for TPID 0x8100                           |                                                |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+
| ``MTU``                     | The MTU for the Open vSwitch port                                       |  NO                                            |
+-----------------------------+-------------------------------------------------------------------------+------------------------------------------------+

For example, you can define an *Open vSwitch - QinQ Network* with the following template:

.. code::

    NAME     = "qinq_net"
    VN_MAD   = "ovswitch"
    PHYDEV   = eth0
    VLAN_ID  = 50                 # Service VLAN ID
    CVLANS   = "101,103,110-113"  # Customer VLAN ID list

In this example, the driver will assign and create an Open vSwitch bridge and will attach the interface ``eth0`` it. When a virtual machine is instantiated, its bridge ports will be tagged with 802.1Q VLAN ID ``50`` and service VLAN IDs ``101,103,110,111,112,113``. The configuration of the port should be similar to the that of following example that shows the second (``NIC_ID=1``) interface port ``one-1-5`` for VM 5:

.. code::

    # ovs-vsctl list Port one-5-1

    _uuid               : 791b84a9-2705-4cf9-94b4-43b39b98fe62
    bond_active_slave   : []
    bond_downdelay      : 0
    bond_fake_iface     : false
    bond_mode           : []
    bond_updelay        : 0
    cvlans              : [101, 103, 110, 111, 112, 113]
    external_ids        : {}
    fake_bridge         : false
    interfaces          : [6da7ff07-51ec-40e9-97cd-c74a36e2c267]
    lacp                : []
    mac                 : []
    name                : one-5-1
    other_config        : {qinq-ethtype="802.1q"}
    protected           : false
    qos                 : []
    rstp_statistics     : {}
    rstp_status         : {}
    statistics          : {}
    status              : {}
    tag                 : 100
    trunks              : []
    vlan_mode           : dot1q-tunnel
