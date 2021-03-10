.. _vm_guide:
.. _vm_templates:

================================================================================
Managing Virtual Machine Templates
================================================================================

In OpenNebula the Virtual Machines are defined with VM Templates. This section explains **how to describe the wanted-to-be-ran Virtual Machine, and how users typically interact with the system**.

The VM Template Pool allows OpenNebula administrators and users to register Virtual Machine definitions in the system, to be instantiated later as Virtual Machine instances. These Templates can be instantiated several times, and also shared with other users.

.. _vm_guide_defining_a_vm_in_3_steps:

Defining a VM
================================================================================

A Virtual Machine within the OpenNebula system consists of:

-  A capacity in terms memory and CPU
-  A set of NICs attached to one or more virtual networks
-  A set of disk images
-  Optional attributes like VNC graphics, the booting order, context information, etc.

Virtual Machines are defined in an OpenNebula Template. Templates are stored in the system to easily browse and instantiate VMs from them.

Capacity & Name
--------------------------------------------------------------------------------

|sunstone_template_create_capacity|

.. _vm_disks:

Disks
--------------------------------------------------------------------------------

Each disk is defined with a DISK attribute. A VM can use three types of disk:

* **Use a persistent Image**: changes to the disk image will persist after the VM is terminated.
* **Use a non-persistent Image**: a copy of the source Image is used, changes made to the VM disk will be lost.
* **Volatile**: disks are created on the fly on the target host. After the VM is terminated the disk is disposed.

|sunstone_template_create_image|

|sunstone_template_create_volatile|

Network Interfaces
--------------------------------------------------------------------------------

Network interfaces can be defined in two different ways:

- **Manual selection**: interfaces are attached to a pre-selected Virtual Network. Note that this may require to build multiple templates considering the available networks in each cluster.
- **Automatic selection**: Virtual networks will be scheduled like other resources needed by the VM (like hosts or datastores). This way, you can hint the type of network the VM will need and it will be automatically selected among those available in the cluster. :ref:`See more details here <vgg_vm_vnets>`.


|sunstone_template_create_nic|

Network Interfaces Alias
--------------------------------------------------------------------------------

Network interface alias allows you to have more than one IP on each network interface. This does not create a new virtual interface on the VM. The alias address is added to the network interface. An alias can be attached and detached. Note also that when a nic with an alias is detached, all the associated alias are also detached.

The alias takes a lease from the network which it belongs to. So, for the OpenNebula it is the same as a NIC and exposes the same management interface, it is just different in terms of the associated virtual network interface within the VM.

.. note:: The network of the alias can be different from the network of the nic which is alias of.

Example
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

.. note:: Check the :ref:`VM definition file for a complete reference <template>`

Simple templates can be also created using the command line instead of creating a template file. For example, a similar template as the previous example can be created with the following command:

.. prompt:: text $ auto

    $ onetemplate create --name test-vm --memory 128 --cpu 1 --disk "Arch Linux" --nic Public

For a complete reference of all the available options for ``onetemplate create``, go to the :ref:`CLI reference <cli>`, or run ``onetemplate create -h``.

Note: OpenNebula Templates are designed to be hypervisor-agnostic, but there are additional attributes that are supported for each hypervisor. Check the :ref:`KVM configuration <kvmg>` and :ref:`vCenter configuration <vcenterg>` for more details.

.. _vm_templates_custom_tags:

Other (Custom Tags)
--------------------------------------------------------------------------------

|sunstone_template_custom_tags|

This section in the Other tab is for all fields that haven't any gap in the others tabs. You can introduce others own fields into this section, this values will be saved in the resource template.
Also you can create a value of object type.

.. _vm_templates_endusers:

Preparing Templates for End-Users
================================================================================

Besides the basic VM definition attributes, you can setup extra options in your VM Template.

Customizable Capacity
--------------------------------------------------------------------------------

The capacity attributes (CPU, MEMORY, VCPU) can be modified each time a VM Template is instantiated. The Template owner can decide `if` and `how` each attribute can be customized.

|prepare-tmpl-user-input-2|

The modification options available in the drop-down are:

* **fixed**: The value cannot be modified.
* **any value**: The value can be changed to any number by the user instantiating the Template.
* **range**: Users will be offered a range slider between the given minimum and maximum values.
* **list**: Users will be offered a drop-down menu to select one of the given options.
* **list-multiple**: Users will be offered a drop-down menu to select multiple of the given options.

If you are using a template file instead of Sunstone, the modification is defined with user input attributes (:ref:`see below <vm_guide_user_inputs>`). The absence of user input is an implicit "any value". For example:

