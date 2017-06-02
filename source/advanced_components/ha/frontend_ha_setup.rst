.. _frontend_ha_setup:
.. _oneha:

=============================
OpenNebula HA Setup
=============================

This guide walks you through the process of setting a high available cluster for OpenNebula core services: core (oned), scheduler (mm\_sched) and Sunstone interface (sunstone-server).

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

Adding and Removing Servers
===========================

Configuring Failover for Sunstone and Monitor Agents
====================================================

Summary of Raft Configuration Attributes
========================================

.. todo:: Complete and remove old content

In terms of high-availability, OpenNebula consists in three different basic services, namely:

* **OpenNebula Core**: It is the main orchestration component, supervises the life-cycle of each resources (e.g. hosts, VMs or networks) and operates on the physical infrastructure to deploy and manage virtualized resources.
* **Scheduler**: The scheduler performs a matching between the virtual requests and the available resources using different scheduling policies. It basically assigns a physical host, and a storage area to each VM.
* **Sunstone**: The GUI for advanced and cloud users as well as system administrators. The GUI is accessed through a well-known end-point (IP/URL). Sunstone has been architected as a scalable web application supporting multiple application servers or processes.

The state of the system is stored in a database for persistency and managed by OpenNebula core. In order to improve the response time of the core daemon, it caches the most recently used data so it reduces the number of queries to the DB. Note that this prevents an active-active HA configuration for OpenNebula. However an active-passive configuration, given the lightweight and negligible start times of the core services, is a very adequate solution for the HA problem.

In this guide we assume that the DB backing OpenNebula core state is also configured in an HA mode. The database service should be configured as master-master setup running in the frontend Virtual Machines (very easy to setup and recommended), or as part of the cluster (with clustered storage), or in an external dedicated HA database cluster. The procedure to setup an HA environment for MySQL is beyond the scope of this document. Sqlite should not be used and is not recommended in any case for production setups.

This guide assumes we are not using Apache to serve the Sunstone GUI. Note that the recommendation for production environment is to use Apache. Instead of registering ``opennebula-sunstone`` as a cluster resource, we would need to register ``httpd`` (and configuring it first).

|image0|

HA Cluster Components & Services
================================

As shown in the previous figure, we will use just one fail-over domain (blue) with two hosts. All OpenNebula services will be co-located and run on the same server in this case. You can however easily modify this configuration to split them and assign each service to a different host and define different fail-over domains for each one (e.g. blue for oned and scheduler, red for sunstone).

The following components will be installed:

* opennebula services
* corosync+pacemaker
* fencing agents

Installation and Configuration in CentOS 7
==========================================

In the following, we assume that the cluster consists on two servers:

* one-server1
* one-server2

.. warning:: While setting and testing the installation it is recommended to disable any firewall. Also watch out for SELinux.

Step 1: OpenNebula
------------------

You should have two servers (they may be VMs, as discussed below) ready to install OpenNebula. These servers will have the same requirements as regular OpenNebula front-end (e.g. network connection to hosts, ssh passwordless access, shared filesystems if required...). Remember to use a HA MySQL backend.

It is important to use a twin installation (i.e. same configuration files) so probably it is better to start and configure a server, and once it is tested rsync the configuration to the other one.

Step 2: Install Cluster Software
--------------------------------

In **both** cluster servers install the cluster components:

.. code:: bash

    $ yum install pcs fence-agents-all
    $ passwd hacluster

.. warning:: Set the same password for user hacluster in all the servers

``Pacemaker`` bundles the ``Sinatra`` and ``Rack`` gems, and if the wrong version of the gems is installed in the host, it will fail to start. Therefore ensure you manually install the specific versions:

.. code:: bash

  $ gem uninstall rack sinatra
  $ gem install --no-ri --no-rdoc rack --version=1.5.2
  $ gem install --no-ri --no-rdoc rack-protection --version=1.5.3
  $ gem install --no-ri --no-rdoc rack-test --version=0.6.2
  $ gem install --no-ri --no-rdoc sinatra --version=1.4.5
  $ gem install --no-ri --no-rdoc sinatra-contrib --version=1.4.2
  $ gem install --no-ri --no-rdoc sinatra-sugar --version=0.5.1

