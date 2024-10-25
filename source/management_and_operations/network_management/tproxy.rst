.. _tproxy:

================================================================================
Transparent Proxies
================================================================================

Transparent Proxies make it possible to connect to management services, such as OneGate, by implicitly using the existing data center backbone networking. The OneGate service usually runs on the leader Front-end machine, which makes it difficult for Virtual Machines running in isolated virtual networks to contact it. This situation forces OpenNebula users to design virtual networking in advance, to ensure that VMs can securely reach OneGate. Transparent Proxies have been designed to remove that requirement.

About the Design
================================================================================

|tproxy_diagram|

Virtual networking in OpenNebula is bridge-based. Each Hypervisor that runs Virtual Machines in a specific Virtual Network pre-creates such a bridge before deploying the VMs. Transparent Proxies extend that design by introducing a pair of VETH devices, where one of two "ends" is inserted into the bridge and the other is boxed inside the dedicated network namespace. This makes it possible to deploy proxy processes that can be reached by Virtual Machine guests via TCP/IP securely, i.e. without compromising the internal networking of Hypervisor hosts. Proxy processes themselves form a "mesh" of daemons interconnected with UNIX sockets, which allows for complete isolation of the two involved TCP/IP stacks; we call this environment the "String-Phone Proxy." The final part of the solution requires that Virtual Machine guests contact services over proxy via the ``169.254.16.9`` link-local address on specific ports, instead of their real endpoints.

Hypervisor Configuration
================================================================================

Transparent Proxies read their config from the ``~oneadmin/remotes/etc/vnm/OpenNebulaNetwork.conf`` file on the Front-end machines. The file uses the following syntax:

.. code::

    :tproxy_debug_level: 2 # 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG
    :tproxy:
    # OneGate service.
    - :service_port: 5030
      :remote_addr: 10.11.12.13 # OpenNebula Front-end VIP
      :remote_port: 5030
    # Custom service.
    - :service_port: 1234
      :remote_addr: 10.11.12.34
      :remote_port: 1234
      :networks: [vnet_name_or_id]

.. note::

    The YAML snippet above defines two distinct proxies, where the first is the usual OneGate proxy and the second is a completely custom service.

.. important::

    If the ``:networks:`` YAML key is missing or empty, the particular proxy will be applied to *all* available Virtual Networks. Defining multiple entries with the identical ``:service_port:`` values will have no effect as the subsequent duplicates will be ignored by networking drivers.

**To apply the configuration, you need to perform two steps:**

1. On the leader Front-end machine: as the ``oneadmin`` system user, sync the ``OpenNebulaNetwork.conf`` file with the Hypervisor hosts, by running ``onehost sync -f``.
2. Power-cycle any running guests (for example by running ``onevm poweroff`` followed by ``onevm resume``); otherwise the desired configuration changes may show no effect.

Guest Configuration
================================================================================

The most common use case of Transparent Proxies is for communication with OneGate. Below is an example Virtual Machine template:

.. code::

    NAME = "example0"
    CONTEXT = [
      NETWORK = "YES",
      SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
      TOKEN = "YES" ]
    CPU = "1"
    DISK = [
      IMAGE = "img0" ]
    GRAPHICS = [
      LISTEN = "0.0.0.0",
      TYPE = "VNC" ]
    MEMORY = "256"
    NIC = [
      NETWORK = "vnet0",
      NETWORK_UNAME = "oneadmin",
      SECURITY_GROUPS = "100" ]
    NIC_DEFAULT = [
      MODEL = "virtio" ]
    OS = [
      ARCH = "x86_64" ]

In the simplest (but still instructive) case, a Virtual Machine needs the following settings to connect to OneGate using Transparent Proxies:

.. code::

    $ grep ONEGATE_ENDPOINT /run/one-context/one_env
    export ONEGATE_ENDPOINT="http://169.254.16.9:5030"

    $ ip route show to 169.254.16.9
    169.254.16.9 dev eth0 scope link

.. code::

    $ onegate vm show -j | jq -r '.VM.NAME'
    example0-0

Debugging
================================================================================

