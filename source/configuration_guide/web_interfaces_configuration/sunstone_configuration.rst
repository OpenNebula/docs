.. _sunstone_setup:

=================================================
Sunstone Configuration
=================================================

Requirements
===============================================================================

You must have an OpenNebula site properly configured and running to use OpenNebula Sunstone.
Be sure to check the :ref:`OpenNebula Installation and Configuration Guides
<design_and_installation_guide>` to set up your private cloud first. This section also assumes
that you are familiar with the configuration and use of OpenNebula.

OpenNebula Sunstone was installed during the OpenNebula installation. If you followed the
:ref:`installation guide <ignc>` then you already have all ruby gem requirements. Otherwise,
run the ``install_gem`` script as root:

.. code-block:: bash

    # /usr/share/one/install_gems sunstone

If you want to use VNC, SPICE, RDP, VMRC, ssh or virt-viewer please follow the requirements laid out
:ref:`here <remote_access_sunstone>`.

Configuration
================================================================================

.. _sunstone_sunstone_server_conf:

sunstone-server.conf
--------------------------------------------------------------------------------

The Sunstone configuration file can be found at ``/etc/one/sunstone-server.conf``. It uses YAML
syntax to define some options:

Available options are:

+---------------------------------+-----------------------------------------------------------------------------------------------------+
|           Option                |                                          Description                                                |
+=================================+=====================================================================================================+
| :tmpdir                         | Uploaded images will be temporally stored in this folder before being copied to OpenNebula          |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :one\_xmlrpc                    | OpenNebula daemon host and port                                                                     |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :one\_xmlrpc\_timeout           | Configure the timeout (seconds) for XMLRPC calls from sunstone.                                     |
|                                 | See :ref:`Shell Environment variables <manage_users>`                                               |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :host                           | IP address on which the server will listen. ``0.0.0.0`` by default.                                 |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :port                           | Port on which the server will listen. ``9869`` by default.                                          |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :sessions                       | Method of keeping user sessions. It can be ``memory`` or ``memcache``. For servers that spawn       |
|                                 | more than one process (like Passenger or Unicorn) ``memcache`` should be used                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :memcache\_host                 | Host where ``memcached`` server resides                                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :memcache\_port                 | Port of ``memcached`` server                                                                        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :memcache\_namespace            | memcache namespace where to store sessions. Useful when ``memcached`` server is used by             |
|                                 | more services                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :debug\_level                   | Log debug level: 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                        |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :env                            | Execution environment for Sunstone. ``dev``, Instead of pulling the minified js all the             |
|                                 | files will be pulled (app/main.js). Check the :ref:`Building from Source <compile>` guide           |
|                                 | in the docs, for details on how to run Sunstone in development. ``prod``, the minified js           |
|                                 | will be used (dist/main.js)                                                                         |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :max_upload_file_size           | Maximum allowed size of uploaded images (in bytes). Leave commented for unlimited size              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :auth                           | Authentication driver for incoming requests. Possible values are ``sunstone``,                      |
|                                 | ``opennebula``, ``remote`` and ``x509``. Check :ref:`authentication methods <authentication>`       |
|                                 | for more info                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :core\_auth                     | Authentication driver to communicate with OpenNebula core. Possible values are ``x509``             |
|                                 | or ``cipher``. Check :ref:`cloud\_auth <cloud_auth>` for more information                           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :encode_user_password           | For external authentication drivers, such as LDAP. Performs a URL encoding on the                   |
|                                 | credentials sent to OpenNebula, e.g. secret%20password. This only works with                        |
|                                 | "opennebula" auth.                                                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :lang                           | Default language for the Sunstone interface. This is the default language that will                 |
|                                 | be used if user has not defined a variable LANG with a different valid value in                     |
|                                 | user template                                                                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_port               | Base port for the VNC proxy. The proxy will run on this port as long as Sunstone server             |
|                                 | does. ``29876`` by default. Could be prefixed with an address on which the sever will be            |
|                                 | listening (ex: 127.0.0.1:29876).                                                                    |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_support\_wss       | ``yes``, ``no``, ``only``. If enabled, the proxy will be set up with a certificate and              |
|                                 | a key to use secure websockets. If set to ``only`` the proxy will only accept encrypted             |
|                                 | connections, otherwise it will accept both encrypted or unencrypted ones.                           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_cert               | Full path to certificate file for wss connections.                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_key                | Full path to key file. Not necessary if key is included in certificate.                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_proxy\_ipv6               | Enable IPv6 for novnc. (true or false)                                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_client\_port              | Port where the VNC JS client will connect.                                                          |
|                                 | If not set, will use the port section of :vnc_proxy_port                                            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :vnc\_request\_password         | Request VNC password for external windows. By default it will not be requested                      |
|                                 | (true or false)                                                                                     |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :table\_order                   | Default table order. Resources get ordered by ID in ``asc`` or ``desc`` order.                      |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :marketplace\_username          | Username credential to connect to the Marketplace.                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :marketplace\_password          | Password to connect to the Marketplace.                                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :marketplace\_url               | Endpoint to connect to the Marketplace. If commented, a 503 ``service unavailable``                 |
|                                 | error will be returned to clients.                                                                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :oneflow\_server                | Endpoint to connect to the OneFlow server.                                                          |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :routes                         | List of files containing custom routes to be loaded.                                                |
|                                 | Check :ref:`server plugins <sunstone_dev>` for more info.                                           |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :mode                           | Default views directory.                                                                            |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :keep\_me\_logged               | True to display 'Keep me logged in' option in Sunstone login.                                       |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :get\_extended\_vm\_info        | True to display IP in table by requesting the extended vm pool to oned                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :get\_extended\_vm\_monitoring  | True to display external IPs in table by requesting the monitoring vm pool to oned                  |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :allow\_vnc\_federation         | True to display VNC icons in federation                                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :proxy                          | Proxy server for HTTP Traffic.                                                                      |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :no\_proxy                      | Patterns for IP addresses or domain names that shouldn’t use the proxy                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :paginate                       | Array for paginate, the first position is for internal use. the second is used to put               |
|                                 | names to each value                                                                                 |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :threshold_min                  | Minimum percentage value for green color on thresholds                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :threshold_low                  | Minimum percentage value for orange color on thresholds                                             |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :threshold_high                 | Minimum percentage value for red color on thresholds                                                |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :public_fireedge_endpoint       | URL or IP address where the Fireedge server is running.                                             |
|                                 | This endpoint must be accessible for Sunstone clients.                                              |
+---------------------------------+-----------------------------------------------------------------------------------------------------+
| :private_fireedge_endpoint      | URL or IP address where the Fireedge server is running.                                             |
|                                 | This endpoint must be accessible for Sunstone server.                                               |
+---------------------------------+-----------------------------------------------------------------------------------------------------+

