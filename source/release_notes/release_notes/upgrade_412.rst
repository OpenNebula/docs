.. _upgrade:

=================================
Upgrading from OpenNebula 4.12.0
=================================

This guide describes the installation procedure for systems that are already running a 4.12.0 OpenNebula. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula 4.12.1.

Upgrading a Federation
================================================================================

If you have two or more 4.12.0 OpenNebulas working as a :ref:`Federation <introf>`, you can upgrade each one independently. Zones with an OpenNebula from the 4.12.x series can be part of the same federation, since the shared portion of the database is compatible.

The rest of the guide applies to both a master or slave Zone. You don't need to stop the federation or the MySQL replication to follow this guide.

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Stop OpenNebula and any other related services you may have running: EC2, OCCI, and Sunstone. As ``oneadmin``, in the front-end:

.. code::

    $ sunstone-server stop
    $ oneflow-server stop
    $ econe-server stop
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

Configuration Files Upgrade
===========================

There have not been any changes in the configuration files, so you can keep the existing configuration from your previous 4.12.0 version, including ``oned.conf``.

After the update, simply restore from the ``/etc/one.YYYY-MM-DD`` backup you have made. 

Database Upgrade
================

The upgrade from any previous 4.12.x version does not require a database upgrade, the database schema is compatible.

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``. Execute the following command:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running 'one start' as oneadmin. At this point, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

Default Auth
============

If you are using :ref:`LDAP as default auth driver <ldap>` you will need to update the directory. To do this execute the command:

.. code::

    $ cp -R /var/lib/one/remotes/auth/ldap /var/lib/one/remotes/auth/default

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  Uninstall OpenNebula 4.12.1, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');