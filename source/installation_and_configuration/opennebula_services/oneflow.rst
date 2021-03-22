.. _appflow_configure:
.. _oneflow_conf:

=====================
OneFlow Configuration
=====================

The OneFlow **orchestrates multi-VM services** as a whole, interacts with the OpenNebula Daemon to manage the Virtual Machines (starts, stops), and can be controlled via the Sunstone GUI or over CLI. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-flow`` with system service ``opennebula-flow``.

Read more in :ref:`Multi-VM Service Management <multivm_service_management>`.

Configuration
=============

The OneFlow configuration file can be found in ``/etc/one/oneflow-server.conf`` on your Front-end. It uses **YAML** syntax with following parameters:

.. note::

    After a configuration change, the OneFlow server must be :ref:`restarted <oneflow_conf_service>` to take effect.

+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Parameter           |                                                                               Description                                                                               |
+===========================+=========================================================================================================================================================================+
| **Server Configuration**                                                                                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:one_xmlrpc``           | Endpoint of OpenNebula XML-RPC API                                                                                                                                      |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:subscriber_endpoint``  | Endpoint for ZeroMQ subscriptions                                                                                                                                       |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:autoscaler_interval``  | Time in seconds between each time elasticity rules are evaluated                                                                                                        |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:host``                 | Host/IP where OneFlow will listen                                                                                                                                       |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:port``                 | Port where OneFlow will listen                                                                                                                                          |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:force_deletion``       | Force deletion of VMs on terminate signal                                                                                                                               |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Defaults**                                                                                                                                                                                        |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:default_cooldown``     | Default cooldown period after a scale operation, in seconds                                                                                                             |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:wait_timeout``         | Default time to wait VMs states changes, in seconds                                                                                                                     |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:concurrency``          | Number of threads to make actions with flows                                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:shutdown_action``      | Default shutdown action. Values: ``shutdown``, ``shutdown-hard``                                                                                                        |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:action_number``        | Default number of virtual machines (``:action_number``) that will receive the given call in each interval (``:action_period``),                                         |
| ``:action_period``        | when an action is performed on a Role.                                                                                                                                  |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:vm_name_template``     | Default name for the Virtual Machines created by oneflow. You can use any of the following placeholders:                                                                |
|                           | ``$SERVICE_ID``, ``$SERVICE_NAME``, ``$ROLE_NAME``, ``$VM_NUMBER``.                                                                                                     |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:page_size``            | Default page size when purging DONE services                                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Authentication**                                                                                                                                                                                  |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:core_auth``            | Authentication driver to communicate with OpenNebula core                                                                                                               |
|                           |                                                                                                                                                                         |
|                           | * ``cipher`` for symmetric cipher encryption of tokens                                                                                                                  |
|                           | * ``x509`` for X.509 certificate encryption of tokens                                                                                                                   |
|                           |                                                                                                                                                                         |
|                           | For more information, visit the :ref:`Cloud Server Authentication <cloud_auth>` reference.                                                                              |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Logging**                                                                                                                                                                                         |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:debug_level``          | Logging level. Values: ``0`` for ERROR level, ``1`` for WARNING level, ``2`` for INFO level, ``3`` for DEBUG level                                                      |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

In the default configuration, the OneFlow server will only listen to requests coming from ``localhost`` (which is enough to control OneFlow over Sunstone running on the same host). If you want to control OneFlow over API/CLI remotely, you need to change ``:host`` parameter in ``/etc/one/oneflow-server.conf`` to a public IP of your Front-end host or to ``0.0.0.0`` (to work on all IP addresses configured on host).

Configure Sunstone
------------------

Sunstone GUI enables end-users to access the OneFlow from the UI, it directly connects to the OneFlow on their behalf. Sunstone has configured the OneFlow endpoint it connects to in ``/etc/one/sunstone-server.conf`` in parameter ``:oneflow_server``. When OneFlow is running on a different host than Sunstone, the endpoint in Sunstone must be configured appropriately.

Sunstone tabs for OneFlow (*Services* and *Service Templates*) are enabled in Sunstone by default. To customize visibility for different types of users, follow to the :ref:`Sunstone Views <suns_views>` documentation.

Configure CLI
-------------

OneFlow CLI (``oneflow`` and ``oneflow-template``) uses same credentials as other :ref:`command-line tools <cli>`. The login and password are taken from file referenced by environment variable ``$ONE_AUTH`` (defaults to ``$HOME/.one/one_auth``). Remote endpoint and (optionally) distinct access user/password to the above is configured in environment variable ``$ONEFLOW_URL`` (defaults to ``http://localhost:2474``), ``$ONEFLOW_USER`` and ``$ONEFLOW_PASSWORD``.

Example:

.. prompt:: bash $ auto

    $ ONEFLOW_URL=http://one.example.com:2474 oneflow list

See more in :ref:`Managing Users documentation<manage_users_shell>`.

.. _oneflow_conf_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula-flow``.

To start, restart, stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-flow
    # systemctl restart opennebula-flow
    # systemctl stop    opennebula-flow

To enable or disable automatic start on host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-flow
    # systemctl disable opennebula-flow

Server **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/oneflow.log``
- ``/var/log/one/oneflow.error``

Logs of individual multi-VM Services managed by OneFlow can be found in

- ``/var/log/one/oneflow/$ID.log`` where ``$ID`` identifies the service

Other logs are also available in Journald, use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula-flow.service

Advanced Setup
==============

Permission to Create Services
-----------------------------

*Documents* are special types of resources in OpenNebula used by OneFlow to store *Service Templates* and information about *Services*. When a new user Group is created, you can decide if you want to allow/deny its users to create *Documents*, resp. OneFlow Services. By default, :ref:`new groups <manage_groups>` are allowed to create Document resources.