.. note:: To use Sunstone with IPv6 only systems and thin HTTP sever, use the full IPv6 address in the
    field `:host`. If you need to set the localhost address (::1) or the unspecified address (::) please
    use the following:

    Example: :host: 0::1, :host: 0::0

Sunstone behavior can also be configured through the user template (within a SUNSTONE=[] vector
value, for instance SUNSTONE=[TABLE_ORDER="asc"]):

+---------------------------+-------------------------------------------------------------------+
|           Option          |                            Description                            |
+===========================+===================================================================+
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

.. code-block:: bash

    # service opennebula-sunstone start

You can find the Sunstone server log file in ``/var/log/one/sunstone.log``. Errors are logged in
``/var/log/one/sunstone.error``.

.. _fireedge_sunstone:

Fireedge and Sunstone
================================================================================

:ref:`Fireedge <fireedge_configuration>` provides the following extra functionality to Sunstone:

- :ref:`**Remote access your VM** <remote_access_sunstone>` using Guacamole and/or VMRC (`VMware Remote Console`).

- :ref:`**Resource state autorefresh** <autorefresh>`, VMs and host states are refreshed automatically.

Fireedge uses `Apache Guacamole <guacamole.apache.org>`_, a free and open source web
application which lets you access your dashboard from anywhere using a modern web browser.
It is a **clientless remote desktop gateway** which only requires Guacamole installed on a
server and a web browser supporting HTML5.

