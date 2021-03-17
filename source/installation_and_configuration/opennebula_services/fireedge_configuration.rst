.. _fireedge_setup:
.. _fireedge_configuration:

================================================================================
FireEdge Configuration
================================================================================

FireEdge is a web server which purpose is twofold:

- Sunstone can use **VMRC and Guacamole proxies** for remote access to VMs, including VNC, RDP and ssh connections.

- **Start OneProvision GUI**, to ease the deployment of fully operational OpenNebula Clusters in a remote provider.

.. warning:: Please note that FireEdge does currently not support federated environments. It can interact with a local OpenNebula instance (even if it's federated) but cannot interact with remote, federated OpenNebula instances.

.. _fireedge_install_configuration:

Configuration
================================================================================

The FireEdge configuration file can be found at ``/etc/one/fireedge-server.conf``. It uses YAML syntax to define some options:

+-------------------------------------------+------------------------------+----------------------------------------------------+
| Option                                    | Default Value                | Description                                        |
+===========================================+==============================+====================================================+
| ``:host``                                 | 0.0.0.0                      | Host on which the FireEdge server will listen      |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:port``                                 | 2616                         | Port on which the FireEdge server will listen      |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:log``                                  | prod                         | Log debug: ``prod`` or ``dev``                     |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:cors``                                 | true                         | Enable cors (cross-origin resource sharing)        |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:one_xmlrpc``                           | *http://localhost:2633/RPC2* | XMLRPC endpoint                                    |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:oneflow_server``                       | *http://localhost:2472*      | OneFlow endpoint                                   |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:limit_token/min``                      | 14                           | JWT minimum expiration time (days)                 |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:limit_token/max``                      | 30                           | JWT maximum expiration time (days)                 |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:guacd/port``                           | 4822                         | Port on which the guacd server will listen         |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:guacd/host``                           | 127.0.0.1                    | Hostname on which the guacd server will listen     |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:oneprovision_prepend_command``         |                              | Prepend for ``oneprovision`` command               |
+-------------------------------------------+------------------------------+----------------------------------------------------+
| ``:oneprovision_optional_create_command`` |                              | Optional param for ``oneprovision create`` command |
+-------------------------------------------+------------------------------+----------------------------------------------------+

.. note:: Check extra configuration for :ref:`FireEdge OneProvision GUI <fireedge_cpi>`.

.. _fireedge_configuration_for_sunstone:

Configuration for Sunstone
================================================================================

You need to configure Sunstone with the public endpoint of the FireEdge, so that one service can redirect user to the other. To configure the public FireEdge endpoint in Sunstone, edit ``/etc/one/sunstone-server.conf`` and update the ``:public_fireedge_endpoint`` with the base URL (domain or IP-based) over which end-users can access the service. For example:

.. code::

  :public_fireedge_endpoint: http://one.example.com:2616

If you're reconfiguring any time later already running services, don't forget to restart them to apply the changes.

Alternatively, if you aren't planning to use FireEdge, please disable it in Sunstone by commenting out the following options in ``/etc/one/sunstone-server.conf``:

.. code::

  #:public_fireedge_endpoint
  #:private_fireedge_endpoint

Troubleshooting
================================================================================

Any issue related with FireEdge will be logged in one of the following files:

- ``/var/log/one/fireedge.log``, contains logs of operations.
- ``/var/log/one/fireedge.error``, contains exceptions in the server.

A common issue when launching FireEdge is an occupied port:

.. code:: bash

    Error: listen EADDRINUSE: address already in use 0.0.0.0:2616

To solve this issue, please check first that no FireEdge servers are currently in use (for instance using ``pgrep fireedge``). If there're already a running FireEdge, take it down using ``systemctl``, and try launching it again.

If another service is using that port, you can change FireEdge configuration to use another host/port in ``/etc/one/fireedge-server.conf``. Remember to also adjust the FireEdge endpoints in ``/etc/one/sunstone-server.conf``.

.. note:: When making the change, you must restart the FireEdge service to apply the changes.

