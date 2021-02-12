.. _ignc:
.. _frontend_installation:

================================================================================
Front-end Installation
================================================================================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided on our site is the recommended method, to ensure the installation of the latest version, and to avoid possible package divergences with different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.io/use>`__ to **download the latest package** for your Linux distribution.

If there are no packages for your distribution, head to the :ref:`Building from Source Code guide <compile>`.

.. note:: Installing the frontend inside a LXD container is possible, however you will have limited functionality. The LXD marketplace shouldn't be usable in this situation. The frontend requires to mount a block device and this is not doable for a LXD container.

Step 1. SELinux on CentOS/RHEL (Optional)
================================================================================

Depending on the type of OpenNebula deployment, the SELinux can block some operations initiated by the OpenNebula Front-end, which results in a failure of the particular operation.  It's **not recommended to disable** the SELinux on production environments, as it degrades the security of your server, but to investigate and workaround each individual problem based on the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__. The administrator might disable the SELinux to temporarily workaround the problem or on non-production deployments by changing following line in ``/etc/selinux/config``:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.


.. note::

    Change the following line in ``/etc/selinux/config`` to **enable** SELinux back into the ``enforcing`` mode:

    .. code-block:: bash

        SELINUX=enforcing

    When changing from the ``disabled`` state, it's necessary to trigger filesystem relabel on the next boot by creating a file ``/.autorelabel``, e.g.:

    .. prompt:: bash $ auto

        $ touch /.autorelabel

    After the changes, you have to reboot the machine.

Step 2. Add OpenNebula Repositories
================================================================================

Refer to this :ref:`guide <repositories>` to add the community or enterprise edition repositories.

Step 3. Add 3rd Party Repositories
================================================================================

OpenNebula depends on packages which are not in the base distribution repositories. Enable 3rd party repositories required for you Front-end platform by running following commands under privileged user (``root``):

**CentOS 7**

.. prompt:: bash # auto

    # yum -y install epel-release
    # yum -y install centos-release-scl-rh

**CentOS 8**

.. prompt:: bash # auto

    # yum -y install epel-release

**RHEL 7**

.. prompt:: bash # auto

    # subscription-manager repos --enable rhel-7-server-optional-rpms
    # subscription-manager repos --enable rhel-7-server-extras-rpms
    # subscription-manager repos --enable rhel-server-rhscl-7-rpms
    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

**RHEL 8**

.. prompt:: bash # auto

    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

**Debian 9, Ubuntu 16.04 and 18.04**

.. prompt:: bash # auto

   # wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
   # source /etc/os-release
   # echo "deb https://deb.nodesource.com/node_12.x ${VERSION_CODENAME} main" >/etc/apt/sources.list.d/nodesource.list
   # apt-get update

.. _packages:

Step 3. Installing the Software
================================================================================

.. important::

   Few main packages were renamed in OpenNebula 6.0, see :ref:`Compatibility Guide <compatibility_pkg>`.

Available packages for the OpenNebula frontend and virtualization hosts:

+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
|              Package                  |                                     Description                                                               |
+=======================================+===============================================================================================================+
| **opennebula**                        | OpenNebula Daemon and Scheduler                                                                               |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-tools**                  | Command Line Interface                                                                                        |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-sunstone**               | GUI :ref:`Sunstone <sunstone>`                                                                                |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-fireedge**               | next-generation GUI :ref:`Fireedge <fireedge_setup>`                                                          |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-gate**                   | :ref:`OneGate <onegate_overview>` server which allows communication between VMs and OpenNebula                |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-flow**                   | :ref:`OneFlow <oneflow_overview>` manages services and elasticity                                             |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-provision**              | :ref:`OneProvision <ddc_overview>` deploys new clusters on remote bare-metal cloud providers                  |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-provision-data**         | Data for :ref:`OneProvision <ddc_overview>` tool                                                              |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-node-kvm**               | Dependencies and conf. for KVM hypervisor node                                                                |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-node-firecracker**       | Dependencies and conf. for Firecracker hypervisor node                                                        |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-node-lxd**               | Dependencies and conf. for LXD hypervisor node (*only on Ubuntu and Debian 10*)                               |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-lxd-snap**               | Meta-package to install LXD snap (*only on Ubuntu 16.04 and 18.04*)                                           |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-guacd**                  | Proxy daemon for Guacamole                                                                                    |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-rubygems**               | Bundled Ruby gem dependencies                                                                                 |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-libs**                   | Shared Ruby libraries among various components                                                                |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-common**                 | Shared content for OpenNebula packages                                                                        |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-common-onecfg**          | Helpers for onecfg tool                                                                                       |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| rpm: **opennebula-debuginfo** |br|    | Package with debug information                                                                                |
| deb: **opennebula-dbgsym**            |                                                                                                               |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| rpm: **opennebula-java** |br|         | :ref:`Java OCA <java>` Bindings                                                                               |
| deb: **libopennebula-java** |br|      |                                                                                                               |
| deb: **libopennebula-java-doc**       |                                                                                                               |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **python3-pyone**                     | :ref:`Python 3 OCA <python>` Bindings                                                                         |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **python-pyone**                      | :ref:`Python 2 OCA <python>` Bindings (*not on Fedora, Ubuntu 20.04 and later*)                               |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **docker-machine-opennebula**         | OpenNebula driver for Docker Machine                                                                          |
+---------------------------------------+---------------------------------------------------------------------------------------------------------------+

.. todo:: Correct link to docker-machine-opennebula (OpenNebula driver for Docker Machine <docker_machine_overview>`)

