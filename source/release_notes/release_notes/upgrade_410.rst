.. _upgrade:

=================================
Upgrading from OpenNebula 4.10.x
=================================

This guide describes the installation procedure for systems that are already running a 4.10.x OpenNebula. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula 4.12.

Upgrading a Federation
================================================================================

If you have two or more 4.10.x OpenNebulas working as a :ref:`Federation <introf>`, you can upgrade each one independently. Zones with 4.10.x and 4.12 OpenNebulas can be part of the same federation, with a caveat: Security Groups.

.. note:: Security Groups can be managed in a 4.12 zone by the administrators, but users will only be able to administer their own Security Groups if the master zone is upgraded to 4.12.

The other compatibility issue is in the Sunstone web interface. If your users access different Zones from a unique Sunstone server, you will need to upgrade all Zones to 4.12, or enable a local Sunstone server for each Zone to ensure that a 4.12 OpenNebula is only accessed through a 4.12 Sunstone. Read the :ref:`federation architecture documentation <introf_architecture>` for more details.

The rest of the guide applies to both a master or slave Zone. You don't need to stop the federation or the MySQL replication to follow this guide.

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. As ``oneadmin``, in the front-end:

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

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula 4.12 to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the :ref:`Compatibility Guide <compatibility>` and the complete oned.conf reference for `4.10 <http://docs.opennebula.org/4.10/administration/references/oned_conf.html>`_ and :ref:`4.12 <oned_conf>` versions.

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

First, move the 4.10 backup file created by the upgrade command to a safe place.

.. code::

    $ mv /var/lib/one/mysql_localhost_opennebula.sql /path/for/one-backups/

Then execute the following command:

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

vCenter Password
================

.. note:: This step only applies if you are upgrading from OpenNebula **4.10.0**. If you are already using 4.10.1 or 4.10.2 you can skip this step.

If you already have a host with vCenter drivers you need to update the password as version >4.10.0 expects it to be encrypted. To do so, proceed to Sunstone -> Infrastructure -> Hosts, click on the vCenter host(s) and change the value in ``VCENTER_PASSWORD`` field. It will be automatically encrypted.

Create the Security Group ACL Rule
================================================================================

There is a new kind of resource introduced in 4.12: :ref:`Security Groups <security_groups>`. If you want your existing users to be able to create their own Security Groups, create the following :ref:`ACL Rule <manage_acl>`:

.. code::

    $ oneacl create "* SECGROUP/* CREATE *"

.. note:: For environments in a Federation: This command needs to be executed only once in the master zone, after it is upgraded to 4.12.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula 4.12 still installed, restore the DB backup using 'onedb restore -f'
-  Uninstall OpenNebula 4.12, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');