Guacamole supports multiple connection methods such as **VNC, RDP and ssh**.

Guacamole system is made up of two separate parts: **server and client**.

Guacamole server consists of the native server-side libraries required to connect to the
server and the **guacd** tool. Its **the Guacamole proxy daemon** which accepts the user’s
connections and connects to the remote desktop on their behalf.

.. note::
  The OpenNebula **binary packages** will configure Guacamole  server and client
  automatically, therefore you don’t need to take any extra steps.

Fireedge server acts like a **VMRC proxy** between Sunstone and ESX nodes through web socket.
You can read :ref:`more information <vmrc_sunstone>` about it configuration.

.. _fireedge_sunstone_configuration:

Configuring Sunstone for Guacamole
-------------------------------------------------------------------------------

To configure the Fireedge server on Sunstone when they are **on different servers**, you will need
to set public and private Fireedge server **endpoints** on :ref:`sunstone-server.conf <fireedge_install_configuration>`:

If they are on the **same server**, you can **skip this step**.

Also, if Fireedge is on another server, you must manually copy the file ``fireedge_key`` on
``/var/lib/one/.one`` since this file contains the cipher key for guacamole connections.

.. note::
  If you are building from source and using a self-contained installation you must copy the file ``fireedge_key`` on ``<self-contained folder>/var/.one/``


.. _remote_access_sunstone:

Accessing your VMs Console and Desktop
================================================================================
Sunstone provides several different methods to access your VM console and desktop: VNC, SPICE,
RDP, VMRC, ssh, and virt-viewer. If configured in the VM, these metods can be used to access the
VM console through Sunstone.
For some of those connections, we will need to start our brand new Fireedge server to establish
the remote connection. This section shows how these different technologies can be configured and
what are each requirement.

:ref:`Fireedge <fireedge_configuration>` automatically install dependencies
for  Guacamole connections and the VMRC proxy, which are necessary for use VNC, RDP, ssh, and VMRC.

+----------------+-------------------+---------------------+
|   Connection   |   With Fireedge   |  Without Fireedge   |
+================+===================+=====================+
| VNC            | Guacamole         | noVNC               |
+----------------+-------------------+---------------------+
| RDP            | Guacamole         | noVNC               |
+----------------+-------------------+---------------------+
| SSH            | Guacamole         | N/A                 |
+----------------+-------------------+---------------------+
| SPICE          | noVNC             | noVNC               |
+----------------+-------------------+---------------------+
| Virt-Viewer    | noVNC             | noVNC               |
+----------------+-------------------+---------------------+
| VMRC           | VMRC proxy        | N/A                 |
+----------------+-------------------+---------------------+

.. note:: For **VMRC** connections Sunstone and Fireedge must be installed on the **same server**.

.. important:: For Guacamole to work in Sunstone, **Fireedge server must be running**.
    See :ref:`Fireedge setup<fireedge_setup>` for more information.

.. _requirements_remote_access_sunstone:

Requirements for connections via noVNC
--------------------------------------------------------------------------------
The Sunstone Operation Center offers the possibility of starting a VNC/SPICE session to a Virtual
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
websockets**, and have them enabled. This is the default in current Chrome and Firefox, but former
versions of Firefox (i.e. 3.5) required manual activation. Otherwise Flash emulation will be used.

When using secure websockets, make sure that your certificate and key (if not included in the
certificate) are correctly set in the :ref:`Sunstone configuration files <suns_advance_ssl_proxy>`.
Note that your certificate must be valid and trusted for the wss connection to work.

If you are working with a certificate that it is not accepted by the browser, you can manually add
it to the browser trust list by visiting ``https://sunstone.server.address:vnc_proxy_port``.
The browser will warn that the certificate is not secure and prompt you to manually trust it.

.. note:: Installing the ``python-numpy`` package is recommended for better VNC performance.

