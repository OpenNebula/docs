.. _vgg:

==========================
Managing Virtual Networks
==========================

A host is connected to one or more networks that are available to the virtual machines through the corresponding bridges. OpenNebula allows the creation of Virtual Networks by mapping them on top of the physical ones

Overview
========

In this guide you'll learn how to define and use virtual networks. For the sake of simplicity the following examples assume that the hosts are attached to two **physical** networks:

-  A private network, through the virtual bridge vbr0
-  A network with Internet connectivity, through vbr1

This guide uses the CLI command ``onevnet``, but you can also manage your virtual networks using :ref:`Sunstone <sunstone>`. Select the Network tab, and there you will be able to create and manage your virtual networks in a user friendly way.

|image0|

Adding, Deleting and Updating Virtual Networks
==============================================

A virtual network is defined by two sets of options:

-  The underlying networking parameters, e.g. BRIDGE, VLAN or PHY\_DEV. These attributes depend on the networking technology (drivers) used by the hosts. Please refer to the specific networking guide.

-  A set of Leases. A lease defines a MAC - IP pair, related as MAC = MAC\_PREFFIX:IP. For IPv6 networks the only relevant part is the MAC address (see below).

Depending on how the lease set is defined the networks are:

-  Fixed. A limited (possibly disjoint) set of leases, e.g: 10.0.0.1, 10.0.0.40 and 10.0.0.34
-  Ranged. A continuous set of leases (like in a network way), e.g: 10.0.0.0/24

Please refer to the :ref:`Virtual Network template reference guide <vnet_template>` for more information. The ``onevnet`` command is used to create a VNet from that template.

IPv4 Networks
-------------

IPv4 leases can be defined in several ways:

-  Ranged. The ranged can be defined with:

   -  A network address in CIDR format, e.g. NETWORK\_ADDRESS=10.0.0.0/24.
   -  A network address and a net mask, e.g. NETWORK\_ADDRESS=10.0.0.0 NETWORK\_MASK=255.255.255.0.
   -  A network address and a size, e.g. NETWORK\_ADDRESS=10.0.0.0, NETWORK\_SIZE=C.
   -  An arbitrary IP range, e.g. IP\_START=10.0.0.1, IP\_END=10.0.0.254.

-  Fixed. Each lesae can be defined by:

   -  An IP address, e.g. LEASE=[IP=10.0.0.1]
   -  An IP address and a MAC to override the default MAC generation (MAC=PREFIX:IP), e.g. LEASE=[IP=10.0.0.1, MAC=e8:9d:87:8d:11:22]

As an example, we will create two new VNets, Blue and Red. Lets assume we have two files, ``blue.net`` and ``red.net``.

Blue.net file:

.. code::

    NAME    = "Blue LAN"
    TYPE    = FIXED
     
    # We have to bind this network to ''virbr1'' for Internet Access
    BRIDGE  = vbr1
     
    LEASES  = [IP=130.10.0.1]
    LEASES  = [IP=130.10.0.2, MAC=50:20:20:20:20:21]
    LEASES  = [IP=130.10.0.3]
    LEASES  = [IP=130.10.0.4]
     
    # Custom Attributes to be used in Context
    GATEWAY = 130.10.0.1
    DNS     = 130.10.0.1
     
    LOAD_BALANCER = 130.10.0.4

And red.net file:

.. code::

    NAME    = "Red LAN"
    TYPE    = RANGED
     
    # Now we'll use the host private network (physical)
    BRIDGE  = vbr0
     
    NETWORK_SIZE    = C
    NETWORK_ADDRESS = 192.168.0.0
     
    # Custom Attributes to be used in Context
    GATEWAY = 192.168.0.1
    DNS     = 192.168.0.1
     
    LOAD_BALANCER = 192.168.0.3

Once the files have been created, we can create the VNets executing:

.. code::

    $ onevnet create blue.net
    ID: 0
    $ onevnet create red.net
    ID: 1

Also, ``onevnet`` can be used to query OpenNebula about available VNets:

.. code::

    $ onevnet list
      ID USER     GROUP    NAME            CLUSTER    TYPE BRIDGE  LEASES
       0 oneadmin oneadmin Blue LAN        -             F   vbr1       0
       1 oneadmin oneadmin Red LAN         -             R   vbr0       0

In the output above, ``USER`` is the owner of the network and ``LEASES`` the number of IP-MACs assigned to a VM from this network.

The following attributes can be changed after creating the network: ``VLAN_ID``, ``BRIDGE``, ``VLAN`` and ``PHYDEV``. To update the network run ``onevnet update <id>``.

To delete a virtual network just use ``onevnet delete``. For example to delete the previous networks:

.. code::

    $ onevnet delete 2
    $ onevnet delete 'Red LAN'

You can also check the IPs leased in a network with the ``onevnet show`` command

Check the ``onevnet`` command help or the :ref:`reference guide <cli>` for more options to list the virtual networks.

.. _vgg_ipv6_networks:

IPv6 Networks
-------------

OpenNebula can generate three IPv6 addresses associated to each lease:

-  Link local - fe80::/64 generated always for each lease as IP6\_LINK
-  Unique local address (ULA) - fd00::/8, generate if a local site prefix (SITE\_PREFIX) is provided as part of the network template. The address is associated to the lease as IP6\_SITE
-  Global unicast address - if a global routing prefix (GLOBAL\_PREFIX) is provided in the network template; available in the lease as IP6\_GLOBAL

For all the previous addresses the lower 64 bits are populated with a 64-bit interface identifier in modified EUI-64 format. You do not need to define both SITE\_PREFIX and GLOBAL\_PREFIX , just the ones for the IP6 addresses needed by your VMs.

The IPv6 lease set can be generated as follows depending on the network type:

-  Ranged. You will define a range of MAC addresses (that will be used to generate the EUI-64 host ID in the guest) with the first MAC and a size, e.g. MAC\_START=e8:9d:87:8d:11:22 NETWORK\_SIZE=254.

-  Fixed. Just set the MACs for the network hosts as: LEASE=[MAC=e8:9d:87:8d:11:22] LEASE=[MAC=88:53:2e:08:7f:a0]

For example, the following template defines a ranged IPv6 network:

.. code::

    NAME = "Red LAN 6"
    TYPE = RANGED
     
    BRIDGE = vbr0
     
    MAC_START    = 02:00:c0:a8:00:01
    NETWORK_SIZE = C
     
    SITE_PREFIX   = "fd12:33a:df34:1a::"
    GLOBAL_PREFIX = "2004:a128::"

The IP leases are then in the form:

.. code::

    LEASE=[ MAC="02:00:c0:a8:00:01", IP="192.168.0.1", IP6_LINK="fe80::400:c0ff:fea8:1", IP6_SITE="fd12:33a:df34:1a:400:c0ff:fea8:1", IP6_GLOBAL="2004:a128:0:32:400:c0ff:fea8:1", USED="1", VID="4" ]

Note that IPv4 addresses are generated from the MAC address in case you need to configure IPv4 and IPv6 addresses for the network.

Managing Virtual Networks
=========================

Adding and Removing Leases
--------------------------

You can add and remove leases to existing ``FIXED`` virtual networks (see the :ref:`template file reference <vnet_template>` for more info on the network types). To do so, use the ``onevnet addleases`` and ``onevnet rmleases`` commands.

The new lease can be added specifying its IP and, optionally, its MAC. If the lease already exists, the action will fail.

.. code::

    $ onevnet addleases 0 130.10.0.10
    $ onevnet addleases 0 130.10.0.11 50:20:20:20:20:31
    $
    $ onevnet addleases 0 130.10.0.1
    [VirtualNetworkAddLeases] Error modifiying network leases. Error inserting lease,
    IP 130.10.0.1 already exists

To remove existing leases from the network, they must be free (i.e., not used by any VM).

.. code::

    $ onevnet rmleases 0 130.10.0.3

Hold and Release Leases
-----------------------

Leases can be temporarily be marked ``on hold`` state. These leases are reserved, they are part of the network, but they will not be assigned to any VM.

To do so, use the 'onevnet hold' and 'onevnet release' commands. You see the list of leases on hold with the 'onevnet show' command.

.. code::

    $ onevnet hold "Blue LAN" 130.10.0.1
    $ onevnet hold 0 130.10.0.4

Lease Management in Sunstone
----------------------------

If you are using the Sunstone GUI, you can then easily add, remove, hold and release leases from the dialog of extended information of a Virtual Network. You can open this dialog by clicking the desired element on the Virtual Network table, as you can see in this picture:

|image1|

Update the Virtual Network Template
-----------------------------------

The ``TEMPLATE`` section can hold any arbitrary data. You can use the ``onevnet update`` command to open an editor and edit or add new template attributes. These attributes can be later used in the :ref:`Virtual Machine Contextualization <template_context>`. For example:

.. code::

    dns = "$NETWORK[DNS, NETWORK_ID=3]"

Publishing Virtual Networks
---------------------------

The users can share their virtual networks with other users in their group, or with all the users in OpenNebula. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Let's see a quick example. To share the virtual network 0 with users in the group, the **USE** right bit for **GROUP** must be set with the **chmod** command:

.. code::

    $ onevnet show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    $ onevnet chmod 0 640

    $ onevnet show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

The following command allows users in the same group **USE** and **MANAGE** the virtual network, and the rest of the users **USE** it:

.. code::

    $ onevnet chmod 0 664

    $ onevnet show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

The commands ``onevnet publish`` and ``onevnet unpublish`` are still present for compatibility with previous versions. These commands set/unset

Getting a Lease
===============

A lease from a virtual network can be obtained by simply specifying the virtual network name in the ``NIC`` attribute.

For example, to define VM with two network interfaces, one connected to ``Red LAN`` and other connected to ``Blue LAN`` just include in the template:

