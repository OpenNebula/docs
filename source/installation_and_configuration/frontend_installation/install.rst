.. _ignc:
.. _frontend_installation:

================================================================================
Single Front-end Installation
================================================================================

This page describes how to install a complete OpenNebula Front-end from binary packages available in the :ref:`software repositories <repositories>` configured in the previous section. We recommend using a Host with the supported operating system as installation from packages provides the best experience and is referenced from other places of this documentation. If there are no packages for your distribution, you might consider reading the :ref:`Building from Source Code <compile>` guide to build OpenNebula on your own.

Proceed with the following steps to get the fully-featured OpenNebula Front-end up.

.. _setup_opennebula_repos:

Step 1. Configure the OpenNebula Repositories
================================================================================

Follow the :ref:`OpenNebula Repositories <repositories>` guide and add software repositories for the OpenNebula edition you are going to deploy.


Step 2. Add 3rd Party Repositories
================================================================================

Not all OpenNebula dependencies are in base distribution repositories. On selected platforms below you need to enable 3rd party repositories by running the following commands under privileged user (``root``):

**AlmaLinux 8,9**

.. prompt:: bash # auto

    # yum -y install epel-release


**RHEL 8**

.. prompt:: bash # auto

    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

**RHEL 9**

.. prompt:: bash # auto

    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

.. _packages:

Step 3. Installing the Software
================================================================================

Available packages for OpenNebula clients, the Front-end and hypervisor Nodes:

+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
|              Package                     |                                     Description                                                               |
+==========================================+===============================================================================================================+
| **opennebula**                           | OpenNebula Daemon and Scheduler (*EE comes with additional Enterprise Tools*)                                 |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-tools**                     | Command Line Interface                                                                                        |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-fireedge**                  | Next-generation GUI :ref:`FireEdge <fireedge_setup>`                                                          |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-gate**                      | :ref:`OneGate <onegate_overview>` server which allows communication between VMs and OpenNebula                |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-flow**                      | :ref:`OneFlow <oneflow_overview>` manages services and elasticity                                             |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-migration**                 | Database migration tools for EE (*only in EE*)                                                                |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-migration-community**       | Database migration tools for CE - please request via `online form <https://opennebula.io/get-migration/>`__   |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-provision**                 | Tools to provision :ref:`Edge Clusters <try_hybrid_overview>`                                                 |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-provision-data**            | Data for :ref:`Edge Clusters <try_hybrid_overview>` provisioning tools                                        |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-node-kvm**                  | Base setup for KVM hyp. Node                                                                                  |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-node-lxc**                  | Base setup for LXC hypervisor Node (*not on RHEL 7*)                                                          |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-guacd**                     | Proxy daemon for Guacamole                                                                                    |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-rubygems**                  | Bundled Ruby gem dependencies                                                                                 |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-libs**                      | Shared Ruby libraries among various components                                                                |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-common**                    | Shared content for OpenNebula packages                                                                        |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **opennebula-common-onecfg**             | Helpers for :ref:`Configuration Management <cfg>` tool                                                        |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| rpm: **opennebula-java** |br|            | :ref:`Java OCA <java>` Bindings                                                                               |
| deb: **libopennebula-java** |br|         |                                                                                                               |
| deb: **libopennebula-java-doc**          |                                                                                                               |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+
| **python3-pyone**                        | :ref:`Python 3 OCA <python>` Bindings                                                                         |
+------------------------------------------+---------------------------------------------------------------------------------------------------------------+

There are also packages with debugging symbols for some platforms, e.g. ``openenbula-debuginfo`` on AlmaLinux/RHEL and ``opennebula-dbgsym`` on Debian/Ubuntu. Other architecture-specific components might come with similarly named packages, please query your packaging database if necessary.

.. note::

   There are a few differences in package names among distributions. Those with varying package names contain mostly integration libraries and since they are for general use on installation Hosts, their names are left to follow the distribution conventions. Above, you can find the AlmaLinux/RHEL specific packages prefixed with "*rpm:*" and Debian/Ubuntu specific packages prefixed with "*deb:*".


Install all OpenNebula Front-end components by executing the following commands under a privileged user:

