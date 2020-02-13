.. _ec2g:

================================================================================
Amazon EC2 Driver
================================================================================

Considerations & Limitations
================================================================================

You should take into account the following technical considerations when using the EC2 cloud with OpenNebula:

-  There is no direct access to the hypervisor, so it cannot be monitored. (We don't know where the VM is running on the EC2 cloud.)

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with EC2.

-  By default OpenNebula will always launch m1.small instances, unless otherwise specified.

-  Monitoring of VMs in EC2 is done through CloudWatch. Only information related to the consumption of CPU and Networking (both inbound and outbound) is collected, since CloudWatch does not offer information about guest memory consumption.

Please refer to the EC2 documentation to obtain more information about Amazon instance types and image management:

-  `General information of instances <http://aws.amazon.com/ec2/instance-types/>`__

Prerequisites
================================================================================

-  You must have a working account for `AWS <http://aws.amazon.com/>`__ and signup for EC2 and S3 services.

-  The `aws-sdk ruby gem <https://github.com/aws/aws-sdk-ruby>`__ needs to be installed, version 2.5+. This gem is automatically installed as part of the :ref:`installation process <ruby_runtime>`.

OpenNebula Configuration
================================================================================

Uncomment the EC2 IM and VMM drivers from the ``/etc/one/oned.conf`` file in order to use the driver.

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

+------------+---------------------+
| FLAG       | SETs                |
+============+=====================+
| ``-t``     | Number of threads   |
+------------+---------------------+
| ``-r``     | Number of retries   |
+------------+---------------------+

.. _ec2_driver_conf:

First of all, we take a look over our ``/etc/one/ec2_driver_conf`` file:

.. code::

    proxy_uri:
    state_wait_timeout_seconds: 300
    instance_types:
        c1.medium:
        cpu: 2
        memory: 1.7
        ...


You can define an HTTP proxy if the OpenNebula Frontend does not have access to the internet:

.. code::

    proxy_uri: http://...

Also, you can modify in the same file the default 300 seconds timeout for waiting for the VM to reach the EC2 running state in case you also want to attach to the instance a elastic IP:

.. code::

    state_wait_timeout_seconds: 300

.. warning:: The ``instance_types`` section lists the machines that AWS is able to provide. The EC2 driver will retrieve this kind of information, so it's better not to change it unless you know what you are doing.

.. warning::

    If you were using OpenNebula before 5.4 you may have noticed that there are no AWS credentials in the configuration file anymore. This is for security reasons. In 5.4 there is a new secure credentials storage for AWS, so you do not need to store sensitive credential data on disk. The OpenNebula daemon stores the data in an encrypted format.

After OpenNebula is restarted, create a new Host with AWS credentials that uses the EC2 drivers:

.. prompt:: bash $ auto

    $ onehost create ec2 -t ec2 --im ec2 --vm ec2

.. note::

    ``-t`` is needed to specify what type of remote provider host we want to set up. If you've followed all the instructions properly, your default editor should appear, asking for the credentials and other mandatory data that will allow you to communicate with AWS.

Once you have opened your editor you can look for additional help at the top of the screen. There is more information in the :ref:`EC2 Specific Template Attributes <ec2_specific_template_attributes>` section. The basic three variables you have to set are: ``EC2_ACCESS``, ``EC2_SECRET`` and ``REGION_NAME``.

This can also be done by creating a template file that can be used with the creation command:

.. prompt:: bash $ auto

    $ echo 'EC2_ACCESS = "xXxXXxx"' >  ec2host.tpl
    $ echo 'EC2_SECRET = "xXXxxXx"' >> ec2host.tpl
    $ echo 'REGION_NAME= "xXXxxXx"' >> ec2host.tpl
    $ onehost create ec2 -t ec2 ec2host.tpl --im ec2 --vm ec2

.. _ec2_specific_template_attributes:

EC2-Specific Template Attributes
================================================================================

In order to deploy an instance in EC2 through OpenNebula, you must include an EC2 PUBLIC_CLOUD section in the virtual machine template. This is an example of a virtual machine template that can be deployed in local resources or in EC2.

.. code::

    CPU      = 0.5
    MEMORY   = 128
     
    # KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    # PUBLIC_CLOUD template, this will be use wen submitting this VM to EC2
    PUBLIC_CLOUD = [ TYPE="EC2",
                     AMI="ami-00bafcb5",
                     KEYPAIR="gsg-keypair",
                     INSTANCETYPE=m1.small]
     
    #Add this if you want to use only EC2 cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "ec2"'

See the exhaustive list of attributes in the :ref:`Virtual Machine Definition File Reference Section <public_cloud_amazon_ec2_atts>`.

Default values for all these attributes can be defined in the ``/etc/one/ec2_driver.default`` file.

.. code::

    <!--
     Default configuration attributes for the EC2 driver
     (all domains will use these values as defaults)
     Valid attributes are: AKI AMI CLIENTTOKEN INSTANCETYPE KEYPAIR LICENSEPOOL
        PLACEMENTGROUP PRIVATEIP RAMDISK SUBNETID TENANCY USERDATA SECURITYGROUPS
        AVAILABILITYZONE EBS_OPTIMIZED ELASTICIP TAGS
     Use XML syntax to specify defaults, note elements are UPCASE
     Example:
     <TEMPLATE>
       <PUBLIC_CLOUD>
         <KEYPAIR>gsg-keypair</KEYPAIR>
         <INSTANCETYPE>m1.small</INSTANCETYPE>
       </PUBLIC_CLOUD>
     </TEMPLATE>
    -->
     
    <TEMPLATE>
      <PUBLIC_CLOUD>
        <INSTANCETYPE>m1.small</INSTANCETYPE>
      </PUBLIC_CLOUD>
    </TEMPLATE>

.. note:: The PUBLIC_CLOUD sections allow for substitutions from template and virtual network variables, the same way as the :ref:`CONTEXT section allows <template_context>`.

These values can furthermore be requested from the user using :ref:`user inputs <vm_guide_user_inputs>`. A common scenario is to delegate the User Data to the end user. For that, a new User Input named USERDATA can be created of type ``text64`` (the User Data needs to be encoded on base64), and a placeholder added to the PUBLIC_CLOUD section:

.. code::

    PUBLIC_CLOUD = [ TYPE="EC2",
                     AMI="ami-00bafcb5",
                     KEYPAIR="gsg-keypair",
                     INSTANCETYPE=m1.small,
                     USERDATA="$USERDATA"]


.. _auth_attributes:

Auth Attributes
--------------------------------------------------------------------------------

After successfully executing ``onehost create`` with the ``-t`` option, your default editor will open. An example follows of how you can complete  the information:

.. code::

    EC2_ACCESS = "this_is_my_ec2_access_key_identifier"
    EC2_SECRET = "this_is_my_ec2_secret_key"
    REGION_NAME = "us-east-1"
    CAPACITY = [
        M1_SMALL = "3",
        M1_LARGE = "1" ]

The first two attributes have the authentication info required by AWS:

- **EC2_ACCESS**: Amazon AWS Access Key
- **EC2_SECRET**: Amazon AWS Secret Access Key

This information will be encrypted as soon as the host is created. In the host template the values of the ``EC2_ACCESS`` and ``EC2_SECRET`` attributes will be encrypted.

- **REGION_NAME**: Name of the AWS region that your account uses to deploy machines.

In the example the region is set to ```us-east-1``. You can get this information from the EC2 web console.

- **CAPACITY**: This attribute sets the size and number of EC2 machines that your OpenNebula host will handle. You can consult the ``instance_types`` section in the ``ec2_driver.conf`` file for the supported names. Dot (``.``) is not permitted: you have to change it to underscore (``_``) and capitalize the names (``m1.small`` => ``M1_SMALL``).

.. _context_ec2:

Context Support
--------------------------------------------------------------------------------

If a CONTEXT section is defined in the template, it will be available as USERDATA inside the VM and can be retrieved by running the following command:

.. prompt:: bash $ auto

    $ curl http://169.254.169.254/latest/user-data
    ONEGATE_ENDPOINT="https://onegate...
    SSH_PUBLIC_KEY="ssh-rsa ABAABeqzaC1y...

If the :ref:`Linux context packages for EC2 <kvm_contextualization>` are installed in the VM, these parameters will be used to configure the VM. See the :ref:`list of the supported parameters for EC2 <template_context>`.

For example, if you want to enable SSH access to the VM, an existing EC2 keypair name can be provided in the EC2 template section or the :ref:`SSH public key of the user <vcenter_contextualization>` can be included in the CONTEXT section of the template.

.. note:: If a value for the USERDATA attribute is provided in the EC2 section of the template, the CONTEXT section will be ignored and the value provided as USERDATA will be available instead of the CONTEXT information.

.. _ec2g_multi_ec2_site_region_account_support:

Hybrid VM Templates
================================================================================

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

OpenNebula will use the first portion (from NAME to NIC) in the above template when the VM is scheduled to a local virtualization node, and the EC2 section when the VM is scheduled to an EC2 node (i.e. when the VM is going to be launched in Amazon EC2).

Testing
================================================================================

You must create a template file containing the information on the AMIs you want to launch. Additionally, if you have an elastic IP address you want to use with your EC2 instances, you can specify it as an optional parameter.

.. code::

    CPU      = 1
    MEMORY   = 1700
     
    # KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    #EC2 template machine, this will be use wen submitting this VM to EC2
     
    PUBLIC_CLOUD = [ TYPE="EC2",
                     AMI="ami-00bafcb5",
                     KEYPAIR="gsg-keypair",
                     INSTANCETYPE=m1.small]
     
    #Add this if you want to use only EC2 cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "ec2"'

You only can submit and control the template using the OpenNebula interface:

.. prompt:: bash $ auto

    $ onetemplate create ec2template
    $ onetemplate instantiate ec2template

Now you can monitor the state of the VM with

.. prompt:: bash $ auto

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K             ec2    0d 07:03

Also you can see information (like IP addresses) related to the EC2 instance launched via the command. The attributes available are:

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

.. prompt:: bash $ auto

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
    NET_RX              : 208K
    NET_TX              : 4K
    USED CPU            : 0.2

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    VIRTUAL MACHINE HISTORY
    SEQ HOST            ACTION             DS           START        TIME     PROLOG
      0 ec2             none                0  11/15 14:15:37   2d 21h48m   0h00m00s

    USER TEMPLATE
    PUBLIC_CLOUD=[
      TYPE="EC2",
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
================================================================================

Since EC2 Hosts are treated by the scheduler like any other host, VMs will be automatically deployed in them. But you probably want to lower their priority and start using them only when the local infrastructure is full.

Configure the Priority
--------------------------------------------------------------------------------

The EC2 drivers return a probe with the value PRIORITY = -1. This can be used by :ref:`the scheduler <schg>` by configuring the 'fixed' policy in ``sched.conf``:

.. code::

    DEFAULT_SCHED = [
        policy = 4
    ]

The local hosts will have a priority of 0 by default, but you could set any value manually with the ``onehost update`` or ``onecluster update`` commands.

There are two other parameters that you may want to adjust in ``sched.conf``::

-  **MAX_DISPATCH**: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action
-  **MAX_HOST**: Maximum number of Virtual Machines dispatched to a given host in each scheduling action

In a scheduling cycle, when MAX_HOST VMs have been deployed to a host, the host is discarded for the following pending VMs.

For example, with this configuration:

-  MAX\_HOST = 1
-  MAX\_DISPATCH = 30
-  2 Hosts: 1 in the local infrastructure, and 1 using the ec2 drivers
-  2 pending VMs

the first VM will be deployed in the local host. The second VM will also sort with higher priority on the local host, but because 1 VM was already deployed, the second VM will be launched in EC2.

A quick way to ensure that your local infrastructure will be always used before the EC2 hosts is to **set MAX_DISPATCH to the number of local hosts**.

Force a Local or Remote Deployment
--------------------------------------------------------------------------------

The EC2 drivers report the host attribute PUBLIC\_CLOUD = YES. Knowing this, you can use that attribute in your :ref:`VM requirements <template_placement_section>`.

To force a VM deployment in a local host, use:

.. code::

    SCHED_REQUIREMENTS = "!(PUBLIC_CLOUD = YES)"

To force a VM deployment in an EC2 host, use:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

Importing VMs
================================================================================

VMs running on EC2 that were not launched through OpenNebula can be :ref:`imported into OpenNebula <import_wild_vms>`.

Permissions requirement
================================================================================

If the user account that is going to be used does not have full permissions, here is a table that summarizes the privileges required by the EC2 driver.

Service STS
-----------

+---------------------------------------------+-----------------------------------------------------------------------------+
|                  Privileges                 |                       Resources                                             |
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/DecodeAuthorizationMessage            | Support all resources                                                       |
+---------------------------------------------+-----------------------------------------------------------------------------+

Service EC2
-----------

+---------------------------------------------+-----------------------------------------------------------------------------+
|                  Privileges                 |                       Resources                                             |
+---------------------------------------------+-----------------------------------------------------------------------------+
| List/DescribeInstances                      | Support all resources                                                       |
+---------------------------------------------+-----------------------------------------------------------------------------+
| Read/DescribeTags                           | Support all resources                                                       |
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/AssociateAddress                      | Support all resources                                                       |
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/RunInstances                          | image, instance, key-pair, network-interface, security-group, subnet, volume|
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/StartInstances                        | image, instance, key-pair, network-interface, security-group, subnet, volume|
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/StopInstances                         | image, instance, key-pair, network-interface, security-group, subnet, volume|
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/TerminateInstances                    | image, instance, key-pair, network-interface, security-group, subnet, volume|
+---------------------------------------------+-----------------------------------------------------------------------------+
| Write/CreateTags                            | instance                                                                    |
+---------------------------------------------+-----------------------------------------------------------------------------+
