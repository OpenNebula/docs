.. _fireedge_setup:
.. _fireedge_configuration:
.. _fireedge_conf:

================================================================================
FireEdge Configuration
================================================================================

The OpenNebula FireEdge server provides a **next-generation web-management interface** for remote OpenNebula Cluster provisioning (OneProvision GUI) as well as additional functionality to Sunstone. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-fireedge`` with the system service ``opennebula-fireedge``.

Features:

- **OneProvision GUI**, to manage deployments of fully operational Clusters on remote Edge Cloud providers. See :ref:`Provisioning an Edge Cluster <first_edge_cluster>`.
- **VMRC and Guacamole Proxy** for Sunstone to remotely access the VMs (incl., VNC, RDP, and SSH).

.. warning:: FireEdge currently doesn't support :ref:`federated environments <federation>`. It can interact only with a local OpenNebula instance (even if it's federated), but can't interact with remote, federated OpenNebula instances.

.. _fireedge_install_configuration:

Configuration
================================================================================

The FireEdge configuration file can be found in ``/etc/one/fireedge-server.conf`` on your Front-end. It uses **YAML** syntax with following parameters:

.. note::

    After a configuration change, the FireEdge server must be :ref:`restarted <fireedge_conf_service>` to take effect.

+-------------------------------------------+--------------------------------+----------------------------------------------------+
| Parameter                                 | Default Value                  | Description                                        |
+===========================================+================================+====================================================+
| ``log``                                   | ``prod``                       | Log debug: ``prod`` or ``dev``                     |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``cors``                                  | ``true``                       | Enable CORS (cross-origin resource sharing)        |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``host``                                  | ``0.0.0.0``                    | Host on which the FireEdge server will listen      |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``port``                                  | ``2616``                       | Port on which the FireEdge server will listen      |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``one_xmlrpc``                            | ``http://localhost:2633/RPC2`` | Endpoint of OpenNebula XML-RPC API                 |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``oneflow_server``                        | ``http://localhost:2472``      | Endpoint of OneFlow server                         |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``limit_token/min``                       | ``14``                         | JWT minimum expiration time (days)                 |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``limit_token/max``                       | ``30``                         | JWT maximum expiration time (days)                 |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``oneprovision_prepend_command``          |                                | Command prefix for ``oneprovision`` command        |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``oneprovision_optional_create_command``  |                                | Optional param. for ``oneprovision create`` cmd.   |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``guacd/port``                            | ``4822``                       | Connection port of guacd server                    |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``guacd/host``                            | ``127.0.0.1``                  | Connection hostname/IP of guacd server             |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``langs``                                 |                                | List of server localizations                       |
+-------------------------------------------+--------------------------------+----------------------------------------------------+

Once the server is initialized, it creates the file ``/var/lib/one/.one/fireedge_key``.

.. _fireedge_in_ha:

In HA environments, this file fireedge_key needs to be copied from the first leader to the followers. Optionally, in order to have the provision logs available in all the HA nodes, ``/var/lib/one/fireedge`` need to be shared between nodes.

.. _fireedge_configuration_for_sunstone:

Configure Sunstone
------------------

.. note::

    After a configuration change, the Sunstone server must be :ref:`restarted <sunstone_conf_service>` to take effect.

You need to configure Sunstone with the public endpoint of FireEdge so that one service can redirect users to the other. To configure the public FireEdge endpoint in Sunstone, edit ``/etc/one/sunstone-server.conf`` and update the ``:public_fireedge_endpoint`` with the base URL (domain or IP-based) over which end-users can access the service. For example:

.. code::

    :public_fireedge_endpoint: http://one.example.com:2616

.. hint::

    If you aren't planning to use FireEdge, you can disable it in Sunstone by commenting out the following parameters in ``/etc/one/sunstone-server.conf``, e.g.:

    .. code::

        #:private_fireedge_endpoint: http://localhost:2616
        #:public_fireedge_endpoint: http://localhost:2616

.. _fireedge_conf_guacamole:

Configure Guacamole
-------------------

FireEdge uses `Apache Guacamole <guacamole.apache.org>`__, a free and open source web application that allows you to access a remote console or desktop of the Virtual Machine anywhere using a modern web browser. It is a clientless **remote desktop gateway** which only requires Guacamole installed on a server and a web browser supporting HTML5.

Guacamole supports multiple connection methods such as **VNC, RDP, and SSH** and is made up of two separate parts - server and client. The Guacamole server consists of the native server-side libraries required to connect to the server and the Guacamole proxy daemon (``guacd``), which accepts the user's requests and connects to the remote desktop on their behalf.

.. note::

    The OpenNebula **binary packages** provide Guacamole proxy daemon (package ``opennebula-guacd`` and service ``opennebula-guacd``), which is installed alongside FireEdge. In the default configuration, the Guacamole proxy daemon is automatically started along with FireEdge, and FireEdge is configured to connect to the locally-running Guacamole.

    No extra steps are required!

If Guacamole is running on a different host to the FireEdge, following FireEdge configuration parameters has to be customized:

- ``guacd/host``
- ``guacd/port``

.. _fireedge_conf_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula-fireedge``.

To start, restart or stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-fireedge
    # systemctl restart opennebula-fireedge
    # systemctl stop    opennebula-fireedge

To enable or disable automatic start on host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-fireedge
    # systemctl disable opennebula-fireedge

Server **logs** are located in ``/var/log/one`` in the following files:

- ``/var/log/one/fireedge.log`` - operational log,
- ``/var/log/one/fireedge.error`` - log of errors/exceptions.

Other logs are also available in Journald. Use the following command to show them:

.. prompt:: bash # auto

    # journalctl -u opennebula-fireedge.service

Troubleshooting
===============

Conflicting Port
----------------

A common issue when launching FireEdge is an occupied port:

.. code:: bash

    Error: listen EADDRINUSE: address already in use 0.0.0.0:2616

If another service is using the port, you can change FireEdge configuration (``/etc/one/fireedge-server.conf``) to use another host/port. Remember to also adjust the FireEdge endpoints in Sunstone configuration (``/etc/one/sunstone-server.conf``) as well.
