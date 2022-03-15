.. _aws_cluster:

================
AWS Edge Cluster
================

.. include:: cluster_hypervisor.txt

AWS Providers
================================================================================

An AWS provider contains the credentials to interact with Amazon and also the region to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Frankfurt
* London
* North Virginia (US)
* North California (US)

In order to define an AWS provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``access_key`` and ``secret_key``. You can follow `this guide <https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.
* **Instance types and AMI's**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Add a New AWS Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a new provider you need a YAML template file with the following information:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'aws-frankfurt'

    description: 'Edge cluster in AWS Frankfurt'
    provider: 'aws'

    connection:
      access_key: 'AWS access key'
      secret_key: 'AWS secret key'
      region: 'eu-central-1'

    inputs:
      - name: 'aws_ami_image'
        type: 'list'
        options:
          - 'ami-04c21037b3f953d37'
      - name: 'aws_instance_type'
        type: 'list'
        options:
          - 'c5.metal'
          - 'i3.metal'
          - 'm5.metal'
          - 'r5.metal'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/<type>/providers/aws``. You just need to enter valid credentials.

.. _ami_change:

AMI ID Change
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It can happen that the AMI ID changes when there is a new release of the operating system. If this happens you will get an error like:

.. prompt:: bash $ auto

    The image id '[ami-04505e74c0741db8d]' does not exist

You can check the new AMI ID `here <https://cloud-images.ubuntu.com/locator/ec2/>`__. And then, there are two possible situations:

- You have already created a provider: you need to perform ``oneprovider update`` in order to change the value.
- You haven't created the provider yet: you need to edit the specific file at ``/usr/share/one/oneprovision/edge-clusters/<metal|metal>/providers/aws``.

How to Customize an Existing Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The provider information is stored in the OpenNebula database and it can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

AWS Edge Cluster Implementation
================================================================================

An Edge Cluster in AWS creates the following resources:

* **AWS instance**: Host to run virtual machines.
* **AWS VPC**: it creates an isolated virtual network for all the deployed resources. There are some limits in the number of VPC that can be requested by the user, please refer to `this link <https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html>`__ for more information.
* **AWS subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **AWS internet gateway**: it allows VMs to have public connectivity over Internet.
* **AWS security group**: by default all the traffic is allowed, but custom security rules can be defined by the user to allow only specific traffic to the VMs.

The network model is implemented in the following way:

* **Public Networking**: this is implemeted using elastic IPs from AWS and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from AWS. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by AWS. There are some limits to the number of elastic IPs that can be requested; please refer to `this link <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-limit>`__ for more information.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage AWS Cluster using OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/aws_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
