.. _upgrade_single:

================================================================================
Upgrading Single Front-end Deployments
================================================================================

If you are upgrading from a :ref:`5.12.x <upgrade_512>` installation you only need to follow a reduced set of steps. If you are running a 5.10.x version or older, please check these :ref:`set of steps <upgrading_from_previous_extended_steps>` (some additional ones may apply, please review them at the end of the section).

.. _upgrade_512:

Upgrading from 5.12.x
^^^^^^^^^^^^^^^^^^^^^

This section describes the installation procedure for systems that are already running a 5.12.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

When performing a minor upgrade OpenNebula adheres to the following convention to ease the process:

  * No changes are made to the configuration files, so no configuration file will be changed during the upgrade.
  * Database versions are preserved, so no upgrade of the database schema is needed.

When a critical bug requires an exception to the previous rules it will be explicitly noted in this guide.

Upgrading a Federation and High Availability
================================================================================

You need to perform the following steps in all the HA nodes and all zones. You can upgrade the servers one by one to not incur in any downtime.

Step 1 Stop OpenNebula services
===============================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Now you are ready to stop OpenNebula and any other related services you may have running, e.g. Sunstone or OneFlow. Use preferably the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Step 2 Upgrade frontend to the new version
==========================================

Upgrade the OpenNebula software using the package manager of your OS. Refer to the :ref:`Installation guide <ignc>` for a complete list of the OpenNebula packages installed in your system. Package repos need to be pointing to the latest version (|version|).

For example, in CentOS/RHEL simply execute:

.. prompt:: text # auto

    # yum upgrade opennebula

For Debian/Ubuntuy use:

.. prompt:: text # auto

   # apt-get update
   # apt-get install --only-upgrade opennebula

Step 3 Upgrade hypervisors to the new version
=============================================

You can skip this section for vCenter hosts.

Upgrade the OpenNebula node KVM or LXD packages, using the package manager of your OS.

For example, in a rpm based Linux distribution simply execute:

.. prompt:: text # auto

   # yum upgrade opennebula-node-kvm

For deb based distros use:

.. prompt:: text # auto

   # apt-get update
   # apt-get install --only-upgrade opennebula-node-kvm

.. note:: If you are using LXD the package is ``opennebula-node-lxd``.

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the hosts.

.. note:: You can skip this step if you are not using KVM hosts, or any hosts that use remove monitoring probes.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers as described above.

.. _upgrading_from_previous_extended_steps:


Upgrading from 5.6.x+
^^^^^^^^^^^^^^^^^^^^^

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set all Host to Offline Mode
================================================================================

Set all host to offline mode to stop all monitoring processes

Step 3. Stop OpenNebula
================================================================================

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Preferably use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

.. warning:: Make sure that every OpenNebula process is stopped. The output of `systemctl list-units | grep opennebula` should be empty.

Step 4. Backup OpenNebula Configuration
================================================================================

Backup the configuration files located in **/etc/one** and **/var/lib/one/remotes/etc**. You don't need to do a manual backup of your database, the ``onedb`` command will perform one automatically.

.. prompt:: text # auto

    # cp -ra /etc/one /etc/one.$(date +'%Y-%m-%d')
    # cp -ra /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')

Step 5. Upgrade to the New Version
================================================================================

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get update
    # apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision python3-pyone

CentOS/RHEL

.. prompt:: text # auto

    # yum upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision python-pyone python3-pyone

Step 6. Update Configuration Files
================================================================================

If you haven't modified any configuration files, you can skip this step and proceed to the next one.

In HA setups it is necessary to replace in file ``/etc/one/monitord.conf`` the default value ``auto`` of ``MONITOR_ADDRESS`` attribute by the virtual IP address used in RAFT_LEADER_HOOK and RAFT_FOLLOWER_HOOK in ``/etc/one/oned.conf``.

Community Edition
-----------------

In order to update the configuration files with your existing customizations you'll need to:

#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one`` and ``diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc``. You can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.

