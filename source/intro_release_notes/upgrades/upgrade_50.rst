.. _upgrade:

=================================
Upgrading from OpenNebula 5.0.0
=================================

This section describes the installation procedure for systems that are already running a 5.0.0 OpenNebula. The upgrade will preserve all current users, hosts, resources and configurations; for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula 5.0.

Upgrading a Federation
================================================================================

If you have two or more 5.0.0 OpenNebulas working as a :ref:`Federation <introf>`, you can upgrade each one independently. Zones with an OpenNebula from the 5.0.x series can be part of the same federation, since the shared portion of the database is compatible.

The rest of the guide applies to both a master or slave Zone. You don't need to stop the federation or the MySQL replication to follow this guide.

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

It is highly recommended **not to keep** your current ``oned.conf``, and update the ``oned.conf`` file shipped with OpenNebula 5.0 to your setup. If for any reason you plan to preserve your current ``oned.conf`` file, read the complete :ref:`oned.conf reference for 5.0 <oned_conf>`.

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

The upgrade from any previous 5.0.0 version does not require a database upgrade, the database schema is compatible.

Check DB Consistency
====================

After the upgrade is completed, you should run the command ``onedb fsck``.

First, move the 5.0.0 backup file created by the upgrade command to a safe place.

.. prompt:: text $ auto

    $ mv /var/lib/one/mysql_localhost_opennebula.sql /path/for/one-backups/

Then execute the following command:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0

Reload Start Scripts in CentOS 7
================================

In order for the system to re-read the configuration files you should issue the following command after the installation of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Update the Drivers
==================

You should be able now to start OpenNebula as usual, running ``service opennebula start`` as ``root``. At this point, as ``oneadmin`` user, execute ``onehost sync`` to update the new drivers in the hosts.

.. warning:: Doing ``onehost sync`` is important. If the monitorization drivers are not updated, the hosts will behave erratically.

Default Auth
============

If you are using :ref:`LDAP as default auth driver <ldap>`, you will need to update ``/etc/one/oned.conf`` and set the new ``DEFAULT_AUTH`` variable:

.. code::

    DEFAULT_AUTH = "ldap"

Testing
=======

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in oned.log, and check that all drivers are loaded successfully. After that, keep an eye on oned.log while you issue the onevm, onevnet, oneimage, oneuser, onehost **list** commands. Try also using the **show** subcommand for some resources.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula 5.0 still installed, restore the DB backup using 'onedb restore -f'
-  Uninstall OpenNebula 5.0, and install again your previous version.
-  Copy back the backup of /etc/one you did to restore your configuration.

Known Issues
============

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');
