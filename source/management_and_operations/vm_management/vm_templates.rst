.. _vm_guide:
.. _vm_templates:

================================================================================
Virtual Machine Templates
================================================================================

In OpenNebula, VMs are defined with VM Templates. This section explains how to describe a Virtual Machine, and how users typically interact with the system.

OpenNebula administrators and users can register Virtual Machine definitions (VM Templates) in the system, to be instantiated later as Virtual Machine instances. These VM Templates can be instantiated several times, and also shared with other users.

.. _vm_guide_defining_a_vm_in_3_steps:

Defining a VM
================================================================================

A Virtual Machine Template, at the very basics, consists of:

-  A capacity in terms memory and CPU
-  A set of NICs attached to one or more virtual networks
-  A set of disk images
-  Optional attributes like VNC graphics, the booting order, context information, etc.

VM Templates are stored in the system to easily browse and instantiate VMs from them.

Capacity & Name
--------------------------------------------------------------------------------

Defines the basic attributes of the VM including its NAME, amount of RAM (``MEMORY``), or number of Virtual CPUs.

:ref:`See Capacity Section in the VM Template reference <template_capacity_section>`.

.. _vm_disks:

Disks
--------------------------------------------------------------------------------

Each disk is defined with a DISK attribute. A VM can use three types of disk:

* **Use a persistent Image**: changes to the disk image will persist after the VM is terminated.
* **Use a non-persistent Image**: a copy of the source Image is used, changes made to the VM disk will be lost.
* **Volatile**: disks are created on the fly on the target host. After the VM is terminated the disk is disposed.

:ref:`See Disks Section in the VM Template reference <template_disks_section>`.

Network Interfaces & Alias
--------------------------------------------------------------------------------

Network interfaces can be defined in two different ways:

- **Manual selection**: interfaces are attached to a pre-selected Virtual Network. Note that this may require to build multiple templates considering the available networks in each cluster.
- **Automatic selection**: Virtual networks will be scheduled like other resources needed by the VM (like hosts or datastores). This way, you can hint the type of network the VM will need and it will be automatically selected among those available in the cluster. :ref:`See more details here <vgg_vm_vnets>`.

Network **interface alias** allows you to have more than one IP on each network interface. This does not create a new virtual interface on the VM. The alias address is added to the network interface. An alias can be attached and detached. Note also that when a NIC with an alias is detached, all the associated alias are also detached.

The alias takes a lease from the network which it belongs to. So, for the OpenNebula it is the same as a NIC and exposes the same management interface, it is just different in terms of the associated virtual network interface within the VM.

.. note:: The Virtual Network used for the alias can be different from that of the NIC which is alias of.

:ref:`See Network Section in the VM Template reference <template_network_section>`.

A Complete Example
--------------------------------------------------------------------------------

The following example shows a VM Template file with a couple of disks and a network interface, also a VNC section and an alias were added.

.. code-block:: none

    NAME   = test-vm
    MEMORY = 128
    CPU    = 1

    DISK = [ IMAGE  = "Arch Linux" ]
    DISK = [ TYPE     = swap,
             SIZE     = 1024 ]

    NIC = [ NETWORK = "Public", NETWORK_UNAME="oneadmin" ]

    NIC = [ NETWORK = "Private", NAME = "private_net" ]
    NIC_ALIAS = [ NETWORK = "Public", PARENT = "private_net" ]

    GRAPHICS = [
      TYPE    = "vnc",
      LISTEN  = "0.0.0.0"]

.. important:: Check the :ref:`VM definition file for a complete reference <template>`

Simple templates can be also created using the command line instead of creating a template file. For example, a similar template as the previous example can be created with the following command:

.. prompt:: text $ auto

    $ onetemplate create --name test-vm --memory 128 --cpu 1 --disk "Arch Linux" --nic Public

For a complete reference of all the available options for ``onetemplate create``, go to the :ref:`CLI reference <cli>`, or run ``onetemplate create -h``.

.. note:: OpenNebula Templates are designed to be hypervisor-agnostic, but there are additional attributes that are supported for each hypervisor. Check the corresponding hypervisor guide for specific details.

.. _context_overview:

Virtual Machine Contextualization
================================================================================

OpenNebula uses a method called contextualization to send information to the VM at boot time. Its most basic usage is to share networking configuration and login credentials with the VM so it can be configured. More advanced cases can be starting a custom script on VM boot or preparing configuration to use :ref:`OpenNebula Gate <onegate_usage>`.

You can define contextualization data in the VM Template. :ref:`See Context Section in the VM Template reference <template_context>`.

.. _vm_templates_endusers:

Preparing VM Templates for End-Users
================================================================================

Besides the basic VM definition attributes, you can setup some extra options in your VM Template to ease sharing it with other users.

Customizable Capacity
--------------------------------------------------------------------------------

The capacity attributes (``CPU``, ``MEMORY``, ``VCPU``) can be modified each time a VM Template is instantiated. The Template owner can decide `if` and `how` each attribute can be customized. The modification options available are:

* **fixed** (``fixed``): The value cannot be modified.
* **any value** (``text``): The value can be changed to any number by the user instantiating the Template.
* **range** (``range``): Users will be offered a range slider between the given minimum and maximum values.
* **list** (``list``): Users will be offered a drop-down menu to select one of the given options.

If you are using a template file instead of Sunstone, the modification is defined with user input (``USER_INPUT``) attributes (:ref:`see below <vm_guide_user_inputs>`). The absence of user input is an implicit *any value*. For example:

.. code-block:: none

    CPU    = "1"
    MEMORY = "2048"
    VCPU   = "2"
    USER_INPUTS = [
      VCPU   = "O|fixed|| |2"
      CPU    = "M|list||0.5,1,2,4|1",
      MEMORY = "M|range||512..8192|2048" ]

.. note:: Use float types for CPU, and integer types for MEMORY and VCPU. More information in :ref:`the Template reference documentation <template_user_inputs>`.

.. note:: This capacity customization can be forced to be disabled for any Template in the cloud view. Read more in the :ref:`Cloud View Customization documentation <cloud_view_config>`.

.. _vm_guide_user_inputs:

User Inputs
--------------------------------------------------------------------------------

The User Inputs functionality provides the VM Template creator the possibility to dynamically ask for dynamic values. This is a convenient way to parametrize a base installation. These inputs will be presented to the user when the VM Template is instantiated. The VM guest needs to have the OpenNebula contextualization packages installed to make use of the values provided by the user. The following example shows how to pass some user inputs to a VM:

