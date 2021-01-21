.. _fireedge_install:

================================================================================
Fireedge Server Installation and Configuration
================================================================================

What Is?
========

The OpenNebula Fireedge purpose is twofold:

- Sunstone can use **VMRC and Guacamole proxies** for remote access to VMs, including
  VNC, RDP and ssh connections.

- **Start OneProvision GUI**, to ease the the deployment of fully operational OpenNebula
  clusters in a remote provider.

Requirements
============

- `Node.js 10.21 <https://nodejs.org/en/>`_ or later

.. note:: If you install OpenNebula **from the binary packages** `Guacamole proxy daemon (guacd) <https://guacamole.apache.org/doc/gug/installing-guacamole.html>`_
  should be installed. Otherwise the OpenNebula binary packages will install the Guacamole server.

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

.. note::
  Check extra configuration for :ref:`Guacamole guacd conf <fireedge_sunstone_configuration>`

.. todo:: provision conf => fireedge cpi <fireedge_cpi>

  - :oneprovision_prepend_command ''
  - :oneprovision_optional_create_command ''

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