.. code-block:: bash

    CPU = "1"
    MEMORY = "2048"
    VCPU = "2"
    USER_INPUTS = [
      CPU = "M|list||0.5,1,2,4|1",
      MEMORY = "M|range||512..8192|2048" ]

.. note:: Use float types for CPU, and integer types for MEMORY and VCPU. More information in :ref:`the Template reference documentation <template_user_inputs>`.

.. note:: This capacity customization can be forced to be disabled for any Template in the cloud view. Read more in the :ref:`Cloud View Customization documentation <cloud_view_config>`.

.. _vm_guide_user_inputs:

Ask for User Inputs
--------------------------------------------------------------------------------

The User Inputs functionality provides the Template creator the possibility to dynamically ask the user instantiating the Template dynamic values that must be defined.

A user input can be one of the following types:

* **text**: any text value.
* **text64**: will be encoded in base64 before the value is passed to the VM.
* **password**: any text value. The interface will block the input visually, but the value will be stored as plain text.
* **number**: any integer number.
* **number-float**: any number.
* **range**: any integer number within the defined min..max range.
* **range-float**: any number within the defined min..max range.
* **list**: the user will select from a pre-defined list of values.
* **list-multiple**: the user will select one or more options from a predefined list of values.
* **boolean**: can be either YES or NO.

|prepare-tmpl-user-input-1|

These inputs will be presented to the user when the Template is instantiated. The VM guest needs to be :ref:`contextualized <context_overview>` to make use of the values provided by the user.

|prepare-tmpl-user-input-3|

.. note:: If a VM Template with user inputs is used by a :ref:`Service Template Role <appflow_use_cli>`, the user will be also asked for these inputs when the Service is created.

.. note:: You can use the flag ``--user-inputs ui1,ui2,ui3`` to use them in a non-interactive way.

.. _sched_actions_templ:

Scheduling Actions
--------------------------------------------------------------------------------

You can define Scheduled Actions when defining a Template and at :ref:`VM instantiation <vm_guide2_scheduling_actions>`.

Set a Cost
--------------------------------------------------------------------------------

Each VM Template can have a cost per hour. This cost is set by CPU and MEMORY MB, to allow users to change the capacity and see the cost updated accordingly. VMs with a cost will appear in the :ref:`showback reports <showback>`.

|showback_template_wizard|

See the :ref:`template file syntax here <template_showback_section>`.

.. _cloud_view_features:

Enable End User Features
--------------------------------------------------------------------------------

There are a few features of the :ref:`Cloud View <suns_views>` that will work if you configure the Template to make use of them:

* Users will see the Template logo and description, something that is not so visible in the normal admin view.
* The Cloud View gives access to the VM's VNC, but only if it is configured in the Template.
* End users can upload their public ssh key. This requires the VM guest to be :ref:`contextualized <context_overview>`, and the Template must have the ssh contextualization enabled.

|prepare-tmpl-ssh|

Make the Images Non-Persistent
--------------------------------------------------------------------------------

If a Template is meant to be consumed by end-users, its Images should not be persistent. A :ref:`persistent Image <img_guide_persistent>` can only be used by one VM simultaneously, and the next user will find the changes made by the previous user.

If the users need persistent storage, they can use the :ref:`"instantiate to persistent" functionality <vm_guide2_clone_vm>`.

Prepare the Network Interfaces
--------------------------------------------------------------------------------

End-users can select the VM network interfaces when launching new VMs. You can create templates without any NIC, or set the default ones. If the template contains any NIC, users will still be able to remove them and select new ones.

|prepare-tmpl-network|

Because users will add network interfaces, you need to define a default NIC model in case the VM guest needs a specific one (e.g. virtio for KVM). This can be done with the :ref:`NIC_DEFAULT <nic_default_template>` attribute, or through the Template wizard. Alternatively, you could change the default value for all VMs in the driver configuration file (see the :ref:`KVM one <kvmg_default_attributes>` for example).

|prepare-tmpl-nic-default|

This networking customization can be disabled for each Template. The users instantiating the Template will not be able to add, remove, or customize set NICs set by the Template owner.

|sunstone_disable_network_conf|

.. note:: This networking customization can be forced to be disabled for any Template in the cloud view. Read more in the :ref:`Cloud View Customization documentation <cloud_view_config>`.

Instantiating Templates
=======================

From Sunstone:

|sunstone_admin_instantiate|

From the CLI: the ``onetemplate instantiate`` command accepts a Template ID or name, and creates a VM instance from the given template. You can create more than one instance simultaneously with the ``--multiple num_of_instances`` option.

