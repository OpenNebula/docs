.. _devel_cloudbursting:

================================================================================
Cloud Bursting Driver
================================================================================

This guide will show you how to develop a new driver for OpenNebula to interact with an external cloud provider.

Cloud bursting, or hybrid cloud, is a model in which the local resources of a Private Cloud are combined with resources from remote Cloud providers. The remote provider could be a commercial Cloud service, such as Amazon EC2 or Microsoft Azure, or a partner infrastructure running a different OpenNebula instance. Such support for cloud bursting enables highly scalable hosting environments. For more information on this model see the :ref:`Cloud Bursting overview <introh>`

The remote cloud provider will be included in the OpenNebula host pool like any other physical host of your infrastructure:

.. code::

    $ onehost create remote_provider im_provider vmm_provider

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       2 kvm-            -           0       0 / 800 (0%)      0K / 16G (0%) on
       3 kvm-1           -           0       0 / 100 (0%)     0K / 1.8G (0%) on
       4 remote_provider -           0       0 / 500 (0%)     0K / 8.5G (0%) on

When you create a new host in OpenNebula you have to specify the following parameters:

-  Name: remote\_provider

Name of the host, in case of physical hosts it will the ip address or hostname of the host. In case of remote providers it will be just a name to identify the provider.

-  :ref:`Information Manager <devel-im>`: ``im_provider``

IM driver gather information about the physical host and hypervisor status, so the OpenNebula scheduler knows the available resources and can deploy the virtual machines accordingly.

-  :ref:`VirtualMachine Manager <devel-vmm>`: ``vmm_provider``

VMM drivers translate the high-level OpenNebula virtual machine life-cycle management actions, like deploy, shutdown, etc. into specific hypervisor operations. For instance, the KVM driver will issue a virsh create command in the physical host. The EC2 driver translate the actions into Amazon EC2 API calls.

.. note:: Storage and Network drivers are derived from the VM characteristics rather than the host.

When creating a new host to interact with a remote cloud provider we will use mock versions for the TM and VNM drivers. Therefore, we will only implement the functionality required for the IM and VMM driver.

Adding the Information Manager
================================================================================

Edit oned.conf
--------------------------------------------------------------------------------

Add a new IM section for the new driver in oned.conf:

.. code::

    #*******************************************************************************
    # Information Driver Configuration
    #*******************************************************************************
    # You can add more information managers with different configurations but make
    # sure it has different names.
    #
    #   name      : name for this information manager
    #
    #   executable: path of the information driver executable, can be an
    #               absolute path or relative to $ONE_LOCATION/lib/mads (or
    #               /usr/lib/one/mads/ if OpenNebula was installed in /)
    #
    #   arguments : for the driver executable, usually a probe configuration file,
    #               can be an absolute path or relative to $ONE_LOCATION/etc (or
    #               /etc/one/ if OpenNebula was installed in /)
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #*******************************************************************************
    #-------------------------------------------------------------------------------
    #  EC2 Information Driver Manager Configuration
    #-------------------------------------------------------------------------------
    IM_MAD = [
          name       = "im_provider",
          executable = "one_im_sh",
          arguments  = "-t 1 -r 0 provider_name" ]
    #-------------------------------------------------------------------------------

Populating the Probes
--------------------------------------------------------------------------------

Create a new directory to store your probes, the name of this folder must match the name provided in the arguments section of the IM\_MAD in oned.conf:

-  /var/lib/one/remotes/im/<provider\_name>.d

These probes must return:

-  :ref:`Information of the host capacity <devel-im_basic_monitoring_scripts>`, to limit the number of VMs that can be deployed in this host.
-  :ref:`Information of the VMs <devel-im_vm_information>` running in this host.

You can see an example of these probes in the `ec2 driver <https://github.com/OpenNebula/one/tree/master/src/im_mad/remotes/ec2.d>`__ (`code <https://github.com/OpenNebula/one/blob/master/src/vmm_mad/remotes/ec2/ec2_driver.rb#L300>`__) included in OpenNebula

**You must include the PUBLIC\_CLOUD and HYPERVISOR attributes** as one of the values returned by your probes, otherwise OpenNebula will consider this host as local. The HYPERVISOR attribute will be used by the scheduler and should match the TYPE value inside the PUBLIC\_CLOUD section provided in the VM template.

.. code::

    PUBLIC_CLOUD="YES"
    HYPERVISOR="provider_name"

Adding the Virtual Machine Manager
================================================================================

Edit oned.conf
--------------------------------------------------------------------------------

