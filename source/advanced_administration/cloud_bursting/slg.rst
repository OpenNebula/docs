.. _slg:

================
SoftLayer Driver
================

Considerations & Limitations
============================

You should take into account the following technical considerations when using the SoftLayer (SL) cloud with OpenNebula:

-  There is no direct access to the hypervisor, so it cannot be monitored (we don't know where the VM is running on the SoftLayer cloud).

-  The usual OpenNebula functionality for snapshotting, hot-plugging, or migration is not available with SoftLayer (currently).

-  By default OpenNebula will always launch slcci.small (1 CPU, 1024MB RAM) instances, unless otherwise specified.

+--------------+--------------+-----------------+
|     Name     | CPU Capacity | Memory Capacity |
+==============+==============+=================+
| slcci.small  | 1 Core       | 1024 MB         |
+--------------+--------------+-----------------+
| slcci.medium | 2 Cores      | 4096 MB         |
+--------------+--------------+-----------------+
| slcci.large  | 4 Cores      | 8192 MB         |
+--------------+--------------+-----------------+

Prerequisites
=============

.. warning:: ruby >= 1.9.3 is required, and it is not packaged in all distros supported by OpenNebula. If you are running on an older supported distro (like Centos 6.x or Ubuntu 12.04) please update ruby or use `rvm <https://rvm.io/>`__ to run a newer (>= 1.9.3) version (remember to run ``install_gems`` after the ruby upgrade is done to reinstall all gems)

-  You must have a working account for `SoftLayer <http://www.softlayer.com/>`__
-  You need your username and API authentication key, that can be achieved in the `user profile page <https://control.softlayer.com/account/user/profile/>`__
-  The following gems are required ``softlayer_api`` and ``configparser``. Otherwise, run the ``install_gem`` script as root:

.. code::

    # /usr/share/one/install_gems cloud

OpenNebula Configuration
========================

Uncomment the SoftLayer SL IM and VMM drivers from ``/etc/one/oned.conf`` file in order to use the driver.

.. code::

    IM_MAD = [
          name       = "sl",
          executable = "one_im_sh",
          arguments  = "-c -t 1 -r 0 sl" ]
     
    VM_MAD = [
        name       = "sl",
        executable = "one_vmm_sh",
        arguments  = "-t 15 -r 0 sl",
        type       = "xml" ]

Driver flags are the same as other drivers:

+------+----------------------------------------------------------------------+
| FLAG |                                 SETs                                 |
+======+======================================================================+
| -t   | Number of threads, i.e. number of actions performed at the same time |
+------+----------------------------------------------------------------------+
| -r   | Number of retries when contacting SoftLayer service                  |
+------+----------------------------------------------------------------------+

Additionally you must define your credentials, the SoftLayer datacenter to be used and the maximum capacity that you want OpenNebula to deploy on SoftLayer. In order to do this, edit the file ``/etc/one/sl_driver.conf``:

.. code::

    regions:
        default:
            region_name: ams01
            username: <your_username_here>
            api_key: <your_api_key_here>
            capacity:
                slcci.small: 5
                slcci.large: 0
                slcci.large: 0
        ams01:
            region_name: ams01
            username: <your_username_here>
            api_key: <your_api_key_here>
            capacity:
                slcci.small: 5
                slcci.large: 0
                slcci.large: 0
                    m1.xlarge: 0


In the above file, each region represents a `SoftLayer datacenter <http://www.softlayer.com/data-centers>`__. (see the :ref:`multi site region account section <slg_multi_sl_site_region_account_support>` for more information.  

Once the file is saved, OpenNebula needs to be restarted (as ``oenadmin``, do a 'onevm restart'), create a new Host that uses the SL drivers:

.. code::

    $ onehost create ams01 --im sl --vm sl --net dummy

SoftLayer Specific Template Attributes
======================================

In order to deploy an instance in SoftLayer through OpenNebula you must include an PUBLIC_CLOUD section in the virtual machine template. This is an example of a virtual machine template that can be deployed in our local resources or in SoftLayer.

.. code::

    CPU      = 0.5
    MEMORY   = 128
     
    # Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    # SoftLayer template machine, this will be use wen submitting this VM to SoftLayer
    PUBLIC_CLOUD=[
       TYPE="SOFTLAYER",
       HOSTNAME="MySLVM",
       DOMAIN="c12g.com",
       INSTANCE_TYPE="slcci.medium",
       OPERATINGSYSTEM="UBUNTU_LATEST"
    ]
     
    #Add this if you want this VM to only go to the SL cloud
    #SCHED_REQUIREMENTS = 'HOSTNAME = "asm01"'

These are the attributes that can be used in the PUBLIC_CLOUD section of the template for TYPE SoftLayer:

+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|           ATTRIBUTES          |                                                                                                       DESCRIPTION                                                                                                       |
+===============================+=========================================================================================================================================================================================================================+
| ``HOSTNAME``                  | Hostname for the computing instance                                                                                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DOMAIN``                    | Domain for the computing instance                                                                                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``INSTANCE_TYPE``             | Specifies the capacity of the VM in terms of CPU and memory. If both STARTCPUS and MAXMEMORY are used, then this parameter is disregarded                                                                               |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``STARTCPUS``                 | The number of CPU cores to allocate to the VM                                                                                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MAXMEMORY``                 | The amount of memory to allocate in megabytes                                                                                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``HOURLYBILLING``             | Specifies the billing type for the instance . When true the computing instance will be billed on hourly usage, otherwise it will be billed on a monthly basis                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``LOCALDISK``                 | Name of the placement group. When true the disks for the computing instance will be provisioned on the host which it runs, otherwise SAN disks will be provisioned                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DEDICATEDHOST``             | Specifies whether or not the instance must only run on hosts with instances from the same account                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DATACENTER``                | Specifies which datacenter the instance is to be provisioned in                                                                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``OPERATINGSYSTEM``           | An identifier for the operating system to provision the computing instance with. A non `exhaustive list of identifiers can be found here <https://github.com/softlayer/softlayer-python/blob/master/docs/cli/vs.rst>`__ |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BLOCKDEVICETEMPLATE``       | A global identifier for the template to be used to provision the computing instance                                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BLOCKDEVICE``               | Size of the block device size to be presented to the VM                                                                                                                                                                 |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``NETWORKCOMPONENTSMAXSPEED`` | Specifies the connection speed for the instance's network components                                                                                                                                                    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PRIVATENETWORKONLY``        | Specifies whether or not the instance only has access to the private network  (ie, if it is going to have a public IP interface or not)                                                                                 |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PRIMARYNETWORKVLAN``        | Specifies the network vlan which is to be used for the frontend interface of the computing instance                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PRIMARYBACKENDNETWORKVLAN`` | Specifies the network vlan which is to be used for the backend interface of the computing instance                                                                                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``USERDATA``                  | Arbitrary data to be made available to the computing instance                                                                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SSHKEYS``                   | SSH keys to install on the computing instance upon provisioning                                                                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``POSTSCRIPT``                | Specifies the uri location of the script to be downloaded and run after installation is complete                                                                                                                        |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Default values for all these attributes can be defined in the ``/etc/one/sl_driver.default`` file.

.. code::

    <!--
     Default configuration attributes for the SoftLayer driver
     (all domains will use these values as defaults)
     
     Use XML syntax to specify defaults, note elements are UPPERCASE
     Example:
     <TEMPLATE>
       <SOFTLAYER>
         <INSTANCETYPE>scci.small</INSTANCETYPE>
       </SOFTLAYER>
     </TEMPLATE>
    -->

     <TEMPLATE>
       <SOFTLAYER>
        <DOMAIN>c12g.com</DOMAIN>
        <INSTANCE_TYPE>slcci.small</INSTANCE_TYPE>
        <HOURLYBILLINGFLAG>true</HOURLYBILLINGFLAG>
        <LOCALDISKFLAG>true</LOCALDISKFLAG>
       </SOFTLAYER>
     </TEMPLATE>

.. _slg_multi_sl_site_region_account_support:

Multi SoftLayer Site/Account Support
===========================================

It is possible to define various SoftLater hosts to allow OpenNebula the managing of different SoftLayer datacenters or different SoftLayer accounts. OpenNebula choses the datacenter in which to launch the VM in the following way:

- if the VM description contains the DATACENTER attribute,  then OpenNebula knows that the VM  needs to be launch in this SoftLayer datacenter
- if the name of the host matches the region name (remember, this is the same as a SL datacenter), then OpenNebula knows that the VMs sent to this host needs to be launch in that SL datacenter
- if the VM doesn't have a DATACENTER attribute, and the host name doesn't match any of the defined regions, then the default region is picked.

When you create a new host the credentials and endpoint for that host are retrieved from the ``/etc/one/sl_driver.conf`` file using the host name. Therefore, if you want to add a new host to manage a different datacenter, i.e. ``sjc01``, just add your credentials and the capacity limits to the the ``sjc01`` section in the conf file, and specify that name (sjc01) when creating the new host.

.. code::

    regions:
        ...
        sjc01:
            region_name: sjc01
            username:
            api_key:
            capacity:
                slcci.small: 5
                slcci.medium: 0
                slcci.large: 0

After that, create a new Host with the ``sjc01`` name:

.. code::

    $ onehost create sjc01 --im sl --vm sl --net dummy

If the Host name does not match any regions key, the ``default`` will be used.

You can define a different SoftLayer section in your template for each SoftLayer host, so with one template you can define different VMs depending on which host it is scheduled, just include a HOSTNAME attribute in each PUBLIC_CLOUD section:

.. code::

    PUBLIC_CLOUD = [ TYPE="SOFTLAYER",
                     HOSTNAME="sjc01",
                     OPERATINGSYSTEM="UBUNTU_LATEST",
                     INSTANCE_TYPE="sclcci.small" ]

    PUBLIC_CLOUD = [ TYPE="SOFTLAYER",
                     HOSTNAME="ams01",
                     OPERATINGSYSTEM="REDHAT_LATEST",
                     INSTANCE_TYPE="sclcci.medium" ]

You will have a small Ubuntu VM launched when this VM template is sent to host *sjc01* and a medium RedHat VM launched whenever the VM template is sent to host *ams01*.

.. warning:: If only one SoftLayer site is defined, the SoftLayer driver will deploy all SoftLayer templates onto it, not paying attention to the **HOSTNAME** attribute.

Hybrid VM Templates
===================

A powerful use of cloud bursting in OpenNebula is the ability to use hybrid templates, defining a VM if OpenNebula decides to launch it locally, and also defining it if it is going to be outsourced to SoftLayer. The idea behind this is to reference the same kind of VM even if it is incarnated by different images (the local image and the SoftLayer image).

An example of a hybrid template:

.. code::

    ## Local Template section
    NAME=MNyWebServer
     
    CPU=1
    MEMORY=256
     
    DISK=[IMAGE="nginx-golden"]
    NIC=[NETWORK="public"]
     
    PUBLIC_CLOUD = [ TYPE="SOFTLAYER",
                     HOSTNAME="sjc01",
                     OPERATINGSYSTEM="UBUNTU_LATEST",
                     INSTANCE_TYPE="sclcci.small" ]

OpenNebula will use the first portion (from NAME to NIC) in the above template when the VM is scheduled to a local virtualization node, and the PUBLIC_CLOUD section of TYPE="SOFTLAYER" when the VM is scheduled to an SoftLayer node (ie, when the VM is going to be launched in SoftLayer).

Testing
=======

You must create a template file containing the information of the VMs you want to launch.

.. code::

    CPU      = 1
    MEMORY   = 1700
     
    #Xen or KVM template machine, this will be use when submitting this VM to local resources
    DISK     = [ IMAGE_ID = 3 ]
    NIC      = [ NETWORK_ID = 7 ]
     
    #SoftLayer template machine, this will be use wen submitting this VM to SoftLayer
     
    PUBLIC_CLOUD = [ TYPE="SOFTLAYER",
                     HOSTNAME="sjc01",
                     OPERATINGSYSTEM="UBUNTU_LATEST",
                     INSTANCE_TYPE="sclcci.small" ]
     
    #Add this if you want to use only SoftLayer cloud
    #SCHED_REQUIREMENTS = 'HYPERVISOR = "SOFTLAYER"'

You can submit and control the template using the OpenNebula interface:

.. code::

    $ onetemplate create sltemplate
    $ ontemplate instantiate sltemplate

Now you can monitor the state of the VM with

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K           sjc01    0d 07:03

Also you can see information (like IP address) related to the SoftLayer instance launched via the command. The attributes available are:

-  SL_CRED_PASSWORD
-  SL_CRED_USER
-  SL_DOMAIN
-  SL_FULLYQUALIFIEDDOMAINNAME
-  SL_GLOBALIDENTIFIER
-  SL_HOSTNAME
-  SL_ID
-  SL_MAXCPU
-  SL_MAXMEMORY
-  SL_PRIMARYBACKENDIPADDRESS
-  SL_PRIMARYIPADDRESS
-  SL_STARTCPUS
-  SL_UUID

.. code::

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 32
    NAME                : one-32
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    RESCHED             : No
    HOST                : sjc01
    CLUSTER ID          : -1
    START TIME          : 06/05 20:01:46
    END TIME            : -
    DEPLOY ID           : 4978604

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
      0 sjc01           none               -1  06/05 20:01:59   3d 16h53m   0h00m00s

    USER TEMPLATE
    PUBLIC_CLOUD = [ TYPE="SOFTLAYER",
                     HOSTNAME="sjc01",
                     OPERATINGSYSTEM="UBUNTU_LATEST",
                     INSTANCE_TYPE="sclcci.small" ]

    VIRTUAL MACHINE TEMPLATE
    AUTOMATIC_REQUIREMENTS="!(PUBLIC_CLOUD = YES) | (PUBLIC_CLOUD = YES & (HYPERVISOR = SOFTLAYER | HYPERVISOR = SOFTLAYER))"
    CPU="1"
    MEMORY="1024"
    SL_CRED_PASSWORD="xxxxxx"
    SL_CRED_USER="root"
    SL_DOMAIN="c12g.com"
    SL_FULLYQUALIFIEDDOMAINNAME="MySLVM.c12g.com"
    SL_GLOBALIDENTIFIER="xx299e80-96a0-434f-b228-430689c45ffb"
    SL_HOSTNAME="MySLVM"
    SL_ID="4978604"
    SL_MAXCPU="2"
    SL_MAXMEMORY="4096"
    SL_PRIMARYBACKENDIPADDRESS="10.104.201.xxx"
    SL_PRIMARYIPADDRESS="5.153.45.xx"
    SL_STARTCPUS="2"
    SL_UUID="xxxxxxxx-a0cc-e648-2ebd-e5fb2a500965"

Scheduler Configuration
=======================

Since SoftLayer Hosts are treated by the scheduler like any other host, VMs will be automatically deployed in them. But you probably want to lower their priority and start using them only when the local infrastructure is full.

Configure the Priority
----------------------

The SoftLayer drivers return a probe with the value PRIORITY = -1. This can be used by :ref:`the scheduler <schg>`, configuring the 'fixed' policy in ``sched.conf``:

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
-  2 Hosts: 1 in the local infrastructure, and 1 using the SoftLayer drivers
-  2 pending VMs

The first VM will be deployed in the local host. The second VM will have also sort the local host with higher priority, but because 1 VMs was already deployed, the second VM will be launched in SoftLayer.

A quick way to ensure that your local infrastructure will be always used before the SoftLayer hosts is to **set MAX\_DISPATH to the number of local hosts**.

Force a Local or Remote Deployment
----------------------------------

The SoftLayer drivers report the host attribute PUBLIC\_CLOUD = YES. Knowing this, you can use that attribute in your :ref:`VM requirements <template_placement_section>`.

To force a VM deployment in a local host, use:

.. code::

    SCHED_REQUIREMENTS = "!(PUBLIC_CLOUD = YES)"

To force a VM deployment in a SoftLayer host, use:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

