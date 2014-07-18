.. _azg:

============
Azure Driver
============

Considerations & Limitations
============================

You should take into account the following technical considerations when using the Microsoft Azure (AZ) cloud with OpenNebula:

-  There is no direct access to the hypervisor, so it cannot be monitored (we don't know where the VM is running on the Azure cloud).

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with Azure (currently).

-  By default OpenNebula will always launch Small (1 CPU, 1792 MB RAM) instances, unless otherwise specified.

+------------+--------------+-----------------+
|    Name    | CPU Capacity | Memory Capacity |
+============+==============+=================+
| ExtraSmall | 0.1 Cores    | 768 MB          |
+------------+--------------+-----------------+
| Small      | 1 Cores      | 1792 MB         |
+------------+--------------+-----------------+
| Medium     | 2 Cores      | 3584 MB         |
+------------+--------------+-----------------+
| Large      | 4 Cores      | 7168 MB         |
+------------+--------------+-----------------+
| ExtraLarge | 8 Cores      | 14336 MB        |
+------------+--------------+-----------------+
| A5         | 2 Cores      | 14336 MB        |
+------------+--------------+-----------------+
| A6         | 4 Cores      | 28672 MB        |
+------------+--------------+-----------------+
| A7         | 8 Cores      | 57344 MB        |
+------------+--------------+-----------------+
| A8         | 8 Cores      | 57344 MB        |
+------------+--------------+-----------------+
| A9         | 16 Cores     | 114688 MB       |
+------------+--------------+-----------------+

Prerequisites
=============

.. warning:: ruby >= 1.9.3 is required, and it is not packaged in all distros supported by OpenNebula. If you are running on an older supported distro (like Centos 6.x or Ubuntu 12.04) please update ruby or use `rvm <https://rvm.io/>`__ to run a newer (>= 1.9.3) version (remember to run ``install_gems`` after the ruby upgrade is done to reinstall all gems)

-  You must have a working account for `Azure <http://azure.microsoft.com/>`__
-  You need your Azure credentials (Information on how to manage Azure certificates can be found `here <http://azure.microsoft.com/en-us/documentation/articles/linux-use-ssh-key/>`__. ). The information can be obtained from the `Management Azure page <https://manage.windowsazure.com>`__:

  * First, the Subscription ID, that can be uploaded and retrieved from Settings -> Subscriptions
  * Second, the Management Certificate file, that can be uploaded and retrieved from Settings -> Management Certificates

-  The following gem is required: ``azure``. Otherwise, run the ``install_gems`` script as root:

.. code::

    # /usr/share/one/install_gems cloud

OpenNebula Configuration
========================

Uncomment the Azure AZ IM and VMM drivers from ``/etc/one/oned.conf`` file in order to use the driver.

.. code::

    IM_MAD = [
          name       = "az",
          executable = "one_im_sh",
          arguments  = "-c -t 1 -r 0 az" ]
     
    VM_MAD = [
        name       = "az",
        executable = "one_vmm_sh",
        arguments  = "-t 15 -r 0 az",
        type       = "xml" ]

Driver flags are the same as other drivers:

+------+----------------------------------------------------------------------+
| FLAG |                                 SETs                                 |
+======+======================================================================+
| -t   | Number of threads, i.e. number of actions performed at the same time |
+------+----------------------------------------------------------------------+
| -r   | Number of retries when contacting Azure service                      |
+------+----------------------------------------------------------------------+

Additionally you must define your credentials, the Azure location to be used and the maximum capacity that you want OpenNebula to deploy on Azure. In order to do this, edit the file ``/etc/one/az_driver.conf``:

.. code::

    default:
        region_name: "West Europe"
        pem_management_cert: <path-to-your-pem-certificate-here>
        subscription_id: <your-subscription-id-here>
        managment_endpoint:
        capacity:
            Small: 5
            Medium: 1
            Large: 0
    west-europe:
        region_name:  "West Europe"
        pem_management_cert: <path-to-your-pem-certificate-here>
        subscription_id: <your-subscription-id-here>
        managment_endpoint:
        capacity:
            Small: 5
            Medium: 1
            Large: 0


In the above file, each region represents an `Azure datacenter <http://matthew.sorvaag.net/2011/06/windows-azure-data-centre-locations/>`__ (Microsoft doesn't provide an official list). (see the :ref:`multi site region account section <azg_multi_az_site_region_account_support>` for more information.

Once the file is saved, OpenNebula needs to be restarted (as ``oneadmin``, do a 'onevm restart'), create a new Host that uses the AZ drivers:

.. code::

    $ onehost create west-europe -i az -v az -n dummy

Azure Specific Template Attributes
==================================

In order to deploy an instance in Azure through OpenNebula you must include an PUBLIC_CLOUD section in the virtual machine template. This is an example of a virtual machine template that can be deployed in our local resources or in Azure.

.. code::

    CPU      = 0.5
    MEMORY   = 128
     
    # Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    # Azure template machine, this will be use wen submitting this VM to Azure
    PUBLIC_CLOUD = [
      TYPE=AZURE,
      INSTANCE_TYPE=ExtraSmall,
      IMAGE=b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04-LTS-amd64-server-20140606.1-en-us-30GB,
      VM_USER="azuser",
      VM_PASSWORD="mypassword",
      WIN_RM="https",
      TCP_ENDPOINTS="80",
      SSHPORT=2222
    ]
     
    #Add this if you want this VM to only go to the West EuropeAzure cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "west-europe"'

These are the attributes that can be used in the PUBLIC_CLOUD section of the template for TYPE "AZURE":

+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        ATTRIBUTES        |                                                                                             DESCRIPTION                                                                                             |
+==========================+=====================================================================================================================================================================================================+
| ``INSTANCE_TYPE``        | Specifies the capacity of the VM in terms of CPU and memory                                                                                                                                         |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``IMAGE``                | Specifies the base OS of the VM. There are various ways to obtain the list of valid images for Azure, the simplest one is detailed `here <http://msdn.microsoft.com/library/azure/jj157191.aspx>`__ |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VM_USER``              | If the selected IMAGE is prepared for Azure provisioning, a username can be specified here to access the VM once booted                                                                             |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VM_PASSWORD``          | Password for VM_USER                                                                                                                                                                                |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``LOCATION``             | Azure datacenter where the VM will be sent. See /etc/one/az_driver.conf for possible values (under region_name)                                                                                     |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``STORAGE_ACCOUNT``      | Specify the storage account where this VM will belong                                                                                                                                               |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``WIN_RM``               | Comma-separated list of possible protocols to access this Windows VM                                                                                                                                |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CLOUD_SERVICE``        | Specifies the name of the cloud service where this VM will be linked. Defaults to "OpennebulaDefaultCloudServiceName" to                                                                            |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TCP_ENDPOINTS``        | Comma-separated list of TCP ports to be accesible from the public internet to this VM                                                                                                               |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SSHPORT``              | Port where the VMs ssh server will listen on                                                                                                                                                        |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VIRTUAL_NETWORK_NAME`` | Name of the virtual network to which this VM will be connected                                                                                                                                      |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SUBNET``               | NAme of the particular Subnet where this VM will be connected to                                                                                                                                    |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``AVAILABILITY_SET``     | Name of the availability set to which this VM will belong                                                                                                                                           |
+--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Default values for all these attributes can be defined in the ``/etc/one/az_driver.default`` file.

.. code::

    <!--
     Default configuration attributes for the Azure driver
     (all domains will use these values as defaults)
     Valid attributes are: INSTANCE_TYPE, IMAGE, VM_USER, VM_PASSWORD, LOCATION, 
     STORAGE_ACCOUNT, WIN_RM, CLOUD_SERVICE, TCP_ENDPOINTS, SSHPORT, AFFINITY_GROUP, 
     VIRTUAL_NETWORK_NAME, SUBNET and AVAILABILITY_SET
     Use XML syntax to specify defaults, note elements are UPCASE
     Example:
     <TEMPLATE>
       <AZURE>
         <LOCATION>west-europe</LOCATION>
         <INSTANCE_TYPE>Small</INSTANCE_TYPE>
         <CLOUD_SERVICE>MyDefaultCloudService</CLOUD_SERVICE>
         <IMAGE>0b11de9248dd4d87b18621318e037d37__RightImage-Ubuntu-12.04-x64-v13.4</IMAGE>
         <VM_USER>MyUser</VM_USER>
         <VM_PASSWORD>MyPassword</VM_PASSWORD>
         <STORAGE_ACCOUNT>MyStorageAccountName</STORAGE_ACCOUNT>
         <WIN_RM>http</WIN_RM>
         <CLOUD_SERVICE>MyCloudServiceName</CLOUD_SERVICE>
         <TCP_ENDPOINTS>80,3389:3390</TCP_ENDPOINTS>
         <SSHPORT>2222</SSHPORT>
         <AFFINITY_GROUP>MyAffinityGroup</AFFINITY_GROUP>
         <VIRTUAL_NETWORK_NAME>MyVirtualNetwork</VIRTUAL_NETWORK_NAME>
         <SUBNET>MySubNet<SUBNET>
         <AVAILABILITY_SET>MyAvailabilitySetName<AVAILABILITY_SET>
       </AZURE>
     </TEMPLATE>
    -->

    <TEMPLATE>
      <AZURE>
         <LOCATION>west-europe</LOCATION>
         <INSTANCE_TYPE>Small</INSTANCE_TYPE>
      </AZURE>
    </TEMPLATE>

.. _azg_multi_az_site_region_account_support:

Multi Azure Location/Account Support
====================================

It is possible to define various Azure hosts to allow OpenNebula the managing of different Azure locations or different Azure accounts. OpenNebula choses the datacenter in which to launch the VM in the following way:

- if the VM description contains the LOCATION attribute,  then OpenNebula knows that the VM  needs to be launch in this Azure location
- if the name of the host matches the region name (remember, this is the same as an Azure location), then OpenNebula knows that the VMs sent to this host needs to be launched in that Azure datacenter
- if the VM doesn't have a LOCATION attribute, and the host name doesn't match any of the defined regions, then the default region is picked.

When you create a new host the credentials and endpoint for that host are retrieved from the ``/etc/one/az_driver.conf`` file using the host name. Therefore, if you want to add a new host to manage a different datacenter, i.e. ``west-europe``, just add your credentials and the capacity limits to the the ``west-europe`` section in the conf file, and specify that name (west-europe) when creating the new host.

.. code::

    regions:
        ...
        west-europe:
            region_name: "West Europe"
            pem_management_cert: "<path-to-pem-certificate>"
            subscription_id: "your-subscription-id"
            management_endpoint:
            capacity:
                Small: 5
                Medium: 1
                Large: 0

After that, create a new Host with the ``west-europe`` name:

.. code::

    $ onehost create west-europe -i az -v az -n dummy

If the Host name does not match any regions key, the ``default`` will be used.

You can define a different Azure section in your template for each Azure host, so with one template you can define different VMs depending on which host it is scheduled, just include a LOCATION attribute in each PUBLIC_CLOUD section:

.. code::

    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Small,
                     IMAGE=b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04-LTS-amd64-server-20140606.1-en-us-30GB,
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="brazil-south"
    ]

    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Medium,
                     IMAGE=0b11de9248dd4d87b18621318e037d37__RightImage-Ubuntu-12.04-x64-v13.4,
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="west-europe"
    ]