.. code-block:: none

    USER_INPUTS = [
      BLOG_TITLE="M|text|Blog Title",
      MYSQL_PASSWORD="M|password|MySQL Password",
    ]

    CONTEXT=[
      BLOG_TITLE="$BLOG_TITLE",
      MYSQL_PASSWORD="$MYSQL_PASSWORD" ]


.. note:: If a VM Template with user inputs is used by a :ref:`Service Template Role <appflow_use_cli>`, the user will be also asked for these inputs when the Service is created.

.. note:: You can use the flag ``--user-inputs ui1,ui2,ui3`` to use them in a non-interactive way.

:ref:`See User Inputs Section in the VM Template reference <template_user_inputs>`.

.. _vm_guide_user_inputs_sunstone:

User Inputs in Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When a virtual machine template is instantiated using Sunstone, the user will be asked to fill the user inputs that are defined in the virtual machine template. So, using the following user inputs:

.. code-block:: none

    USER_INPUTS = [
      BLOG_TITLE="M|text|Blog Title",
      BLOG_DESCRIPTION="O|text|Blog Description",
      MYSQL_ENDPOINT="M|text|MySQL Endpoint",
      MYSQL_USER="O|password|MySQL User",
      MYSQL_PASSWORD="O|password|MySQL Password",
      MYSQL_ADDITIONAL="O|boolean|Define additional parameters",
      MYSQL_SOCKET="O|text|MySQL Socket",
      MYSQL_CHARSET="O|text|MySQL Charset",
    ]

The result will be a step with all the user inputs that are defined in the template:

|sunstone_user_inputs_no_convention|

In order to improve the user experience, Sunstone can render this user inputs in a different way, easy to understand to the Sunstone user. To do that, Sunstone uses rules based on the name of the user inputs. That rules are:

.. _sunstone_layout_rules:

- User input name has to meet the following convention ``ONEAPP_<APP>_<GROUP>_<FIELD>`` where all the user inputs that meet this convention will be grouped by APP and GROUP. An APP will be render as a tab in Sunstone and a GROUP will group the user inputs that belong to this group.
- If ``FIELD`` is the word ``ENABLED`` and the user input type is boolean, all the user inputs that has the same APP and GROUP will be hidden until the ENABLED user input is turn on.
- If a user input not meet the convention, will be placed in a tab called Others.
- If all the user inputs do not meet the convention name, no tabs will be rendered (as the previous example).

So, if the previous template is modified as follows:

.. code-block:: none

    USER_INPUTS = [
      ONEAPP_BLOG_CONF_TITLE="M|text|Blog Title",
      ONEAPP_BLOG_CONF_DESCRIPTION="O|text|Blog Description",
      ONEAPP_MYSQL_CONFIG_ENDPOINT="M|text|MySQL Endpoint",
      ONEAPP_MYSQL_CONFIG_USER="O|password|MySQL User",
      ONEAPP_MYSQL_CONFIG_PASSWORD="O|password|MySQL Password",
      ONEAPP_MYSQL_ADDITIONAL_ENABLED="O|boolean|Define additional parameters",
      ONEAPP_MYSQL_ADDITIONAL_SOCKET="O|text|MySQL Socket",
      ONEAPP_MYSQL_ADDITIONAL_CHARSET="O|text|MySQL Charset",
    ]

The user inputs will be grouped in a tab called BLOG with a group called CONF:

|sunstone_user_inputs_convention_blog|

Also, there will be a tab called MYSQL with two groups, CONFIG and ADDITIONAL:

|sunstone_user_inputs_convention_mysql_1|

To see the user inputs in the ADDITONAL group, the user must turn on the Define additional parameters user input:

|sunstone_user_inputs_convention_mysql_2|


Additional data for User Inputs in Sunstone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to help the Sunstone user, the virtual machine templates can be extended with an attribute called USER_INPUTS_METADATA that will be adding some info to the APPS and GROUPS.

:ref:`See User Inputs Section Metadata in the VM Template reference <template_user_inputs_metadata>`.

.. note:: The attribute ``USER_INPUTS_METADATA`` only will be used in Sunstone, not in others components of OpenNebula.

So, if we use the previous template and add the following information:

.. code::

  USER_INPUTS_METADATA=[
    DESCRIPTION="This tab includes all the information about the blog section in this template.",
    NAME="BLOG",
    TITLE="Blog",
    TYPE="APP" ]
  USER_INPUTS_METADATA=[
    NAME="MYSQL",
    TITLE="MySQL",
    TYPE="APP" ]
  USER_INPUTS_METADATA=[
    DESCRIPTION="MySQL configuration parameters",
    NAME="CONFIG",
    TITLE="Configuration",
    TYPE="GROUP" ]
  USER_INPUTS_METADATA=[
    DESCRIPTION="Additional MySQL parameters",
    NAME="ADDITIONAL",
    TITLE="Additional parameters",
    TYPE="GROUP" ]

Due to the elements with TYPE equal to APP, BLOG tab has title Blog and MYSQL tab has title MySQL (TITLE attribute). Also, due to these elements, we have an info note in the Blog tab (DESCRIPTION attribute):

|sunstone_user_inputs_metadata_1|

Due to the elements with TYPE equal to GROUP, CONFIG group has title Configuration and ADDITIONAL group has title Additional parameters (TTILE attribute). Also, due to these elements Sunstone shows a info text in both groups (DESCRIPTION attribute):

|sunstone_user_inputs_metadata_2|


.. _sched_actions_templ:

Schedule Actions
--------------------------------------------------------------------------------

If you want to perform a pre-defined operation on a VM, you can use the Scheduled Actions. The selected operation will be performed on the VM at a specific time, e.g. *"Shut down the VM 5 hours after it started"*. You can also add an Scheduled action at :ref:`VM instantiation <vm_guide2_scheduling_actions>`.

:ref:`See Schedule Actions Section in the VM Template reference <template_schedule_actions>`.


Set a Cost
--------------------------------------------------------------------------------

Each VM Template can have a cost per hour. This cost is set by CPU unit and MEMORY MB, and disk MB. VMs with a cost will appear in the :ref:`showback reports <showback>`.


:ref:`See Showback Section in the VM Template reference <template_showback_section>`.

.. _cloud_view_features:

Enable End User Features
--------------------------------------------------------------------------------

There are a few features of the :ref:`Cloud View <cloud_view>` that will work if you configure the Template to make use of them:

* The Cloud View gives access to the VM's VNC, but only if it is configured in the Template.
* End users can upload their public ssh key. This requires the VM guest to be :ref:`contextualized <context_overview>`, and the Template must have the ssh contextualization enabled.

