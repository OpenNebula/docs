============================
OpenNebula High Availability
============================

This guide walks you through the process of setting a high available
cluster for OpenNebula. The ultimate goal is to reduce downtime of core
OpenNebula services: core (oned), scheduler (mm\_sched) and Sunstone
interface (sunstone-server).

We will be using the classical active-passive cluster architecture which
is the recommended solution for OpenNebula. In this solution two (or
more) nodes will be part of a cluster where the OpenNebula daemon,
scheduler and Sunstone (web UI) are cluster resources. When the active
node fails, the passive one takes control.

If you are interested in failover protection against hardware and
operating system outages within your virtualized IT environment, check
the `Virtual Machines High Availability Guide </./ftguide>`__.

This guide is structured in a â€œhow-toâ€? form using the Red Hat HA
Cluster suite tested in a CentOS installation; but generic
considerations and requirements for this setup are discussed to easily
implement this solution with other systems.

Overview
========

In terms of high-availability, OpenNebula consists in three different
basic services, namely:

-  **OpenNebula Core**: It is the main orchestration component,
supervises the life-cycle of each resources (e.g. hosts, VMs or
networks) and operates on the physical infrastructure to deploy and
manage virtualized resources.

-  **Scheduler**: The scheduler performs a matching between the virtual
requests and the available resources using different scheduling
policies. It basically assigns a physical host, and a storage area to
each VM.

-  **Sunstone**: The GUI for advanced and cloud users as well as system
administrators. The GUI is accessed through a well-known end-point
(IP/URL). Sunstone has been architected as a scalable web application
supporting multiple application servers or processes.

The state of the system is stored in a database for persistency and
managed by OpenNebula core. In order to improve the response time of the
core daemon, it caches the most recently used data so it reduces the
number of queries to the DB. Note that this prevents an active-active HA
configuration for OpenNebula. However such a configuration, given the
lightweight and negligible start times of the core services, does not
suppose any advantage.

In this guide we assume that the DB backing OpenNebula core state is
also configured in a HA mode. The procedure for MySQL is well documented
elsewhere. Although Sqlite could also be used it is not recommended for
a HA deployment.

|image0|

HA Cluster Components & Services
================================

As shown in the previous figure, we will use just one fail-over domain
(blue) with two hosts. All OpenNebula services will be collocated and
run on the same server in this case. You can however easily modify this
configuration to split them and allocate each service to a different
host and define different fail-over domains for each one (e.g. blue for
oned and scheduler, red for sunstone).

The following components will be installed and configured based on the
RedHat Cluster suite:

\* **Cluster management**, CMAN (cluster manager) and corosync. These
components manage cluster membership and quorum. It prevents service
corruption in a distributed setting because of a â€œsplit-brainâ€?
condition (e.g. two opennebulas updating the DB).

\* **Cluster configuration system**, CCS. It keeps and synchronizes the
cluster configuration information. There are other windows-based
configuration systems.

\* **Service Management**, rgmanager. This module checks service status
and start/stop them as needed in case of failure.

\* **Fencing**, in order to prevent OpenNebula DB corruption it is
important to configure a suitable fencing mechanism.

Installation and Configuration
==============================

In the following, we assume that the cluster consists on two servers:

-  one-server1
-  one-server2

|:!:| While setting and testing the installation it is recommended to
disable any firewall. Also watch out for se\_linux.

Step 1: OpenNebula
------------------

You should have two servers (they may be VMs, as discussed below) ready
to install OpenNebula. These servers will have the same requirements as
regular OpenNebula front-end (e.g. network connection to hosts, ssh
passwordless access, shared filesystems if requiredâ€¦). Remember to use
a HA MySQL backend.

It is important to use a twin installation (i.e. same configuration
files) so probably it is better to start and configure a server, and
once it is tested rsync the configuration to the other one.

Step 2: Install Cluster Software
--------------------------------

In all the cluster servers install the cluster components:

.. code::

