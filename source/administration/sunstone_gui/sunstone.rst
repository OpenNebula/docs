.. _sunstone:

=================================================
OpenNebula Sunstone: The Cloud Operations Center
=================================================

OpenNebula Sunstone is the OpenNebula Cloud Operations Center, a Graphical User Interface (GUI) intended for regular users and administrators that simplifies the typical management operations in private and hybrid cloud infrastructures. OpenNebula Sunstone allows to easily manage all OpenNebula resources and perform typical operations on them.

OpenNebula Sunstone can be adapted to different user roles. For example, it will only show the resources the users have access to. Its behaviour can be customized and extended via :ref:`views <suns_views>`.

|image0|

Requirements
============

You must have an OpenNebula site properly configured and running to use OpenNebula Sunstone, be sure to check the :ref:`OpenNebula Installation and Configuration Guides <design_and_installation_guide>` to set up your private cloud first. This guide also assumes that you are familiar with the configuration and use of OpenNebula.

OpenNebula Sunstone was installed during the OpenNebula installation. If you followed the :ref:`installation guide <ignc>` then you already have all ruby gem requirements. Otherwise, run the ``install_gem`` script as root:

.. code::

    # /usr/share/one/install_gems sunstone

The Sunstone Operation Center offers the possibility of starting a VNC session to a Virtual Machine. This is done by using a VNC websocket-based client (noVNC) on the client side and a VNC proxy translating and redirecting the connections on the server-side.

Requirements:

-  Websockets-enabled browser (optional): Firefox and Chrome support websockets. In some versions of Firefox manual activation is required. If websockets are not enabled, flash emulation will be used.
-  Installing the python-numpy package is recommended for a better vnc performance.

Considerations & Limitations
============================

OpenNebula Sunstone supports Firefox (> 3.5) and Chrome browsers. Internet Explorer, Opera and others are not supported and may not work well.

Configuration
=============

sunstone-server.conf
--------------------

Sunstone configuration file can be found at ``/etc/one/sunstone-server.conf``. It uses YAML syntax to define some options:

Available options are:

+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|           Option          |                                                                                                                       Description                                                                                                                        |
+===========================+==========================================================================================================================================================================================================================================================+
| :tmpdir                   | Uploaded images will be temporally stored in this folder before being copied to OpenNebula                                                                                                                                                               |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :one\_xmlrpc              | OpenNebula daemon host and port                                                                                                                                                                                                                          |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :host                     | IP address on which the server will listen on. ``0.0.0.0`` for everyone. ``127.0.0.1`` by default.                                                                                                                                                       |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :port                     | Port on which the server will listen. ``9869`` by default.                                                                                                                                                                                               |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :sessions                 | Method of keeping user sessions. It can be ``memory`` or ``memcache``. For server that spawn more than one process (like Passenger or Unicorn) ``memcache`` should be used                                                                               |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :memcache\_host           | Host where ``memcached`` server resides                                                                                                                                                                                                                  |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :memcache\_port           | Port of ``memcached`` server                                                                                                                                                                                                                             |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :memcache\_namespace      | memcache namespace where to store sessions. Useful when ``memcached`` server is used by more services                                                                                                                                                    |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :debug\_level             | Log debug level: 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                                                                                                                                                                             |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :auth                     | Authentication driver for incoming requests. Possible values are ``sunstone``, ``opennebula`` and ``x509``. Check :ref:`authentication methods <authentication>` for more info                                                                           |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :core\_auth               | Authentication driver to communicate with OpenNebula core. Possible values are ``x509`` or ``cipher``. Check :ref:`cloud\_auth <cloud_auth>` for more information                                                                                        |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :lang                     | Default language for the Sunstone interface. This is the default language that will be used if user has not defined a variable LANG with a different valid value its user template                                                                       |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_port         | Base port for the VNC proxy. The proxy will run on this port as long as Sunstone server does. ``29876`` by default.                                                                                                                                      |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_support\_wss | ``yes``, ``no``, ``only``. If enabled, the proxy will be set up with a certificate and a key to use secure websockets. If set to ``only`` the proxy will only accept encrypted connections, otherwise it will accept both encrypted or unencrypted ones. |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_cert         | Full path to certificate file for wss connections.                                                                                                                                                                                                       |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_key          | Full path to key file. Not necessary if key is included in certificate.                                                                                                                                                                                  |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_ipv6         | Enable ipv6 for novnc. (true or false)                                                                                                                                                                                                                   |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :table\_order             | Default table order, resources get ordered by ID in ``asc`` or ``desc`` order.                                                                                                                                                                           |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :marketplace\_username    | Username credential to connect to the Marketplace.                                                                                                                                                                                                       |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :marketplace\_password    | Password to connect to the Marketplace.                                                                                                                                                                                                                  |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :marketplace\_url         | Endpoint to connect to the Marketplace. If commented, a 503 ``service unavailable`` error will be returned to clients.                                                                                                                                   |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :oneflow\_server          | Endpoint to connect to the OneFlow server.                                                                                                                                                                                                               |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :routes                   | List of files containing custom routes to be loaded. Check :ref:`server plugins <sunstone_server_plugin_guide>` for more info.                                                                                                                           |
+---------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. warning:: In order to access Sunstone from other place than ``localhost`` you need to set the server's public IP in the ``:host`` option. Otherwise it will not be reachable from the outside.

.. todo:: Running Sunstone Server separate host.

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

-  Make sure that you have not checked the ``Secure websockets connection`` in the Configuration dialog if your proxy has not been configured to support them. Connection will fail if so.

-  If your connection is very, very, very slow, there might be a token expiration issue. Please try the manual proxy launch as described below to check it.

-  Doesn't work yet? Try launching Sunstone, killing the websockify proxy and relaunching the proxy manually in a console window with the command that is logged at the beginning of ``/var/log/one/novnc.log``. You must generate a lock file containing the PID of the python process in ``/var/lock/one/.novnc.lock`` Leave it running and click on the VNC icon on Sunstone for the same VM again. You should see some output from the proxy in the console and hopefully the cause of why the connection does not work.

-  Please contact the user list only when you have gone through the suggestion above and provide full sunstone logs, shown errors and any relevant information of your infraestructure (if there are Firewalls etc)

Tuning & Extending
==================

For more information on how to customize and extend you Sunstone deployment use the following links:

-  :ref:`Sunstone Views <suns_views>`, different roles different views.
-  :ref:`Security & Authentication Methods <suns_auth>`, improve security with x509 authentication and SSL
-  :ref:`Advanced Deployments <suns_advance>`, improving scalability and isolating the server

.. |image0| image:: /images/sunstonedash4.png
