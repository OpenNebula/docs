.. _sunstone_setup:

=================================================
Sunstone Installation & Configuration
=================================================

Requirements
================================================================================

You must have an OpenNebula site properly configured and running to use OpenNebula Sunstone. Be sure to check the :ref:`OpenNebula Installation and Configuration Guides <design_and_installation_guide>` to set up your private cloud first. This section also assumes that you are familiar with the configuration and use of OpenNebula.

OpenNebula Sunstone was installed during the OpenNebula installation. If you followed the :ref:`installation guide <ignc>` then you already have all ruby gem requirements. Otherwise, run the ``install_gem`` script as root:

.. prompt:: bash # auto

    # /usr/share/one/install_gems sunstone

.. _remote_access_sunstone:

The Sunstone Operation Center offers the possibility of starting a VNC/SPICE session to a Virtual Machine. This is done by using a VNC/SPICE websocket-based client (noVNC) on the client side and a VNC proxy translating and redirecting the connections on the server side.

.. warning:: The SPICE Web client is a prototype and is limited in function. More information of this component can be found in the following `link <http://www.spice-space.org/page/Html5>`__

.. warning:: Make sure that there is free space in sunstone's log directory or it will die silently. By default the log directory is ``/var/log/one``.

Requirements:

-  Websockets-enabled browser (optional): Firefox and Chrome support websockets. In some versions of Firefox manual activation is required. If websockets are not enabled, Flash emulation will be used.
-  Installing the python-numpy package is recommended for better VNC performance.


Configuration
================================================================================

.. _sunstone_sunstone_server_conf:

sunstone-server.conf
--------------------------------------------------------------------------------

The Sunstone configuration file can be found at ``/etc/one/sunstone-server.conf``. It uses YAML syntax to define some options:

Available options are:

+---------------------------+-----------------------------------------------------------------------------------------------+
|           Option          |                                          Description                                          |
+===========================+===============================================================================================+
| :tmpdir                   | Uploaded images will be temporally stored in this folder before being copied to OpenNebula    |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :one\_xmlrpc              | OpenNebula daemon host and port                                                               |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :one\_xmlrpc\_timeout     | Configure the timeout (seconds) for XMLRPC calls from sunstone.                               |
|                           | See :ref:`Shell Environment variables <manage_users>`                                         |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :host                     | IP address on which the server will listen. ``0.0.0.0`` by default.                           |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :port                     | Port on which the server will listen. ``9869`` by default.                                    |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :sessions                 | Method of keeping user sessions. It can be ``memory`` or ``memcache``. For servers that spawn |
|                           | more than one process (like Passenger or Unicorn) ``memcache`` should be used                 |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :memcache\_host           | Host where ``memcached`` server resides                                                       |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :memcache\_port           | Port of ``memcached`` server                                                                  |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :memcache\_namespace      | memcache namespace where to store sessions. Useful when ``memcached`` server is used by       |
|                           | more services                                                                                 |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :debug\_level             | Log debug level: 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                  |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :env                      | Execution environment for Sunstone. ``dev``, Instead of pulling the minified js all the       |
|                           | files will be pulled (app/main.js). Check the :ref:`Building from Source <compile>` guide     |
|                           | in the docs, for details on how to run Sunstone in development. ``prod``, the minified js     |
|                           | will be used (dist/main.js)                                                                   |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :max_upload_file_size     | Maximum allowed size of uploaded images (in bytes). Leave commented for unlimited size        |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :auth                     | Authentication driver for incoming requests. Possible values are ``sunstone``,                |
|                           | ``opennebula``, ``remote`` and ``x509``. Check :ref:`authentication methods <authentication>` |
|                           | for more info                                                                                 |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :core\_auth               | Authentication driver to communicate with OpenNebula core. Possible values are ``x509``       |
|                           | or ``cipher``. Check :ref:`cloud\_auth <cloud_auth>` for more information                     |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :encode_user_password     | For external authentication drivers, such as LDAP. Performs a URL encoding on the             |
|                           | credentials sent to OpenNebula, e.g. secret%20password. This only works with                  |
|                           | "opennebula" auth.                                                                            |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :lang                     | Default language for the Sunstone interface. This is the default language that will           |
|                           | be used if user has not defined a variable LANG with a different valid value in               |
|                           | user template                                                                                 |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_proxy\_port         | Base port for the VNC proxy. The proxy will run on this port as long as Sunstone server       |
|                           | does. ``29876`` by default. Could be prefixed with an address on which the sever will be      |
|                           | listening (ex: 127.0.0.1:29876).                                                              |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_proxy\_support\_wss | ``yes``, ``no``, ``only``. If enabled, the proxy will be set up with a certificate and        |
|                           | a key to use secure websockets. If set to ``only`` the proxy will only accept encrypted       |
|                           | connections, otherwise it will accept both encrypted or unencrypted ones.                     |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_proxy\_cert         | Full path to certificate file for wss connections.                                            |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_proxy\_key          | Full path to key file. Not necessary if key is included in certificate.                       |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_proxy\_ipv6         | Enable IPv6 for novnc. (true or false)                                                        |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_client\_port        | Port where the VNC JS client will connect.                                                    |
|                           | If not set, will use the port section of :vnc_proxy_port                                      |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :vnc\_request\_password   | Request VNC password for external windows. By default it will not be requested                |
|                           | (true or false)                                                                               |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :table\_order             | Default table order. Resources get ordered by ID in ``asc`` or ``desc`` order.                |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :marketplace\_username    | Username credential to connect to the Marketplace.                                            |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :marketplace\_password    | Password to connect to the Marketplace.                                                       |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :marketplace\_url         | Endpoint to connect to the Marketplace. If commented, a 503 ``service unavailable``           |
|                           | error will be returned to clients.                                                            |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :oneflow\_server          | Endpoint to connect to the OneFlow server.                                                    |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :routes                   | List of files containing custom routes to be loaded.                                          |
|                           | Check :ref:`server plugins <sunstone_dev>` for more info.                                     |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :mode                     | Default views directory.                                                                      |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :keep\_me\_logged         | True to display 'Keep me logged in' option in Sunstone login.                                 |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :get\_extended\_vm\_info  | True to display IP in table by requesting the extended vm pool to oned                        |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :allow\_vnc\_federation   | True to display VNC icons in federation                                                       |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :http\_proxy              | Proxy server for HTTP Traffic.                                                                |
+---------------------------+-----------------------------------------------------------------------------------------------+
| :no\_proxy                | Patterns for IP addresses or domain names that shouldn’t use the proxy                        |
+---------------------------+-----------------------------------------------------------------------------------------------+

