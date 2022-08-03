.. _service_vnf:

==================================================
Virtual Network Functions (VNF) and Virtual Router
==================================================

OpenNebula Marketplace Appliance implementing various **Virtual Network Functions** (VNFs) and `Virtual Router <https://docs.opennebula.io/stable/management_and_operations/network_management/vrouter.html>`_.

.. note::

    This appliance replaces the Virtual Routers available on the Marketplace in the past as **Vrouter Alpine** for KVM and vCenter platforms. These old versions are referenced as **legacy** from now on. Templates and contextualization parameters are compatible with new appliance, you only need to update the reference in the old imported template to the new image. It's highly recommended to migrate to the new appliance.

    To meet different use-cases, the core logic is provided by 2 appliances (sharing the same image) and listed on the Marketplace as

    * `Service VNF <https://marketplace.opennebula.io/appliance/7dba6a0d-73e8-4036-9cb8-73da669ee494>`__ - exposing all features as regular VM
    * `Service Virtual Router <https://marketplace.opennebula.io/appliance/cc96d537-f6c7-499f-83f1-15ac4058750e>`__ - integration with OpenNebula Virtual Router interface

.. include:: shared/features-alpine.txt
* High-availability provided by `Keepalived <https://www.keepalived.org/>`_.
* **Network Functions**

  * :ref:`DHCPv4 <vnf_dhcp4_context_param>`
  * :ref:`DNS recursor <vnf_dns_context_param>`
  * :ref:`IPv4 Network Address Translation <vnf_nat4_context_param>`
  * :ref:`Virtual Networks Mapping via SNAT/DNAT <vnf_sdnat4_context_param>`
  * :ref:`LoadBalancer <vnf_lb_context_param>`
  * Virtual Router (:ref:`VR <vnf_vrouter_context_param>`, :ref:`VM <vnf_router4_context_param>`)

Platform Notes
==============

Component versions
------------------

============================= ==================
Component                     Version
============================= ==================
ISC Kea                       1.8.2
ISC Kea MAC to IPv4 hook      1.1.1
Contextualization package     6.2.0
============================= ==================

.. _service_vnf_quick_start:

Quick Start
===========

.. include:: shared/import.txt
.. include:: shared/update.txt
.. include:: shared/run.txt

The initial configuration can be customized with :ref:`contextualization <vnf_context_param>` parameters:

|image-context-vars|

.. note::

    **No VNF services are started by default**, you always need to select and enable those you require to run. This can be done right on VM instantiation or later (both to enable or disable) via the live VM update operations (in Sunstone in VM details do **Conf → Update Configuration** or use CLI command ``onevm updateconf``).

After you are done, click on the button **Instantiate**. Virtual machine with running service(s) should be ready in a few minutes.

.. include:: shared/report.txt

.. code::

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

    localhost:~# cat /etc/one-appliance/config
    [VNF]
    ONEAPP_VNF_DHCP4_ENABLED = 'YES'
    ONEAPP_VNF_DHCP4_INTERFACES_DISABLED = 'ETH0'
    ONEAPP_VNF_DHCP4_LEASE_TIME = '3600'
    ONEAPP_VNF_DNS_ENABLED = 'YES'
    ONEAPP_VNF_DNS_INTERFACES_DISABLED = 'ETH0'
    ONEAPP_VNF_DNS_MAX_CACHE_TTL = '3600'
    ONEAPP_VNF_DNS_USE_ROOTSERVERS = 'YES'
    ONEAPP_VNF_NAT4_ENABLED = 'YES'
    ONEAPP_VNF_NAT4_INTERFACES_OUT = 'ETH0'
    ONEAPP_VNF_ROUTER4_ENABLED = 'YES'
    ONEAPP_VROUTER_ETH0_DNS = '10.0.0.2'
    ONEAPP_VROUTER_ETH0_GATEWAY = '192.168.150.1'
    ONEAPP_VROUTER_ETH0_IP = '192.168.150.102'
    ONEAPP_VROUTER_ETH0_MAC = '02:00:c0:a8:96:66'
    ONEAPP_VROUTER_ETH1_DNS = '192.168.101.1'
    ONEAPP_VROUTER_ETH1_GATEWAY = '192.168.101.1'
    ONEAPP_VROUTER_ETH1_IP = '192.168.101.1'
    ONEAPP_VROUTER_ETH1_MAC = '02:00:c0:a8:65:01'
    ONEAPP_VROUTER_ETH1_MASK = '255.255.255.0'
    ONEAPP_VROUTER_ETH2_DNS = '192.168.102.1'
    ONEAPP_VROUTER_ETH2_GATEWAY = '192.168.102.1'
    ONEAPP_VROUTER_ETH2_IP = '192.168.102.1'
    ONEAPP_VROUTER_ETH2_MAC = '02:00:c0:a8:66:01'
    ONEAPP_VROUTER_ETH2_MASK = '255.255.255.0'


.. _vnf_context_param:

Contextualization
=================

Contextualization parameters provided in the Virtual Machine template controls the initial VM configuration. Except for the `common set <https://docs.opennebula.io/stable/management_and_operations/references/template.html#context-section>`_ of parameters supported by every appliance on the OpenNebula Marketplace, there are few specific to the particular service appliance. The parameters should be provided in the ``CONTEXT`` section of the Virtual Machine template, read the OpenNebula `Management and Operations Guide <https://docs.opennebula.io/stable/management_and_operations/references/kvm_contextualization.html#set-up-the-virtual-machine-template>`__ for more details.

.. note::

    As described in the :ref:`Overview <service_vnf>`, there are 2 appliances available. Both share the same image and support the same set of contextualization parameters, the only difference is how they are managed in the OpenNebula - via Virtual Router (VR) interface or as regular Virtual Machine (VM).

If parameters support multiple values, the values can be are separated by spaces (``x y``), commas (``x,y``), or semicolons (``;``).

.. _vnfs_context_param:

Virtual Network Functions
-------------------------

Following parameters are supported in both deployment modes, as Virtual Machine (VM) and Virtual Router (VR).

.. _vnf_dhcp4_context_param:

Function DHCP4
~~~~~~~~~~~~~~

The function implements DHCPv4 service. If enabled without any specific configuration, it provides DHCP leases for all (non-management) interfaces and all their configured subnets.

**Basic parameters**:

============================================ ============== ===========
Parameter                                    Default        Description
============================================ ============== ===========
``ONEAPP_VNF_DHCP4_ENABLED``                 ``NO``         Enable/disable DHCP4 function (``YES``/``NO``)
``ONEAPP_VNF_DHCP4_INTERFACES``              all ifaces     List of :ref:`interfaces <vnf_interfaces>` to listen on (``<[!]ethX> ...``)
``ONEAPP_VNF_DHCP4_AUTHORITATIVE``           ``YES``        Server authoritativity (``YES``/``NO``)
``ONEAPP_VNF_DHCP4_LEASE_TIME``              ``3600``       DHCP lease time (seconds)
``ONEAPP_VNF_DHCP4_DNS``                                    Default nameservers (IP address)
``ONEAPP_VNF_DHCP4_GATEWAY``                                Default gateway (IP address)
``ONEAPP_VNF_DHCP4_MAC2IP_ENABLED``          ``YES``        Enable/disable MAC-to-IP translation (``YES``/``NO``)
``ONEAPP_VNF_DHCP4_MAC2IP_MACPREFIX``        ``02:00``      2-bytes OpenNebula MAC prefix for MAC-to-IP trans.
============================================ ============== ===========

**Advanced parameters:**

============================================ ============== ===========
Parameter                                    Default        Description
============================================ ============== ===========
``ONEAPP_VNF_DHCP4_ETHx``                                   Custom interface subnet/pool range (``<CIDR>:<start IP>-<end IP>``)
``ONEAPP_VNF_DHCP4_ETHx_DNS``                               Custom interface pool DNS (``<IP> ...``)
``ONEAPP_VNF_DHCP4_ETHx_GATEWAY``                           Custom interface pool gateway (``<IP> ...``)
``ONEAPP_VNF_DHCP4_ETHx_MTU``                               CUstom interface pool MTU option (number)
``ONEAPP_VNF_DHCP4_ETHx_ALIASy``                            Custom alias interface sub./pool range (``<CIDR>:<start IP>-<end IP>``)
``ONEAPP_VNF_DHCP4_ETHx_ALIASy_DNS``                        Custom alias interface pool DNS (``<IP> ...``)
``ONEAPP_VNF_DHCP4_ETHx_ALIASy_GATEWAY``                    Custom alias interface pool gateway (``<IP> ...``)
``ONEAPP_VNF_DHCP4_ETHx_ALIASy_MTU``                        Custom alias interface pool MTU (number)
``ONEAPP_VNF_DHCP4_MAC2IP_SUBNETS``                         List of subnets for MAC-to-IP transl. (``<network>/<prefix> ...``)
``ONEAPP_VNF_DHCP4_CONFIG``                                 ISC Kea configuration (JSON Base64 encoded)
``ONEAPP_VNF_DHCP4_SUBNET[0-9]``                            ISC Kea subnet definition (JSON Base64 encoded)
``ONEAPP_VNF_DHCP4_HOOK[0-9]``                              ISC Kea hook definition (JSON Base64 encoded)
``ONEAPP_VNF_DHCP4_LEASE_DATABASE``                         ISC Kea database definition (JSON Base64 encoded)
============================================ ============== ===========

