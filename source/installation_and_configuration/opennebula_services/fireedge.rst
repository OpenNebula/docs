.. _fireedge_setup:
.. _fireedge_configuration:
.. _fireedge_conf:

================================================================================
FireEdge Configuration
================================================================================

The OpenNebula FireEdge server provides a **next-generation web-management interface** for remote OpenNebula Cluster provisioning (OneProvision GUI) as well as additional functionality to Sunstone. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-fireedge`` with the system service ``opennebula-fireedge``.

Main Features
--------------------------------------------------------------------------------

- **VMRC and Guacamole Proxy** for Sunstone to remotely access the VMs (incl., VNC, RDP, and SSH)
- **OneProvision GUI**: to manage deployments of fully operational Clusters on remote Edge Cloud providers, see :ref:`Provisioning an Edge Cluster <first_edge_cluster>`. Accessible from the following URL:

.. code::

    http://<OPENNEBULA-FRONTEND>:2616/fireedge/provision


- **FireEdge Sunstone**: new iteration of Sunstone written in React/Redux. Accessible through the following URL:

.. code::

    http://<OPENNEBULA-FRONTEND>:2616


.. warning:: FireEdge currently doesn't support :ref:`federated environments <federation>`. It can interact only with a local OpenNebula instance (even if it's federated), but can't interact with remote, federated OpenNebula instances.

.. _fireedge_install_configuration:

Configuration
================================================================================

The FireEdge server configuration file can be found in ``/etc/one/fireedge-server.conf`` on your Front-end. It uses **YAML** syntax with following parameters:

.. note::

    After a configuration change, the FireEdge server must be :ref:`restarted <fireedge_conf_service>` to take effect.

+-------------------------------------------+--------------------------------+----------------------------------------------------+
| Parameter                                 | Default Value                  | Description                                        |
+===========================================+================================+====================================================+
| ``log``                                   | ``prod``                       | Log debug: ``prod`` or ``dev``                     |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``cors``                                  | ``true``                       | Enable CORS (cross-origin resource sharing)        |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``host``                                  | ``0.0.0.0``                    | IP on which the FireEdge server will listen        |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``port``                                  | ``2616``                       | Port on which the FireEdge server will listen      |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``one_xmlrpc``                            | ``http://localhost:2633/RPC2`` | Endpoint of OpenNebula XML-RPC API. It needs to    |
|                                           |                                | match the **ENDPOINT** attribute of                |
|                                           |                                | ``onezone show 0``                                 |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``oneflow_server``                        | ``http://localhost:2474``      | Endpoint of OneFlow server                         |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``session_expiration``                    | ``180``                        | JWT expiration time (minutes)                      |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``session_remember_expiration``           | ``3600``                       | JWT expiration time when using remember check box  |
|                                           |                                | (minutes)                                          |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``minimun_opennebula_expiration``         | ``30``                         | Minimum time to reuse previously generated JWTs    |
|                                           |                                | (minutes)                                          |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``subscriber_endpoint``                   | ``tcp://localhost:2101``       | Endpoint to subscribe for OpenNebula events        |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``debug_level``                           | ``2``                          | Log debug level                                    |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``guacd/port``                            | ``4822``                       | Connection port of guacd server                    |
+-------------------------------------------+--------------------------------+----------------------------------------------------+
| ``guacd/host``                            | ``localhost``                  | Connection hostname/IP of guacd server             |
+-------------------------------------------+--------------------------------+----------------------------------------------------+

.. note:: JWT is acronime of JSON Web Token

.. _oneprovision_configuration:

**OneProvision GUI**

|oneprovision_dashboard|

+-------------------------------------------+--------------------------------+------------------------------------------------------------+
| Parameter                                 | Default Value                  | Description                                                |
+===========================================+================================+============================================================+
| ``oneprovision_prepend_command``          |                                | Command prefix for ``oneprovision`` command                |
+-------------------------------------------+--------------------------------+------------------------------------------------------------+
| ``oneprovision_optional_create_command``  |                                | Optional options for ``oneprovision create`` command.      |
|                                           |                                | Check ``oneprovision create --help`` for more information. |
+-------------------------------------------+--------------------------------+------------------------------------------------------------+

.. _fireedge_sunstone_configuration:

**FireEdge Sunstone**

|fireedge_sunstone_dashboard|

+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| Parameter                                 | Default Value                             | Description                                          |
+===========================================+===========================================+======================================================+
| ``support_url``                           | ``https://opennebula.zendesk.com/api/v2`` | Zendesk support URL                                  |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``token_remote_support``                  |                                           | Support enterprise token                             |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``vcenter_prepend_command``               |                                           | Command prefix for ``onevcenter`` command            |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``sunstone_prepend``                      |                                           | Optional parameter for ``Sunstone commands`` command |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``tmpdir``                                | ``/var/tmp``                              | Directory to store temporal files when uploading     |
|                                           |                                           | images                                               |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``max_upload_file_size``                  | ``20000``                                 | Max size upload file (bytes)                         |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``proxy``                                 |                                           | Enable an http proxy for the support portal and      |
|                                           |                                           | to download MarketPlaceApps                          |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``leases``                                |                                           | Enable the vm leases                                 |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``supported_fs``                          |                                           | Support filesystem                                   |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``currency``                              | ``EUR``                                   | Currency formatting                                  |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``default_lang``                          | ``en``                                    | Default language setting                             |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``langs``                                 |                                           | List of server localizations                         |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+
| ``keep_me_logged_in``                     | ``true``                                  | True to display 'Keep me logged in' option           |
+-------------------------------------------+-------------------------------------------+------------------------------------------------------+

