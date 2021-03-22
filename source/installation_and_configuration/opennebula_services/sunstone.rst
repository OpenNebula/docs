.. _sunstone:
.. _sunstone_setup:
.. _sunstone_conf:
.. _sunstone_sunstone_server_conf:

======================
Sunstone Configuration
======================

The OpenNebula Sunstone server provides a **web-based management interface**. It's a dedicated daemon installed by default as part of the :ref:`Single Front-end Installation <frontend_installation>`, but can be deployed independently on a different machine. The server is distributed as an operating system package ``opennebula-sunstone`` with system services ``opennebula-sunstone`` for Sunstone and ``opennebula-novnc`` for noVNC Proxy.

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
| ``:max_upload_file_size``       | Maximum allowed size of uploaded images (in bytes). Leave commented for unlimited size              |
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
| ``:paginate``                   | Array for paginate, the first position is for internal use. the second is used to put               |
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

.. note::

    To use Sunstone on IPv6-only environments with `thin <https://github.com/macournoyer/thin>`__ HTTP server, use the full IPv6 address in the configuration parameter ``:host``. If you need to set the localhost address (``::1``) or the unspecified address (``::``), use one of the following examples:

    .. code::

        :host: 0::1
        :host: 0::0

Sunstone settings can be also configured on user-level through the user template (within a ``SUNSTONE=[]`` section, for example ``SUNSTONE=[TABLE_ORDER="asc"]``). Following attributes are available for customization:

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

Both values can be same, as long as they are valid. Example:

.. code::

    :private_fireedge_endpoint: http://f2.priv.example.com:2616
    :public_fireedge_endpoint: http://one.example.com:2616

.. hint::

    If you **are not planning to use FireEdge**, you can disable it by commenting both endpoints in configuration:

    .. code::

        #:private_fireedge_endpoint: http://localhost:2616
        #:public_fireedge_endpoint: http://localhost:2616

If FireEdge is running on a different host, cipher key ``/var/lib/one/.one/fireedge_key`` for Guacamole connections must be copied among hosts.

.. _sunstone_conf_service:

Service Control and Logs
========================

Manage operating system services ``opennebula-sunstone`` and ``opennebula-novnc`` to change the server(s) running state.

To start, restart, stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula-sunstone
    # systemctl restart opennebula-sunstone
    # systemctl stop    opennebula-sunstone

To enable or disable automatic start on host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula-sunstone
    # systemctl disable opennebula-sunstone

.. note::

   noVNC Proxy Server is automatically started (unless masked) with the start of OpenNebula Sunstone.

Servers **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/sunstone.log``
- ``/var/log/one/sunstone.error``
- ``/var/log/one/novnc.log``

Other logs are also available in Journald, use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula-sunstone.service
    # journalctl -u opennebula-novnc.service

Usage
=====

.. _commercial_support_sunstone:

Commercial Support Integration
------------------------------

We are aware that in production environments, access to professional, efficient support is
a must, and this is why we have introduced an integrated tab in Sunstone to access
`OpenNebula Systems <http://opennebula.systems>`_ (the company behind OpenNebula, formerly C12G)
professional support. In this way, support ticket management can be performed through Sunstone,
avoiding disruption of work and enhancing productivity.

|support_home|

.. _remote_access_sunstone:

.. TODO - This Remote Desktop section is absolutely terrible!!!

Accessing VM Console and Desktop
--------------------------------

Sunstone provides several different methods to access your VM console and desktop: VNC, SPICE, RDP, VMRC, SSH, and ``virt-viewer``. If configured in the VM, these metods can be used to access the VM console through Sunstone.  For some of those connections, we will need to start new FireEdge server to establish the remote connection. This section shows how these different technologies can be configured and what are each requirement.

:ref:`FireEdge <fireedge_configuration>` automatically installs dependencies for Guacamole connectinos and VMRC proxy, which are necessary for use VNC, RDP, SSH, and VMRC.