# yum install ricci
# passwd ricci

|:!:| Set the same password for user ricci in all the servers

.. code::

# yum install cman rgmanager
# yum install ccs

Finally enable the daemons and start ricci.

.. code::

# chkconfig ricci on
# chkconfig cman rgmanager on
# chkconfig rgmanager on
# service ricci start

Step 3: Create the Cluster and Failover Domain
----------------------------------------------

Cluster configuration is stored in ``/etc/cluster/cluster.conf`` file.
You can either edit this file directly or use the ccs tool. It is
important, however to synchronize and activate the configurtion on all
nodes after a change.

To define the cluster using ccs:

.. code::

# ccs -h one-server1 --createcluster opennebula
# ccs -h one-server1 --setcman two_node=1 expected_votes=1
# ccs -h one-server1 --addnode one-server1
# ccs -h one-server1 --addnode one-server2
# ccs -h one-server1 --startall

|:!:| You can use the -p option in the previous commands with the
password set for user ricci.

Now you should have a cluster with two nodes, note the specific quorum
options for cman, running. Let's create one failover domain for
OpenNebula services consisting of both servers:

.. code::

# ccs -h one-server1 --addfailoverdomain opennebula ordered
# ccs -h one-server1 --addfailoverdomainnode opennebula one-server1 1
# ccs -h one-server1 --addfailoverdomainnode opennebula one-server2 2
# ccs -h one-server1 --sync --activate

Step 4: Define the OpenNebula Service
-------------------------------------

As pointed out previously we'll use just one fail-over domain with all
the OpenNebula services co-allocated in the same server. You can easily
split the services in different servers and failover domains if needed
(e.g. for security reasons you want Sunstone in other server).

First create the resources of the service: A IP address to reach
Sunstone, the one init.d script (it starts oned and scheduler) and the
sunstone init.d script

.. code::

# ccs --addresource ip address=10.10.11.12 sleeptime=10 monitor_link=1
# ccs --addresource script name=opennebula file=/etc/init.d/opennebula
# ccs --addresource script name=sunstone file=/etc/init.d/opennebula-sunstone

Finally compose the service with these resources and start it:

.. code::

# ccs --addservice opennebula domain=opennebula recovery=restart autostart=1
# ccs --addsubservice opennebula ip ref=10.10.11.12
# ccs --addsubservice opennebula script ref=opennebula
# ccs --addsubservice opennebula script ref=sunstone
# ccs -h one-server1 --sync --activate

As a reference the /etc/cluster/cluster.conf should look like:

.. code:: code

<?xml version="1.0"?>
<cluster config_version="17" name="opennebula">
<fence_daemon/>
<clusternodes>
<clusternode name="one-server1" nodeid="1"/>
<clusternode name="one-server2" nodeid="2"/>
</clusternodes>
<cman expected_votes="1" two_node="1"/>
<fencedevices/>
<rm>
<failoverdomains>
<failoverdomain name="opennebula" nofailback="0" ordered="1" restricted="0">
<failoverdomainnode name="one-server1" priority="1"/>
<failoverdomainnode name="one-server2" priority="2"/>
</failoverdomain>
</failoverdomains>
<resources>
<ip address="10.10.11.12" sleeptime="10"/>
<script file="/etc/init.d/opennebula" name="opennebula"/>
<script file="/etc/init.d/opennebula-sunstone" name="sunstone"/>
</resources>
<service domain="opennebula" name="opennebula" recovery="restart">
<ip ref="10.10.11.12"/>
<script ref="opennebula"/>
<script ref="sunstone"/>
</service>
</rm>
</cluster>

Fencing and Virtual Clusters
============================

Fencing is an essential component when setting up a HA cluster. You
should install and test a proper fencing device before moving to
production. In this section we show how to setup a special fencing
device for virtual machines.

OpenNebula can be (and it is usually) installed in a virtual machine.
Therefore the previous one-server1 and one-server2 can be in fact
virtual machines running in the same physical host (you can run them in
different hosts, requiring a different fencing plugin).

