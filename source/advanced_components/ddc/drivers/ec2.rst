.. _ddc_driver_ec2:

=================
Amazon AWS Driver
=================

Requirements:

* AWS API credentials (access and secret key)

Supported AWS hosts:

* operating systems: CentOS 7, Ubuntu 16.04 and 18.04
* AMIs (us-east1): ``ami-66a7871c`` (CentOS 7), ``ami-759bc50a`` (Ubuntu 16.04)
* instance types: all metal instances are supported. You can check `here <https://aws.amazon.com/ec2/instance-types>`__ the available instances per region (baremetal instances are those with **.metal** suffix)

.. _ddc_driver_ec2_params:

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
``cloud_init``        NO        Generate ``cloud-init`` contextualization data if no custom ``userdata`` specified (default: ``no``). See :ref:`Cloud-init <ddc_driver_ec2_cloudinit>`.
===================== ========= ===========

and all the parameters supported by the :ref:`EC2 cloud-bursting <ec2g>` driver.

.. _ddc_driver_ec2_cloudinit:

Cloud-init
==========

`Cloud-init <http://cloudinit.readthedocs.io/>`__ is a popular tool to contextualize the cloud resources. Although OpenNebula mainly supports its own contextualization method and tools (see packages for `Linux <https://github.com/OpenNebula/addon-context-linux>`__ and `Windows <https://github.com/OpenNebula/addon-context-windows>`__), the EC2 driver can be forced to provide configuration for generic images relying on cloud-init.

The cloud-init configuration is generated if

1. explicitly enabled by the ``cloud_init`` parameter and
2. no custom ``userdata`` parameter is specified.

Parameter ``cloud_init`` allowed values:

* ``yes`` or ``true``
* ``no`` or ``false``

Supported functionality:

* provide authorized keys for default user based on the OpenNebula context keys

.. _ddc_driver_ec2_example:

Example
=======

Example of a minimal EC2 provision template:

.. code::


    ---
    name: myprovision

    defaults:
      provision:
        provider: ec2
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
