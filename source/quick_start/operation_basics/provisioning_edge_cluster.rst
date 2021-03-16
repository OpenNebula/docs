.. _first_edge_cluster:

=====================================================
Provisioning an Edge Cluster
=====================================================

FIREEDGE + SUNSTONE INTERFACE

Overview
================================================================================

* Components of an OPenNebula Edge Cluster: datastores, networks...
* Implementation in AWS: VPC, CIDR, IGW, route table..

..
    Example, needs review:
    An edge cluster in AWS consists of:
      * 2 datastores (image and system) using the SSH replica driver.
      * 1 Public Network using the elastic drivers with preallocated IPs.
      * 1 Private Network template
      * As many hosts of you selected when the provision was created.

    During the provision of the cluster all these resources and their corresponding AWS objects are created with the aid of Terraform. In particular the following AWS resources are created:
      * A virtual private cloud (VPC) to allocate the OpenNebula hosts (AWS instances)
      * A CIDR block for the AWS instances. This CIDR block is used to assign secondary IPs to the hosts to allocate elastic IPs.
      * An Internet Gateway to provide Internet access to host and VMs
      * A routing table for the previous elements.


Step 1: Requirements & Configuration
================================================================================

* Software components not installed as part of OpenNebula installation: ansible and terraform. Table with each component and version

* Additional configuration needed not part of the OpenNebula installation: ssh-provision keys (more?)

* AWS account

Step 2: Configuring AWS & Needed Information
================================================================================

* Describe how to get the information needed to create a provider
* Warning on ssh keys

Step 3: Create an AWS provider
================================================================================
* Create a virtual aws provider using one of the pre-configured templates
* Verify the creation of the provider and its characteristics

Step 4: Provision a Virtual Edge Cluster
================================================================================
* Describe inputs needed: provider (previous), number of hosts, number of IPs, hypervisor (table)
* Overview of the provision process and logs
* Verify the state of the provision and characteristics

Step 5: Validation (TENTATIVE NEEDS CHECK WITH USAGE BASICS. FROM DDC)
================================================================================

**Infrastructure Validation**

Once the deployment has finished, we can check that all the objects have been correctly created:

.. prompt:: bash $ auto

    $ oneprovision host list
    ID NAME             CLUSTER         ALLOCATED_CPU      ALLOCATED_MEM STAT
    11 147.75.80.135    PacketClus       0 / 700 (0%)     0K / 7.8G (0%) on
    10 147.75.80.151    PacketClus       0 / 700 (0%)     0K / 7.8G (0%) on

    $ oneprovision datastore list
  ID NAME                   SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
 117 PacketCluster-system     0M -   108           0 sys  -       ssh     on
 116 PacketCluster-image     80G 97% 108           0 img  fs      ssh     on

    $ oneprovision network list
  ID USER     GROUP    NAME                             CLUSTERS   BRIDGE   LEASES
  22 oneadmin oneadmin PacketCluster-public             108        onebr22       0
  21 oneadmin oneadmin PacketCluster-private            108        vxbr100       0
  20 oneadmin oneadmin PacketCluster-private-host-only  108        br0           0

We can now deploy virtual machines on those hosts. You just need to download and app from the marketplace, store it in the image datastore and instantiate it:

- Export the image from the marketplace

.. prompt:: bash $ auto

    $ onemarketapp export "Alpine Linux 3.11" "Alpine" -d 116
    IMAGE
        ID: 0
    VMTEMPLATE
        ID: 0

- Update the VM template to add the virtual networks

.. prompt:: bash $ auto

    $ ontemplate update 0
    NIC = [
        NETWORK = "PacketCluster-private",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC = [
        NETWORK = "PacketCluster-private-host-only",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC_ALIAS = [
        EXTERNAL= "YES",
        NETWORK = "PacketCluster-public",
        NETWORK_UNAME = "oneadmin",
        PARENT = "NIC1",
        SECURITY_GROUPS = "0" ]
    NIC_DEFAULT = [
        MODEL = "virtio" ]

- Instantiate the VM template

.. prompt:: bash $ auto

    $ onetemplate instantiate 0 -m 2

- Check ssh over public

.. prompt:: bash $ auto

    $ ssh root@147.75.81.25
    Warning: Permanently added '147.75.81.25' (ECDSA) to the list of known hosts.
    localhost:~# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
            valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
            valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 02:00:c0:a8:a0:03 brd ff:ff:ff:ff:ff:ff
        inet 192.168.160.3/24 scope global eth0
            valid_lft forever preferred_lft forever
        inet6 fe80::c0ff:fea8:a003/64 scope link
            valid_lft forever preferred_lft forever
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 02:00:c0:a8:96:03 brd ff:ff:ff:ff:ff:ff
        inet 192.168.150.3/24 scope global eth1
            valid_lft forever preferred_lft forever
        inet6 fe80::c0ff:fea8:9603/64 scope link
            valid_lft forever preferred_lft forever
