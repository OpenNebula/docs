.. _upgrade_single:

================================================================================
Upgrading Single Front-end Deployments
================================================================================

Upgrading from 5.6.x+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. important:: If you haven't done so, please enable the :ref:`OpenNebula and needed 3rd party repositories <setup_opennebula_repos>` before attempting the upgrade process. If you want to use Docker related functionality of OpenNebula and/or OpenNebula Edge Clusters provisioning you'll need to follow :ref:`this for RedHat <install_docker_deps_rh>` or :ref:`this for Debian <install_docker_deps_deb>` distributions.

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

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please stop this service instead of Sunstone one.

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
    $ apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone

RHEL

.. prompt:: bash $ auto

    $ yum upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow opennebula-provision pennebula-fireedge python3-pyone

.. important::

    When **upgrading** an existing deployment which could be running OpenNebula older than 5.10.0 anytime in the past, you might need to upgrade also required Ruby dependencies with script ``install_gems`` if you are not yet using the shipped Ruby gems (i.e., when symbolic link ``/usr/share/one/gems`` doesn't exist on your Front-end)!

    If unsure, run ``/usr/share/one/install_gems`` and the script warns if action is not relevant for you. For example:

    .. prompt:: bash $ auto

        $ /usr/share/one/install_gems
        WARNING: Running install_gems is not necessary anymore, as all the
        required dependencies are already installed by your packaging
        system into symlinked location /usr/share/one/gems. Ruby gems
        installed by this script won't be used until this symlink exists.
        Remove the symlink before starting the OpenNebula services
        to use Ruby gems installed by this script. E.g. execute

            # unlink /usr/share/one/gems

        Execution continues in 15 seconds ...

    Read :ref:`this <ruby_runtime>` for more information.

Community Edition
--------------------------------------------------------------------------------

There is an additional step if you are upgrading OpenNebula CE. After you get the `opennebula-migration-community package <https://opennebula.io/get-migration>`__, you need to install it in the OpenNebula Front-end.

RHEL

.. prompt:: bash $ auto

    $ rpm -i opennebula-migration-community*.rpm

Debian/Ubuntu

.. prompt:: bash $ auto

	$ dpkg -i opennebula-migration-community*.deb

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
    OpenNebula:  5.8.5
    Config:      5.8.0

    --- Available Configuration Updates -------
    No updates available.

Unknown Configuration Version Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you get error message about an unknown configuration version, you don't need to do anything. The configuration version will be automatically initialized during the OpenNebula upgrade. The configuration of the current version will be based on the former OpenNebula version.

.. prompt:: bash $ auto

    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.8.5
    Config:      unknown
    ERROR: Unknown config version

Configuration Metadata Outdated Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the configuration tool complains about outdated metadata, you have not run a configuration upgrade during some of the past OpenNebula upgrades. Please note, configuration must be upgraded or processed with even OpenNebula's maintenance releases.

The following invalid state:

.. prompt:: bash $ auto

    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.8.5
    Config:      5.8.0
    ERROR: Configurations metadata are outdated.

needs to be fixed by reinitialization of the configuration state. Any unprocessed upgrades will be lost and the current state will be initialized based on your current OpenNebula version and configurations located in system directories.

.. prompt:: bash $ auto

    $ onecfg init --force
    $ onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.8.5
    Config:      5.8.5

    --- Available Configuration Updates -------
    No updates available.

After checking the state of configuration, in most cases running the following command without any extra parameters will suffice, as it will upgrade the probes based on the internal configuration version tracking of the currently installed OpenNebula.

.. prompt:: bash $ auto

     $ onecfg upgrade
     ANY   : Backup stored in '/tmp/onescape/backups/2020-6...
     ANY   : Configuration updated to 6.2.1

If you get conflicts when running ``onecfg`` upgrade refer to the :ref:`onecfg upgrade basic usage documentation <cfg_usage>` on how to upgrade and troubleshoot the configurations, in particular the :ref:`onecfg upgrade doc <cfg_upgrade>` and the :ref:`troubleshooting section <cfg_conflicts>`.

FireEdge public endpoint is not working
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After updating the configuration file ``/etc/one/sunstone-server.conf``, if you didn't install FireEdge :ref:`FireEdge <fireedge_setup>` you might get an error like this ``FireEdge public endpoint is not working, please contact your cloud administrator`` in the Web GUI. By default this configuration file will have the following configuration enabled.

.. prompt:: bash $ auto

    $ tail -n 5 /etc/one/sunstone-server.conf
    # FireEdge
    ################################################################################

    :private_fireedge_endpoint: http://localhost:2616
    :public_fireedge_endpoint: http://localhost:2616

If you don't want to use the new feature, comment these out in order to get rid of the error.

.. note:: After doing the change, please restart Sunseont or Apache/Nginx in case you are using Sunstone behind one of them.

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

Start OpenNebula and any other related services: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please start this service instead of Sunstone one.

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

.. note:: Note that the ``<hypervisor>`` tag should be replaced by the name of the corresponding hypervisor (i.e ``kvm``, ``lxc`` or ``firecracker``).

.. important::  For KVM hypervisor it's necessary to restart also the libvirt service

Step 13. Enable Hosts
================================================================================

Enable all Hosts, disabled in step 2:

.. prompt:: bash $ auto

   $ onehost enable <host_id>

After following all the steps, please review the corresponding guide:

.. toctree::
   :maxdepth: 1

   Additional Steps for 5.8.x <upgrade_58>
   Additional Steps for 5.6.x <upgrade_56>

Testing
================================================================================

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in ``oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).

Restoring the Previous Version
================================================================================

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula |version|, and install again your previous version. After that, update the drivers if needed, as outlined in Step 8.
