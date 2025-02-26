.. _upgrade_single:

================================================================================
Upgrading Single Front-end Deployments
================================================================================

If you are upgrading from a 6.10.x installation you only need to follow a reduced set of steps. If you are running a 6.8.x version or older, please check :ref:`these set of steps <upgrading_from_previous_extended_steps>` (some additional ones may apply, please review them at the end of the section).

.. important::

    Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this `online form <https://opennebula.io/get-migration>`__. In order to use these non-commercial migrators to upgrade to the latest CE release (OpenNebula 6.8.0), you will need to upgrade your existing OpenNebula environment first to CE Patch Release 6.8.0.1

.. important:: If you haven't done so, please enable the :ref:`OpenNebula and needed 3rd party repositories <setup_opennebula_repos>` before attempting the upgrade process.

.. _upgrade_610:

Upgrading from 6.10.x
^^^^^^^^^^^^^^^^^^^^^

This section describes the installation procedure for systems that are already running a 6.10.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations.

When performing a minor upgrade OpenNebula adheres to the following convention to ease the process:

  * No changes are made to the configuration files, so no configuration file will be changed during the upgrade.
  * Database versions are preserved, so no upgrade of the database schema is needed.

When a critical bug requires an exception to the previous rules it will be explicitly noted in this guide.

