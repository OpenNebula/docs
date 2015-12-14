.. _sunstone:

=================================================
OpenNebula Sunstone: The Cloud Operations Center
=================================================

OpenNebula Sunstone is the OpenNebula Cloud Operations Center, a Graphical User Interface (GUI) intended for regular users and administrators that simplifies the typical management operations in private and hybrid cloud infrastructures. OpenNebula Sunstone allows to easily manage all OpenNebula resources and perform typical operations on them.

OpenNebula Sunstone can be adapted to different user roles. For example, it will only show the resources the users have access to. Its behaviour can be customized and extended via :ref:`views <suns_views>`.

|admin_view|

Requirements
============

You must have an OpenNebula site properly configured and running to use OpenNebula Sunstone, be sure to check the :ref:`OpenNebula Installation and Configuration Guides <design_and_installation_guide>` to set up your private cloud first. This guide also assumes that you are familiar with the configuration and use of OpenNebula.

OpenNebula Sunstone was installed during the OpenNebula installation. If you followed the :ref:`installation guide <ignc>` then you already have all ruby gem requirements. Otherwise, run the ``install_gem`` script as root:

.. code::

    # /usr/share/one/install_gems sunstone

.. _remote_access_sunstone:

The Sunstone Operation Center offers the possibility of starting a VNC/SPICE session to a Virtual Machine. This is done by using a VNC/SPICE websocket-based client (noVNC) on the client side and a VNC proxy translating and redirecting the connections on the server-side.

.. warning:: The SPICE Web client is a prototype and is limited in function. More information of this component can be found in the following `link <http://www.spice-space.org/page/Html5>`__

Requirements:

-  Websockets-enabled browser (optional): Firefox and Chrome support websockets. In some versions of Firefox manual activation is required. If websockets are not enabled, flash emulation will be used.
-  Start the novnc-server included with OpenNebula, both VNC and SPICE use this server as they have no built in support for the WebSocket protocol.
-  Installing the python-numpy package is recommended for a better vnc performance.

Considerations & Limitations
============================

OpenNebula Sunstone supports Internet Explorer (>= 9), Firefox (> 3.5) and Chrome browsers. Oher browsers are not supported and may not work well.

.. warning:: Internet Explorer is **not** supported with the Compatibility Mode enabled, since it emulates IE7 which is not supported.

The upload option for files and images is limited to Firefox 4+ and Chrome 11+.

Configuration
=============

.. _sunstone_connect_oneflow:

Cannot connect to OneFlow server
-----------------------------------------------

The last two tabs, OneFlow Services and Templates, will show the following message:

    Cannot connect to OneFlow server

You need to start the OneFlow component :ref:`following this guide <appflow_configure>`, or disable these two menu entries in the ``admin.yaml`` and ``user.yaml`` :ref:`sunstone views <suns_views>`.

.. _sunstone_sunstone_server_conf:

sunstone-server.conf
--------------------

Sunstone configuration file can be found at ``/etc/one/sunstone-server.conf``. It uses YAML syntax to define some options:

Available options are:

+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
|           Option          |                                                                                                                                              Description                                                                                                                                               |   |
+===========================+========================================================================================================================================================================================================================================================================================================+===+
| :tmpdir                   | Uploaded images will be temporally stored in this folder before being copied to OpenNebula                                                                                                                                                                                                             |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :one\_xmlrpc              | OpenNebula daemon host and port                                                                                                                                                                                                                                                                        |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :host                     | IP address on which the server will listen on. ``0.0.0.0`` for everyone. ``127.0.0.1`` by default.                                                                                                                                                                                                     |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :port                     | Port on which the server will listen. ``9869`` by default.                                                                                                                                                                                                                                             |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :sessions                 | Method of keeping user sessions. It can be ``memory`` or ``memcache``. For server that spawn more than one process (like Passenger or Unicorn) ``memcache`` should be used                                                                                                                             |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :memcache\_host           | Host where ``memcached`` server resides                                                                                                                                                                                                                                                                |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :memcache\_port           | Port of ``memcached`` server                                                                                                                                                                                                                                                                           |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :memcache\_namespace      | memcache namespace where to store sessions. Useful when ``memcached`` server is used by more services                                                                                                                                                                                                  |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :debug\_level             | Log debug level: 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                                                                                                                                                                                                                           |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :env                      | Excution environment for Sunstone. ``dev``, Instead of pulling the minified js all the files will be pulled (app/main.js). Check the :ref:`Building from Source <compile>` guide in the docs, for details on how to run Sunstone in development. ``prod``, the minified js will be used (dist/main.js) |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :auth                     | Authentication driver for incoming requests. Possible values are ``sunstone``, ``opennebula``, ``remote`` and ``x509``. Check :ref:`authentication methods <authentication>` for more info                                                                                                             |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :core\_auth               | Authentication driver to communicate with OpenNebula core. Possible values are ``x509`` or ``cipher``. Check :ref:`cloud\_auth <cloud_auth>` for more information                                                                                                                                      |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :lang                     | Default language for the Sunstone interface. This is the default language that will be used if user has not defined a variable LANG with a different valid value its user template                                                                                                                     |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_proxy\_port         | Base port for the VNC proxy. The proxy will run on this port as long as Sunstone server does. ``29876`` by default.                                                                                                                                                                                    |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_proxy\_support\_wss | ``yes``, ``no``, ``only``. If enabled, the proxy will be set up with a certificate and a key to use secure websockets. If set to ``only`` the proxy will only accept encrypted connections, otherwise it will accept both encrypted or unencrypted ones.                                               |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_proxy\_cert         | Full path to certificate file for wss connections.                                                                                                                                                                                                                                                     |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_proxy\_key          | Full path to key file. Not necessary if key is included in certificate.                                                                                                                                                                                                                                |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_proxy\_ipv6         | Enable ipv6 for novnc. (true or false)                                                                                                                                                                                                                                                                 |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :vnc\_request\_password   | Request VNC password for external windows, by default it will not be requested (true or false)                                                                                                                                                                                                         |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :table\_order             | Default table order, resources get ordered by ID in ``asc`` or ``desc`` order.                                                                                                                                                                                                                         |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :marketplace\_username    | Username credential to connect to the Marketplace.                                                                                                                                                                                                                                                     |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :marketplace\_password    | Password to connect to the Marketplace.                                                                                                                                                                                                                                                                |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :marketplace\_url         | Endpoint to connect to the Marketplace. If commented, a 503 ``service unavailable`` error will be returned to clients.                                                                                                                                                                                 |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :oneflow\_server          | Endpoint to connect to the OneFlow server.                                                                                                                                                                                                                                                             |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :routes                   | List of files containing custom routes to be loaded. Check :ref:`server plugins <sunstone_dev>` for more info.                                                                                                                                                                                         |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+
| :instance_types           | Default instace types for Cloud View `Instance Types for Cloud View`_                                                                                                                                                                                                                                  |   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---+


.. warning:: In order to access Sunstone from other place than ``localhost`` you need to set the server's public IP in the ``:host`` option. Otherwise it will not be reachable from the outside.

Starting Sunstone
-----------------

To start Sunstone just issue the following command as oneadmin

.. code::

    $ sunstone-server start

You can find the Sunstone server log file in ``/var/log/one/sunstone.log``. Errors are logged in ``/var/log/one/sunstone.error``.

To stop the Sunstone service:

.. code::

    $ sunstone-server stop

VNC Troubleshooting
-------------------

There can be multiple reasons that may prevent noVNC from correctly connecting to the machines. Here's a checklist of common problems:

-  noVNC requires Python >= 2.5 for the websockets proxy to work. You may also need additional modules as python2<version>-numpy.

-  You can retrieve useful information from ``/var/log/one/novnc.log``

-  You must have a ``GRAPHICS`` section in the VM template enabling VNC, as stated in the documentation. Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow connections from everywhere), otherwise, no connections will be allowed from the outside.

-  Your browser must support websockets, and have them enabled. This is the default in latest Chrome and Firefox, but former versions of Firefox (i.e. 3.5) required manual activation. Otherwise Flash emulation will be used.

-  Make sure there are not firewalls blocking the connections. The proxy will redirect the websocket data from the VNC proxy port to the ``VNC`` port stated in the template of the VM. The value of the proxy port is defined in ``sunstone-server.conf``.

-  Make sure that you can connect directly from Sunstone frontend to the VM using a normal VNC client tools such as ``vncviewer``.