Maybe the versions listed above do not coincide with the ``sinatra*`` and ``rack*`` gems vendorized in the ``/usr/lib/pcsd/vendor/bundle/ruby/gems/`` path (owned by the ``pcsd`` package). If they don't update the previous commands with the appropriate versions.

Start/enable the cluster services:

.. code:: bash

    $ systemctl start pcsd.service
    $ systemctl enable pcsd.service
    $ systemctl enable corosync.service
    $ systemctl enable pacemaker.service

At this point make sure the firewall allows the necessary ports for the cluster services. Remember to disable it if you hit any errors to determine if the error comes from the firewall. If you are using ``firewalld`` use the following snippet to allow the cluster services traffic:

.. code:: bash

  $ firewall-cmd --permanent --add-service=high-availability
  $ firewall-cmd --reload


Step 3: Create the Cluster and Failover Domain
----------------------------------------------

The following commands must be executed **only in one node**, for example ``one-server1``.

Authorize the nodes:

.. code:: bash

    $ pcs cluster auth one-server1 one-server2
    Username: hacluster

    one-server1: Authorized
    one-server2: Authorized

Now we need to create the cluster:

.. code:: bash

  $ pcs cluster setup --name opennebula one-server1 one-server2

Now we can start the cluster:

.. code:: bash

  $ pcs cluster start --all

As we only have two nodes, we can't reach a majority quorum, we must disable it:

.. code:: bash

  pcs property set no-quorum-policy=ignore

Step 4: Define the OpenNebula Service
-------------------------------------

We need to enable a fencing agent. To query the available ones you can execute:

.. code:: bash

  $ pcs stonith list
  $ pcs stonith describe <fencing_agent>

In this case we will exemplify the ``fence_ilo_ssh`` command:

.. code:: bash

  $ pcs stonith create fence_server1 fence_ilo_ssh pcmk_host_list=one-server1 ipaddr=<ilo_hypervisor_one-server1> login="..." passwd="..." action="reboot" secure=yes delay=30 op monitor interval=20s
  $ pcs stonith create fence_server2 fence_ilo_ssh pcmk_host_list=one-server2 ipaddr=<ilo_hypervisor_one-server2> login="..." passwd="..." action="reboot" secure=yes delay=15 op monitor interval=20s

Not that the delay is different to get protection from stonith battles. With the above cofiguration, in a split brain event ``one-server2`` would be killed before it can kill ``one-server1``, ensure we keep at least one node.

You can try out fencing manually by running these commands:

.. code:: bash

  $ fence_ilo_ssh -o status -x -a "<ilo_hypervisor_one-server1>" -l "..." -p "..." -v
  $ fence_ilo_ssh -o reboot -x -a "<ilo_hypervisor_one-server1>" -l "..." -p "..." -v

Or even by calling the cluster:

.. code:: bash

  $ pcs stonith fence one-server2

Next, we can add the HA IP where users will be able to connect to:

.. code:: bash

  $ pcs resource create Cluster_VIP ocf:heartbeat:IPaddr2 ip=<HA_ip> cidr_netmask=24 op monitor interval=20s

The nic is inferred from the routing table, but it can be passed explicitely. Note that you can check all the possible arguments by running:

.. code:: bash

  $ pcs resource describe ocf:heartbeat:IPaddr2

We are now ready to add the OpenNebula resources:

.. code:: bash

  $ pcs resource create opennebula systemd:opennebula
  $ pcs resource create opennebula-sunstone systemd:opennebula-sunstone
  $ pcs resource create opennebula-gate systemd:opennebula-gate
  $ pcs resource create opennebula-flow systemd:opennebula-flow

