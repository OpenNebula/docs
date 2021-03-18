.. _frontend_ha_setup:
.. _oneha:

================================================================================
OpenNebula Front-end HA
================================================================================

OpenNebula provides a built-in mechanism to ensure high availability (HA) of the core Front-end services - ``opennebula`` (i.e., daemon ``oned``) and ``opennebula-scheduler`` (i.e., daemon ``mm_sched``). Services needs to be deployed and configured across several hosts and a distributed consensus protocol to provides fault-tolerance and state consistency across them. Such a deployment is resilient to a failure of at least a single host (depends on total number of hosts).

In this section, you learn the basics of how to bootstrap a distributed highly available OpenNebula Front-end.

.. warning:: If you are interested in fail-over protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Guide <ftguide>`.

Raft Overview
================================================================================

This section covers some internals on how OpenNebula implements Raft. You do not need to know these details to effectively operate OpenNebula on HA. These details are provided for those who wish to learn about them to fine tune their deployments.

A consensus algorithm is built around two concepts:

- **System State** - OpenNebula data stored in the database tables (users, ACLs, or the VMs in the system).

- **Log** - sequence of SQL statements that are *consistently* applied to the OpenNebula DB in all servers to evolve the system state.

To preserve a consistent view of the system across servers, modifications to system state are performed through a special node, the *leader*. The servers in the OpenNebula cluster elect a single node to be the *leader*. The *leader* periodically sends heartbeats to the other servers, the *followers*, to keep its leadership. If a *leader* fails to send the heartbeat, *followers* promote to *candidates* and start a new election.

Whenever the system is modified (e.g. a new VM is added to the system), the *leader* updates the log and replicates the entry in a majority of *followers* before actually writing it to the database. The latency of DB operations is thus increased, but the system state is safely replicated, and the cluster can continue its operation in case of node failure.

In OpenNebula, read-only operations can be performed through any oned server in the cluster; this means that reads can be arbitrarily stale but generally within the round-trip time of the network.

Requirements and Architecture
================================================================================

The recommended deployment size is either 3 or 5 servers, which provides a fault-tolerance for 1 or 2 server failures, respectively. You can add, replace or remove servers once the cluster is up and running.

Every HA cluster requires:

* An odd number of servers (3 is recommended).
* (Recommended) identical server capacities.
* The same software configuration of the servers. (The sole difference would be the ``SERVER_ID`` field in ``/etc/one/oned.conf``.)
* A working database connection of the same type. MySQL is recommended.
* All the servers must share the credentials.
* Floating IP which will be assigned to the *leader*.
* A shared filesystem.

The servers should be configured in the following way:

* Sunstone (with or without Apache/Passenger) running on all the nodes.
* Shared datastores must be mounted on all the nodes.

Bootstrapping the HA cluster
================================================================================

This section shows examples of all the steps required to deploy the HA Cluster.

.. warning::

  To maintain a healthy cluster during the procedure of adding servers to the clusters, make sure you add **only** one server at a time.

.. important:: In the following, each configuration step starts with (initial) **Leader** or (future) **Follower** to indicate the server where the step must be performed.

Configuration of the initial leader
--------------------------------------------------------------------------------

We start with the first server, to perform the initial system bootstrapping.

* **Leader**: Start OpenNebula
* **Leader**: Add the server itself to the zone:

.. prompt:: bash $ auto

  $ onezone list
  C    ID NAME                      ENDPOINT
  *     0 OpenNebula                http://localhost:2633/RPC2

  # We are working on Zone 0

  $ onezone server-add 0 --name server-0 --rpc http://192.168.150.1:2633/RPC2

  # It's now available in the zone:

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  ZONE SERVERS
  ID NAME            ENDPOINT
   0 server-0        http://192.168.150.1:2633/RPC2

  HA & FEDERATION SYNC STATUS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  FED_INDEX
   0 server-0        solo       0          -1         0          -1    -1

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

.. important::

  Floating IP should be used for **zone endpoints** and cluster private
  addresses for the zone **server endpoints**.

* **Leader**: Stop OpenNebula service and update ``SERVER_ID`` in ``/etc/one/oned.conf``

.. code-block:: bash

  FEDERATION = [
      MODE          = "STANDALONE",
      ZONE_ID       = 0,
      SERVER_ID     = 0, # changed from -1 to 0 (as 0 is the server id)
      MASTER_ONED   = ""
  ]


* **Leader**: [Optional] Enable the RAFT Hooks in ``/etc/one/oned.conf``. This will add a floating IP to the system.

.. note::

    Floating IP should be used for monitor daemon parameter MONITOR_ADDRESS in ``/etc/one/monitord.conf``
.. code-block:: bash

  # Executed when a server transits from follower->leader
  RAFT_LEADER_HOOK = [
       COMMAND = "raft/vip.sh",
       ARGUMENTS = "leader eth0 10.3.3.2/24"
  ]

  # Executed when a server transits from leader->follower
  RAFT_FOLLOWER_HOOK = [
      COMMAND = "raft/vip.sh",
      ARGUMENTS = "follower eth0 10.3.3.2/24"
  ]

* **Leader**: Start OpenNebula.
* **Leader**: Check the zone. The server is now the *leader* and has the floating IP:

.. prompt:: bash $ auto

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  ZONE SERVERS
  ID NAME            ENDPOINT
   0 server-0        http://192.168.150.1:2633/RPC2

  HA & FEDERATION SYNC STATUS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  FED_INDEX
   0 server-0        leader     1          3          3          -1    -1

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"
  $ ip -o a sh eth0|grep 10.3.3.2/24
  2: eth0    inet 10.3.3.2/24 scope global secondary eth0\       valid_lft forever preferred_lft forever

.. _frontend_ha_setup_add_remove_servers:

Adding more servers
--------------------------------------------------------------------------------

.. warning::

  This procedure will discard the OpenNebula database in the server you are adding and substitute it with the database of the initial *leader*.

.. warning::

  Add only one host at a time. Repeat this process for every server you want to add.

* **Leader**: Create a DB backup in the initial *leader* and distribute it to the new server, along with the files in ``/var/lib/one/.one/``:

.. prompt:: bash $ auto

  $ onedb backup -u oneadmin -p oneadmin -d opennebula
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2017-6-1_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file

  # Copy it to the other servers
  $ scp /var/lib/one/mysql_localhost_opennebula_2017-6-1_11:52:47.sql <ip>:/tmp

  # Copy the .one directory (make sure you preseve the owner: oneadmin)
  $ ssh <ip> rm -rf /var/lib/one/.one
  $ scp -r /var/lib/one/.one/ <ip>:/var/lib/one/

* **Follower**: Stop OpenNebula on the new server if it is running.
* **Follower**: Restore the database backup on the new server.

.. prompt:: bash $ auto

  $ onedb restore -f -u oneadmin -p oneadmin -d opennebula /tmp/mysql_localhost_opennebula_2017-6-1_11:52:47.sql
  MySQL DB opennebula at localhost restored.

* **Leader**: Add the new server to OpenNebula (in the initial *leader*), and note the server id.

.. prompt:: bash $ auto

  $ onezone server-add 0 --name server-1 --rpc http://192.168.150.2:2633/RPC2

* **Leader**: Check the zone. The new server is in the error state, since OpenNebula on the new server is still not running. Make a note of the server id, in this case 1.

.. prompt:: bash $ auto

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  ZONE SERVERS
  ID NAME            ENDPOINT
   0 server-0        http://192.168.150.1:2633/RPC2
   1 server-1        http://192.168.150.2:2633/RPC2

  HA & FEDERATION SYNC STATUS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  FED_INDEX
   0 server-0        leader     1          19         19         -1    -1
   1 server-1        error      -          -          -          -

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

* **Follower**: Edit ``/etc/one/oned.conf`` on the new server to set the ``SERVER_ID`` for the new server. Make sure to enable the hooks as in the initial *leader's* configuration.
* **Follower**: Start the OpenNebula service.
* **Leader**: Run ``onezone show 0`` to make sure that the new server is in *follower* state.

.. prompt:: bash $ auto

  $ onezone show 0
  ZONE 0 INFORMATION
  ID                : 0
  NAME              : OpenNebula


  ZONE SERVERS
  ID NAME            ENDPOINT
   0 server-0        http://192.168.150.1:2633/RPC2
   1 server-1        http://192.168.150.2:2633/RPC2

  HA & FEDERATION SYNC STATUS
  ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  FED_INDEX
   0 server-0        leader     1          21         19         -1    -1
   1 server-1        follower   1          16         16         -1    -1

  ZONE TEMPLATE
  ENDPOINT="http://localhost:2633/RPC2"

.. note::

  It may happen that the **TERM**/**INDEX**/**COMMIT** does not match (as above). This is not important right now; it will sync automatically when the database is changed.

Repeat this section to add new servers. Make sure that you only add servers when the cluster is in a healthy state. That means there is 1 *leader* and the rest are in *follower* state. If there is one server in error state, fix it before proceeding.

Checking Cluster Health
=======================

Execute ``onezone show <id>`` to see if any of the servers are in error state. If they are in error state, check ``/var/log/one/oned.log`` in both the current *leader* (if any) and in the host that is in error state. All Raft messages will be logged in that file.

If there is no *leader* in the cluster please review ``/var/log/one/oned.log`` to make sure that there are no errors taking place.

Adding and Removing Servers
===========================

In order to add servers you need to use this command:

.. prompt:: bash $ auto

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

Make sure that there is one *leader* (by running ``onezone show <id>``), otherwise it will not work.

To remove a server, use the command:

.. prompt:: bash $ auto

  $ onezone server-del
  Command server-del requires 2 parameters to run.
  ## USAGE
  server-del <zoneid> <serverid>
          Delete an OpenNebula server from this zone.

  ## OPTIONS
       -v, --verbose             Verbose mode
       -h, --help                Show this message
       -V, --version             Show version and copyright information
       --user name               User name used to connect to OpenNebula
       --password password       Password to authenticate with OpenNebula
       --endpoint endpoint       URL of OpenNebula xmlrpc frontend

The whole procedure is documented :ref:`above <frontend_ha_setup_add_remove_servers>`.

.. _frontend_ha_recover_servers:

Recovering servers
================================================================================

When a *follower* is down for some time it may fall out of the recovery window, i.e. the log may not include all the records needed to bring it up-to-date. In order to recover this server you need to:

* **Leader**: Create a DB backup and copy it to the failed *follower*. Note that you cannot reuse a previous backup.
* **Follower**: Stop OpenNebula if it is running.
* **Follower**: Restore the DB backup from the *leader*.
* **Follower**: Start OpenNebula.
* **Leader**: Reset the failing *follower* with:

.. prompt:: bash $ auto

  $ onezone server-reset <zone_id> <server_id_of_failed_follower>

Shared data between HA nodes
================================================================================

HA deployment requires the filesystem view of most datastores (by default in ``/var/lib/one/datastores/``) to be the same on all frontends. It is necessary to setup a shared filesystem over the datastore directories. This document does not cover configuration and deployment of the shared filesystem; it is left completely up to the cloud administrator.

OpenNebula stores virtual machine logs inside ``/var/log/one/`` as files named ``${VMID}.log``. It is not recommended to share the whole log directory between the front-ends as there are also other OpenNebula logs which would be randomly overwritten. It is up to the cloud administrator to periodically backup the virtual machine logs on the cluster *leader*, and on fail-over to restore from the backup on a new *leader* (e.g. as part of the raft hook).

Sunstone and FireEdge
================================================================================

There are several types of Sunstone deployment in an HA environment. The basic one is Sunstone running on each OpenNebula frontend node configured with the local OpenNebula. Only one server, the *leader* with floating IP, is used by the clients.

It is possible to configure a load balancer (e.g. HAProxy, Pound, Apache, or Nginx) over the front-ends to spread the load (read operations) among the nodes. In this case, the **Memcached** and shared ``/var/tmp/`` may be required, please see :ref:`Configuring Sunstone for Large Deployments <suns_advance>`.

To easy scale out beyond the total number of core OpenNebula daemons, Sunstone can be running on separate machines. They should talk to the cluster floating IP (see ``:one_xmlprc:`` in ``sunstone-server.conf``) and may also require **Memcached** and shared ``/var/tmp/`` between Sunstone and front-end nodes. Please check :ref:`Configuring Sunstone for Large Deployments <suns_advance>`.

FireEdge is a next-generation GUI, which doesn't support highly available deployment yet.

Raft Configuration Attributes
================================================================================

The Raft algorithm can be tuned by several parameters in the configuration file ``/etc/one/oned.conf``. The following options are available:

+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Raft: Algorithm Attributes                                                                                                                          |
+============================+========================================================================================================================+
| ``LIMIT_PURGE``            | Number of DB log records that will be deleted on each purge.                                                           |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``LOG_RETENTION``          | Number of DB log records kept, it determines the synchronization window across servers and extra storage space needed. |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``LOG_PURGE_TIMEOUT``      | How often applied records are purged according the log retention value. (in seconds).                                  |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``ELECTION_TIMEOUT_MS``    | Timeout to start an election process if no heartbeat or log is received from the *leader*.                             |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``BROADCAST_TIMEOUT_MS``   | How often heartbeats are sent to  *followers*.                                                                         |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``XMLRPC_TIMEOUT_MS``      | To timeout raft-related API calls. To set an infinite  timeout set this value to 0.                                    |
+----------------------------+------------------------------------------------------------------------------------------------------------------------+

.. warning::

  Any change in these parameters can lead to unexpected behavior during the fail-over and result in whole-cluster malfunction. After any configuration change, always check the crash scenarios for the correct behavior.

Compatibility with the earlier HA
=================================

In OpenNebula <= 5.2, HA was configured using a classical active-passive approach, using Pacemaker and Corosync. While this still works for OpenNebula > 5.2, it is not the recommended way to set up a cluster. However, it is fine if you want to continue using that HA method when coming from earlier versions.

This is documented here: `Front-end HA Setup <http://docs.opennebula.io/5.2/advanced_components/ha/frontend_ha_setup.html>`_.

