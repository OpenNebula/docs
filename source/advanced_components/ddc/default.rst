.. _default_ddc_templates:

============================
Cluster Provisioning Example
============================

In this section you can see how to automatically deploy a fully operational remote cluster with ``oneprovision``. This is a cluster with all the resources needed to run virtual machines, including hosts, datastores and virtual networks. You will also see some examples about how to run the virtual machine and ssh to it.

Default Templates
-----------------

OpenNebula provision currently supports two different providers:

- AWS
- Packet

For each of them, OpenNebula brings an example template, ready to use, provided by OpenNebula. These templates are located in ``/usr/share/one/oneprovision/examples``:

- example_aws.yaml
- example_packet.yaml

AWS Deployment
--------------

In this example we are going to deploy a cluster with two hosts and the rest of infrastructure resources. Virtual machines deployed in each host will be able to communicate with each other.

.. image:: /images/ddc_aws_deployment.png
    :align: center

Deployment File
###############

The deployment file provided by OpenNebula (``/usr/share/one/oneprovision/examples/example_aws.yaml``) needs some changes in order to deploy the hosts.

First of all, you need to create a provider using your AWS credentials and region:

- aws_access
- aws_secret
- aws_region

.. prompt:: bash $ auto

    $ cat aws.yaml
    ---
    name: "aws"
    connection:
        aws_access: "**********"
        aws_secret: "**********"
        aws_region: "us-east-1"

    $ oneprovider create aws.yaml
    ID: 0

In the template you have to change ``******`` by a valid key. You can find `here <https://docs.aws.amazon.com/secretsmanager/latest/userguide/tutorials_basic.html>`__ a guide about how to create those credentials.

Then you need to add the hosts you want to deploy. You have to uncomment the Ubuntu or CentOS hosts, in case of CentOS the final result would be the following:

.. code::

    hosts:
      - reserved_cpu: "100"
        im_mad: "kvm"
        vm_mad: "kvm"
        provision:
          hostname: "centos-host-1"
          ami: "ami-66a7871c"
      - reserved_cpu: "100"
        im_mad: "kvm"
        vm_mad: "kvm"
        provision:
          hostname: "centos-host-2"
          ami: "ami-66a7871c"

After doing this, we have our template ready to be deployed in AWS. You can validate the template using the command ``oneprovision validate``:

.. prompt:: bash $ auto

    $ oneprovision validate example_aws.yaml && echo OK
    OK

Deploy
######

To deploy it you just need to use the command ``oneprovision create example_aws.yaml``:

.. prompt:: bash $ auto

    $ oneprovision create example_aws.yaml
    ID: ea5a0e54-7b22-4535-9e70-de6bc197f228

.. warning:: This will take a bit, because hosts need to be allocated on AWS/Packet, configured to run hypervisor, and added into OpenNebula.

Infrastructure Validation
#########################

Once the deployment has finished, we can check that all the objects have been correctly created:

.. prompt:: bash $ auto

    $ oneprovision host list
  ID NAME               CLUSTER         ALLOCATED_CPU      ALLOCATED_MEM STAT
   5 54.167.216.3       AWSCluster      0 / -100 (0%)                  - off
   4 100.24.17.189      AWSCluster      0 / -100 (0%)                  - off

    $ oneprovision datastore list
  ID NAME               SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
 111 AWSluster-system    0M -   106           0 sys  -        ssh     on
 110 AWSCluster-image    80G 97% 106           0 img  fs      ssh     on

    $ oneprovision network list
  ID USER     GROUP    NAME                             CLUSTERS   BRIDGE   LEASES
  15 oneadmin oneadmin AWSCluster-private                    106  vxbr100        0
  14 oneadmin oneadmin AWSCluster-private-host-only-nat      106      br0        0

We can now deploy virtual machines on those hosts. You just need to download and app from the marketplace, store it in the image datastore and instantiate it:

- Export the image from the marketplace

.. prompt:: bash $ auto

    $ onemarketapp export "Alpine Linux 3.11" "Alpine" -d 110
    IMAGE
        ID: 0
    VMTEMPLATE
        ID: 0

- Update the VM template to add the virtual networks

.. prompt:: bash $ auto

    $ ontemplate update 0
    NIC = [
        NETWORK = "AWSCluster-private",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC = [
        NETWORK = "AWSCluster-private-host-only-nat",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC_DEFAULT = [
        MODEL = "virtio" ]

- Instantiate the VM template

.. prompt:: bash $ auto

    # Instantiate it
    $ onetemplate instantiate 0 -m 2

- Check ping between VMs

.. image:: /images/ddc_aws_ping.png
    :align: center

Packet Deployment
-----------------

In this example we are going to deploy a cluster with two hosts and the rest of infrastructure resources. Virtual machines deployed in each host will be able to communicate with each other and also we are going to be able to ssh them.


.. image:: /images/ddc_packet_deployment.png
    :align: center

Deployment File
###############

The deployment file provided by OpenNebula (``/usr/share/one/oneprovision/examples/example_packet.yaml``) needs some changes in order to deploy the hosts.

First of all, you need to create a provider using your Packet credentials and facility:

- packet_token
- packet_project
- facility

.. prompt:: bash $ auto

    $ cat packet.yaml
    ---
    name: "packet"
    connection:
        packet_token:   "**********"
        packet_project: "**********"
        facility:       "ams1"

    $ oneprovider create packet.yaml
    ID: 1

In the template you have to change ``******`` by a valid token. You can create one in your Packet user portal. And to get the project ID just go to project settings tab in Packet.

Then you need to add the hosts you want to deploy. You have to uncomment the Ubuntu or CentOS hosts, in case of CentOS the final result would be the following:

.. code::

    hosts:
      - reserved_cpu: "100"
        im_mad: "kvm"
        vm_mad: "kvm"
        provision:
          hostname: "centos-host"
          os: "centos_7"
      - reserved_cpu: "100"
        im_mad: "kvm"
        vm_mad: "kvm"
        provision:
          hostname: "centos-host"
          os: "centos_7"

After doing this, we have our template ready to be deployed in Packet. You can validate the template using the command ``oneprovision validate``:

.. prompt:: bash $ auto

    $ oneprovision validate example_packet.yaml && echo OK
    OK

Deploy
######

To deploy it you just need to use the command ``oneprovision create example_packet.yaml``:

.. prompt:: bash $ auto

    $ oneprovision create example_packet.yaml
    ID: fd368975-d438-4588-b311-4c6d51a48679

.. warning:: This will take a bit, because the hosts need to be configured by Ansible.

Infrastructure Validation
#########################

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
