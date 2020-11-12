.. _ddc_driver_aws:

=================
Amazon AWS Driver
=================

Requirements:

* AWS API credentials (access and secret key)

Supported AWS hosts:

* operating systems: CentOS 7, Ubuntu 16.04 and 18.04
* AMIs (us-east1): ``ami-66a7871c`` (CentOS 7), ``ami-759bc50a`` (Ubuntu 16.04)
* instance types: all metal instances are supported. You can check `here <https://aws.amazon.com/ec2/instance-types>`__ the available instances per region (baremetal instances are those with **.metal** suffix)

.. _ddc_driver_aws_params:

Provision parameters
====================

The following table shows base provision parameters for the AWS driver:

===================== ========= ===========
Parameter             Mandatory Description
===================== ========= ===========
``aws_access``        **YES**   AWS access key
``aws_secret``        **YES**   AWS secret key
``aws_region``        **YES**   AWS deployment's region
``instancetype``      **YES**   Type of HW plan
``ami``               **YES**   AWS image ID (operating system)
``securitygroupids``  **YES**   AWS security group IDs
``subnetid``          **YES**   AWS subnet ID
``hostname``          NO        Hostname set in the booted operating system (and on EC2 dashboard)
``userdata``          NO        Custom user data
``keypair``           NO        AWS keypair name
``tags``              NO        Host tags in the AWS inventory
``cloud_init``        NO        Generate ``cloud-init`` contextualization data if no custom ``userdata`` specified (default: ``no``). See :ref:`Cloud-init <ddc_driver_aws_cloudinit>`.
===================== ========= ===========

and all the parameters supported by the :ref:`EC2 cloud-bursting <ec2g>` driver.

.. _ddc_driver_aws_cloudinit:

Cloud-init
==========

`Cloud-init <http://cloudinit.readthedocs.io/>`__ is a popular tool to contextualize the cloud resources. Although OpenNebula mainly supports its own contextualization method and tools (see packages for `Linux <https://github.com/OpenNebula/addon-context-linux>`__ and `Windows <https://github.com/OpenNebula/addon-context-windows>`__), the AWS driver can be forced to provide configuration for generic images relying on cloud-init.

The cloud-init configuration is generated if

1. explicitly enabled by the ``cloud_init`` parameter and
2. no custom ``userdata`` parameter is specified.

Parameter ``cloud_init`` allowed values:

* ``yes`` or ``true``
* ``no`` or ``false``

Supported functionality:

* provide authorized keys for default user based on the OpenNebula context keys

.. _ddc_driver_aws_example:

Example
=======

Example of a minimal AWS provision template:

.. code::


    ---
    name: myprovision

    defaults:
      provision:
        provider: aws
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "host1"

.. _terraform_advanced:

Advanced Terraform Configuration
================================

The integration with Terraform allows you to create more resources using a single provision template file. In this section you can find the available resources
and how to create them.

Each resource that is going to be deployed has an equivalence inside OpenNebula:

- **Cluster** -> **aws_vpc**: this will create all the resources needed to set up an VPC, including the internet gateway and the route.
- **Host** -> **aws_instance**: this is the default resource created for each host defined in the template.
- **Network** -> **aws_subnet** this will create one subnet in Amazon per network defined in the provision template.

.. note:: All the templates used to create the resources can be found in ``/usr/lib/one/oneprovision/lib/terraform/providers/templates/aws``.

These resources are created by ``oneprovision`` tool and are managed automatically. You do not have to care of any Terraform file, everything is updated
by the tool.

.. important:: In order to properly manage all the resources, to delete them, you must use delete sub commands included in ``oneprovision``.

Example of a AWS provision template that creates an VPC:

.. code::

    ---
    name: 'AWS_PROVISION'

    playbook:
      - default

    defaults:
      provision:
        provider: 'aws'
        instancetype: 'i3.metal'
      connection:
        public_key: '/var/lib/one/.ssh/id_rsa.pub'
        private_key: '/var/lib/one/.ssh/id_rsa'
      configuration:
        opennebula_node_kvm_param_nested: false

    cluster:
      name: 'AWS'
      provision:
        cidr: '10.0.0.0/16'
        dest_cidr: '0.0.0.0/0'

    hosts:
      - reserved_cpu: '100'
        im_mad: 'kvm'
        vm_mad: 'kvm'
        provision:
          hostname: '${provision}-host'
          ami: 'ami-0e1ce3e0deb8896d2'

    networks:
      - name: '${provision}-vpc'
        vn_mad: 'dummy'
        bridge: 'br0'
        provision:
          sub_cidr: '10.0.1.0/24'

.. note:: Before using this template, you need to create the provider, check :ref:`this <ddc_provider>` for more information.
