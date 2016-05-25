.. _vm_guide:

================================================================================
Managing Virtual Machine Templates
================================================================================

In OpenNebula the Virtual Machines are defined with VM Templates. This section explains **how to describe the wanted-to-be-ran Virtual Machine, and how users typically interact with the system**.

The VM Template Pool allows OpenNebula administrators and users to register Virtual Machine definitions in the system, to be instantiated later as Virtual Machine instances. These Templates can be instantiated several times, and also shared with other users.

Virtual Machine Model
================================================================================

A Virtual Machine within the OpenNebula system consists of:

-  A capacity in terms memory and CPU
-  A set of NICs attached to one or more virtual networks
-  A set of disk images
-  Optional attributes like the booting order, context information, etc.

.. _vm_guide_defining_a_vm_in_3_steps:

Defining a VM
================================================================================

Virtual Machines are defined in an OpenNebula Template. Templates are stored in the system to easily browse and instantiate VMs from them. To create a new Template you have to define 3 things

Capacity & Name
--------------------------------------------------------------------------------

+------------+-----------------------------------------------------+-----------+------------+
| Attribute  |                     Description                     | Mandatory |  Default   |
+============+=====================================================+===========+============+
| ``NAME``   | Name that the VM will get for description purposes. | Yes       | one-<vmid> |
+------------+-----------------------------------------------------+-----------+------------+
| ``MEMORY`` | Amount of RAM required for the VM, in Megabytes.    | Yes       |            |
+------------+-----------------------------------------------------+-----------+------------+
| ``CPU``    | CPU ratio (e..g half a physical CPU is 0.5).        | Yes       |            |
+------------+-----------------------------------------------------+-----------+------------+
| ``VCPU``   | Number of virtual cpus.                             | No        | 1          |
+------------+-----------------------------------------------------+-----------+------------+

Disks
--------------------------------------------------------------------------------

Each disk is defined with a DISK attribute. A VM can use three types of disk:

* **Use a persistent Image**: changes to the disk image will persist after the VM is terminated.
* **Use a non-persistent Image**: a copy of the source Image is used, changes made to the VM disk will be lost.
* **Volatile**: disks are created on the fly on the target host. After the VM is terminated the disk is disposed.

Disks Using an Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can set the Image ID directly, or use the Image name. Optionally, if the Image is not owned by the user instantiating the Template, you can set the owner user's ID or name.

+-----------------+----------------------------------------------+-----------------------------+---------+
|    Attribute    |                 Description                  |          Mandatory          | Default |
+=================+==============================================+=============================+=========+
| ``IMAGE_ID``    | The ID of the image                          | Yes (if IMAGE not given)    |         |
+-----------------+----------------------------------------------+-----------------------------+---------+
| ``IMAGE``       | The ID or Name of the image                  | Yes (if IMAGE_ID not given) |         |
+-----------------+----------------------------------------------+-----------------------------+---------+
| ``IMAGE_UID``   | Select the IMAGE of a given user by her ID   | No                          | self    |
+-----------------+----------------------------------------------+-----------------------------+---------+
| ``IMAGE_UNAME`` | Select the IMAGE of a given user by her NAME | No                          | self    |
+-----------------+----------------------------------------------+-----------------------------+---------+

Volatile
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. todo:: review this table

+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+---------+
| Attribute  |                                                                           Description                                                                           | Mandatory | Default |
+============+=================================================================================================================================================================+===========+=========+
| ``TYPE``   | Type of the disk: ``swap``, ``fs``. ``swap`` type will set the label to ``swap`` so it is easier to mount and the context packages will automatically mount it. | Yes       |         |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+---------+
| ``SIZE``   | size in MB                                                                                                                                                      | Yes       |         |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+---------+
| ``FORMAT`` | (only for ``TYPE=fs``) ``raw`` or ``qcow2``                                                                                                                     | Yes       |         |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+---------+

Network Interfaces
--------------------------------------------------------------------------------

Each network interface of a VM is defined with the ``NIC`` attribute.


You can set the Network ID directly, or use the Network name. Optionally, if the virtual network is not owned by the user instantiating the Template, you can set the owner user's ID or name.

+-------------------+------------------------------------------------+-------------------------------+---------+
|     Attribute     |                  Description                   |           Mandatory           | Default |
+===================+================================================+===============================+=========+
| ``NETWORK_ID``    | The ID of the network                          | Yes (if NETWORK not given)    |         |
+-------------------+------------------------------------------------+-------------------------------+---------+
| ``NETWORK``       | The ID or Name of the network                  | Yes (if NETWORK_ID not given) |         |
+-------------------+------------------------------------------------+-------------------------------+---------+
| ``NETWORK_UID``   | Select the NETWORK of a given user by her ID   | No                            | self    |
+-------------------+------------------------------------------------+-------------------------------+---------+
| ``NETWORK_UNAME`` | Select the NETWORK of a given user by her NAME | No                            | self    |
+-------------------+------------------------------------------------+-------------------------------+---------+

The following example shows a VM Template file with a couple of disks and a network interface, also a VNC section was added.

.. code-block:: none

    NAME   = test-vm
    MEMORY = 128
    CPU    = 1
     
    DISK = [ IMAGE  = "Arch Linux" ]
    DISK = [ TYPE     = swap,
             SIZE     = 1024 ]
     
    NIC = [ NETWORK = "Public", NETWORK_UNAME="oneadmin" ]
     
    GRAPHICS = [
      TYPE    = "vnc",
      LISTEN  = "0.0.0.0"]

