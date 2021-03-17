.. _fireedge_setup:
.. _fireedge_configuration:

================================================================================
FireEdge Configuration
================================================================================

FireEdge is a web server which purpose is twofold:

- Sunstone can use **VMRC and Guacamole proxies** for remote access to VMs, including
  VNC, RDP and ssh connections.

- **Start OneProvision GUI**, to ease the deployment of fully operational OpenNebula
  clusters in a remote provider.

.. warning:: Please note that FireEdge does currently not support federated environments. It can interact with a local OpenNebula instance (even if it is federated) but cannot interact with remote, federated OpenNebula instances.

.. _fireedge_install_configuration:

Configuration
==============

You need to configure Sunstone with the public endpoint of the FireEdge, so that one service can redirect user to the other. To configure the public FireEdge endpoint in Sunstone, edit ``/etc/one/sunstone-server.conf`` and update the ``:public_fireedge_endpoint`` with the base URL (domain or IP-based) over which end-users can access the service. For example:

.. code::

    :public_fireedge_endpoint: http://one.example.com:2616

If you are reconfiguring any time later already running services, don't forget to restart them to apply the changes.

Alternatively, if you are not planning to use FireEdge, please disable it in Sunstone by commenting out the following attributes in /etc/one/sunstone-server.conf:

- :public_fireedge_endpoint
- :private_fireedge_endpoint

The FireEdge configuration file can be found at ``/etc/one/fireedge-server.conf``. It uses YAML
syntax to define some options:

+---------------------------------------+------------------------------+------------------------------------------------+
|                 Option                |        Default Value         |                  Description                   |
+=======================================+==============================+================================================+
| :host                                 | `0.0.0.0`                    | Host on which the Firedge server will listen   |
+---------------------------------------+------------------------------+------------------------------------------------+
| :port                                 | `2616`                       | Port on which the Firedge server will listen   |
+---------------------------------------+------------------------------+------------------------------------------------+
| :log                                  | `prod`                       | Log debug: ``prod`` or ``dev``                 |
+---------------------------------------+------------------------------+------------------------------------------------+
| :cors                                 | `true`                       | Enable cors (cross-origin resource sharing)    |
+---------------------------------------+------------------------------+------------------------------------------------+
| :one_xmlrpc                           | `http://localhost:2633/RPC2` | ONE XMLRPC endpoint                            |
+---------------------------------------+------------------------------+------------------------------------------------+
| :oneflow_server                       | `http://localhost:2472`      | OneFlow endpoint                               |
+---------------------------------------+------------------------------+------------------------------------------------+
| :limit_token/min                      | `14`                         | JWT minimum expiration time (days)             |
+---------------------------------------+------------------------------+------------------------------------------------+
| :limit_token/max                      | `30`                         | JWT maximum expiration time (days)             |
+---------------------------------------+------------------------------+------------------------------------------------+
| :guacd/port                           | `4822`                       | Port on which the guacd server will listen     |
+---------------------------------------+------------------------------+------------------------------------------------+
| :guacd/host                           | `127.0.0.1`                  | Hostname on which the guacd server will listen |
+---------------------------------------+------------------------------+------------------------------------------------+
| :oneprovision_prepend_command         | ""                           | Prepend for oneprovision command               |
+---------------------------------------+------------------------------+------------------------------------------------+
| :oneprovision_optional_create_command | ""                           | Optional param for oneprovision command create |
+---------------------------------------+------------------------------+------------------------------------------------+

.. note::
  Check extra configuration for :ref:`FireEdge OneProvision GUI <fireedge_cpi>`

You can find the FireEdge server log file in ``/var/log/one/fireedge.log``. Errors are logged in ``/var/log/one/fireedge.error``.

Troubleshooting
===============

If when starting the server fireedge fails. In  the log you find this error:

.. code-block:: bash

    Error: listen EADDRINUSE: address already in use 0.0.0.0:2616

Change the configuration to work with another host/port in ``/etc/one/fireedge-server.conf``

.. note::
  When making the change, you must restart the FireEdge service to apply the changes