.. _vnc_sunstone:

Configuring your VM for VNC
--------------------------------------------------------------------------------

VNC is a graphical console with wide support among many hypervisors and clients.

VNC without Fireedge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When clicking the VNC icon, a request is made, and if a VNC session is possible, the Sunstone server will add the VM
Host to the list of allowed vnc session targets and create a **random token** associated to it. The
server responds with the session token, then a ``noVNC`` dialog pops up.

The VNC console embedded in this dialog will try to connect to the proxy, either using websockets
(default) or emulating them using Flash. Only connections providing the right token will be successful.
The token expires and cannot be reused.

Make sure that you can connect directly from the Sunstone frontend to the VM using a normal VNC
client tool, such as ``vncviewer``.

.. _requirements_guacamole_vnc_sunstone:

VNC with Fireedge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Configuring your VM for RDP
--------------------------------------------------------------------------------

Short for **Remote Desktop Protocol**, allows one computer to connect to another computer
over a network in order to use it remotely. Is a graphical console primarily used with
Hyper-V.

RDP without Fireedge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

RDP connections are available on sunstone using noVNC. You will only have to download the
RDP file and open it with an RDP client to establish a connection with your Virtual Machine.

.. _requirements_guacamole_rdp_sunstone:

RDP with Fireedge
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Configuring your VM for SSH
--------------------------------------------------------------------------------

**SSH connections are available only when a reachable Firedge server is found**. Unlike VNC or RDP,
SSH is a text protocol. SSH connections require a hostname or IP address defining
the destination machine. :ref:`Like the RDP connection <requirements_guacamole_rdp_sunstone>`,
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


.. _spice_sunstone:

Configuring your VM for SPICE
--------------------------------------------------------------------------------

SPICE connections are channeled only through the noVNC proxy. SPICE support in Sunstone share
a similar architecture to the VNC implementation. Sunstone use a ``SPICE-HTML5`` widget in
its console dialog that communicates with the proxy by using websockets.

.. note:: For the correct functioning of the SPICE Web Client, we recommend defining by default
    some SPICE parameters in ``/etc/one/vmm_mad/vmm_exec_kvm.conf``. In this way, once modified the
    file and restarted OpenNebula, it will be applied to all the VMs instantiated from now on. You can
    also override these SPICE parameters in VM Template. For more info check :ref:`Driver Defaults
    <kvmg_default_attributes>` section.

.. _virt_viewer_sunstone:

Configuring your VM for virt-viewer
--------------------------------------------------------------------------------

virt-viewer connections are channeled only through the noVNC proxy. virt-viewer is a minimal tool
for displaying the graphical console of a virtual machine. It can **display VNC or SPICE protocol**,
and uses libvirt to lookup the graphical connection details.

In this case, Sunstone allows you to download **the virt-viewer configuration file** for the VNC and
SPICE protocols. The only requirement is the ``virt-viewer`` package.

To use this option, you will only have to enable any of two protocols in the VM. Once the VM is
``instantiated`` and ``running``, users will be able to download the virt-viewer file.

|sunstone_virt_viewer_button|

.. _vmrc_sunstone:

Configuring your VM for VMRC
--------------------------------------------------------------------------------

**VMRC connections are available only when a reachable Firedge server is found**.

VMware Remote Console provides console access and client device connection to VMs on a remote host.

These type of connections requests a ``TOKEN`` from vCenter to connect with the Virtual Machine
allocated on vCenter every time you click on the VMRC button.

To use this option, you will only have to enable VNC / VMRC connections to your VMs and start the
Fireedge Server.

|sunstone_vmrc|

.. _commercial_support_sunstone:

Commercial Support Integration
================================================================================

We are aware that in production environments, access to professional, efficient support is
a must, and this is why we have introduced an integrated tab in Sunstone to access
`OpenNebula Systems <http://opennebula.systems>`_ (the company behind OpenNebula, formerly C12G)
professional support. In this way, support ticket management can be performed through Sunstone,
avoiding disruption of work and enhancing productivity.

|support_home|

