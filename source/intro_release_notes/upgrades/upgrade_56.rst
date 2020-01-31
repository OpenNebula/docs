=================================
Upgrading from OpenNebula 5.6.x
=================================

This section describes the installation procedure for systems that are already running a 5.6.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.

Upgrading a Federation and High Availability
================================================================================

You need to perform the following steps in all the HA nodes and all zones. Note that you need to update all the servers at the same time, not one by one.


Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Stop OpenNebula
---------------

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Use preferably the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Backup
======

Backup the configuration files located in **/etc/one**. You don't need to do a manual backup of your database, the onedb command will perform one automatically.

.. prompt:: text # auto

    # cp -r /etc/one /etc/one.$(date +'%Y-%m-%d')

Installation of New Version
===========================

Follow the :ref:`Platform Notes <uspng>` and the :ref:`Installation guide <ignc>`, taking into account that you will already have configured the passwordless ssh access for oneadmin.

Make sure to run the ``install_gems`` tool, as the new OpenNebula version may have different gem requirements.

.. note::

    If executing ``install_gems`` you get a message asking to overwrite files for aws executables you can safely answer "yes".

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula |version| to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the :ref:`Compatibility Guide <compatibility>` and the complete ``oned.conf`` |onedconf| reference.

Configuration Files Upgrade
===========================

If you haven't modified any configuration files, the package managers will replace the configuration files with their newer versions and no manual intervention is required.

If you have customized **any** configuration files under ``/etc/one`` we recommend you to follow these steps regardless of the platform/linux distribution.

#. Backup ``/etc/one`` (already performed)
#. Install the new packages (already performed)
#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one``. Or you can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.
#. You should **never** overwrite the configuration files with older versions.

.. note::

    Configuration files from inside the remote scripts directory structure ``/var/lib/one/remotes/`` have been moved into dedicated directory ``/var/lib/one/remotes/etc/``. Check all the files on the new path, and apply any necessary changes to your environment.


Database Upgrade
================

Perform the Database Upgrade
--------------------------------------------------------------------------------

The database schema and contents are incompatible between versions. The OpenNebula daemon checks the existing DB version, and will fail to start if the version found is not the one expected, with the message 'Database version mismatch'.

You can upgrade the existing DB with the 'onedb' command. You can specify any Sqlite or MySQL database. Check the :ref:`onedb reference <onedb>` for more information.

.. note:: Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically.

After you install the latest OpenNebula, and fix any possible conflicts in oned.conf, you can issue the 'onedb upgrade -v' command. The connection parameters have to be supplied with the command line options, see the :ref:`onedb manpage <cli>` for more information. Some examples:

.. prompt:: text $ auto

    $ onedb upgrade -v --sqlite /var/lib/one/one.db

.. prompt:: text $ auto

    $ onedb upgrade -v -S localhost -u oneadmin -p oneadmin -d opennebula

If everything goes well, you should get an output similar to this one:

.. code::

    $ onedb upgrade -v -u oneadmin -d opennebula
    MySQL Password:
    Version read:
    Shared tables 4.11.80 : OpenNebula 4.12.1 daemon bootstrap
    Local tables  4.11.80 : OpenNebula 4.12.1 daemon bootstrap

    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file


    >>> Running migrators for shared tables
      ...

    >>> Running migrators for local tables
      ...
      > Done in 41.93s

    Database migrated from 4.11.80 to 4.13.80 (OpenNebula 4.13.80) by onedb command.

    Total time: 41.93s

.. note:: Make sure you keep the backup file. If you face any issues, the onedb command can restore this backup, but it won't downgrade databases to previous versions.

.. note:: vCenter VM disks managed by OpenNebula will be retagged in the vCenter VMs extraConfig. It is important that the front-end has access to the vCenter servers managed by OpenNebula in this DB upgrade process.

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``.

First, move the 5.6.x backup file created by the upgrade command to a safe place.

.. prompt:: text $ auto

    $ mv /var/lib/one/mysql_localhost_opennebula.sql /path/for/one-backups/

Then execute the following command:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Reload Start Scripts
================================

Follow this section if you are using a `systemd` base distribution, like CentOS 7+, Ubuntu 16.04+, etc.

In order for the system to re-read the configuration files you should issue the following command after the installation of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

.. note:: You can skip this step if you are not using KVM hosts, or any hosts that use remove monitoring probes.

Update ServerAdmin password to SHA256
=====================================

Since 5.10 passwords and tokens are generated using SHA256. OpenNebula will update the DB automatically for your regular users (including oneadmin). However, you need to do the update for serveradmin manually. You can do so, with:

.. prompt:: text # auto

    $ oneuser passwd --sha256 serveradmin `cat /var/lib/one/.one/sunstone_auth|cut -f2 -d':'`

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula |version| still installed, restore the DB backup using 'onedb restore -f'
-  Uninstall OpenNebula |version|, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');

.. include:: version.txt

Bug recovering
================

If Ceph datastores were used with OpenNebula <= 5.6.2 and any VM have been reverted to a snapshot, it's needed to follow the next steps for recovering snapshot tree consistency:

.. warning:: Check history in order to find how many reverts have been done. If the number of reverts are greater than 1 we do not recommend to deleted any snapshot, becase it will cause lose of information. If the number of revert is 1 you can fix it by following the steps below.

- Use the command ``onedb update-body vm --id <vm_id>`` for updating the body of the VM.
- Set /VM/SNAPSHOTS/CURRENT_BASE to the ID of the current active snapshot.