.. note::

   There are a few differencies in package names among distributions. Those with varying package names contain mostly integration libraries and since they are for general use on installation hosts, their names are left to follow the distribution conventions. Find above the CentOS/RHEL/Fedora specific packages prefixed with "*rpm:*" and Debian/Ubuntu specific packages prefixed with "*deb:*".

CentOS / RHEL / Fedora
----------------------

Install all OpenNebula Front-end components by executing following commands under a privileged user:

.. prompt:: bash # auto

    # yum -y install opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision

**Optional**

1. Install dependencies for :ref:`Docker Hub Marketplace <market_dh>`:

- install Docker following the official documention for `CentOS <https://docs.docker.com/engine/install/centos/>`_ or `Fedora <https://docs.docker.com/engine/install/fedora/>`_
- add user ``oneadmin`` into group ``docker``:

.. prompt:: bash # auto

    # usermod -a -G docker oneadmin

2. Install dependencies for OpenNebula provisioning features:

.. todo:: Adapt to python3 commands

.. prompt:: bash # auto

    # yum -y install python-pip
    # pip install 'ansible>=2.8.0,<2.10.0'
    # pip install 'Jinja2>=2.10.0'
    # curl 'https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip' | zcat >/usr/bin/terraform
    # chmod 0755 /usr/bin/terraform

Debian / Ubuntu
---------------

Install all OpenNebula Front-end components by executing following commands under a privileged user:

.. prompt:: bash # auto

    # apt-get update
    # apt-get -y install opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision

**Optional**

1. Install dependencies for :ref:`Docker Hub Marketplace <market_dh>`:

- install Docker following the official documention for `Debian <https://docs.docker.com/engine/install/debian/>`_ or `Ubuntu <https://docs.docker.com/engine/install/ubuntu/>`_
- add user ``oneadmin`` into group ``docker``:

.. prompt:: bash # auto

    # usermod -a -G docker oneadmin

2. Install dependencies for OpenNebula provisioning features:

.. todo:: Adapt to python3 commands

.. prompt:: bash # auto

    # apt-get -y install python-pip
    # pip install 'ansible>=2.8.0,<2.10.0'
    # pip install 'Jinja2>=2.10.0'
    # curl 'https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip' | zcat >/usr/bin/terraform
    # chmod 0755 /usr/bin/terraform

.. _ruby_runtime:

Step 4. Install Ruby Dependencies System-wide (Optional)
================================================================================

.. todo:: Probably this should be better moved on different page not to confuse users.

