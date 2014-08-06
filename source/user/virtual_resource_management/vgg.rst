.. _vgg:

==========================
Managing Virtual Networks
==========================

A host is connected to one or more networks that are available to the virtual machines through the corresponding bridges. OpenNebula allows the creation of Virtual Networks by mapping them on top of the physical ones.

.. _vgg_vn_model:

Virtual Network Model
=====================

A virtual network (VNET) definition consists of three different parts:

-  The **underlying networking infrastructure** that will support the VNET. These section will typically include the following values:

+-------------+-----------------------------------------------------+
| Attribute   |                     Description                     |
+=============+=====================================================+
| ``BRIDGE``  | Device to bind the virtual and physical network,    |
|             | depending on the network driver it may refer to     |
|             | different technologies or require host setups.      |
+-------------+-----------------------------------------------------+
| ``VLAN``    | Set to ``YES`` to activate VLAN isolation when      |
|             | supported by the network drivers                    |
+-------------+-----------------------------------------------------+
| ``VLAN_ID`` | Identifier for the VLAN                             |
+-------------+-----------------------------------------------------+

.. warning:: The attributes above depend on the networking technology (drivers) used by the hosts when they are created. Please refer to the specific :ref:`networking guide <nm>` for a complete description of each value.

- The **logical address space** available. Addresses associated to a VNET can be IPv4, IPv6, dual stack IPv4-IPv6 or Ethernet; and can define a non-continuous addresses range  structured in one or more Address Ranges (AR), see below

- **Context attributes**. Apart from the addresses and configuration attributes used to setup the guest network additional information can be injected into the VM at boot time. These contextualization attributes may include for example network masks, DNS servers or gateways. The following values are recognize by the contextualization packages:

  - ``NETWORK_ADDRESS``
  - ``NETWORK_MASK``
  - ``GATEWAY``
  - ``GATEWAY6``
  - ``DNS``

These attributes can be later used in the :ref:`Virtual Machine Contextualization <template_context>`. For example:

.. code::

    CONTEXT = [
      DNS = "$NETWORK[DNS, NETWORK=Private]"
    ]

.. note:: You can add any arbitrary data to the VNET to later use it within the VMs or just to tag the VNET with any attribute.

.. _vgg_vn_ar:

The Address Range (AR)
----------------------

The addresses available in a VNET are defined by one or more Address Ranges (AR). Each address range defines a continuous address range and optionally, configuration attributes (context or configuration) that will override those provided by the VNET.

.. _vgg_ipv6_networks:

IPv4 Address Range
^^^^^^^^^^^^^^^^^^

Defines a continuous IPv4 range:

+-------------+-----------------------------------------------------+
| Attribute   |                     Description                     |
+=============+=====================================================+
| ``TYPE``    | ``IP4``                                             |
+-------------+-----------------------------------------------------+
| ``IP``      | First IP in the range in dot notation.              |
+-------------+-----------------------------------------------------+
| ``MAC``     | **Optional**. First MAC, if not provided it will be |
|             | generated using the IP and the MAC_PREFIX in        |
|             | ``oned.conf``.                                      |
+-------------+-----------------------------------------------------+
| ``SIZE``    | Number of addresses in this range.                  |
+-------------+-----------------------------------------------------+

.. code::

    #Example of an IPv4 AR, template form
    AR=[
        TYPE = "IP4",
        IP   = "10.0.0.150",
        MAC  = "02:00:0a:00:00:96",
        SIZE = "51",
    ]

IPv6 Address Range
^^^^^^^^^^^^^^^^^^

IPv6 networks assumes the auto-configuration process defined in the IPv6 standard, so the host id part is derived by the MAC address (or randomly). The global and ULA prefix needs to be provided.

+-------------------+-----------------------------------------------------+
| Attribute         |                     Description                     |
+===================+=====================================================+
| ``TYPE``          | ``IP6``                                             |
+-------------------+-----------------------------------------------------+
| ``MAC``           | **Optional**. First MAC, if not provided it will be |
|                   | generated randomly.                                 |
+-------------------+-----------------------------------------------------+
| ``GLOBAL_PREFIX`` | **Optional**. A /64 globally routable prefix        |
+-------------------+-----------------------------------------------------+
| ``ULA_PREFIX``    | **Optional**. A /64 unique local address (ULA)      |
|                   | prefix corresponding to the ``fd00::/8`` block      |
+-------------------+-----------------------------------------------------+
| ``SIZE``          | Number of addresses in this range.                  |
+-------------------+-----------------------------------------------------+

.. code::

    #Example of an IPv6 AR, template form
    AR=[
        TYPE= "IP6",
        MAC = "02:00:40:55:83:ff",
        GLOBAL_PREFIX = "2001:a::",
        ULA_PREFIX    = "fd01:a:b::",
        SIZE="1000"
    ]