In this case, a virtual HA cluster running in the same host, you could
control misbehaving VMs and restart OpenNebula in other virtual server.
However, if you need a to control also host failures you need to fencing
mechanism for the physical host (typically based on power).

Let's assume then that one-server1 and one-server2 are VMs using KVM and
libvirt, and running on a physical server.

Step 1: Configuration of the Physical Server
--------------------------------------------

Install the fence agents:

.. code::

yum install fence-virt fence-virtd fence-virtd-multicast fence-virtd-libvirt

Now we need to generate a random key, for the virtual servers to
communicate with the dencing agent in the physical server. You can use
any convinient method, for example: generate key ro access xvm

.. code::

# mkdir /etc/cluster
# date +%s | sha256sum | base64 | head -c 32 Â > /etc/cluster/fence_xvm.key
# chmod 400 /etc/cluster/fence_xvm.key

Finally configure the fence-virtd agent

.. code::

# fence-virtd -c

The configuration file should be similar to:

.. code:: code

=== Begin Configuration ===
backends {
libvirt {
uri = "qemu:///system";
}
 
}
 
listeners {
multicast {
interface = "eth0";
port = "1229";
family = "ipv4";
address = "225.0.0.12";
key_file = "/etc/cluster/fence_xvm.key";
}
 
}
 
fence_virtd {
module_path = "/usr/lib64/fence-virt";
backend = "libvirt";
listener = "multicast";
}
 
=== End Configuration ===

|:!:| Interface (eth0 in the example) is the interface used to
communicate the virtual and physical servers.

Now you can start and test the fencing agent:

.. code::

# chkconfig fence_virtd on
# service fence_virtd start
# fence_xvm -o list

Step 2: Configuration of the Virtual Servers
--------------------------------------------

You need to copy the key to each virtual server:

.. code::

scp /etc/cluster/fence_xvm.key one-server1:/etc/cluster/
scp /etc/cluster/fence_xvm.key one-server2:/etc/cluster/

Now you should be able to test the fencing agent in the virtual nodes:

.. code::

# fence_xvm -o list

Step 3: Configure the Cluster to Use Fencing
--------------------------------------------

Finally we need to add the fencing device to the cluster:

.. code::

ccs --addfencedev libvirt-kvm agent=fence_xvm key_file="/etc/cluster/fence_xvm.key" multicast_address="225.0.0.12" ipport="1229"

And let the servers use it:

.. code::

# ccs --addmethod libvirt-kvm one-server1
# ccs --addmethod libvirt-kvm one-server2
# ccs --addfenceinst libvirt-kvm one-server1 libvirt-kvm port=one1
# ccs --addfenceinst libvirt-kvm one-server2 libvirt-kvm port=one2

Finally synchronize and activate the configuration:

.. code::

# ccs -h one-server1 --sync --activate

What to Do After a Fail-over Event
==================================

When the active node fails and the passive one takes control, it will
start OpenNebula again. This OpenNebula will see the resources in the
exact same way as the one in the server that crashed. However, there
will be a set of Virtual Machines which will be stuck in transient
states. For example when a Virtual Machine is deployed and it starts
copying the disks to the target hosts it enters one of this transient
states (in this case 'PROLOG'). OpenNebula will wait for the storage
driver to return the 'PROLOG' exit status. This will never happen since
the driver fails during the crash, therefore the Virtual Machine will
get stuck in the state.

In these cases it's important to review the states of all the Virtual
Machines and let OpenNebula know if the driver exited succesfully or
not. There is a command specific for this: ``onevm recover``. You can
read more about this command in the `Managing Virtual
Machines </./rel4.2:vm_guide_2#life-cycle_operations_for_administrators>`__
guide.

In our example we would need to manually check if the disk files have
been properly deployed to our host and execute:

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

.. |image0| image:: /./_media/documentation:rel4.2:ha_opennebula.png?w=475
.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