-  When using secure websockets, make sure that your certificate and key (if not included in certificate), are correctly set in Sunstone configuration files. Note that your certificate must be valid and trusted for the wss connection to work. If you are working with a certicificate that it is not accepted by the browser, you can manually add it to the browser trust-list visiting ``https://sunstone.server.address:vnc_proxy_port``. The browser will warn that the certificate is not secure and prompt you to manually trust it.

-  If your connection is very, very, very slow, there might be a token expiration issue. Please try the manual proxy launch as described below to check it.

-  Doesn't work yet? Try launching Sunstone, killing the websockify proxy and relaunching the proxy manually in a console window with the command that is logged at the beginning of ``/var/log/one/novnc.log``. You must generate a lock file containing the PID of the python process in ``/var/lock/one/.novnc.lock`` Leave it running and click on the VNC icon on Sunstone for the same VM again. You should see some output from the proxy in the console and hopefully the cause of why the connection does not work.

-  Please contact the user list only when you have gone through the suggestion above and provide full sunstone logs, shown errors and any relevant information of your infraestructure (if there are Firewalls etc)

- The message "SecurityError: The operation is insecure." is usually related to a Same-Origin-Policy problem.  If you have Sunstone TLS secured and try to connect to an insecure websocket for VNC, Firefox blocks that. For Firefox, you need to have both connections secured to not get this error. And don't use a self-signed certificate for the server, this would raise the error again (you can setup your own little CA, that works, but don't use a self-signed server certificate). The other option would be to go into the Firefox config (about:config) and set "network.websocket.allowInsecureFromHTTPS" to "true".

.. _sunstone_instance_types:

Instance Types for Cloud View
-----------------------------

These are the default instance types for the Cloud View, these types are presented in the cloud view to customize VM Templates and they can be customized to meet your requirements. Each type is defined by:

* name: the name of the type
* cpu: capacity allocated to the VM for scheduling purposes
* vcpu: number of cores
* memory: in MB for the VM
* description: to help the user pick one, it may include purpose or price.

.. code::

    :instance_types:
        - :name: small-x1
          :cpu: 1
          :vcpu: 1
          :memory: 128
          :description: Very small instance for testing purposes
        - :name: small-x2
          :cpu: 2
          :vcpu: 2
          :memory: 512
          :description: Small instance for testing multi-core applications
        - :name: medium-x2
          :cpu: 2
          :vcpu: 2
          :memory: 1024
          :description: General purpose instance for low-load servers
        - :name: medium-x4
          :cpu: 4
          :vcpu: 4
          :memory: 2048
          :description: General purpose instance for medium-load servers
        - :name: large-x4
          :cpu: 4
          :vcpu: 4
          :memory: 4096
          :description: General purpose instance for servers
        - :name: large-x8
          :cpu: 8
          :vcpu: 8
          :memory: 8192
          :description: General purpose instance for high-load servers

.. _commercial_support_sunstone:

Commercial Support Integration
==============================

We are aware that in production environments, access to professional, efficient support is a must, and this is why we have introduced an integrated tab in Sunstone to access `OpenNebula Systems <http://opennebula.systems>`__ (the company behind OpenNebula, formerly C12G) professional support. In this way, support ticket management can be performed through Sunstone, avoiding disruption of work and enhancing productivity.

|support_home|

This tab and can be disabled in the ``admin``, ``admin_vcenter`` and ``user`` yaml files inside the sunstone views configuration directory:

.. code-block:: yaml

    enabled_tabs:
        - dashboard-tab
        - system-tab
        - users-tab
        - groups-tab
        - acls-tab
        - vresources-tab
        - vms-tab
        - templates-tab
        - images-tab
        - files-tab
        - infra-tab
        #- clusters-tab
        - hosts-tab
        - datastores-tab
        - vnets-tab
        - marketplace-tab
        - oneflow-dashboard
        - oneflow-services
        - oneflow-templates
        - zones-tab
        #- support-tab

Tuning & Extending
==================

For more information on how to customize and extend you Sunstone deployment use the following links:

-  :ref:`Sunstone Views <suns_views>`, different roles different views.
-  :ref:`Security & Authentication Methods <suns_auth>`, improve security with x509 authentication and SSL
-  :ref:`Advanced Deployments <suns_advance>`, improving scalability and isolating the server

.. |admin_view| image:: /images/admin_view.png
.. |support_home| image:: /images/support_home.png