.. warning::

  Make sure you run ``systemtl disable <service>`` for all the systemd services you add to the cluster.

You will notice that at this point the services are not started in the same host. If you want them to be in the same host, you can configure the colocation:

.. code:: bash

  $ pcs constraint colocation add opennebula Cluster_VIP INFINITY
  $ pcs constraint colocation add opennebula-sunstone Cluster_VIP INFINITY
  $ pcs constraint colocation add opennebula-novnc Cluster_VIP INFINITY
  $ pcs constraint colocation add opennebula-gate Cluster_VIP INFINITY
  $ pcs constraint colocation add opennebula-flow Cluster_VIP INFINITY

At this point, the cluster should be properly configured:

.. code:: bash

  $ pcs status
  Cluster name: opennebula
  Last updated: [...]
  Stack: corosync
  Current DC: one-server1 (version [...]) - partition with quorum
  2 nodes and 8 resources configured

  Online: [ one-server1 one-server2 ]

  Full list of resources:

   fence_server1 (stonith:fence_ilo_ssh):  Started one-server1
   fence_server2 (stonith:fence_ilo_ssh):  Started one-server2
   Cluster_VIP  (ocf::heartbeat:IPaddr2): Started one-server1
   opennebula (systemd:opennebula): Started one-server1
   opennebula-sunstone (systemd:opennebula-sunstone):  Started one-server1
   opennebula-novnc (systemd:opennebula-novnc): Started one-server1
   opennebula-gate  (systemd:opennebula-gate):  Started one-server1
   opennebula-flow  (systemd:opennebula-flow):  Started one-server1

  Failed Actions:

  PCSD Status:
    one-server1: Online
    one-server2: Online

  Daemon Status:
    corosync: active/enabled
    pacemaker: active/enabled
    pcsd: active/enabled


Installation and Configuration in Ubuntu 14.04
==============================================

We assume that the cluster consists on two servers:

* one-server1
* one-server2

Step 1: OpenNebula
------------------

You should have two servers (they may be VMs, as discussed below) ready to install OpenNebula. These servers will have the same requirements as regular OpenNebula front-end (e.g. network connection to hosts, ssh passwordless access, shared filesystems if required...). Remember to use a HA MySQL backend.

It is important to use a twin installation (i.e. same configuration files) so probably it is better to start and configure a server, and once it is tested rsync the configuration to the other one.

Step 2: Install Cluster Software
--------------------------------

In **both** cluster servers install the cluster components:

.. code:: bash

    $ apt-get install pacemaker fence-agents

Now disable the automatic start-up of the OpenNebula resources and enable the HA services on boot time:

.. code:: bash

  $ update-rc.d opennebula disable
  $ update-rc.d opennebula-gate disable
  $ update-rc.d opennebula-flow disable
  $ update-rc.d pacemaker defaults 20 01

Step 3: Configure the Cluster
-----------------------------

The following commands must be executed **only in one node**, for example ``one-server1``.

We need to generate a corosync key, in order to do so we will need an entropy dameon which we will uninstall right afterwards:

.. code::

  $ apt-get install haveged
  $ corosync-keygen
  $ apt-get remove --purge haveged

Let's define the corosync.conf (based on ``/etc/corosync/corosync.conf.example.udpu`` which installs as part of the package):

.. code::

  $ cat /etc/corosync/corosync.conf
  totem {
    version: 2
    cluster_name: opennebula

    crypto_cipher: none
    crypto_hash: none

    interface {
      ringnumber: 0
      bindnetaddr: 10.3.4.0
      mcastport: 5405
      ttl: 1
    }
    transport: udpu
  }

  logging {
    fileline: off
    to_logfile: yes
    to_syslog: yes
    logfile: /var/log/corosync/corosync.log
    debug: off
    timestamp: on
    logger_subsys {
      subsys: QUORUM
      debug: off
    }
  }

  nodelist {
    node {
      ring0_addr: 10.3.4.20
      nodeid: 1
    }

    node {
      ring0_addr: 10.3.4.21
      nodeid: 2
    }
  }

  quorum {
    provider: corosync_votequorum
    two_node: 1
  }


