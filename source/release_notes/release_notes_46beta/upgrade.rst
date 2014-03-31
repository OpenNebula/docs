.. _upgrade:

=================================
Upgrading from Previous Versions
=================================

This guide describes the installation procedure for systems that are already running a 2.x or 3.x OpenNebula. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility_46beta>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula 4.6.

.. warning:: With the new :ref:`multi-system DS <system_ds_multiple_system_datastore_setups>` functionality, it is now required that the system DS is also part of the cluster. If you are using System DS 0 for Hosts inside a Cluster, any VM saved (stop, suspend, undeploy) **will not be able to be resumed after the upgrade process**.

.. warning:: Two drivers available in 4.2 are now discontinued: **ganglia** and **iscsi**.

-  **iscsi** drivers have been moved out of the main OpenNebula distribution and are available (although not supported) as an `addon <https://github.com/OpenNebula/addon-iscsi>`__.
-  **ganglia** drivers have been moved out of the main OpenNebula distribution and are available (although not supported) as an `addon <https://github.com/OpenNebula/addon-ganglia>`__.

Preparation
===========

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

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

Installation
============

Follow the :ref:`Platform Notes <uspng>` and the :ref:`Installation guide <ignc>`, taking into account that you will already have configured the passwordless ssh access for oneadmin.

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula 4.4 to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the :ref:`Compatibility Guide <compatibility_46beta>` and the complete oned.conf reference for `4.2 <http://opennebula.org/documentation:archives:rel4.2:oned_conf>`__ and :ref:`4.4 <oned_conf>` versions.

.. warning:: If you are upgrading from a version prior to 4.2, read the `3.8 upgrade guide <http://opennebula.org/documentation:rel3.8:upgrade#installation>`_, `4.0 upgrade guide <http://opennebula.org/documentation:rel4.0:upgrade#installation>`_ and `4.2 upgrade guide <http://opennebula.org/rel4.2:upgrade#installation>`_ for specific notes.

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
    4.0.1 : Database migrated from 3.8.0 to 4.2.0 (OpenNebula 4.2.0) by onedb command.

    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file
      > Running migrator /usr/lib/one/ruby/onedb/4.2.0_to_4.3.80.rb
      > Done

      > Running migrator /usr/lib/one/ruby/onedb/4.3.80_to_4.3.85.rb
      > Done

      > Running migrator /usr/lib/one/ruby/onedb/4.3.85_to_4.3.90.rb
      > Done

      > Running migrator /usr/lib/one/ruby/onedb/4.3.90_to_4.4.0.rb
      > Done

    Database migrated from 4.2.0 to 4.4.0 (OpenNebula 4.4.0) by onedb command.

If you receive the message “ATTENTION: manual intervention required”, read the section :ref:`Manual Intervention Required <upgrade_manual_intervention_required>` below.

.. warning:: Make sure you keep the backup file. If you face any issues, the onedb command can restore this backup, but it won't downgrade databases to previous versions.

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``.

First, move the 4.2 backup file created by the upgrade command to a save place.

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

Setting new System DS
=====================

With the new :ref:`multi-system DS <system_ds_multiple_system_datastore_setups>` functionality, it is now required that the system DS is also part of the cluster. If you are using System DS 0 for Hosts inside a Cluster, any VM saved (stop, suspend, undeploy) **will not be able to be resumed after the upgrade process**.

You will need to have at least one system DS in each cluster. If you don't already, create new system DS with the same definition as the system DS 0 (TM\_MAD driver). Depending on your setup this may or may not require additional configuration on the hosts.

You may also try to recover saved VMs (stop, suspend, undeploy) following the steps described in this `thread of the users mailing list <http://lists.opennebula.org/pipermail/users-opennebula.org/2013-December/025727.html>`__.

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula 4.4 still installed, restore the DB backup using 'onedb restore -f'
-  Uninstall OpenNebula 4.4, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

If the MySQL database password contains specials characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');

.. _upgrade_manual_intervention_required:

Manual Intervention Required
============================

If you have a datastore configured to use a tm driver not included in the OpenNebula distribution, the onedb upgrade command will show you this message:

.. code::

    ATTENTION: manual intervention required

    The Datastore <id> <name> is using the
    custom TM MAD '<tm_mad>'. You will need to define new
    configuration parameters in oned.conf for this driver, see
    http://opennebula.org/documentation:rel4.4:upgrade

In OpenNebula 4.4, each tm\_mad driver has a TM\_MAD\_CONF section in oned.conf. If you developed the driver, it should be fairly easy to define the required information looking at the existing ones:

.. code::

    # The  configuration for each driver is defined in TM_MAD_CONF. These
    # values are used when creating a new datastore and should not be modified
    # since they define the datastore behaviour.
    #   name      : name of the transfer driver, listed in the -d option of the
    #               TM_MAD section
    #   ln_target : determines how the persistent images will be cloned when
    #               a new VM is instantiated.
    #       NONE: The image will be linked and no more storage capacity will be used
    #       SELF: The image will be cloned in the Images datastore
    #       SYSTEM: The image will be cloned in the System datastore
    #   clone_target : determines how the non persistent images will be
    #                  cloned when a new VM is instantiated.
    #       NONE: The image will be linked and no more storage capacity will be used
    #       SELF: The image will be cloned in the Images datastore
    #       SYSTEM: The image will be cloned in the System datastore
    #   shared : determines if the storage holding the system datastore is shared
    #            among the different hosts or not. Valid values: "yes" or "no"
     
    TM_MAD_CONF = [
        name        = "lvm",
        ln_target   = "NONE",
        clone_target= "SELF",
        shared      = "yes"
    ]

