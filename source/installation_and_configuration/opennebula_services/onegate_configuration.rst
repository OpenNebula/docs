.. _onegate_configure:

=====================
OneGate Configuration
=====================

The OneGate service allows Virtual Machine guests to pull and push VM information from OpenNebula, it can be used with VMs running on :ref:`KVM, LXC, Firecracker and vCenter <context_overview>`. It's installed by default, but the use is completely optional and/or can be deployed separately on a different machine. Please check the :ref:`Single Front-end Installation <ignc>`.

Configuration
=============

The OneGate configuration file can be found at ``/etc/one/onegate-server.conf``. It uses YAML syntax to define the following options:

**Server Configuration**

* ``one_xmlrpc``: OpenNebula daemon host and port
* ``host``: Host where OneGate will listen
* ``port``: Port where OneGate will listen
* ``ssl_server``: SSL proxy URL that serves the API (set if is being used)

**Log**

* ``debug_level``: Log debug level. 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG

**Auth**

* ``auth``: Authentication driver for incomming requests.

  * ``onegate``: based on token provided in the context

* ``core_auth``: Authentication driver to communicate with OpenNebula core.

  * ``cipher`` for symmetric cipher encryption of tokens
  * ``x509`` for x509 certificate encryption of tokens. For more information, visit the :ref:`OpenNebula Cloud Auth documentation <cloud_auth>`.

* ``oneflow_server`` Endpoint where the OneFlow server is listening.
* ``permissions`` By default OneGate exposes all the available API calls, each of the actions can be enabled/disabled in the server configuration.
* ``restricted_attrs`` Attrs that cannot be modified when updating a VM template
* ``restricted_actions`` Actions that cannot be performed on a VM
* ``vnet_template_attributes`` Attributes of the Virtual Network template that will be retrieved for vnets

.. warning:: By default, the server will only listen to requests coming from localhost. Change the ``:host`` attribute in ``/etc/one/onegate-server.conf`` to your server public IP, or 0.0.0.0 so onegate will listen on any interface.

Inside ``/var/log/one/`` you can find log files for the server:

.. code::

    /var/log/one/onegate.error
    /var/log/one/onegate.log

Use OneGate
===========

Before your VMs can communicate with OneGate, you need to edit ``/etc/one/oned.conf`` and set the OneGate endpoint. This IP must be reachable from your VMs.

.. code::

    ONEGATE_ENDPOINT = "http://192.168.0.5:5030"

At this point the service is ready, you can continue to the :ref:`OneGate usage documentation <onegate_usage>`.

Configuring a SSL Proxy
=======================

This is an example on how to configure Nginx as a ssl proxy for Onegate in Ubuntu.

Update your package lists and install Nginx:

.. prompt:: bash $ auto

    $ sudo apt-get update
    $ sudo apt-get install nginx

You should get an official signed certificate, but for the purpose of this example we will generate a self-signed SSL certificate:

.. prompt:: bash $ auto

    $ cd /etc/one
    $ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/one/cert.key -out /etc/one/cert.crt

Next you will need to edit the default Nginx configuration file or generate a new one. Change the ONEGATE_ENDPOINT variable with your own domain name.

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

Update ``/etc/one/oned.conf`` with the new OneGate endpoint

.. code::

    ONEGATE_ENDPOINT = "https://ONEGATE_ENDPOINT"


Update ``/etc/one/onegate-server.conf`` with the new OneGate endpoint and uncomment the ``ssl_server`` parameter

.. code::

    :ssl_server: https://ONEGATE_ENDPOINT

Then restart oned, onegate-server and Nginx:

.. prompt:: bash # auto

    # systemctl restart nginx
    # systemctl restart opennebula
    # systemctl restart opennebula-gate