This tab and can be disabled in each one of the :ref:`view yaml files <suns_views>`.

.. code-block:: yaml

    enabled_tabs:
        [...]
        #- support-tab


.. _link_attribute_sunstone:

Link attribute
================================================================================
Editable template attributes are represented in some sections of Sunstone, for example
in the marketplace app section.

You can add an attribute with the name LINK and whose value is an external link. In this way,
the value of that attribute will be represented as a hyperlink.

|sunstone_link_attribute|


Troubleshooting
================================================================================

.. _sunstone_connect_oneflow:

Cannot connect to OneFlow server
--------------------------------------------------------------------------------

The Service instances and templates tabs may show the following message:

.. code::

    Cannot connect to OneFlow server

|sunstone_oneflow_error|

You need to start the OneFlow component :ref:`following this section <appflow_configure>`, or
disable the Service and Service Templates menu entries in the :ref:`Sunstone views yaml files
<suns_views>`.

Tuning & Extending
==================

Internationalization and Languages
--------------------------------------------------------------------------------

Sunstone supports multiple languages. If you want to contribute a new language, make corrections, or
complete a translation, you can visit our `Transifex project page <https://www.transifex.com/projects/p/one/>`_

Translating through Transifex is easy and quick. All translations should be submitted via Transifex.

Users can update or contribute translations anytime. Prior to every release, normally after the
beta release, a call for translations will be made in the forum. Then the source strings will be
updated in Transifex so all the translations can be updated to the latest OpenNebula version.
Translation with an acceptable level of completeness will be added to the final OpenNebula release.

Customize the VM Logos
--------------------------------------------------------------------------------

The VM Templates have an image logo to identify the guest OS. To modify the list of available
logos, or to add new ones, edit ``/etc/one/sunstone-logos.yaml``.

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

.. _sunstone_branding:

Branding the Sunstone Portal
--------------------------------------------------------------------------------

You can easily add your logos to the login and main screens by updating the ``logo:`` attribute as
follows:

- The login screen is defined in the ``/etc/one/sunstone-views.yaml``.
- The logo of the main UI screen is defined for each view in :ref:`the view yaml file <suns_views>`.

You can also change the color threshold values in the ``/etc/one/sunstone-server.conf``.

- The green color starts in ``:threshold_min:``
- The orange color starts in ``:threshold_low:``
- The red color starts in ``:threshold_high:``

sunstone-views.yaml
--------------------------------------------------------------------------------

OpenNebula Sunstone can be adapted to different user roles. For example, it will only show the
resources the users have access to. Its behavior can be customized and extended via
:ref:`views <suns_views>`.

The preferred method to select which views are available to each group is to update the group
configuration from Sunstone; as described in :ref:`Sunstone Views section <suns_views_configuring_access>`.
There is also the ``/etc/one/sunstone-views.yaml`` file that defines an alternative method to
set the view for each user or group.

Sunstone will calculate the views available to each user using:

* From all the groups the user belongs to, the views defined inside each group are combined and presented to the user.

* If no views are available from the user's group, the defaults would be fetched from ``/etc/one/sunstone-views.yaml``. Here, views can be defined for:

  * Each user (``users:`` section): list each user and the set of views available for her.
  * Each group (``groups:`` section): list the set of views for the group.
  * The default view: if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.
  * The default views for group admins: if a group admin user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default_groupadmin views will be used.

By default, users in the ``oneadmin`` group have access to all views, and users in the ``users``
group can use the ``cloud`` view.

The following ``/etc/one/sunstone-views.yaml`` example enables the user (user.yaml) and the
cloud (cloud.yaml) views for helen and the cloud (cloud.yaml) view for group cloud-users. If more
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

A Different Endpoint for Each View
--------------------------------------------------------------------------------

OpenNebula :ref:`Sunstone views <suns_views>` can be adapted to deploy a different endpoint for
each kind of user. For example if you want an endpoint for the admins and a different one for the
cloud users. You just have to deploy a :ref:`new sunstone server <suns_advance>` and set a default
view for each sunstone instance:

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
