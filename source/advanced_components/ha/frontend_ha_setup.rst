.. _frontend_ha_setup:
.. _oneha:

=============================
Front-end HA Setup
=============================

This guide walks you through the process of setting a high available cluster for OpenNebula. The ultimate goal is to reduce downtime of core OpenNebula services: core (oned), scheduler (mm\_sched) and Sunstone interface (sunstone-server).

We will be using the classical active-passive cluster architecture which is the recommended solution for OpenNebula. In this solution two (or more) nodes will be part of a cluster where the OpenNebula daemon, scheduler and Sunstone (web UI) are cluster resources. When the active node fails, the passive one takes control.

If you are interested in failover protection against hardware and operating system outages within your virtualized IT environment, check the :ref:`Virtual Machines High Availability Guide <ftguide>`.

This guide is structured in a *how-to* form using Pacemaker tested in a CentOS 7 installation; but generic considerations and requirements for this setup are discussed to easily implement this solution with other systems.

Overview
========

In terms of high-availability, OpenNebula consists in three different basic services, namely:

-  **OpenNebula Core**: It is the main orchestration component, supervises the life-cycle of each resources (e.g. hosts, VMs or networks) and operates on the physical infrastructure to deploy and manage virtualized resources.

-  **Scheduler**: The scheduler performs a matching between the virtual requests and the available resources using different scheduling policies. It basically assigns a physical host, and a storage area to each VM.

-  **Sunstone**: The GUI for advanced and cloud users as well as system administrators. The GUI is accessed through a well-known end-point (IP/URL). Sunstone has been architected as a scalable web application supporting multiple application servers or processes.

The state of the system is stored in a database for persistency and managed by OpenNebula core. In order to improve the response time of the core daemon, it caches the most recently used data so it reduces the number of queries to the DB. Note that this prevents an active-active HA configuration for OpenNebula. However an active-passive configuration, given the lightweight and negligible start times of the core services, is a very adequate solution for the HA problem.

In this guide we assume that the DB backing OpenNebula core state is also configured in an HA mode. The database service should be configured as part of the cluster (with clustered storage), or a master-master setup running in the frontend Virtual Machines (very easy to setup), or in an external dedicated HA database cluster. The procedure to setup an HA environment for MySQL is beyond the scope of this document. Sqlite should not be used and is not recommended in any case for production setups.

This guide assumes we are not using Apache to serve the Sunstone GUI. Note that the recommendation for production environment is to use Apache. Instead of registering ``opennebula-sunstone`` as a cluster resource, we would need to register ``httpd`` (and configuring it first).

|image0|

HA Cluster Components & Services
================================

As shown in the previous figure, we will use just one fail-over domain (blue) with two hosts. All OpenNebula services will be co-located and run on the same server in this case. You can however easily modify this configuration to split them and assign each service to a different host and define different fail-over domains for each one (e.g. blue for oned and scheduler, red for sunstone).

The following components will be installed:

* opennebula services
* corosync+pacemaker
* fencing agents

Installation and Configuration
==============================

In the following, we assume that the cluster consists on two servers:

-  one-server1
-  one-server2

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
