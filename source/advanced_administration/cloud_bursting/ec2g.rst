.. _ec2g:

==================
Amazon EC2 Driver
==================

Considerations & Limitations
============================

You should take into account the following technical considerations when using the EC2 cloud with OpenNebula:

-  There is no direct access to the dom0, so it cannot be monitored (we don't know where the VM is running on the EC2 cloud).

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with EC2.

-  By default OpenNebula will always launch m1.small instances, unless otherwise specified.

Please refer to the EC2 documentation to obtain more information about Amazon instance types and image management:

-  `General information of instances <http://aws.amazon.com/ec2/instance-types/>`__

Prerequisites
=============

-  You must have a working account for `AWS <http://aws.amazon.com/>`__ and signup for EC2 and S3 services.

-  The `aws-sdk ruby gem <https://github.com/aws/aws-sdk-ruby>`__ needs to be installed. This gem is automatically installed as part of the `installation process <ruby_runtime>`__. In case you need to deploy it manually, please take into account that v2 of the gem only works for ruby versions > 1.9.

OpenNebula Configuration
========================

Uncomment the EC2 IM and VMM drivers from ``/etc/one/oned.conf`` file in order to use the driver.

.. code::

    IM_MAD = [
        name       = "ec2",
        executable = "one_im_sh",
        arguments  = "-c -t 1 -r 0 ec2" ]
     
    VM_MAD = [
        name       = "ec2",
        executable = "one_vmm_sh",
        arguments  = "-t 15 -r 0 ec2",
        type       = "xml" ]

Driver flags are the same as other drivers:

+--------+---------------------+
| FLAG   | SETs                |
+========+=====================+
| -t     | Number of threads   |
+--------+---------------------+
| -r     | Number of retries   |
+--------+---------------------+

Additionally you must define the AWS credentials and AWS region to be used and the maximum capacity that you want OpenNebula to deploy on the EC2, for this edit the file ``/etc/one/ec2_driver.conf``:

.. code::

    regions:
        default:
            region_name: us-east-1
            access_key_id: YOUR_ACCESS_KEY
            secret_access_key: YOUR_SECRET_ACCESS_KEY
            capacity:
                m1.small: 5
                m1.large: 0
                m1.xlarge: 0

You can define an http proxy if the OpenNebula Frontend does not have access to the internet, in ``/etc/one/ec2_driver.conf``:

.. code::

    proxy_uri: http://...

After OpenNebula is restarted, create a new Host that uses the ec2 drivers:

.. code::

    $ onehost create ec2 --im ec2 --vm ec2 --net dummy

EC2 Specific Template Attributes
================================

In order to deploy an instance in EC2 through OpenNebula you must include an EC2 section in the virtual machine template. This is an example of a virtual machine template that can be deployed in our local resources or in EC2.

.. code::

    CPU      = 0.5
    MEMORY   = 128
     
    # Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    # EC2 template machine, this will be use wen submitting this VM to EC2
    EC2 = [ AMI="ami-00bafcb5",
            KEYPAIR="gsg-keypair",
            INSTANCETYPE=m1.small]
     
    #Add this if you want to use only EC2 cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "ec2"'

These are the attributes that can be used in the EC2 section of the template:

+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       ATTRIBUTES       |                                                                                                                                        DESCRIPTION                                                                                                                                         |
+========================+============================================================================================================================================================================================================================================================================================+
| ``AMI``                | Unique ID of a machine image, returned by a call to ec2-describe-images.                                                                                                                                                                                                                   |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``AKI``                | The ID of the kernel with which to launch the instance.                                                                                                                                                                                                                                    |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CLIENTTOKEN``        | Unique, case-sensitive identifier you provide to ensure idempotency of the request.                                                                                                                                                                                                        |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``INSTANCETYPE``       | Specifies the instance type.                                                                                                                                                                                                                                                               |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``KEYPAIR``            | The name of the key pair, later will be used to execute commands like *ssh -i id\_keypair* or *scp -i id\_keypair*                                                                                                                                                                         |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``LICENSEPOOL``        | –license-pool                                                                                                                                                                                                                                                                              |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BLOCKDEVICEMAPPING`` | The block device mapping for the instance. More than one can be specified in a space-separated list. Check the –block-device-mapping option of the `EC2 CLI Reference <http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-RunInstances.html>`__ for the syntax |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PLACEMENTGROUP``     | Name of the placement group.                                                                                                                                                                                                                                                               |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PRIVATEIP``          | If you're using Amazon Virtual Private Cloud, you can optionally use this parameter to assign the instance a specific available IP address from the subnet.                                                                                                                                |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``RAMDISK``            | The ID of the RAM disk to select.                                                                                                                                                                                                                                                          |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SUBNETID``           | If you're using Amazon Virtual Private Cloud, this specifies the ID of the subnet you want to launch the instance into. This parameter is also passed to the command *ec2-associate-address -i i-0041230 -a elasticip*.                                                                    |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TENANCY``            | The tenancy of the instance you want to launch.                                                                                                                                                                                                                                            |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``USERDATA``           | Specifies Base64-encoded MIME user data to be made available to the instance(s) in this reservation.                                                                                                                                                                                       |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SECURITYGROUPS``     | Name of the security group. You can specify more than one security group (comma separated).                                                                                                                                                                                                |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SECURITYGROUPIDS``   | Ids of the security group. You can specify more than one security group (comma separated).                                                                                                                                                                                                 |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ELASTICIP``          | EC2 Elastic IP address to assign to the instance. This parameter is passed to the command *ec2-associate-address -i i-0041230 elasticip*.                                                                                                                                                  |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TAGS``               | Key and optional value of the tag, separated by an equals sign ( = ).You can specify more than one tag (comma separated).                                                                                                                                                                  |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``AVAILABILITYZONE``   | The Availability Zone in which to run the instance.                                                                                                                                                                                                                                        |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``HOST``               | Defines which OpenNebula host will use this template                                                                                                                                                                                                                                       |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``EBS_OPTIMIZED``      | Obtain a better I/O throughput for VMs with EBS provisioned volumes                                                                                                                                                                                                                        |
+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Default values for all these attributes can be defined in the ``/etc/one/ec2_driver.default`` file.

.. code::

    <!--
     Default configuration attributes for the EC2 driver
     (all domains will use these values as defaults)
     Valid atributes are: AKI AMI CLIENTTOKEN INSTANCETYPE KEYPAIR LICENSEPOOL
        PLACEMENTGROUP PRIVATEIP RAMDISK SUBNETID TENANCY USERDATA SECURITYGROUPS
        AVAILABILITYZONE EBS_OPTIMIZED ELASTICIP TAGS
     Use XML syntax to specify defaults, note elements are UPCASE
     Example:
     <TEMPLATE>
       <EC2>
         <KEYPAIR>gsg-keypair</KEYPAIR>
         <INSTANCETYPE>m1.small</INSTANCETYPE>
       </EC2>
     </TEMPLATE>
    -->
     
    <TEMPLATE>
      <EC2>
        <INSTANCETYPE>m1.small</INSTANCETYPE>
      </EC2>
    </TEMPLATE>

This values can furthermore be asked to the user using :ref:`user inputs <vm_guide_user_inputs>`. A common scenario is to delegate the User Data to the end user. For that, a new User Input named USERDATA can be created of text64 (the User Data needs to be encoded on base64) and a placeholder added to the EC2 section:

.. code::
    
    EC2 = [ AMI="ami-00bafcb5",
            KEYPAIR="gsg-keypair",
            INSTANCETYPE=m1.small,
            USERDATA="$USERDATA"]

.. _ec2g_multi_ec2_site_region_account_support:

Multi EC2 Site/Region/Account Support
=====================================

It is possible to define various EC2 hosts to allow opennebula the managing of different EC2 regions or different EC2 accounts.

When you create a new host the credentials and endpoint for that host are retrieved from the ``/etc/one/ec2_driver.conf`` file using the host name. Therefore, if you want to add a new host to manage a different region, i.e. ``eu-west-1``, just add your credentials and the capacity limits to the the ``eu-west-1`` section in the conf file, and specify that name (eu-west-1) when creating the new host.

.. code::

    regions:
        ...
        eu-west-1:
            region_name: us-east-1
            access_key_id: YOUR_ACCESS_KEY
            secret_access_key: YOUR_SECRET_ACCESS_KEY
            capacity:
                m1.small: 5
                m1.large: 0
                m1.xlarge: 0

After that, create a new Host with the ``eu-west-1`` name:

.. code::

    $ onehost create eu-west-1 --im ec2 --vm ec2 --net dummy

If the Host name does not match any regions key, the ``default`` will be used.

You can define a different EC2 section in your template for each EC2 host, so with one template you can define different AMIs depending on which host it is scheduled, just include a HOST attribute in each EC2 section:

.. code::

    EC2 = [ HOST="ec2",
            AMI="ami-0022c769" ]
    EC2 = [ HOST="eu-west-1",
            AMI="ami-03324cc9" ]

You will have *ami-0022c769* launched when this VM template is sent to host *ec2* and *ami-03324cc9* whenever the VM template is sent to host *eu-west-1*.

.. warning:: If only one EC2 site is defined, the EC2 driver will deploy all EC2 templates onto it, not paying attention to the **HOST** attribute.

The availability zone inside a region, can be specified using the ``AVAILABILITYZONE`` attribute in the EC2 section of the template

Hybrid VM Templates
===================

A powerful use of cloud bursting in OpenNebula is the ability to use hybrid templates, defining a VM if OpenNebula decides to launch it locally, and also defining it if it is going to be outsourced to Amazon EC2. The idea behind this is to reference the same kind of VM even if it is incarnated by different images (the local image and the remote AMI).

An example of a hybrid template:

.. code::

    ## Local Template section
    NAME=MNyWebServer
     
    CPU=1
    MEMORY=256
     
    DISK=[IMAGE="nginx-golden"]
    NIC=[NETWORK="public"]
     
    EC2=[
      AMI="ami-xxxxx" ]

OpenNebula will use the first portion (from NAME to NIC) in the above template when the VM is scheduled to a local virtualization node, and the EC2 section when the VM is scheduled to an EC2 node (ie, when the VM is going to be launched in Amazon EC2).

Testing
=======

You must create a template file containing the information of the AMIs you want to launch. Additionally if you have an elastic IP address you want to use with your EC2 instances, you can specify it as an optional parameter.

.. code::

    CPU      = 1
    MEMORY   = 1700
     
    #Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    #EC2 template machine, this will be use wen submitting this VM to EC2
     
    EC2 = [ AMI="ami-00bafcb5",
            KEYPAIR="gsg-keypair",
            INSTANCETYPE=m1.small]
     
    #Add this if you want to use only EC2 cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "ec2"'

You only can submit and control the template using the OpenNebula interface:

.. code::

    $ onetemplate create ec2template
    $ onetemplate instantiate ec2template

Now you can monitor the state of the VM with

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K             ec2    0d 07:03

Also you can see information (like IP address) related to the amazon instance launched via the command. The attributes available are:

-  AWS\_DNS\_NAME
-  AWS\_PRIVATE\_DNS\_NAME
-  AWS\_KEY\_NAME
-  AWS\_AVAILABILITY\_ZONE
-  AWS\_PLATFORM
-  AWS\_VPC\_ID
-  AWS\_PRIVATE\_IP\_ADDRESS
-  AWS\_IP\_ADDRESS
-  AWS\_SUBNET\_ID
-  AWS\_SECURITY\_GROUPS
-  AWS\_INSTANCE\_TYPE

.. code::

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : pepe
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    RESCHED             : No
    HOST                : ec2
    CLUSTER ID          : -1
    START TIME          : 11/15 14:15:16
    END TIME            : -
    DEPLOY ID           : i-a0c5a2dd

    VIRTUAL MACHINE MONITORING
    USED MEMORY         : 0K
    NET_RX              : 0K
    NET_TX              : 0K
    USED CPU            : 0

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    VIRTUAL MACHINE HISTORY
    SEQ HOST            ACTION             DS           START        TIME     PROLOG
      0 ec2             none                0  11/15 14:15:37   2d 21h48m   0h00m00s

    USER TEMPLATE
    EC2=[
      AMI="ami-6f5f1206",
      INSTANCETYPE="m1.small",
      KEYPAIR="gsg-keypair" ]
    SCHED_REQUIREMENTS="ID=4"

    VIRTUAL MACHINE TEMPLATE
    AWS_AVAILABILITY_ZONE="us-east-1d"
    AWS_DNS_NAME="ec2-54-205-155-229.compute-1.amazonaws.com"
    AWS_INSTANCE_TYPE="m1.small"
    AWS_IP_ADDRESS="54.205.155.229"
    AWS_KEY_NAME="gsg-keypair"
    AWS_PRIVATE_DNS_NAME="ip-10-12-101-169.ec2.internal"
    AWS_PRIVATE_IP_ADDRESS="10.12.101.169"
    AWS_SECURITY_GROUPS="sg-8e45a3e7"

Scheduler Configuration
=======================

Since ec2 Hosts are treated by the scheduler like any other host, VMs will be automatically deployed in them. But you probably want to lower their priority and start using them only when the local infrastructure is full.

Configure the Priority
----------------------

The ec2 drivers return a probe with the value PRIORITY = -1. This can be used by :ref:`the scheduler <schg>`, configuring the 'fixed' policy in ``sched.conf``:

.. code::

    DEFAULT_SCHED = [
        policy = 4
    ]

The local hosts will have a priority of 0 by default, but you could set any value manually with the 'onehost/onecluster update' command.

There are two other parameters that you may want to adjust in sched.conf::

-  ``MAX_DISPATCH``: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action
-  ``MAX_HOST``: Maximum number of Virtual Machines dispatched to a given host in each scheduling action

In a scheduling cycle, when MAX\_HOST number of VMs have been deployed to a host, it is discarded for the next pending VMs.

For example, having this configuration:

-  MAX\_HOST = 1
-  MAX\_DISPATCH = 30
-  2 Hosts: 1 in the local infrastructure, and 1 using the ec2 drivers
-  2 pending VMs

The first VM will be deployed in the local host. The second VM will have also sort the local host with higher priority, but because 1 VMs was already deployed, the second VM will be launched in ec2.

A quick way to ensure that your local infrastructure will be always used before the ec2 hosts is to **set MAX\_DISPATH to the number of local hosts**.

Force a Local or Remote Deployment
----------------------------------

The ec2 drivers report the host attribute PUBLIC\_CLOUD = YES. Knowing this, you can use that attribute in your :ref:`VM requirements <template_placement_section>`.

To force a VM deployment in a local host, use:

.. code::

    SCHED_REQUIREMENTS = "!(PUBLIC_CLOUD = YES)"

To force a VM deployment in an ec2 host, use:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

Importing VMs
=============

VMs running on EC2 that were not launched through OpenNebula can be :ref:`imported in OpenNebula <import_wild_vms>`.