.. important::

   Virtual Routers interface in the OpenNebula doesn't support managing `Network Interface Aliases <https://docs.opennebula.io/stable/management_and_operations/vm_management/vm_templates.html#network-interfaces-alias>`_. Aliases can be used only when the appliance is used as a regular Virtual Machine.

For more information continue to :ref:`DHCP4 <vnf_dhcp4>` VNF documentation.

.. _vnf_dns_context_param:

Function DNS
~~~~~~~~~~~~

The function implements DNS service. It can delegate requests to upstream servers based on network contextualization or directly resolve requests on its own.

**Basic parameters**:

=====================================  ============== ===========
Parameter                              Default        Description
=====================================  ============== ===========
``ONEAPP_VNF_DNS_ENABLED``             ``NO``         Enable/disable DNS function (``YES``/``NO``)
``ONEAPP_VNF_DNS_INTERFACES``          all ifaces     List of :ref:`interfaces <vnf_interfaces>` to listen on (``<[!]ethX> ...``
``ONEAPP_VNF_DNS_MAX_CACHE_TTL``       ``3600``       Maximum caching time (seconds)
``ONEAPP_VNF_DNS_USE_ROOTSERVERS``     ``YES``        Use root name servers directly (``YES``/``NO``)
``ONEAPP_VNF_DNS_NAMESERVERS``                        List of upstream NSs to forward queries to (``<IP>[@<PORT>] ...``)
``ONEAPP_VNF_DNS_UPSTREAM_TIMEOUT``    ``1128``       Upstream NS connection timeout (milliseconds)
=====================================  ============== ===========

**Advanced parameters:**

=====================================  ============== ===========
Advanced parameter                     Default        Description
=====================================  ============== ===========
``ONEAPP_VNF_DNS_CONFIG``                             Unbound server configuration (Base64 encoded)
``ONEAPP_VNF_DNS_ALLOWED_NETWORKS``                   Client networks from which is allowed to make queries (``<network>/<prefix> ...``)
``ONEAPP_VNF_DNS_TCP_DISABLED``        ``NO``         Enable/disable service over TCP (``YES``/``NO``)
``ONEAPP_VNF_DNS_UDP_DISABLED``        ``NO``         Enable/disable service over UDP (``YES``/``NO``)
=====================================  ============== ===========

For more information continue to :ref:`DNS <vnf_dns>` VNF documentation.

.. _vnf_nat4_context_param:

Function NAT4
~~~~~~~~~~~~~

The function implements IPv4 Network Address Translation (Masquerade) service for the attached interfaces (except management), through the specified outgoing interface(s).

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``ONEAPP_VNF_NAT4_ENABLED``           ``NO``         Enable/disable NAT function (``YES``/``NO``)
``ONEAPP_VNF_NAT4_INTERFACES_OUT``     none          **Mandatory:** Outgoing :ref:`interface(s) <vnf_interfaces>` for NAT (``<[!]ethX> ...``)
===================================== ============== ===========

For more information continue to :ref:`NAT4 <vnf_nat4>` VNF documentation.

.. _vnf_sdnat4_context_param:

Function SDNAT4 (Virtual Networks Mapping)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The function implements mapping of IPv4 addresses among virtual networks available through the attached interfaces (except management) via SNAT and DNAT mechanism.

======================================= ============== ===========
Parameter                               Default        Description
======================================= ============== ===========
``ONEAPP_VNF_SDNAT4_ENABLED``           ``NO``         Enable/disable SNAT/DNAT function (``YES``/``NO``)
``ONEAPP_VNF_SDNAT4_INTERFACES``        none           **Mandatory:** List of :ref:`interfaces <vnf_interfaces>` among which to detect mappings (``<[!]ethX> ...``)
``ONEAPP_VNF_SDNAT4_REFRESH_RATE``      ``30``         Refresh rate between updates of the mapping rules (in seconds)
======================================= ============== ===========

.. include:: shared/vnf_sdnat4_req.txt

For more information continue to :ref:`SDNAT4 <vnf_sdnat4>` VNF documentation.

.. _vnf_router4_context_param:

Function ROUTER4
~~~~~~~~~~~~~~~~

The function implements routing among connected network interfaces.

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``ONEAPP_VNF_ROUTER4_ENABLED``        ``NO``         Enable/disable Router function (``YES``/``NO``)
``ONEAPP_VNF_ROUTER4_INTERFACES``     all ifaces     List of routed :ref:`interfaces <vnf_interfaces>` (``<[!]ethX> ...``)
===================================== ============== ===========

For more information continue to :ref:`Router4 <vnf_router4>` VNF documentation.

.. _vnf_lb_context_param:

Function LB (LoadBalancer)
~~~~~~~~~~~~~~~~~~~~~~~~~~

The function provides LoadBalancer service which for defined incoming connections will forward and load balance the traffic to the pool of static and/or dynamic real servers (backends) per LB.

**Generic parameters**:

(These will affect all configured loadbalancers.)

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``ONEAPP_VNF_LB_ENABLED``             ``NO``         Enable/disable LB function (``YES``/``NO``)
``ONEAPP_VNF_LB_ONEGATE_ENABLED``     ``NO``         Enable/disable dynamic real servers via OneGate (``YES``/``NO``)
``ONEAPP_VNF_LB_REFRESH_RATE``        ``30``         Refresh rate between updates of the pool of real servers (in seconds)
``ONEAPP_VNF_LB_FWMARK_OFFSET``       ``10000``      Default starting firewall mark for LVS/IPVS
``ONEAPP_VNF_LB_CONFIG`` [*]_         none           Individual LB config(s) (BASE64 encoded JSONs separated by commas)
===================================== ============== ===========

.. [*] If used then the rest of LB params or static real server params are ignored (those suffixed with ``[0-9]``) - dynamic real server params will still be applied.

**Per LB parameters**:

(These will define a loadbalancer - ignored if ``ONEAPP_VNF_LB_CONFIG`` is utilized.)

===================================== ============== ===========
LB Parameter                          Default        Description
===================================== ============== ===========
``ONEAPP_VNF_LB[0-9]_IP`` [*]_        none           Load balanced IP address (required)
``ONEAPP_VNF_LB[0-9]_PORT``           empty          IP port to specify connection (optional)
``ONEAPP_VNF_LB[0-9]_PROTOCOL``       empty          IP protocol to specify connection (optional - ``TCP``, ``UDP`` or ``BOTH``)
``ONEAPP_VNF_LB[0-9]_METHOD`` [*]_    ``NAT``        LVS/IPVS method (``NAT`` or ``DR`` - Direct Routing)
``ONEAPP_VNF_LB[0-9]_TIMEOUT``        ``10``         Tolerated timeout of any real server for this LB (in seconds)
``ONEAPP_VNF_LB[0-9]_SCHEDULER``      ipvs default   LVS/IPVS scheduler (default is ``wlc`` [*]_)
===================================== ============== ===========

.. [*] If only the address is specified (both port and protocol is skipped) then all traffic on this load balanced IP will be forwarded on 1:1 basis to the real servers.
.. [*] The Direct-Routing method will require additional steps on real servers for this setup to work - described in the separate :ref:`VNF LB section <vnf_lb_direct_routing>`.
.. [*] Consult ``man ipvsadm`` to find out more about schedulers (other useful value can be ``rr`` - round robin)

**Per real server parameters (STATIC)**:

(These will define a **static** real server for the designated LB - ignored if ``ONEAPP_VNF_LB_CONFIG`` is utilized..)

============================================== ============== ===========
Static RS Parameter                            Default        Description
============================================== ============== ===========
``ONEAPP_VNF_LB[0-9]_SERVER[0-9]_HOST``        none           Real server address (IP or hostname - required)
``ONEAPP_VNF_LB[0-9]_SERVER[0-9]_PORT``        none           Real server port (required if LB has port defined too)
``ONEAPP_VNF_LB[0-9]_SERVER[0-9]_WEIGHT``      ipvs default   Real server weight (optional)
``ONEAPP_VNF_LB[0-9]_SERVER[0-9]_ULIMIT``      ipvs default   Real server upper limit on connections (optional)
``ONEAPP_VNF_LB[0-9]_SERVER[0-9]_LLIMIT``      ipvs default   Real server lower limit on connections (optional)
============================================== ============== ===========

.. note::

    LoadBalancer service also supports :ref:`dynamic real servers <vnf_lb_dynamic_rs>` propagated via OneGate.

For more information continue to :ref:`LB <vnf_lb>` VNF documentation.

.. _vnf_vrouter_context_param:

OpenNebula Virtual Router
-------------------------

The function implements another routing mechanism among connected networks but integrated with `OpenNebula Virtual Router <https://docs.opennebula.io/stable/management_and_operations/network_management/vrouter.html>`_ interface. In addition to all contextualization parameters above, the VNF appliance recognizes also the following variables passed by the OpenNebula when running over Virtual Router (VR) interface.

.. _vnf_legacy_vrouter_context_param:

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``VROUTER_KEEPALIVED_ID``             ``1``          Global VR ID (1-255)
``VROUTER_KEEPALIVED_PASSWORD``       (empty)        Global VR password (max 8 characters)
``ETHx_VROUTER_IP``                   (empty)        Floating IPv4 (VIP) for ethX
``ETHx_VROUTER_MANAGEMENT``           ``NO``         Set ethX a management interface (``YES``/``NO``)
===================================== ============== ===========

.. important::

    No VNFs, routing or Keepalived services are ever started on **management interfaces** (``ETHx_VROUTER_MANAGEMENT``) except the default SSH server.

.. _vnf_new_vrouter_context_param:

**Additional parameters** (not automatically set by OpenNebula):

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``ONEAPP_VROUTER_ETHx_VIP<0-9>``      (empty)        Extra floating IPv4 (VIPs) for ethX
===================================== ============== ===========

.. note::

    ``ONEAPP_VROUTER_ETHx_VIP<0-9>`` **must always have index** in suffix, e.g. ``ONEAPP_VROUTER_ETH0_VIP0`` or ``ONEAPP_VROUTER_ETH0_VIP1``.

.. _vnf_keepalived_context_param:

Keepalived
----------

`Keepalived <https://www.keepalived.org/>`_ is an open-source project implementing `VRRP protocol <https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol>`_ and a pre-installed appliance service which provides high-availability to other VNFs running on the instance. It's not a self-contained and directly usable service. In case of incident it's able to migrate the floating IP (VIP) addresses and services to another instance with as little downtime as possible.

.. note::

    OpenNebula Virtual Router interface transparently integrates with the Keepalived function to provide high-availability when multiple router instances are started. When running appliances as Virtual Router (controlled over VR specific :ref:`context parameters <vnf_legacy_vrouter_context_param>`), it's not necessary to directly deal with the following context parameters.

.. important::

    You need to have at least **one VNF** enabled and at least **one floating IP** (VIP) configured.

**Basic parameters**:

===================================== ============== ===========
Parameter                             Default        Description
===================================== ============== ===========
``ONEAPP_VNF_KEEPALIVED_ENABLED``     ``NO``         Enable/disable Keepalived function (``YES``/``NO``)
``ONEAPP_VNF_KEEPALIVED_INTERFACES``  all ifaces     List of managed :ref:`interfaces <vnf_interfaces>` (``<[!]ethX> ...``)
``ONEAPP_VNF_KEEPALIVED_PASSWORD``    (empty)        Global VR password (max 8 characters)
``ONEAPP_VNF_KEEPALIVED_PRIORITY``    ``100``        Global VR numerical priority
``ONEAPP_VNF_KEEPALIVED_VRID``        ``1``          Global VR ID (1-255)
``ONEAPP_VNF_KEEPALIVED_INTERVAL``    ``1``          Global advertising interval (seconds)
===================================== ============== ===========

**Advanced parameters:**

========================================== ============== ===========
Parameter                                  Default        Description
========================================== ============== ===========
``ONEAPP_VNF_KEEPALIVED_ETHx_PASSWORD``    (empty)        VR password for ethX (max 8 characters)
``ONEAPP_VNF_KEEPALIVED_ETHx_PRIORITY``    ``100``        VR numerical priority for ethX
``ONEAPP_VNF_KEEPALIVED_ETHx_VRID``        ``1``          VR ID for ethX (1-255)
``ONEAPP_VNF_KEEPALIVED_ETHx_INTERVAL``    ``1``          Advertising interval for ethX (seconds)
========================================== ============== ===========

The fundamental part is the floating IP address (VIP), which must be always configured otherwise function won't work. Also, the function must be provided with **Virtual Router ID** (``VRID``) unique for the subnets instance runs on (otherwise different VRs with same ``VRID`` could try to join into the single same cluster and both fail terribly)!

.. warning::

    **Known Issue:** Multiple quick consecutive reconfigurations of VM/VR (e.g., hot-attaching several NICs) without a proper delay might break a Keepalived cluster! You should always wait and verify that the instance is in the desired state after each change.

.. _vnf_interfaces:

Interfaces
----------

Each VNF has **interface** context parameter which defines on which network interfaces the service is or isn't active. If no interfaces context variable is provided (or is empty), the enabled VNF is listening on all available interfaces (except loopback ``lo`` and :ref:`OpenNebula Virtual Router <vnf_legacy_vrouter_context_param>` management interfaces).

.. note::

   **NAT4 VNF**: A special case is NAT4 VNF, which uses a context parameter ``ONEAPP_VNF_NAT4_INTERFACES_OUT`` (with ``_OUT`` suffix) to emphasize the actual place where the network address translation will happen (outgoing/external interface). This parameter doesn't provide any default. If it's not specified, NAT4 won't select any outgoing interface automatically and service won't behave. For NAT4 the parameter ``ONEAPP_VNF_NAT4_INTERFACES_OUT`` is **always mandatory**.

   This applies similarly to the ``ONEAPP_VNF_SDNAT4_INTERFACES`` which also defaults to none.

The listed interface names must follow the naming of the interfaces in the OpenNebula (see `context parameters <https://docs.opennebula.io/stable/management_and_operations/references/template.html#context-section>`__). Always use ``eth`` interface names followed by an index starting from 0, i.e. ``eth0`` for first NIC, ``eth4`` for fifth NIC. The real interface names inside the running VR/VM might differ - have different prefixes (e.g., ``enoX``, ``ensX``, ``enpXsY``) following Consistent Network Device Naming or even different interface index(!). Appliance scripts **automatically translate OpenNebula interface names from context names into real instance names**.

Extra interfaces specified in context variables, but missing in the instance, are **ignored**.

Example: To enable :ref:`DNS VNF <vnf_dns_context_param>` only on 3rd and 4th network interfaces, set the corresponding context parameter and its value as follows. If the instance wouldn't have these interfaces (but only first two, i.e. ``eth0`` and ``eth``), the DNS VNF would not run on any interface.

.. code::

    ONEAPP_VNF_DNS_INTERFACES="eth2 eth3"

.. note::

   You can separate interfaces by spaces (``"eth2 eth3"``), commas (``"eth2,eth3"``) or semicolons (``"eth2;eth3"``).

Exclude Interfaces
~~~~~~~~~~~~~~~~~~

To disable VNF on a particular interface, you can use one of the following syntaxes:

* **include**: name all interfaces where service should be enabled and skip the disabled interface(s)
* **exclude**: prefix disabled interface(s) with ``!`` (e.g, ``!eth0``), rest available interfaces will be included automatically

Example: To disable :ref:`DHCP4 VNF <vnf_dhcp4_context_param>` on 3rd (i.e., ``eth2``) from 5 interfaces, use any of the following styles:

.. code::

    ONEAPP_VNF_DHCP4_INTERFACES="eth0 eth1 eth3 eth4"
      or
    ONEAPP_VNF_DHCP4_INTERFACES="!eth2"

.. important::

   Mixing **include** and **exclude** syntaxes within a single parameter is conflicting and must be avoided (e.g., ``!eth0 eth1 eth2``). The semantic of exclude syntax is to automatically include all the rest available interfaces (except those excluded). If both syntaxes are still used, the include syntax has higher priority and excluded interfaces are not respected.

.. _vnf_list:

Network Functions
=================

.. _vnf_dhcp4:

DHCP4
-----

See: :ref:`Contextualization Parameters <vnf_dhcp4_context_param>`

The VNF provides *Dynamic Host Configuration Protocol* (DHCPv4) service implemented by the `ISC Kea <https://www.isc.org/kea/>`_ software suite.

.. warning::

    Be careful and always specify interfaces the DHCP service should operate on as you could negatively affect the availability of other the devices and services running on the connected networks!

Enabled service without any other context parameters will run DHCP on all interfaces and their subnets. The context parameter ``ONEAPP_VNF_DHCP4_INTERFACES`` limits the functionality on particular interfaces. Firstly, it tells on which interface it will listen for DHCP requests. Secondly, it will determine for which subnets it will provide leases - it will auto-generate subnet lease configuration (if no ``ONEAPP_VNF_DHCP4_SUBNET[0-9]`` are provided).

The format of values in ``ONEAPP_VNF_DHCP4_INTERFACES`` can be

* ``ethX`` - interface name (e.g., ``eth0``)
* ``ethX/IP`` - interface name with IP address to pinpoint the listening address and subnet creation in case more than one IP address is assigned to the interface (e.g., ``eth0/192.168.1.1``)

Service by default provides configuration to the remote DHCP clients based on IP configuration of interfaces on which it's enabled via ``ONEAPP_VNF_DHCP4_INTERFACES``. Interfaces configuration is taken from static network `contextualization parameters <https://docs.opennebula.io/stable/management_and_operations/references/template.html#context-section>`__ (e.g., ``ETH0_GATEWAY``), not from the run-time configuration of the particular interfaces on the instance. Settings can be overridden by similarly named DHCP VNF specific contextualization parameters per NIC or NIC alias, e.g.:

.. code::

    CONTEXT=[
        ONEAPP_VNF_DHCP4_ETHx="<CIDR>:<start IP>-<end IP>",
        ONEAPP_VNF_DHCP4_ETHx_DNS="<IP> ...",
        ONEAPP_VNF_DHCP4_ETHx_GATEWAY="<IP> ...",
        ONEAPP_VNF_DHCP4_ETHx_MTU="<number>",
        ONEAPP_VNF_DHCP4_ETHx_ALIASy="<CIDR>:<start IP>-<end IP>",
        ONEAPP_VNF_DHCP4_ETHx_ALIASy_DNS="<IP> ...",
        ONEAPP_VNF_DHCP4_ETHx_ALIASy_GATEWAY="<IP> ...",
        ONEAPP_VNF_DHCP4_ETHx_ALIASy_MTU="<number>",
        ...
    ]

The context parameters for NIC aliases are applied only if the **subnet of NIC alias is unique** (i.e., no other interface uses the same subnet). Otherwise particular NIC alias configuration is ignored. Contextualization of main (non-aliased) interfaces always takes a priority over NIC aliases for the same subnet.

.. note::

    **Example:** Having VM NICs network parameters provided by OpenNebula contextualization

    * ``eth0``: ``192.168.0.1/255.255.0.0``
    * ``eth0`` alias 0: ``192.168.1.100/255.255.0.0``

    with following overrides within DHCP4 VNF:

    .. code::

        CONTEXT=[
             ONEAPP_VNF_DHCP4_ETH0_DNS="8.8.8.8",
             ONEAPP_VNF_DHCP4_ETH0_ALIAS0_DNS="4.4.4.4",
             ONEAPP_VNF_DHCP4_ETH0_ALIAS0="192.168.0.0/16:192.168.100.100-192.168.200.250",
             ...
        ]

    In this case both the ``eth0`` and its alias share the same subnet, but with two different overrides for nameserver option data and subnet pool (default vs. explicitly defined one). And so when VNF tries to create a DHCP4 configuration it encounters a conflict between the subnet pools and the option data (``DNS``, ``GATEWAY``, and ``MTU``) of the two. That is why the interface variables (``ONEAPP_VNF_DHCP4_ETH0``) will **always** take precedence in such scenarios (all ``ONEAPP_VNF_DHCP4_ETH0_ALIAS0`` will be ignored).

    For illustration the example of a generated configuration for the `ISC Kea <https://www.isc.org/kea/>`_ of the case above:

    .. code::

        ...
        "subnet4": [
        {
          "subnet": "192.168.0.0/16",
          "pools": [ { "pool": "192.168.0.2-192.168.255.254" } ],
          "option-data": [
            { "name": "domain-name-servers", "data": "8.8.8.8" },
            { "name": "routers", "data": "192.168.0.1" }
          ],
          "reservations": [
            { "flex-id": "'DO-NOT-LEASE-192.168.101.1'", "ip-address": "192.168.0.1" },
            { "flex-id": "'DO-NOT-LEASE-192.168.101.100'", "ip-address": "192.168.1.100" }
          ],
          "reservation-mode": "all"
        },
        ...

For more tailored subnet configuration, you can use ``ONEAPP_VNF_DHCP4_SUBNET`` context variable(s) with **raw configuration** which is directly passed to the DHCP server and the value must be a valid Base64 encoded JSON configuration of `ISC Kea subnet4 section <https://kea.readthedocs.io/en/latest/arm/dhcp4-srv.html#configuration-of-ipv4-address-pools>`_. More subnet configuration variables can be specified and they must be suffixed with numerical index (e.g., ``ONEAPP_VNF_DHCP4_SUBNET0``). Subnets defined by these subnet context parameters always **take precedence** over other interface-specific parameters (i.e., the existence of ``ONEAPP_VNF_DHCP4_SUBNET`` disables any contextualization based on interface configuration). Subnet definitions **must be unique**, although it's possible to have overlapping subnets - in such (or other non-trivial) setup consult the `ISC Kea documentation <https://kea.readthedocs.io/en/latest/arm/dhcp4-srv.html>`_ to better understand how DHCP lease will work.

.. warning::

   The appliance allows (live) **reconfiguration** and adapts to the changes in context parameters as they happen. The known issue of this process is that some variables defined in the past might still remain active if they are removed! E.g., a problem could arise if ``ONEAPP_VNF_DHCP4_SUBNET``-like variable was defined, but now you wish to use dynamic per-interface variables instead (``ONEAPP_VNF_DHCP4_ETHx``-like), remove the former variable, but it still remains in the appliance configuration to a certain extent. A workaround is not to remove an old variable, but instead provide the empty content, e.g. ``ONEAPP_VNF_DHCP4_SUBNET0=""``.

   **IMPORTANT:** It's recommended not to delete once used context variables, but set their content to empty string. You can remove them safely after the next full recontextualization (or reboot).

To have full control over the DHCP4 VNF, you can provide the complete ISC Kea configuration via ``ONEAPP_VNF_DHCP4_CONFIG`` contextualization parameter. It must be a valid Base64 encoded JSON configuration file following the `documentation <https://kea.readthedocs.io/en/latest/arm/dhcp4-srv.html>`_ and as required by the ISC Kea service.

OpenNebula MAC to IPv4 Translation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the OpenNebula, there is a clear relation between MAC (Hardware) and IPv4 addresses allocated for the Virtual Machine NICs. The MAC address for particular NIC is constructed as a concatenation of

- ``02:00`` (default) prefix followed by
- hexadecimal representation of the allocated IPv4 address ``01:02:03:04`` (e.g., for ``1.2.3.4``)

The leading prefix can be configured in OpenNebula via ``MAC_PREFIX`` option in `oned.conf <https://docs.opennebula.io/stable/installation_and_configuration/opennebula_services/oned.html#virtual-networks>`_ (but then must be aligned with prefix configured for DHCP4 VNF via ``ONEAPP_VNF_DHCP4_MAC2IP_MACPREFIX``)

The DHCP4 VNF comes with a **translation hook** (custom DHCP server plugin), which computes and offers suitable IPv4 addresses just based on the MAC address the same way as the OpenNebula does. It ensures that VM gets same IPv4 addresses via dynamic configuration (DHCP) as it would get through static contextualization (i.e., parameters on contextualization CD-ROM/service). This allows networking to unmodified VMs, which are not aware of the OpenNebula static contextualization.

.. note::

    The OpenNebula `MAC to IP translation <https://github.com/OpenNebula/addon-kea-hooks>`_ hook for ISC Kea works completely offline, without the need to directly query the OpenNebula front-end. It's enabled by default and can be disabled via context parameter ``ONEAPP_VNF_DHCP4_MAC2IP_ENABLED="NO"``.

Translation hook can be restricted to work only on selected subnets via ``ONEAPP_VNF_DHCP4_MAC2IP_SUBNETS`` parameter, which accepts a list of ranges in CIDR notation. For all the rest subnets and pools not covered in this parameter, the normal ISC Kea's lease behavior is applied. Missing or empty parameter defaults to translation hook work on all subnets.

.. important::

   On subnets managed by OpenNebula MAC to IP translation hook (by default all), the requests from MAC addresses which **can't be converted to the suitable IP address are ignored**!

If DHCP VNF is provided to both OpenNebula (via MAC to IP) and custom addressed clients, it must be either set ``ONEAPP_VNF_DHCP4_MAC2IP_SUBNETS`` or translation hook disabled completely (``ONEAPP_VNF_DHCP4_MAC2IP_ENABLED="NO"``). Otherwise, you could encounter issues with failed DHCP requests for all non-OpenNebula addressed DHCP clients.

.. _vnf_nat4:

NAT4
----

See: :ref:`Contextualization Parameters <vnf_nat4_context_param>`

The VNF provides **IPv4 Network Address Translation** (Masquerade) to connected interfaces over a specific outgoing interface. The outgoing interface **always must be set** in ``ONEAPP_VNF_NAT4_INTERFACES_OUT``, the default is an empty list and with an empty list the function won't run even if it's enabled. This differs from how other functions deal with interface lists (where default empty list means all interfaces).

.. _vnf_sdnat4:

SDNAT4 (Virtual Networks Mapping)
---------------------------------

See: :ref:`Contextualization Parameters <vnf_sdnat4_context_param>`

This VNF provides the **Virtual Networks Mapping** feature, which allows to transparently deliver traffic targetting an IP address (e.g., public) from one network to a device in a different network (e.g., private) without any need to directly expose the device to the first network. This eventually results in **mapping** between those 2 IP addresses from different networks. Such mapping is established on the Virtual Router where all related networks need to be connected, and by attaching the foreign mapped IP address to the VM as **external NIC alias**.

.. note::

    This VNF is similar to the :ref:`NAT4 <vnf_nat4>` function as it's implemented by two-way NAT - **SNAT (Source NAT)** and **DNAT (Destination NAT)**. The short function name ``SDNAT4`` is a composition of these mechanisms used underneath.

The interfaces on Virtual Router among which the mapping can be established **must be always specified** via context parameter ``ONEAPP_VNF_SDNAT4_INTERFACES``, otherwise, no rules will be applied (this differs from how other functions deal with interface lists, where default empty list means all interfaces).

.. include:: shared/vnf_sdnat4_req.txt

Once the interface list is provided to the VNF, the service deployed inside the Virtual Router starts to monitor OpenNebula via OneGate for changes to the IP address allocations. Esp., to the **external NIC aliases assigned** to any VM on any of virtual networks connected to the Virtual Router instance. Based on the aggregated data, it builds a list of pairs for SNAT/DNAT where the destination part is the IP address of the external NIC alias and the source part is the real IP address assigned to the VM we try to reach.

.. note::

    OpenNebula supports 2 types of NIC aliases.

    - **internal** - the IP addresses directly configured inside the VM as additional IP addresses on the network interfaces. The virtual machine is directly reachable over the internal NIC alias address. Internal NIC aliases are natively supported and documented in the `CLI and GUI Sunstone <https://docs.opennebula.io/stable/management_and_operations/vm_management/vm_templates.html#network-interfaces-alias>`__.

    Example of VM with several internal NIC aliases configured on ``eth0`` NIC:

    .. code::

        # ip address show dev eth0
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
            link/ether 02:00:c0:a8:02:0e brd ff:ff:ff:ff:ff:ff
            inet 192.168.2.14/24 brd 192.168.2.255 scope global eth0
               valid_lft forever preferred_lft forever
            inet 192.168.2.15/24 brd 192.168.2.255 scope global secondary eth0
               valid_lft forever preferred_lft forever
            inet 192.168.2.16/24 brd 192.168.2.255 scope global secondary eth0
               valid_lft forever preferred_lft forever
            inet 192.168.2.17/24 brd 192.168.2.255 scope global secondary eth0
               valid_lft forever preferred_lft forever
            inet6 fe80::c0ff:fea8:20e/64 scope link
               valid_lft forever preferred_lft forever

    - **external** - the additional IP addresses **are not configured inside the VM**, but "some" external logic outside the VM ensures that the traffic designated for such IP address is routed to the primary IP address of VM. This requires the external mechanism to implement them, they are specific for some deployment types (e.g., when running on 3rd party's managed infrastructures), and therefore are not well documented and proposed. Virtual Networks Mapping function in the Virtual Router is the first example of general-purpose external logic, which supports the external NIC aliases. You can find examples of usage below.

    Virtual Networks Mapping relies on using **external NIC aliases**, the second case!

To hot-attach an **external NIC alias** to the existing VM, we must use CLI tools and pass a template file (e.g.: ``external-nic-alias.tmpl``) with content similar to the one below (network name, ID and NIC must be adapted to your use-case):

.. code::

   NIC_ALIAS = [
       NETWORK_ID = 0,
       PARENT     = NIC0,
       EXTERNAL   = YES
   ]

.. important::

    The template parameter ``EXTERNAL=YES`` must be set, otherwise, the alias will be configured as **internal** and an additional IP address will appear in the VM. The usage of external NIC aliases can be also enforced for all IP addresses of the specific virtual network if the parameter ``EXTERNAL=YES`` is set directly in your `virtual network <https://docs.opennebula.io/stable/management_and_operations/network_management/vn_templates.html>`__ template.

Such alias can be attached to the VM (e.g., with ID 10) via command line following way:

.. prompt:: bash $ auto

   $ onevm nic-attach 10 --file external-nic-alias.tmpl

Example Use-Case
~~~~~~~~~~~~~~~~

Our demonstration deployment has a Virtual Router instance with the following NICs attached:

- ``eth0`` with **public** network (``10.0.0.0/8``) and assigned IP ``10.0.0.1``
- ``eth1`` with **private** network (``192.168.0.0/24``) and assigned IP ``192.168.0.1``

The contextualization parameter ``ONEAPP_VNF_SDNAT4_INTERFACES`` is set to ``eth0 eth1`` and VNF will continuously create and update mappings between **public** and **private** networks. We also have the following virtual machines:

- public **VM1** in the public network with IP ``10.0.0.100``
- private **VM2** in the private network with IP ``192.168.0.2``

We now attach **external NIC alias** to the private **VM2** from the public network with the command above and OpenNebula allocates the appropriate IP address, e.g. ``10.0.0.101``. This IP address is not configured inside the virtual machine, but Virtual Routers detects the change in IP addresses allocation in both networks and creates mapping rules which ensure the traffic over the ``10.0.0.101`` gets to/from **VM2**.

The **VM2** is now transparently accessible via its external alias IP which is translated in both directions to its real and the only private address. Any other VMs in the public network will be able to connect to it via the external alias.

The demonstration deployment can be seen in the following schema:

|image-vnf-sdnat4-diagram|

.. note::

   The mapping rules are updated in intervals set via the context parameter ``ONEAPP_VNF_SDNAT4_REFRESH_RATE`` and defaults to 30 seconds.

.. _vnf_router4:

ROUTER4
-------

See: :ref:`Contextualization Parameters <vnf_router4_context_param>`

The VNF provides *routing* functionality among different networks and allows Virtual Machines from different networks to talk to each other. If enabled (``ONEAPP_VNF_ROUTER4_ENABLED``) and by default, the routing is done among all connected interfaces (except management), but can be limited only to interfaces specified via ``ONEAPP_VNF_ROUTER4_INTERFACES``. The function is implemented on the Linux kernel level by enabling IP packages forwarding on the selected network interfaces.

.. important::

  This function provides only routing. The function must be combined with :ref:`NAT4 <vnf_nat4>` VNF if you want to, e.g. give your private network clients access to the public Internet services.

.. _vnf_dns:

DNS
---

See: :ref:`Contextualization Parameters <vnf_dns_context_param>`

The VNF provides *DNS recursor* service implemented by the `Unbound <https://nlnetlabs.nl/documentation/unbound/>`_ server. Introduces the DNS resolving functionality for network clients, which cannot access the Internet or other locally configured name server directly. The VNF by default uses DNS **root servers** to resolve the requests on its own. It can also forward queries (when ``ONEAPP_VNF_DNS_USE_ROOTSERVERS="NO"``) to another configured name servers (set in ``ONEAPP_VNF_DNS_NAMESERVERS`` or auto-configured from your virtual networks).

.. note::

   In forward-only behavior the auto-configurated settings usually **IS NOT** desired, don't forget to specify the upstream DNS name servers, e.g.:

    .. code::

        CONTEXT=[
            ONEAPP_VNF_DNS_NAMESERVERS="8.8.8.8, 8.8.4.4",
            ...
        ]

Service can be restricted only to work on particular network interfaces via ``ONEAPP_VNF_DNS_INTERFACES``. Apart from described syntax to list the :ref:`interfaces <vnf_interfaces>` to include or exclude (``ethX``, ``!ethX``), in this VNF it's extended to also cover optional listening IP and port on the particular interface (with syntax ``ethX/IP[@port]``), e.g.:

.. code::

        CONTEXT=[
            ONEAPP_VNF_DNS_INTERFACES="eth0, eth1/10.0.0.1, eth2/192.168.0.1@53",
            ...
        ]

.. important::

   Beware of running the DNS VNF on any of your Internet-facing interfaces! It might become a DNS recursor for the whole Internet and be a victim of some form of `Denial-of-Service Attack <https://en.wikipedia.org/wiki/Denial-of-service_attack>`_!

Function might be disabled to work over TCP (via ``ONEAPP_VNF_DNS_TCP_DISABLED="YES"``) or UDP (via ``ONEAPP_VNF_DNS_UDP_DISABLED="YES"``) protocols. But, it's not generally recommended to disable UDP protocol as many public name servers are using UDP exclusively.

To have full control over DNS VNF, you can provide the complete Unbound configuration file via ``ONEAPP_VNF_DNS_CONFIG`` contextualization parameter. It must a Base64 encoded string with valid `unbound.conf <https://nlnetlabs.nl/documentation/unbound/unbound.conf/>`_ content.

.. _vnf_lb:

LB (LoadBalancer)
-----------------

See: :ref:`Contextualization Parameters <vnf_lb_context_param>`

LoadBalancer function is provided by `LVS/IPVS feature <http://linuxvirtualserver.org/>`_ of the Linux kernel.

.. important::

    Some limitations apply due to the underlying implementation of the LVS/IPVS working on a lower layer of the Linux kernel networking stack.

    There are obstacles to overcome when there is a need to connect to the load balanced address from the VNF/Vrouter (Director in the LVS/IPVS parlance) and from the real servers themselves.

    Some workarounds can be found in the `HowTo pages <http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/>`_.

    **Please, consider this fact while defining your solution!**

The best way to utilize the LB feature is to treat the VNF/Vrouter as a one-way blackbox where the traffic on the load balanced address is forwarded to the real servers (static or dynamic) and those do **NOT** need to connect via load balance address back to themselves.

If the real servers need to communicate with each other then consider workarounds from the linked HowTo pages or run some cluster-aware software like `etcd <https://etcd.io/>`_ and let the nodes connect to localhost while exposing the cluster API via LB for the outside clients.

Using ONEAPP_VNF_LB_CONFIG
~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``ONEAPP_VNF_LB_CONFIG`` can be used instead of using many contextualization parameters to define the LBs and all static real servers and keeping track of all those integer suffixes (``[0-9]``) which must be in sync.

``ONEAPP_VNF_LB_CONFIG`` provides a way to define complete LB setup in one contextualization parameter.

Each LB with all its static real servers is a one JSON - multiple LBs can be stringed together and separated by commas.

The following is a minimalist JSON config for one LB:

.. code::

    {
      "index": 0,
      "real-servers": [
        {
          "server-host": "192.168.101.100"
        },
        {
          "server-host": "192.168.102.100"
        }
      ],
      "lb-address": "192.168.150.101"
    }

.. important::

    The above minimalist configuration will forward **ALL** the incoming traffic into one of the real servers including ``SSH`` because no port nor protocol was specified!

    Therefore if the load-balanced IP (in this case ``192.168.150.101``) is the **only IP** on the VNF/Vrouter then the VNF/Vrouter itself becomes virtually **inaccessible**!

And this one is using all possible options together:

.. code::

    {
      "index": 0,
      "real-servers": [
        {
          "server-host": "192.168.101.100",
          "server-port": "8080",
          "server-weight": 1,
          "server-ulimit": 100,
          "server-llimit": 0
        },
        {
          "server-host": "192.168.102.100",
          "server-port": "8080",
          "server-weight": 2,
          "server-ulimit": 100,
          "server-llimit": 0
        }
      ],
      "lb-address": "192.168.150.101",
      "lb-port": "80",
      "lb-protocol": "TCP",
      "lb-scheduler": "wlc",
      "lb-method": "NAT",
      "lb-timeout": "10"
    }

.. note::

    The keys should be self-explanatory and match the value semantics of suffixed contextualization parameters.

.. important::

    Just create one JSON per LB, separated them by commas and encode the whole text in ``BASE64`` or use the **user input** in the marketplace template.

.. important::

    Do not forget to **increment** the ``index`` of each LB!

.. _vnf_lb_dynamic_rs:

Dynamic real servers
~~~~~~~~~~~~~~~~~~~~

If the VNF is part of a OneFlow service then it is possible to dynamically update the LB's real server pool via OneGate.

The idea is to create VMs running a program/script which will on the bootstrap or when a need arises instruct VNF to join this VM to the pool of real servers by signalling this fact via OneGate variables.

This is the complete list of such variables and their semantics match of those of static real server contextualization parameters.

===================================== ============== ===========
OneGate variable                      Default        Description
===================================== ============== ===========
``ONEGATE_LB[0-9]_IP``                none           The load balanced IP address defined on VNF (required)
``ONEGATE_LB[0-9]_PORT``              none           The load balanced IP port defined on VNF (required if used for LB)
``ONEGATE_LB[0-9]_PROTOCOL``          none           The load balanced IP protocol defined on VNF (required if used for LB)
``ONEGATE_LB[0-9]_SERVER_HOST``       none           Real server address (IP or hostname - required)
``ONEGATE_LB[0-9]_SERVER_PORT``       none           Real server port (required if LB has port defined too)
``ONEGATE_LB[0-9]_SERVER_WEIGHT``     none           Real server weight (optional)
``ONEGATE_LB[0-9]_SERVER_ULIMIT``     none           Real server upper limit on connections (optional)
``ONEGATE_LB[0-9]_SERVER_LLIMIT``     none           Real server lower limit on connections (optional)
===================================== ============== ===========

.. note::

    You can define multiple LBs on each VM by simply suffixing the variables correctly and distinguish them by port/protocol.

.. important::

    The suffix does not need to match the index on the VNF but it must match the defined LB triplet (IP, port and protocol) or just load balanced IP if port nor protocol is defined for the LB.

The VM script can inside use the following commands (for example):

.. code::

    onegate vm update --data ONEGATE_LB0_IP=192.168.150.100
    onegate vm update --data ONEGATE_LB0_PROTOCOL=TCP
    onegate vm update --data ONEGATE_LB0_PORT=80
    onegate vm update --data ONEGATE_LB0_SERVER_HOST=192.168.101.1
    onegate vm update --data ONEGATE_LB0_SERVER_PORT=8080

.. note::

    Notice that in the example above we used the same suffix (``0``) to define this one dynamic real server and to pair it to the right LB.

.. _vnf_lb_direct_routing:

LVS/IPVS method (NAT vs Direct-Routing)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**NAT**

The LoadBalancer will by default use ``NAT`` method where VNF/Vrouter will route the traffic between client and real servers (backends) through itself in both directions.

The NATed method will require two interfaces on VNF/Vrouter and two vnets - one *public* from which the traffic will be initiated (client network) and *private* where real servers will be located.

.. code::

    NAT method:

                     .--------.
                     | Client |
                     `--------`
                    eth0: client IP
                         |
                         |

                   (public vnet)

        src: client IP <---> dest: LB IP

                         |
                         |
                    eth0: LB IP
                  .-------------.
          DNAT >> | VNF/Vrouter | >> SNAT
                  `-------------`
                    eth1: Priv IP
                         |
                         |

                   (private vnet)

        src: client IP <---> dest: RS IP

                         |
                         |
                    eth0: RS IP
                  .-------------.
                  | Real Server |
                  `-------------`

----

**DR**

Another option is to use the **Direct-Routing** method.

E.g. some particular LoadBalancer (``LB0`` in this case) can be switched to Direct-Routing method by setting up the context parameter ``ONEAPP_VNF_LB0_METHOD`` to the value ``DR``.

.. note::

    Alternatively set the ``lb-method`` key in the case of JSON config (``ONEAPP_VNF_LB_CONFIG``) - also with the value ``DR``.

In the DR scenario the VNF/Vrouter will see only the incoming traffic but the outgoing traffic from any real server will go back **directly** to the client.

It is also mean that VNF/Vrouter will require only one interface and only one vnet is needed for the whole setup.

.. important::

    Direct-Routing method will not work without taking additional steps on each real server (described below)!

.. code::

    DR method:

                     .--------.
                     | Client |
                     `--------`
                    eth0: client IP

                    ^               V
                    ^               v
                    ^                \______
                    |                       \
                    |                        `_____
                    |                              \
                    |                               \
                    |
                    |                src: client IP --> dest: LB IP
                    |
                    |                               |
                    |
                    |                          eth0: LB IP
                                             .-------------.
        src: LB IP --> dest: client IP       | VNF/Vrouter |
                                             `-------------`
                    |
                    |                               |
                    |
                    |               src: client IP --> dest: LB IP (!!!)
                    |
                    |                               /
                    |                        ______'
                    |                       /
                    |                ______'
                    ^               /
                    ^              v
                    ^              V

                    lo: LB IP (!!!)
                    eth0: RS IP
                  .-------------.
                  | Real Server |
                  `-------------`

.. important::

    From the schema above it is obvious that under normal circumstances this real server would reply on any ARP requests for the load-balanced IP and therefore we would have conflicting IP on the same subnet - ``LB IP`` is setup on both the real server and VNF/Vrouter!

    Some additional steps must be taken to prevent that.

- Each real server for that particular LB (using DR) must also have assigned the load-balanced IP - that should be done either on its loopback or some ``dummy`` interface (``modprobe dummy``)::

    $ ip addr add <LB_IP> dev lo

- Each real server also has to workaround the ARP flux problem to avoid unwanted ARP replies::

    # e.g. in /etc/sysctl.conf
    net.ipv4.ip_nonlocal_bind=1
    net.ipv4.conf.eth0.arp_ignore = 1
    net.ipv4.conf.eth0.arp_announce = 2

For more information visit the official `LVS/IPVS wiki <https://web.archive.org/web/20211118135810/https://kb.linuxvirtualserver.org/wiki/Using_arp_announce/arp_ignore_to_disable_ARP>`_ or `LVS ARP HowTo <https://web.archive.org/web/20210323211958/http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/LVS-HOWTO.arp_problem.html>`_.

.. note::

    Similar result can be also achieved with `arptables <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/s1-lvs-direct-vsa>`_ command too - if ``sysctl`` approach is undesirable.

.. _vnf_tutorials:

Tutorials
=========

In this section, we will demonstrate how this appliance can be used - but there is a need for a few prerequisites. VNF appliance is useful only when there are networks involved so we will create a couple of virtual networks in OpenNebula - if you do not know how to create them then peek into the `Virtual Network Management <https://docs.opennebula.io/stable/management_and_operations/network_management/index.html>`_ documentation in OpenNebula.

================ ==================== ========================================= =================== ===============
Network Name     Subnet               Range                                     Gateway             DNS
================ ==================== ========================================= =================== ===============
``public``       ``192.168.150.0/24`` ``192.168.150.100`` - ``192.168.150.199`` ``192.168.150.1``
``vnet_a``       ``192.168.101.0/24`` ``192.168.101.100`` - ``192.168.101.199`` ``192.168.101.111`` ``192.168.101.111``
``vnet_b``       ``192.168.102.0/24`` ``192.168.102.100`` - ``192.168.102.199`` ``192.168.102.111`` ``192.168.102.111``
``vnet_mgt``     ``192.168.103.0/24`` ``192.168.103.100`` - ``192.168.103.199`` ``192.168.103.111`` ``192.168.103.111``
================ ==================== ========================================= =================== ===============

.. important::

   Before you can start with the tutorials, ensure that you followed the steps as was described in the :ref:`Quick Start <service_vnf_quick_start>` section and that you have appliance(s) imported in your OpenNebula and templates updated with the password and/or SSH key.

This tutorial starts an instance of VNF appliance with the following functions - router with NAT, DHCP server, and DNS. It will have access to the Internet via the ``public`` (external) network (where NAT will happen) and it will be attached to the other two different local subnets (where it will provide DHCP and DNS services). It will forward packets between these networks and it will provide access to the Internet.

We'll describe how to instantiate VNF as a regular :ref:`Virtual Machine <vnf_tutorial_vnf>` and as :ref:`Virtual Router <vnf_tutorial_vrouter>`.

.. _vnf_tutorial_vnf:

VNF as Virtual Machine
----------------------

In the beginning, let's instantiate Virtual Machine from the ``Service VNF`` template without attaching any no networks yet. The provided contextualization can be seen in this picture:

|image-vnf-demo-vm1|

.. _vnf_tutorial_vnf_explanation:

.. note::

   In this tutorial, we don't want to provide DHCP and DNS recursor functions to the Internet - so we specify interfaces for these VNFs with public interface excluded - ``"!eth0"``. For the NAT, we must be explicit and specify outgoing public interface over which address translation happens - ``"eth0"``.  For the routing, we want to forward packets between all the interfaces - so the clients in both the local networks can talk to each other and to the internet. For that, we can leave it empty because that is the default when the VNF is enabled.

   The rest of the contextualization parameters are unchanged, they are left with defaults.

Click the **Instantiate** button and wait until VM is properly started. You should also be able to login inside and look around. There is only a loopback interface so all enabled VNFs are just idle.

Now let's attach three virtual networks and see what happens:

1. ``public`` (to be on ``eth0``)
2. ``vnet_a`` (to be on ``eth1``)
3. ``vnet_b`` (to be on ``eth2``)

Step 1 - Attach First NIC
~~~~~~~~~~~~~~~~~~~~~~~~~

First, we will attach the ``public`` virtual network (which will our first NIC, referenced by platform-independent name ``eth0``). It is the Internet-facing NIC through which we can reach public services like root DNS servers.

Click on the instantiated VM and then **Network → Attach nic → public → Attach**.

If you are logged in the VM you can tail the appliance log

.. code::

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

    localhost:~# tail -f /var/log/one-appliance/ONE_configure.log

You should see some activity there and the final lines should resemble

.. code::

    ...
    [Tue Mar 17 05:13:15 UTC 2020] => INFO: Save context/config variables as a report in: /etc/one-appliance/config
    [Tue Mar 17 05:13:15 UTC 2020] => INFO: --- CONFIGURATION FINISHED ---

Step 2 -Attach Second and Third NICs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now we will attach ``vnet_a`` and ``vnet_b`` in the same manner. After each attach, you have to wait after the reconfiguration is finished (e.g., by following the log file above ``/var/log/one-appliance/ONE_configure.log``).

Our VM has altogether 3 addresses IP addresses, for example:

* ``192.168.150.102/24``
* ``192.168.101.100/24``
* ``192.168.102.100/24``

.. note::

    Please, bear in mind that we are demoing a specific environment and addresses might differ to yours. Adjust the examples accordingly.

Step 3 - Validation
~~~~~~~~~~~~~~~~~~~

You can verify that all has been configured by checking the appliance configuration file with report in ``/etc/one-appliance/config``. You should find there all three interfaces and their IPs, for example:

.. code::

    ...
    ONEAPP_VROUTER_ETH0_IP = '192.168.150.102'
    ...
    ONEAPP_VROUTER_ETH1_IP = '192.168.101.100'
    ...
    ONEAPP_VROUTER_ETH2_IP = '192.168.102.100'
    ...

.. note::

    Advanced users can inspect the real configuration files of the VNF services to understand how they are configured to work, e.g.:

    * **DHCP4** VNF: ``/etc/kea/kea-dhcp4.conf``
    * **DNS** VNF: ``/etc/unbound/unbound.conf``
    * **ROUTER4** VNF: ``/etc/sysctl.d/01-one-router4.conf``
    * **NAT** VNF: ``/etc/iptables/nat4-rules-enabled``

Step 4 - Reconfigure DHCP
~~~~~~~~~~~~~~~~~~~~~~~~~

We are still not done yet. DHCP4 and DNS functions are configured and running, but DHCP does not provide the right options to the clients - it offers parameters based on contextualization preloaded from Virtual Network instead of ones we want. We are going to configure the IP addresses or our VNF VM (``192.168.101.100`` and ``192.168.102.100``) as both gateways and name servers to our DHCP clients

We must update the Virtual Machine context parameters to fix this problem. Open Virtual Machine details in the OpenNebula Sunstone and click on **Conf → Update Configuration → Context → Custom vars** and at the bottom, there is a "**plus**" button. Click on it and create the following context variables with values:

=================================== ===============
Variable Name                       Value
=================================== ===============
``ONEAPP_VNF_DHCP4_ETH1_DNS``       ``192.168.101.100``
``ONEAPP_VNF_DHCP4_ETH1_GATEWAY``   ``192.168.101.100``
``ONEAPP_VNF_DHCP4_ETH2_DNS``       ``192.168.102.100``
``ONEAPP_VNF_DHCP4_ETH2_GATEWAY``   ``192.168.102.100``
=================================== ===============

Apply changes by clicking on the **Update** button at the top. After the recontextualization happens in your VNF VM, you can verify the changes in the appliance configuration file (``/etc/one-appliance/config``) or in ISC Kea configuration (``/etc/kea/kea-dhcp4.conf``).


Step 5 - Reconfigure DNS
~~~~~~~~~~~~~~~~~~~~~~~~

The demo should be ready now, but maybe the OpenNebula is deployed in a restricted environment and direct DNS resolving through root servers doesn't work. For example, try on your VNF VM instance:

.. code::

    localhost:~# ping opennebula.org
    ping: bad address 'opennebula.org'

If resolving works for you, you can skip this step. If not, you might need to reconfigure your DNS function to forward to specific DNS servers.

Update VNF VM context parameters one again. Go to the Virtual Machine details in the OpenNebula Sunstone, click on **Conf → Update Configuration → Context → Custom vars** and add following context variables:

=================================== ===============
Variable Name                       Value
=================================== ===============
``ONEAPP_VNF_DNS_USE_ROOTSERVERS``  ``NO``
``ONEAPP_VNF_DNS_NAMESERVERS``      ``8.8.8.8, 8.8.4.4``
=================================== ===============

Apply changes by clicking on **Update** and wait until recontextualization is finished.


.. note::

    You can verify the change in the configuration of the Unbound server in ``/etc/unbound/unbound.conf``, e.g.:

    .. code::

        localhost:~# tail -n 5 /etc/unbound/unbound.conf
        forward-zone:
            name: "."
            forward-addr: 8.8.8.8
            forward-addr: 8.8.4.4

If the provided parameters are correct and VM was reconfigured successfully, the resolving should work now:

.. code::

    localhost:~# ping opennebula.org
    PING opennebula.org (173.255.245.62): 56 data bytes
    64 bytes from 173.255.245.62: seq=0 ttl=54 time=158.173 ms
    64 bytes from 173.255.245.62: seq=1 ttl=54 time=158.410 ms
    64 bytes from 173.255.245.62: seq=2 ttl=54 time=158.268 ms
    ^C
    --- opennebula.org ping statistics ---
    3 packets transmitted, 3 packets received, 0% packet loss
    round-trip min/avg/max = 158.173/158.283/158.410 ms

Step 6 - Test Clients
~~~~~~~~~~~~~~~~~~~~~

We are done with configuring VNF and we'll run a few client VMs, for which the VNF will provide services (DNS, DHCP, routing with NAT).

You can export any image with your favorite operating system from `Marketplaces <https://docs.opennebula.io/stable/management_and_operations/storage_management/marketplaces.html>`_ for the following tests, but the examples below are running on the `Alpine Linux image <https://marketplace.opennebula.io/appliance/193631c3-7082-4528-bfdb-31b2ecb3d9f5>`__. Instantiate 2 VMs with no special configuration, only attach one NIC to each client VM from different network

1. VM - NIC from ``vnet_a``
2. VM - NIC from ``vnet_b``

Login over the OpenNebula Sunstone VNC console into both VMs, run DHCP clients, and validate they received leases with expected parameters. For example, for VM 1 (with NIC in ``vnet_a``):

.. code::

    localhost:~# udhcpc
    udhcpc: started, v1.31.1
    udhcpc: sending discover
    udhcpc: sending select for 192.168.101.101
    udhcpc: lease of 192.168.101.101 obtained, lease time 3600

    localhost:~# cat /etc/resolv.conf
    nameserver 192.168.101.100

    localhost:~# ip r
    default via 192.168.101.100 dev eth0 metric 202
    192.168.101.0/24 dev eth0 proto kernel scope link src 192.168.101.101

For VM 2 (with NIC in ``vnet_b``):

.. code::

    localhost:~# udhcpc
    udhcpc: started, v1.31.1
    udhcpc: sending discover
    udhcpc: sending select for 192.168.102.101
    udhcpc: lease of 192.168.102.101 obtained, lease time 3600

    localhost:~# cat /etc/resolv.conf
    nameserver 192.168.102.100

    localhost:~# ip r
    default via 192.168.102.100 dev eth0 metric 202
    192.168.102.0/24 dev eth0 proto kernel scope link src 192.168.102.101

Both of these client VMs connected to different networks should be able to talk to each other (try ``ping``), resolve DNS, and reach Internet services.

.. _vnf_tutorial_vrouter:

VNF as Virtual Router
---------------------

In this part of the tutorial, we'll instantiate the appliance as a Virtual Router. The functionality will be the same as in previous VNF as Virtual Machine, but in addition, it'll be deployed in HA mode with Keepalived service running with no extra work. In the OpenNebula Sunstone, go to the **Templates → Virtual Routers** and instantiate ``Service Virtual Router`` (also you continue to the `Virtual Routers documentation <https://docs.opennebula.io/stable/management_and_operations/network_management/vrouter.html>`_ to learn more about VRs).

Ensure your contextualization is as follows, we'll start 2 instances:

|image-vnf-demo-vrouter1|

You won't be able to instantiate the VR until you fill the specific name:

|image-vnf-demo-vrouter2|

.. note::

    The contextualization parameters are almost the same as they were in the :ref:`previous VM tutorial <vnf_tutorial_vnf_explanation>`, the notable differences here are the missing **router** option (which is always enabled for VR) and new option **Number of VM instances** which specifies number nodes in HA mode.

We wait until the VR machines are running and we can login to each of them via VNC in Sunstone to verify if everything was configured as expected. Although we did not attach any network yet, all enabled VNFs are idle. Now we attach these 3 virtual networks:

1. ``public`` (to be on ``eth0``)
2. ``vnet_a`` (to be on ``eth1``)
3. ``vnet_b`` (to be on ``eth2``)

Step 1 - Attach First NIC
~~~~~~~~~~~~~~~~~~~~~~~~~

First, we will attach NIC from the virtual network ``public``. It is an Internet-facing NIC through which we can reach public services like root DNS servers. In the OpenNebula Sunstone pick **Instances → Virtual Routers**, click on your Virtual Router and then **Attach NIC → public → Attach**.

If you are logged in one of the VMs of your Virtual Router, then you can tail the appliance log

.. code::

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

    localhost:~# tail -f /var/log/one-appliance/ONE_configure.log

You should see the activity there and the final lines should resemble:

.. code::

    ...
    [Tue Mar 17 08:04:52 UTC 2020] => INFO: Save context/config variables as a report in: /etc/one-appliance/config
    [Tue Mar 17 08:04:52 UTC 2020] => INFO: --- CONFIGURATION FINISHED ---

Step 2 -Attach Second and Third NICs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now we will attach ``vnet_a`` and ``vnet_b`` with an extra (but crucial) step. Go again on **Instances → Virtual Routers**, click on your Virtual Router, and then **Attach NIC**. Click on ``vnet_a``  and now you must fill in the text box **Force IPv4** with value ``192.168.101.111`` and tick the checkbox on the right with **Floating IP**. If your settings look like on the screenshot below, click on **Attach**:

|image-vnf-demo-vrouter3|

Wait until recontextualization is finished in the instances and attach another virtual network ``vnet_b`` the same way, but set **Force IPv4** with ``192.168.102.111`` and enable **Floating IP** as well.

|image-vnf-demo-vrouter4|

Step 3 - Validation
~~~~~~~~~~~~~~~~~~~

Wait until both instances of Virtual Router are configured inside (follow log ``/var/log/one-appliance/ONE_configure.log``). Recontextualization is triggered with each attached NIC, before you continue be sure that you see two more "``CONFIGURATION FINISHED``" texts in the log and that one of the instances is **Master** (run ``/etc/keepalived/ha-check-status.sh``).

At that point both Virtual Router instances should have three interfaces with Keepalived running, one of them should have all VNFs running and assigned all floating IPs. You can verify that by checking the report file - ``/etc/one-appliance/config``.

There you should see all three interfaces for the first instance:

.. code::

    ...
    ONEAPP_VROUTER_ETH0_IP = '192.168.150.102'
    ...
    ONEAPP_VROUTER_ETH1_IP = '192.168.101.100'
    ...
    ONEAPP_VROUTER_ETH2_IP = '192.168.102.100'
    ...

And, for the second instance:

.. code::

    ...
    ONEAPP_VROUTER_ETH0_IP = '192.168.150.103'
    ...
    ONEAPP_VROUTER_ETH1_IP = '192.168.101.102'
    ...
    ONEAPP_VROUTER_ETH2_IP = '192.168.102.102'
    ...

.. note::

    Advanced users can inspect the real configuration files of the VNF services to understand how they are configured to work, e.g.:

    * **DHCP4** VNF: ``/etc/kea/kea-dhcp4.conf``
    * **DNS** VNF: ``/etc/unbound/unbound.conf``
    * **ROUTER4** VNF: ``/etc/sysctl.d/01-one-router4.conf``
    * **NAT** VNF: ``/etc/iptables/nat4-rules-enabled``

The important point is that both floating IPs (VIPs) are assigned. Log into each instance of the Virtual Router and check the state. For example:

.. code::

    localhost:~# /etc/keepalived/ha-check-status.sh
    KEEPALIVED: RUNNING
    VRRP-INSTANCE(ETH0): MASTER
    VRRP-INSTANCE(ETH1): MASTER
    VRRP-INSTANCE(ETH2): MASTER
    SYNC-GROUP(vrouter): MASTER

    localhost:~# ip a | grep -e 192.168.101.111 -e 192.168.102.111
        inet 192.168.101.111/32 scope global eth1
        inet 192.168.102.111/32 scope global eth2
    localhost:~#

On the output above we can see that the particular Virtual Router VM is the **Master** (among the Virtual Router instances which form a HA group) and has all two floating IPs configured on network interfaces. A different case is presented below:

.. code::

    localhost:~# /etc/keepalived/ha-check-status.sh
    KEEPALIVED: RUNNING
    VRRP-INSTANCE(ETH0): BACKUP
    VRRP-INSTANCE(ETH1): BACKUP
    VRRP-INSTANCE(ETH2): BACKUP
    SYNC-GROUP(vrouter): BACKUP

    localhost:~# ip a | grep -e 192.168.101.111 -e 192.168.102.111
    localhost:~#

This instance is running in a standby (backup) mode and waiting for the time when the master instance is down to take over the operations. Also, it doesn't have the floating IPs assigned.

Step 4 - Test Clients
~~~~~~~~~~~~~~~~~~~~~

We are done with Virtual Router configuration and as a final step, we are going to instantiate two client VMs. For example, you can take `Alpine Linux image <https://marketplace.opennebula.io/appliance/193631c3-7082-4528-bfdb-31b2ecb3d9f5>`__ from OpenNebula Marketplace. We don't need any special configuration, only attach one NIC to each client VM from different network

1. VM - NIC from ``vnet_a``
2. VM - NIC from ``vnet_b``

Login over the OpenNebula Sunstone VNC console into both VMs, run DHCP clients, and validate they received leases with expected parameters. For example, for VM 1 (with NIC in ``vnet_a``):

.. code::

    localhost:~# udhcpc
    udhcpc: started, v1.31.1
    udhcpc: sending discover
    udhcpc: sending select for 192.168.101.101
    udhcpc: lease of 192.168.101.101 obtained, lease time 3600

    localhost:~# cat /etc/resolv.conf
    nameserver 192.168.101.111

    localhost:~# ip r
    default via 192.168.101.111 dev eth0 metric 202
    192.168.101.0/24 dev eth0 proto kernel scope link src 192.168.101.101

For VM 2 (with NIC in ``vnet_b``):

.. code::

    localhost:~# udhcpc
    udhcpc: started, v1.31.1
    udhcpc: sending discover
    udhcpc: sending select for 192.168.102.101
    udhcpc: lease of 192.168.102.101 obtained, lease time 3600

    localhost:~# cat /etc/resolv.conf
    nameserver 192.168.102.111

    localhost:~# ip r
    default via 192.168.102.111 dev eth0 metric 202
    192.168.102.0/24 dev eth0 proto kernel scope link src 192.168.102.101

Both of these network clients (on different subnets) should be able to communicate with each other (e.g., try to ``ping`` second VM from first VM) and should be able to resolve DNS and reach internet services.

Management Network
~~~~~~~~~~~~~~~~~~

An attached network card to the Virtual Router can be configured as **management** only. This allows only to connect to the Virtual Router instances, but no VNF and/or routing services will be running on management interfaces.

We'll attach to our running Virtual Router management interface from the reserved virtual network ``vnet_mgt``, which we have already created at the :ref:`beginning of the tutorials <vnf_tutorials>`.  In the OpenNebula Sunstone pick **Instances → Virtual Routers**, click on your Virtual Router and then **Attach NIC → vnet_mgt**. Tick the checkbox: **Management Interface** and continue with the final **Attach**.

|image-vnf-demo-vrouter5|

Wait for all the Virtual Router instances to be reconfigured and one of them will be (re)selected as **Master**. You should see a new network interface inside, but no VNFs will be running on it.

.. |image-download| image:: /images/vnf-download.png
.. |image-context-vars| image:: /images/vnf-context-vars.png
.. |image-context-vars-vrouter| image:: /images/vnf-context-vars-vrouter.png
.. |image-ssh-context| image:: /images/appliance-ssh-context.png
.. |image-custom-vars-password| image:: /images/appliance-custom-vars-password.png
.. |image-vnf-demo-vm1| image:: /images/vnf-demo-vm1.png
.. |image-vnf-demo-vrouter1| image:: /images/vnf-demo-vrouter1.png
.. |image-vnf-demo-vrouter2| image:: /images/vnf-demo-vrouter2.png
.. |image-vnf-demo-vrouter3| image:: /images/vnf-demo-vrouter3.png
.. |image-vnf-demo-vrouter4| image:: /images/vnf-demo-vrouter4.png
.. |image-vnf-demo-vrouter5| image:: /images/vnf-demo-vrouter5.png
.. |image-vnf-sdnat4-diagram| image:: /images/vnf-sdnat4-diagram.png
                              :scale: 70%
