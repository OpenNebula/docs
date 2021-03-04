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

