.. _upgrade_single:

================================================================================
Upgrading Single Front-end Deployments
================================================================================

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set all Host to Offline Mode
================================================================================

Set all host to offline mode to stop all monitoring processes

Step 3. Stop OpenNebula
================================================================================

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Preferably use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Step 4. Backup OpenNebula Configuration
================================================================================

Backup the configuration files located in **/etc/one** and **/var/lib/one/remotes/etc**. You don't need to do a manual backup of your database, the ``onedb`` command will perform one automatically.

.. prompt:: text # auto

    # cp -r /etc/one /etc/one.$(date +'%Y-%m-%d')
    # cp -r /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')

Step 5. Upgrade to the New Version
================================================================================

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow python-pyone

CentOS

.. prompt:: text # auto

    # yum upgrade opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow


Step 6. Update Configuration Files
================================================================================

If you haven't modified any configuration files, you can skip this step and proceed to the next one.

Community Edition
-----------------

In order to update the configuration files with your existing customizations you'll need to:

#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one`` and ``diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc``. You can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.

Enterprise Edition
------------------

If you have modified configuration files lets's use onecfg to automate the configuration file upgrades.

Before upgrading OpenNebula, you need to ensure that state of OneScape configuration module is clean without any pending migrations from past or outdated configurations. Run ``onecfg status`` to check the configuration state.

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

If the configuration module complains about outdated metadata, you have missed to run configuration upgrade during some of OpenNebula upgrades in the past. Please note configuration must be upgraded or processed with even OpenNebula maintenance releases.

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
        No updates available.<Paste>

After checking the state of OneScape, in most cases running the following command without any extra parameters will suffice, as it will upgrade based on internal configuration version tracking and currently installed OpenNebula.

.. prompt:: text # auto

     # onecfg upgrade
     ANY   : Backup stored in '/tmp/onescape/backups/2020-6
     ANY   : Configuration updated to 5.12.0

If you get conflicts when running onecfg upgrade refer to the `onecfg upgrade basic usage documentation <http://docs.opennebula.io/onescape/5.12/module/config/usage.html>`__ on how to upgrade and troubleshoot the configurations, in particular the `onecfg upgrade doc <http://docs.opennebula.io/onescape/5.12/module/config/usage.html#cfg-upgrade>`__ and the `troubleshooting section <http://docs.opennebula.io/onescape/5.12/module/config/conflicts.html>`__.

.. todo: Is onescape ready for 5.12

Step 7. Upgrade the Database version
================================================================================

.. important::

    User of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this online form.

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

Make the system re-read the service configuration files of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Now you should be able to start OpenNebula as usual, running ``service opennebula start`` as ``root``. Do not forget to restart also any associated service like Sunstone, OneGate or OneFlow.

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

    # apt-get install --only-upgrade opennebula-node
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

Enable all hosts, disabled in step 2
