.. _onegate_conf:

=====================
OneGate Configuration
=====================

The OneGate server allows **Virtual Machines to pull and push information from/to OpenNebula**. It can be used with all hypervisor Host types (KVM, LXC, Firecracker, and vCenter) if the guest operating system has preinstalled the OpenNebula :ref:`contextualization package <os_install>`. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-gate`` with the system service ``opennebula-gate``.

Read more in :ref:`OneGate Usage <onegate_usage>`.

Recommended Network Setup
=========================

To use the OneGate Service, VMs must have connectivity to the service. We recommend setting up a dedicated virtual network, ideally on a separate VLAN, for OneGate access. To accomplish this, simply add a virtual network interface (NIC) to the OneGate Service network for the VMs requiring access to the service. In cases where you're deploying a multi-tier service, you can just add the virtual router to the OneGate Service network. The recommended network layout is illustrated in the diagram below:

|onegate_net|

Configuration
=============

The OneGate configuration file can be found in ``/etc/one/onegate-server.conf`` on your Front-end. It uses **YAML** syntax with following parameters:

.. note::

    After a configuration change, the OneGate server must be :ref:`restarted <onegate_conf_service>` to take effect.

+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Parameter               |                                                                               Description                                                                               |
+===============================+=========================================================================================================================================================================+
| **Server Configuration**                                                                                                                                                                                |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:one_xmlrpc``               | Endpoint of OpenNebula XML-RPC API                                                                                                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:host``                     | Host/IP where OneGate will listen                                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:port``                     | Port where OneGate will listen                                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:ssl_server``               | SSL proxy URL that serves the API (set if is being used)                                                                                                                |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Authentication**                                                                                                                                                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:auth``                     | Authentication driver for incoming requests.                                                                                                                            |
|                               |                                                                                                                                                                         |
|                               | * ``onegate`` based on tokens provided in VM context                                                                                                                    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:core_auth``                | Authentication driver to communicate with OpenNebula core                                                                                                               |
|                               |                                                                                                                                                                         |
|                               | * ``cipher`` for symmetric cipher encryption of tokens                                                                                                                  |
|                               | * ``x509`` for X.509 certificate encryption of tokens                                                                                                                   |
|                               |                                                                                                                                                                         |
|                               | For more information, visit the :ref:`Cloud Server Authentication <cloud_auth>` reference.                                                                              |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **OneFlow Endpoint**                                                                                                                                                                                    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:oneflow_server``           | Endpoint where the OneFlow server is listening                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Permissions**                                                                                                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:permissions``              | By default OneGate exposes all the available API calls. Each of the actions can be enabled/disabled in the server configuration.                                        |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:restricted_attrs``         | Attributes that cannot be modified when updating a VM template                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:restricted_actions``       | Actions that cannot be performed on a VM                                                                                                                                |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:vnet_template_attributes`` | Attributes of the Virtual Network template that will be retrieved for Virtual Networks                                                                                  |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Logging**                                                                                                                                                                                             |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:debug_level``              | Logging level. Values: ``0`` for ERROR level, ``1`` for WARNING level, ``2`` for INFO level, ``3`` for DEBUG level                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:expire_delta``             | Default interval for timestamps. Tokens will be generated using the same timestamp for this interval of time. THIS VALUE CANNOT BE LOWER THAN EXPIRE_MARGIN.            |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:expire_margin``            | Tokens will be generated if time > EXPIRE_TIME - EXPIRE_MARGIN                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

In the default configuration, the OneGate server will only listen to requests coming from ``localhost``. Because the OneGate needs to be accessible remotely from the Virtual Machines, you need to change ``:host`` parameter in ``/etc/one/onegate-server.conf`` to a public IP of your Front-end host or to ``0.0.0.0`` (to work on all IP addresses configured on host).

Configure OpenNebula
--------------------

Before Virtual Machines can communicate with OneGate, you need to edit :ref:`/etc/one/oned.conf <oned_conf_onegate>` and set the OneGate endpoint in parameter ``ONEGATE_ENDPOINT``. This endpoint (IP/hostname) must be reachable from the Virtual Machines over the network!

.. code::

    ONEGATE_ENDPOINT = "http://one.example.com:5030"

Restart the OpenNebula service to apply changes.

.. _onegate_conf_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula-gate``.

To start, restart or stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-gate
    # systemctl restart opennebula-gate
    # systemctl stop    opennebula-gate

To enable or disable automatic start on Host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-gate
    # systemctl disable opennebula-gate

Server **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/onegate.log``
- ``/var/log/one/onegate.error``

Other logs are also available in Journald. Use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula-gate.service

.. _onegate_proxy_conf:

.. |onegate_net| image:: /images/onegate_net.png