.. note:: You can define either ``GLOBAL_PREFIX`` or ``ULA_PREFIX``, or both as needed to generate global, or ULA, or both IP6 addresses. Also note that the prefix are 64 bit long, including any subnet ID.

Dual IPv4-IPv6 Address Range
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The dual stack IP4-IP6 is just a combination of the two previous ARs, thus generating both a IPv4 and IPv6 addresses.

+-------------------+-----------------------------------------------------+
| Attribute         |                     Description                     |
+===================+=====================================================+
| ``TYPE``          | ``IP4_6``                                           |
+-------------------+-----------------------------------------------------+
| ``IP``            | First IP in the range in dot notation.              |
+-------------------+-----------------------------------------------------+
| ``MAC``           | **Optional**. First MAC, if not provided it will be |
|                   | generated using the IP and the MAC_PREFIX in        |
|                   | ``oned.conf``.                                      |
+-------------------+-----------------------------------------------------+
| ``GLOBAL_PREFIX`` | **Optional**. A /64 globally routable prefix        |
+-------------------+-----------------------------------------------------+
| ``ULA_PREFIX``    | **Optional**. A /64 unique local address (ULA)      |
|                   | prefix corresponding to the ``fd00::/8`` block      |
+-------------------+-----------------------------------------------------+
| ``SIZE``          | Number of addresses in this range.                  |
+-------------------+-----------------------------------------------------+

.. code::

    # Example of a dual IP6 IP4 range, template form
    AR=[
        TYPE = "IP4_6",
        IP   = "192.1.0.1",
        GLOBAL_PREFIX = "2001:a::",
        SIZE = "60"
   ]

Ethernet Address Range
^^^^^^^^^^^^^^^^^^^^^^

This is the simplest AR, just MAC addresses are generated for the VM guests. You
should use this AR when an external service is providing the IP addresses, such a DHCP server.

+-------------------+-----------------------------------------------------+
| Attribute         |                     Description                     |
+===================+=====================================================+
| ``TYPE``          | ``ETHER``                                           |
+-------------------+-----------------------------------------------------+
| ``MAC``           | **Optional**. First MAC, if not provided it will be |
|                   | generated randomly.                                 |
+-------------------+-----------------------------------------------------+
| ``SIZE``          | Number of addresses in this range.                  |
+-------------------+-----------------------------------------------------+

.. code::

    # Example of Ethernet range, template form
    AR=[
        TYPE = "ETHER",
        SIZE = "25"
    ]

This guide uses the CLI command ``onevnet``, but you can also manage your virtual networks using :ref:`Sunstone <sunstone>`. Select the Network tab, and there you will be able to create and manage your virtual networks in a user friendly way.

|image0|

Adding and Deleting Virtual Networks
====================================

A VNET is created through a template definition file containing the previous set of attributes: configuration, context and address ranges. The following example shows how to define a pure IPv4.

Create a file with the network configuration: priv.net

.. code::

    # Confgiuration attributes (dummy driver)
    NAME        = "Private Network"
    DESCRIPTION = "A private network for VM inter-communication"

    BRIDGE = "bond-br0"

    # Context attributes
    NETWORK_ADDRESS = "10.0.0.0"
    NETWORK_MASK    = "255.255.255.0"
    DNS             = "10.0.0.1"
    GATEWAY         = "10.0.0.1"

    #Address Ranges, only these addresses will be assigned to the VMs
    AR=[
        TYPE = "IP4",
        IP   = "10.0.0.10",
        SIZE = "100",
    ]

    AR=[
        TYPE = "IP4",
        IP   = "10.0.0.200",
        SIZE = "10",
    ]

Once the file has been created, we can create the VNET executing:

.. code::

    $ onevnet create priv.net
    ID: 0

You can remove a VNET when no longer needed using its ID or NAME:

.. code::

    $ onevnet delete 0
    $ onevnet delete "Private Network"

Also, ``onevnet`` can be used to query OpenNebula about available VNets:

.. code::

   $ onevnet list
   ID USER         GROUP        NAME            CLUSTER    BRIDGE   LEASES
    0 admin        oneadmin     Private         -          vbr1          0
    1 admin        oneadmin     Public          -          vbr0          0

In the output above, ``USER`` is the owner of the network and ``LEASES`` the number of addresses assigned to a VM or reserved from each VNET.

You can also check the IPs leased in a network with the ``onevnet show`` command