Step 1. Stop OpenNebula Services
================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (run, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Now you are ready to stop OpenNebula and any other related services you may have running, e.g. Sunstone or OneFlow. It's preferable to use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Step 2. Upgrade Front-end to the New Version
============================================

Upgrade the OpenNebula software using the package manager of your OS. Refer to the :ref:`Single Front-end Installation guide <frontend_installation>` for a complete list of the OpenNebula packages installed on your system. Package repos need to be pointing to the latest version (|version|).

For example, in CentOS/RHEL simply execute:

.. prompt:: text # auto

    # yum upgrade opennebula

For Debian/Ubuntu use:

.. prompt:: text # auto

   # apt-get update
   # apt-get install --only-upgrade opennebula

Step 3. Upgrade Hypervisors to the New Version
==============================================

You can skip this section for vCenter Hosts.

Upgrade the OpenNebula node KVM or LXC packages, using the package manager of your OS.

For example, in a rpm-based Linux distribution simply execute:

.. prompt:: text # auto

   # yum upgrade opennebula-node-kvm

For deb-based distros use:

.. prompt:: text # auto

   # apt-get update
   # apt-get install --only-upgrade opennebula-node-kvm

.. note:: If you are using LXC the package is ``opennebula-node-lxc``.

Step 4. Update the Drivers
==========================

You should now be able to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the Hosts.

.. note:: You can skip this step if you are not using KVM Hosts, or any Hosts that use remote monitoring probes.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers if needed, as outlined in the Step 12 below.

.. _upgrading_from_previous_extended_steps:


Upgrading from 6.x and higher
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migrate, epilog, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set All Hosts to Disable Mode
================================================================================

Set all Hosts to disable mode to stop all monitoring processes.

.. prompt:: bash $ auto

   $ onehost disable <host_id>

Step 3. Stop OpenNebula
================================================================================

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running FireEdge service behind Apache/Nginx, please stop also the Apache/Nginx service.

.. warning:: Make sure that every OpenNebula process is stopped. The output of ``systemctl list-units | grep opennebula`` should be empty.

Step 4. Back-up OpenNebula Configuration
================================================================================

Back-up the configuration files located in ``/etc/one`` and ``/var/lib/one/remotes/etc``. You don't need to do a manual backup of your database; the ``onedb`` command will perform one automatically.

.. prompt:: bash $ auto

    $ cp -ra /etc/one /etc/one.$(date +'%Y-%m-%d')
    $ cp -ra /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')
    $ onedb backup

Step 5. Upgrade OpenNebula Packages Repository
================================================================================

In order to be able to retrieve the packages for the latest version, you need to update the OpenNebula packages repository. The instructions for doing this are detailed :ref:`here <repositories>`.

Step 6. Upgrade to the New Version
================================================================================

Ubuntu/Debian

.. prompt:: bash $ auto

    $ apt-get update
    $ apt-get install --only-upgrade opennebula opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone

RHEL

.. prompt:: bash $ auto

    $ yum upgrade opennebula opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone

.. warning:: Sunstone on Apache

    If upgrading a Front-end where Sunstone is deployed through an **Apache web server**, bear in mind that the upgrade may cause :ref:`filesystem permissions <sunstone_fs_permissions>` to be reset. If this happens Apache will be unable to access Sunstone files, and users be unable to access the Sunstone UI. The Apache log will show an entry like below:

    .. code-block::

        [Mon Feb 14 11:10:09.133702 2022] [core:error] [pid 668659:tid 140354620548864] [client 10.141.18.116:60062] AH00037: Symbolic link not allowed or link target not accessible: /usr/lib/one/sunstone/public/dist/main.js, referer:

    To prevent this problem, reapply the correct file permissions after upgrading.

Community Edition
--------------------------------------------------------------------------------

If upgrading OpenNebula CE, you will need to install the ``opennebula-migration-community`` package on your Front-end.

If you are upgrading to the *latest* version, you will need to download the package from the `Get Migration Packages <https://opennebula.io/get-migration>`__ page.

If you are upgrading to any prior version (such as upgrading from 6.6 to 6.8), then the migration package is already included in the OpenNebula repositories.

To install the migration package:

On RHEL:

.. prompt:: bash $ auto

    $ rpm -i opennebula-migration-community*.rpm

On Debian/Ubuntu:

.. prompt:: bash $ auto

	$ dpkg -i opennebula-migration-community*.deb

.. note::

    Before downloading the migration package, it's a good idea to double-check the URL in your software repository file. Ensure that the URL includes the software major and minor version (in ``<major>.<minor>`` format), but not the exact release.

    For example, for OpenNebula version 6.10, the file should point to ``https://downloads.opennebula.io/repo/6.10`` and not ``https://downloads.opennebula.io/repo/6.10.0``. The first case will include migration packages for 6.10.*, whereas the second case will exclude minor versions such as 6.10.0.1.

Step 7. Update Configuration Files
================================================================================

In HA setups it is necessary to replace in the file ``/etc/one/monitord.conf`` the default value ``auto`` of ``MONITOR_ADDRESS`` attributed to the virtual IP address used in RAFT_LEADER_HOOK and RAFT_FOLLOWER_HOOK in ``/etc/one/oned.conf``.

Community Edition
--------------------------------------------------------------------------------

In order to update the configuration files with your existing customizations you'll need to:

- Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one`` and ``diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc``. You can use graphical diff-tools like ``meld`` to compare both directories; they are very useful in this step.
- Edit the **new** files and port all the customizations from the previous version.

Enterprise Edition
--------------------------------------------------------------------------------

If you have modified configuration files, let's use ``onecfg`` to automate the configuration file upgrades.

Before upgrading OpenNebula, you need to ensure that the configuration state is clean without any pending migrations from past or outdated configurations. Run ``onecfg status`` to check the configuration state.

A clean state might look like this:

.. prompt:: bash $ auto

    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  6.8.3
    Config:      6.8.0

    --- Available Configuration Updates -------
    No updates available.

Unknown Configuration Version Error
--------------------------------------------------------------------------------

If you get error message about an unknown configuration version, you don't need to do anything. The configuration version will be automatically initialized during the OpenNebula upgrade. The configuration of the current version will be based on the former OpenNebula version.

.. prompt:: bash $ auto

    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  6.8.3
    Config:      unknown
    ERROR: Unknown config version

Configuration Metadata Outdated Error
--------------------------------------------------------------------------------

If the configuration tool complains about outdated metadata, you have not run a configuration upgrade during some of the past OpenNebula upgrades. Please note, configuration must be upgraded or processed with even OpenNebula's maintenance releases.

The following invalid state:

.. prompt:: bash $ auto

    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  6.8.3
    Config:      6.8.0
    ERROR: Configurations metadata are outdated.

needs to be fixed by reinitialization of the configuration state. Any unprocessed upgrades will be lost and the current state will be initialized based on your current OpenNebula version and configurations located in system directories.

.. prompt:: bash $ auto

    $ onecfg init --force
    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  6.8.3
    Config:      6.8.3

    --- Available Configuration Updates -------
    No updates available.

After checking the state of configuration, in most cases running the following command without any extra parameters will suffice, as it will upgrade the probes based on the internal configuration version tracking of the currently installed OpenNebula.

.. prompt:: bash $ auto

     $ onecfg upgrade
     ANY   : Backup stored in '/tmp/onescape/backups/2020-6...
     ANY   : Configuration updated to 6.2.1

If you get conflicts when running ``onecfg`` upgrade refer to the :ref:`onecfg upgrade basic usage documentation <cfg_usage>` on how to upgrade and troubleshoot the configurations, in particular the :ref:`onecfg upgrade doc <cfg_upgrade>` and the :ref:`troubleshooting section <cfg_conflicts>`.

Step 8. Upgrade the Database Version
================================================================================

.. important:: Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this `online form <https://opennebula.io/get-migration>`__.

Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically. Simply run the ``onedb upgrade -v`` command. The connection parameters are automatically retrieved from ``/etc/one/oned.conf``.

Step 9. Check DB Consistency
================================================================================

First, move the |version| backup file created by the upgrade command to a safe place. If you face any issues, the ``onedb`` command can restore this backup, but it won't downgrade databases to previous versions. Then, execute the ``onedb fsck`` command:

.. prompt:: bash $ auto

    $ onedb fsck
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Step 10. Start OpenNebula
================================================================================

Start OpenNebula and any other related services: OneFlow, OneGate & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running FireEdge service behind Apache/Nginx, please start also the Apache/Nginx service.

Step 11. Restore Custom Probes
================================================================================

If you have any custom monitoring probes, follow :ref:`these instructions <devel-im>`, to update them to the new monitoring system

Step 12. Update the Hypervisors
================================================================================

.. warning:: If you're using vCenter please skip to the next step.

Update the virtualization, storage and networking drivers.  As the ``oneadmin`` user, execute:

.. prompt:: bash $ auto

   $ onehost sync

Then log in to your hypervisor Hosts and update the ``opennebula-node`` packages:

Ubuntu/Debian

.. prompt:: bash $ auto

    $ apt-get install --only-upgrade opennebula-node-<hypervisor>

RHEL

.. prompt:: bash $ auto

    $ yum upgrade opennebula-node-<hypervisor>

.. note:: Note that the ``<hypervisor>`` tag should be replaced by the name of the corresponding hypervisor (i.e ``kvm`` or ``lxc``).

.. important::  For KVM hypervisor it's necessary to restart also the libvirt service

Step 13. Enable Hosts
================================================================================

Enable all Hosts, disabled in step 2:

.. prompt:: bash $ auto

   $ onehost enable <host_id>

If upgrading from a version earlier than 6.0, please see :ref:`Upgrading from Previous Versions <upgrade_from_previous>`.

Testing
================================================================================

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in ``oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).

Restoring the Previous Version
================================================================================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers if needed, as outlined in Step 12.

.. |br| raw:: html

  <br/>
