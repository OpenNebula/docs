.. _aws_cluster_ceph:

==========================
AWS Edge Cluster with Ceph
==========================

You can run the following hypervisors in the cluster:

* **KVM**, runs virtual machines. This hypervisor can be only used with metal clusters.
* **LXC**, runs system containers.

.. include:: aws_provider.txt

AWS Edge Cluster Implementation
================================================================================

An Edge Cluster in AWS creates the following resources:

* **AWS instance**: Host to run virtual machines.
* **AWS VPC**: it creates an isolated virtual network for all the deployed resources. There are some limits in the number of VPC that can be requested by the user, please refer to `this link <https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html>`__ for more information.
* **AWS subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **AWS subnet for Ceph**: to isolate Ceph communication
* **AWS internet gateway**: it allows VMs to have public connectivity over Internet.
* **AWS security group**: by default all the traffic is allowed, but custom security rules can be defined by the user to allow only specific traffic to the VMs.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from AWS and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from AWS. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by AWS. There are some limits to the number of elastic IPs that can be requested; please refer to `this link <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-limit>`__ for more information.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster_ceph|

OpenNebula resources
================================================================================
In OpenNebula there are following resources created

1. Cluster - containing all other resources
2. Hosts - for each AWS instance
3. Datastores - image + system Ceph datastores
4. Virtual network - for public networking
5. Virtual network template - for private networking


Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage AWS Cluster using OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster_ceph| image:: /images/aws_ceph_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