.. note:: To use Sunstone with IPv6 only systems and thin HTTP sever, use the full IPv6 address in the field `:host`. If you need to set the localhost address (::1) or the unspecified address (::) please use the following:

          Example: :host: 0::1, :host: 0::0

.. note:: To use Sunstone with IPv6-only systems and thin HTTP sever, use the full IPv6 address in the field `:host`. If you need to set the localhost address (::1) or the unspecified address (::) please use the following:

          Example: :host: 0::1, :host: 0::0


Sunstone behavior can also be configured through the user template (within a SUNSTONE=[] vector value, for instance SUNSTONE=[TABLE_ORDER="asc"]):

+---------------------------+-------------------------------------------------------------------+
|           Option          |                            Description                            |
+---------------------------+-------------------------------------------------------------------+
| DISPLAY_NAME              | Name of the user that will appear in Sunstone                     |
+---------------------------+-------------------------------------------------------------------+
| TABLE_ORDER               | Asc (ascending) or Desc (descending)                              |
+---------------------------+-------------------------------------------------------------------+
| DEFAULT_VIEW              | Name of the default view (as appearing in                         |
|                           | ``/etc7on/sunstone-views``)                                       |
+---------------------------+-------------------------------------------------------------------+
| TABLE_DEFAULT_PAGE_LENGTH | Default length of Sunstone datatables' pages                      |
+---------------------------+-------------------------------------------------------------------+
| LANG                      | Sunstone language (defaults to en_US)                             |
+---------------------------+-------------------------------------------------------------------+
| DEFAULT_ZONE_ENDPOINT     | Default zone at Sunstone login. Defaults to the local zone        |
+---------------------------+-------------------------------------------------------------------+

Starting Sunstone
--------------------------------------------------------------------------------

To start Sunstone, just issue the following command as oneadmin

.. prompt:: bash # auto

    # service opennebula-sunstone start

You can find the Sunstone server log file in ``/var/log/one/sunstone.log``. Errors are logged in ``/var/log/one/sunstone.error``.

.. _commercial_support_sunstone:

Commercial Support Integration
================================================================================

We are aware that in production environments, access to professional, efficient support is a must, and this is why we have introduced an integrated tab in Sunstone to access `OpenNebula Systems <http://opennebula.systems>`__ (the company behind OpenNebula, formerly C12G) professional support. In this way, support ticket management can be performed through Sunstone, avoiding disruption of work and enhancing productivity.

|support_home|

This tab and can be disabled in each one of the :ref:`view yaml files <suns_views>`.

.. code-block:: yaml

    enabled_tabs:
        [...]
        #- support-tab

Troubleshooting
================================================================================