.. code::

    NIC = [ NETWORK_ID = 0 ]
    NIC = [ NETWORK    = "Red LAN" ]

Networks can be referred in a NIC in two different ways, see the :ref:`Simplified Virtual Machine Definition File documentation <vm_guide_defining_a_vm_in_3_steps>` for more information:

-  NETWORK\_ID, using its ID as returned by the create operation
-  NETWORK, using its name. In this case the name refers to one of the virtual networks owned by the user (names can not be repeated for the same user). If you want to refer to an NETWORK of other user you can specify that with NETWORK\_UID (by the uid of the user) or NETWORK\_UNAME (by the name of the user).

You can also request a specific address just by adding the ``IP`` attributes to ``NIC`` (or ``MAC`` address, specially in a IPv6):

.. code::

    NIC = [ NETWORK_ID = 1, IP = 192.168.0.3 ]

When the VM is submitted, OpenNebula will look for available IPs in the ``Blue LAN`` and ``Red LAN`` virtual networks. The leases on hold will be skipped. If successful, the ``onevm show`` command should return information about the machine, including network information.

.. code::

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : server
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : PENDING
    LCM_STATE           : LCM_INIT
    START TIME          : 12/13 06:59:07
    END TIME            : -
    DEPLOY ID           : -

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    VIRTUAL MACHINE MONITORING
    NET_TX              : 0
    NET_RX              : 0
    USED MEMORY         : 0
    USED CPU            : 0

    VIRTUAL MACHINE TEMPLATE
    NAME=server
    NIC=[
      BRIDGE=vbr1,
      IP=130.10.0.2,
      MAC=02:00:87:8d:11:25,
      IP6_LINK=fe80::400:87ff:fe8d:1125
      NETWORK="Blue LAN",
      NETWORK_ID=0,
      VLAN=NO ]
    NIC=[
      BRIDGE=vbr0,
      IP=192.168.0.2,
      IP6_LINK=fe80::400:c0ff:fea8:2,
      MAC=00:03:c0:a8:00:02,
      NETWORK="Red LAN",
      NETWORK_ID=1,
      VLAN=NO ]
    VMID=0

.. warning:: Note that if OpenNebula is not able to obtain a lease from a network the submission will fail.

Now we can query OpenNebula with ``onevnet show`` to find out about given leases and other VNet information:

.. code::

    $ onevnet list
      ID USER     GROUP    NAME            CLUSTER    TYPE BRIDGE  LEASES
       0 oneadmin oneadmin Blue LAN        -             F   vbr1       3
       1 oneadmin oneadmin Red LAN         -             R   vbr0       3

Note that there are two LEASES on hold, and one LEASE used in each network

.. code::

    $ onevnet show 1
    VIRTUAL NETWORK 1 INFORMATION
    ID             : 1
    NAME           : Red LAN
    USER           : oneadmin
    GROUP          : oneadmin
    TYPE           : RANGED
    BRIDGE         : vbr0
    VLAN           : No
    PHYSICAL DEVICE:
    VLAN ID        :
    USED LEASES    : 3

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    VIRTUAL NETWORK TEMPLATE
    DNS=192.168.0.1
    GATEWAY=192.168.0.1
    LOAD_BALANCER=192.168.0.3
    NETWORK_MASK=255.255.255.0

    RANGE
    IP_START       : 192.168.0.1
    IP_END         : 192.168.0.254

    LEASES ON HOLD
    LEASE=[ MAC="02:00:c0:a8:00:01", IP="192.168.0.1", IP6_LINK="fe80::400:c0ff:fea8:1", USED="1", VID="-1" ]
    LEASE=[ MAC="02:00:c0:a8:00:03", IP="192.168.0.3", IP6_LINK="fe80::400:c0ff:fea8:3", USED="1", VID="-1" ]

    USED LEASES

    LEASE=[ MAC="02:00:c0:a8:00:02", IP="192.168.0.2", IP6_LINK="fe80::400:c0ff:fea8:2", USED="1", VID="4" ]

.. warning:: IP 192.168.0.2 is in use by Virtual Machine 4

Apply Firewall Rules to VMs
---------------------------

You can apply firewall rules on your VMs, to filter TCP and UDP ports, and to define a policy for ICMP connections.

Read more about this feature :ref:`here <firewall>`.

Using the Leases within the Virtual Machine
-------------------------------------------

Hypervisors can attach a specific MAC address to a virtual network interface, but Virtual Machines need to obtain an IP address.

In order to configure the IP inside the guest, you need to use one of the two available methods:

-  Instantiate a :ref:`Virtual Router <router>` inside each Virtual Network. The Virtual Router appliance contains a DHCP server that knows the IP assigned to each VM.
-  Contextualize the VM. Please visit the :ref:`contextualization guide <cong>` to learn how to configure your Virtual Machines to automatically obtain an IP derived from the MAC.

.. |image0| image:: /images/sunstone_vnet_create.png
.. |image1| image:: /images/sunstone_vnet_leases.png
