.. _onegate_configure:

=============================
OneGate Server Configuration
=============================

The OneGate service allows Virtual Machines guests to pull and push VM information from OpenNebula. Although it is installed by default, its use is completely optional.

Requirements
============

Check the :ref:`Installation guide <ignc>` for details of what package you have to install depending on your distribution

Currently, OneGate is not supported for VMs instantiated in Softlayer and Azure, since the authentication token is not available inside these VMs. OneGate support for these drivers will be include in upcoming releases. Since OpenNebula 4.14.2 the authentication token is available for :ref:` instances deployed in EC2 <context_ec2>`.

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

This is the default file

.. code::

    ################################################################################
    # Server Configuration
    ################################################################################
    
    # OpenNebula sever contact information
    #
    :one_xmlrpc: http://localhost:2633/RPC2

    # Server Configuration
    #
    :host: 127.0.0.1
    :port: 5030

    # SSL proxy URL that serves the API (set if is being used)
    #:ssl_server: https://service.endpoint.fqdn:port/

    ################################################################################
    # Log
    ################################################################################

    # Log debug level
    #   0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG
    #
    :debug_level: 3

    ################################################################################
    # Auth
    ################################################################################

    # Authentication driver for incomming requests
    #   onegate, based on token provided in the context
    #
    :auth: onegate

    # Authentication driver to communicate with OpenNebula core
    #   cipher, for symmetric cipher encryption of tokens
    #   x509, for x509 certificate encryption of tokens
    #
    :core_auth: cipher
    
    ################################################################################
    # OneFlow Endpoint
    ################################################################################
    
    :oneflow_server: http://localhost:2474

    ################################################################################
    # Permissions
    ################################################################################

    :permissions:
      :vm:
        :show: true
        :show_by_id: true
        :update: true
        :update_by_id: true
        :action_by_id: true
      :service:
        :show: true
        :change_cardinality: true

Start OneGate
=============

To start and stop the server, use the ``onegate-server start/stop`` command:

.. code::

    $ onegate-server start
    onegate-server started

.. warning:: By default, the server will only listen to requests coming from localhost. Change the ``:host`` attribute in ``/etc/one/onegate-server.conf`` to your server public IP, or 0.0.0.0 so onegate will listen on any interface.

Inside ``/var/log/one/`` you will find new log files for the server:

.. code::

    /var/log/one/onegate.error
    /var/log/one/onegate.log

Use OneGate
===========

Before your VMs can communicate with OneGate, you need to edit ``/etc/one/oned.conf`` and set the OneGate endpoint. This IP must be reachable from your VMs.

.. code::

    ONEGATE_ENDPOINT = "http://192.168.0.5:5030"

Continue to the :ref:`OneGate usage guide <onegate_usage>`.

Configuring a SSL Proxy
=======================

This is an example on how to configure Nginx as a ssl proxy for Onegate in Ubuntu.

Update your package lists and install Nginx:

.. code::

    sudo apt-get update
    sudo apt-get install nginx

You should get an official signed certificate, but for the purpose of this example we will generate a self-signed SSL certificate:

.. code::
    
    cd /etc/one
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/one/cert.key -out /etc/one/cert.crt

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

.. code::

    sudo service nginx restart
    sudo service opennebula restart
    sudo service opennebula-gate restart