.. _upgrade_ha_510:

================================================================================
Upgrading High Availability Clusters
================================================================================

Step 1. Set all host to offline mode
================================================================================

Set all host to offline mode to stop all monitoring processes.


Step 2. Stop the HA Cluster
================================================================================

You need to stop all the nodes in the cluster to upgrade them at the same time. Start from the followers and leave the leader to the end.


Step 3. Upgrade the Leader
================================================================================

Follow Steps 4 to 8 described in the previous Section (Upgrading Single Front-end deployments). Finally create a database backup to replicate the *upgraded* state to the followers:

.. prompt:: bash $ auto

  $ onedb backup -u oneadmin -p oneadmin -d opennebula
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file


Step 4. Upgrade OpenNebula in the Followers
================================================================================

Upgrade OpenNebula packages as described in Step 4 in the previous section (Upgrading Single Front-end deployments)


Step 5. Replicate Database and configuration
================================================================================

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
================================================================================

Start OpenNebula in the followers as described in Step 8 in the previous section (Upgrading Single Front-end deployments).


Step 7. Check Cluster Health
================================================================================

At this point the ``onezone show`` command should display all the followers active and in sync with the leader.

Step 8. Update the Hypervisors (KVM & LXD)
================================================================================

Finally upgrade the hypervisors as described in Step 9 in the previous section (Upgrading Single Front-end deployments).