AlmaLinux / RHEL
--------------------------

.. prompt:: bash # auto

    # yum -y install opennebula opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision


Debian / Ubuntu
---------------

.. prompt:: bash # auto

    # apt-get update
    # apt-get -y install opennebula opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision


Optional: Install dependencies for OpenNebula Edge Clusters provisioning
------------------------------------------------------------------------

There are 2 main dependencies which needs to be installed on the FE for running provisioning.

1. **Terraform** -- is needed to provision resources on public cloud providers, download the binary as follows

.. prompt:: bash # auto

    # curl 'https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip' | zcat >/usr/bin/terraform
    # chmod 0755 /usr/bin/terraform


2. **Ansible** -- is used to configure the provisioned resources (cloud or on-premise). Ansible system package is installed
as a dependency of the opennebula-provision package. However for HCI provisioning including Ceph, the system-installed
ansible version may not be sufficient as it requires ansible-core 2.15+. It is advised to use latest Ubuntu for the FE if
Ceph HCI provision is needed or install ansible 2.15+ on the system and make it default for oneadmin user.


Step 3. Enabling MySQL/MariaDB (Optional)
================================================================================

You can skip this step if you want to deploy OpenNebula as quickly as possible for evaluation.

If you are deploying Front-end for production/serious use, make sure you read the :ref:`Database Setup <database_setup>` guide and select the suitable database Back-end. Although it **is** possible to switch from (default) SQLite to MySQL/MariaDB Back-end later, it's not easy and straightforward, so **we suggest to deploy and use MySQL/MariaDB Back-end from the very beginning**.

Step 4. Configuring OpenNebula
================================================================================

OpenNebula Daemon
-----------------

.. important::

    This is **only for initial** OpenNebula deployment, not applicable for upgrades!

OpenNebula's initial deployment on first usage creates a user ``oneadmin`` **inside the OpenNebula** (not to be confused with system user ``oneadmin`` in the Front-end operating system!) based on a randomly generated password read from ``/var/lib/one/.one/one_auth``. To set your own user password from the very beginning, proceed with the following steps before starting the services:

1. Log in as the ``oneadmin`` system user with this command:

.. prompt:: bash # auto

    # sudo -u oneadmin /bin/sh

2. Create file ``/var/lib/one/.one/one_auth`` with initial password in the format ``oneadmin:<password>``

.. prompt:: bash $ auto

    $ echo 'oneadmin:changeme123' > /var/lib/one/.one/one_auth

.. warning:: This will set the oneadmin's password only upon starting OpenNebula for the first time. From that point, you must use the ``oneuser passwd`` command to change oneadmin's password. More information on how to change the oneadmin password is :ref:`here <change_credentials>`.

Check how to :ref:`change oneadmin password <change_credentials>` for already running services.

.. note::

    For advanced setup, follow the configuration references for OpenNebula :ref:`Daemon <oned_conf>` and :ref:`Scheduler <schg>`.

FireEdge
--------

OpenNebula FireEdge is the next-generation web UI server that replaces the legacy Ruby Sunstone. It provides the Sunstone GUI --- including additional functionality via Guacamole --- as well as the OneProvision GUI for provisioning clusters. It is installed and configured by default.

.. note::

    For advanced setup, follow the FireEdge :ref:`configuration reference <fireedge_configuration>`.

OneGate (Optional)
------------------

The OneGate server allows communication between VMs and OpenNebula. It's optional and not required for basic functionality but is essential for multi-VM services orchestrated by OneFlow server below. The configuration is two-phase - configure the OneGate server to listen for the connections from outside the Front-end and configure the OpenNebula Daemon with OneGate end-point passed to the virtual machines. Neither or both must be done.

1. To configure OneGate, edit ``/etc/one/onegate-server.conf`` and update the ``:host`` parameter with service listening address accordingly. For example, use ``0.0.0.0`` to work on all configured network interfaces on the Front-end:

.. code::

    :host: 0.0.0.0

2. To configure OpenNebula Daemon, edit ``/etc/one/oned.conf`` and set the ``ONEGATE_ENDPOINT`` with the URL and port of your OneGate server (domain or IP-based). The end-point address **must be reachable directly from your future virtual machines**. You need to decide what virtual networks and addresses will be used in your cloud. For example:

.. code::

    ONEGATE_ENDPOINT="http://one.example.com:5030"

If you are reconfiguring already running services at a later point, don't forget to restart them to apply the changes.

.. note::

    For advanced setup, follow the OneGate :ref:`configuration reference <onegate_conf>`.

OneFlow (Optional)
------------------

The OneFlow server orchestrates the services and multi-VM deployments. While for most cases the default configuration fits well, you might need to reconfigure the service to be able to control the OneFlow **remotely** over API. Edit the ``/etc/one/oneflow-server.conf`` and update ``:host:`` parameter with service listening address accordingly. For example, use ``0.0.0.0`` to work on all configured network interfaces on the Front-end:

.. code::

    :host: 0.0.0.0

If you are reconfiguring already running services at a later point, don't forget to restart them to apply the changes.

.. note::

    For advanced setup, follow the OneFlow :ref:`configuration reference <appflow_configure>`.

.. _frontend_services:

Step 5. Starting and Managing OpenNebula Services
================================================================================

The complete list of operating system services provided by OpenNebula:

+---------------------------------------+------------------------------------------------------------------------+---------------------------+
|              Service                  |                                     Description                        | Auto-Starts With          |
+=======================================+========================================================================+===========================+
| **opennebula**                        | Main OpenNebula Daemon (oned), XML-RPC API endpoint                    |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-scheduler**              | Scheduler                                                              | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-hem**                    | Hook Execution Service                                                 | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-fireedge**               | Next-generation GUI server :ref:`FireEdge <fireedge_setup>`            |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-gate**                   | OneGate Server for communication between VMs and OpenNebula            |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-flow**                   | OneFlow Server for multi-VM services                                   |                           |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-guacd**                  | Guacamole Proxy Daemon                                                 | opennebula-fireedge       |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-showback**               | Service for periodic recalculation of showback                         | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-ssh-agent**              | Dedicated SSH agent for OpenNebula Daemon                              | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+
| **opennebula-ssh-socks-cleaner**      | Periodic cleaner of SSH persistent connections                         | opennebula                |
+---------------------------------------+------------------------------------------------------------------------+---------------------------+

.. note:: Since 5.12, the OpenNebula comes with an integrated SSH agent as the ``opennebula-ssh-agent`` service which removes the need to copy oneadmin's SSH private key across your Hosts. For more information, refer to the :ref:`passwordless login <kvm_local>` section of the manual.

You are ready to **start** all OpenNebula services with the following command (NOTE: you might want to remove the services from the command arguments if you skipped their configuration steps above):

.. prompt:: bash # auto

    # systemctl start opennebula opennebula-fireedge opennebula-gate opennebula-flow

.. warning::

   Make sure all required :ref:`network ports <frontend_fw>` are enabled on your firewall (on Front-end or the router).

Other OpenNebula services might be started as a dependency but you don't need to care about them unless they need to be explicitly restarted or stopped. To start these **services automatically on server boot**, it's necessary to enable them by the following command:

.. prompt:: bash # auto

    # systemctl enable opennebula opennebula-fireedge opennebula-gate opennebula-flow

.. _verify_frontend_section:

Step 6. Verifying the Installation
================================================================================

After OpenNebula is started for the first time, you should check that the commands can connect to the OpenNebula daemon. You can do this in the Linux CLI or the graphical user interface Sunstone.

Linux CLI
---------

In the Front-end, run the following command as ``oneadmin`` system user and find a similar output:

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

If you get an error message then the OpenNebula Daemon could not be started properly:

.. prompt:: bash $ auto

    $ oneuser show
    Failed to open TCP connection to localhost:2633 (Connection refused - connect(2) for "localhost" port 2633)

You can investigate the OpenNebula logs in ``/var/log/one``, check files ``/var/log/one/oned.log`` (main OpenNebula Daemon log) and ``/var/log/one/sched.log`` (OpenNebula Scheduler log). Check for any error messages marked with ``[E]``.

.. _verify_frontend_section_sunstone:

