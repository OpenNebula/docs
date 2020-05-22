.. _default_ddc_templates:

================================
Default Infrastructure Provision
================================

In this section you can see how to easily deploy a fully operational cluster with ``oneprovision``. This is a cluster with all the resources needed to deploy a Virtual Machine.
It includes the hosts, datastores and Virtual Networks.

Default Templates
-----------------

OpenNebula provision currently supports two different providers:

- AWS
- Packet

For each of them, you can find an example template, ready to use, provided by OpenNebula. These templates are located in ``/usr/share/one/oneprovision/examples``:

- **example_ec2.yaml**

.. code::

    ---

    #############################################################
    # WARNING: You need to replace ***** values with your
    # own credentials for the particular provider. You need to
    # uncomment and update list of hosts to deploy based
    # on your requirements.
    #############################################################

    # Ansible playbook to configure hosts
    playbook: "static_vxlan"

    # Provision name to use in all resources
    name: "EC2Cluster"

    # Defaults sections with information related with Packet
    defaults:
    provision:
        driver: "ec2"
        instancetype: "i3.metal"
        ec2_access: "***********************************"
        ec2_secret: "***********************************"
        region_name: "us-east-1"
        cloud_init: true

    # Hosts to be deployed in Packet and created in OpenNebula
    hosts:
    #  - reserved_cpu: "100"
    #    im_mad: "kvm"
    #    vm_mad: "kvm"
    #    provision:
    #      hostname: "centos-host"
    #      ami: "ami-66a7871c"

    #  - reserved_cpu: "100"
    #    im_mad: "kvm"
    #    vm_mad: "kvm"
    #    provision:
    #      hostname: "ubuntu-host"
    #      ami: "ami-759bc50a" # (Ubuntu 16.04)

    # Datastores to be created in OpenNebula
    datastores:
    - name: "<%= @name %>-image"
        ds_mad: "fs"
        tm_mad: "ssh"

    - name: "<%= @name %>-system"
        type: "system_ds"
        tm_mad: "ssh"

    # Network to be created in OpenNebula
    networks:
    - name: "<%= @name %>-private-host-only-nat"
        vn_mad: "dummy"
        bridge: "br0"
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only private network with NAT"
        ar:
        - ip: "192.168.150.2"
            size: "253"
            type: "IP4"

    - name: "<%= @name %>-private"
        vn_mad: "dummy"
        bridge: "vxbr100"
        mtu: "1450"
        description: "Private networking"
        ar:
        - ip: "192.168.160.2"
            size: "253"
            type: "IP4"


- **example_packet.yaml**

.. code::

    ---

    #############################################################
    # WARNING: You need to replace ***** values with your
    # own credentials for the particular provider. You need to
    # uncomment and update list of hosts to deploy based
    # on your requirements.
    #############################################################

    # Ansible playbook to configure hosts
    playbook: "static_vxlan"

    # Provision name to use in all resources
    name: "PacketCluster"

    # Defaults sections with information related with Packet
    defaults:
    provision:
        driver: "packet"
        packet_token: "**************************"
        packet_project: "************************"
        facility: "ams1"
        plan: "baremetal_0"
        os: "centos_7"
    configuration:
        iptables_masquerade_enabled: false  # NAT breaks public networking

    # Hosts to be deployed in Packet and created in OpenNebula
    hosts:
    #  - reserved_cpu: "100"
    #    im_mad: "kvm"
    #    vm_mad: "kvm"
    #    provision:
    #      hostname: "centos-host"
    #      os: "centos_7"

    #  - reserved_cpu: "100"
    #    im_mad: "kvm"
    #    vm_mad: "kvm"
    #    provision:
    #      hostname: "ubuntu-host"
    #      os: "ubuntu_18_04"

    # Datastores to be created in OpenNebula
    datastores:
    - name: "<%= @name %>-image"
        ds_mad: "fs"
        tm_mad: "ssh"

    - name: "<%= @name %>-system"
        type: "system_ds"
        tm_mad: "ssh"

    # Network to be created in OpenNebula
    networks:
    - name: "<%= @name %>-private-host-only"
        vn_mad: "dummy"
        bridge: "br0"
        description: "Host-only private network"
        gateway: "192.168.150.1"
        ar:
        - ip: "192.168.150.2"
            size: "253"
            type: "IP4"

    - name: "<%= @name %>-private"
        vn_mad: "dummy"
        bridge: "vxbr100"
        mtu: "1450"
        description: "Private networking"
        ar:
        - ip: "192.168.160.2"
            size: "253"
            type: "IP4"

    - name: "<%= @name %>-public"
        vn_mad: "alias_sdnat"
        external: "yes"
        description: "Public networking"
        ar:
        - size: "4"  # select number of public IPs
            type: "IP4"
            ipam_mad: "packet"
            packet_ip_type: "public_ipv4"
            facility: "ams1"
            packet_token: "********************************"
            packet_project: "******************************"

In the following sections you are going to see what changes are needed to deploy these templates and a graphic with the resulting infrastructure.

AWS Deployment
--------------

In this example we are going to deploy a cluster with two hosts and the rest infrastructure resources. Virtual machines deployed in each host will be able to communicate each other.

Graphic
#######

.. image:: /images/ddc_aws_deployment.png
    :align: center

Deployment File
###############

The deployment file provided by OpenNebula (``/usr/share/one/oneprovision/examples/example_ec2.yaml``) Needs some changes in order to deploy the hosts.

First of all, you need to add your AWS credentials:

- ec2_access
- ec2_secret

In the template you have to change ``******`` by a valid key. You can find `here <https://docs.aws.amazon.com/secretsmanager/latest/userguide/tutorials_basic.html>`__
a guide about how to create those credentials.

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

    $ oneprovision validate example_ec2.yaml && echo $?
    0

Deploy
######

To deploy it you just need to use the command ``oneprovision create example_ec2.yaml``:

.. prompt:: bash $ auto

    $ oneprovision create example_ec2.yaml
    ID: ea5a0e54-7b22-4535-9e70-de6bc197f228

.. warning:: This will take a bit, because the hosts need to be configured by Ansible.

Validation
##########

Once the deployment has finished, we can check that all the objects have been correctly created:

.. prompt:: bash $ auto

    $ oneprovision host list
  ID NAME                                                                                     CLUSTER         ALLOCATED_CPU      ALLOCATED_MEM PROVIDER STAT
   5 54.167.216.3                                                                             EC2Cluster      0 / -100 (0%)                  - ec2      off
   4 100.24.17.189                                                                            EC2Cluster      0 / -100 (0%)                  - ec2      off

    $ oneprovision datastore list
  ID NAME                                                                                                 SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
 111 EC2Cluster-system                                                                                      0M -   -             0 sys  -       ssh     on
 110 EC2Cluster-image                                                                                      80G 97% -             0 img  fs      ssh     on

    $ oneprovision vnet list
      ID USER     GROUP    NAME                                                                       CLUSTERS   BRIDGE                                   LEASES
  15 oneadmin oneadmin EC2Cluster-private                                                         -          vxbr100                                       0
  14 oneadmin oneadmin EC2Cluster-private-host-only-nat                                           -          br0                                           0

We can now deploy virtual machines on those hosts. You just need to download and app from the marketplace, store it in the image datastore and instantiate it.

Packet Deployment
-----------------

Graphic
#######

Deployment File
###############

Deploy
######

Validation
##########
