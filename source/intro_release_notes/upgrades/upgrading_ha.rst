.. _upgrade_ha:

================================================================================
Upgrading High Availability Clusters
================================================================================

Step 1. Check Virtual Machine Status
================================================================================

Before proceeding, make sure you don't have any VMs in a transient state (prolog, migrate, epilog, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Set All Hosts to Disable Mode
================================================================================

Set all Hosts to disable mode to stop all monitoring processes.

.. prompt:: bash $ auto

   $ onehost disable <host_id>

If you are upgrading from version 6.2+. Use ``onezone disable <zone_id>`` to make sure that no operation changing OpenNebula state are executed.

Step 3. Stop the HA Cluster
================================================================================

You need to stop all the nodes in the cluster to upgrade them at the same time. Start with the followers and leave the leader until the end.

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please stop this service instead of Sunstone one.

.. warning:: Make sure that every OpenNebula process is stopped. The output of ``systemctl list-units | grep opennebula`` should be empty.

Step 4. Upgrade the Leader
================================================================================

Follow Steps 4 to 9 described in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide in the HA leader.

Afterwards, create a database backup to replicate the upgraded state to the followers:

.. prompt:: bash $ auto

  $ onedb backup
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file

Step 5. Upgrade OpenNebula in the Followers
================================================================================

Follow Steps 4 to 9 described in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide in the HA followers.

Step 6. Replicate Database and Configuration
================================================================================

Copy the database backup of the leader to each follower and restore it:

.. prompt:: bash $ auto

  $ scp /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql <follower_ip>:/tmp
  $ onedb restore -f /tmp/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  MySQL DB opennebula at localhost restored.

Synchronize the configuration files to the followers:

.. note:: Before copying, gather the ``SERVER_ID`` from your ``/etc/one/oned.conf files`` on each follower, then replace those values after.

.. prompt:: bash $ auto

  $ rsync -r /etc/one root@<follower_ip>:/etc
  $ rsync -r /var/lib/one/remotes/etc root@<follower_ip>:/var/lib/one/remotes

On each of the followers, ensure these folders are owned by the ``oneadmin`` user:

.. prompt:: bash $ auto

  $ chown -R oneadmin:oneadmin /etc/one
  $ chown -R oneadmin:oneadmin /var/lib/one/remotes/etc

Step 7. Start OpenNebula in the Leader and Followers
================================================================================

Start OpenNebula and any other related services: OneFlow, OneGate, Sunstone & FireEdge. It's preferable to use the system tools, like ``systemctl`` or ``service`` as ``root`` in order to stop the services.

.. important:: If you are running Sunstone behind Apache/Nginx, please start this service instead of Sunstone one.

Step 8. Check Cluster Health
================================================================================

At this point the ``onezone show`` command should display all the followers active and in sync with the leader.

Step 9. Update the Hypervisors
================================================================================

Finally, upgrade the hypervisors and enable them as described in Steps 11-13 in the :ref:`Upgrading Single Front-end Deployments <upgrade_single>` guide.
