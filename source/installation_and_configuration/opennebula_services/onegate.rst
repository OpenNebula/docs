.. _onegate_conf:

=====================
OneGate Configuration
=====================

The OneGate server allows **Virtual Machines to pull and push information from/to OpenNebula**. It can be used with all hypervisor Host types (KVM, LXC, Firecracker, and vCenter) if the guest operating system has preinstalled the OpenNebula :ref:`contextualization package <os_install>`. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-gate`` with the system service ``opennebula-gate``.

Read more in :ref:`OneGate Usage <onegate_usage>`.

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

Advanced Setup
==============

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
