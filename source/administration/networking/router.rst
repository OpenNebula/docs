.. _router:

===============
Virtual Router
===============

This guide describes how to use the `Virtual Router <http://marketplace.c12g.com/appliance/53d108268fb81d0b1e000001>`__ in OpenNebula.

Overview
========

When instantiated in a network, this appliance provides the following services for other Virtual Machines running in the same network:

-  Router (masquerade)
-  Port forwarding
-  DHCP server
-  RADVD server
-  DNS server

|image0|

A big advantage of using this appliance is that Virtual Machines can be run in the same network **without** being :ref:`contextualized <cong>` for OpenNebula.

This appliance is controlled via ``CONTEXT``. More information in the following sections.

Considerations & Limitations
============================

This is a 64-bit appliance and will run both in ``KVM``, ``Xen`` and ``VMware`` environments. It will run with any network driver.

Since each virtual router will start a DHCP server and it's not recommended to have more than one DHCP server per network, it's recommend to use it along network isolation drivers if you're going to deploy two or more router instances in your environment:

-  :ref:`Open vSwitch <openvswitch>`
-  :ref:`Ebtables <ebtables>`
-  :ref:`802.1Q VLAN <hm-vlan>`

Configuration
=============

The appliance is based on `alpinelinux <http://alpinelinux.org/>`__. There's only one user account: ``root``. There is no default password for the root account, however, it can be specified in the ``CONTEXT`` section along with root's public key.

-  **SSH_PUBLIC_KEY**: If set, it will be set as root's authorized_keys.
-  **ROOT_PASSWORD**: To change the root account password use this attribute. It expects the password in an encrypted format as returned by ``openssl passwd -1`` and encoded in base64. For example, to generate the password ``test``, you will need to issue this command: ``openssl passwd -1 test | base64``.

Usage
=====

The virtual router can be used in two ways:

DHCP or RADVD Server
--------------------

Only one interface. Useful if you only want DHCP or RADVD. Of course, enabling RADVD only makes sense if the private network is IPv6.

To enable this you need to add the following context to the VM:

.. code::

    TARGET     = "hdb"
    PRIVNET  = "$NETWORK[TEMPLATE, NETWORK=\"<private_network_name>\"]",
    TEMPLATE = "$TEMPLATE"
    DHCP     = "YES|NO"
    RADVD    = "YES|NO"

Instead of specifying the network name, you can specify the network id:

.. code::

    PRIVNET  = "$NETWORK[TEMPLATE, NETWORK_ID=\"<private_network_id>\"]",
    ...

Full Router
-----------

In this case, the Virtual Machine will need two network interfaces: a private and a public one. The public one will be masqueraded. In this mode you can also configure a DNS server by setting the ``DNS`` and optionally the ``SEARCH`` attribute (useful for domain searches in ``/etc/resolv.conf``). This mode also includes all the attributes related to the previous section, i.e. DHCP and RADVD servers.

This is an example context for the router mode:

.. code::

    TARGET     = "hdb"
    PRIVNET    = "$NETWORK[TEMPLATE, NETWORK=\"<private_network>\"]",
    PUBNET     = "$NETWORK[TEMPLATE, NETWORK=\"<public_network>\"]",
    TEMPLATE   = "$TEMPLATE"
    DHCP       = "YES|NO"
    RADVD      = "YES|NO" # Only useful for an IPv6 private network
    NTP_SERVER = "10.0.10.1"
    DNS        = "8.8.4.4 8.8.8.8"
    SEARCH     = "local.domain"
    FORWARDING = "8080:10.0.10.10:80 10.0.10.10:22"

**DNS**

This attribute expects a list of dns servers separated by spaces.

**NTP_SERVER**

This attribute expects the IP of the NTP server of the cluster. The DHCP server will be configured to serve the NTP parameter to its leases.

**FORWARDING**

This attribute expects a list of forwarding rules separated by spaces. Each rule has either 2 or 3 components separated by ``:``. If only two components are specified, the first is the IP to forward the port to, and the second is the port number. If there are three components, the first is the port in the router, the second the IP to forward to, and the third the port in the forwarded Virtual Machine. Examples:

-  ``8080:10.0.10.10:80`` This will forward the port 8080 in the router to the port 80 to the VM with IP 10.0.10.10.
-  ``10.0.10.10:22`` This will forward the port 22 in the router to the port 22 to the VM with IP 10.0.10.10.

.. |image0| image:: /images/virtualrouter.png
