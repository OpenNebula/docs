.. _community_upgrade_510:

=================================
Upgrading from OpenNebula 5.10.x
=================================

This section describes the installation procedure for systems that are already running a 5.10.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section; you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations, for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.


Upgrading Single Front-end Deployments
================================================================================

Step 1. Check Virtual Machine Status
--------------------------------------------------------------------------------
Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.


Step 2. Set all host to offline mode
--------------------------------------------------------------------------------
Set all host to offline mode to stop all monitoring processes


Step 3. Stop OpenNebula
--------------------------------------------------------------------------------
Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Preferably use the system tools, like `systemctl` or `service` as `root` in order to stop the services.


Step 4. Backup OpenNebula Configuration
--------------------------------------------------------------------------------
Backup the configuration files located in **/etc/one** and **/var/lib/one/remotes/etc**. You don't need to do a manual backup of your database, the ``onedb`` command will perform one automatically.

.. prompt:: text # auto

    # cp -r /etc/one /etc/one.$(date +'%Y-%m-%d')
    # cp -r /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')


Step 5. Upgrade to the New Version
--------------------------------------------------------------------------------

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow python-pyone

CentOS

.. prompt:: text # auto

    # yum upgrade opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow


Step 6. Update Configuration Files
--------------------------------------------------------------------------------
If you haven't modified any configuration files, you can skip this step and proceed to the next one.

.. todo: Is onescape ready for 5.12

.. important::

    If you have an active OpenNebula `support subscription <http://opennebula.systems/opennebula-support>`__, this step can be automated using the `Configuration Management Module of OneScape <http://docs.opennebula.pro/onescape/5.10/module/config/index.html>`__. It is **mandatory** that you updgrade in this fashion to OpenNebula 5.10.2+. After the ``onecfg upgrade`` step is completed, follow the rest of the steps in this guide before moving to the final steps in OneScape's `OpenNebula Upgrade Workflow <http://docs.opennebula.pro/onescape/5.10/module/config/workflow.html>`__.

In order to update the configuration files with your existing customizations you'll need to:

#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one`` and ``diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc``. You can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.
    * See changes in the :ref:`Monitoring <mon>`, optionally update the MONITOR_ADDRESS in ``/etc/one/monitord.conf``
    * If you use HA configuration, the MONITOR_ADDRESS should be a floating address

Step 7. Upgrade the Database version
--------------------------------------------------------------------------------
.. note:: Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically.

Simply run the ``onedb upgrade -v`` command. The connection parameters have to be supplied with the command line options, see the :ref:`onedb manpage <cli>` for more information. For example:

.. prompt:: text $ auto

    $ onedb upgrade -v -S localhost -u oneadmin -p oneadmin -d opennebula

Step 8. Check DB Consistency
--------------------------------------------------------------------------------
First, move the |version| backup file created by the upgrade command to a safe place. If you face any issues, the ``onedb`` command can restore this backup, but it won't downgrade databases to previous versions. Then execute the ``onedb fsck`` command, providing the same connection parameter used during the database upgrade:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0


Step 9. Start OpenNebula
--------------------------------------------------------------------------------

Make the system re-read the service configuration files of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Now you should be able to start OpenNebula as usual, running ``service opennebula start`` as ``root``. Do not forget to restart also any associated service like Sunstone, OneGate or OneFlow.

At this point OpenNebula will continue the monitoring and management of your previous Hosts and VMs.  As a measure of caution, look for any error messages in ``oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).


Step 10. Restore custom probes
--------------------------------------------------------------------------------

If you have any custom monitoring probe, follow :ref:`these instructions <devel-im>`, to update them to new monitoring system


Step 11. Update the Hypervisors (LXD & KVM only)
------------------------------------------------

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


Step 12. Enable hosts
------------------------------------------------

Enable all hosts, disabled in step 2


Upgrading High Availability Clusters
================================================================================

Step 1. Set all host to offline mode
--------------------------------------------------------------------------------

Set all host to offline mode to stop all monitoring processes.


Step 2. Stop the HA Cluster
--------------------------------------------------------------------------------

You need to stop all the nodes in the cluster to upgrade them at the same time. Start from the followers and leave the leader to the end.


Step 3. Upgrade the Leader
--------------------------------------------------------------------------------

Follow Steps 4 to 8 described in the previous Section (Upgrading Single Front-end deployments). Finally create a database backup to replicate the *upgraded* state to the followers:

.. prompt:: bash $ auto

  $ onedb backup -u oneadmin -p oneadmin -d opennebula
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file


Step 4. Upgrade OpenNebula in the Followers
--------------------------------------------------------------------------------

Upgrade OpenNebula packages as described in Step 4 in the previous section (Upgrading Single Front-end deployments)


Step 5. Replicate Database and configuration
--------------------------------------------------------------------------------

Copy the database backup of the leader to each follower and restore it:

.. prompt:: bash $ auto

  $ scp /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql <follower_ip>:/tmp

  $ onedb restore -f -u oneadmin -p oneadmin -d opennebula /tmp/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  MySQL DB opennebula at localhost restored.

Synchronize the configuration files to the followers:

.. prompt:: bash $ auto

  $ rsync -r /etc/one root@<follower_ip>:/etc

  $ rsync -r /var/lib/one/remotes/etc root@<follower_ip>:/var/lib/one/remotes


Step 6. Start OpenNebula in the Leader and Followers
--------------------------------------------------------------------------------

Start OpenNebula in the followers as described in Step 8 in the previous section (Upgrading Single Front-end deployments).


Step 7. Check Cluster Health
--------------------------------------------------------------------------------

At this point the ``onezone show`` command should display all the followers active and in sync with the leader.

Step 8. Update the Hypervisors (KVM & LXD)
--------------------------------------------------------------------------------

Finally upgrade the hypervisors as described in Step 9 in the previous section (Upgrading Single Front-end deployments).


Upgrading a Federation
================================================================================

.. todo: Describe federation update due to PostgreSql support


Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula |version| still installed, restore the DB backup using ``onedb restore -f``
-  Uninstall OpenNebula |version|, and install again your previous version.
-  Copy back the backup of ``/etc/one`` you did to restore your configuration.