.. code::

    #*******************************************************************************
    # Virtualization Driver Configuration
    #*******************************************************************************
    # You can add more virtualization managers with different configurations but
    # make sure it has different names.
    #
    #   name      : name of the virtual machine manager driver
    #
    #   executable: path of the virtualization driver executable, can be an
    #               absolute path or relative to $ONE_LOCATION/lib/mads (or
    #               /usr/lib/one/mads/ if OpenNebula was installed in /)
    #
    #   arguments : for the driver executable
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #
    #   default   : default values and configuration parameters for the driver, can
    #               be an absolute path or relative to $ONE_LOCATION/etc (or
    #               /etc/one/ if OpenNebula was installed in /)
    #
    #   type      : driver type, supported drivers: xen, kvm, xml
    #  
    #-------------------------------------------------------------------------------
    VM_MAD = [
        name       = "vmm_provider",
        executable = "one_vmm_sh",
        arguments  = "-t 15 -r 0 provider_name",
        type       = "xml" ]
    #-------------------------------------------------------------------------------

Create the Driver Folder and Implement the Specific Actions
--------------------------------------------------------------------------------

Create a new folder inside the remotes dir (/var/lib/one/remotes/vmm). The new folder should be named “provider\_name”, the name specified in the previous VM\_MAD arguments section.

This folder must contain scripts for the supported actions. You can see the list of available actions in the :ref:`Virtual Machine Driver guide <devel-vmm_action>`. These scripts are language-agnostic so you can implement them using python, ruby, bash...

You can see examples on how to implement this in the `ec2 driver <https://github.com/OpenNebula/one/tree/master/src/vmm_mad/remotes/ec2>`__:

-  EC2 Shutdown action:

.. code::

    #!/usr/bin/env ruby
     
    # -------------------------------------------------------------------------- #
    # Copyright 2002-2016, OpenNebula Project, OpenNebula Systems                #
    #                                                                            #
    # Licensed under the Apache License, Version 2.0 (the "License"); you may    #
    # not use this file except in compliance with the License. You may obtain    #
    # a copy of the License at                                                   #
    #                                                                            #
    # http://www.apache.org/licenses/LICENSE-2.0                                 #
    #                                                                            #
    # Unless required by applicable law or agreed to in writing, software        #
    # distributed under the License is distributed on an "AS IS" BASIS,          #
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
    # See the License for the specific language governing permissions and        #
    # limitations under the License.                                             #
    # -------------------------------------------------------------------------- #
     
    $: << File.dirname(__FILE__)
     
    require 'ec2_driver'
     
    deploy_id = ARGV[0]
    host      = ARGV[1]
     
    ec2_drv = EC2Driver.new(host)
     
    ec2_drv.shutdown(deploy_id)

Create the New Host
--------------------------------------------------------------------------------

After restarting oned we can create the new host that will use this new driver

.. code::

    $ onehost create remote_provider im_provider vmm_provider

Create a new Virtual Machine
--------------------------------------------------------------------------------

Create a new VM using a template with an specific section for this provider. You have to include the required information to start a new VM inside the PUBLIC\_CLOUD section, and the TYPE attribute must match the HYPERVISOR value of the host. For example:

.. code::

    $ cat vm_template.one
    CPU=1
    MEMORY=256
    PUBLIC_CLOUD=[
        TYPE=provider_name
        PROVIDER_IMAGE_ID=id-141234,
        PROVIDER_INSTANCE_TYPE=small_256mb
    ]

    $ onevm create vm_template
    ID: 23

    $ onevm deploy 23 remote_provider

After this, the deploy script will receive the following arguments:

-  The path to the deployment file that contains the following XML:

.. code::

    <CPU>1</CPU>
    <MEMORY>256</MEMORY>
    <PUBLIC_CLOUD>
        <TYPE>provider_name</TYPE>
        <PROVIDER_IMAGE_ID>id-141234</PROVIDER_IMAGE_ID>
        <PROVIDER_INSTANCE_TYPE>small_256mb</PROVIDER_INSTANCE_TYPE>
    </PUBLIC_CLOUD>

-  The hostname: ``remote_provider``
-  The VM ID: ``23``

The deploy script has to return the ID of the new resource and an exit\_code 0:

.. code::

    $ cat /var/lib/one/remote/provider/deploy
    #!/bin/bash
    deployment_file=$1
    # Parse required parameters from the template
    ..
    # Retrieve account credentials from a local file/env
    ...
    # Create a new resource using the API provider
    ...
    # Return the provider ID of the new resource and exit code 0 or an error message