.. code::

  $ onevnet show 1
  VIRTUAL NETWORK 1 INFORMATION
  ID             : 1
  NAME           : Public
  USER           : admin
  GROUP          : oneadmin
  CLUSTER        : -
  BRIDGE         : vbr0
  VLAN           : No
  USED LEASES    : 1

  PERMISSIONS
  OWNER          : um-
  GROUP          : u--
  OTHER          : u--

  VIRTUAL NETWORK TEMPLATE
  BRIDGE="vbr0"
  DESCRIPTION="Network with Internet connection through NAT"
  NETWORK_ADDRESS="10.0.0.0"
  NETWORK_MASK="255.255.255.0"
  PHYDEV=""
  VLAN="NO"
  VLAN_ID=""

  ADDRESS RANGE POOL
   AR TYPE    SIZE LEASES               MAC              IP        GLOBAL_PREFIX
    0 IP4       51      1 02:00:0a:00:00:96      10.0.0.150

  LEASES
   AR  OWNER                     MAC              IP                   IP6_GLOBAL
    0   VM : 43    02:00:0a:00:00:96      10.0.0.150


Check the ``onevnet`` command help or the :ref:`reference guide <cli>` for more options to list the virtual networks.

VNET Definition Tips
---------------------
- You may have some used IPs in a VNET so you do not want them to be assigned. You can add as many ARs as you need to implement these address gaps. Alternatively you can put address on hold to prevent them to be assigned.

- ARs can be of SIZE = 1 to define single addresses lease scheme. This set up is equivalent to the previous FIXED VNET type.

- ARs does not need to be of the same type or belong to the same IP network. To accommodate this use case you can overwrite context attributes in the AR, this is you can include attributes like NETWORK_MASK or DNS in the AR definition.

- *Super-netting*, you can even combine ARs overwriting the VNET ``BRIDGE`` or with a different ``VLAN_ID``. This way a VNET can be a logical network, e.g. DMZ, that can be implemented through multiple VLANs or host interfaces.

- There are no need to plan all your IP assignment plan beforehand, ARs can be added and modified after the VNET is created, see below.


Updating a Virtual Network
==========================

The following attributes can be changed after creating the network, using ``onevnet update`` command:
- Any attribute corresponding to the context or VNET description.
- Network configuration attributes, in particular: ``PHYDEV``, ``VLAN_ID``, ``VLAN`` and ``BRIDGE``

Also the name of the VNET can be changed with ``onevnet rename`` command.

Managing Address Ranges
=======================

Addresses of a VNET are structured in Address Ranges (AR), VNETs are quite flexible in terms of addition and removal of addresses. In this way, you can easily add new addresses to an existing VNET if the current addresses are exhausted.

Adding and Removing Address Ranges
----------------------------------

A new AR can be added to the VNET using exactly the same definition parameters as described above. For example the following command will add a new AR of 20 IP addresses to the VNET:

.. code::

    onevnet addar Private --ip 10.0.0.200 --size 20

In the same way you can remove an AR:

.. code::

    onevnet rmar Private 2

Using Sunstone you can manage ARs (add, remove or update) in the Addresses tab of the VNET information.

|image1|

Updating Address Ranges
-----------------------

You can update the following attributes of an AR:

- ``SIZE``, assigned addresses cannot fall outside of the range.
- IPv6 prefix: ``GLOBAL_PREFIX`` and ``ULA_PREFIX``
- Any custom attribute that may override the VNET defaults.

The following command shows how to update an AR using the CLI

.. code::

    #Update the AR 0 of VNET "Private"
    onevnet updatear Private 0

Hold and Release Leases
-----------------------
Addresses can be temporarily be marked ``on hold`` state. They are part of the network, but they will not be assigned to any VM.

To do so, use the 'onevnet hold' and 'onevnet release' commands. By default, the address will be put on hold in all ARs containing it; if you need to hold the IP of a specific AR you can specified it with the '-a <AR_ID>' option.

.. code::

    #Hold IP 10.0.0.120 in all ARs
    $ onevnet hold "Private Network" 10.0.0.120

    #Hold IP 10.0.0.123 in AR 0
    $ onevnet hold 0 10.0.0.123 -a 0

You see the list of leases on hold with the 'onevnet show' command, they'll show up as used by VM -1, 'VM: -1'

Using a VNET
============

Getting an address for a VM
---------------------------
An address lease from a VNET can be obtained by simply specifying the virtual network name in the ``NIC`` attribute.

For example, to define VM with a network interfaces connected to the ``Private Network`` just include in the template:

.. code::

    # Reference by ID
    NIC = [ NETWORK_ID = 0 ]
    # Reference by NAME
    NIC = [ NETWORK    = "Private Network" ]

Networks can be referred in a NIC in two different ways, see the :ref:`Simplified Virtual Machine Definition File documentation <vm_guide_defining_a_vm_in_3_steps>` for more information:

-  ``NETWORK_ID``, using its ID as returned by the create operation