Make the Images Non-Persistent
--------------------------------------------------------------------------------

If a Template is meant to be consumed by end-users, its Images should not be persistent. A persistent Image can only be used by one VM simultaneously, and the next user will find the changes made by the previous user.

If the users need persistent storage, they can use the :ref:`"instantiate to persistent" functionality <vm_guide2_clone_vm>`.

Prepare the Network Interfaces
--------------------------------------------------------------------------------

End-users can select the VM network interfaces when launching new VMs. You can create templates without any NIC, or set the default ones. If the template contains any NIC, users will still be able to remove them and select new ones.

When users add network interfaces, you need to define a default NIC model in case the VM guest needs a specific one (e.g. virtio for KVM). This can be done with the :ref:`NIC_DEFAULT <nic_default_template>` attribute, or through the Template wizard. Alternatively, you could change the default value for all VMs in the driver configuration file (see the :ref:`KVM one <kvmg_default_attributes>` for example).

.. note:: This networking customization can be forced to be disabled for any Template in the cloud view. Read more in the :ref:`Cloud View Customization documentation <cloud_view_config>`.

Instantiating Templates
================================================================================

You can create a VM out of an existing VM Template using the ``onetemplate instantiate`` command . It accepts a Template ID or name, and creates a VM instance from the given template. You can create more than one instance simultaneously with the ``--multiple num_of_instances`` option.

.. prompt:: text $ auto

    $ onetemplate instantiate 6
    VM ID: 0

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneuser1 users    one-0        pend   0      0K                 00 00:00:16

Overwrite VM Template Values
--------------------------------------------------------------------------------

Users can overwrite some of the VM Template values, limited to those not listed in the restricted attributes. This allows users some safe, degree of customization for predefined templates.

Let's say the administrator wants to provide base templates that the users can customize, but with some restrictions. Having the following :ref:`restricted attributes in oned.conf <oned_conf_restricted_attributes_configuration>`:

.. code-block:: none

    VM_RESTRICTED_ATTR = "CPU"
    VM_RESTRICTED_ATTR = "VPU"
    VM_RESTRICTED_ATTR = "NIC"

And the following template:

.. code-block:: none

    CPU     = "1"
    VCPU    = "1"
    MEMORY  = "512"
    DISK=[
      IMAGE = "BaseOS" ]
    NIC=[
      NETWORK_ID = "0" ]

Users can instantiate it customizing anything except the CPU, VCPU and NIC. To create a VM with different memory and disks:

.. prompt:: text $ auto

    $ onetemplate instantiate 0 --memory 1G --disk "Ubuntu 16.04"

Also, a user cannot delete any element of a list that has any restricted attributes. Having the following :ref:`restricted attributes in oned.conf <oned_conf_restricted_attributes_configuration>`:

.. code-block:: none

    VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC"

And the following template:

.. code-block:: none

    CPU     = "1"
    VCPU    = "1"
    MEMORY  = "512"
    DISK=[
      IMAGE = "BaseOS"
      TOTAL_BYTES_SEC = 1 ]
    DISK=[
      IMAGE = "BaseOS2" ]      
    NIC=[
      NETWORK_ID = "0" ]

A user can delete the second disk but an user cannot delete the first disk because it has a restricted attribute.

.. warning:: The provided attributes replace the existing ones. To add a new disk, the current one needs to be added also.

.. prompt:: text $ auto

    $ onetemplate instantiate 0 --disk BaseOS,"Ubuntu 16.04"

.. prompt:: text $ auto

    $ cat /tmp/file
    MEMORY = 512
    COMMENT = "This is a bigger instance"

    $ onetemplate instantiate 6 /tmp/file
    VM ID: 1


Deployment
--------------------------------------------------------------------------------

The OpenNebula Scheduler will deploy automatically the VMs in one of the available Hosts, if they meet the requirements. The deployment can be forced by an administrator using the ``onevm deploy`` command.

Use ``onevm terminate`` to shutdown and delete a running VM.

Continue to the :ref:`Managing Virtual Machine Instances Guide <vm_guide_2>` to learn more about the VM States, and the available operations that can be performed.

.. _instantiate_as_uid_gid:

Instantiating as another user and/or group
--------------------------------------------------------------------------------

The ``onetemplate instantiate`` command accepts option ``--as_uid`` and ``--as_gid`` with the User ID or Group ID to define the owner or group for the new VM.

.. prompt:: text $ auto

    $ onetemplate instantiate 6 --as_uid 2 --as_gid 1
    VM ID: 0

    $ onevm list
        ID USER      GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 test_user users    one-0        pend   0      0K                 00 00:00:16

Managing Templates
================================================================================

Users can manage the VM Templates using the command ``onetemplate``, or the graphical interface :ref:`Sunstone <sunstone>`. For each user, the actual list of templates available are determined by the ownership and permissions of the templates.

Adding and Deleting Templates
--------------------------------------------------------------------------------

Using ``onetemplate create``, users can create new Templates for private or shared use. The ``onetemplate delete`` command allows the owner -or the OpenNebula administrator- to delete it from the repository.

For instance, if the previous example template is written in the vm-example.txt file:

.. prompt:: text $ auto

    $ onetemplate create vm-example.txt
    ID: 6

Via Sunstone, you can easily add templates using the provided wizards and delete them clicking on the delete button.


.. _vm_template_clone:

Cloning Templates
--------------------------------------------------------------------------------

You can also clone an existing Template with the ``onetemplate clone`` command:

.. prompt:: text $ auto

    $ onetemplate clone 6 new_template
    ID: 7

If you use the ``onetemplate clone --recursive`` option, OpenNebula will clone each one of the Images used in the Template Disks. These Images are made persistent, and the cloned template DISK/IMAGE_ID attributes are replaced to point to the new Images.

Updating a Template
--------------------------------------------------------------------------------

It is possible to update a template by using the ``onetemplate update``. This will launch the editor defined in the variable ``EDITOR`` and let you edit the template.

.. prompt:: text $ auto

    $ onetemplate update 3

Restricted attributes when create or update a Template
--------------------------------------------------------------------------------

When a user creates or updates a template, there are some restricted attributes that she could not create or update. Having the following :ref:`restricted attributes in oned.conf <oned_conf_restricted_attributes_configuration>`:

.. code-block:: none

    VM_RESTRICTED_ATTR = "CPU"
    VM_RESTRICTED_ATTR = "VPU"
    VM_RESTRICTED_ATTR = "NIC"

And the following template:

.. code-block:: none

    CPU     = "1"
    VCPU    = "1"
    MEMORY  = "512"
    DISK=[
      IMAGE = "BaseOS" ]
    NIC=[
      NETWORK_ID = "0" ]

