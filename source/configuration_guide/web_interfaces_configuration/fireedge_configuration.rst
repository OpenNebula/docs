.. _fireedge_configuration:

================================================================================
FireEdge Configuration
================================================================================

What Is?
========

FireEdge is a web server which purpose is twofold:

- Sunstone can use **VMRC and Guacamole proxies** for remote access to VMs, including
  VNC, RDP and ssh connections.

- **Start OneProvision GUI**, to ease the deployment of fully operational OpenNebula
  clusters in a remote provider.

Requirements
============

- `Node.js 10.21 <https://nodejs.org/en/>`_ or later

.. note:: If you install OpenNebula **from the binary packages** `Guacamole proxy daemon (guacd) <https://guacamole.apache.org/doc/gug/installing-guacamole.html>`_
  should be installed. Otherwise the OpenNebula binary packages will install the Guacamole server.

.. warning:: Please note that FireEdge does currently not support federated environments. It can interact with a local OpenNebula instance (even if it is federated) but cannot interact with remote, federated OpenNebula instances.

.. _fireedge_install_configuration:

Configuration
==============

The Fireedge configuration file can be found at ``/etc/one/fireedge-server.conf``. It uses YAML
syntax to define some options:

+---------------------------+--------------------------------+---------------------------------------------------------------+
|          Option           | Default Value                  | Description                                                   |
+===========================+================================+===============================================================+
| :port                     | `2616`                         | Port on which the Firedge server will listen                  |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :log                      | `prod`                         | Log debug: ``prod`` or ``dev``                                |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :cors                     | `true`                         | Enable cors (cross-origin resource sharing)                   |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :one_xmlrpc               | `http://localhost:2633/RPC2`   | XMLRPC endpoint                                               |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :oneflow_server           | `http://localhost:2472`        | OneFlow endpoint                                              |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :limit_token/min          | `14`                           | JWT minimum expiration time (days)                            |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :limit_token/max          | `30`                           | JWT maximum expiration time (days)                            |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :guacd/port               | `4822`                         | Port on which the guacd server will listen                    |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :guacd/host               | `127.0.0.1`                    | Hostname on which the guacd server will listen                |
+---------------------------+--------------------------------+---------------------------------------------------------------+


.. note::
  Check extra configuration for :ref:`Fireedge OneProvision GUI <fireedge_cpi>`


Starting Fireedge
=================

To start Fireedge, just issue the following command as oneadmin

..code-block:: bash

  # service opennebula-fireedge start

You can find the Fireedge server log file in ``/var/log/one/fireedge.log``. Errors are logged in
``/var/log/one/fireedge.error``.


.. todo:: Troubleshooting

  - node version
  - ...