Substitute the IPs with the proper ones, and make sure that in ``totem -> interface -> bindnetaddr`` you type in the **network address**, not the IP.

Allow the pacemaker service to use corosync:

.. code::

  $ cat /etc/corosync/service.d/pcmk
  service {
    name: pacemaker
    ver: 1
  }

And enable the automatic startup of corosync:

.. code::

  $ cat /etc/default/corosync
  # start corosync at boot [yes|no]
  START=yes

Distribute these files to the other node:

.. code::

  $ scp /etc/corosync/authkey one-server2:/etc/corosync
  $ scp /etc/corosync/corosync.conf one-server2:/etc/corosync/corosync.conf
  $ scp /etc/corosync/service.d/pcmk one-server2:/etc/corosync/service.d/pcmk
  $ scp /etc/default/corosync one-server2:/etc/default/corosync

Now start corosync and pacemaker in **both** nodes:

.. code::

  $ service corosync start
  $ service pacemaker start

You can now check that everything is correct:

Check that everything is correct (be patient, it might take a minute or so to get a similar output):

.. code::

    $ crm configure show
    Last updated: Thu Jul 21 12:05:50 2016
    Last change: Thu Jul 21 12:05:18 2016 via cibadmin on one-server2
    Stack: corosync
    Current DC: one-server2 (2) - partition with quorum
    Version: 1.1.10-42f2063
    2 Nodes configured
    0 Resources configured

    Online: [ one-server1 one-server2 ]

Step 4: Add resources to the Cluster
------------------------------------

Now that the cluster is set up, we need to add the resources to it. However, first we need to determine what fencing (stonith) mechanism we are going to use.

.. note:: Fencing is not mandatory, but recommended. If you don't want to use fencing you can add the property: ``property stonith-enabled=false`` to the cib transaction (see below) and skip all the stonith commands below and the stonith primitives in the cib transaction.

To get the supported stonith mechanisms:

.. code:: bash

  $ crm ra list stonith
  apcmaster                   apcmastersnmp               apcsmart                    baytech                     bladehpi
  cyclades                    drac3                       external/drac5              external/dracmc-telnet      external/hetzner
  external/hmchttp            external/ibmrsa             external/ibmrsa-telnet      external/ipmi               external/ippower9258
  external/kdumpcheck         external/libvirt            external/nut                external/rackpdu            external/riloe
  external/ssh                external/vcenter            external/vmware             external/xen0               external/xen0-ha
  fence_ack_manual            fence_alom                  fence_apc                   fence_apc_snmp              fence_baytech
  fence_bladecenter           fence_brocade               fence_bullpap               fence_cdu                   fence_cisco_mds
  fence_cisco_ucs             fence_cpint                 fence_drac                  fence_drac5                 fence_eaton_snmp
  fence_egenera               fence_eps                   fence_ibmblade              fence_ifmib                 fence_ilo
  fence_ilo_mp                fence_intelmodular          fence_ipmilan               fence_ldom                  fence_legacy
  fence_lpar                  fence_mcdata                fence_na                    fence_nss_wrapper           fence_pcmk
  fence_rackswitch            fence_rhevm                 fence_rsa                   fence_rsb                   fence_sanbox2
  fence_scsi                  fence_virsh                 fence_vixel                 fence_vmware                fence_vmware_helper
  fence_vmware_soap           fence_wti                   fence_xcat                  fence_xenapi                fence_zvm
  ibmhmc                      ipmilan                     meatware                    null                        nw_rpc100s
  rcd_serial                  rps10                       ssh                         suicide                     wti_mpc
  wti_nps

To access the documentation of these mechanisms, including how to configure them, use these commands:

.. code:: bash

    $ crm ra meta stonith:fence_ipmilan
    $ stonith_admin --metadata -a ipmilan