Users can create or update a template customizing anything except the CPU, VCPU and NIC.

Also, a user cannot delete any element of a list that has a restricted attributes. Having the following :ref:`restricted attributes in oned.conf <oned_conf_restricted_attributes_configuration>`:

.. code-block:: none

    VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC"

And the following template:

.. code-block:: none

    CPU     = "1"
    VCPU    = "1"
    MEMORY  = "512"
    DISK=[
      IMAGE = "BaseOS"
      TOTAL_BYTES_SEC = 1 ]
    DISK=[
      IMAGE = "BaseOS2" ]      
    NIC=[
      NETWORK_ID = "0" ]

A user can delete the second disk but she cannot delete the first disk because it contains a restricted attribute.

Sharing Templates with other Users
--------------------------------------------------------------------------------

The users can share their Templates with other users in their group, or with all the users in OpenNebula. See the :ref:`Managing Permissions documentation <chmod>` for more information.

Let's see a quick example. To share the Template 0 with users in the group, the **USE** right bit for **GROUP** must be set with the **chmod** command:

.. prompt:: text $ auto

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    $ onetemplate chmod 0 640

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

The following command allows users in the same group **USE** and **MANAGE** the Template, and the rest of the users **USE** it:

.. prompt:: text $ auto

    $ onetemplate chmod 0 664

    $ onetemplate show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : um-
    OTHER          : u--

The ``onetemplate chmod --recursive`` option will perform the chmod action also on each one of the Images used in the Template disks.

Sunstone offers an "alias" for ``onetemplate chmod --recursive 640``, the share action:

|sunstone_template_share|

Managing VM Templates with Sunstone
================================================================================

Sunstone exposes the above functionality in the Templates > VM Templates tab:

|sunstone_template_create|


Operating System Profiles
================================================================================

In Sunstone you can quickly flavor a VM template by using a Operating System Profile, which will pre-fill part of the template for you. By default Sunstone ships with a default "Windows Optimized" profile which contains some basic windows specific optimization settings.

.. _define_os_profile:

Defining a Profile
------------------------------------

1. **Navigate to the profiles directory**

   By default found in ``etc/one/fireedge/sunstone/profiles``.

2. **Create a new YAML file**

   Name your profile by defining a new ``.yaml`` file

   .. note:: The filename is used to identify the profile in Sunstone. The filename is sentence cased and all ``_`` characters are displayed as spaces. For example ``windows_optimized.yaml`` becomes ``Windows Optimized``.

3. **Configure the profile**

   Define the profile according to the :ref:`Operating System Profiles schema <os_profile_schema>`.

   .. important:: All values are case-sensitive


   Here's an example of a profile that fills in the name of the VM template, the CPU & memory configuration and sets up the backup strategy.

   .. code-block:: yaml

      ---
      # basic_profile.yaml
      "General":
        NAME: "Example profile"
        CPU: 4
        VCPU: 4
        MEMORY: 8
        MEMORYUNIT: "GB"

      "Advanced options":
        Backup:
          BACKUP_CONFIG:
           MODE: "INCREMENT"
           INCREMENT_MODE: "CBT"
           BACKUP_VOLATILE: "Yes"
           FS_FREEZE: "AGENT"
           KEEP_LAST: 7


   The profile can then be saved and accessed in Sunstone from the first step in the VM Templates Create/Update dialog:

   |os_profile_selector|


.. important:: Sunstone also ships with a ``base.template`` file (found in the default profiles directory), which includes examples for majority of the inputs for a VM template. This base template should only be used as a reference when creating new profiles and not directly used as-is.


Profile Chain Loading
---------------------

It's also possible to chain-load profiles by referencing one profile from another. This allows you to more efficiently combine snippets of profiles together, combining different optimizations for specialized use cases.

Take for example, the default windows profile that ships with Sunstone:

.. code-block:: yaml

   ---
   # Windows profile
   "General":
     NAME: "Optimized Windows Profile"

   "Advanced options":
     OsCpu:
       OS:
         ARCH: X86_64
         SD_DISK_BUS: scsi
         MACHINE: host-passthrough
         FIRMWARE: BIOS
       FEATURES:
         ACPI: "Yes"
         PAE: "Yes"
         APIC: "Yes"
         HYPERV: "Yes"
         LOCALTIME: "Yes"
         GUEST_AGENT: "Yes"
         VIRTIO_SCSI_QUEUES: "auto"
         VIRTIO_BLK_QUEUES: "auto"
         # IOTHREADS:
       CPU_MODEL:
         MODEL: "host-passthrough"
           # FEATURES:
           # - Tunable depending on host CPU support
           # -
       RAW:
         DATA: |-
           <features>
             <hyperv>
               <evmcs state='off'/>
               <frequencies state='on'/>
               <ipi state='on'/>
               <reenlightenment state='off'/>
               <relaxed state='on'/>
               <reset state='off'/>
               <runtime state='on'/>
               <spinlocks state='on' retries='8191'/>
               <stimer state='on'/>
               <synic state='on'/>
               <tlbflush state='on'/>
               <vapic state='on'/>
               <vpindex state='on'/>
             </hyperv>
           </features>
           <clock offset='utc'>
             <timer name='hpet' present='no'/>
             <timer name='hypervclock' present='yes'/>
             <timer name='pit' tickpolicy='delay'/>
             <timer name='rtc' tickpolicy='catchup'/>
           </clock>
         VALIDATE: "Yes"


Now say you want to combine this profile with the ``basic profile`` from the :ref:`previous section <define_os_profile>`. Then you just add the ``OS_PROFILE`` attribute to the basic profile's configuration and reference the other profile from it:

.. note:: The ``OS_PROFILE`` value being referenced should match the one on disk exactly, excluding the ``.yaml`` extension


.. code-block:: yaml

   ---
   # basic_profile.yaml
   "General":
     NAME: "Example profile"
     OS_PROFILE: "windows_optimized"
     CPU: 4
     VCPU: 4
     MEMORY: 8
     MEMORYUNIT: "GB"

   "Advanced options":
     Backup:
       BACKUP_CONFIG:
        MODE: "INCREMENT"
        INCREMENT_MODE: "CBT"
        BACKUP_VOLATILE: "Yes"
        FS_FREEZE: "AGENT"
        KEEP_LAST: 7


Sunstone now sequentially loads each profile and applies them on top of each other. This means that if two fields modify the same values, e.g., ``NAME``, the last profile to modify that field will be used.

|chain_loaded_profiles|


.. _os_profile_schema:

Profiles Schema
---------------------------------------------

.. note:: All parent attributes are annotated in **bold** and child attributes are prefixed with a `→` depending on their level.


General Configuration
-----------------------------------------------------------------------------------------------------------------------------------

+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| Field Name                | Type              | Description                                        | Allowed Values             |
+===========================+===================+====================================================+============================+
| NAME                      | string            | Template name                                      | Any string                 |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| LOGO                      | string            | Logo path                                          | Any valid path or URL,     |
|                           |                   |                                                    | e.g.,                      |
|                           |                   |                                                    | "images/logos/linux.png"   |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| HYPERVISOR                | string            | Type of hypervisor used                            | "kvm", "lxc", "qemu"       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| DESCRIPTION               | string            | Description of the configuration                   | Any string                 |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| VROUTER                   | boolean           | Specifies if it's a virtual router                 | "Yes", "No"                |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| OS_PROFILE                | string            | Operating system profile                           | Any string                 |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| AS_GID                    | string            | Instantiate as Group ID                            | Any valid group ID         |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| AS_UID                    | string            | Instantiate as User ID                             | Any valid user ID          |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORY_SLOTS              | number            | Number of memory slots                             | Any positive integer       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORY_RESIZE_MODE        | string            | Mode for resizing memory                           | "BALLOONING", "HOTPLUG"    |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORY_MAX                | number            | Maximum memory allocation                          | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORYUNIT                | string            | Memory measurement unit                            | "MB", "GB", "TB"           |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| VCPU_MAX                  | number            | Maximum number of virtual CPUs                     | Any positive integer       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| VCPU                      | number            | Number of virtual CPUs allocated                   | Any positive integer       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| CPU                       | number            | Number of CPUs allocated                           | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORY                    | number            | Amount of memory allocated                         | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| DISK_COST                 | number            | Cost associated with disk usage                    | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| CPU_COST                  | number            | Cost associated with CPU usage                     | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| MEMORY_COST               | number            | Cost associated with memory usage                  | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **MODIFICATION**          |                   | **Resource Modification Settings**                 |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **VCPU**                  |                   |                                                    |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → max                     | number            | Maximum value for virtual CPUs                     | Any positive integer       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → min                     | number            | Minimum value for virtual CPUs                     | Any positive integer       |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → options                 | array             | Options for virtual CPUs                           | List of options            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → type                    | string            | Type of virtual CPUs modification                  | "Any value", "fixed",      |
|                           |                   |                                                    | "list", "range"            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **CPU**                   |                   |                                                    |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → max                     | number            | Maximum value for CPUs                             | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → min                     | number            | Minimum value for CPUs                             | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → options                 | array             | Options for CPUs                                   | List of options            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → type                    | string            | Type of CPUs modification                          | "Any value", "fixed",      |
|                           |                   |                                                    | "list", "range"            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **MEMORY**                |                   |                                                    |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → max                     | number            | Maximum memory allocation                          | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → min                     | number            | Minimum memory allocation                          | Any positive number        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → options                 | array             | Options for memory                                 | List of options            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → type                    | string            | Type of memory modification                        | "Any value", "fixed",      |
|                           |                   |                                                    | "list", "range"            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **HOT_RESIZE**            |                   | **Hot Resize Configuration**                       |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → CPU_HOT_ADD_ENABLED     | boolean           | Enables hot-add functionality for CPU              | "Yes", "No"                |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → MEMORY_HOT_ADD_ENABLED  | boolean           | Enables hot-add functionality for memory           | "Yes", "No"                |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| **VMGROUP**               |                   | **Virtual Machine Group Settings**                 |                            |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → ROLE                    | string            | Role within the VM group                           | Any role identifier        |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+
| → VMGROUP_ID              | string            | Identifier for the VM group                        | Any valid VM group ID      |
+---------------------------+-------------------+----------------------------------------------------+----------------------------+


Advanced Options
---------------------------------------------------------------------------------------------------------------------------

All configuration options are grouped by tab.


Storage Configuration
---------------------------------------------------------------------------------------------------------------------------

+-------------------------------+---------------+---------------------------------------------+---------------------------+
| Field Name                    | Type          | Description                                 | Allowed Values            |
+===============================+===============+=============================================+===========================+
| **Storage**                   |               | **Storage Configuration**                   |                           |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| **→ DISK**                    | array         | List of disk configurations                 |                           |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ NAME                       | string        | Disk identifier                             | Any string (e.g.,         |
|                               |               |                                             | "DISK1", "DISK2")         |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ CACHE                      | string        | Cache mode                                  | "default", "unsafe",      |
|                               |               |                                             | "writethrough",           |
|                               |               |                                             | "writeback",              |
|                               |               |                                             | "directsync"              |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TARGET                     | string        | Target device                               | Any string (e.g., "sdc")  |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ DEV_PREFIX                 | string        | Device prefix (BUS)                         | "vd", "sd", "hd",         |
|                               |               |                                             | "xvd", "custom"           |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ DISCARD                    | string        | Discard mode                                | "ignore", "unmap"         |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ IMAGE                      | string        | Name of the image                           | Any string,               |
|                               |               |                                             | should match the image ID |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ IMAGE_ID                   | number        | ID of the image                             | Any positive integer,     |
|                               |               |                                             | should match the image    |
|                               |               |                                             | name                      |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ IO                         | string        | IO policy                                   | "native", "threads",      |
|                               |               |                                             | "io_uring"                |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ IOTHREADS                  | number        | Number of IO threads                        | Any positive integer      |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READONLY                   | boolean       | Read-only flag                              | "Yes", "No"               |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_BYTES_SEC             | number        | Read bytes per second                       | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_BYTES_SEC_MAX         | number        | Max read bytes per second                   | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_BYTES_SEC_MAX_LENGTH  | number        | Time period for max read bytes/sec          | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_IOPS_SEC              | number        | Read IO operations per second               | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_IOPS_SEC_MAX          | number        | Max read IO operations per second           | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ READ_IOPS_SEC_MAX_LENGTH   | number        | Time period for max read IOPS/sec           | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ RECOVERY_SNAPSHOT_FREQ     | number        | Snapshot frequency for recovery             | Any positive integer      |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ SIZE                       | number        | Size of the disk in MB                      | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ SIZE_IOPS_SEC              | number        | Size of IO operations per second            | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_BYTES_SEC            | number        | Total bytes per second                      | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_BYTES_SEC_MAX        | number        | Max total bytes per second                  | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_BYTES_SEC_MAX_LENGTH | number        | Time period for max total bytes/sec         | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_IOPS_SEC             | number        | Total IO operations per second              | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_IOPS_SEC_MAX         | number        | Max total IO operations per second          | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ TOTAL_IOPS_SEC_MAX_LENGTH  | number        | Time period for max total IOPS/sec          | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_BYTES_SEC            | number        | Write bytes per second                      | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_BYTES_SEC_MAX        | number        | Max write bytes per second                  | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_BYTES_SEC_MAX_LENGTH | number        | Time period for max write bytes/sec         | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_IOPS_SEC             | number        | Write IO operations per second              | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_IOPS_SEC_MAX         | number        | Max write IO operations per second          | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+
| →→ WRITE_IOPS_SEC_MAX_LENGTH  | number        | Time period for max write IOPS/sec          | Any positive number       |
+-------------------------------+---------------+---------------------------------------------+---------------------------+

