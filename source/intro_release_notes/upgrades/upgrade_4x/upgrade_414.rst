
=================================
Upgrading from OpenNebula 4.14.x
=================================

This section describes the installation procedure for systems that are already running a 4.14.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the Compatibility Guide for `5.0 <http://docs.opennebula.org/5.0/intro_release_notes/release_notes/compatibility.html>`_ and |compatibility|, and the `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.

.. warning:: If you are using the vCenter drivers, there is a manual intervention required in order to upgrade to OpenNebula 5.4. Note that **upgrading from OpenNebula < 5.2 to OpenNebula >= 5.4 is NOT supported**. You need to upgrade first to OpenNebula 5.2, and then upgrade to OpenNebula 5.4.


Upgrading a Federation
================================================================================

If you have two or more 4.14.x OpenNebulas working as a :ref:`Federation <introf>`, you need to upgrade all of them. The upgrade does not have to be simultaneous, the slaves can be kept running while the master is upgraded.

The steps to follow are:

1. Stop the MySQL replication in all the slaves
2. Upgrade the **master** OpenNebula
3. Upgrade each **slave**
4. Resume the replication

During the time between steps 1 and 4 the slave OpenNebulas can be running, and users can keep accessing them if each zone has a local Sunstone instance. There is however an important limitation to note: all the shared database tables will not be updated in the slaves zones. This means that new user accounts, password changes, new ACL rules, etc. will not have any effect in the slaves. Read the :ref:`federation architecture documentation <introf_architecture>` for more details.

It is recommended to upgrade all the slave zones as soon as possible.

To perform the first step, `pause the replication <http://dev.mysql.com/doc/refman/5.7/en/replication-administration-pausing.html>`_ in each **slave MySQL**:

.. code::

    mysql> STOP SLAVE;

    mysql> SHOW SLAVE STATUS\G

     Slave_IO_Running: No
    Slave_SQL_Running: No

Then follow this section for the **master zone**. After the master has been updated to |version|, upgrade each **slave zone** following this same section.


Upgrading from a High Availability deployment
================================================================================

The recommended procedure to upgrade two OpenNebulas configured in HA is to follow the upgrade procedure in a specific order. Some steps need to be executed in both servers, and others in just the active node. For the purpose of this section, we will still refer to the *active node* as such even after stopping the cluster, so we run the single node steps always in the same node:

* *Preparation* in the active node.
* *Backup* in the active node.
* Stop the cluster in the active node: ``pcs cluster stop``.
* *Installation* in both nodes. Before running ``install_gems``, run ``gem list > previous_gems.txt`` so we can go back to those specific ``sinatra`` and ``rack`` gems if the ``pcsd`` refuses to start.
* *Configuration Files Upgrade* in the active node.
* *Database Upgrade* in the active node.
* *Check DB Consistency* in the active node.
* *Reload Start Scripts in CentOS 7* in both nodes.
* Start the cluster in the active node.

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

The network drivers since OpenNebula 5.0 are located in the Virtual Network, rather than in the host. The upgrade process may ask you questions about your existing VMs, Virtual Networks and hosts, and as such it is wise to have the following information saved beforehand, since in the upgrade process OpenNebula will be stopped.

.. prompt:: text $ auto

  $ onevnet list -x > networks.txt
  $ onehost list -x > hosts.txt
  $ onevm list -x > vms.txt

The list of valid network drivers since 5.0 Wizard are:

* ``802.1Q``
* ``dummy``
* ``ebtables``
* ``fw``
* ``ovswitch``
* ``vxlan``

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Use preferably the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Backup
======

Backup the configuration files located in **/etc/one**. You don't need to do a manual backup of your database, the onedb command will perform one automatically.

.. prompt:: text # auto

    # cp -r /etc/one /etc/one.$(date +'%Y-%m-%d')

Installation
============

Follow the :ref:`Platform Notes <uspng>` and the :ref:`Installation guide <ignc>`, taking into account that you will already have configured the passwordless ssh access for oneadmin.

Make sure to run the ``install_gems`` tool, as the new OpenNebula version may have different gem requirements.

.. note::

    If executing ``install_gems`` you get a message asking to overwrite files for aws executables you can safely answer "yes".

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula |version| to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the :ref:`Compatibility Guide <compatibility>` and the complete oned.conf reference for `4.14 <http://docs.opennebula.org/4.14/administration/references/oned_conf.html>`_ and |onedconf| versions.

Configuration Files Upgrade
===========================

If you haven't modified any configuration files, the package managers will replace the configuration files with their newer versions and no manual intervention is required.

If you have customized **any** configuration files under ``/etc/one`` we recommend you to follow these steps regardless of the platform/linux distribution.

#. Backup ``/etc/one`` (already performed)
#. Install the new packages (already performed)
#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one``. Or you can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.
#. You should **never** overwrite the configuration files with older versions.

Database Upgrade
================

The database schema and contents are incompatible between versions. The OpenNebula daemon checks the existing DB version, and will fail to start if the version found is not the one expected, with the message 'Database version mismatch'.

You can upgrade the existing DB with the 'onedb' command. You can specify any Sqlite or MySQL database. Check the :ref:`onedb reference <onedb>` for more information.

.. warning:: Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically.

.. warning:: For environments in a Federation: Before upgrading the **master**, make sure that all the slaves have the MySQL replication paused.

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

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``.

First, move the 4.14 backup file created by the upgrade command to a safe place.

.. prompt:: text $ auto

    $ mv /var/lib/one/mysql_localhost_opennebula.sql /path/for/one-backups/

Then execute the following command:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Resume the Federation
================================================================================

This section applies only to environments working in a Federation.

For the **master zone**: This step is not necessary.

For a **slave zone**: The MySQL replication must be resumed now.

- First, add two new tables, ``marketplace_pool`` and ``marketplaceapp_pool``, to the replication configuration.

.. warning:: Do not copy the server-id from this example, each slave should already have a unique ID.

.. code-block:: none

    # vi /etc/my.cnf
    [mysqld]
    server-id           = 100
    replicate-do-table  = opennebula.user_pool
    replicate-do-table  = opennebula.group_pool
    replicate-do-table  = opennebula.vdc_pool
    replicate-do-table  = opennebula.zone_pool
    replicate-do-table  = opennebula.db_versioning
    replicate-do-table  = opennebula.acl
    replicate-do-table  = opennebula.marketplace_pool
    replicate-do-table  = opennebula.marketplaceapp_pool

    # service mysqld restart

- Start the **slave MySQL** process and check its status. It may take a while to copy and apply all the pending commands.

.. code-block:: none

    mysql> START SLAVE;
    mysql> SHOW SLAVE STATUS\G

The ``SHOW SLAVE STATUS`` output will provide detailed information, but to confirm that the slave is connected to the master MySQL, take a look at these columns:

.. code-block:: none

       Slave_IO_State: Waiting for master to send event
     Slave_IO_Running: Yes
    Slave_SQL_Running: Yes


Reload Start Scripts in CentOS 7
================================

In order for the system to re-read the configuration files you should issue the following command after the installation of the new packages:

.. prompt:: text $ auto

    # systemctl daemon-reload

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

Create the Virtual Router ACL Rule
================================================================================

There is a new kind of resource introduced in 5.0: :ref:`Virtual Routers <vrouter>`. If you want your existing users to be able to create their own Virtual Routers, create the following :ref:`ACL Rule <manage_acl>`:

.. code::

    $ oneacl create "* VROUTER/* CREATE *"

.. note:: For environments in a Federation: This command needs to be executed only once in the master zone, after it is upgraded to |version|.

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

.. include:: ../version.txt