-  ``NETWORK``, using its name. In this case the name refers to one of the virtual networks owned by the user (names cannot be repeated for the same user). If you want to refer to a VNET of other user you can specify that with ``NETWORK_UID`` (by the uid of the user) or ``NETWORK_UNAME`` (by the name of the user).

You can also request a specific address just by adding the ``IP`` or ``MAC``attributes to ``NIC``. If no address is requested the first free address (in any AR) will be used.

.. code::

    NIC = [ NETWORK_ID = 1, IP = 192.168.0.3 ]

When the VM is submitted, OpenNebula will look for available IPs, leases on hold, reserved or in use by other VMs will be skipped. If successful, the ``onevm show`` command should return information about the machine, including network information.

.. code::

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    VMID=0

    ...

    VM NICS
      ID NETWORK              VLAN BRIDGE       IP              MAC
       0 Public                 no vbr0         10.0.0.150      02:00:0a:00:00:96

.. warning:: Note that if OpenNebula is not able to obtain a lease from a network the submission will fail.

Using the address within the VM
-------------------------------

Hypervisors can set the MAC address of a virtual NIC, but VMs need to obtain an IP address for it. In order to configure the IP inside the guest, you need to use one of the two available methods:

-  Instantiate a :ref:`Virtual Router <router>` inside each Virtual Network. The Virtual Router appliance contains a DHCP server that knows the IP assigned to each VM.

-  Contextualize the VM. Please visit the :ref:`contextualization guide <cong>` to learn how to configure your Virtual Machines to automatically obtain an IP derived from the MAC.

-  Use an custom external service (e.g. your own DHCP server)

Apply Firewall Rules to VMs
---------------------------

You can apply firewall rules on your VMs, to filter TCP and UDP ports, and to define a policy for ICMP connections.

Read more about this feature :ref:`here <firewall>`.

.. _vgg_vn_reservations:

VNET Self-Provisioning: Reservations
====================================

VNETs implement a simple self-provisioning scheme, that allows users to create their own networks consisting of portions of an existing VNET. Each portion is called a Reservation. To implement this you need to:

- **Define a VNET**, with the desired ARs and configuration attributes. These attributes will be inherited by any Reservation made on the VNET. Final users does not need to deal with low-level networking details.
- **Setting up access**. In order to make a Reservation, users needs USE rights on the VNET, just as if they would use it to directly to provision IPs from it.
- **Make Reservations**. Users can easily request specific addresses or just a number of addresses from a VNET. Reservations are placed in their own VNET for the user.
- **Use Reservations**. Reservations offer the same interface as a regular VNET so you can just point your VM templates to the new VNET. The number of addresses and usage stats are shown also in the same way.

Setting up access to VNETs
--------------------------

Once a VNET is setup by a Cloud admin, she needs to make it available to other users in the cloud. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Let's see a quick example. The following command allows users in the same group **USE** and **MANAGE** the virtual network, and the rest of the users **USE** it:

.. code::

    $ onevnet chmod 0 664

    $ onevnet show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

.. note:: Users can only attach VMs or make reservations from VNETs with **USE** rights on the VNET

Make and delete Reservations
----------------------------

In its simplest form you can make a reservations just by defining the source VNET, the number of addresses and the name of the reservation. For example to reserve 10 addresses from VNET Private and place it on MyVNET just:

.. code::

     $ onevnet reserve Private -n MyVNET -s 10

As a result a new VNET has been created:

.. code::

    $ onevnet list
    ID USER         GROUP        NAME            CLUSTER    BRIDGE   LEASES
     0 admin        oneadmin     Private         -          vbr1         10
     1 helen        users        MyVNET          -          vbr1          0

Note that VNET Private shows 10 address leases in use, and leased to VNET 1. Also note that both VNETs share the same configuration, e.g. BRIDGE vbr1. You can verify this details with ``onevnet show`` command.

Reservations can include advanced options such as:

- The AR where you want to make the reservation from in the source VNET
- The starting IP or MAC to make the reservation from

A reservation can be remove just as a regular VNET:

.. code::

   $ onevnet delete MyVNET

Using Reservations
------------------

To use a reservation you can use it as any other VNET; as they expose the same interface, i.e. you can refer to VNET variables in context, add NICs...

.. code::

   #Use a reservation in a VM
   NIC = [ NETWORK = "MyVNET"]

A Reservation can be also extended with new addresses. This is, you can add a new reservation to an existing one. This way a user can refer to its own network with a controlled and deterministic address space.

.. note:: Reservation increase leases counters on the user and group, and they can be limited through a quota.

.. note:: The reservation interface is exposed by Sunstone in a very convenient way.

.. |image0| image:: /images/sunstone_vnet_create.png
.. |image1| image:: /images/sunstone_vnet_leases.png