You will have a small Ubuntu 14.04 VM launched when this VM template is sent to host *brazil-south* and a medium Ubuntu 13.04 VM launched whenever the VM template is sent to host *west-europe*.

.. warning:: If only one Azure host is defined, the Azure driver will deploy all Azure templates onto it, not paying attention to the **LOCATION** attribute.

Hybrid VM Templates
===================

A powerful use of cloud bursting in OpenNebula is the ability to use hybrid templates, defining a VM if OpenNebula decides to launch it locally, and also defining it if it is going to be outsourced to Azure. The idea behind this is to reference the same kind of VM even if it is incarnated by different images (the local image and the Azure image).

An example of a hybrid template:

.. code::

    ## Local Template section
    NAME=MNyWebServer
     
    CPU=1
    MEMORY=256
     
    DISK=[IMAGE="nginx-golden"]
    NIC=[NETWORK="public"]
     
    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Medium,
                     IMAGE=0b11de9248dd4d87b18621318e037d37__RightImage-Ubuntu-12.04-x64-v13.4,
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="west-europe"
    ]

OpenNebula will use the first portion (from NAME to NIC) in the above template when the VM is scheduled to a local virtualization node, and the PUBLIC_CLOUD section of TYPE="AZURE" when the VM is scheduled to an Azure node (ie, when the VM is going to be launched in Azure).

