.. _appflow_configure:
.. _oneflow_conf:

=====================
OneFlow Configuration
=====================

OneFlow **orchestrates multi-VM services** as a whole, interacts with the OpenNebula Daemon to manage the Virtual Machines (starts, stops), and can be controlled via the Sunstone GUI or over CLI. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-flow`` with the system service ``opennebula-flow``.

Read more in :ref:`Multi-VM Service Management <multivm_service_management>`.

Configuration
=============

The OneFlow configuration file can be found in ``/etc/one/oneflow-server.conf`` on your Front-end. It uses the **YAML** syntax, with the parameters listed in the table below.

.. note::

    After a configuration change, the OneFlow server must be :ref:`restarted <oneflow_conf_service>` to take effect.

.. tip::

    For a quick view of any changes in configuration file options in maintenance releases, check the Resolved Issues page in the :ref:`Release Notes <rn_enterprise>` for the release. Please note that even in the case of changes (such as a new option available), you do *not* need to update your configuration files unless you wish to change the application's behavior.

+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Parameter           |                                                                               Description                                                                               |
+===========================+=========================================================================================================================================================================+
| **Server Configuration**                                                                                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:one_xmlrpc``           | Endpoint of OpenNebula XML-RPC API                                                                                                                                      |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:subscriber_endpoint``  | Endpoint for ZeroMQ subscriptions                                                                                                                                       |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:autoscaler_interval``  | Time in seconds between each evaluation of elasticity rules                                                                                                             |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:host``                 | Host/IP where OneFlow will listen                                                                                                                                       |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:port``                 | Port where OneFlow will listen                                                                                                                                          |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:force_deletion``       | Force deletion of VMs on terminate signal                                                                                                                               |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:retries``              | Retries in case of aborting call due to authentication issue                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Defaults**                                                                                                                                                                                        |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:default_cooldown``     | Default cooldown period after a scale operation, in seconds                                                                                                             |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:wait_timeout``         | Default time to wait for VMs state changes, in seconds                                                                                                                  |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:concurrency``          | Number of threads to make actions with flows                                                                                                                            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:shutdown_action``      | Default shutdown action. Values: ``shutdown``, ``shutdown-hard``                                                                                                        |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:action_number``        | Default number of virtual machines (``:action_number``) that will receive the given call in each interval (``:action_period``),                                         |
| ``:action_period``        | when an action is performed on a Role.                                                                                                                                  |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:vm_name_template``     | Default name for the Virtual Machines created by Oneflow. You can use any of the following placeholders:                                                                |
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
| ``:expire_delta``         | Default interval for timestamps. Tokens will be generated using the same timestamp for this interval of time. THIS VALUE CANNOT BE LOWER THAN EXPIRE_MARGIN.            |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``:expire_margin``        | Tokens will be generated if time > EXPIRE_TIME - EXPIRE_MARGIN                                                                                                          |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

In the default configuration, the OneFlow server will only listen to requests coming from ``localhost`` (which is enough to control OneFlow over Sunstone running on the same host). If you want to control OneFlow over API/CLI remotely, you need to change ``:host`` parameter in ``/etc/one/oneflow-server.conf`` to a public IP of your Front-end host or to ``0.0.0.0`` (to work on all IP addresses configured on Host).

.. _oneflow_conf_sunstone:

Configure Sunstone
------------------

Sunstone GUI enables end-users to access the OneFlow from the UI and it directly connects to OneFlow on their behalf. Sunstone has configured the OneFlow endpoint it connects to in ``/etc/one/fireedge-server.conf`` in parameter ``:oneflow_server``. When OneFlow is running on a different host than Sunstone, the endpoint in Sunstone must be configured appropriately.

Sunstone tabs for OneFlow (*Services* and *Service Templates*) are enabled in Sunstone by default. To customize visibility for different types of users, follow the :ref:`Sunstone Views <fireedge_suns_views>` documentation.

Configure CLI
-------------

OneFlow CLI (``oneflow`` and ``oneflow-template``) uses same credentials as other :ref:`command-line tools <cli>`. The login and password are taken from the file referenced by environment variable ``$ONE_AUTH`` (defaults to ``$HOME/.one/one_auth``). Remote endpoint and (optionally) distinct user/password access to the above is configured in environment variable ``$ONEFLOW_URL`` (defaults to ``http://localhost:2474``), ``$ONEFLOW_USER`` and ``$ONEFLOW_PASSWORD``.

Example:

.. prompt:: bash $ auto

    $ ONEFLOW_URL=http://one.example.com:2474 oneflow list

See more in :ref:`Managing Users documentation<manage_users_shell>`.

.. _oneflow_conf_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula-flow``.

To start, restart or stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-flow
    # systemctl restart opennebula-flow
    # systemctl stop    opennebula-flow

To enable or disable automatic start on Host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-flow
    # systemctl disable opennebula-flow

Server **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/oneflow.log``
- ``/var/log/one/oneflow.error``

Logs of individual multi-VM Services managed by OneFlow can be found in

- ``/var/log/one/oneflow/$ID.log`` where ``$ID`` identifies the service

Other logs are also available in Journald. Use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula-flow.service

Advanced Setup
==============

Permission to Create Services
-----------------------------

*Documents* are special types of resources in OpenNebula used by OneFlow to store *Service Templates* and information about *Services*. When a new user Group is created, you can decide if you want to allow/deny its users to create *Documents* (and also OneFlow Services). By default, :ref:`new groups <manage_groups>` are allowed to create Document resources.