..
    Advanced Setup
    ==============


    Example: Use OneGate/Proxy to Improve Security
    ----------------------------------------------

    In addition to the OneGate itself, OpenNebula provides transparent TCP-proxy for the OneGate's network traffic.
    It's been designed to drop the requirement for guest VMs to be directly connecting to the service. Up to this point,
    in cloud environments like :ref:`OneProvision/AWS <first_edge_cluster>`, the OneGate service had to be exposed
    on a public IP address. Please take a look at the example diagram below:

    .. graphviz::

        digraph {
          graph [splines=true rankdir=LR ranksep=0.7 bgcolor=transparent];
          edge [dir=both color=blue arrowsize=0.6];
          node [shape=plaintext fontsize="11em"];

          { rank=same;
            F1 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>ONE / 1 (follower)</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">eth1: 192.168.150.1</TD></TR>
              </TABLE>
            >];
            F2 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>ONE / 2 (leader)</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">opennebula-gate<BR/>192.168.150.86:5030</TD></TR>
                <HR/>
                <TR><TD PORT="eth1" BGCOLOR="white">eth1:<BR/>192.168.150.2<BR/>192.168.150.86 (VIP)</TD></TR>
              </TABLE>
            >];
            F3 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>ONE / 3 (follower)</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">eth1: 192.168.150.3</TD></TR>
              </TABLE>
            >];
          }

          { rank=same;
            H1 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>ONE-Host / 1</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">opennebula-gate-proxy<BR/>169.254.16.9:5030</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">lo:<BR/>127.0.0.1<BR/>169.254.16.9</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white"><FONT COLOR="blue">⇅ (forwarding)</FONT></TD></TR>
                <HR/>
                <TR><TD PORT="br0" BGCOLOR="white">br0: 192.168.150.4</TD></TR>
              </TABLE>
            >];
            H2 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>ONE-Host / 2</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">opennebula-gate-proxy<BR/>169.254.16.9:5030</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">lo:<BR/>127.0.0.1<BR/>169.254.16.9</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white"><FONT COLOR="blue">⇅ (forwarding)</FONT></TD></TR>
                <HR/>
                <TR><TD PORT="br0" BGCOLOR="white">br0: 192.168.150.5</TD></TR>
              </TABLE>
            >];
          }

          { rank=same;
            G1 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>VM-Guest / 1</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">ONEGATE_ENDPOINT=<BR/>http://169.254.16.9:5030</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">static route:<BR/>169.254.16.9/32 dev eth0</TD></TR>
                <HR/>
                <TR><TD PORT="eth0" BGCOLOR="white">eth0: 192.168.150.100</TD></TR>
              </TABLE>
            >];
            G2 [label=<
              <TABLE STYLE="ROUNDED" BGCOLOR="lightgray" BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="5">
                <TR><TD>VM-Guest / 2</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">ONEGATE_ENDPOINT=<BR/>http://169.254.16.9:5030</TD></TR>
                <HR/>
                <TR><TD BGCOLOR="white">static route:<BR/>169.254.16.9/32 dev eth0</TD></TR>
                <HR/>
                <TR><TD PORT="eth0" BGCOLOR="white">eth0: 192.168.150.101</TD></TR>
              </TABLE>
            >];
          }

          F1:s -> F2:n [style=dotted arrowhead=none];
          F2:s -> F3:n [style=dotted arrowhead=none];

          F2:eth1:e -> H1:br0:w;
          F2:eth1:e -> H2:br0:w;

          H1:br0:e -> G1:eth0:w;
          H2:br0:e -> G2:eth0:w;
        }

    |

    In this altered OneGate architecture, each hypervisor Node runs a process, which listens for connections on a dedicated
    `IPv4 Link-Local Address <https://www.rfc-editor.org/rfc/rfc3927>`_.
    After a guest VM connects to the proxy, the proxy connects back to OneGate and transparently forwards all the protocol traffic
    both ways. Because a guest VM no longer needs to be connecting directly, it's now easy to setup a VPN/TLS tunnel between
    hypervisor Nodes and the OpenNebula Front-end machines. It should allow for OneGate communication to be conveyed through securely,
    and without the need for exposing OneGate on a public IP address.

    Each of the OpenNebula DEB/RPM node packages: ``opennebula-node-kvm``, ``opennebula-node-lxc`` and ``opennebula-node-firecracker``
    contains the ``opennebula-gate-proxy`` systemd service. To enable and start it on your Hosts, execute as **root**:

    .. prompt:: bash # auto

        # systemctl enable opennebula-gate-proxy.service --now

    You should be able to verify, that the proxy is running with the default config:

    .. prompt:: bash # auto

        # ss -tlnp | grep :5030
        LISTEN 0      4096    169.254.16.9:5030      0.0.0.0:*    users:(("ruby",pid=9422,fd=8))

    .. important::

        The ``:onegate_addr`` attribute is configured automatically in the ``/var/tmp/one/etc/onegate-proxy.conf`` file during
        the ``onehost sync -f`` operation. That allows for an easy reconfiguration in the case of a larger (many Hosts)
        OpenNebula environment.

    To change the value of the ``:onegate_addr`` attribute, edit the ``/var/lib/one/remotes/etc/onegate-proxy.conf``
    file and then execute the ``onehost sync -f`` operation as **oneadmin**:

    .. prompt:: bash $ auto

        $ gawk -i inplace -f- /var/lib/one/remotes/etc/onegate-proxy.conf <<'EOF'
        BEGIN { update = ":onegate_addr: '192.168.150.86'" }
        /^#*:onegate_addr:/ { $0 = update; found=1 }
        { print }
        END { if (!found) print update >>FILENAME }
        EOF
        $ onehost sync -f
        ...
        All hosts updated successfully.

    .. note::

        As a consequence of the ``onehost sync -f`` operation, the proxy service will be automatically restarted
        and reconfigured on every hypervisor Node.

    To change the value of the ``ONEGATE_ENDPOINT`` context attribute for each guest VM, edit the ``/etc/one/oned.conf`` file
    on your Front-end machines. For the purpose of using the proxy, just specify an IP address from the ``169.254.0.0/16``
    subnet (by default it's ``169.254.16.9``) and then restart the ``opennebula`` service:

    .. prompt:: bash # auto

        # gawk -i inplace -f- /etc/one/oned.conf <<'EOF'
        BEGIN { update = "ONEGATE_ENDPOINT = \"http://169.254.16.9:5030\"" }
        /^#*ONEGATE_ENDPOINT[^=]*=/ { $0 = update; found=1 }
        { print }
        END { if (!found) print update >>FILENAME }
        EOF
        # systemctl restart opennebula.service

    And, last but not least, it's required from guest VMs to setup this static route:

    .. prompt:: bash # auto

        # ip route replace 169.254.16.9/32 dev eth0

    Perhaps one of the easiest ways to achieve it, is to alter a VM template by adding a :ref:`start script <template_context>`:

    .. prompt:: bash # auto

        # (export EDITOR="gawk -i inplace '$(cat)'" && onetemplate update alpine) <<'EOF'
        BEGIN { update = "START_SCRIPT=\"ip route replace 169.254.16.9/32 dev eth0\"" }
        /^CONTEXT[^=]*=/ { $0 = "CONTEXT=[" update "," }
        { print }
        EOF
        # onetemplate instantiate alpine
        VM ID: 0

    Finally, by examining the newly created guest VM, you can confirm if OneGate is reachable:

    .. prompt:: bash # auto

        # grep -e ONEGATE_ENDPOINT -e START_SCRIPT /var/run/one-context/one_env
        export ONEGATE_ENDPOINT="http://169.254.16.9:5030"
        export START_SCRIPT="ip route replace 169.254.16.9/32 dev eth0"
        # ip route show to 169.254.16.9
        169.254.16.9 dev eth0 scope link
        # onegate vm show --json
        {
          "VM": {
            "NAME": "alpine-0",
            "ID": "0",
            "STATE": "3",
            "LCM_STATE": "3",
            "USER_TEMPLATE": {
              "ARCH": "x86_64"
            },
            "TEMPLATE": {
              "NIC": [
                {
                  "IP": "192.168.150.100",
                  "MAC": "02:00:c0:a8:96:64",
                  "NAME": "NIC0",
                  "NETWORK": "public"
                }
              ],
              "NIC_ALIAS": []
            }
          }
        }

    Example: Deployment Behind TLS Proxy
    ------------------------------------

    This is an **example** of how to configure Nginx as a SSL/TLS proxy for OneGate on Ubuntu.

    1. Update your package lists and install Nginx:

    .. prompt:: bash # auto

        # apt-get update
        # apt-get -y install nginx

    2. Get a trusted SSL/TLS certificate. For testing, we'll generate a self-signed certificate:

    .. prompt:: bash # auto

        # cd /etc/one
        # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/one/cert.key -out /etc/one/cert.crt

    3. Use the following content as an Nginx configuration. NOTE: Change the ``one.example.com`` variable for your own domain:

    .. code::

        server {
          listen 80;
          return 301 https://$host$request_uri;
        }

        server {
          listen 443;
          server_name ONEGATE_ENDPOINT;

          ssl_certificate           /etc/one/cert.crt;
          ssl_certificate_key       /etc/one/cert.key;

          ssl on;
          ssl_session_cache  builtin:1000  shared:SSL:10m;
          ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
          ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
          ssl_prefer_server_ciphers on;

          access_log            /var/log/nginx/onegate.access.log;

          location / {

            proxy_set_header        Host $host;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;

            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_pass          http://localhost:5030;
            proxy_read_timeout  90;

            proxy_redirect      http://localhost:5030 https://ONEGATE_ENDPOINT;
          }
        }

    4. Configure OpenNebula (``/etc/one/oned.conf``) with OneGate endpoint, e.g.:

    .. code::

        ONEGATE_ENDPOINT = "https://one.example.com"

    5. Configure OneGate (``/etc/one/onegate-server.conf``) with new secure OneGate endpoint in ``:ssl_server``, e.g.:

    .. code::

        :ssl_server: https://one.example.com

    6. Restart all services:

    .. prompt:: bash # auto

        # systemctl restart nginx
        # systemctl restart opennebula
        # systemctl restart opennebula-gate
