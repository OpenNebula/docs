.. _onprem_cluster:

================================================================================
On-Premises Edge Cluster
================================================================================

Edge Cluster Types
================================================================================

The On-Premises provider allows to automatically configure On-Premises infrastructure as an Edge Cluster. You can use the following hypervisors on your On-Premises bare-metal clusters:

* **KVM** to run virtual machines.
* **Firecracker** to run microVMs.
* **LXC** to run system containers.

On-Premises Provider
================================================================================

The ``onprem`` provider needs no special configuration as it will retrieve the FQDNs of the host to be configured while creating the provisions. It can be easily created by running:

.. prompt:: bash $ auto

    $ oneprovider create /usr/share/one/oneprovision/edge-clusters/onprem/providers/onprem/onprem.yml

The ``onprem`` provider can also be shown by running the command below:

.. prompt:: bash $ auto

    $ oneprovider show onprem
    PROVIDER 0 INFORMATION
    ID   : 0
    NAME : onprem

.. note:: OpenNebula front-end node requires root access to the hosts that are going to be configured using ``onprem`` provider.

On-Premises Edge Cluster Implementation
================================================================================

An On-Premises Edge Cluster consists of a set of hosts with the following requirements:

.. list-table::
  :header-rows: 1
  :widths: 35 200

  * - Host Subsystem
    - Configuration & Requirements
  * - **Operating System**
    - Vanilla CentOS 8 installation.
  * -
    - SSH is configured in the host to grant root passwordless access with the ``oneadmin`` credentials.
  * - **Networking**
    - Configured management interface. The OpenNebula front-end can reach the hosts through this network.
  * -
    - Separated interface connected to the Internet. VMs will access the Internet through this network. Do not configure any IP address for this interface.
  * -
    - Your network should allow inbound connections to ports 22 (TCP), 179 (TCP) and 8472 (UDP) on the management network. The Internet/Public network should not restrict any access. You can later set Security Groups for your VMs.
  * - **Storage**
    - Hosts should have enough local storage mounted under ``/var/lib/one`` to store the virtual disk images of the VMs.

The overall architecture of the On-Premises cluster is shown below. OpenNebula will create for you the following resources:

* Image and System datastore for the cluster. The storage is configured to use the Hosts :ref:`local storage through OneStor drivers <onestor_ds>`. On-Premises clusters also include access to the default datastore, so you can easily share images across clusters.
* Public Network, bound to the Internet interface through a Linux Bridge.
* Private Networking, implemented using a VXLAN overlay on the management network.

|image_prem|

Tutorial: Provision an On-Premises Cluster
================================================================================

Step 1. Check your hosts
--------------------------------------------------------------------------------

Before we start we need to prepare the hosts for our on-prem cluster. We just need a vanilla installation of CentOS 8 with root passwordless SSH access. In this tutorial we'll use ``host01`` and ``host02``.

.. prompt:: bash $ auto

    $ ssh root@host01 cat /etc/centos-release
    Warning: Permanently added 'host01,10.4.4.100' (ECDSA) to the list of known hosts.
    CentOS Linux release 8.3.2011
    

    $  ssh root@host02 cat /etc/centos-release
    Warning: Permanently added 'host02,10.4.4.101' (ECDSA) to the list of known hosts.
    CentOS Linux release 8.3.2011

Step 2. Create your On-premises cluster
--------------------------------------------------------------------------------

Check that you have your On-Premises provider created (if not, see above):

.. prompt:: bash $ auto

    $ oneprovider list
      ID NAME                                                                    REGTIME
       0 onprem                                                           04/28 11:31:34

Now we can create our On-Premises Edge Cluster, grab the following attributes for your setup:

.. list-table::
  :header-rows: 1
  :widths: 35 70

  * - Attribute
    - Content
  * - Hostnames
    - host01;host02
  * - Hypervisor
    - LXC
  * - Public Network Interface
    - eth1
  * - Public IP block
    - 172.16.0.2, and the next 10 consecutive addresses
  * - Private Network Interface
    - eth0

The command, using a verbose output mode, looks like:

.. prompt:: bash $ auto

    $ oneprovision create -Dd --provider onprem /usr/share/one/oneprovision/edge-clusters/onprem/provisions/onprem.yml

    2021-04-28 18:04:45 DEBUG : Executing command: `create`
    2021-04-28 18:04:45 DEBUG : Command options: debug [verbose, true] [provider, onprem] [sync, true]
    ID: 4
    Virtualization technology for the cluster hosts

        0  kvm
        1  lxc
        2  firecracker

    Please select the option (default=): lxc

    Physical device to be used for private networking.
    Text `private_phydev` (default=): eth0

    Comma separated list of FQDNs or IP addresses of the hosts to be added to the cluster
    Array `hosts_names` (default=): host01;host02

    Physical device to be used for public networking.
    Text `public_phydev` (default=): eth1

    First public IP for the public IPs address range.
    Text `first_public_ip` (default=): 172.16.0.2

    Number of public IPs to get
    Text `number_public_ips` (default=1): 10

    2021-04-28 18:05:15 INFO  : Creating provision objects
    ...
    2021-04-28 18:05:17 DEBUG : Generating Ansible configurations into /tmp/d20210428-3894-z6wb1x
    2021-04-28 18:05:17 DEBUG : Creating /tmp/d20210428-3894-z6wb1x/inventory:
    [nodes]
    host01
    host02

    [targets]
    host01 ansible_connection=ssh ansible_ssh_private_key_file=/var/lib/one/.ssh-oneprovision/id_rsa ansible_user=root ansible_port=22
    host02 ansible_connection=ssh ansible_ssh_private_key_file=/var/lib/one/.ssh-oneprovision/id_rsa ansible_user=root ansible_port=22

    ...

    Provision successfully created
    ID: 4

Step 3. Quick tour on your new cluster
--------------------------------------------------------------------------------

Let's first check  the hosts are up and running, in our simple case:

.. prompt:: bash $ auto

    $ onehost list
  ID NAME                  CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   4 host02                onprem-clu   0       0 / 200 (0%)     0K / 3.8G (0%) on
   3 host01                onprem-clu   0       0 / 200 (0%)     0K / 3.8G (0%) on

And similarly for the networks. You'll have a public network and a network template to create as many private networks as you need:

.. prompt:: bash $ auto

    $ onevnet list
  ID USER     GROUP    NAME                        CLUSTERS   BRIDGE          LEASES
   4 oneadmin oneadmin onprem-cluster-public       102        onebr4               0

    $ onevntemplate list
  ID USER     GROUP    NAME                                                  REGTIME
   0 oneadmin oneadmin onprem-cluster-private                         04/28 18:08:38

For example let's create a 192.168.0.100/26 network from the private network template:

.. prompt:: bash $ auto

    $ onevntemplate instantiate 0 --ip 192.168.0.100 --size 64
    VN ID: 5

Step 4. A Simple test, run a container
--------------------------------------------------------------------------------

As a simple test we'll run a container. For example let's pick the nginx base image from Tunrkey Linux Market:

.. prompt:: bash $ auto

    $ onemarketapp list | grep -i 'nginx.*LX'
     107 nginx - LXD                                         1.0    5G  rdy  img 11/23/18 TurnKey Li    0

and add it into our cloud:

.. prompt:: bash $ auto

   $ onemarketapp export 107 nginx_market -d default
    IMAGE
        ID: 2
    VMTEMPLATE
        ID: 3

   $ oneimage list
  ID USER     GROUP    NAME                    DATASTORE     SIZE TYPE PER STAT RVMS
   2 oneadmin oneadmin nginx_market            default      1024M OS    No rdy     0

The final step will be adding a network interface to the template just created (3 in our example):

.. prompt:: bash $ auto

    $onetemplate update 3
    ...
    NIC = [ NETWORK_MODE = "auto", SCHED_REQUIREMENTS = "NETROLE = \"public\"" ]

Now we can create the VM from this template:

.. prompt:: bash $ auto
    
    $ onetemplate instantiate 3
    VM ID:10
    
    $ onevm show 10
    VIRTUAL MACHINE 10 INFORMATION
    ID                  : 10
    NAME                : nginx-10
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING

    ...

    VIRTUAL MACHINE MONITORING
    CPU                 : 0
    MEMORY              : 332.7M
    NETTX               : 103K
    NETRX               : 102K

    ...
    VM DISKS
     ID DATASTORE  TARGET IMAGE                               SIZE      TYPE SAVE
      0 default    sda    nginx                               5G/5G     file   NO
      1 -          hda    CONTEXT                             1M/-      -       -

    VM NICS
     ID NETWORK              BRIDGE       IP              MAC               PCI_ID
      0 onprem-cluster-publi onebr4       172.16.0.2      02:00:ac:10:00:02

If you connect through SSH to the VM, the setup screen for the appliance should welcome you:

|image_mysql|

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage On-Premise Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_fireedge| image:: /images/oneprovision_fireedge.png
.. |image_prem| image:: /images/onprem-cluster.png
.. |image_mysql| image:: /images/onprem-nginx.png

