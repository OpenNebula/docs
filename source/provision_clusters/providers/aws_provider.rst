.. _aws_provider:

================================================================================
Amazon AWS Provider
================================================================================

An AWS provider contains the credentials to interact with Amazon and also the region to deploy your Provision Clusters. OpenNebula comes with four pre-defined AWS providers in the following regions:

* Frankfurt
* London
* North Virginia (US)
* North California (US)

In order to define an AWS provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``access_key`` and ``secret_key``. You can follow `this guide <https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.
* **Instance types and AMI's**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Create an AWS Provider
================================================================================

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
		 type: 'text'
		 default: 'default'
		 description: 'AWS AMI image (default = Ubuntu Focal)'
	   - name: 'aws_instance_type'
		 type: 'list'
		 default: 'c5.metal'
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

AMI Value
================================================================================

When you leave the ``aws_ami_image`` with `default` value then the latest Ubuntu Focal ami
will be searched and used. Also you can define the ami image on you own, just ensure
this ami is available in the given region.


How to Customize an Existing Provider
================================================================================

The provider information is stored in the OpenNebula database and it can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

