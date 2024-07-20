.. _onprem_cluster_ceph:

================================================================================
On-Premises HCI Cluster
================================================================================

On-Premises HCI Implementation
================================================================================

An On-Premises Edge Cluster with Ceph consists of a set of hosts with the following requirements:

.. list-table::
  :header-rows: 1
  :widths: 35 200

  * - Host Subsystem
    - Configuration & Requirements
  * - **Operating System**
    - Ubuntu 20.04 Focal installation.
  * -
    - SSH is configured in the host to grant root passwordless access with the ``oneadmin`` credentials.
  * - **Networking**
    - Configured management interface. The OpenNebula front-end can reach the hosts through this network.
  * -
    - Separated interface connected to the Internet. **VMs will access the Internet** through this network. Do not configure any IP address for this interface.
  * -
    - Your network should allow inbound connections to ports 22 (TCP), 179 (TCP) and 8472 (UDP) on the management network. The Internet/Public network should not restrict any access. You can later set Security Groups for your VMs.
  * -
    - It's recommended to use also separate network interfaces for Ceph
  * -
    - The nodes needs access to Internet (at least while oneprovision runs), to be able to install the dependencies.
  * - **Storage**
    - Hosts should have at least one separate disk for Ceph datastore

The overall architecture of the On-Premises cluster is shown below. OpenNebula will create for you the following resources:

* Image and System datastore for the cluster. The storage is configured to use the Hosts :ref:`Ceph storage <ceph_ds>`.
* Public Network, bound to the Internet interface through a Linux Bridge.
* Private Networking, implemented using a VXLAN overlay on the management network.

|image_prem_ceph|

On-Premises HCI Definition
================================================================================

To create a HCI Cluster on-premises you need to input the following information:

.. list-table::
    :header-rows: 1
    :widths: 35 35 200

    * - Input Name
      - Example
      - Description
    * - **ceph_full_hosts_names**
      - host01;host02;host02
      - Hosts to run hypervisor, osd and mon ceph daemons (semicolon list of FQDNs or IPs)
    * - **ceph_osd_hosts_names**
      - (can be empty)
      - Hosts to run hypervisor and osd daemons (semicolon list of FQDNs or IPs)
    * - **client_hosts_names**
      - (can be empty)
      - Hosts to run hypervisor and ceph client (semicolon list of FQDNs or IPs)
    * - **ceph_device**
      - /dev/sdb
      - Block devices for Ceph OSD (semicolon separated list)
    * - **ceph_monitor_interface**
      - eth0
      - Physical device to be used for Ceph
    * - **ceph_public_network**
      - (can be empty)
      - Ceph public network in CIDR notation
    * - **private_phydev**
      - eth1
      - Physical device to be used for private networking.
    * - **public_phydev**
      - eth0
      - Physical device to be used for public networking.
    * - **first_public_ip**
      - 172.16.0.2
      - First public IP for the public IPs address range.
    * - **number_public_ips**
      - 10
      - Number of public IPs to get from AWS for VMs

Tutorial: Provision an On-Premises Cluster
================================================================================

Step 1. Check your hosts
--------------------------------------------------------------------------------

Before we start we need to prepare the hosts for our on-prem cluster. We just need a vanilla installation of Ubuntu Focal with root passwordless SSH access. In this tutorial we'll use ``host01``, ``host02`` and ``host03``.

.. prompt:: bash $ auto

    $ ssh root@host01 cat /etc/lsb-release
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=20.04
    DISTRIB_CODENAME=focal
    DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"

Step 2. Create your On-premises Cluster
--------------------------------------------------------------------------------

Check that you have your On-Premises provider created (if not, the instruction for creating it can be found :ref:`here <onprem_provider>`):

.. prompt:: bash $ auto

    $ oneprovider list
      ID NAME                                                                    REGTIME
       0 onprem                                                           04/28 11:31:34

Now we can create our On-Premises Edge Cluster, grab the attributes for the inputs described above. The command, using a verbose output mode, looks like:

.. prompt:: bash $ auto

    $ oneprovision create -Dd --provider onprem /usr/share/one/oneprovision/edge-clusters/metal/provisions/onprem-hci.yml
      2022-05-05 09:01:08 DEBUG : Executing command: `create`
      2022-05-05 09:01:08 DEBUG : Command options: debug [verbose, true] [provider, onprem] [sync, true]
      ID: 2

      Virtualization technology for the cluster hosts

          -  kvm
          -  lxc

      Please select the option (default=): kvm

      Physical device to be used for private networking.
      Text `private_phydev` (default=): eth1

      Hosts to run hypervisor, osd and mon ceph daemons (semicolon list of FQDNs or IPs)
      Array `ceph_full_hosts_names` (default=): host01;host02;host03

      Hosts to run hypervisor and osd daemons (semicolon list of FQDNs or IPs)
      Array `ceph_osd_hosts_names` (default=):

      Hosts to run hypervisor and ceph client (semicolon list of FQDNs or IPs)
      Array `client_hosts_names` (default=):

      Physical device to be used for public networking.
      Text `public_phydev` (default=): eth0

      First public IP for the public IPs address range.
      Text `first_public_ip` (default=): 172.20.0.51

      Number of public IPs to get
      Text `number_public_ips` (default=1): 5

      Block devices for Ceph OSD (semicolon separated list)
      Array `ceph_device` (default=/dev/sdb): /dev/sdb

      Physical device to be used for Ceph.
      Text `ceph_monitor_interface` (default=eth0): eth1

      Ceph public network in CIDR notation
      Text `ceph_public_network` (default=):
      ...
      Provision successfully created
      ID: 4

Step 3. Quick Tour of your New Cluster
--------------------------------------------------------------------------------

Let's first check the hosts are up and running, in our simple case:

.. prompt:: bash $ auto

    $ onehost list
  ID NAME                  CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   5 host03                onprem-clu   0       0 / 200 (0%)     0K / 3.8G (0%) on
   4 host02                onprem-clu   0       0 / 200 (0%)     0K / 3.8G (0%) on
   3 host01                onprem-clu   0       0 / 200 (0%)     0K / 3.8G (0%) on

Let's review relevant datastores:

.. prompt:: bash $ auto

    $ onedatastore list
      ID NAME                         SIZE  AVA CLUSTERS IMAGES TYPE DS      TM      STAT
     101 onprem-hci-cluster-system    28.3G 100% 100           0 sys  -       ceph    on
     100 onprem-hci-cluster-image     28.3G 100% 100           1 img  ceph    ceph    on


And similarly for the networks. You'll have a public network and a network template to create as many private networks as you need:

.. prompt:: bash $ auto

    $ onevnet list
  ID USER     GROUP    NAME                      CLUSTERS   BRIDGE   STATE    LEASES
   4 oneadmin oneadmin onprem-hci-cluster-public     102        onebr4   rdy           0

    $ onevntemplate list
  ID USER     GROUP    NAME                                                  REGTIME
   0 oneadmin oneadmin onprem-hci-cluster-private                         04/28 18:08:38

For example let's create a 192.168.0.100/26 network from the private network template:

.. prompt:: bash $ auto

    $ onevntemplate instantiate 0 --ip 192.168.0.100 --size 64
    VN ID: 5

Step 4. As a Simple test, Run a VM
--------------------------------------------------------------------------------

As a simple test we'll run a small VM, an Alpine Linux from the OpenNebula Public Marketplace.

.. prompt:: bash $ auto

  $ onemarketapp list | grep -i alpine
  74 Alpine Linux 3.20                       6.10.0-2-2  256M  rdy  img 05/14/24 OpenNebula    0
  51 Alpine Linux 3.17                       6.10.0-2-2  256M  rdy  img 05/14/24 OpenNebula    0
  40 Alpine Linux 3.16                       6.10.0-2-2  256M  rdy  img 02/01/24 OpenNebula    0
  27 Alpine Linux 3.19                       6.10.0-2-2  256M  rdy  img 05/14/24 OpenNebula    0
  22 Alpine Linux 3.18                       6.10.0-2-2  256M  rdy  img 05/14/24 OpenNebula    0

We'll select the newest version (ID 74 in this case) and add it to our cloud:

.. prompt:: bash $ auto

   $ onemarketapp export 74 alpine_market -d default
    IMAGE
        ID: 2
    VMTEMPLATE
        ID: 3

The VM template has been created, with ID 3.

.. prompt:: bash $ auto

   $ oneimage list
  ID USER     GROUP    NAME                       DATASTORE     SIZE TYPE PER STAT RVMS
   3 oneadmin oneadmin alpine_market              default       256M OS    No rdy     0

The final step is adding a network interface to the template just created:

.. prompt:: bash $ auto

    $ onetemplate update 3
    ...
    NIC = [ NETWORK_MODE = "auto" ]

Now we can instantiate the VM from this template:

.. prompt:: bash $ auto

    $ onetemplate instantiate 3
    VM ID:11

The VM has been instantiated with ID 11. To see information for the VM:

.. prompt:: bash $ auto

    $ onevm show 11
    VIRTUAL MACHINE 10 INFORMATION
    ID                  : 11                  
    NAME                : alpine_market-11    
    USER                : oneadmin            
    GROUP               : oneadmin            
    STATE               : ACTIVE              
    LCM_STATE           : RUNNING

    ...

    VIRTUAL MACHINE MONITORING                                                      
    CPU                 : 0.0                 
    MEMORY              : 173.7M              
    NETTX               : 14K                 
    NETRX               : 54K

    ...
    VM DISKS
     ID DATASTORE  TARGET IMAGE                               SIZE      TYPE SAVE
      0 default    vda    alpine_market                       80M/256M  file   NO
      1 -          hda    CONTEXT                             1M/-      -       -

    VM NICS
     ID NETWORK              BRIDGE       IP              MAC               PCI_ID
      0 onprem-cluster-publi onebr4       172.16.0.2      02:00:ac:10:00:02

You should now be able to connect to the VM via SSH:

.. code::

  $ ssh root@172.16.0.2
    The authenticity of host '172.16.0.2 (172.16.0.2)' can't be established.
    ED25519 key fingerprint is SHA256:Uz6WarB4k+1Sq2DI5Zz7b15p0ND7fr+kwxzIxSzr/Zg.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added '172.16.0.2' (ED25519) to the list of known hosts
    localhost:~#

Advanced: Customize the HCI Cluster
================================================================================

You can easily customize the provision of the HCI Cluster to better fit your setup. The main provision template is located at ``/usr/share/one/oneprovision/edge-clusters/onprem/provisions/onprem-hci.yml``

.. prompt:: yaml $ auto

    name: 'onprem-hci-cluster'

    description: 'On-premises hyper-convergent Ceph cluster'

    extends:
        - onprem.d/defaults.yml
        - onprem.d/resources.yml
        - onprem.d/hosts-hci.yml
        - onprem.d/datastores-hci.yml
        - onprem.d/fireedge.yml
        - onprem.d/inputs-hci.yml
        - onprem.d/networks.yml
    ...

Most of the parts should be self-explanatory, the important parts are at first,
the ``ceph_vars`` which values goes as Ansible group_vars to all ceph hosts.

.. prompt:: yaml $ auto

    ceph_vars:
      ceph_hci: true
      devices: "${input.ceph_device}"
      monitor_interface: "${input.ceph_monitor_interface}"
      public_network: "${input.ceph_public_network}"

Other important part which could be adjusted are hosts. So, instead of creating the hosts based on the values from inputs (ceph_full_hosts_names, ceph_osd_hosts_names). You can defined them on your own in file ``/usr/share/one/oneprovision/edge-clusters/onprem/provisions/onprem.d/hosts-hci.yml``

An example of such a definition is following. See that in this example you can define different devices (OSD devices) or dedicated_devices per hosts. For more details about the OSD configuration follow `OSD Scernarios <https://docs.ceph.com/projects/ceph-ansible/en/latest/osds/scenarios.html>`__

.. prompt:: yaml $ auto

    hosts:

      - im_mad: "lxc"
        vm_mad: "lxc"
        provision:
          hostname: "ceph01-host.localdomain"
          ceph_group: "osd,mon"
          devices:
            - "/dev/sdb"
            - "/dev/sdc"
          dedicated_devices:
            - "/dev/nvme1n1"
          ceph_monitor_interface: "enp4s0"

      - im_mad: "lxc"
        vm_mad: "lxc"
        provision:
          hostname: "ceph02-host.localdomain"
          ceph_group: "osd,mon"
          devices:
            - "/dev/sdc"
          dedicated_devices:
            - "/dev/nvme1n1"
          ceph_monitor_interface: "enp4s0"

      - im_mad: "lxc"
        vm_mad: "lxc"
        provision:
          hostname: "ceph03-host.localdomain"
          ceph_group: "osd,mon"
            - "/dev/sdb"
          dedicated_devices:
            - "/dev/nvme1n1"
          ceph_monitor_interface: "enp4s0"

      - im_mad: "lxc"
        vm_mad: "lxc"
        provision:
          hostname: "host04.localdomain"
          ceph_group: "clients"



Operating Providers and Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage AWS Clusters using the OneProvision GUI in Sunstone.

|image_fireedge|

.. |image_fireedge| image:: /images/oneprovision_fireedge.png
.. |image_prem_ceph| image:: /images/onprem-cluster-ceph.png
.. |image_mysql| image:: /images/onprem-nginx.png

