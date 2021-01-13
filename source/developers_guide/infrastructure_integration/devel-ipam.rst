.. _devel-ipam:

================================================================================
IPAM driver
================================================================================

A IPAM driver lets you delegate IP lease management to an external component. This way you can coordinate IP use with other virtual or bare metal servers in your datacenter. To effectively use an external IPAM you need to develop four action scripts that hooks on different points of the IP network/lease life-cycle.

Note that OpenNebula includes a built-in internal IPAM. You need to develop this component if you are using a IPAM server and want to coordinate OpenNebula with it.


IPAM Drivers Structure
================================================================================

The main drivers are located under ``/var/lib/one/remotes/ipam/<ipam_mad>``. For an example, you can take a look to ``/var/lib/one/remotes/ipam/dummy``. This set of simple scripts can be used as an starting point to develop the integration.

register_address_range
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This action is used to register a new IP network in the IPAM. The network may be selected from a pool of free networks or if an specific network is requested its availability maybe checked by the IPAM driver. The IPAM driver must return an OpenNebula AddressRange definition, potentially augmented with network specific variables to be used by VMs (e.g. ``GATEWAY``, ``NETWORK_MASK``...)

**STDIN Argument**:

* AddressRange. The AddressRange (IP network) request in XML encoded in Base 64. The XML may contain any of the attributes used to define an AR. Note that OpenNebula uses a free format for objects so you can freely add more and process more (or less) attributes in this action. At least TYPE, IPAM_MAD and SIZE will be present:

.. code::

  <IPAM_DRIVER_ACTION_DATA>
  <AR>
    <TYPE>IP4</TYPE>
    <IP> First IP in the network in '.' notation </IP>
    <MAC> First MAC in the network in ':' notation </MAC
    <SIZE>Number of IPs in the network </SIZE>
    <NETWORK_ADDRESS> Base network address</NETWORK_ADDRESS>
    <NETWORK_MASK> Network mask</NETWORK_MASK>
    <GATEWAY> Default gateway for the network</GATEWAY>
    <DNS> DNS servers, a space separated list of servers</DNS>
    <GUEST_MTU> Sets the MTU for the NICs in this network</GUEST_MTU>
    <SEARCH_DOMAIN> for DNS client</SEARCH_DOMAIN>
  </AR>
  </IPAM_DRIVER_ACTION_DATA>

**Arguments**:

* Request ID, used internally to identify this IPAM request.

**Returns**: It should return throudh STDOUT a valid AddressRange definiton in template format. The response MUST include IPAM_MAD, TYPE, IP and SIZE attribute. For example:

* A basic network definition

.. code::

    AR = [
      IPAM_MAD = "dummy",
      TYPE = "IP4",
      IP   = "10.0.0.1",
      SIZE = "255"
    ]

* A complete network definition. Custom attributes (free form, key-value) can be added, names cannot be repeated.

.. code::

    AR = [
      IPAM_MAD = "dummy",
      TYPE = "IP4",
      IP   = "10.0.0.2",
      SIZE = "200",
      NETWORK_ADDRESS   = "10.0.0.0",
      NETWORK_MASK      = "255.255.255.0",
      GATEWAY           = "10.0.0.1",
      DNS               = "10.0.0.1",
      IPAM_ATTR         = "10.0.0.240",
      OTHER_IPAM_ATTR   = ".mydoamin.com"
    ]

unregister_address_range
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This action is used to unregister an address range from the IPAM.

**STDIN Argument**:

* AddressRange. The AddressRange in XML encoded in Base 64. The XML may contain any of the attributes used to define an AR. Note that OpenNebula uses a free format for objects so you can freely add more and process more (or less) attributes in this action. At least TYPE, IPAM_MAD and SIZE will be present:

.. code::

  <IPAM_DRIVER_ACTION_DATA>
  <AR>
    <TYPE>IP4</TYPE>
    <IP> First IP in the network in '.' notation </IP>
    <MAC> First MAC in the network in ':' notation </MAC
    <SIZE>Number of IPs in the network </SIZE>
    <NETWORK_ADDRESS> Base network address</NETWORK_ADDRESS>
    <NETWORK_MASK> Network mask</NETWORK_MASK>
    <GATEWAY> Default gateway for the network</GATEWAY>
    <DNS> DNS servers, a space separated list of servers</DNS>
    <GUEST_MTU> Sets the MTU for the NICs in this network</GUEST_MTU>
    <SEARCH_DOMAIN> for DNS client</SEARCH_DOMAIN>
  </AR>
  </IPAM_DRIVER_ACTION_DATA>

**Arguments**:

* Request ID, used internally to identify this IPAM request.

**Returns**: This scripts MUST exit 0 if no errors we found.

allocate_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This script is used to register an specific IP address (or addresses) as used. The IP (or IPs)  will be used by an OpenNebula VM and should not be allocated to any other host in the network.

**STDIN Argument**:

* AddressRange and Address. The AddressRange (IP network) and address request in XML, encoded in Base 64. The XML will contain the AR as defined by the previous action; and the address request:

.. code::

  <IPAM_DRIVER_ACTION_DATA>
  <AR>
    As returned by previous action, see above for examples.
  </AR>
  <ADDRESS>
    <IP> Requested IP address </IP>
    <SIZE> Number of IPs to allocate, in a continous range from the firs IP</SIZE>
    <MAC> Optional the MAC address </MAC>
  </ADDRESS>
  </IPAM_DRIVER_ACTION_DATA>

**Arguments**:

* Request ID, used internally to identify this IPAM request.

**Returns**: This scripts MUST exit 0 if the address is free.

get_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This script is used to lease an IP address (or addresses). The IP (or IPs)  will be used by an OpenNebula VM and should not be allocated to any other host in the network.

**STDIN Argument**:

* AddressRange and Address. The AddressRange (IP network) and address request in XML, encoded in Base 64. The XML will contain the AR as defined by the previous action; and the address request:

.. code::

  <IPAM_DRIVER_ACTION_DATA>
  <AR>
    As returned by previous action, see above for examples.
  </AR>
  <ADDRESS>
    <SIZE> Number of IPs to allocate, in a continous range from the firs IP</SIZE>
  </ADDRESS>
  </IPAM_DRIVER_ACTION_DATA>

**Arguments**:

* Request ID, used internally to identify this IPAM request.

**Returns**: This script MUST output the leased IP range as defined by the ADDRESS element in template format thourgh STOUT. For example, to lease IPs from 10.0.0.2 to 10.0.0.35 return:

.. code::

  ADDRESS = [ IP = "10.0.0.2", SIZE=34 ]

If the "size" IPs cannot be assgined the sript must return -1, otherwise it must exit 0.

free_address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This script is used to free an specific IP address (or addresses). The IP (or IPs)  are no longer in use by OpenNebula VMs or reservations.

**STDIN Argument**:

* AddressRange and Address. Same as in ``allocate_address``.

**Arguments**:

* Request ID, used internally to identify this IPAM request.

**Returns**: This scripts MUST exit 0 if the address is free.

IPAM Usage
================================================================================

To use your new IPAM module you need to:

* Place the four previous scripts in ``/var/lib/one/remotes/ipam/<ipam_mad>``.
* Activate the driver in oned.conf by adding the IPAM driver name (same as the one used to name the directory where the action scripts are stored) to the ``-i`` option of the IPAM_MAD attribure:

.. code::

    IPAM_MAD = [
        EXECUTABLE = "one_ipam",
        ARGUMENTS  = "-t 1 -i dummy, <ipam_mad>"
    ]

* You need to restart OpenNebula to load the new ipam module.
* Now, define Virtual Networks to use the IPAM. Add ``IPAM_MAD`` to the AR defintion, for example:

.. code::

  NAME = "IPAM Network"

  BRIDGE  = "br0"
  VNM_MAD = "dummy"

  AR = [
    SIZE     = 21,
    IPAM_MAD = <ipam_mad>
   ]

Any VM (or VNET reservation) from IPAM Network will contanct the IPAM using your drivers.
