=================================
Upgrading from OpenNebula 4.6.x
=================================

This section describes the installation procedure for systems that are already running a 4.6.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section, you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the Compatibility Guide for `4.8 <http://docs.opennebula.org/4.8/release_notes/release_notes/compatibility.html>`_, `4.10 <http://docs.opennebula.org/4.10/release_notes/release_notes/compatibility.html>`_, `4.12 <http://docs.opennebula.org/4.12/release_notes/release_notes/compatibility.html>`_, `4.14 <http://docs.opennebula.org/4.14/release_notes/release_notes/compatibility.html>`_, `5.0 <http://docs.opennebula.org/5.0/intro_release_notes/release_notes/compatibility.html>`_ and |compatibility|, and the `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.

.. warning:: If you are using the vCenter drivers, there is a manual intervention required in order to upgrade to OpenNebula 5.4. Note that **upgrading from OpenNebula < 5.2 to OpenNebula >= 5.4 is NOT supported**. You need to upgrade first to OpenNebula 5.2, and then upgrade to OpenNebula 5.4.

Upgrading a Federation
================================================================================

If you have two or more 4.6 OpenNebulas working as a :ref:`Federation <introf>`, you need to upgrade all of them. The upgrade does not have to be simultaneous, the slaves can be kept running while the master is upgraded.

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

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

.. warning:: In 4.14 the ``FAILED`` state dissapears. You need to delete all the VMs in this state **before** the new version is installed.

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

Stop OpenNebula and any other related services you may have running: EC2, OCCI, and Sunstone. As ``oneadmin``, in the front-end:

.. code::

    $ sunstone-server stop
    $ oneflow-server stop
    $ econe-server stop
    $ occi-server stop
    $ one stop

Backup
======

Backup the configuration files located in **/etc/one**. You don't need to do a manual backup of your database, the onedb command will perform one automatically.

.. code::

    # cp -r /etc/one /etc/one.YYYY-MM-DD

.. note::

    Substitute ``YYYY-MM-DD`` with the date.

Installation
============

Follow the :ref:`Platform Notes <uspng>` and the :ref:`Installation guide <ignc>`, taking into account that you will already have configured the passwordless ssh access for oneadmin.

Make sure to run the ``install_gems`` tool, as the new OpenNebula version may have different gem requirements.

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula |version| to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the :ref:`Compatibility Guide <compatibility>` and the complete oned.conf reference for `4.6 <http://docs.opennebula.org/4.6/administration/references/oned_conf.html>`_ and :ref:`5.0 <oned_conf>` versions.

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

.. note::

    If you have a MAC_PREFIX in :ref:`oned.conf <oned_conf>` different than the default ``02:00``, open
    ``/usr/lib/one/ruby/onedb/local/4.5.80_to_4.7.80.rb`` and change the value of the ``ONEDCONF_MAC_PREFIX`` constant.

After you install the latest OpenNebula, and fix any possible conflicts in oned.conf, you can issue the 'onedb upgrade -v' command. The connection parameters have to be supplied with the command line options, see the :ref:`onedb manpage <cli>` for more information. Some examples:

.. code::

    $ onedb upgrade -v --sqlite /var/lib/one/one.db

.. code::

    $ onedb upgrade -v -S localhost -u oneadmin -p oneadmin -d opennebula

If everything goes well, you should get an output similar to this one:

.. code::

    $ onedb upgrade -v -u oneadmin -d opennebula
    MySQL Password:
    Version read:
    Shared tables 4.4.0 : OpenNebula 4.4.0 daemon bootstrap
    Local tables  4.4.0 : OpenNebula 4.4.0 daemon bootstrap

    >>> Running migrators for shared tables
      > Running migrator /usr/lib/one/ruby/onedb/shared/4.4.0_to_4.4.1.rb
      > Done in 0.00s

      > Running migrator /usr/lib/one/ruby/onedb/shared/4.4.1_to_4.5.80.rb
      > Done in 0.75s

    Database migrated from 4.4.0 to 4.5.80 (OpenNebula 4.5.80) by onedb command.

    >>> Running migrators for local tables
    Database already uses version 4.5.80
    Total time: 0.77s

.. note:: Make sure you keep the backup file. If you face any issues, the onedb command can restore this backup, but it won't downgrade databases to previous versions.

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``.

First, move the 4.6 backup file created by the upgrade command to a safe place.

.. code::

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

- First, add 3 new tables, ``vdc_pool``, ``marketplace_pool`` and ``marketplaceapp_pool`` to the replication configuration.

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


Update the Drivers
==================

You should be able now to start OpenNebula as usual, running 'one start' as oneadmin. At this point, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

Create the Security Group ACL Rule
================================================================================

There is a new kind of resource introduced in 4.12: :ref:`Security Groups <security_groups>`. If you want your existing users to be able to create their own Security Groups, create the following :ref:`ACL Rule <manage_acl>`:

.. code::

    $ oneacl create "* SECGROUP/* CREATE *"

.. note:: For environments in a Federation: This command needs to be executed only once in the master zone, after it is upgraded to |version|.

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