Network Configuration
-------------------------------------------------------------------------------------------------------------------------------------------

.. note:: NICs are configured under ``Network→NIC`` and PCI devices under ``Network→PCI``

+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| Field Name                         | Type          | Description                                           | Allowed Values             |
+====================================+===============+=======================================================+============================+
| **Network**                        |               | **Network Configuration**                             |                            |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| **→ NIC | PCI**                    | array         | List of NIC or PCI configurations                     |                            |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ NAME                            | string        | Name of the network interface                         | Any string                 |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ GATEWAY                         | string        | Default gateway                                       | Valid IPv4 address         |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ GATEWAY6                        | string        | Default IPv6 gateway                                  | Valid IPv6 address         |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ GUEST_MTU                       | number        | Guest MTU setting                                     | Any number (e.g., 1500)    |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ INBOUND_AVG_BW                  | number        | Inbound average bandwidth                             | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ INBOUND_PEAK_BW                 | number        | Inbound peak bandwidth                                | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ INBOUND_PEAK_KB                 | number        | Inbound peak kilobytes                                | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ IP                              | string        | IP address                                            | Valid IPv4 address         |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ IP6                             | string        | IPv6 address                                          | Valid IPv6 address         |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ IP6_METHOD                      | string        | IPv6 configuration method                             | "auto", "dhcp", "static"   |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ MAC                             | string        | MAC address                                           | Valid MAC address          |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ METHOD                          | string        | IP configuration method                               | "auto", "dhcp", "static"   |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ MODEL                           | string        | Model of the network interface                        | Any string                 |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ NETWORK_ADDRESS                 | string        | Network address                                       | Valid network address      |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ NETWORK_MASK                    | string        | Network mask                                          | Valid subnet mask          |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ NETWORK_MODE                    | string        | Network mode                                          | "auto", "manual", etc.     |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ OUTBOUND_AVG_BW                 | number        | Outbound average bandwidth                            | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ OUTBOUND_PEAK_BW                | number        | Outbound peak bandwidth                               | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ OUTBOUND_PEAK_KB                | number        | Outbound peak kilobytes                               | Any positive number        |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ PCI_TYPE                        | string        | PCI type                                              | "NIC", "PCI", "emulated"   |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP                             | boolean       | Enable RDP                                            | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_DISABLE_AUDIO               | boolean       | Disable RDP audio                                     | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_DISABLE_BITMAP_CACHING      | boolean       | Disable RDP bitmap caching                            | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_DISABLE_GLYPH_CACHING       | boolean       | Disable RDP glyph caching                             | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_DISABLE_OFFSCREEN_CACHING   | boolean       | Disable RDP offscreen caching                         | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_AUDIO_INPUT          | boolean       | Enable RDP audio input                                | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_DESKTOP_COMPOSITION  | boolean       | Enable desktop composition in RDP                     | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_FONT_SMOOTHING       | boolean       | Enable font smoothing in RDP                          | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_FULL_WINDOW_DRAG     | boolean       | Enable full window drag in RDP                        | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_MENU_ANIMATIONS      | boolean       | Enable menu animations in RDP                         | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_THEMING              | boolean       | Enable theming in RDP                                 | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_ENABLE_WALLPAPER            | boolean       | Enable wallpaper in RDP                               | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_RESIZE_METHOD               | string        | RDP resize method                                     | "display-update",          |
|                                    |               |                                                       | "reconnect"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ RDP_SERVER_LAYOUT               | string        | RDP server keyboard layout                            | e.g., "en-us-qwerty"       |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ SSH                             | string        | Enable SSH                                            | "Yes", "No"                |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ VIRTIO_QUEUES                   | number        | Number of VirtIO queues                               | Any positive integer       |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+
| →→ *TYPE*                          | string        | Set to "NIC" or "PCI" to specify device type          | "NIC", "PCI"               |
+------------------------------------+---------------+-------------------------------------------------------+----------------------------+


OS and CPU Configuration
--------------------------------------------------------------------------------------------------------------------------

+-------------------------------+---------------+-------------------------------------------+----------------------------+
| Field Name                    | Type          | Description                               | Allowed Values             |
+===============================+===============+===========================================+============================+
| **OsCpu**                     |               | **OS and CPU  Configuration**             |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→OS**                       |               | Operating System configuration            |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ ARCH                       | string        | Architecture                              | "x86_64", "i686"           |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ SD_DISK_BUS                | string        | SD disk bus type                          | "scsi", "sata"             |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ MACHINE                    | string        | Machine type                              | Dependent on host support  |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ FIRMWARE                   | string        | Firmware type                             | "BIOS", "UEFI" & host      |
|                               |               |                                           | supported e.g.,            |
|                               |               |                                           | "/usr/share/AAVMF/         |
|                               |               |                                           | AAVMF_CODE.fd"             |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ BOOT                       | string        | Boot device order                         | Comma-separated list       |
|                               |               |                                           | e.g., "disk0,disk1,nic0"   |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ KERNEL                     | string        | Kernel image path                         | Any valid path             |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ KERNEL_DS                  | string        | Kernel file reference                     | e.g., $FILE[IMAGE_ID=123]  |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ INITRD                     | string        | Initrd image path                         | Any valid path             |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ INITRD_DS                  | string        | Initrd file reference                     | e.g., $FILE[IMAGE_ID=456]  |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ ROOT                       | string        | Root device identifier                    | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ FIRMWARE_SECURE            | boolean       | Enable secure firmware                    | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ KERNEL_CMD                 | string        | Kernel command-line parameters            | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ BOOTLOADER                 | string        | OS bootloader                             | Any valid path             |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ UUID                       | string        | Operating system UUID                     | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→FEATURES**                 |               | **Virtualization Features**               |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ ACPI                       | boolean       | ACPI setting                              | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ PAE                        | boolean       | PAE setting                               | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ APIC                       | boolean       | APIC setting                              | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ HYPERV                     | boolean       | Enable Hyper-V features                   | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ LOCALTIME                  | boolean       | Synchronize guest time with host          | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ GUEST_AGENT                | boolean       | Enable guest agent                        | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ VIRTIO_SCSI_QUEUES         | string        | Virtio SCSI queues configuration          | "auto" or positive integer |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ VIRTIO_BLK_QUEUES          | string        | Virtio block queues configuration         | "auto" or positive integer |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ IOTHREADS                  | number        | Number of IO threads                      | Any positive integer       |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→CPU_MODEL**                |               | **CPU Model Configuration**               |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ MODEL                      | string        | Specific CPU model                        | "host-passthrough",        |
|                               |               |                                           | "core2duo", etc.           |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ FEATURES                   | array         | CPU model features                        | List of features           |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→RAW**                      |               | **Raw Configuration Data**                |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ TYPE                       | string        | Type of raw data                          | "kvm", "qemu"              |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ DATA                       | string        | Raw configuration data                    | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ VALIDATE                   | boolean       | Validate raw data against libvirt schema  | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+


