.. _ignc:
.. _frontend_installation:

================================================================================
Front-end Installation
================================================================================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided on our site is the recommended method, to ensure the installation of the latest version, and to avoid possible package divergences with different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.io/use>`__ to **download the latest package** for your Linux distribution.

If there are no packages for your distribution, head to the :ref:`Building from Source Code guide <compile>`.

.. note:: Installing the frontend inside a LXD container is possible, however you will have limited functionality. The LXD marketplace shouldn't be usable in this situation. The frontend requires to mount a block device and this is not doable for a LXD container.


Step 1. SELinux on CentOS/RHEL
================================================================================

SELinux can block some operations initiated by the OpenNebula Front-end, which results in failures. If the administrator isn't experienced in SELinux configuration, **it's recommended to disable this functionality to avoid unexpected failures**. You can enable SELinux anytime later when you have the installation working.

Disable SELinux (recommended)
-----------------------------

Change the following line in ``/etc/selinux/config`` to **disable** SELinux:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.

Enable SELinux
--------------

Change the following line in ``/etc/selinux/config`` to **enable** SELinux in ``enforcing`` state:

.. code-block:: bash

    SELINUX=enforcing

When changing from the ``disabled`` state, it's necessary to trigger filesystem relabel on the next boot by creating a file ``/.autorelabel``, e.g.:

.. prompt:: bash $ auto

    $ touch /.autorelabel

After the changes, you should reboot the machine.

.. note:: Follow the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__ for more information on how to configure and troubleshoot SELinux.

Step 2. Add OpenNebula Repositories
================================================================================

.. include:: ../repositories.txt

Step 3. Installing the Software
================================================================================

Installing on CentOS/RHEL
-------------------------

OpenNebula depends on packages which are not in the base repositories.
The following repositories have to be enabled before installation:

* only RHEL 7: **optional** and **extras** RHEL repositories
* `EPEL <https://fedoraproject.org/wiki/EPEL>`__ (Extra Packages for Enterprise Linux)

Repository EPEL
^^^^^^^^^^^^^^^

On **CentOS**, enabling EPEL is as easy as installation of the package with additional repository configuration:

.. prompt:: bash # auto

    # yum install epel-release


On **RHEL 7**, you enable EPEL by running:

.. note:: RHEL 7 **optional** and **extras** repositories must be configured first.

.. prompt:: bash # auto

    # subscription-manager repos --enable rhel-7-server-optional-rpms
    # subscription-manager repos --enable rhel-7-server-extras-rpms
    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

On **RHEL 8**, you enable EPEL by running:

.. prompt:: bash # auto

    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

Install OpenNebula
^^^^^^^^^^^^^^^^^^

Install the CentOS/RHEL OpenNebula Front-end with packages from **our repository** by executing the following as root:

.. prompt:: bash # auto

    # yum install opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow

**CentOS/RHEL Package Description**

The packages for the OpenNebula frontend and the virtualization host are as follows:

* **opennebula**: Command Line Interface.
* **opennebula-server**: Main OpenNebula daemon, scheduler, etc.
* **opennebula-sunstone**: :ref:`Sunstone <sunstone>` (the GUI) and the :ref:`EC2 API <introc>`.
* **opennebula-gate**: :ref:`OneGate <onegate_overview>` server that enables communication between VMs and OpenNebula.
* **opennebula-flow**: :ref:`OneFlow <oneflow_overview>` manages services and elasticity.
* **opennebula-provision**: :ref:`OneProvision <ddc_overview>` deploys new clusters on remote bare-metal cloud providers.
* **opennebula-node-kvm**: Meta-package that installs the oneadmin user, libvirt and kvm.
* **opennebula-common**: Common files for OpenNebula packages.
* **opennebula-rubygems**: All Ruby gem dependencies.
* **opennebula-debuginfo**: Package with debug information.
* **opennebula-ruby**: Ruby Bindings.
* **opennebula-java**: Java Bindings.
* **python-pyone**: Python Bindings.
* **python3-pyone**: Python3 Bindings.

.. note::

    The configuration files are located in ``/etc/one`` and ``/var/lib/one/remotes/etc``.

Installing on Debian/Ubuntu
---------------------------

To install OpenNebula on a Debian/Ubuntu Front-end using packages from **our repositories** execute as root:

.. prompt:: bash # auto

    # apt-get update
    # apt-get install opennebula opennebula-sunstone opennebula-gate opennebula-flow

**Debian/Ubuntu Package Description**

These are the packages available for these distributions:

* **opennebula**: OpenNebula Daemon.
* **opennebula-common**: Provides the user and common files.
* **opennebula-tools**: Command Line interface.
* **opennebula-sunstone**: :ref:`Sunstone <sunstone>` (the GUI).
* **opennebula-gate**: :ref:`OneGate <onegate_overview>` server that enables communication between VMs and OpenNebula.
* **opennebula-flow**: :ref:`OneFlow <oneflow_overview>` manages services and elasticity.
* **opennebula-provision**: :ref:`OneProvision <ddc_overview>` deploys new clusters on remote bare-metal cloud providers.
* **opennebula-node**: Prepares a node as an opennebula KVM node.
* **opennebula-node-lxd**: Prepares a node as an opennebula LXD node.
* **opennebula-lxd-snap**: Installs LXD snap (only on Ubuntu 16.04 and 18.04).
* **opennebula-rubygems**: All Ruby gem dependencies.
* **opennebula-dbgsym**: Package with debug information.
* **ruby-opennebula**: Ruby API.
* **libopennebula-java**: Java API.
* **libopennebula-java-doc**: Java API Documentation.
* **python-pyone**: Python API.
* **python3-pyone**: Python3 Bindings.

.. note::

    The configuration files are located in ``/etc/one`` and ``/var/lib/one/remotes/etc``.

.. _ruby_runtime:

Step 4. Ruby Runtime Installation (Optional)
================================================================================

.. warning::

    Since OpenNebula 5.10, this step is **optional** and all required Ruby gems are provided within **opennebula-rubygems** package. Ruby gems are installed into a dedicated directory ``/usr/share/one/gems-dist/``, but OpenNebula uses them via (symlinked) location ``/usr/share/one/gems/`` which points to the ``gems-dist/`` directory. When the ``gems/`` directory (by default on new installations) exists, OpenNebula uses the gems inside **exclusively** by removing any other system Ruby gems locations from the search paths!

    .. prompt:: bash # auto

        # ls -lad /usr/share/one/gems*
        lrwxrwxrwx 1 root root    9 Aug 13 11:41 /usr/share/one/gems -> gems-dist
        drwxr-xr-x 9 root root 4096 Aug 13 11:41 /usr/share/one/gems-dist

    If you want to use the system-wide Ruby gems instead of the packaged ones, remove the symlink ``/usr/share/one/gems/`` and install all required dependencies with the ``install_gems`` script described below. The removed ``/usr/share/one/gems/`` symlink **won't be created again on the next OpenNebula upgrade**. OpenNebula-shipped Ruby gems can't be uninstalled, but their use can be disabled by removing the ``/usr/share/one/gems/`` symlink.

    If additional Ruby gems are needed by custom drivers or hooks, they must be installed into the introduced dedicated directory. For example, set gem name in ``$GEM_NAME`` and run under privileged user root:

    .. prompt:: bash # auto

        # export GEM_PATH=/usr/share/one/gems/
        # export GEM_HOME=/usr/share/one/gems/
        # gem install --no-document --conservative $GEM_NAME

Some OpenNebula components need Ruby libraries. OpenNebula provides a script that installs the required gems as well as some development library packages needed.

As root execute:

.. prompt:: bash # auto

    # test -L /usr/share/one/gems && unlink /usr/share/one/gems
    # /usr/share/one/install_gems

The previous script is prepared to detect common Linux distributions and install the required libraries. If it fails to find the packages needed in your system, manually install these packages:

* sqlite3 development library
* mysql client development library
* PostgreSQL client development library
* curl development library
* libxml2 and libxslt development libraries
* ruby development library
* gcc and g++
* make

If you want to install only a set of gems for a specific component, read :ref:`Building from Source Code <compile>` where it is explained in more depth.

Step 5. Enabling MySQL/MariaDB/PostgreSQL (Optional)
================================================================================

You can skip this step if you just want to deploy OpenNebula as quickly as possible. However if you are deploying this for production, or in a more serious environment, make sure you read the :ref:`MySQL Setup <mysql_setup>` or :ref:`PostgreSQL Setup <postgresql_setup>` sections.

Note that it **is** possible to switch from SQLite to MySQL, but since it's more cumbersome to migrate databases, we suggest that, if in doubt, use MySQL from the start. It is not possible to automatically migrate existing databases to PostgreSQL.

Step 6. Starting OpenNebula
================================================================================

.. warning::
    If you are performing an upgrade, skip this and the next steps and go back to the upgrade document.

Log in as the ``oneadmin`` user follow these steps:

The ``/var/lib/one/.one/one_auth`` fill will have been created with a randomly-generated password. It should contain the following: ``oneadmin:<password>``. Feel free to change the password before starting OpenNebula. For example:

.. prompt:: bash $ auto

    $ echo "oneadmin:mypassword" > ~/.one/one_auth

.. warning:: This will set the oneadmin password on the first boot. From that point, you must use the `oneuser passwd` command to change oneadmin's password. More information on how to change the oneadmin password is :ref:`here <change_credentials>`.

You are ready to start the OpenNebula daemons - via ``systemctl`` like this:

.. prompt:: bash # auto

    # systemctl start opennebula
    # systemctl start opennebula-sunstone

Or if you are used to the old ``service`` command:

.. prompt:: bash # auto

    # service opennebula start
    # service opennebula-sunstone start

.. note:: Since 5.12, the OpenNebula comes with an integrated SSH agent as the ``opennebula-ssh-agent`` service which removes the need to copy oneadmin's SSH private key across your hosts. For more info you can look at the :ref:`passwordless login <kvm_ssh>` section of the manual. You can opt to disable this service and configure your environment the old way.

.. _verify_frontend_section:

Step 7. Verifying the Installation
================================================================================

After OpenNebula is started for the first time, you should check that the commands can connect to the OpenNebula daemon. You can do this in the Linux CLI or in the graphical user interface: Sunstone.

Linux CLI
--------------------------------------------------------------------------------

In the Front-end, run the following command as oneadmin:

.. prompt:: bash $ auto

    $ oneuser show
    USER 0 INFORMATION
    ID              : 0
    NAME            : oneadmin
    GROUP           : oneadmin
    PASSWORD        : 3bc15c8aae3e4124dd409035f32ea2fd6835efc9
    AUTH_DRIVER     : core
    ENABLED         : Yes

    USER TEMPLATE
    TOKEN_PASSWORD="ec21d27e2fe4f9ed08a396cbd47b08b8e0a4ca3c"

    RESOURCE USAGE & QUOTAS


If you get an error message, then the OpenNebula daemon could not be started properly:

.. prompt:: bash $ auto

    $ oneuser show
    Failed to open TCP connection to localhost:2633 (Connection refused - connect(2) for "localhost" port 2633)

The OpenNebula logs are located in ``/var/log/one``. You should have at least the files ``oned.log`` and ``sched.log``, the core and scheduler logs. Check ``oned.log`` for any error messages, marked with ``[E]``.

.. _verify_frontend_section_sunstone:

Sunstone
--------------------------------------------------------------------------------

Now you can try to log in to Sunstone web interface. To do this, point your browser to ``http://<frontend_address>:9869``. If everything is OK you will be greeted with a login page. The user is ``oneadmin`` and the password is the one in the file ``/var/lib/one/.one/one_auth`` in your Front-end.

If the page does not load, make sure you check ``/var/log/one/sunstone.log`` and ``/var/log/one/sunstone.error``. Also, make sure TCP port 9869 is allowed through the firewall.

Directory Structure
--------------------------------------------------------------------------------

The following table lists some notable paths that are available in your Frontend after the installation:

+-------------------------------------+--------------------------------------------------------------------------------------+
|                 Path                |                                     Description                                      |
+=====================================+======================================================================================+
| ``/etc/one/``                       | Configuration Files                                                                  |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/log/one/``                   | Log files, notably: ``oned.log``, ``sched.log``, ``sunstone.log`` and ``<vmid>.log`` |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/``                   | ``oneadmin`` home directory                                                          |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/datastores/<dsid>/`` | Storage for the datastores                                                           |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/vms/<vmid>/``        | Action files for VMs (deployment file, transfer manager scripts, etc...)             |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/.one/one_auth``      | ``oneadmin`` credentials                                                             |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/``           | Probes and scripts that will be synced to the Hosts                                  |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/hooks/``     | Hook scripts                                                                         |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/vmm/``       | Virtual Machine Manager Driver scripts                                               |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/auth/``      | Authentication Driver scripts                                                        |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/im/``        | Information Manager (monitoring) Driver scripts                                      |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/market/``    | MarketPlace Driver scripts                                                           |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/datastore/`` | Datastore Driver scripts                                                             |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/vnm/``       | Networking Driver scripts                                                            |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/lib/one/remotes/tm/``        | Transfer Manager Driver scripts                                                      |
+-------------------------------------+--------------------------------------------------------------------------------------+

Firewall configuration
--------------------------------------------------------------------------------

The list below shows the ports used by OpenNebula. These ports need to be open for OpenNebula to work properly:

+-------------------------------------+-------------------------------------------------------------------------------------------------------------+
|                 Port                |                     Description                                                                             |
+=====================================+=============================================================================================================+
| ``9869``                            | Sunstone server.                                                                                            |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------+
| ``29876``                           | VNC proxy port, used for translating and redirecting VNC connections to the hypervisors.                    |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------+
| ``2633``                            | OpenNebula daemon, main XML-RPC API endpoint.                                                               |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------+
| ``2474``                            | OneFlow server. This port only needs to be opened if OneFlow server is used.                                |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------+
| ``5030``                            | OneGate server. This port only needs to be opened if OneGate server is used.                                |
+-------------------------------------+-------------------------------------------------------------------------------------------------------------+

OpenNebula connects to the hypervisors through ssh (port 22). Additionally ``oned`` may connect to the OpenNebula Marketplace (``https://marketplace.opennebula.systems/``) and Linux Containers Makerplace (``https://images.linuxcontainers.org``) to get a list of available appliances. You should open outgoing connections to these ports and protocols. Note: These are the default ports; each component can be configure to bind to specific ports or use an HTTP Proxy.


Step 8. Next steps
================================================================================

Now that you have successfully started your OpenNebula service, head over to the :ref:`Node Installation <node_installation>` chapter in order to add hypervisors to your cloud.

.. note:: To change oneadmin password, follow the next steps:

    .. prompt:: bash # auto

        #oneuser passwd 0 <PASSWORD>
        #echo 'oneadmin:PASSWORD' > /var/lib/one/.one/one_auth

    Test that everything works using `oneuser show`.

.. |image0| image:: /images/debian-opennebula.png
