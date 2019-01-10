.. _ignc:
.. _frontend_installation:

================================================================================
Front-end Installation
================================================================================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided in our site is the recommended method, to ensure the installation of the latest version and to avoid possible packages divergences of different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.org/software:software>`__ to **download the latest package** for your Linux distribution.

If there are no packages for your distribution, head to the :ref:`Building from Source Code guide <compile>`.

Step 1. Disable SElinux in CentOS/RHEL 7
================================================================================

SElinux can cause some problems, like not trusting ``oneadmin`` user's SSH credentials. You can disable it changing in the file ``/etc/selinux/config`` this line:

.. code-block:: bash

    SELINUX=disabled

After this file is changed reboot the machine.

Step 2. Add OpenNebula Repositories
================================================================================

.. include:: ../repositories.txt

Step 3. Installing the Software
================================================================================

Installing on CentOS/RHEL 7
---------------------------

Before installing:

* Activate the `EPEL <http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F>`__ repo. In CentOS this can be done with the following command:

.. prompt:: bash # auto

    # yum install epel-release

There are packages for the Front-end, distributed in the various components that conform OpenNebula, and packages for the virtualization host.

To install a CentOS/RHEL OpenNebula Front-end with packages from **our repository**, execute the following as root.

.. prompt:: bash # auto

    # yum install opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow

**CentOS/RHEL Package Description**

These are the packages available for this distribution:

* **opennebula**: Command Line Interface.
* **opennebula-server**: Main OpenNebula daemon, scheduler, etc.
* **opennebula-sunstone**: :ref:`Sunstone <sunstone>` (the GUI) and the :ref:`EC2 API <introc>`.
* **opennebula-ruby**: Ruby Bindings.
* **opennebula-java**: Java Bindings.
* **opennebula-gate**: :ref:`OneGate <onegate_overview>` server that enables communication between VMs and OpenNebula.
* **opennebula-flow**: :ref:`OneFlow <oneflow_overview>` manages services and elasticity.
* **opennebula-node-kvm**: Meta-package that installs the oneadmin user, libvirt and kvm.
* **opennebula-common**: Common files for OpenNebula packages.

.. note::

    The files located in ``/etc/one`` and ``/var/lib/one/remotes`` are marked as configuration files.

Installing on Debian/Ubuntu
---------------------------

To install OpenNebula on a Debian/Ubuntu Front-end using packages from **our repositories** execute as root:

.. prompt:: bash # auto

    # apt-get update
    # apt-get install opennebula opennebula-sunstone opennebula-gate opennebula-flow

**Debian/Ubuntu Package Description**

These are the packages available for these distributions:

|image0|

* **opennebula-common**: Provides the user and common files.
* **ruby-opennebula**: Ruby API.
* **libopennebula-java**: Java API.
* **libopennebula-java-doc**: Java API Documentation.
* **opennebula-node**: Prepares a node as an opennebula-node.
* **opennebula-sunstone**: :ref:`Sunstone <sunstone>` (the GUI).
* **opennebula-tools**: Command Line interface.
* **opennebula-gate**: :ref:`OneGate <onegate_overview>` server that enables communication between VMs and OpenNebula.
* **opennebula-flow**: :ref:`OneFlow <oneflow_overview>` manages services and elasticity.
* **opennebula**: OpenNebula Daemon.

.. note::

    Besides ``/etc/one``, the following files are marked as configuration files:

    * ``/var/lib/one/remotes/datastore/ceph/ceph.conf``
    * ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``

.. _ruby_runtime:

Step 4. Ruby Runtime Installation
================================================================================

Some OpenNebula components need Ruby libraries. OpenNebula provides a script that installs the required gems as well as some development libraries packages needed.

As root execute:

.. prompt:: bash # auto

    # /usr/share/one/install_gems

.. warning::
    The `Bundler <https://bundler.io/>`__ (Ruby application dependencies management tool) is installed by ``install_gems`` if missing. Installation can fail, as the latest versions might be incompatible with older Ruby versions. You have to install a suitable version of Bundler manually and run ``install_gems`` again. As root execute:

    .. prompt:: bash # auto

        # gem install bundler --version '< 2'
        # /usr/share/one/install_gems

The previous script is prepared to detect common Linux distributions and install the required libraries. If it fails to find the packages needed in your system, manually install these packages:

* sqlite3 development library
* mysql client development library
* curl development library
* libxml2 and libxslt development libraries
* ruby development library
* gcc and g++
* make

If you want to install only a set of gems for an specific component read :ref:`Building from Source Code <compile>` where it is explained in more depth.

Step 5. Enabling MySQL/MariaDB (Optional)
================================================================================

You can skip this step if you just want to deploy OpenNebula as quickly as possible. However if you are deploying this for production or in a more serious environment, make sure you read the :ref:`MySQL Setup <mysql_setup>` section.

Note that it **is** possible to switch from SQLite to MySQL, but since it's more cumbersome to migrate databases, we suggest that if in doubt, use MySQL from the start.

Step 6. Starting OpenNebula
================================================================================

.. warning::
    If you are performing an upgrade skip this and the next steps and go back to the upgrade document.

Log in as the ``oneadmin`` user follow these steps:

The ``/var/lib/one/.one/one_auth`` fill will have been created with a randomly-generated password. It should contain the following: ``oneadmin:<password>``. Feel free to change the password before starting OpenNebula. For example:

.. prompt:: bash $ auto

    $ echo "oneadmin:mypassword" > ~/.one/one_auth

.. warning:: This will set the oneadmin password on the first boot. From that point, you must use the :ref:`oneuser passwd <manage_users>` command to change oneadmin's password.

You are ready to start the OpenNebula daemons. You can use systemctl for Linux distributions which have adopted systemd:

.. prompt:: bash # auto

    # systemctl start opennebula
    # systemctl start opennebula-sunstone

Or use service in older Linux systems:

.. prompt:: bash # auto

    # service opennebula start
    # service opennebula-sunstone start

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

The OpenNebula logs are located in ``/var/log/one``, you should have at least the files ``oned.log`` and ``sched.log``, the core and scheduler logs. Check ``oned.log`` for any error messages, marked with ``[E]``.

.. _verify_frontend_section_sunstone:

Sunstone
--------------------------------------------------------------------------------

Now you can try to log in into Sunstone web interface. To do this point your browser to ``http://<fontend_address>:9869``. If everything is OK you will be greeted with a login page. The user is ``oneadmin`` and the password is the one in the file ``/var/lib/one/.one/one_auth`` in your Front-end.

If the page does not load, make sure you check ``/var/log/one/sunstone.log`` and ``/var/log/one/sunstone.error``. Also, make sure TCP port 9869 is allowed through the firewall.

Directory Structure
--------------------------------------------------------------------------------

The following table lists some notable paths that are available in your Front-end after the installation:

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

Step 8. Next steps
================================================================================

Now that you have successfully started your OpenNebula service, head over to the :ref:`Node Installation <node_installation>` chapter in order to add hypervisors to your cloud.

.. |image0| image:: /images/debian-opennebula.png
