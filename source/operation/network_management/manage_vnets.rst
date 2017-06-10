.. _vgg:
.. _manage_vnets:

================
Virtual Networks
================

A host is connected to one or more networks that are available to the virtual machines through the corresponding bridges. OpenNebula allows the creation of Virtual Networks by mapping them on top of the physical ones.

.. _vgg_vn_model:

Virtual Network Definition
==========================

A Virtual Network definition consists of three different parts:

- The **underlying physical network infrastructure** that will support it, including the network driver.

- The **logical address space** available. Addresses associated to a Virtual Network can be IPv4, IPv6, dual stack IPv4-IPv6 or Ethernet.

- The **guest configuration attributes** to setup the Virtual Machine network, that may include for example network masks, DNS servers or gateways.

Physical Network Attributes
---------------------------

To define a Virtual Network include:

* ``NAME`` to refer this Virtual Network.

* ``VN_MAD`` the driver to implement this Virtual Network. Depending on the driver you may need to set additional attributes, check the following to get more details:

  * :ref:`Define a bridged network <bridged_net>`
  * :ref:`Define a 802.1Q network <hm-vlan_net>`
  * :ref:`Define a VXLAN network <vxlan_net>`
  * :ref:`Define a OpenvSwitch network <ovswitch_net>`

* QoS parameters (optional) for each NIC attached to the network, to limit the inbound/outbound average and peak bandwidths as well as the burst data size that can be transmitted at peak speed (:ref:`see more details here <vnet_template_qos>`).

For example, to define a 802.1Q Virtual Network you would add:

.. code::

    NAME    = "Private Network"
    VN_MAD  = "802.1Q"
    PHYDEV  = "eth0"

    OUTBOUND_AVG_BW = "1000"
    OUTBOUND_PEAK_BW = "1500"
    OUTBOUND_PEAK_KB = "2048"

.. _manage_vnet_ar:

Address Space
-------------

The addresses available in a Virtual Network are defined by one or more Address Ranges (AR). Each AR defines a continuous address range and optionally, configuration attributes that will override the first level attributes defined in the Virtual Network. There are four types of ARs:

- **IPv4**, to define a contiguous IPv4 address set (classless), :ref:`see more details here <vnet_template_ar4>`
- **IPv6**, to define global and ULA IPv6 networks, :ref:`see full details here <vnet_template_ar6>`
- **IPv6 no-SLAAC**, to define fixed 128 bits IPv6 address, :ref:`see here<vn_template_ar6_nslaac>`
- **Dual stack**, each NIC in the network will get both a IPv4 and a IPv6 address (SLAAC or no-SLAAC), :ref:`see more here <vnet_template_ar46>`
- **Ethernet**,  just MAC addresses are generated for the VMs. You should use this AR when an external service is providing the IP addresses, such a DHCP server, :ref:`see more details here <vnet_template_eth>`

For example, to define the IPv4 address range 10.0.0.150 - 10.0.0.200

.. code::

    AR=[
        TYPE = "IP4",
        IP   = "10.0.0.150",
        SIZE = "51",
    ]

Guest Configuration Attributes (Context)
----------------------------------------

To setup the guest network, the Virtual Network may include additional information to be injected into the VM at boot time. These contextualization attributes may include for example network masks, DNS servers or gateways. For example, to define a gateway and DNS server for the virtual machines in the Virtual Network, simply add:

.. code::

    DNS = "10.0.0.23"
    GATEWAY = "10.0.0.1"

These attributes are automatically added to the VM and processed by the context packages. Virtual Machines just need to add:

.. code::

    CONTEXT = [
      NETWORK="yes"
    ]

:ref:`See here for a full list of supported attributes <vnet_template_context>`

Virtual Network Definition Example
----------------------------------

Getting all the three pieces together we get:

.. code::

    NAME    = "Private"
    VN_MAD  = "802.1Q"
    PHYDEV  = "eth0"

    AR=[
        TYPE = "IP4",
        IP   = "10.0.0.150",
        SIZE = "51"
    ]

    DNS     = "10.0.0.23"
    GATEWAY = "10.0.0.1"

    DESCRIPTION = "A private network for VM inter-communication"

This file will create a IPv4 network using VLAN tagging, the VLAN ID in this case is assigned by OpenNebula. The network will lease IPs in the range 10.0.0.150 - 10.0.0.200. Virtual Machines in this network will get a lease in the range and configure DNS servers to 10.0.0.23 and 10.0.0.1 as default gateway.

:ref:`See here for more examples <vnet_template_example>`

Adding and Deleting Virtual Networks
====================================