FireEdge
--------------------------------------------------------------------------------

.. note::

   Make sure the TCP port 2616 is not blocked on your firewall.

Now you can try to log in through the Sunstone GUI and Provision GUI. To do so, point your browser to ``http://<frontend_address>:2616/fireedge/sunstone`` to access to Sunstone and point your browser to ``http://<frontend_address>:2616/fireedge/provision`` to access to Provision. You should get to the login page in both cases. The access user is ``oneadmin`` and initial (or customized) password is the one from the file ``/var/lib/one/.one/one_auth`` on your Front-end.

|sunstone_login|

In case of problems, you can investigate the OpenNebula logs in ``/var/log/one`` and check file ``/var/log/one/fireedge.log``.

Directory Structure
--------------------------------------------------------------------------------

The following table lists few significant directories on your OpenNebula Front-end:

+-------------------------------------+--------------------------------------------------------------------------------------+
|                 Path                |                                     Description                                      |
+=====================================+======================================================================================+
| ``/etc/one/``                       | **Configuration files**                                                              |
+-------------------------------------+--------------------------------------------------------------------------------------+
| ``/var/log/one/``                   | Log files, e.g. ``oned.log``, ``sched.log``, ``fireedge.log`` and ``<vmid>.log``     |
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
| ``29876``  | noVNC Proxy Server                                                           |
+------------+------------------------------------------------------------------------------+

.. note::

    These are only the default ports. Each component can be configured to bind to specific ports or use a HTTP Proxy.

OpenNebula connects to the hypervisor Nodes over SSH (port 22). Additionally, the main OpenNebula Daemon (oned) may connect to various remote Marketplace servers to get a list of available appliances, e.g.:

- OpenNebula Marketplace (``https://marketplace.opennebula.io/``)
- Linux Containers Marketplace (``https://images.linuxcontainers.org/``)

You should open the outgoing connections to these services.

Step 7. Stop and Restart Services (Optional)
================================================================================

To stop, start or restart any of the listed individual :ref:`services <frontend_services>`, follow the examples below for a selected service:

.. prompt:: bash # auto

    # systemctl stop        opennebula
    # systemctl start       opennebula
    # systemctl restart     opennebula
    # systemctl try-restart opennebula

Use following command to **stop all** OpenNebula services:

.. prompt:: bash # auto

    # systemctl stop opennebula opennebula-scheduler opennebula-hem \
        opennebula-fireedge opennebula-gate opennebula-flow \
        opennebula-guacd opennebula-novnc opennebula-showback.timer \
        opennebula-ssh-agent opennebula-ssh-socks-cleaner.timer

Use the following command to **restart all** already running OpenNebula services:

.. prompt:: bash # auto

    # systemctl try-restart opennebula opennebula-scheduler opennebula-hem \
        opennebula-fireedge opennebula-gate opennebula-flow \
        opennebula-guacd opennebula-novnc opennebula-ssh-agent

Learn more about `Managing Services with Systemd <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/managing-services-with-systemd_configuring-basic-system-settings#managing-system-services_managing-services-with-systemd>`__.

In production environments the services should be stopped in a specific order and with extra manual safety checks:

1. Stop **opennebula-scheduler** to stop planning deployment of VMs.
2. Stop **opennebula-fireedge** to disable GUI access to users.
3. Stop **openenbula-flow** to disable unattended multi-VM options.
4. Check and wait until there are no active operations with VMs and images.
5. Stop **opennebula** and rest services.

Step 8. Next steps
================================================================================

Now that you have successfully started your OpenNebula services, you can continue with adding content to your cloud. Add hypervisor Nodes, storage, and Virtual Networks. Or you can provision Users with Groups and permissions, Images, define and run Virtual Machines.

Continue with the following guides:

- :ref:`Open Cluster Deployment <open_cluster_deployment>` to provision hypervisor Nodes, storage, and Virtual Networks.
- :ref:`Management and Operations <operations_guide>` to add Users, Groups, Images, define Virtual Machines, and a lot more ...

.. |sunstone_login| image:: /images/sunstone-login.png
   :width: 350
   :align: middle

.. |br| raw:: html

  <br/>
