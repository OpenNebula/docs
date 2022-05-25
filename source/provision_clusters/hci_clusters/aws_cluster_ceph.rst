.. _aws_cluster_ceph:

================================================================================
AWS HCI Cluster
================================================================================

AWS HCI Cluster Implementation
================================================================================

HCI Cluster Nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The HCI cluster consists of three different type of servers:

* **Full nodes**, run Ceph OSD and Monitor daemons as well as the selected hypervisor. In order to get a fault tolerant cluster a number of 3 nodes of this type is recommended.
* **OSD nodes**, run Ceph OSD daemon and the selected hypervisor.
* **Hypervisor-only nodes**, run the selected hypervisor and the Ceph client tools.

Ceph Specific AWS Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following resources are allocated to implement the Ceph cluster:

* **AWS EBS Volume**, each node running the OSD daemons include an EBS backed device to store the cluster data.
* **AWS Ceph subnet**, each instance include a dedicated interface to isolate Ceph communication. This network uses ``10.1.0.0/16`` address by default, see below.

Cluster Network Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The cluster includes two different networks:

* **Public Networking**: this is implemented using elastic IPs from AWS and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from AWS. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by AWS. There are some limits to the number of elastic IPs that can be requested; please refer to `this link <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-limit>`__ for more information.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

These networks are implemented with the following resources:

* **AWS VPC**: it creates an isolated virtual network for all the deployed resources. There are some limits in the number of VPC that can be requested by the user, please refer to `this link <https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html>`__ for more information.
* **AWS subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **AWS internet gateway**: it allows VMs to have public connectivity over Internet.
* **AWS security group**: by default all the traffic is allowed, but custom security rules can be defined by the user to allow only specific traffic to the VMs.

|image_cluster_ceph|

AWS HCI Cluster Definition
================================================================================

To create a HCI Cluster in Amazon AWS cloud you need to input the following information:

.. list-table::
    :header-rows: 1
    :widths: 35 35 200

    * - Input Name
      - Default
      - Description
    * - **number_ceph_full_hosts**
      - 3
      - Number of instances for Ceph full nodes (OSD+MON), usually 3
    * - **number_ceph_osd_hosts**
      - 0
      - Number of instances for Ceph OSD (OSD only)
    * - **number_ceph_client_hosts**
      - 0
      - Number of instances for hypervisor (Ceph client only)
    * - **ceph_disk_size**
      - 100
      - Disk size of CEPH disk volume for the OSD, in GB
    * - **aws_instance_type**
      - c5.metal
      - AWS instance type, use bare-metal instances
    * - **aws_root_size**
      - 100
      - AWS instance root volume size, in GB
    * - **aws_ami_image**
      - default
      - AWS ami image used for host deployments
    * - **number_public_ips**
      - 1
      - Number of public IPs to get from AWS for VMs
    * - **dns**
      - 1.1.1.1
      - Comma separated list of DNS servers for public network

Additionally you can fine tune some of the defaults by manually editing the provision file ``/usr/share/one/oneprovision/edge-clusters/metal/provisions/aws-hci.yml``:

.. prompt:: yaml $ auto

    # Defaults ceph options
    ceph_vars:
      ceph_hci: true
      setup_eth1: true
      devices: [ "/dev/nvme1n1" ]
      monitor_interface: "ens1"
      public_network: "10.1.0.0/16"
      ceph_disk_size: "${input.ceph_disk_size}"

OpenNebula resources
================================================================================

In OpenNebula there are following resources created

1. Cluster - containing all other resources
2. Hosts - for each AWS instance
3. Datastores - image and system Ceph datastores
4. Virtual network - for public networking
5. Virtual network template - for private networking

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage AWS Cluster using OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster_ceph| image:: /images/aws_ceph_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