.. note:: This guide uses the CLI command ``onevnet``, but you can also manage your virtual networks using :ref:`Sunstone <sunstone>`. Select the Network tab, and there you will be able to create and manage your virtual networks in a user friendly way.

|image0|

To create a new network put its configuration in a file, for example using the contents above, and then execute:

.. code::

    $ onevnet create priv.net
    ID: 4

You can delete a virtual network using its ID or name:

.. code::

    $ onevnet delete 0
    $ onevnet delete "Private"

To list the virtual networks in the system use ``onevnet list``:

.. code::

   $ onevnet list
   ID USER         GROUP        NAME            CLUSTER    BRIDGE   LEASES
    0 admin        oneadmin     Private         0,100      onebr.10      0
    1 admin        oneadmin     Public          0,101      vbr0          0

In the output above, ``USER`` is the owner of the network and ``LEASES`` the number of addresses assigned to a virtual machine or reserved.

You can check the details of a Virtual Network with the ``onevnet show`` command:

.. code::

  $ onevnet show 1
    VIRTUAL NETWORK 4 INFORMATION
    ID             : 4
    NAME           : Private
    USER           : ruben
    GROUP          : oneadmin
    CLUSTERS       : 0
    BRIDGE         : onebr4
    VN_MAD         : 802.1Q
    PHYSICAL DEVICE: eth0
    VLAN ID        : 6
    USED LEASES    : 0

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    VIRTUAL NETWORK TEMPLATE
    BRIDGE="onebr4"
    DESCRIPTION="A private network for VM inter-communication"
    DNS="10.0.0.23"
    GATEWAY="10.0.0.1"
    PHYDEV="eth0"
    SECURITY_GROUPS="0"
    VN_MAD="802.1Q"

    ADDRESS RANGE POOL
    AR 0
    SIZE           : 51
    LEASES         : 0

    RANGE                                   FIRST                               LAST
    MAC                         02:00:0a:00:00:96                  02:00:0a:00:00:c8
    IP                                 10.0.0.150                         10.0.0.200

Check the ``onevnet`` command help or the :ref:`reference guide <cli>` for more options to list the virtual networks.

Virtual Network Tips
---------------------
* You may have some used IPs in a VNET so you do not want them to be assigned. You can add as many ARs as you need to implement these address gaps. Alternatively you can put address on hold to prevent them to be assigned.

* ARs can be of SIZE = 1 to define single addresses lease scheme.

* ARs does not need to be of the same type or belong to the same IP network. To accommodate this use case you can overwrite context attributes in the AR, for example adding attributes like NETWORK_MASK or DNS in the AR definition.

* *Super-netting*, you can even combine ARs overwriting the physical attributes, e.g. ``BRIDGE`` or ``VLAN_ID``. This way a Virtual Network can be a logical super-net, e.g. DMZ, that can be implemented through multiple VLANs each using a different hypervisor bridge.

* There are no need to plan all your IP assignment plan beforehand, ARs can be added and modified after the Virtual Network is created, see below.

Updating a Virtual Network
==========================

After creating a Virtual Network, you can use the ``onevnet update`` command to update the following attributes:

* Any attribute corresponding to the context or description.

* Physical network configuration attributes, e.g. ``PHYDEV`` or ``VLAN_ID``.

* Any custom tag.

Also the name of the Virtual Network can be changed with ``onevnet rename`` command.

.. _manage_address_ranges:

Managing Address Ranges
=======================

Addresses are structured in Address Ranges (AR). Address Ranges can be dynamically added or removed from a Virtual Network. In this way, you can easily add new addresses to an existing Virtual Network if the current addresses are exhausted.

Adding and Removing Address Ranges
----------------------------------

A new AR can be added using exactly the same definition parameters as described above. For example the following command will add a new AR of 20 IP addresses:

.. code::

    onevnet addar Private --ip 10.0.0.200 --size 20

In the same way you can remove an AR:

.. code::

    onevnet rmar Private 2

Updating Address Ranges
-----------------------

You can update the following attributes of an AR:

- ``SIZE``, assigned addresses cannot fall outside of the range.
- IPv6 prefix: ``GLOBAL_PREFIX`` and ``ULA_PREFIX``
- Any custom attribute that may override the Virtual Network defaults.

The following command shows how to update an AR using the CLI, an interactive editor session will be stated:

.. code::

    onevnet updatear Private 0

Hold and Release Leases
-----------------------
Addresses can be temporarily be marked as ``hold``. They are still part of the network, but they will not be assigned to any virtual machine.

