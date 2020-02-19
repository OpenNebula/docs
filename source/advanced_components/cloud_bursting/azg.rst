.. _azg:

================================================================================
Azure Driver
================================================================================

Considerations & Limitations
================================================================================

You should take into account the following technical considerations when using the Microsoft Azure (AZ) cloud with OpenNebula:

-  There is no direct access to the hypervisor, so it cannot be monitored. (We don't know where the VM is running on the Azure cloud.)

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with Azure.

-  By default, OpenNebula will always launch `Standard_B1ls` (1 CPU, 512 MB RAM) instances, unless otherwise specified. The following table is an excerpt from all the instance types available in Azure. A more exhaustive list can be found (and edited) in ``/etc/one/az_driver.conf``.

+-----------------+--------------+-----------------+
|    Name         | CPU Capacity | Memory Capacity |
+=================+==============+=================+
| Standard_B1ls1  | 1 Core       | 0.5 GB          |
+-----------------+--------------+-----------------+
| Standard_B1ms   | 1 Core       | 2 GB            |
+-----------------+--------------+-----------------+
| Standard_B1s    | 1 Core       | 1 GB            |
+-----------------+--------------+-----------------+
| Standard_B2ms   | 2 Cores      | 8 GB            |
+-----------------+--------------+-----------------+
| Standard_B2s    | 2 Cores      | 4 GB            |
+-----------------+--------------+-----------------+
| Standard_B4ms   | 4 Cores      | 16 GB           |
+-----------------+--------------+-----------------+
| Standard_B8ms   | 8 Cores      | 32 GB           |
+-----------------+--------------+-----------------+
| Standard_B12ms  | 12 Cores     | 48 GB           |
+-----------------+--------------+-----------------+
| Standard_B16ms  | 16 Cores     | 64 GB           |
+-----------------+--------------+-----------------+
| Standard_B20ms  | 20 Cores     | 80 GB           |
+-----------------+--------------+-----------------+

Prerequisites
================================================================================

- You must have a working account for `Azure <https://portal.azure.com/>`__.
- First, you need the Subscription ID, that can be uploaded and retrieved from All services -> Subscriptions.
- Second, you need Client ID, Client secret and Tenant ID. To get those you need to register an application
  in the Azure Active Directory. Follow the Azure documentation
  `Create an Azure AD application <https://docs.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal>`__.
-  The following gems are required: `azure_mgmt_compute`, `azure_mgmt_monitor`, `azure_mgmt_network`, `azure_mgmt_resources`, `azure_mgmt_storage`

These gems are automatically installed as part of the :ref:`installation process <ruby_runtime>`. Otherwise, run the ``install_gems`` script as root:

.. prompt:: bash # auto

    # /usr/share/one/install_gems cloud

OpenNebula Configuration
================================================================================

Uncomment the Azure AZ IM and VMM drivers from the ``/etc/one/oned.conf`` file in order to use the driver.

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

+----------+----------------------------------------------------------------------+
| FLAG     |                                 SETs                                 |
+==========+======================================================================+
| ``-t``   | Number of threads, i.e. number of actions performed at the same time |
+----------+----------------------------------------------------------------------+
| ``-r``   | Number of retries when contacting Azure service                      |
+----------+----------------------------------------------------------------------+

The Azure driver has its own configuration file with a few options ready to customize. Edit ``/etc/one/az_driver.conf``:

.. code::

    proxy_uri:
    rgroup_name_format: one-%<NAME>s-%<ID>s
    instance_types:
        Standard_B1ls:
            memory: 0.5
            cpu: 1
        Standard_B1ms:
            memory: 2.0
            cpu: 1
        Standard_B1s:
            memory: 1.0
            cpu: 1
        Standard_B2ms:
            memory: 8.0
            cpu: 2
        Standard_B2s:
            memory: 4.0
            cpu: 2
        ...

In the above file, each ``instance_type`` represents the physical resources that Azure will serve.

If the OpenNebula frontend needs to use a proxy to connect to the public Internet you also need to configure the proxy in that file. The parameter is called ``proxy_uri``. Authenticated proxies are not supported, that is ones that require user name and password. For example, if the proxy is on ``10.0.0.1`` and its port is ``8080`` the configuration line should read:

.. code::

    proxy_uri: http://10.0.0.1:8080

If you don't specify the Azure Resource Group explicitly in the HOST template then the ``rgroup_name_format`` is taken into account and the Azure Resource Group name will be derived from the OpenNebula Azure host values (name and id).


.. warning:: The ``instance_types`` section lists the machines that Azure is able to provide. The Azure driver will retrieve this kind of information, so it's better not to change it unless you know what you are doing.

.. warning::

    If you were using OpenNebula before 5.4 you may have noticed that there are no Microsoft credentials in the configuration file anymore. This is for security reasons. In 5.4 there is a new secure credentials storage for Microsoft accounts, so you do not need to store sensitive credential data on disk. The OpenNebula daemon stores the data in an encrypted format.


Once the file is saved, OpenNebula needs to be restarted. Create a new Host with Microsoft credentials that uses the AZ drivers:

.. prompt:: bash $ auto

    $ onehost create azure_host -t az -i az -v az

.. note::

    ``-t`` is needed to specify what type of remote provider host we want to set up. If you've followed all the instructions properly, your default editor should appear, asking for the credentials and other mandatory data that will allow you to communicate with Azure.

Once you have opened your editor you can look for additional help at the top of your screen. There is more information in the :ref:`Azure Auth template Attributes <az_auth_attributes>` section. The basic five variables you have to set are: ``AZ_SUB``, ``AZ_CLIENT``, ``AZ_SECRET``, ``AZ_TENANT`` and ``AZ_REGION``.


.. _azure_specific_template_attributes:

Azure Specific Template Attributes
================================================================================

In order to deploy an instance in Azure through OpenNebula, you must include an Azure PUBLIC_CLOUD section in the virtual machine template. This is an example of a virtual machine template that can be deployed in our local resources or in Azure.

.. code::

    CPU      = 0.5
    MEMORY   = 128

    # KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]

    # Azure template machine, this will be use when submitting this VM to Azure

    PUBLIC_CLOUD = [
      INSTANCE_TYPE="Standard_B1s",
      IMAGE_OFFER="UbuntuServer",
      IMAGE_PUBLISHER="canonical",
      IMAGE_SKU="16.04.0-LTS",
      IMAGE_VERSION="latest",
      PUBLIC_IP="YES",
      TYPE="AZURE",
      VM_USER="MyUserName"
      VM_PASSWORD="myr@nd0mPass9",
    ]

    #Add this if you want this VM to only go to the West EuropeAzure cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "westeurope"'

These are the attributes that can be used in the PUBLIC_CLOUD section of the template for TYPE "AZURE", There is an exhaustive list of attributes in the :ref:`Virtual Machine Definition File Reference Section <public_cloud_azure_atts>`.

.. note:: The PUBLIC_CLOUD sections allow for substitutions from a template and virtual network variables, the same way as the :ref:`CONTEXT section allows <template_context>`.


Default values for all these attributes can be defined in the ``/etc/one/az_driver.default`` file.

.. code::

    <!--
     Default configuration attributes for the Azure driver
     (all domains will use these values as defaults)
     Valid attributes are: LOCATION, INSTANCE_TYPE, IMAGE_PUBLISHER, IMAGE_OFFER,
     IMAGE_SKU, IMAGE_VERSION, VM_USER, VM_PASSWORD, VIRTUAL_NETWORK_NAME,
     PUBLIC_IP, VNET_NAME, VNET_ADDR_PREFIX, VNET_DNS, VNET_SUBNAME,
     VNET_SUB_PREFIX,
     Use XML syntax to specify defaults, note elements are UPCASE
     Example:
     <TEMPLATE>
       <AZURE>
         <LOCATION>westeurope</LOCATION>
         <INSTANCE_TYPE>Standard_B1ls</INSTANCE_TYPE>
         <IMAGE_PUBLISHER>canonical</IMAGE_PUBLISHER>
         <IMAGE_OFFER>UbuntuServer</IMAGE_OFFER>
         <IMAGE_SKU>16.04.0-LTS</IMAGE_SKU>
         <IMAGE_VERSION>latest</IMAGE_VERSION>
         <VM_USER>one</VM_USER>
         <VM_PASSWORD>Q2ejfz$Cbzf</VM_PASSWORD>
         <VIRTUAL_NETWORK_NAME></VIRTUAL_NETWORK_NAME>
         <PUBLIC_IP>YES</PUBLIC_IP>
         <VNET_NAME>one-vnet</VNET_NAME>
         <VNET_ADDR_PREFIX>10.0.0.0/16</VNET_ADDR_PREFIX>
         <VNET_DNS>8.8.8.8</VNET_DNS>
         <VNET_SUBNAME>default</VNET_SUBNAME>
         <VNET_SUB_PREFIX>10.0.0.0/24</VNET_SUB_PREFIX>
       </AZURE>
     </TEMPLATE>
    -->

    <TEMPLATE>
      <AZURE>
         <LOCATION>westeurope</LOCATION>
         <INSTANCE_TYPE>Standard_B1ls</INSTANCE_TYPE>
      </AZURE>
    </TEMPLATE>


.. _az_auth_attributes:

Azure Auth Attributes
--------------------------------------------------------------------------------

After successfully executing ``onehost create`` with the ``-t`` option, your default editor will open. An example follows of how you can complete  the information:

.. code::

    AZ_SUB    = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    AZ_CLIENT = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    AZ_SECRET = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    AZ_TENANT = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    AZ_REGION = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"

    CAPACITY=[
      STANDARD_B1LS =<number of machines Standard_B1ls>,
      STANDARD_A1_V2=<number of machines Standard_A1_v2>
    ]

    Optional AZURE ATTRIBUTES:

    AZ_RGROUP = ""
    AZ_RGROUP_KEEP_EMPTY = ""


+--------------------------+------------------------------------------------------------------------------------------------------+
|  **AZ_SUB**              | Your Microsoft Azure subscription identifier, found in All services -> Subscriptions.                |
+--------------------------+------------------------------------------------------------------------------------------------------+
|  **AZ_CLIENT**,          | For those parameters you need to register an application in AzureActive Directory.                   |
|  **AZ_SECRET**,          | Follow the Azure documentation `Create an Azure AD application                                       |
|  **AZ_TENANT**           | <https://docs.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal>`__.|
|                          | In the host template the values of the ``AZ_SUB``, ``AZ_CLIENT``, ``AZ_SECRET`` and ``AZ_TENANT``    |
|                          | attributes will be encrypted to maintain your future communication with Azure securely.              |
+--------------------------+------------------------------------------------------------------------------------------------------+
| **AZ_REGION**            | The name of the Azure region that your account uses to deploy machines. You can check Microsoft's    |
|                          | `Regions Azure page <https://azure.microsoft.com/global-infrastructure/regions/>`__ to find more     |
|                          | about the region availability.                                                                       |
+--------------------------+------------------------------------------------------------------------------------------------------+
| **AZ_RGROUP**            | Name of the Azure Resource Group, which will be created on Azure. If not specified then it will      |
|                          | be derived from the name of the host and the format string specified in the                          |
|                          | ``/etc/one/az_driver.conf``.                                                                         |
+--------------------------+------------------------------------------------------------------------------------------------------+
| **AZ_RGROUP_KEEP_EMPTY** | If set to ``YES`` then even if the last VM if deleted in this Resource Group it will remain          |
|                          | in the Azure. This is useful when you have pre-defined resources in the Azure (like Resource group,  |
|                          | Virtual networks etc) and want them to use it by OpenNebula Azure driver.                            |
+--------------------------+------------------------------------------------------------------------------------------------------+
| **CAPACITY**             | This attribute sets the size and number of Azure machines that your OpenNebula host will handle.     |
|                          | See the ``instance_types`` section in the ``azure_driver.conf`` file for the supported names.        |
|                          | Remember that it is mandatory to capitalize the names (``STANDARD_B1ls`` => ``STANDARD_B1LS``)       |
+--------------------------+------------------------------------------------------------------------------------------------------+

.. _azg_multi_az_site_region_account_support:

Multi Azure Location/Account Support
================================================================================

It is possible to define various Azure hosts to allow OpenNebula to manage different Azure locations or different Azure accounts. OpenNebula chooses the datacenter in which to launch the VM in the following way:

- If the VM description contains the LOCATION attribute, then OpenNebula knows that the VM needs to be launched in this Azure location.
- If the name of the host matches the region name (remember, this is the same as an Azure location), then OpenNebula knows that the VMs sent to this host need to be launched in that Azure datacenter.
- If the VM doesn't have a LOCATION attribute, and the host name doesn't match any of the defined regions, then the default region is picked.


You can define a different Azure section in your template for each Azure host, so with one template you can define different VMs depending on which host it is scheduled. Just include a LOCATION attribute in each PUBLIC_CLOUD section:

.. code::

    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Standard_B1ls,
                     IMAGE_PUBLISHER=canonical,
                     IMAGE_OFFER=UbuntuServer,
                     IMAGE_SKU=16.04.0-LTS,
                     IMAGE_VERSION=latest
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="brazilsouth"
    ]

    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Standard_B2s,
                     IMAGE_PUBLISHER=canonical,
                     IMAGE_OFFER=UbuntuServer,
                     IMAGE_SKU=16.04.0-LTS,
                     IMAGE_VERSION=latest
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="westeurope"
    ]

