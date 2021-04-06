.. _upgrade_ha:

================================================================================
Upgrading High Availability Clusters
================================================================================

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set All Hosts to Offline Mode
================================================================================

Set all Hosts to offline mode to stop all monitoring processes.

Step 3. Stop the HA Cluster
================================================================================

You need to stop all the nodes in the cluster to upgrade them at the same time. Start with the followers and leave the leader until the end.

Step 4. Upgrade the Leader
================================================================================

Follow Steps 4 to 8 described in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide in the HA leader.

Afterwards, create a database backup to replicate the *upgraded* state to the followers:

.. prompt:: bash $ auto

  $ onedb backup
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file


Step 5. Upgrade OpenNebula in the Followers
================================================================================

Follow Steps 4 to 8 described in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide in the HA followers.

Step 6. Replicate Database and Configuration
================================================================================

Copy the database backup of the leader to each follower and restore it:

.. prompt:: bash $ auto

  $ scp /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql <follower_ip>:/tmp

  $ onedb restore -f /tmp/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  MySQL DB opennebula at localhost restored.

Synchronize the configuration files to the followers:

.. prompt:: bash $ auto

  $ rsync -r /etc/one root@<follower_ip>:/etc

  $ rsync -r /var/lib/one/remotes/etc root@<follower_ip>:/var/lib/one/remotes


Step 7. Start OpenNebula in the Leader and Followers
================================================================================

Start OpenNebula in the followers as described in Step 8 in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide.

Step 8. Check Cluster Health
================================================================================

At this point the ``onezone show`` command should display all the followers active and in sync with the leader.

Step 9. Update the Hypervisors
================================================================================

Finally, upgrade the hypervisors and enable them as described in Steps 11-12 in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide.