+-----------------+-------------------+---------------------+
|   Connection    |   With FireEdge   |  Without FireEdge   |
+=================+===================+=====================+
| VNC             | Guacamole         | noVNC               |
+-----------------+-------------------+---------------------+
| RDP             | Guacamole         | noVNC               |
+-----------------+-------------------+---------------------+
| SSH             | Guacamole         | N/A                 |
+-----------------+-------------------+---------------------+
| SPICE           | noVNC             | noVNC               |
+-----------------+-------------------+---------------------+
| ``virt-viewer`` | noVNC             | noVNC               |
+-----------------+-------------------+---------------------+
| VMRC            | VMRC proxy        | N/A                 |
+-----------------+-------------------+---------------------+

.. important::

    :ref:`FireEdge <fireedge_conf>` server must be running to get Guacamole conn. working. For VMRC conn. Sunstone and FireEdge must be running on the **same server**.

.. _requirements_remote_access_sunstone:

Requirements for connections via noVNC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Sunstone GUI offers the possibility of starting a VNC/SPICE session to a Virtual
Machine. This is done by using a **VNC/SPICE websocket-based client (noVNC)** on the client-side and
a VNC proxy translating and redirecting the connections on the server-side.

To enable VNC/SPICE console service, you must have a ``GRAPHICS`` section in the VM template, as
stated in the documentation. Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow
connections from everywhere), otherwise, no connections will be allowed from the outside.

For example, to configure this in Virtual Machine template:

.. code-block:: none

    GRAPHICS=[
        LISTEN="0.0.0.0",
        TYPE="vnc"
    ]

Make sure there are no firewalls blocking the connections and websockets enabled in your browser.
**The proxy will redirect the websocket** data from the VNC proxy port to the VNC port stated in
the template of the VM. The value of the proxy port is defined in ``sunstone-server.conf`` as
``:vnc_proxy_port``.

You can retrieve useful information from ``/var/log/one/novnc.log``. **Your browser must support
websockets**, and have them enabled.

When using secure websockets, make sure that your certificate and key (if not included in the
certificate) are correctly set in the :ref:`Sunstone configuration files <suns_advance_ssl_proxy>`.
Note that your certificate must be valid and trusted for the wss connection to work.

If you are working with a certificate that it is not accepted by the browser, you can manually add
it to the browser trust list by visiting ``https://sunstone.server.address:vnc_proxy_port``.
The browser will warn that the certificate is not secure and prompt you to manually trust it.

.. _vnc_sunstone:

Configuring your VM for VNC
^^^^^^^^^^^^^^^^^^^^^^^^^^^

VNC is a graphical console with wide support among many hypervisors and clients.

VNC without FireEdge
""""""""""""""""""""

When clicking the VNC icon, a request is made, and if a VNC session is possible, the Sunstone server will add the VM
Host to the list of allowed vnc session targets and create a **random token** associated to it. The
server responds with the session token, then a ``noVNC`` dialog pops up.

The VNC console embedded in this dialog will try to connect to the proxy, either using websockets
(default) or emulating them using Flash. Only connections providing the right token will be successful.
The token expires and cannot be reused.

Make sure that you can connect directly from the Sunstone frontend to the VM using a normal VNC
client tool, such as ``vncviewer``.

.. _requirements_guacamole_vnc_sunstone:

VNC with FireEdge
"""""""""""""""""

To enable VNC console service, you must have a ``GRAPHICS`` section in the VM template,
as stated in the documentation.

To configure it via Sunstone, you need to update the VM template. In the Input/Output tab,
you can see the graphics section where you can add the IP, the port, a connection password
or define your keymap.

|sunstone_guac_vnc|

To configure this in Virtual Machine template in **advanced mode**:

.. code-block:: none

    GRAPHICS=[
        LISTEN="0.0.0.0",
        TYPE="vnc"
    ]

.. note:: Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow connections
    from everywhere), otherwise, no connections will be allowed from the outside.

.. _rdp_sunstone:

Configure VM for RDP
^^^^^^^^^^^^^^^^^^^^

Short for **Remote Desktop Protocol**, allows one computer to connect to another computer
over a network in order to use it remotely.

RDP without FireEdge
""""""""""""""""""""

RDP connections are available on Sunstone using noVNC. You will only have to download the
RDP file and open it with an RDP client to establish a connection with your Virtual Machine.

.. _requirements_guacamole_rdp_sunstone:

RDP with FireEdge
"""""""""""""""""