To do so, use the 'onevnet hold' and 'onevnet release' commands. By default, the address will be put on hold in all ARs containing it; if you need to hold the IP of a specific AR you can specified it with the '-a <AR_ID>' option.

.. code::

    #Hold IP 10.0.0.120 in all ARs
    $ onevnet hold "Private Network" 10.0.0.120

    #Hold IP 10.0.0.123 in AR 0
    $ onevnet hold 0 10.0.0.123 -a 0

You see the list of leases on hold with the 'onevnet show' command, they'll show up as used by virtual machine -1, 'V: -1'

Using a Virtual Network
=======================

Once the Virtual Networks are setup, they can be made available to users based on access rights and ownership. The preferred way to do so is through :ref:`Virtual Data Center abstraction <manage_vdcs>`. By default, all Virtual Networks are automatically available to the group ``users``.

Attach a Virtual Machine to a Virtual Network
---------------------------------------------

To attach a Virtual Machine to a Virtual Network simply specify its name or ID in the ``NIC`` attribute.  For example, to define VM with a network interface connected to the ``Private`` Virtual Network just include in the template:

.. code::

    NIC = [ NETWORK = "Private" ]

Equivalently you can use the network ID as:

.. code::

    NIC = [ NETWORK_ID = 0 ]

The Virtual Machine will also get a free address from any of the address ranges of the network.  You can also request a specific address just by adding the ``IP`` or ``MAC`` to ``NIC``. For example to put a Virtual Machine in the network ``Private`` and request 10.0.0.153 use:

.. code::

    NIC = [ NETWORK = "Network", IP = 10.0.0.153 ]

.. warning:: Note that if OpenNebula is not able to obtain a lease from a network the submission will fail.

.. warning:: Users can only attach VMs or make reservations from Virtual Networks with **USE** rights on it. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Configuring the Virtual Machine Network
---------------------------------------

Hypervisors will set the MAC address for the NIC of the Virtual Machines, but not the IP address. The IP configuration inside the guest is performed by the contextualization process, check the :ref:`contextualization guide <context_overview>` to learn how to prepare your Virtual Machines to automatically configure the network

.. note:: Altenatively a custom external service can configure the Virtual Machine network (e.g. your own DHCP server in a separate virtual machine)

.. _vgg_vn_reservations:

Virtual Network Self-Provisioning: Reservations
===============================================

Virtual Networks implement a simple self-provisioning scheme, that allows users to create their own networks consisting of portions of an existing Virtual Network. Each portion is called a Reservation. To implement this you need to:

- **Define a VNET**, with the desired ARs and configuration attributes. These attributes will be inherited by any Reservation, so the final users do not need to deal with low-level networking details.

- **Setting up access**. In order to make a Reservation, users needs USE rights on the Virtual Network, just as if they would use it to directly to provision IPs from it.

- **Make Reservations**. Users can easily request specific addresses or just a number of addresses from a network. Reservations are placed in a new Virtual Network for the user.

- **Use Reservations**. Reservations are Virtual Networks and offer the same interface, so simply point any Virtual Machine to them. The number of addresses and usage stats are shown also in the same way.

Make and delete Reservations
----------------------------

To make a reservations just choose the source Virtual Network, the number of addresses and the name of the reservation. For example to reserve 10 addresses from Private and place it on MyVNET just:

.. code::

     $ onevnet reserve Private -n MyVNET -s 10
     Reservation VNET ID: 7

As a result a new VNET has been created:

.. code::

    $ onevnet list
    ID USER         GROUP        NAME            CLUSTER    BRIDGE   LEASES
     0 admin        oneadmin     Private         -          vbr1         10
     7 helen        users        MyVNET          -          vbr1          0

Note that Private shows 10 address leases in use, those reserved by Virtual Network 7. Also note that both networks share the same configuration, e.g. ``BRIDGE``.

Reservations can include advanced options such as:

- The AR where you want to make the reservation from in the source Virtual Network
- The starting IP or MAC to make the reservation from

A reservation can be remove just as a regular Virtual Network:

.. code::

   $ onevnet delete MyVNET

Using Reservations
------------------

To use a reservation you can use it as any other Virtual Network; as they expose the same interface. For example, to attach a virtual machine to the previous Reservation:

.. code::

   NIC = [ NETWORK = "MyVNET"]

Updating Reservations
---------------------

A Reservation can be also extended with new addresses. This is, you can add a new reservation to an existing one. This way a user can refer to its own network with a controlled and deterministic address space.

.. note:: Reservation increase leases counters on the user and group, and they can be limited through a quota.

.. note:: The reservation interface is exposed by Sunstone in a very convenient way.

.. |image0| image:: /images/sunstone_vnet_create.png
