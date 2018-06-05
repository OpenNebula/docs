.. _azg:

================================================================================
Azure Driver
================================================================================

Considerations & Limitations
================================================================================

You should take into account the following technical considerations when using the Microsoft Azure (AZ) cloud with OpenNebula:

-  There is no direct access to the hypervisor, so it cannot be monitored (we don't know where the VM is running on the Azure cloud).

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with Azure.

-  By default OpenNebula will always launch Small (1 CPU, 1792 MB RAM) instances, unless otherwise specified. The following table is an excerpt of all the instance types available in Azure, a more exhaustive list can be found (and edited) in ``/etc/one/az_driver.conf``.

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
================================================================================

-  You must have a working account for `Azure <http://azure.microsoft.com/>`__.
-  You need your Azure credentials (Information on how to manage Azure certificates can be found `here <http://azure.microsoft.com/en-us/documentation/articles/linux-use-ssh-key/>`__. ). The information can be obtained from the `Management Azure page <https://manage.windowsazure.com>`__.
- First, the Subscription ID, that can be uploaded and retrieved from Settings -> Subscriptions.
- Second, the Management Certificate file, that can be created with the following steps- We need the .pem file (for the ruby gem) and the .cer file (to upload to Azure):

.. code::

    ## Install openssl

    ## CentOS
    $ sudo yum install openssl

    ## Ubuntu
    $ sudo apt-get install openssl

    # Move to a folder (wherever you prefer, it's better if you choose a private folder to store all yours keys)
    $ mkdir ~/.ssh/azure && cd ~/.ssh/azure

    ## Create certificate
    $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout myPrivateKey.key -out myCert.pem
    $ chmod 600 myPrivateKey.key

    ## Generate .cer file for Azure
    $ openssl x509 -outform der -in myCert.pem -out myCert.cer

    ## You should have now your .pem certificate and your private key
    $ find .
    ==>
        ./myCert.pem
        ./myPrivateKey.key



- Third, the certificate file (.cer) has to be uploaded to Settings -> Management Certificates can only be accessed from classic Azure portal, if you are using V2 try to:

        portal v2 home page -> Azure classic portal -> Settings -> Management Certificates

- In order to allow azure driver to properly authenticate with our Azure account, you need to sign your .pem file:

.. code::

    ## Concatenate key and pem certificate (sign with private key)
    $ cat myCert.pem myPrivateKey.key > azureOne.pem

azureOne.pem is the result of your signed cert, OpenNebula does not need you to store this cert in any certain location of the OpenNebula front-end filesystem, please keep it safe. Remember that you will need to read it in the host creation process. We'll talk about how perform this action later.

-  The following gem is required: ``azure``. This gem is automatically installed as part of the :ref:`installation process <ruby_runtime>`. Otherwise, run the ``install_gems`` script as root:

.. prompt:: bash # auto

    # /usr/share/one/install_gems cloud

OpenNebula Configuration
================================================================================

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

Azure driver has his own configuration file with a few options ready to customize, take a look inside your opennebula etc folder, edit the file ``/etc/one/az_driver.conf``:

.. code::

    proxy_uri:
    instance_types:
        ExtraSmall:
            cpu: 1
            memory: 0.768
        Small:
            cpu: 1
            memory: 1.75
        Medium:
            cpu: 2
            memory: 3.5
        Large:
            cpu: 4
            memory: 7.0
        ExtraLarge:
            cpu: 8
            memory: 14.0
        ...

In the above file, each instance_type represents the physical resources that Azure will serve.

If the OpenNebula frontend needs to use a proxy to connect to the public Internet you also need to configure the proxy in that file. The parameter is called ``proxy_uri``. Authenticated proxies are not supported, that is, the ones that require user name and password. For example, if the proxy is in ``10.0.0.1`` and its port is ``8080`` the configuration line should read:

.. code::

    proxy_uri: http://10.0.0.1:8080


.. warning:: ``instance_types`` section shows us the machines that Azure is able to provide, the azure driver will retrieve this kind of information so it's better to not change it unless you are aware of your actions.

.. warning::

    If you were using OpenNebula before 5.4 you may have noticed that there are not Microsoft credentials in configuration file anymore, this is due security reasons. In 5.4 there is a new secure credentials storage for Microsoft's accounts so you do not need to store sensitive credential data inside your disk. OpenNebula daemon stores the data in an encrypted format.


Once the file is saved, OpenNebula needs to be restarted (as ``oneadmin``, do a 'onevm restart'), create a new Host with Microsoft's credentials that uses the AZ drivers:

.. prompt:: bash $ auto

    $ onehost create azure_host -t az -i az -v az

.. note::

    ``-t`` is needed to specify what type of remote provider host we want to set up, if you've followed all the instruction properly your default editor should show in your screen asking for the credentials and other mandatory data that will allow you to communicate with Azure.

Once you have opened your editor you can look for additional help at the top of your screen, you have more information in :ref:`Azure Auth template Attributes <az_auth_attributes>` section. The basic three variables you have to set are: ``AZ_ID``, ``AZ_CERT`` and ``REGION_NAME``.


.. _azure_specific_template_attributes:

Azure Specific Template Attributes
================================================================================

In order to deploy an instance in Azure through OpenNebula you must include an PUBLIC_CLOUD section in the virtual machine template. This is an example of a virtual machine template that can be deployed in our local resources or in Azure.

.. code::

    CPU      = 0.5
    MEMORY   = 128
     
    # KVM template machine, this will be use when submitting this VM to local resources
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

Check an exhaustive list of attributes in the :ref:`Virtual Machine Definition File Reference Section <public_cloud_azure_atts>`.

.. note:: The PUBLIC_CLOUD sections allow for substitutions from template and virtual network variables, the same way as the :ref:`CONTEXT section allows <template_context>`.


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

.. note:: Valid Azure images to set in the IMAGE atribute of the PUBLIC_CLOUD section can be extracted with the following ruby snippet:


.. code::

   #!/usr/bin/env ruby

   require "azure"
   require "yaml"

   CONFIG_PATH = "/etc/one/az_driver.conf"

   # Get a list of available virtual machine images
   def get_image_names
       vm_image_management = Azure.vm_image_management
       vm_image_management.list_os_images.each do |image|
           puts "#{image.os_type}"
           puts "      locations: #{image.locations}"
           puts "      name     : #{image.name}"
           puts
       end
   end

   @account = YAML::load(File.read(CONFIG_PATH))
   _regions = @account['regions']
   _az = _regions['default']

   Azure.configure do |config|
             config.management_certificate = _az['pem_management_cert'] || ENV['AZURE_CERT']
             config.subscription_id        = _az['subscription_id'] || ENV['AZURE_SUB']
             config.management_endpoint    = _az['management_endpoint'] || ENV['AZURE_ENDPOINT']
   end

   get_image_names


.. _az_auth_attributes:

Azure Auth Attributes
--------------------------------------------------------------------------------

After successfully executing onehost create with -t option, your default editor will open. An example follows of how you can complete this area:

.. code::

    AZ_ID = "this-is-my-azure-identifier"
    AZ_CERT = "-----BEGIN CERTIFICATE-----
              xxxxxxxxxxxxxxxxxxxxxxxxxxxx
              -----END CERTIFICATE-----
              -----BEGIN PRIVATE KEY-----
              xxxxxxxxxxxxxxxxxxxxxxxxxxxx
              -----END PRIVATE KEY-----"

    REGION_NAME = "West Europe"
    CAPACITY = [
        SMALL = "3",
        MEDIUM = "1" ]

The first two attributes have the authentication info required by Azure:

- **AZ_ID**: your Microsoft Azure account identifier, found in Azure classic portal -> settings.
- **AZ_CERT**: The certificate that you signed before, in our example this file is called 'azureOne.pem' you only need to read this file one time to set this attribute and start using Azure:

.. prompt:: bash $ auto

    $ cat ~/.ssh/azure/azureOne.pem

- Copy the content into your system clipboard without any mistake selecting all the text (ctrl + Shift + c if you are under normal linux terminal).

- Paste into AZ_CERT value, make sure you are inside quotes without leaving any blankspace.


This information will be encrypted as soon as the host is created. In the host template the values of the ``AZ_ID`` and ``AZ_CERT`` attributes will be encrypted to maintain a secure way in your future communication with azure.

- **REGION_NAME**: it's the name of Azure region that your account uses to deploy machines. You can check Microsoft's site to know more about the region availability `Regions Azure page <https://azure.microsoft.com/es-es/regions/>`__.

In the example the region is set to `West Europe`.

- **CAPACITY**: This attribute sets the size and number of Azure machines that your OpenNebula host will handle, you can see ``instance_types`` section in ``azure_driver.conf`` file to know the supported names. Remember that its mandatory to capitalize the names (``Small`` => ``SMALL``).

.. _azg_multi_az_site_region_account_support:

Multi Azure Location/Account Support
================================================================================

It is possible to define various Azure hosts to allow OpenNebula the managing of different Azure locations or different Azure accounts. OpenNebula choses the datacenter in which to launch the VM in the following way:

- if the VM description contains the LOCATION attribute, then OpenNebula knows that the VM needs to be launch in this Azure location
- if the name of the host matches the region name (remember, this is the same as an Azure location), then OpenNebula knows that the VMs sent to this host needs to be launched in that Azure datacenter
- if the VM doesn't have a LOCATION attribute, and the host name doesn't match any of the defined regions, then the default region is picked.

When you create a new host the credentials and endpoint for that host are retrieved from the ``/etc/one/az_driver.conf`` file using the host name. Therefore, if you want to add a new host to manage a different datacenter, i.e. ``west-europe``, just add your credentials and the capacity limits to the the ``west-europe`` section in the conf file, and specify that name (west-europe) when creating the new host.

.. code::

    regions:
        ...
        west-europe:
            region_name: "West Europe"
            pem_management_cert: "<path-to-your-vonecloud-pem-certificate-here>"
            subscription_id: "your-subscription-id"
            management_endpoint:
            capacity:
                Small: 5
                Medium: 1
                Large: 0

After that, create a new Host with the ``west-europe`` name:

.. prompt:: bash $ auto

    $ onehost create west-europe -i az -v az

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
================================================================================

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
================================================================================

You must create a template file containing the information of the VMs you want to launch.

.. code::

    CPU      = 1
    MEMORY   = 1700
     
    # KVM template machine, this will be use when submitting this VM to local resources
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

.. prompt:: bash $ auto

    $ onetemplate create aztemplate
    $ onetemplate instantiate aztemplate

Now you can monitor the state of the VM with

.. prompt:: bash $ auto

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

.. prompt:: bash $ auto

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
================================================================================

Since Azure Hosts are treated by the scheduler like any other host, VMs will be automatically deployed in them. But you probably want to lower their priority and start using them only when the local infrastructure is full.

Configure the Priority
--------------------------------------------------------------------------------

The Azure drivers return a probe with the value PRIORITY = -1. This can be used by :ref:`the scheduler <schg>`, configuring the 'fixed' policy in ``sched.conf``:

.. code::

    DEFAULT_SCHED = [
        policy = 4
    ]

The local hosts will have a priority of 0 by default, but you could set any value manually with the 'onehost/onecluster update' command.

There are two other parameters that you may want to adjust in sched.conf:

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
--------------------------------------------------------------------------------

The Azure drivers report the host attribute PUBLIC\_CLOUD = YES. Knowing this, you can use that attribute in your :ref:`VM requirements <template_placement_section>`.

To force a VM deployment in a local host, use:

.. code::

    SCHED_REQUIREMENTS = "!(PUBLIC_CLOUD = YES)"

To force a VM deployment in a Azure host, use:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

Importing VMs
================================================================================

VMs running on Azure that were not launched through OpenNebula can be :ref:`imported in OpenNebula <import_wild_vms>`.