To add one RDP connection link for a network in a VM, you must have one ``NIC``
with ``RDP`` attribute equals ``YES`` in his template.

Via Sunstone, you need to enable RDP connection on one of VM template networks, **after or
before his instantiation**.

|sunstone_guac_nic|

To configure this in Virtual Machine template in **advanced mode**:

.. code-block:: none

    NIC=[
        ...
        RDP = "YES"
    ]

Once the VM is instantiated, users will be able to download the **file configuration or
connect via browser**.

|sunstone_guac_rdp|

.. important:: **The RDP connection is only allowed to activate on a single NIC**. In any
    case, the connection will only contain the IP of the first NIC with this property enabled.
    The RDP connection will work the **same way for NIC ALIASES**.

.. note:: If the VM template has a ``PASSWORD`` and ``USERNAME`` set in the contextualization
    section, this will be reflected in the RDP connection. You can read about them in the
    :ref:`Virtual Machine Definition File reference section <template_context>`.

.. _requirements_guacamole_ssh_sunstone:

Configure VM for SSH
^^^^^^^^^^^^^^^^^^^^

**SSH connections are available only when a reachable Firedge server is found**. Unlike VNC or RDP,
SSH is a text protocol. SSH connections require a hostname or IP address defining
the destination machine. Like with the :ref:`RDP <requirements_guacamole_rdp_sunstone>` connections,
you need to enable the SSH connection on one of VM template networks.

For example, to configure this in Virtual Machine template in **advanced mode**:

.. code-block:: none

    NIC=[
        ...
        SSH = "YES"
    ]

SSH is standardized to use port 22 and this will be the proper value in most cases. You only
need to specify the **SSH port in the contextualization section as** ``SSH_PORT`` if you are
not using the standard port.

.. note:: If the VM template has a ``PASSWORD`` and ``USERNAME`` set in the contextualization
	section, this will be reflected in the SSH connection. You can read about them in the
	:ref:`Virtual Machine Definition File reference section <template_context>`.

For example, to allow connection by username and password to a guest VM. First make sure you
have SSH root access to the VM, check more info :ref:`here <cloudview_ssh_keys>`.

After that you can access the VM and configure the SSH service:

.. code-block:: bash

    oneadmin@frontend:~$ ssh root@<guest-vm>

    # Allow authentication with password: PasswordAuthentication yes
    root@<guest-VM>:~$ vi /etc/ssh/sshd_config

    # Restart SSH service
    root@<guest-VM>:~$ service sshd restart

    # Add user: username/password
    root@<guest-VM>:~$ adduser <username>

.. _spice_sunstone:

Configure VM for SPICE
^^^^^^^^^^^^^^^^^^^^^^

SPICE connections are channeled only through the noVNC proxy. SPICE support in Sunstone share
a similar architecture to the VNC implementation. Sunstone use a **SPICE-HTML5** widget in
its console dialog that communicates with the proxy by using websockets.

.. note:: For the correct functioning of the SPICE Web Client, we recommend defining by default
    some SPICE parameters in ``/etc/one/vmm_mad/vmm_exec_kvm.conf``. In this way, once modified the
    file and restarted OpenNebula, it will be applied to all the VMs instantiated from now on. You can
    also override these SPICE parameters in VM Template. For more info check :ref:`Driver Defaults
    <kvmg_default_attributes>` section.

.. _virt_viewer_sunstone:

Configure VM for virt-viewer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``virt-viewer`` connections are channeled only through the noVNC proxy. virt-viewer is a minimal tool
for displaying the graphical console of a virtual machine. It can **display VNC or SPICE protocol**,
and uses libvirt to lookup the graphical connection details.

In this case, Sunstone allows you to download the **virt-viewer configuration file** for the VNC and
SPICE protocols. The only requirement is the ``virt-viewer`` being installed on your machine from which you are accessing the Sunstone.

To use this option, you will only have to enable any of two protocols in the VM. Once the VM is
``instantiated`` and ``running``, users will be able to download the ``virt-viewer`` file.

|sunstone_virt_viewer_button|

.. _vmrc_sunstone:

Configure VM for VMRC
^^^^^^^^^^^^^^^^^^^^^

.. important::

    VMRC connections are available only when a reachable FireEdge server is found.

*VMware Remote Console* provides console access and client device connection to VMs on a remote host.

These type of connections requests a ``TOKEN`` from vCenter to connect with the Virtual Machine
allocated on vCenter every time you click on the VMRC button.

To use this option, you will only have to enable VNC / VMRC connections to your VMs and start the
FireEdge Server.

|sunstone_vmrc|

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

Users can update or contribute translations anytime. Prior to every release, normally after the
beta release, a call for translations will be made in the forum. Then the source strings will be
updated in Transifex so all the translations can be updated to the latest OpenNebula version.
Translation with an acceptable level of completeness will be added to the final OpenNebula release.

Customize VM Logos
------------------

The VM Templates can have an image logo to identify the guest OS. Edit ``/etc/one/sunstone-logos.yaml`` to modify list of available logos. Example:

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

Guest OS logo as shown in the Sunstone:

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
configuration from Sunstone; as described in :ref:`Sunstone Views section <suns_views_configuring_access>`.
There is also the ``/etc/one/sunstone-views.yaml`` file that defines an alternative method to
set the view for each user or group.

Sunstone will offer the available views to each user following way:

* From all the groups the user belongs to, the views defined inside each group are combined and presented to the user.

* If no views are available from the user's group, the defaults are taken from ``/etc/one/sunstone-views.yaml``. Here, views can be defined for:

  * Each user (``users:`` section): list each user and the set of views available for her.
  * Each group (``groups:`` section): list the set of views for the group.
  * The default view: if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.
  * The default views for group admins: if a group admin user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default_groupadmin views will be used.

By default, users in the ``oneadmin`` group have access to all views, and users in the ``users``
group can use the ``cloud`` view.

The following example of ``/etc/one/sunstone-views.yaml`` enables the *user* (``user.yaml``) and the
*cloud* (``cloud.yaml``) views for user ``helen`` and the *cloud* (``cloud.yaml``) view for group ``cloud-users``. If more
than one view is available for a given user the first one is the default.

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
each kind of user. For example, if you want an endpoint for the admins and a different one for the
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

Editable template attributes are on various places of the Sunstone, for example in details of Marketplace Appliance. You can add an attribute with the name ``LINK``, which contains an URL. The value will be automatically transformed into the clickable hyperlink.

|sunstone_link_attribute|

.. |support_home| image:: /images/support_home.png
.. |sunstone_link_attribute| image:: /images/sunstone_link_attribute.png
.. |sunstone_oneflow_error| image:: /images/sunstone_oneflow_error.png
.. |sunstone_virt_viewer_button| image:: /images/sunstone_virt_viewer_button.png
.. |sunstone_rdp_connection| image:: /images/sunstone_rdp_connection.png
.. |sunstone_rdp_button| image:: /images/sunstone_rdp_button.png
.. |sunstone_vm_logo| image:: /images/sunstone_vm_logo.png
.. |sunstone_guac_vnc| image:: /images/sunstone_guac_vnc.png
.. |sunstone_guac_rdp| image:: /images/sunstone_guac_rdp.png
.. |sunstone_guac_nic| image:: /images/sunstone_guac_nic.png
.. |sunstone_vmrc| image:: /images/sunstone_vmrc.png