You will have a Standard_B1ls Ubuntu 16.04 VM launched when this VM template is sent to host *brazilsouth* and a Standard_B2s Ubuntu 16.04 VM launched whenever the VM template is sent to host *westeurope*.

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
                     INSTANCE_TYPE=Standard_B2s,
                     IMAGE_PUBLISHER=canonical,
                     IMAGE_OFFER=UbuntuServer,
                     IMAGE_SKU=16.04.0-LTS,
                     IMAGE_VERSION=latest
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="westeurope"
    ]

OpenNebula will use the first portion (from NAME to NIC) in the above template when the VM is scheduled to a local virtualization node, and the PUBLIC_CLOUD section of TYPE="AZURE" when the VM is scheduled to an Azure node (i.e. when the VM is going to be launched in Azure).

Testing
================================================================================

You must create a template file containing the information of the VMs you want to launch.

.. code::

    CPU      = 1
    MEMORY   = 1700

    # KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]

    # Azure template machine, this will be used when submitting this VM to Azure

    PUBLIC_CLOUD = [ TYPE=AZURE,
                     INSTANCE_TYPE=Standard_B2s,
                     IMAGE_PUBLISHER=canonical,
                     IMAGE_OFFER=UbuntuServer,
                     IMAGE_SKU=16.04.0-LTS,
                     IMAGE_VERSION=latest
                     VM_USER="MyUserName",
                     VM_PASSWORD="MyPassword",
                     LOCATION="westeurope"
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


Also, you can see information (like IP address) related to the Azure instance launched via the command ``onevm show 0``. The attributes available are:

-   AZ_HARDWARE_PROFILE_VM_SIZE
-   AZ_ID
-   AZ_IPADDRESS
-   AZ_LOCATION
-   AZ_NAME
-   AZ_OS_PROFILE_ADMIN_USERNAME
-   AZ_OS_PROFILE_COMPUTER_NAME
-   AZ_PROVISIONING_STATE
-   AZ_STORAGE_PROFILE_IMAGE_REFERENCE_OFFER
-   AZ_STORAGE_PROFILE_IMAGE_REFERENCE_PUBLISHER
-   AZ_STORAGE_PROFILE_IMAGE_REFERENCE_SKU
-   AZ_STORAGE_PROFILE_IMAGE_REFERENCE_VERSION
-   AZ_STORAGE_PROFILE_OS_DISK_CACHING
-   AZ_STORAGE_PROFILE_OS_DISK_CREATE_OPTION
-   AZ_STORAGE_PROFILE_OS_DISK_MANAGED_DISK_ID
-   AZ_STORAGE_PROFILE_OS_DISK_MANAGED_DISK_STORAGE_ACCOUNT_TYPE
-   AZ_STORAGE_PROFILE_OS_DISK_NAME
-   AZ_STORAGE_PROFILE_OS_DISK_OS_TYPE
-   AZ_TYPE
-   AZ_VM_ID


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

The local hosts will have a priority of 0 by default, but you could set any value manually with the ``onehost update`` or ``onecluster update`` commands.

There are two other parameters that you may want to adjust in ``sched.conf``:

-  MAX_DISPATCH: Maximum number of Virtual Machines actually dispatched to a host in each scheduling action
-  MAX_HOST: Maximum number of Virtual Machines dispatched to a given host in each scheduling action

In a scheduling cycle, when MAX_HOST VMs have been deployed to a host, the host is discarded for the following pending VMs.

For example, having this configuration:

-  MAX\_HOST = 1
-  MAX\_DISPATCH = 30
-  2 Hosts: 1 in the local infrastructure, and 1 using the Azure drivers
-  2 pending VMs

The first VM will be deployed in the local host. The second VM will have also sort the local host with higher priority, but because 1 VM was already deployed, the second VM will be launched in Azure.

A quick way to ensure that your local infrastructure will always be used before the Azure hosts is to **set MAX_DISPATCH to the number of local hosts**.

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

VMs running on Azure that were not launched through OpenNebula can be :ref:`imported into OpenNebula <import_wild_vms>`.