Once the server is initialized, it creates the file ``/var/lib/one/.one/fireedge_key``, used to encrypt communications with Guacd.

.. _fireedge_in_ha:

In HA environments, ``fireedge_key`` needs to be copied from the first leader to the followers. Optionally, in order to have the provision logs available in all the HA nodes, ``/var/lib/one/fireedge`` need to be shared between nodes.

.. _fireedge_ssl_without_nginx:

If you need to execute the FireEdge with SSL Certificate, in the following path: ``/usr/lib/one/fireedge`` you must create a folder called ``cert`` and inside it place the files ``cert.pem`` and ``key.pem``. After doing that you need to restart ``opennebula-fireedge``.

.. _fireedge_configuration_for_sunstone:

Configure Sunstone for VMRC and Guacamole
--------------------------------------------------------------------------------

.. note::

    After a configuration change, the Sunstone server must be :ref:`restarted <sunstone_conf_service>` to take effect.

In order for Sunstone (not FireEdge Sunstone, but rather the current Sunstone, with full admin functionality) to allow VMRC and Guacamole VNC/RDP/SSH access, you need to configure Sunstone with the public endpoint of FireEdge so that one service can redirect users to the other. To configure the public FireEdge endpoint in Sunstone, edit ``/etc/one/sunstone-server.conf`` and update the ``:public_fireedge_endpoint`` with the base URL (domain or IP-based) over which end-users can access the service. For example:

.. code::

    :public_fireedge_endpoint: http://one.example.com:2616

.. hint::

    If you aren't planning to use FireEdge, you can disable it in Sunstone by commenting out the following parameters in ``/etc/one/sunstone-server.conf``, e.g.:

    .. code::

        #:private_fireedge_endpoint: http://localhost:2616
        #:public_fireedge_endpoint: http://localhost:2616

.. warning:: FireEdge currently doesn't support :ref:`X.509 Authentication <x509_auth>`.

.. _fireedge_conf_guacamole:

Configure Guacamole
--------------------------------------------------------------------------------

FireEdge uses `Apache Guacamole <http://guacamole.apache.org>`__, a free and open source web application that allows you to access a remote console or desktop of the Virtual Machine anywhere using a modern web browser. It is a clientless **remote desktop gateway** which only requires Guacamole installed on a server and a web browser supporting HTML5.

Guacamole supports multiple connection methods such as **VNC, RDP, and SSH** and is made up of two separate parts - server and client. The Guacamole server consists of the native server-side libraries required to connect to the server and the Guacamole proxy daemon (``guacd``), which accepts the user's requests and connects to the remote desktop on their behalf.

.. note::

    The OpenNebula **binary packages** provide Guacamole proxy daemon (package ``opennebula-guacd`` and service ``opennebula-guacd``), which is installed alongside FireEdge. In the default configuration, the Guacamole proxy daemon is automatically started along with FireEdge, and FireEdge is configured to connect to the locally-running Guacamole. No extra steps are required!

If Guacamole is running on a different host to the FireEdge, following FireEdge configuration parameters have to be customized:

- ``guacd/host``
- ``guacd/port``

.. _fireedge_conf_service:

Service Control and Logs
================================================================================

Change the server running state by managing the operating system service ``opennebula-fireedge``.

To start, restart or stop the server, execute one of:

.. prompt:: bash $ auto

    $ systemctl start   opennebula-fireedge
    $ systemctl restart opennebula-fireedge
    $ systemctl stop    opennebula-fireedge

To enable or disable automatic start on host boot, execute one of:

.. prompt:: bash $ auto

    $ systemctl enable  opennebula-fireedge
    $ systemctl disable opennebula-fireedge

Server **logs** are located in ``/var/log/one`` in the following file:

- ``/var/log/one/fireedge.log``: operational log.
- ``/var/log/one/fireedge.error``: errors and exceptions log.

Other logs are also available in Journald. Use the following command to show them:

.. prompt:: bash $ auto

    $ journalctl -u opennebula-fireedge.service

Troubleshooting
================================================================================

Conflicting Port
--------------------------------------------------------------------------------

A common issue when starting FireEdge is a used port:

.. code:: bash

    Error: listen EADDRINUSE: address already in use 0.0.0.0:2616

If another service is using the port, you can change FireEdge configuration (``/etc/one/fireedge-server.conf``) to use another host/port. Remember to also adjust the FireEdge endpoints in Sunstone configuration (``/etc/one/sunstone-server.conf``) as well.

.. |oneprovision_dashboard| image:: /images/oneprovision_dashboard.png
.. |fireedge_sunstone_dashboard| image:: /images/fireedge_sunstone_dashboard.png