.. important::

   Optional step for **new installations**. When **upgrading** existing deployment, you have to proceeed with installing via ``install_gems`` below if not using the shipped Ruby gems (i.e., when symbolic link ``/usr/share/one/gems`` doesn't exist).

.. warning::

    Since OpenNebula 5.10, this step is **optional** and all required Ruby gems are provided within **opennebula-rubygems** package. Ruby gems are installed into a dedicated directory ``/usr/share/one/gems-dist/``, but OpenNebula uses them via (symlinked) location ``/usr/share/one/gems/`` which points to the ``gems-dist/`` directory. When the ``gems/`` directory (by default on new installations) exists, OpenNebula uses the gems inside **exclusively** by removing any other system Ruby gems locations from the search paths!

    .. prompt:: bash # auto

        # ls -lad /usr/share/one/gems*
        lrwxrwxrwx 1 root root    9 Aug 13 11:41 /usr/share/one/gems -> gems-dist
        drwxr-xr-x 9 root root 4096 Aug 13 11:41 /usr/share/one/gems-dist

    If you want to use the system-wide Ruby gems instead of the packaged ones, remove the symlink ``/usr/share/one/gems/`` and install all required dependencies with the ``install_gems`` script described below. The removed ``/usr/share/one/gems/`` symlink **won't be created again on the next OpenNebula upgrade**. Ruby gems shipped with OpenNebula can't be avoided or uninstalled, but their use can be disabled by removing the ``/usr/share/one/gems/`` symlink.

    If additional Ruby gems are needed by custom drivers or hooks, they must be installed into the introduced dedicated directory. For example, set gem name in ``$GEM_NAME`` and run under privileged user root:

    .. prompt:: bash # auto

        # export GEM_PATH=/usr/share/one/gems/
        # export GEM_HOME=/usr/share/one/gems/
        # gem install --install-dir /usr/share/one/gems/ --bindir /usr/share/one/gems/bin/ --no-document --conservative $GEM_NAME

Several OpenNebula components depend on Ruby and specific Ruby libraries (gems). They are distributed alongside with the OpenNebula, but available to and used exclusively by the OpenNebula. For the advanced usage, you can use following commands to install all Ruby libraries system-wide and enforce OpenNebula to use them:

.. prompt:: bash # auto

    # test -L /usr/share/one/gems && unlink /usr/share/one/gems
    # /usr/share/one/install_gems

Step 5. Enabling MySQL/MariaDB/PostgreSQL (Optional)
================================================================================

You can skip this step if you just want to deploy OpenNebula as quickly as possible. However if you are deploying this for production, or in a more serious environment, make sure you read the :ref:`MySQL Setup <mysql_setup>` or :ref:`PostgreSQL Setup <postgresql_setup>` sections.

Note that it **is** possible to switch from SQLite to MySQL, but since it's more cumbersome to migrate databases, we suggest that, if in doubt, use MySQL from the start. It is not possible to automatically migrate existing databases to PostgreSQL.

Step 6. Configuring OpenNebula
================================================================================

OpenNebula Daemon
-----------------

.. important::

    This is **only for initial** OpenNebula deployment, not applicable for upgrades!

Initial OpenNebula deployment on a very first start creates a user ``oneadmin`` **inside the OpenNebula** (not to be confused with system user ``oneadmin`` in the Front-end operating system!) based on randomly generated password read from ``/var/lib/one/.one/one_auth``. To set the own user password since the very start, proceed with following steps before starting the services:

1. Login in as the ``oneadmin`` system user with this command:

.. prompt:: bash # auto

    # sudo -u oneadmin /bin/sh

2. Create file ``/var/lib/one/.one/one_auth`` with initial password in a format ``oneadmin:<password>``

.. prompt:: bash $ auto

    $ echo 'oneadmin:mypassword' > ~/.one/one_auth

.. warning:: This will set the oneadmin's password only on the first start of the OpenNebula. From that point, you must use the ``oneuser passwd`` command to change oneadmin's password. More information on how to change the oneadmin password is :ref:`here <change_credentials>`.

.. note::

    For advanced configuration, follow to the OpenNebula Daemon :ref:`configuration <oned_conf>` reference.

.. todo:: Add link to scheduler configuration?

OneGate (Optional)
------------------

The OneGate server allows the communication between VMs and OpenNebula. It's optional and not required for basic functionality, but essential for multi-VM services orchestrated by OneFlow server. The configuration is two-phase - configure OneGate server to listen for the connections from outside of the Front-end and configure OpenNebula Daemon with OneGate end-point passed to the virtual machines. None or both must be done.

1. To configure OneGate, edit ``/etc/one/onegate-server.conf`` and update the ``:host`` parameter with service listen address accordingly. For example, use ``0.0.0.0`` to work on all configured network interfaces on the Front-end:

.. code::

    :host: 0.0.0.0

2. To configure OpenNebula Daemon, edit ``/etc/one/oned.conf`` and set the ``ONEGATE_ENDPOINT`` with the URL and port of your OneGate server (domain or IP-based). The end-point address **must be reachable directly from your future virtual machines**. You need to decide what virtual networks and addressing will be used in your cloud. For example:

.. code::

    ONEGATE_ENDPOINT="http://one.example.com:5030"

If you are reconfiguring any time later already running services, don't forget to restart them to apply the changes.

.. note::

    For advanced configuration, follow to the OneGate :ref:`configuration <onegate_configure>` reference.

FireEdge (Optional)
-------------------

The OpenNebula FireEdge is the evolving next-generation GUI, with features (currently only) the clusters provisioning and Guacamole VNC. It's optional and not required for basic functionality, but essential for clusters provisioning. You need to configure Sunstone with the public endpoint of the FireEdge, so that one service can redirect user to the other.

To configure public FireEdge endpoint in the Sunstone, edit ``/etc/one/sunstone-server.conf`` and update the ``:public_fireedge_endpoint`` with the base URL (domain or IP-based) over which **end-users** can access the service. For example:

.. code::

    :public_fireedge_endpoint: http://one.example.com:2616

If you are reconfiguring any time later already running services, don't forget to restart them to apply the changes.

.. note::

    For advanced configuration, follow to the FireEdge :ref:`configuration <fireedge_configuration>` reference.

OneFlow (Optional)
------------------

The OneFlow server orchestrates the services, multi-VM deployments. While for most cases the default configuration fits well, you might need to reconfigure the service to be able to control the OneFlow **remotely** over API. Edit the ``/etc/one/oneflow-server.conf`` and update ``:host:`` parameter with service listen address accordingly. For example, use ``0.0.0.0`` to work on all configured network interfaces on the Front-end:

.. code::

    :host: 0.0.0.0

If you are reconfiguring any time later already running services, don't forget to restart them to apply the changes.

.. note::

    For advanced configuration, follow to the OneFlow :ref:`configuration <appflow_configure>` reference.

.. _frontend_services:

Step 7. Starting and Managing OpenNebula Services
================================================================================

The complete list of operating system services OpenNebula comes with:

+---------------------------------------+------------------------------------------------------------------------+---------------------------+
|              Service                  |                                     Description                        | Auto-Starts With          |
+=======================================+========================================================================+===========================+
| **opennebula**                        | Main OpenNebula Daemon (oned)                                          |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-scheduler**              | Scheduler                                                              | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-hem**                    | Hook Execution Service                                                 | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-sunstone**               | GUI :ref:`Sunstone <sunstone>`                                         |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-fireedge**               | next-generation GUI :ref:`Fireedge <fireedge_setup>`                   |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-gate**                   | OneGate Server for communication between VMs and OpenNebula            |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-flow**                   | OneFlow Server for multi-VM services                                   |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-guacd**                  | Guacamole Proxy Daemon                                                 | opennebula-fireedge       |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-novnc**                  | noVNC Server                                                           | opennebula-sunstone       |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-showback**               | Service for periodic recalculation of showback                         | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-ssh-agent**              | Dedicated SSH agent for OpenNebula Daemon                              | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-ssh-socks-cleaner**      | Periodic cleaner of SSH persistent connections                         | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+

.. note:: Since 5.12, the OpenNebula comes with an integrated SSH agent as the ``opennebula-ssh-agent`` service which removes the need to copy oneadmin's SSH private key across your hosts. For more info you can look at the :ref:`passwordless login <kvm_ssh>` section of the manual. You can opt to disable this service and configure your environment the old way.

You are ready to **start** the OpenNebula all services by following command:

.. prompt:: bash # auto

    # systemctl start opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow

.. warning::

   Make sure all required :ref:`network ports <frontend_fw>` are enabled on your firewall (on Front-end or the router).

Other OpenNebula services might be started as a dependency, but you don't need to care about them unless they need to be explicitly restarted or stopped. To start these services automatically **on server boot**, it's necessary to enable them by following command:

.. prompt:: bash # auto

    # systemctl enable opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow

.. _verify_frontend_section:

Step 8. Verifying the Installation
================================================================================

After OpenNebula is started for the first time, you should check that the commands can connect to the OpenNebula daemon. You can do this in the Linux CLI or in the graphical user interface Sunstone.

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

The OpenNebula logs are located in ``/var/log/one``, there should be at least the files ``/var/log/one/oned.log`` (main OpenNebula daemon) and ``/var/log/one/sched.log`` (scheduler). Check ``oned.log`` for any error messages marked with ``[E]``.

.. _verify_frontend_section_sunstone:

Sunstone
--------------------------------------------------------------------------------

.. note::

   Make sure the TCP port 9869 is allowed on your firewall.

Now you can try to log in to Sunstone graphical interface. To do this, point your browser to ``http://<frontend_address>:9869``.

You should be greeted with a login page, the access user is ``oneadmin`` and initial (or customized) password is the one in the file ``/var/lib/one/.one/one_auth`` in your Front-end.

If the page does not load, make sure to you check ``/var/log/one/sunstone.log`` and ``/var/log/one/sunstone.error``

Directory Structure
--------------------------------------------------------------------------------

The following table lists some notable paths that are available in your Frontend after the installation:

+-------------------------------------+--------------------------------------------------------------------------------------+
|                 Path                |                                     Description                                      |
+=====================================+======================================================================================+
| ``/etc/one/``                       | **Configuration files**                                                              |
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
| ``/var/lib/one/remotes/etc``        | **Configuration files** for probes and scripts                                       |
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

.. _frontend_fw:

Firewall Configuration
--------------------------------------------------------------------------------

The list below shows the ports used by OpenNebula. These ports need to be open for OpenNebula to work properly:

+------------+------------------------------------------------------------------------------+
|   Port     |                     Description                                              |
+============+==============================================================================+
| ``22``     | Front-end host SSH server                                                    |
+------------+------------------------------------------------------------------------------+
| ``2474``   | OneFlow server                                                               |
+------------+------------------------------------------------------------------------------+
| ``2616``   | Next-generation GUI server FireEdge                                          |
+------------+------------------------------------------------------------------------------+
| ``2633``   | Main OpenNebula Daemon (oned), XML-RPC API endpoint                          |
+------------+------------------------------------------------------------------------------+
| ``4124``   | Monitoring daemon (both TCP/UDP)                                             |
+------------+------------------------------------------------------------------------------+
| ``5030``   | OneGate server                                                               |
+------------+------------------------------------------------------------------------------+
| ``9869``   | GUI server Sunstone                                                          |
+------------+------------------------------------------------------------------------------+
| ``29876``  | noVNC proxy                                                                  |
+------------+------------------------------------------------------------------------------+

.. note::

    These are only the default ports. Each component can be configured to bind to specific ports or use a HTTP Proxy.

OpenNebula connects to the hypervisors through SSH (port 22). Additionally, main OpenNebula daemon (oned) may connect to various remote Marketplace servers to get a list of available appliances, e.g.:

- OpenNebula Marketplace (``https://marketplace.opennebula.io/``)
- Linux Containers Makerplace (``https://images.linuxcontainers.org/``)
- TurnKey Linux (``http://mirror.turnkeylinux.org/``)
- Docker Hub (``https://hub.docker.com/``)

You should open the outgoing connections to these services.

Step 9. Stop and Restart Services
================================================================================

.. todo:: IMHO It doesn't fit here anywhere.

To stop, start or restart any of the listed individual :ref:`services <frontend_services>`, follow the examples below for a selected service:

.. prompt:: bash # auto

    # systemctl stop        opennebula
    # systemctl start       opennebula
    # systemctl restart     opennebula
    # systemctl try-restart opennebula

Use following command to **stop all** OpenNebula services:

.. prompt:: bash # auto

    # systemctl stop opennebula opennebula-scheduler opennebula-hem \
        opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow \
        opennebula-guacd opennebula-novnc opennebula-showback.timer \
        opennebula-ssh-agent opennebula-ssh-socks-cleaner.timer

Use following command to **restart all** already running OpenNebula services:

.. prompt:: bash # auto

    # systemctl try-restart opennebula opennebula-scheduler opennebula-hem \
        opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow \
        opennebula-guacd opennebula-novnc opennebula-ssh-agent

Learn more about `Managing Services with Systemd <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/managing-services-with-systemd_configuring-basic-system-settings#managing-system-services_managing-services-with-systemd>`__.

On production environments the services should be stopped in specific order and with extra manual safety checks:

1. stop **opennebula-scheduler**
2. stop **opennebula-sunstone** and **opennebula-fireedge**
3. stop **openenbula-flow**
4. check and wait until there are no active operations with VMs and images
5. stop **opennebula**

.. todo:: Provide some commands for point 4?

Step 10. Next steps
================================================================================

Now that you have successfully started your OpenNebula service, head over to the :ref:`Node Installation <node_installation>` chapter in order to add hypervisors to your cloud.

.. note:: To change oneadmin password, follow the next steps:

    .. prompt:: bash # auto

        #oneuser passwd 0 <PASSWORD>
        #echo 'oneadmin:PASSWORD' > /var/lib/one/.one/one_auth

    Test that everything works using `oneuser show`.

.. |image0| image:: /images/debian-opennebula.png

.. |br| raw:: html

  <br/>
