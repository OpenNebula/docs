.. _aws_provider:

================================================================================
Amazon AWS Provider
================================================================================

An AWS provider contains the credentials to interact with Amazon and also the region to deploy your Provisions. OpenNebula comes with four pre-defined AWS providers in the following regions:

* Frankfurt
* London
* North Virginia (US)
* North California (US)

TODO: How to enable more zones? Why only these ones?

In order to define an AWS provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``access_key`` and ``secret_key``. You can follow `this guide <https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html>`__.
* **Region**: this is the location in the world where the resources are going to be allocated. All the available regions are `listed here <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.
* **Instance types and AMI's**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

.. warning:: Please note even though custom AMIs (i.e other than the default one) can be used, the automation tools are tailored to works with these default ones. If you use a custom AMI, please be aware that it might required some adjustments, and things might not work as expected. Avoid using them in production environment unless you've properly tested it before.

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

When you leave the ``aws_ami_image`` with `default` value then the latest Ubuntu Focal ami will be searched and used.

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/<type>/providers/aws``. You just need to enter valid credentials.

.. include:: customize.txt