PCI Configuration
--------------------------------------------------------------------------------------------------------------------------

+-------------------------------+---------------+-------------------------------------------+----------------------------+
| Field Name                    | Type          | Description                               | Allowed Values             |
+===============================+===============+===========================================+============================+
| **PciDevices**                |               | **PCI Device Configuration**              |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→PCI**                      | array         | PCI Configuration                         |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ NAME                       | string        | PCI device identifier                     | PCI + ID, e.g., PCI1, PCI2 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ CLASS                      | string        | PCI class code of the device              | Hexadecimal string         |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ DEVICE                     | string        | PCI device ID                             | Hexadecimal string         |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ VENDOR                     | string        | PCI vendor ID                             | Hexadecimal string         |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ SHORT_ADDRESS              | string        | PCI address of the device                 | Hexadecimal string         |
+-------------------------------+---------------+-------------------------------------------+----------------------------+


Input/Output Configuration
--------------------------------------------------------------------------------------------------------------------------

+-------------------------------+---------------+-------------------------------------------+----------------------------+
| Field Name                    | Type          | Description                               | Allowed Values             |
+===============================+===============+===========================================+============================+
| **InputOutput**               |               | **Input/Output Configuration**            |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→ VIDEO**                   |               | **Video Configuration**                   |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ TYPE                       | string        | Type of video device                      | "auto", "cirrus", "none",  |
|                               |               |                                           | "vga", "virtio"            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ VRAM                       | number        | Video RAM allocation in KB                | Any positive integer       |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ RESOLUTION                 | string        | Video resolution                          | e.g., "1280x720"           |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ IOMMU                      | boolean       | Enable IOMMU support                      | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ ATS                        | boolean       | Enable Address Translation Service        | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→ INPUT**                   | array         | **Input Device Configurations**           |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ BUS                        | string        | Bus type for input device                 | "ps2", "usb"               |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ TYPE                       | string        | Type of input device                      | "mouse", "tablet"          |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| **→ GRAPHICS**                |               | **Graphics Configuration**                |                            |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ TYPE                       | string        | Type of graphics interface                | "VNC"                      |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ LISTEN                     | string        | Graphics listen address                   | Valid IP address or        |
|                               |               |                                           | hostname                   |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ PORT                       | string        | Graphics access port                      | Any valid port number      |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ KEYMAP                     | string        | Keymap configuration                      | e.g., "en-us"              |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ PASSWD                     | string        | Graphics access password                  | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ RANDOM_PASSWD              | boolean       | Use random password for graphics access   | "Yes", "No"                |
+-------------------------------+---------------+-------------------------------------------+----------------------------+
| →→ COMMAND                    | string        | Custom graphics command                   | Any string                 |
+-------------------------------+---------------+-------------------------------------------+----------------------------+


Context Configuration
---------------------------------------------------------------------------------------------------------------------

+----------------------------+---------------+------------------------------------------+---------------------------+
| Field Name                 | Type          | Description                              | Allowed Values            |
+============================+===============+==========================================+===========================+
| **Context**                |               | **Contextualization Configuration**      |                           |
+----------------------------+---------------+------------------------------------------+---------------------------+
| **→ CONTEXT**              | mapping       | **Context Variables**                    |                           |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ SSH_PUBLIC_KEY          | string        | SSH public key for the VM                | Any string e.g.,          |
|                            |               |                                          | "$USER[SSH_PUBLIC_KEY]"   |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ START_SCRIPT            | string        | Start script content (plain or base64)   | Any string                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ NETWORK                 | string        | Include network context                  | "Yes", "No"               |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ TOKEN                   | string        | Include authentication token             | "Yes", "No"               |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ REPORT_READY            | string        | Report readiness to the system           | "Yes", "No"               |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ INIT_SCRIPTS            | array         | Initialization scripts                   | List of script names      |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ FILES_DS                | string        | Files from datastore (space-separated)   | Any string                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ Custom Context Variables| mapping       | User-defined context variables           | e.g., CUSTOM_VAR: "123"   |
+----------------------------+---------------+------------------------------------------+---------------------------+
| **→ USER_INPUTS**          | array         | **Array of User Input Definitions**      |                           |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ name                    | string        | Name of the user input                   | Any string                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ mandatory               | boolean       | Whether the input is mandatory           | true, false               |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ type                    | string        | Type of the input                        | "password", "list",       |
|                            |               |                                          | "listMultiple", "number", |
|                            |               |                                          | "numberFloat", "range",   |
|                            |               |                                          | "rangeFloat", "boolean"   |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ label                   | string        | Label or description of the input        | Any string                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ options                 | array         | List of options for selection inputs     | List of strings           |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ default                 | string        | Default value of the input               | Any string                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ min                     | string        | Minimum value (for numeric inputs)       | Any number                |
+----------------------------+---------------+------------------------------------------+---------------------------+
| →→ max                     | string        | Maximum value (for numeric inputs)       | Any number                |
+----------------------------+---------------+------------------------------------------+---------------------------+


Scheduled Actions Configuration
----------------------------------------------------------------------------------------------------------------------------

