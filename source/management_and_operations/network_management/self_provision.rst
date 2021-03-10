.. _self_provision:

==================================
Virtual Network Self-Provisioning
==================================

End-users can create their own virtual networks in two different ways: making a **reservation** or instantiating a **Virtual Network Template**.

.. _vgg_vn_reservations:

Reservations
===============================================

Reservations allows users to create their own networks consisting of portions of an existing Virtual Network. Each portion is called a Reservation. To implement this you need to:

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


Virtual Network Templates
===============================================

Virtual Network Templates allow end users to create their own network without knowledge of the underlying infrastructure. Virtual Network Templates, unlike Reservations, allows end user to set the logic attributes, like address ranges, dns server or gateway of the network. See the :ref:`Virtual Network Templates guide<vn_templates>` for more information.
