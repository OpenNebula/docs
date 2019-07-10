.. _ddc_ipam_packet:

================================================================================
Packet IPAM driver
================================================================================

The IAPM driver is in charge of assigning Packet IPs to a virtual network in OpenNebula. Read :ref:`Ipam Driver <devel-ipam>` for more information about IPAM. To activate the Packet IPAM you need to do add the following to the `oned.conf`:

.. code::

    IPAM_MAD = [
        EXECUTABLE = "one_ipam",
        ARGUMENTS  = "-t 1 -i dummy,packet"
    ]

After that, you have to restart OpenNebula so the change takes effect.

.. note:: Be sure that you have all the files installed under `/var/lib/one/remotes/ipam/packet`.

Creating the address range
================================================================================

If you want to use the IPAM driver, first you need to create a virtual network. For that virtual network, you need to create an address range. There are some parameters which are compulsory:

    * **PACKET_IP_TYPE**: type of the IP, it can be public_ipv4 or global_ipv4.
    * **FACILITY**: datacenter where the IP will be reserved.
    * **PACKET_PROJECT**: Packet project where you are going to deploy the network.
    * **PACKET_TOKEN**: Packet api token.
    * **SIZE**: number of IPs you want to request.
    * **IPAM_MAD**: IPAM driver you want to use, in this case it would be packet.

.. note:: Due to a bug in OpenNebula, you need to specify an IP, altough that IP won't be used, because it will use the one returned by the IPAM.

To create the address range:

.. code::

    $ cat packet_ar
        AR = [
            PACKET_IP_TYPE = "public_ipv4",
            FACILITY       = "ams1",
            PACKET_PROJECT = "****************",
            PACKET_TOKEN   = "****************",
            SIZE           = 2,
            IPAM_MAD       = "packet",
            TYPE           = IP4,
            IP             = "1.1.1.1"
        ]

    $ onevnet addar <vnetid> --file packet_ar
