.. _vcenter_networking_setup:
.. _virtual_network_vcenter_usage:

================================================================================
vCenter Networking
================================================================================

Virtual Networks from vCenter can be represented using OpenNebula networks, taking into account that the BRIDGE of the Virtual Network needs to match the name of the Network defined in vCenter. OpenNebula supports both "Port Groups" and "Distributed Port Groups", and as such can consume any vCenter defined network resource (even those created by other networking components NSX)

Virtual Networks in vCenter can be created using the vCenter web client, with any specific configuration like for instance VLANs. OpenNebula will use these networks with the defined characteristics, but it cannot create new Virtual Networks in vCenter, but rather only OpenNebula vnet representations of such Virtual Networks. OpenNebula additionally can handle on top of these networks three types of :ref:`Address Ranges: Ethernet, IPv4 and IPv6 <vgg_vn_ar>`.

vCenter VM Templates can define their own NICs, and OpenNebula will not manage them. However, any NIC added in the OpenNebula VM Template, or through the attach_nic operation, will be handled by OpenNebula, and as such it is subject to be detached and its information (IP, MAC, etc) is known by OpenNebula.

Importing vCenter Networks
================================================================================

The **onevcenter** tool can be used to import existing Networks and distributed vSwitches from the ESX clusters:

.. prompt:: bash $ auto

    $ .onevcenter networks --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>

    Connecting to vCenter: <vcenter-host>...done!

    Looking for vCenter networks...done!

    Do you want to process datacenter vOneDatacenter [y/n]? y

      * Network found:
          - Name    : MyvCenterNetwork
          - Type    : Port Group
        Import this Network [y/n]? y
        How many VMs are you planning to fit into this network [255]? 45
        What type of Virtual Network do you want to create (IPv[4],IPv[6],[E]thernet) ? E
        Please input the first MAC in the range [Enter for default]:
        OpenNebula virtual network 29 created with size 45!

        $ onevnet list
          ID USER            GROUP        NAME                CLUSTER    BRIDGE   LEASES
          29 oneadmin        oneadmin     MyvCenterNetwork    -          MyFakeNe      0

        $ onevnet show 29
        VIRTUAL NETWORK 29 INFORMATION
        ID             : 29
        NAME           : MyvCenterNetwork
        USER           : oneadmin
        GROUP          : oneadmin
        CLUSTER        : -
        BRIDGE         : MyvCenterNetwork
        VLAN           : No
        USED LEASES    : 0

        PERMISSIONS
        OWNER          : um-
        GROUP          : ---
        OTHER          : ---

        VIRTUAL NETWORK TEMPLATE
        BRIDGE="MyvCenterNetwork"
        PHYDEV=""
        VCENTER_TYPE="Port Group"
        VLAN="NO"
        VLAN_ID=""

        ADDRESS RANGE POOL
         AR TYPE    SIZE LEASES               MAC              IP          GLOBAL_PREFIX
          0 ETHER     45      0 02:00:97:7f:f0:87               -                      -

        LEASES
        AR  OWNER                    MAC              IP                      IP6_GLOBAL


The same import mechanism is available graphically through Sunstone 

.. todo:: Screenshot vCenter network import

.. image:: /images/vcenter_create.png
    :width: 90%
    :align: center