.. note:: Check the :ref:`VM definition file for a complete reference <template>`

Simple templates can be also created using the command line instead of creating a template file. For example, a similar template as the previous example can be created with the following command:

.. prompt:: text $ auto

    $ onetemplate create --name test-vm --memory 128 --cpu 1 --disk "Arch Linux" --nic Public

For a complete reference of all the available options for ``onetemplate create``, go to the :ref:`CLI reference <cli>`, or run ``onetemplate create -h``.

Note: OpenNebula Templates are designed to be hypervisor-agnostic, but there are additional attributes that are supported for each hypervisor. Check the :ref:`KVM configuration <kvmg>` and :ref:`vCenter configuration <vcenterg>` for more details.

Managing Templates
==================

Users can manage the VM Templates using the command ``onetemplate``, or the graphical interface :ref:`Sunstone <sunstone>`. For each user, the actual list of templates available are determined by the ownership and permissions of the templates.

.. _vm_templates_labels:

Listing Available Templates
---------------------------

You can use the ``onetemplate list`` command to check the available Templates in the system.

.. prompt:: text $ auto

    $ onetemplate list a
      ID USER     GROUP    NAME                         REGTIME
       0 oneadmin oneadmin template-0            09/27 09:37:00
       1 oneuser  users    template-1            09/27 09:37:19
       2 oneadmin oneadmin Ubuntu_server         09/27 09:37:42

To get complete information about a Template, use ``onetemplate show``.

Here is a view of templates tab in Sunstone:

|labels_edit|

Labels can be defined for most of the OpenNebula resources from the admin view. Each resource will store the labels information in its own template, thus it can be easily edited from the CLI or Sunstone. This feature enables the possibility to group the different resources under a given label and filter them in the admin and cloud views. The user will be able to easily find the template she wants to instantiate or select a set of resources to apply a given action.

|labels_filter|

The list of labels defined for each pool will be shown in the left navigation menu. After clicking on one of these labels only the resources with this label will be shown in the table. This filter is also available in the cloud view inside the virtual machine creation form to easily select a specific template.

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

Instantiating Templates
=======================

The ``onetemplate instantiate`` command accepts a Template ID or name, and creates a VM instance from the given template. You can create more than one instance simultaneously with the ``--multiple num_of_instances`` option.

.. prompt:: text $ auto

    $ onetemplate instantiate 6
    VM ID: 0

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneuser1 users    one-0        pend   0      0K                 00 00:00:16

You can also merge another template to the one being instantiated. The new attributes will be added, or will replace the ones fom the source template. This can be more convenient that cloning an existing template and updating it.

.. prompt:: text $ auto

    $ cat /tmp/file
    MEMORY = 512
    COMMENT = "This is a bigger instance"

    $ onetemplate instantiate 6 /tmp/file
    VM ID: 1

The same options to create new templates can be used to be merged with an existing one. See the :ref:`CLI reference <cli>`, or execute ``onetemplate instantiate --help`` for a complete reference.

.. prompt:: text $ auto

    $ onetemplate instantiate 6 --cpu 2 --memory 1024
    VM ID: 2

.. _vm_guide_user_inputs:

Ask for User Inputs
--------------------------------------------------------------------------------

The User Inputs functionality provides the template creator the possibility to dynamically ask the user instantiating the template dynamic values that must be defined.

A user input can be one of the following types:

* **text**: any text value
* **password**: any text value. The interface will block the input visually, but the value will be stored as plain text.
* **text64**: will be encoded in base64 before the value is passed to the VM.
* **number**: any integer number.
* **number-float**: any number.
* **range**: any integer number within the defined min..max range.
* **range-float**: any number within the defined min..max range
* **list**: the user will select from a pre-defined list of values

|prepare-tmpl-user-input-1|

The CPU, MEMORY and VCPU attributes can have a user input to define how the users will be able to modify the capacity on instantiation.

|prepare-tmpl-user-input-2|

These inputs will be presented to the user when the Template is instantiated. The VM guest needs to be :ref:`contextualized <bcont>` to make use of the values provided by the user.

|prepare-tmpl-user-input-3|

.. note:: If a VM Template with user inputs is used by a :ref:`Service Template Role <appflow_use_cli>`, the user will be also asked for these inputs when the Service is created.

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

Deployment
==========

The OpenNebula Scheduler will deploy automatically the VMs in one of the available Hosts, if they meet the requirements. The deployment can be forced by an administrator using the ``onevm deploy`` command.

Use ``onevm terminate`` to shutdown and delete a running VM.

Continue to the :ref:`Managing Virtual Machine Instances Guide <vm_guide_2>` to learn more about the VM Life Cycle, and the available operations that can be performed.

.. |labels_edit| image:: /images/labels_edit.png
.. |labels_filter| image:: /images/labels_filter.png
.. |image2| image:: /images/sunstone_template_create.png
.. |prepare-tmpl-user-input-1| image:: /images/prepare-tmpl-user-input-1.png
.. |prepare-tmpl-user-input-2| image:: /images/prepare-tmpl-user-input-2.png
.. |prepare-tmpl-user-input-3| image:: /images/prepare-tmpl-user-input-3.png
.. |sunstone_clone_template| image:: /images/sunstone_clone_template.png
.. |sunstone_template_share| image:: /images/sunstone_template_share.png