Testing
=======

You must create a template file containing the information of the VMs you want to launch.

.. code::

    CPU      = 1
    MEMORY   = 1700
     
    # Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    # Azure template machine, this will be use when submitting this VM to Azure
     
    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Medium,
                     IMAGE=0b11de9248dd4d87b18621318e037d37__RightImage-Ubuntu-12.04-x64-v13.4,
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="west-europe"
    ]
     
    # Add this if you want to use only Azure cloud
    #SCHED_REQUIREMENTS = 'HYPERVISOR = "AZURE"'

You can submit and control the template using the OpenNebula interface:

.. code::

    $ onetemplate create aztemplate
    $ ontemplate instantiate aztemplate

Now you can monitor the state of the VM with

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K     west-europe    0d 07:03

Also you can see information (like IP address) related to the Azure instance launched via the command. The attributes available are:

-  AZ_AVAILABILITY_SET_NAME
-  AZ_CLOUD_SERVICE_NAME,
-  AZ_DATA_DISKS,
-  AZ_DEPLOYMENT_NAME,
-  AZ_DISK_NAME,
-  AZ_HOSTNAME,
-  AZ_IMAGE,
-  AZ_IPADDRESS,
-  AZ_MEDIA_LINK,
-  AZ_OS_TYPE,
-  AZ_ROLE_SIZE,
-  AZ_TCP_ENDPOINTS,
-  AZ_UDP_ENDPOINTS,
-  AZ_VIRTUAL_NETWORK_NAME

