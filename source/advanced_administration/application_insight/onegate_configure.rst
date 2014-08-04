.. _onegate_configure:

=============================
OneGate Server Configuration
=============================

The OneGate service allows Virtual Machines guests to push monitoring information to OpenNebula. Although it is installed by default, its use is completely optional.

Requirements
============

Check the :ref:`Installation guide <ignc>` for details of what package you have to install depending on your distribution

Configuration
=============

The OneGate configuration file can be found at ``/etc/one/onegate-server.conf``. It uses YAML syntax to define the following options:

**Server Configuration**

* ``one_xmlrpc``: OpenNebula daemon host and port
* ``host``: Host where OneGate will listen
* ``port``: Port where OneGate will listen

**Log**

* ``debug_level``: Log debug level. 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG

**Auth**

* ``auth``: Authentication driver for incomming requests. ``onegate``: based on token provided in the context
* ``core_auth``: Authentication driver to communicate with OpenNebula core, ``cipher`` for symmetric cipher encryption of tokens ``x509`` for x509 certificate encryption of tokens. For more information, visit the :ref:`OpenNebula Cloud Auth documentation <cloud_auth>`.

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