.. prompt:: text $ auto

    $ onetemplate instantiate 6
    VM ID: 0

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneuser1 users    one-0        pend   0      0K                 00 00:00:16

Merge Use Case
--------------

The template merge functionality, combined with the restricted attributes, can be used to allow users some degree of customization for predefined templates.

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
      IMAGE_ID = "0" ]
    NIC=[
      NETWORK_ID = "0" ]

Users can instantiate it customizing anything except the CPU, VCPU and NIC. To create a VM with different memory and disks:

.. prompt:: text $ auto

    $ onetemplate instantiate 0 --memory 1G --disk "Ubuntu 16.04"

.. warning:: The merged attributes replace the existing ones. To add a new disk, the current one needs to be added also.

.. prompt:: text $ auto

    $ onetemplate instantiate 0 --disk 0,"Ubuntu 16.04"

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

Continue to the :ref:`Managing Virtual Machine Instances Guide <vm_guide_2>` to learn more about the VM Life Cycle, and the available operations that can be performed.

.. _instantiate_as_uid_gid:

Instantiating as a user and/or group
--------------------------------------------------------------------------------

From Sunstone:

|sunstone_template_instantiate_as_uid_gid|

From the CLI: the ``onetemplate instantiate`` command accepts option ``--as_uid`` and ``--as_gid`` with the User ID or Group ID to define which will be the owner or group for the VM.

.. prompt:: text $ auto

    $ onetemplate instantiate 6 --as_uid 2 --as_gid 1
    VM ID: 0

    $ onevm list
        ID USER      GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 test_user users    one-0        pend   0      0K                 00 00:00:16

Managing Templates
==================

Users can manage the VM Templates using the command ``onetemplate``, or the graphical interface :ref:`Sunstone <sunstone>`. For each user, the actual list of templates available are determined by the ownership and permissions of the templates.

Adding and Deleting Templates
-----------------------------

Using ``onetemplate create``, users can create new Templates for private or shared use. The ``onetemplate delete`` command allows the Template owner -or the OpenNebula administrator- to delete it from the repository.

For instance, if the previous example template is written in the vm-example.txt file:

.. prompt:: text $ auto

    $ onetemplate create vm-example.txt
    ID: 6

Via Sunstone, you can easily add templates using the provided wizards (or copy/pasting a template file) and delete them clicking on the delete button:

|image2|

.. _vm_template_clone:

Cloning Templates
-----------------------------

You can also clone an existing Template with the ``onetemplate clone`` command:

.. prompt:: text $ auto

    $ onetemplate clone 6 new_template
    ID: 7

If you use the ``onetemplate clone --recursive`` option, OpenNebula will clone each one of the Images used in the Template Disks. These Images are made persistent, and the cloned template DISK/IMAGE_ID attributes are replaced to point to them.

|sunstone_clone_template|

Updating a Template
-------------------

It is possible to update a template by using the ``onetemplate update``. This will launch the editor defined in the variable ``EDITOR`` and let you edit the template.

.. prompt:: text $ auto

    $ onetemplate update 3

Sharing Templates
--------------------

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


.. |image2| image:: /images/sunstone_template_create.png
.. |prepare-tmpl-user-input-1| image:: /images/prepare-tmpl-user-input-1.png
.. |prepare-tmpl-user-input-2| image:: /images/prepare-tmpl-user-input-2.png
.. |prepare-tmpl-user-input-3| image:: /images/prepare-tmpl-user-input-3.png
.. |sunstone_clone_template| image:: /images/sunstone_clone_template.png
.. |sunstone_template_share| image:: /images/sunstone_template_share.png
.. |prepare-tmpl-network| image:: /images/prepare-tmpl-network.png
.. |prepare-tmpl-nic-default| image:: /images/prepare-tmpl-nic-default.png
.. |prepare-tmpl-ssh| image:: /images/prepare-tmpl-ssh.png
.. |showback_template_wizard| image:: /images/showback_template_wizard.png
.. |sunstone_template_create_capacity| image:: /images/sunstone_template_create_capacity.png
.. |sunstone_template_create_image| image:: /images/sunstone_template_create_image.png
.. |sunstone_template_create_nic| image:: /images/sunstone_template_create_nic.png
.. |sunstone_template_create_volatile| image:: /images/sunstone_template_create_volatile.png
.. |sunstone_disable_network_conf| image:: /images/sunstone_disable_network_conf.png
.. |sunstone_admin_instantiate| image:: /images/sunstone_admin_instantiate.png
.. |sunstone_template_custom_tags| image:: /images/custom_tags.png
.. |sunstone_template_instantiate_as_uid_gid| image:: /images/instantiate_as_uid_gid.png
