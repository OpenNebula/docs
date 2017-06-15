.. _frontend_ha_setup:
.. _oneha:

=============================
OpenNebula HA Setup
=============================

This guide walks you through the process of setting a high available cluster for OpenNebula core services: core (oned), scheduler (mm\_sched).

OpenNebula uses a distributed consensus protocol to provide fault-tolerance and state consistency across OpenNebula services. In this section you'll learn the basics of how-to bootstrap and operate an OpenNebula distributed cluster.

.. warning:: If you are interested in failover protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Guide <ftguide>`.

Raft Overview
=============

This section covers some internal details on how OpenNebula implements Raft. You do not need to know these details to effectively operate OpenNebula on HA. These details are provided for those who wish to learn about them to fine tune their deployments.

A consensus algorithm is built around two concepts:

* **System State**, in OpenNebula the system state is the data stored in the database tables (users, acls, or the VMs in the system).

* **Log**, a sequence of SQL statements that are *consistently* applied to the OpenNebula DB in all servers to evolve the system state.

To preserve a consistent view of the system across servers, modifications to system state are performed through a special node, the *leader*. The servers in the OpenNebula cluster elects a single node to be the *leader*. The *leader* periodically sends heartbeats to the other servers (*followers*) to keep its leadership. If a *leader* fails to send the heartbeat, *followers* promote to *candidates* and start a new election.

Whenever the system is modified (e.g. a new VM is added to the system), the *leader* updates the log and replicates the entry in a majority of *followers* before actually writing it to the database. The latency of DB operations are thus increased, but the system state is safely replicated and the cluster can continue its operation in case of node failure.

In OpenNebula, read-only operations can be performed through any oned server in the cluster, this means that reads can be arbitrarily stale but generally within the round-trip time of the network.

Requirements
===========================

.. todo:: TODO

Bootstraping the HA cluster
===========================

The recommended deployment size is either 3 or 5 servers, that are able to tolerate up to 1 or 2 server failures, respectively. You can add, replace or remove servers once the cluster is up and running.

.. warning::

  In order to maintain a healthy cluster during the procedure of adding servers to the clusters, make sure you add **only** one server at a time

Configuration of the initial leader
--------------------------------------------------------------------------------

We start with the first server, to perform the initial system bootstraping.

* Start OpenNebula
* Add the server itself to the zone:

.. code::

  $ onezone list
  C    ID NAME                      ENDPOINT
  *     0 OpenNebula                http://localhost:2633/RPC2

  # We are working on Zone 0

  $ onezone server-add 0 --name server-0 --rpc http://10.3.3.22:2633/RPC2

  # It's now available in the zone:

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  SERVERS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  ENDPOINT
   0 server-0        solo       0          0          0          -1    http://10.3.3.22:2633/RPC2

* Stop OpenNebula service and update SERVER_ID in ``/etc/one/oned.conf``

.. code::

  FEDERATION = [
      MODE          = "STANDALONE",
      ZONE_ID       = 0,
      SERVER_ID     = 0, # changed from -1 to 0 (as 0 is the server id)
      MASTER_ONED   = ""
  ]


* [Optional] Enable the RAFT Hooks. This will add a floating IP to the system.

.. code::

  # Executed when a server transits from follower->leader
  RAFT_LEADER_HOOK = [
       COMMAND = "raft/vip.sh",
       ARGUMENTS = "leader eth0 10.3.3.2/24"
  ]

  # Executed when a server transits from leader->follower
  RAFT_FOLLOWER_HOOK = [
      COMMAND = "raft/follower.sh",
      ARGUMENTS = "follower eth0 10.3.3.2/24"
  ]

* Start oned. The server is now the leader and has the floating IP.

.. code::

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  SERVERS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  ENDPOINT
   0 server-0        leader     1          0          0          -1    http://10.3.3.22:2

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

  $ ip -o a sh eth0|grep 10.3.3.2/24
  2: eth0    inet 10.3.3.2/24 scope global secondary eth0\       valid_lft forever preferred_lft forever

.. _frontend_ha_setup_add_remove_servers:

Adding more servers
--------------------------------------------------------------------------------

.. warning::

  This procedure will discard the OpenNebula database in the server you are adding and substitute it with the database of the initial leader.

.. warning::

  Add only one host at a time. Repeat this process for every server you want to add.

* Create a DB backup in the initial leader and distribute it to new server, along with the files in /var/lib/one/.one/:

.. code::

  $ onedb backup -u oneadmin -p oneadmin -d opennebula
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2017-6-1_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file

  # Copy it to the other servers
  $ scp /var/lib/one/mysql_localhost_opennebula_2017-6-1_11:52:47.sql <ip>:/tmp

  # Copy the .one directory (make sure you preseve the owner: oneadmin)
  $ ssh <ip> rm -rf /var/lib/one/.one
  $ scp -r /var/lib/one/.one/ <ip>:/var/lib/one/

* Stop OpenNebula in the new server if it's running.
* Restore the database backup in the new server.

.. code::

  $ onedb restore -u oneadmin -p oneadmin -d opennebula /tmp/mysql_localhost_opennebula_2017-6-1_11:52:47.sql
  MySQL DB opennebula at localhost restored.

* Add the new server to OpenNebula (in the initial leader), and note the server id.

.. code::

  [oneadmin@c7-10 ~]$ onezone server-add 0 --name server-1 --rpc http://10.3.3.23:2633/RPC2

  [oneadmin@c7-10 ~]$ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula

  SERVERS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  ENDPOINT
   0 server-0        leader     3          71         68         -1    http://10.3.3.22:2
   1 server-1        error      -          -          -          -     http://10.3.3.23:2

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

* The new server is in error state, since OpenNebula in the new server is still not running. Make note of the server id, in this case it's 1.
* Edit ``/etc/one/oned.conf`` in the new server to set the SERVER_ID for the new server. Make sure to enable the hooks as in the initial leader's configuration.
* Start OpenNebula service.
* Run `onezone show 0` to make sure that the new server is in follower state.

.. code::

  [oneadmin@c7-10 ~]$ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  SERVERS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  ENDPOINT
   0 server-0        leader     3          71         68         -1    http://10.3.3.22:2
   1 server-1        follower   3          55         55         -1    http://10.3.3.23:2

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

* It may happen TERM/INDEX/COMMIT does not need match (like above). This is not important, it will sync automatically when the DB is changed.

Repeat this last section to add new servers. Make sure that you only add servers when the cluster is in healthy state, that is: there is 1 leader and the rest are in follower state. If there is one server in error state, fix it before proceeding.

Checking Cluster Health
=======================

Execute `onezone show <id>` to see if any of the servers are in error state. If they are in error state, check `/var/log/one/oned.log` in both the current leader (if any) and in the host that is in error state. All Raft messages will be logged in that file.

If there is no leader in the cluster please review `/var/log/one/oned.log` to make sure that there are no errors taking place.

Adding and Removing Servers
===========================

In order to add servers you need to use this command:

.. code::

  $ onezone server-add
  Command server-add requires one parameter to run
  ## USAGE
  server-add <zoneid>
          Add an OpenNebula server to this zone.
          valid options: server_name, server_rpc

  ## OPTIONS
       -n, --name                Zone server name
       -r, --rpc                 Zone server RPC endpoint
       -v, --verbose             Verbose mode
       -h, --help                Show this message
       -V, --version             Show version and copyright information
       --user name               User name used to connect to OpenNebula
       --password password       Password to authenticate with OpenNebula
       --endpoint endpoint       URL of OpenNebula xmlrpc frontend

Make sure that there is one leader (by running `onezone show <id>`), otherwise it will not work.

The whole procedure is documented :ref:`here <frontend_ha_setup_add_remove_servers>`.

Sunstone
================================================================================

.. todo:: TODO

Summary of Raft Configuration Attributes
========================================

.. todo:: TODO

.. code::

  RAFT: Algorithm attributes
    LOG_RETENTION: Number of DB log records kept, it determines the
    synchronization window across servers and extra storage space needed.
    LOG_PURGE_TIMEOUT: How often applied records are purged according the log
    retention value. (in seconds)
    ELECTION_TIMEOUT_MS: Timeout to start a election process if no hearbeat or
    log is received from leader.
    BROADCAST_TIMEOUT_MS: How often heartbeats are sent to  followers.
    XMLRPC_TIMEOUT_MS: To timeout raft related API calls

  RAFT_LEADER_HOOK: Executed when a server transits from follower->leader
    The purpose of this hook is to configure the Virtual IP.
    COMMAND: raft/vip.sh is a fully working script, this should not be changed
    ARGUMENTS: <interface> and <ip_cidr> must be replaced. For example
               ARGUMENTS = "leader ens1 10.0.0.2/24"

  RAFT_FOLLOWER_HOOK: Executed when a server transits from leader->follower
    The purpose of this hook is to configure the Virtual IP.
    COMMAND: raft/vip.sh is a fully working script, this should not be changed
    ARGUMENTS: <interface> and <ip_cidr> must be replaced. For example
               ARGUMENTS = "follower ens1 10.0.0.2/24"

Compatibility with the earlier HA
=================================

In OpenNebula <= 5.2, HA was configured using a classical active-passive approach, using Pacemaker and Corosync. While this will still work for OpenNebula > 5.2 it is not the recommended way to set up a cluster. However, it is fine if you want to continue using that HA coming from earlier versions.

This is documented here: `Front-end HA Setup <http://docs.opennebula.org/5.2/advanced_components/ha/frontend_ha_setup.html>`_.
