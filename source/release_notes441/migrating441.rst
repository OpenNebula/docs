.. _migrating441:

=============================
Upgrading from OpenNebula 4.4
=============================

.. warning:: If you are upgrading from any other previous version please refer to the information included in the :ref:`OpenNebula 4.4 Retina release notes <rn44>`.

The migration from OpenNebula 4.4 is straightforward by just upgrading the database version using the following procedure.

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

You can keep your current ``oned.conf`` as there are no changes between 4.4 and 4.4.1 in the file.

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

Then execute the following command:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula 4.4.1 still installed, restore the DB backup using 'onedb restore -f'
-  Uninstall OpenNebula 4.4.1, and install again 4.4.
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

In OpenNebula 4.4.1, each tm\_mad driver has a TM\_MAD\_CONF section in oned.conf. If you developed the driver, it should be fairly easy to define the required information looking at the existing ones:

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