.. _sunstone_connect_oneflow:

Cannot connect to OneFlow server
--------------------------------------------------------------------------------

The Service instances and templates tabs may show the following message:

.. code::

    Cannot connect to OneFlow server

|sunstone_oneflow_error|

You need to start the OneFlow component :ref:`following this section <appflow_configure>`, or disable the Service and Service Templates menu entries in the :ref:`Sunstone views yaml files <suns_views>`.

.. _sunstone_vnc_troubleshooting:

VNC Troubleshooting
--------------------------------------------------------------------------------

When clicking the VNC icon, the process of starting a session begins:

-  A request is made, and if a VNC session is possible, the Sunstone server will add the VM Host to the list of allowed vnc session targets and create a random token associated to it.
-  The server responds with the session token, then a ``noVNC`` dialog pops up.
-  The VNC console embedded in this dialog will try to connect to the proxy, either using websockets (default) or emulating them using Flash. Only connections providing the right token will be successful. The token expires and cannot be reused.

There can be multiple reasons for noVNC not correctly connecting to the machines. Here's a checklist of common problems:

-  noVNC requires Python >= 2.5 for the websockets proxy to work. You may also need additional modules, such as ``python2<version>-numpy``.
-  You can retrieve useful information from ``/var/log/one/novnc.log``
-  You must have a ``GRAPHICS`` section in the VM template enabling VNC, as stated in the documentation. Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow connections from everywhere), otherwise, no connections will be allowed from the outside.
-  Your browser must support websockets, and have them enabled. This is the default in current Chrome and Firefox, but former versions of Firefox (i.e. 3.5) required manual activation. Otherwise Flash emulation will be used.
-  Make sure there are no firewalls blocking the connections. The proxy will redirect the websocket data from the VNC proxy port to the ``VNC`` port stated in the template of the VM. The value of the proxy port is defined in ``sunstone-server.conf``.
-  Make sure that you can connect directly from the Sunstone frontend to the VM using a normal VNC client tool, such as ``vncviewer``.
-  When using secure websockets, make sure that your certificate and key (if not included in the certificate) are correctly set in the Sunstone configuration files. Note that your certificate must be valid and trusted for the wss connection to work. If you are working with a certificate that it is not accepted by the browser, you can manually add it to the browser trust list by visiting ``https://sunstone.server.address:vnc_proxy_port``. The browser will warn that the certificate is not secure and prompt you to manually trust it.
-  If your connection is very, very, very slow, there might be a token expiration issue. Please try the manual proxy launch as described below to check it.
-  Doesn't work yet? Try launching Sunstone, killing the websockify proxy and relaunching the proxy manually in a console window with the command that is logged at the beginning of ``/var/log/one/novnc.log``. You must generate a lock file containing the PID of the python process in ``/var/lock/one/.novnc.lock`` Leave it running and click on the VNC icon on Sunstone for the same VM again. You should see some output from the proxy in the console and hopefully the reason the connection does not work.
-  Please contact the support forum only when you have gone through the suggestions, above and provide full sunstone logs, errors shown, and any relevant information on your infrastructure (if there are Firewalls etc.).
- The message "SecurityError: The operation is insecure." is usually related to a Same-Origin-Policy problem.  If you have Sunstone TLS-secured and try to connect to an insecure websocket for VNC, Firefox blocks that. For Firefox, you need to have both connections secured to not get this error. And don't use a self-signed certificate for the server, this would raise the error again (you can setup your own little CA, that works, but don't use a self-signed server certificate). The other option would be to go into the Firefox config (about:config) and set ``network.websocket.allowInsecureFromHTTPS`` to ``true``.

.. _sunstone_rdp_troubleshootings:

RDP Troubleshooting
--------------------------------------------------------------------------------

To add one RDP connection link for a NIC in a VM, there are two possibilities for this purpose.

- Activate the option in the Network tab of the template:

|sunstone_rdp_troubleshooting|

- It can also be defined in the VM by adding:

.. code::

    NIC=[
        ...
        RDP = "YES"
    ]

Once the VM is instantiated, users will be able to download the RDP file configuration.

|sunstone_rdp_troubleshooting2|

.. important:: The RDP connection is only allowed to activate on a single NIC. In any case, the file RDP will only contain the IP of the first NIC with this property enabled. The RDP button will work the same way for NIC ALIASES

.. note:: If the VM template has a password and username set in the contextualization section, this will be reflected in the RDP file. You can read about them in the :ref:`Virtual Machine Definition File reference section <template_context>`


Tuning & Extending
==================

Internationalization and Languages
--------------------------------------------------------------------------------

Sunstone supports multiple languages. If you want to contribute a new language, make corrections, or complete a translation, you can visit our:

-  `Transifex project page <https://www.transifex.com/projects/p/one/>`__

Translating through Transifex is easy and quick. All translations should be submitted via Transifex.

Users can update or contribute translations anytime. Prior to every release, normally after the beta release, a call for translations will be made in the forum. Then the source strings will be updated in Transifex so all the translations can be updated to the latest OpenNebula version. Translation with an acceptable level of completeness will be added to the final OpenNebula release.

Customize the VM Logos
--------------------------------------------------------------------------------

The VM Templates have an image logo to identify the guest OS. To modify the list of available logos, or to add new ones, edit ``/etc/one/sunstone-logos.yaml``.

.. code-block:: yaml

    - { 'name': "Arch Linux",         'path': "images/logos/arch.png"}
    - { 'name': "CentOS",             'path': "images/logos/centos.png"}
    - { 'name': "Debian",             'path': "images/logos/debian.png"}
    - { 'name': "Fedora",             'path': "images/logos/fedora.png"}
    - { 'name': "Linux",              'path': "images/logos/linux.png"}
    - { 'name': "Redhat",             'path': "images/logos/redhat.png"}
    - { 'name': "Ubuntu",             'path': "images/logos/ubuntu.png"}
    - { 'name': "Windows XP/2003",    'path': "images/logos/windowsxp.png"}
    - { 'name': "Windows 8",          'path': "images/logos/windows8.png"}

|sunstone_vm_logo|


Branding the Sunstone Portal
--------------------------------------------------------------------------------

You can easily add your logos to the login and main screens by updating the ``logo:`` attribute as follows:

-  The login screen is defined in the ``/etc/one/sunstone-views.yaml``.
-  The logo of the main UI screen is defined for each view in :ref:`the view yaml file <suns_views>`.

sunstone-views.yaml
--------------------------------------------------------------------------------

OpenNebula Sunstone can be adapted to different user roles. For example, it will only show the resources the users have access to. Its behavior can be customized and extended via :ref:`views <suns_views>`.

The preferred method to select which views are available to each group is to update the group configuration from Sunstone; as described in :ref:`Sunstone Views section <suns_views_configuring_access>`.
There is also the ``/etc/one/sunstone-views.yaml`` file that defines an alternative method to set the view for each user or group.

Sunstone will calculate the views available to each user using:

- From all the groups the user belongs to, the views defined inside each group are combined and presented to the user
- If no views are available from the user's group, the defaults would be fetched from ``/etc/one/sunstone-views.yaml``. Here, views can be defined for:

  -  Each user (``users:`` section): list each user and the set of views available for her.
  -  Each group (``groups:`` section): list the set of views for the group.
  -  The default view: if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.
  -  The default views for group admins: if a group admin user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default_groupadmin views will be used.

By default, users in the ``oneadmin`` group have access to all views, and users in the ``users`` group can use the ``cloud`` view.

The following ``/etc/one/sunstone-views.yaml`` example enables the user (user.yaml) and the cloud (cloud.yaml) views for helen and the cloud (cloud.yaml) view for group cloud-users. If more than one view is available for a given user the first one is the default.

.. code-block:: yaml

    ---
    logo: images/opennebula-sunstone-v4.0.png
    users:
        helen:
            - cloud
            - user
    groups:
        cloud-users:
            - cloud
    default:
        - user
    default_groupadmin:
        - groupadmin
        - cloud

A Different Endpoint for Each View
--------------------------------------------------------------------------------

OpenNebula :ref:`Sunstone views <suns_views>` can be adapted to deploy a different endpoint for each kind of user. For example if you want an endpoint for the admins and a different one for the cloud users. You just have to deploy a :ref:`new sunstone server <suns_advance>` and set a default view for each sunstone instance:

.. code::

      # Admin sunstone
      cat /etc/one/sunstone-server.conf
        ...
        :host: admin.sunstone.com
        ...

      cat /etc/one/sunstone-views.yaml
        ...
        users:
        groups:
        default:
            - admin

.. code::

      # Users sunstone
      cat /etc/one/sunstone-server.conf
        ...
        :host: user.sunstone.com
        ...

      cat /etc/one/sunstone-views.yaml
        ...
        users:
        groups:
        default:
            - user

.. |support_home| image:: /images/support_home.png
.. |sunstone_oneflow_error| image:: /images/sunstone_oneflow_error.png
.. |sunstone_rdp_troubleshooting| image:: /images/sunstone_rdp_troubleshooting.png
.. |sunstone_rdp_troubleshooting2| image:: /images/sunstone_rdp_troubleshooting2.png
.. |sunstone_vm_logo| image:: /images/sunstone_vm_logo.png