Enterprise Edition
------------------

If you have modified configuration files lets's use onecfg to automate the configuration file upgrades.

Before upgrading OpenNebula, you need to ensure that configuration state is clean without any pending migrations from past or outdated configurations. Run ``onecfg status`` to check the configuration state.

Clean state might look like:

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.0

        --- Available Configuration Updates -------
        No updates available.

Unknown Configuration Version Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you get error message about unknown configuration version, you don't need to do anything. Configuration version will be automatically initialized during OpenNebula upgrade. Version of current configuration will be based on old OpenNebula version.

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      unknown
        ERROR: Unknown config version

Configuration Metadata Outdated Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the configuration tool complains about outdated metadata, you have missed to run configuration upgrade during some of OpenNebula upgrades in the past. Please note configuration must be upgraded or processed with even OpenNebula maintenance releases.

Following invalid state:

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.0
        ERROR: Configurations metadata are outdated.

needs to be fixed by reinitialization of the configuration state. Any unprocessed upgrades will be lost and current state will be initialized based on your current OpenNebula version and configurations located in system directories.

    .. prompt:: bash # auto

        # onecfg init --force
        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.5

        --- Available Configuration Updates -------
        No updates available.

After checking the state of configuration, in most cases running the following command without any extra parameters will suffice, as it will upgrade based on internal configuration version tracking and currently installed OpenNebula.

.. prompt:: text # auto

     # onecfg upgrade
     ANY   : Backup stored in '/tmp/onescape/backups/2020-6...
     ANY   : Configuration updated to 6.0.0

If you get conflicts when running onecfg upgrade refer to the :ref:`onecfg upgrade basic usage documentation <cfg_usage>` on how to upgrade and troubleshoot the configurations, in particular the :ref:`onecfg upgrade doc <cfg_upgrade>` and the :ref:`troubleshooting section <cfg_conflicts>`.

.. todo: Is onescape ready for 5.12

Step 7. Upgrade the Database version
================================================================================

.. important::

    User of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this `online form <https://opennebula.io/get-migration>`__.

Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically. Simply run the ``onedb upgrade -v`` command. The connection parameters are automatically retrieved from ``oned.conf``.

Step 8. Check DB Consistency
================================================================================

First, move the |version| backup file created by the upgrade command to a safe place. If you face any issues, the ``onedb`` command can restore this backup, but it won't downgrade databases to previous versions. Then execute the ``onedb fsck`` command:

.. code::

    $ onedb fsck
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0


Step 9. Start OpenNebula
================================================================================

Now you should be able to start OpenNebula as usual by running as ``root``:

.. prompt:: text # auto

    # systemctl start opennebula

At this point OpenNebula will continue the monitoring and management of your previous Hosts and VMs.  As a measure of caution, look for any error messages in ``oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).

Step 10. Restore Custom Probes
================================================================================

If you have any custom monitoring probe, follow :ref:`these instructions <devel-im>`, to update them to new monitoring system


Step 11. Update the Hypervisors (LXD & KVM only)
================================================================================

First update the virtualization, storage and networking drivers.  As the ``oneadmin`` user execute:

.. prompt:: text $ auto

   $ onehost sync

Then log into your hypervisor hosts and update the ``opennebula-node`` packages:

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula-node-kvm
    # service libvirtd restart # debian
    # service libvirt-bin restart # ubuntu

If upgrading the LXD drivers on Ubuntu

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula-node-lxd

CentOS

.. prompt:: text # auto

    # yum upgrade opennebula-node-kvm
    # systemctl restart libvirtd


Step 12. Enable Hosts
================================================================================

Enable all hosts, disabled in step 2.

.. important:: Due to new monitoring system, the firewall of the frontend (if enabled) must allow TCP and UDP packages incoming from the hosts on port 4124.

After following all the steps, please review corresponding guide:

.. toctree::
   :maxdepth: 1

   Additional Steps for 5.8.x <upgrade_58>
   Additional Steps for 5.6.x <upgrade_56>