Synchronize configuration files across servers
================================================================================

You can use the command ``onezone serversync``. This command is designed to help administrators to sync OpenNebula's configurations across High Availability (HA) nodes and fix lagging nodes in HA environments. It will first check for inconsistencies between local and remote configuration files inside ``/etc/one/`` directory. In case they exist, the local version will be replaced by the remote version and only the affected service will be restarted. Whole configuration files will be replaced with the only exception of ``/etc/one/oned.conf``. In this case, the local ``FEDERATION`` configuration will be maintained, but the rest of the content will be overwritten. A backup will be made inside ``/etc/one/`` before replacing any file.

.. warning:: Only use this option between HA nodes, never across federated nodes

This is the list of files that will be checked and replaced:

Individual files:

- ``/etc/one/az_driver.conf``
- ``/etc/one/az_driver.default``
- ``/etc/one/ec2_driver.conf``
- ``/etc/one/ec2_driver.default``
- ``/etc/one/econe.conf``
- ``/etc/one/monitord.conf``
- ``/etc/one/oneflow-server.conf``
- ``/etc/one/onegate-server.conf``
- ``/etc/one/sched.conf``
- ``/etc/one/sunstone-logos.yaml``
- ``/etc/one/sunstone-server.conf``
- ``/etc/one/vcenter_driver.default``

Folders:

- ``/etc/one/sunstone-views``
- ``/etc/one/auth``
- ``/etc/one/ec2query_templates``
- ``/etc/one/hm``
- ``/etc/one/sunstone-views``
- ``/etc/one/vmm_exec``

.. note:: Any file inside previous folders that doesn't exist on the remote server (like backups) will **not** be removed.

Usage
-----

.. important:: The command has to be executed under privileged user ``root`` (as it modifies the configuration files) and requires to have a passwordless SSH access to the remote OpenNebula Front-end to remote users ``root`` or ``oneadmin``.

.. prompt:: bash # auto

    # onezone serversync <remote_opennebula_server> [--db]

where ``<remote_opennebula_server>`` needs to be replaced by a hostname/IP of the the OpenNebula server that will be used to fetch configuration files from. If ``--db`` option is used, local database will be synced with the one located on remote server.
