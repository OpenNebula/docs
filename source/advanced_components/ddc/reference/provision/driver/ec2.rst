.. _ddc_provision_driver_ec2:

=================
Amazon EC2 Driver
=================

Requirements:

* AWS API credentials (access and secret key)

Supported EC2 hosts:

* operating systems: CentOS 7, Ubuntu 16.04 and 18.04
* AMIs (us-east1): ``ami-66a7871c`` (CentOS 7), ``ami-759bc50a`` (Ubuntu 16.04)
* instance types: ``i3.metal``

.. _ddc_driver_ec2_params:

Provision parameters
====================

The following table shows base provision parameters for the EC2 driver:

===================== ========= ===========
Parameter             Mandatory Description
===================== ========= ===========
``ec2_access``        **YES**   AWS access key
``ec2_secret``        **YES**   AWS secret key
``region_name``       **YES**   AWS deployment's region
``instancetype``      **YES**   Type of HW plan
``ami``               **YES**   AWS image ID (operating system)
``securitygroupids``  **YES**   AWS security group IDs
``subnetid``          **YES**   AWS subnet ID
``hostname``          NO        Hostname set in the booted operating system (and on EC2 dashboard)
``userdata``          NO        Custom user data
``keypair``           NO        EC2 keypair name
``tags``              NO        Host tags in the EC2 inventory
``cloud_init``        NO        Generate ``cloud-init`` contextualization data if no custom ``userdata`` specified (default: ``no``). See :ref:`Cloud-init <ddc_driver_ec2_cloudinit>`.
===================== ========= ===========

and, all the parameters supported by the :ref:`EC2 cloud-bursting <ec2g>` driver.

.. _ddc_driver_ec2_cloudinit:

Cloud-init
==========

`Cloud-init <http://cloudinit.readthedocs.io/>`__ is a popular tool to contextualize the cloud resources. Although the OpenNebula mainly supports own contextualization method and tools (see packages for `Linux <https://github.com/OpenNebula/addon-context-linux>`__ and `Windows <https://github.com/OpenNebula/addon-context-windows>`__), the EC2 driver can be forced to provide configuration for generic images relying on the cloud-init.

The cloud-init configuration is generated if

1. explicitly enabled by ``cloud_init`` parameter and
2. no custom ``userdata`` parameter is specified.

Parameter ``cloud_init`` allowed values:

* ``yes`` or ``true``
* ``no`` or ``false``

Supported functionality:

* provide authorized keys for default user based on the OpenNebula context keys

.. _ddc_driver_ec2_example:

Example
=======

Example of minimal EC2 provision template:

.. code::


    ---
    version: 2
    name: myprovision

    defaults:
      provision:
        driver: ec2
        ec2_access: *********************
        ec2_secret: ****************************************
        region_name: "us-east-1"
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