From that documentation we can infer that we will need to prepare a stonith primitive such as:

.. code:: bash

    primitive ipmi-fencing stonith::fence_ipmilan \
     params pcmk_host_list="one-server1 one-server2" ipaddr=10.0.0.1 login=testuser passwd=abc123 \
     op monitor interval="60s"

Now we are ready to create a new cib transaction and commit it to pacemaker.

.. code:: bash

  $ crm
  crm(live)# cib new conf1
  crm(live)# cib new conf11
  INFO: conf11 shadow CIB created
  crm(conf1)# configure
  crm(conf1)configure# property no-quorum-policy=ignore
  crm(conf1)configure# primitive ipmi-fencing stonith::fence_ipmilan \
  > params pcmk_host_list="one-server1 one-server2" ipaddr=10.0.0.1 login=testuser passwd=abc123 \
  > op monitor interval="60s"
  crm(conf1)configure# primitive VIP ocf:IPaddr2 params ip=10.3.4.2 op monitor interval=10s
  crm(conf1)configure# primitive opennebula lsb::opennebula op monitor interval=15s
  crm(conf1)configure# primitive opennebula-sunstone lsb::opennebula-sunstone op monitor interval=15s
  crm(conf1)configure# primitive opennebula-flow lsb::opennebula-flow op monitor interval=15s
  crm(conf1)configure# primitive opennebula-gate lsb::opennebula-gate op monitor interval=15s
  crm(conf1)configure# group opennebula-cluster VIP opennebula opennebula-gate opennebula-sunstone opennebula-flow
  crm(conf1)configure# commit
  crm(conf1)configure# end
  crm(conf1)# cib commit conf1
  INFO: committed 'conf1' shadow CIB to the cluster
  crm(conf1)# quit

At this point, the cluster should be properly configured:

.. code:: bash

  $ crm status
  Last updated: Thu Jul 21 16:10:38 2016
  Last change: Thu Jul 21 16:10:34 2016 via cibadmin on one-server1
  Stack: corosync
  Current DC: one-server1 (1) - partition with quorum
  Version: 1.1.10-42f2063
  2 Nodes configured
  6 Resources configured


  Online: [ one-server1 one-server2 ]

   Resource Group: opennebula-cluster
       VIP  (ocf::heartbeat:IPaddr2): Started one-server2
       opennebula (lsb:opennebula): Started one-server2
       opennebula-gate  (lsb:opennebula-gate):  Started one-server2
       opennebula-sunstone  (lsb:opennebula-sunstone):  Started one-server2
       opennebula-flow  (lsb:opennebula-flow):  Started one-server2
   ipmi-fencing (stonith:ipmilan): Started one-server1

What to Do After a Fail-over Event
==================================

When the active node fails and the passive one takes control, it will start OpenNebula again. This OpenNebula will see the resources in the exact same way as the one in the server that crashed. However, there might be a set of Virtual Machines which could be stuck in transient states. For example when a Virtual Machine is deployed and it starts copying the disks to the target hosts it enters one of this transient states (in this case 'PROLOG'). OpenNebula will wait for the storage driver to return the 'PROLOG' exit status. This will never happen since the driver fails during the crash, therefore the Virtual Machine will get stuck in the state.

In these cases it's important to review the states of all the Virtual Machines and let OpenNebula know if the driver exited succesfully or not. There is a command specific for this: ``onevm recover``. You can read more about this command in the :ref:`Managing Virtual Machines <vm_guide_2>` guide.

In our example we would need to manually check if the disk files have been properly deployed to our host and execute:

.. code::

    $ onevm recover <id> --success # or --failure

The transient states to watch out for are:

-  BOOT
-  CLEAN
-  EPILOG
-  FAIL
-  HOTPLUG
-  MIGRARTE
-  PROLOG
-  SAVE
-  SHUTDOWN
-  SNAPSHOT
-  UNKNOWN

.. |image0| image:: /images/ha_opennebula.png