+-------------------------------+---------------+---------------------------------------------+----------------------------+
| Field Name                    | Type          | Description                                 | Allowed Values             |
+===============================+===============+=============================================+============================+
| **ScheduledAction**           |               | **Scheduled Actions Configuration**         |                            |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| **→ SCHEDULED_ACTION**        | array         | Array of scheduled action definitions       |                            |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ NAME                       | string        | Name of the scheduled action                | Any string                 |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ ACTION                     | string        | Action to be performed                      |  "backup", "terminate"     |
|                               |               |                                             |  "terminate-hard",         |
|                               |               |                                             |  "undeploy",               |
|                               |               |                                             |  "undeploy-hard","hold",   |
|                               |               |                                             |  "release","stop",         |
|                               |               |                                             |  "suspend","resume",       |
|                               |               |                                             |  "reboot","reboot-hard",   |
|                               |               |                                             |  "poweroff",               |
|                               |               |                                             |  "poweroff-hard",          |
|                               |               |                                             |  "snapshot-create",        |
|                               |               |                                             |  "snapshot-revert",        |
|                               |               |                                             |  "snapshot-delete",        |
|                               |               |                                             |  "disk-snapshot-create",   |
|                               |               |                                             |  "disk-snapshot-rename",   |
|                               |               |                                             |  "disk-snapshot-revert"    |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ ARGS                       | string        | Arguments for the action                    | Depends on ACTION          |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ TIME                       | number        | Scheduled time in Unix timestamp            | Positive integer           |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ REPEAT                     | string        | Type of repetition                          | `0`: weekly                |
|                               |               |                                             | `1`: monthly               |
|                               |               |                                             | `2`: yearly                |
|                               |               |                                             | `3`: hourly                |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ DAYS                       | string        | Days of the week for repeating actions      | Comma-separated list of    |
|                               |               |                                             | numbers (0 to 6)           |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ END_TYPE                   | string        | Type of end condition                       | `0`: never                 |
|                               |               |                                             | `1`: repetition            |
|                               |               |                                             | `2`: date                  |
+-------------------------------+---------------+---------------------------------------------+----------------------------+
| →→ END_VALUE                  | number        | Value associated with END_TYPE              | Depends on END_TYPE        |
+-------------------------------+---------------+---------------------------------------------+----------------------------+


Placement Configuration
----------------------------------------------------------------------------------------------------------------------

+---------------------------+---------------+-------------------------------------------+----------------------------+
| Field Name                | Type          | Description                               | Allowed Values             |
+===========================+===============+===========================================+============================+
| **Placement**             |               | **Placement Configuration**               |                            |
+---------------------------+---------------+-------------------------------------------+----------------------------+
| → SCHED_DS_RANK           | string        | Datastore scheduling rank expression      | "FREE_MB", "-FREE_MB"      |
+---------------------------+---------------+-------------------------------------------+----------------------------+
| → SCHED_DS_REQUIREMENTS   | string        | Datastore scheduling requirements         | Expression string          |
+---------------------------+---------------+-------------------------------------------+----------------------------+
| → SCHED_RANK              | string        | Host scheduling rank expression           | "FREE_CPU", "RUNNING_VMS", |
|                           |               |                                           | "-RUNNING_VMS"             |
+---------------------------+---------------+-------------------------------------------+----------------------------+
| → SCHED_REQUIREMENTS      | string        | Host scheduling requirements              | Expression string          |
+---------------------------+---------------+-------------------------------------------+----------------------------+


NUMA Topology Configuration
----------------------------------------------------------------------------------------------------------------------

+------------------------------+---------------+----------------------------------------+----------------------------+
| Field Name                   | Type          | Description                            | Allowed Values             |
+==============================+===============+========================================+============================+
| **NUMA**                     |               | **NUMA Configuration**                 |                            |
+------------------------------+---------------+----------------------------------------+----------------------------+
| **→ TOPOLOGY**               |               | **NUMA Topology Settings**             |                            |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ CORES                     | number        | Number of cores per socket             | Any positive integer       |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ THREADS                   | number        | Number of threads per core             | Any positive integer       |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ SOCKETS                   | number        | Number of sockets                      | Any positive integer       |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ HUGEPAGE_SIZE             | string        | Size of hugepages in MB                | "2", "1024"                |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ MEMORY_ACCESS             | string        | Memory access mode                     | "private", "shared"        |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ PIN_POLICY                | string        | NUMA pinning policy                    | "NONE", "THREAD",          |
|                              |               |                                        | "SHARED", "CORE",          |
|                              |               |                                        | "NODE_AFFINITY"            |
+------------------------------+---------------+----------------------------------------+----------------------------+
| →→ NODE_AFFINITY             | string        | Preferred NUMA node(s)                 | Comma-separated list of    |
|                              |               |                                        | node IDs                   |
+------------------------------+---------------+----------------------------------------+----------------------------+


Backup Configuration
---------------------------------------------------------------------------------------------------------------------

+-----------------------------+---------------+----------------------------------------+----------------------------+
| Field Name                  | Type          | Description                            | Allowed Values             |
+=============================+===============+========================================+============================+
| **BACKUP**                  |               | **Backup Configuration**               |                            |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| **→ BACKUP_CONFIG**         |               | **Backup Settings**                    |                            |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| →→ MODE                     | string        | Backup mode                            | "FULL", "INCREMENT"        |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| →→ INCREMENT_MODE           | string        | Incremental backup method              | "CBT", "SNAPSHOT"          |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| →→ BACKUP_VOLATILE          | string        | Include volatile disks in backup       | "Yes", "No"                |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| →→ FS_FREEZE                | string        | Filesystem freeze method               | "NONE", "AGENT", "SUSPEND" |
+-----------------------------+---------------+----------------------------------------+----------------------------+
| →→ KEEP_LAST                | number        | Number of backups to keep              | Any positive integer       |
+-----------------------------+---------------+----------------------------------------+----------------------------+

.. |sunstone_template_share| image:: /images/sunstone_template_share.png
.. |sunstone_template_create| image:: /images/sunstone_template_create.png
.. |sunstone_user_inputs_no_convention| image:: /images/sunstone_user_inputs_no_convention.png
.. |sunstone_user_inputs_convention_blog| image:: /images/sunstone_user_inputs_convention_blog.png
.. |sunstone_user_inputs_convention_mysql_1| image:: /images/sunstone_user_inputs_convention_mysql_1.png
.. |sunstone_user_inputs_convention_mysql_2| image:: /images/sunstone_user_inputs_convention_mysql_2.png
.. |sunstone_user_inputs_metadata_1| image:: /images/sunstone_user_inputs_metadata_1.png
.. |sunstone_user_inputs_metadata_2| image:: /images/sunstone_user_inputs_metadata_2.png
.. |os_profile_selector| image:: /images/os_profile_selector.png
.. |chain_loaded_profiles| image:: /images/os_profile_chain_loaded.png
