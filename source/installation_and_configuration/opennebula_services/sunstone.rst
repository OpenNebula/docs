.. _sunstone:
.. _sunstone_setup:
.. _sunstone_conf:
.. _sunstone_sunstone_server_conf:

======================
Sunstone Configuration
======================

The OpenNebula Sunstone server provides a **web-based management interface**. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-sunstone`` with the system services ``opennebula-sunstone`` for Sunstone and ``opennebula-novnc`` for noVNC Proxy.

Configuration
=============

The Sunstone configuration file can be found in ``/etc/one/sunstone-server.conf`` on your Front-end. It uses **YAML** syntax with following parameters:

.. note::

    After a configuration change, the Sunstone server must be :ref:`restarted <sunstone_conf_service>` to take effect.

+---------------------------------+-----------------------------------------------------------------------------------------------------+
|          Parameter              |                                          Description                                                |
+=================================+=====================================================================================================+
| **Server Configuration**                                                                                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:tmpdir``                     | Directory to temporarily store uploaded images before copying to OpenNebula (Default: ``/var/tmp``) |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:one_xmlrpc``                 | Endpoint of OpenNebula XML-RPC API (Default: ``http://localhost:2633/RPC2``)                        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:one_xmlrpc_timeout``         | Timeout (in seconds) for XML-RPC calls from Sunstone.                                               |
|                                 | See :ref:`Shell Environment variables <manage_users>`.                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:subscriber_endpoint``        | Endpoint for ZeroMQ subscriptions (Default: ``tcp://localhost:2101``)                               |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:host``                       | Hostname/IP where server will listen (Default: ``0.0.0.0``)                                         |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:port``                       | Port where server will listen (Default: ``9869``)                                                   |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:sessions``                   | Method of keeping user sessions. It can be ``memory``, ``memcache`` or ``memcache-dalli``.          |
|                                 | For servers that spawn more processes (e.g., Passenger or Unicorn) ``memcache`` must be used.       |
|                                 | (Default: ``memory``)                                                                               |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:memcache_host``              | Hostname/IP of memcached server (only for memcached-based sessions) (Default: ``localhost``)        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:memcache_port``              | Port of memcached server (only for memcached-based sessions) (Default: ``11211``)                   |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:memcache_namespace``         | Memcached namespace to store sessions, useful when memcached is used by other services              |
|                                 | (Default: ``opennebula.sunstone``)                                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:env``                        | Execution environment for Sunstone. With ``dev``, instead of pulling the minified JS all the        |
|                                 | files will be pulled (``app/main.js``). Check the :ref:`Building from Source <compile>` guide       |
|                                 | for details on how to run Sunstone in development. With ``prod``, the minified JS                   |
|                                 | will be used (``dist/main.js``) (Default: ``prod``)                                                 |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:max_upload_file_size``       | Maximum permitted size of uploaded images (in bytes). Leave commented for unlimited size            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Logging**                                                                                                                           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:debug_level``                | Logging level. Values: ``0`` for ERROR level, ``1`` for WARNING level, ``2`` for INFO level,        |
|                                 | ``3`` for DEBUG level. (Default: ``3``)                                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Proxy**                                                                                                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:proxy``                      | Proxy server for HTTP traffic                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:no_proxy``                   | Patterns for IP addresses or domain names that shouldn’t use the proxy                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Authentication**                                                                                                                    |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:auth``                       | Authentication driver for incoming requests. Possible values are ``sunstone``,                      |
|                                 | ``opennebula``, ``remote`` and ``x509``. Check :ref:`authentication methods <authentication>`       |
|                                 | for more info. (Default: ``opennebula``)                                                            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:core_auth``                  | Authentication driver to communicate with OpenNebula Daemon. Possible values are ``x509``           |
|                                 | or ``cipher``. See :ref:`Cloud Server Authentication <cloud_auth>`. (Default: ``cipher``)           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:two_factor_auth_issuer``     | Two Factor Authentication Issuer Label (Default: ``opennebula``)                                    |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **WebAuthn**                                                                                                                          |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:webauthn_origin``            |                                                                                                     |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:webauthn_rpname``            | Relying Party name for display purposes (Default: ``OpenNebula Cloud``)                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:webauthn_timeout``           | Time (in ms) the browser should wait for any interaction with user (Default: ``60000``)             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:webauthn_rpid``              | Optional differing Relying Party ID                                                                 |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:webauthn_algorithms``        | List of supported cryptographic algorithms. Options: ``ES256``, ``ES384``, ``ES512``, ``PS256``,    |
|                                 | ``PS384``, ``PS512``, ``RS256``, ``RS384``, ``RS512``, ``RS1``. (Default: ``[ES256, PS256, RS256]``)|
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Upgrades Checks**                                                                                                                   |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:remote_version``             | URL to check for latest releases (Default: ``http://downloads.opennebula.org/latest``)              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **UI Settings**                                                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_proxy_port``             | Base port for the noVNC proxy. Can be prefixed with an address on which the sever will              |
|                                 | be listening (ex: 127.0.0.1:29876). (Default: ``28767``)                                            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_proxy_support_wss``      | Values ``yes``, ``no``, ``only``. If enabled, the proxy will be set up with a certificate and       |
|                                 | a key to use secure websockets. If set to ``only`` the proxy will only accept encrypted             |
|                                 | connections, otherwise it will accept both encrypted or unencrypted ones. (Default: ``no``)         |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_proxy_cert``             | Full path to certificate file for WSS connections.                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_proxy_key``              | Full path to key file. Not necessary if key is included in certificate.                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_proxy_ipv6``             | Enable IPv6 for noVNC - ``true`` or ``false`` (Default: ``false``)                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_client_port``            | Port where the noVNC JS client will connect.                                                        |
|                                 | If not set, will use the port section of ``:vnc_proxy_port``                                        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:vnc_request_password``       | Request VNC password for external windows, ``true`` or ``false`` (Default: ``false``)               |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:allow_vnc_federation``       | Display VNC icons in federation, ``yes`` or ``no`` (Default: ``no``)                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:session_expire_time``        | Login Session Length in seconds (Default: ``3600``, 1 hour)                                         |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:keep_me_logged``             | Enable option *'Keep me logged in'* in Sunstone login (Default: ``true``)    n                      |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:lang``                       | Default language for the Sunstone interface. This is the default language that will                 |
|                                 | be used if user has not defined a variable ``LANG`` with a different valid value in                 |
|                                 | user template                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:table_order``                | Default table order. Resources get ordered by ID in ``asc`` or ``desc`` order. (Default: ``desc``)  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:mode``                       | Default Sunstone views group (Default: ``mixed``)                                                   |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:get_extended_vm_info``       | True to display extended VM information from OpenNebula (Default: ``false``)                        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:get_extended_vm_monitoring`` | True to display extended information from VM monitoring from OpenNebula (Default: ``false``)        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:paginate``                   | Array for paginate, the first position is for internal use. The second is used to put               |
|                                 | names to each value.                                                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:leases``                     | Displays button and clock icon in table of VM                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:threshold_min``              | Minimum percentage value for green color on thresholds                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:threshold_low``              | Minimum percentage value for orange color on thresholds                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:threshold_high``             | Minimum percentage value for red color on thresholds                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:support_fs``                 | List of filesystems to offer when creating new Image                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Official Support**                                                                                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:token_remote_support``       | Customer token to contact support from Sunstone                                                     |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Marketplace**                                                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:marketplace_username``       | Username credential to connect to the Marketplace                                                   |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:marketplace_password``       | Password to connect to the Marketplace                                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:marketplace_url``            | Endpoint to connect to the Marketplace. If commented, a 503 ``service unavailable``                 |
|                                 | error will be returned to clients. (Default: ``http://marketplace.opennebula.io/``)                 |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **OneFlow**                                                                                                                           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:oneflow_server``             | Endpoint to connect to the OneFlow server (Default: ``http://localhost:2474/``)                     |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **Routes**                                                                                                                            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:routes``                     | List of Ruby files containing custom routes to be loaded.                                           |
|                                 | Check :ref:`server plugins <sunstone_dev>` for more information.                                    |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| **FireEdge**                                                                                                                          |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:private_fireedge_endpoint``  | Base URL (hostname/IP-based) where the FireEdge server is running.                                  |
|                                 | This endpoint must be **reachable by Sunstone server**.                                             |
|                                 | (Default: ``http://localhost:2616``)                                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| ``:public_fireedge_endpoint``   | Base URL (hostname/IP-based) where the FireEdge server is running.                                  |
|                                 | This endpoint must be **reachable by end-users**!                                                   |
|                                 | (Default: ``http://localhost:2616``)                                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+

.. _sunstone_in_ha:

In order to properly use Sunstone with FireEdge in HA environments and have the Guacamole functionality available, all Sunstone servers need to access ``/var/lib/one/.one/fireedge_key``.

.. note::

    To use Sunstone on IPv6-only environments with `thin <https://github.com/macournoyer/thin>`__ HTTP server, use the full IPv6 address in the configuration parameter ``:host``. If you need to set the localhost address (``::1``) or the unspecified address (``::``), use one of the following examples:

    .. code::

        :host: 0::1
        :host: 0::0

Sunstone settings can be also configured on user-level through the user template (within a ``SUNSTONE=[]`` section, for example ``SUNSTONE=[TABLE_ORDER="asc"]``). The following attributes are available for customization:

+-------------------------------+------------------------------------------------------------------------+
|         Attribute             |                            Description                                 |
+===============================+========================================================================+
| ``DISPLAY_NAME``              | Name of the user that will appear in Sunstone                          |
+-------------------------------+------------------------------------------------------------------------+
| ``TABLE_ORDER``               | Values ``asc`` (ascending) or ``desc`` (descending)                    |
+-------------------------------+------------------------------------------------------------------------+
| ``DEFAULT_VIEW``              | Name of the default view (as located in ``/etc/one/sunstone-views``)   |
+-------------------------------+------------------------------------------------------------------------+
| ``TABLE_DEFAULT_PAGE_LENGTH`` | Default length of Sunstone datatables' pages                           |
+-------------------------------+------------------------------------------------------------------------+
| ``LANG``                      | Sunstone language (defaults to en_US)                                  |
+-------------------------------+------------------------------------------------------------------------+
| ``DEFAULT_ZONE_ENDPOINT``     | Default zone at Sunstone login. Defaults to the local zone.            |
+-------------------------------+------------------------------------------------------------------------+

.. _fireedge_sunstone:
.. _fireedge_sunstone_configuration:

Configure FireEdge
------------------

Optional :ref:`FireEdge <fireedge_configuration>` server provides the additional functionality to Sunstone:

- :ref:`Resource state autorefresh <autorefresh>`, VMs and host states are refreshed automatically.
- :ref:`Remote access VMs <remote_access_sunstone>` using **Guacamole** and/or **VMRC** (VMware Remote Console). FireEdge acts as a proxy between Sunstone and hypervisor nodes or vCenter/ESX (see :ref:`more <vmrc_sunstone>`) and streaming the remote console/desktop of the Virtual Machines.

Sunstone has to be configured (``/etc/one/sunstone-server.conf``) with two FireEdge endpoints to work properly:

- ``:private_fireedge_endpoint`` - base URL reachable by **Sunstone** (leave default if running on same host),
- ``:public_fireedge_endpoint`` - base URL reachable by **end-users**.

Both values can be same, as long as they are valid. For example:

.. code::

    :private_fireedge_endpoint: http://f2.priv.example.com:2616
    :public_fireedge_endpoint: http://one.example.com:2616

.. hint::

    If you **are not planning to use FireEdge**, you can disable it by commenting both endpoints in configuration:

    .. code::

        #:private_fireedge_endpoint: http://localhost:2616
        #:public_fireedge_endpoint: http://localhost:2616

If FireEdge is running on a different host, the cipher key ``/var/lib/one/.one/fireedge_key`` for Guacamole connections must be copied among Hosts.

.. _sunstone_conf_service:

Service Control and Logs
========================

Manage operating system services ``opennebula-sunstone`` and ``opennebula-novnc`` to change the server(s) running state.

To start, restart or stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-sunstone
    # systemctl restart opennebula-sunstone
    # systemctl stop    opennebula-sunstone

To enable or disable automatic start on Host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-sunstone
    # systemctl disable opennebula-sunstone

.. note::

   noVNC Proxy Server is automatically started (unless masked) when OpenNebula Sunstone starts.

Servers **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/sunstone.log``
- ``/var/log/one/sunstone.error``
- ``/var/log/one/novnc.log``

Other logs are also available in Journald; use the following command to show these:

.. prompt:: bash # auto

    # journalctl -u opennebula-sunstone.service
    # journalctl -u opennebula-novnc.service

Usage
=====

.. _commercial_support_sunstone:

Commercial Support Integration
------------------------------

We are aware that in production environments, access to professional, efficient support is
a must and this is why we have introduced an integrated tab in Sunstone to access
`OpenNebula Systems <http://opennebula.systems>`_ (the company behind OpenNebula, formerly C12G)
professional support. In this way, support ticket management can be performed through Sunstone,
avoiding disruption of work and enhancing productivity.

|support_home|

Troubleshooting
===============

Failed to Connect to OneFlow
----------------------------

The Service and Service Template tabs may complain about connection failures to the OneFlow server  (**Cannot connect to OneFlow server**). E.g.:

|sunstone_oneflow_error|

Ensure you have OneFlow server :ref:`configured and running <oneflow_conf>`, or disable Service and Service Templates tabs in :ref:`Sunstone View <suns_views>`.

Tuning and Extending
====================

Internationalization and Localization
-------------------------------------

Sunstone supports multiple languages. If you want to contribute a new language, make corrections, or
complete a translation, you can visit our `Transifex <https://www.transifex.com/projects/p/one/>`__ project page.
Translating through Transifex is easy and quick. All translations **should be submitted via Transifex**.

Users can update or contribute translations any time. Prior to every release, normally after the
beta release, a call for translations will be made in the forum. Then the source strings will be
updated in Transifex so all the translations can be updated to the latest OpenNebula version.
Translations with an acceptable level of completeness will be added to the final OpenNebula release.

Customize VM Logos
------------------

The VM Templates can have an image logo to identify the guest OS. Edit ``/etc/one/sunstone-logos.yaml`` to modify the list of available logos. Example:

.. code-block:: yaml

    - { 'name': "Alpine Linux",    'path': "images/logos/alpine.png"}
    - { 'name': "ALT",             'path': "images/logos/alt.png"}
    - { 'name': "Arch Linux",      'path': "images/logos/arch.png"}
    - { 'name': "CentOS",          'path': "images/logos/centos.png"}
    - { 'name': "Debian",          'path': "images/logos/debian.png"}
    - { 'name': "Fedora",          'path': "images/logos/fedora.png"}
    - { 'name': "FreeBSD",         'path': "images/logos/freebsd.png"}
    - { 'name': "HardenedBSD",     'path': "images/logos/hardenedbsd.png"}
    - { 'name': "Knoppix",         'path': "images/logos/knoppix-logo.png"}
    - { 'name': "Linux",           'path': "images/logos/linux.png"}
    - { 'name': "Oracle",          'path': "images/logos/oel.png"}
    - { 'name': "Redhat",          'path': "images/logos/redhat.png"}
    - { 'name': "SUSE",            'path': "images/logos/suse.png"}
    - { 'name': "Ubuntu",          'path': "images/logos/ubuntu.png"}
    - { 'name': "Windows XP/2003", 'path': "images/logos/windowsxp.png"}
    - { 'name': "Windows 8/2012",  'path': "images/logos/windows8.png"}
    - { 'name': "Windows 10/2016", 'path': "images/logos/windows8.png"}

Guest OS logo as shown in Sunstone:

|sunstone_vm_logo|

.. _sunstone_branding:

Branding Sunstone
-----------------

You can add your logo to the login and main screens by updating the ``logo:`` attribute as follows:

- The login screen is defined in the ``/etc/one/sunstone-views.yaml``.
- The logo of the main UI screen is defined for each view in :ref:`the view yaml file <suns_views>`.

You can also change the color threshold values in the ``/etc/one/sunstone-server.conf``.

- The green color starts in ``:threshold_min:``
- The orange color starts in ``:threshold_low:``
- The red color starts in ``:threshold_high:``

Global User Settings of Sunstone Views
--------------------------------------

OpenNebula Sunstone can be adapted to different user roles. For example, it will only show the
resources the users have access to. Its behavior can be customized and extended via
:ref:`Sunstone Views <suns_views>`.

The preferred method to select which views are available to each group is to update the group
configuration from Sunstone, as described in :ref:`Sunstone Views section <suns_views_configuring_access>`.
There is also the ``/etc/one/sunstone-views.yaml`` file that defines an alternative method to
set the view for each user or group.

Sunstone will offer the available views to each user in the following way:

* From all the groups the user belongs to, the views defined inside each group are combined and presented to the user.

* If no views are available from the user's group, the defaults are taken from ``/etc/one/sunstone-views.yaml``. Here, views can be defined for:

  * Each user (``users:`` section): list each user and the set of views available for him or her.
  * Each group (``groups:`` section): list the set of views for the group.
  * The default view: if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.
  * The default views for group admins: if a group admin user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default_groupadmin views will be used.

By default, users in the ``oneadmin`` group have access to all views, and users in the ``users``
group can use the ``cloud`` view.

The following example of ``/etc/one/sunstone-views.yaml`` enables the *user* (``user.yaml``) and the
*cloud* (``cloud.yaml``) views for user ``helen`` and the *cloud* (``cloud.yaml``) view for group ``cloud-users``. If more
than one view is available for a given user, the first one is the default.

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

Different Endpoint for Different View
-------------------------------------

OpenNebula :ref:`Sunstone Views <suns_views>` can be adapted to use a different endpoint for
each kind of user, such as if you want one endpoint for the admins and a different one for the
cloud users. You just have to deploy a :ref:`new sunstone server <suns_advance>` and set a default
view for each sunstone instance:

.. code::

      # Sunstone for Admins
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

      # Sunstone for Users
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

Hyperlinks in Templates
-----------------------

Editable template attributes are in various places on Sunstone, for example in the details of Marketplace Appliance. You can add an attribute with the name ``LINK`` that contains an URL. The value will be automatically transformed into the clickable hyperlink.

|sunstone_link_attribute|

.. |support_home| image:: /images/support_home.png
.. |sunstone_link_attribute| image:: /images/sunstone_link_attribute.png
.. |sunstone_oneflow_error| image:: /images/sunstone_oneflow_error.png
.. |sunstone_vm_logo| image:: /images/sunstone_vm_logo.png
