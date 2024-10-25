.. _tproxy:

================================================================================
Transparent Proxies
================================================================================

Transparent Proxies allow for connecting to management services like OneGate by utilizing the existing Datacenter backbone networking implicitly. The OneGate service lives normally on the leader Front-end machine, this makes it notoriously difficult for Virtual Machines running in isolated Virtual Networks to contact it. It's ultimately required from OpenNebula users to design Virtual Networking in advance in such a way that OneGate can be reached securely, Transparent Proxies have been designed to remove that requirement.

About the Design
================================================================================

|tproxy_diagram|

Virtual networking in OpenNebula is bridge-based. Each Hypervisor host that's running Virtual Machines inside a specific Virtual Network pre-creates such a bridge before deploying those machines. Transparent Proxies extend that design by introducing a pair of VETH devices, where one of "ends" is inserted into the bridge and the other one is boxed inside the dedicated network namespace. That allows for deployment of proxy processes that can be reached by Virtual Machine guests via TCP/IP securely, i.e. without compromising internal networking of Hypervisor hosts. Proxy processes themselves form a "mesh" of daemons interconnected with UNIX sockets, it allows for complete isolation of the two involved TCP/IP stacks, we call that environment the "String-Phone Proxy". The final part of the solution requires from Virtual Machine guests to contact services over proxy via ``169.254.16.9`` link-local address on specific ports, instead of their real endpoints.

Hypervisor Configuration
================================================================================

Transparent Proxies are configured from the ``~oneadmin/remotes/etc/vnm/OpenNebulaNetwork.conf`` file on the Front-end machines with the following syntax:

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

    The YAML snippet above defines two distinct proxies, where the first one is the usual OneGate proxy and the second is a completely custom service.

.. important::

    When the ``:networks:`` YAML key is missing or empty, it's assumed that the particular proxy should be applied to **all** available Virtual Networks. Defining multiple entries with the identical ``:service_port:`` values will have no effect as the subsequent duplicates will be ignored by networking drivers.

**To apply the configuration two steps need to be performed:**

1. The ``OpenNebulaNetwork.conf`` file needs to be synced into Hypervisor hosts with ``onehost sync -f`` (executed by the ``oneadmin`` system user on the leader Front-end machine).
2. Any already running guests have to be power-cycled (for example with ``onevm poweroff`` followed by ``onevm resume`` CLI commands), otherwise the desired configuration changes may show no effect.

Guest Configuration
================================================================================

The most common use case of Transparent Proxies seems to be communication with OneGate, an example Virtual Machine template could look like:

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

In the simplest (but still instructive) case to make the resulting Virtual Machine connect to OneGate using Transparent Proxies the following settings need to be present inside:

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

Driver logs can be located per each guest in ``/var/log/one/*.log`` on Front-end machines.

Proxy logs can be located in ``/var/log/`` on Hypervisor hosts, for example:

.. code::

    $ ls -1 /var/log/one_tproxy*.log
    /var/log/one_tproxy.log
    /var/log/one_tproxy_br0.log

Transparent Proxies internal implementation involves several networking primitives combined together:

* ``nft`` (``nftables``) to store the service mapping and manage ARP resolutions
* ``ip netns`` / ``nsenter`` family of commands to manage and use network namespaces
* ``ip link`` / ``ip address`` / ``ip route`` commands
* ``/var/tmp/one/vnm/tproxy`` the actual implementation of the "String-Phone" daemon mesh

Let's go here over several example command invocations to get familiar with the environment.

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

    The ``nftables`` config is not persisted across Hypervisor host reboots as it is the default behavior in OpenNebula in general.

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

    In case multiple Hypervisor hosts participate in the Virtual Network's traffic the ``169.254.16.9`` address stays the same regardless, the closest Hypervisor host is supposed to answer guest requests.

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

    There is no PID file management implemented, for simplicity all proxy processes are found by looking at the ``/proc/PID/cmdline`` process attributes.

**Restarting / Reloading config of proxy daemons:**

.. code::

    $ /var/tmp/one/vnm/tproxy restart
    $ /var/tmp/one/vnm/tproxy reload

.. important::

    Start, stop, restart and reload commands can be executed manually by the user as a part of debugging process, but in the normal circumstances proxy daemons are completely managed by networking drivers. The command line interface here is very minimal and does not require any extra parameters as all the relevant config is stored in ``nftables``.

Security Groups
================================================================================

Transparent Proxies can be used together with OpenNebula Security Groups, an example security group template could look like:

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