You can find driver logs for each guest on the Front-end machines, in ``/var/log/one/*.log``.

Proxy logs are found on Hypervisor hosts, in ``/var/log/``. For example:

.. code::

    $ ls -1 /var/log/one_tproxy*.log
    /var/log/one_tproxy.log
    /var/log/one_tproxy_br0.log

The internal implementation of Transparent Proxies involves several networking primitives combined together:

* ``nft`` (``nftables``) to store the service mapping and manage ARP resolutions
* ``ip netns`` / ``nsenter`` family of commands to manage and use network namespaces
* ``ip link`` / ``ip address`` / ``ip route`` commands
* ``/var/tmp/one/vnm/tproxy`` the actual implementation of the "String-Phone" daemon mesh

Below are several example command invocations, to gain familiarity with the environment.

**Listing service mappings in nftables:**

.. code::

    $ nft list ruleset
    ...
    table ip one_tproxy {
            map ep_br0 {
                    type inet_service : ipv4_addr . inet_service
                    elements = { 1234 : 10.11.12.34 . 1234, 5030 : 10.11.12.13 . 5030 }
           }
    }

.. note::

    The ``nftables`` config is not persisted across Hypervisor host reboots, as it is the default behavior in OpenNebula in general.

**Listing all custom network namespaces:**

.. code::

    $ ip netns list
    one_tproxy_br0 (id: 0)

.. note::

    Each active Virtual Network requires one of those namespaces to run the proxy inside.

**Checking if the "internal" end of the VETH device pair has been put inside the dedicated namespace:**

.. code::

    $ ip netns exec one_tproxy_br0 ip address
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    7: br0a@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 12:00:83:53:f4:3d brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 169.254.16.9/32 scope global br0a
           valid_lft forever preferred_lft forever
        inet6 fe80::1000:83ff:fe53:f43d/64 scope link
           valid_lft forever preferred_lft forever

.. note::

    In case multiple Hypervisor hosts participate in the Virtual Network's traffic, the ``169.254.16.9`` address stays the same regardless, the closest Hypervisor host is supposed to answer guest requests.

**Checking if the default route for sending packets back into the bridge has been configured:**

.. code::

    $ ip netns exec one_tproxy_br0 ip route
    default dev br0a scope link

**Listing PIDs of running proxy processes:**

.. code::

    $ /var/tmp/one/vnm/tproxy status
    one_tproxy: 16803
    one_tproxy_br0: 16809

.. note::

    There is only a single ``one_tproxy`` process running in the default network namespace, it connects to real remote services.

.. note::

    There are multiple ``one_tproxy_*`` processes, they are boxed inside corresponding dedicated network namespaces and connect to the ``one_tproxy`` process using UNIX sockets.

.. note::

    There is no PID file management implemented. For simplicity, all proxy processes may be found by looking at the ``/proc/PID/cmdline`` process attributes.

**Restarting/reloading config of proxy daemons:**

.. code::

    $ /var/tmp/one/vnm/tproxy restart
    $ /var/tmp/one/vnm/tproxy reload

.. important::

    While you can manually run the ``start``, ``stop``, ``restart`` and ``reload`` commands as part of a debugging process, under normal circumstances the proxy daemons are completely managed by networking drivers. The command-line interface here is very minimal and does not require any extra parameters, as all the relevant config is stored in ``nftables``.

Security Groups
================================================================================

Transparent Proxies can be used together with OpenNebula Security Groups. Below is an example of a security group template:

.. code::

    NAME = "example0"

    RULE = [
      PROTOCOL  = "ICMP",
      RULE_TYPE = "inbound" ]
    RULE = [
      PROTOCOL  = "ICMP",
      RULE_TYPE = "outbound" ]

    RULE = [
      PROTOCOL  = "TCP",
      RANGE     = "22",
      RULE_TYPE = "inbound" ]
    RULE = [
      PROTOCOL  = "TCP",
      RANGE     = "80,443",
      RULE_TYPE = "outbound" ]

    # Required for Transparent Proxies
    RULE = [
      PROTOCOL  = "TCP",
      RANGE     = "1234,5030",
      RULE_TYPE = "outbound" ]

    # DNS
    RULE = [
      PROTOCOL  = "UDP",
      RANGE     = "53",
      RULE_TYPE = "outbound" ]

.. |tproxy_diagram| image:: /images/tproxy-diagram.drawio.png