.. code::

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : one-0
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    RESCHED             : No
    START TIME          : 06/25 13:05:29
    END TIME            : -
    HOST                : west-europe
    CLUSTER ID          : -1
    DEPLOY ID           : one-0_opennebuladefaultcloudservicename-0


    VIRTUAL MACHINE MONITORING
    USED MEMORY         : 0K
    USED CPU            : 0
    NET_TX              : 0K
    NET_RX              : 0K

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    VIRTUAL MACHINE HISTORY
    SEQ HOST            ACTION             DS           START        TIME     PROLOG
      0 west-europe     none               -1  06/25 13:06:25   0d 00h06m   0h00m00s


    USER TEMPLATE
    PUBLIC_CLOUD=[
      IMAGE="b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04-LTS-amd64-server-20140606.1-en-us-30GB",
      INSTANCE_TYPE="ExtraSmall",
      SSH_PORT="2222",
      TCP_ENDPOINTS="80",
      TYPE="AZURE",
      VM_PASSWORD="MyVMPassword",
      VM_USER="MyUserName",
      WIN_RM="https" ]
    VIRTUAL MACHINE TEMPLATE
    AUTOMATIC_REQUIREMENTS="!(PUBLIC_CLOUD = YES) | (PUBLIC_CLOUD = YES & (HYPERVISOR = AZURE | HYPERVISOR = AZURE))"
    AZ_CLOUD_SERVICE_NAME="opennebuladefaultcloudservicename-0"
    AZ_DEPLOYMENT_NAME="OpenNebulaDefaultCloudServiceName-0"
    AZ_DISK_NAME="OpenNebulaDefaultCloudServiceName-0-one-0_OpenNebulaDefaultCloudServiceName-0-0-201406251107210062"
    AZ_HOSTNAME="ubuntu"
    AZ_IMAGE="b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04-LTS-amd64-server-20140606.1-en-us-30GB"
    AZ_IPADDRESS="191.233.70.93"
    AZ_MEDIA_LINK="http://one0opennebuladefaultclo.blob.core.windows.net/vhds/disk_2014_06_25_13_07.vhd"
    AZ_OS_TYPE="Linux"
    AZ_ROLE_SIZE="ExtraSmall"
    AZ_TCP_ENDPOINTS="name=SSH,vip=23.97.101.202,publicport=2222,local_port=22,local_port=tcp;name=TCP-PORT-80,vip=23.97.101.202,publicport=80,local_port=80,local_port=tcp"
    CPU="1"
    MEMORY="1024"
    VMID="0"

Scheduler Configuration
=======================

Since Azure Hosts are treated by the scheduler like any other host, VMs will be automatically deployed in them. But you probably want to lower their priority and start using them only when the local infrastructure is full.

Configure the Priority
----------------------

The Azure drivers return a probe with the value PRIORITY = -1. This can be used by :ref:`the scheduler <schg>`, configuring the 'fixed' policy in ``sched.conf``:

.. code::

    DEFAULT_SCHED = [
        policy = 4
    ]

The local hosts will have a priority of 0 by default, but you could set any value manually with the 'onehost/onecluster update' command.

There are two other parameters that you may want to adjust in sched.conf::

-  MAX_DISPATCH: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action
-  MAX_HOST: Maximum number of Virtual Machines dispatched to a given host in each scheduling action

In a scheduling cycle, when MAX\_HOST number of VMs have been deployed to a host, it is discarded for the next pending VMs.

For example, having this configuration:

-  MAX\_HOST = 1
-  MAX\_DISPATCH = 30
-  2 Hosts: 1 in the local infrastructure, and 1 using the Azure drivers
-  2 pending VMs

The first VM will be deployed in the local host. The second VM will have also sort the local host with higher priority, but because 1 VMs was already deployed, the second VM will be launched in Azure.

A quick way to ensure that your local infrastructure will be always used before the Azure hosts is to **set MAX\_DISPATH to the number of local hosts**.

Force a Local or Remote Deployment
----------------------------------

The Azure drivers report the host attribute PUBLIC\_CLOUD = YES. Knowing this, you can use that attribute in your :ref:`VM requirements <template_placement_section>`.

To force a VM deployment in a local host, use:

.. code::

    SCHED_REQUIREMENTS = "!(PUBLIC_CLOUD = YES)"

To force a VM deployment in a Azure host, use:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

