=========================
Creating Virtual Machines
=========================

In OpenNebula the Virtual Machines are defined with Template files. This
guide explains **how to describe the wanted-to-be-ran Virtual Machine,
and how users typically interact with the system**.

The Template Repository system allows OpenNebula administrators and
users to register Virtual Machine definitions in the system, to be
instantiated later as Virtual Machine instances. These Templates can be
instantiated several times, and also shared with other users.

Virtual Machine Model
=====================

A Virtual Machine within the OpenNebula system consists of:

-  A capacity in terms memory and CPU
-  A set of NICs attached to one or more virtual networks
-  A set of disk images
-  A state file (optional) or recovery file, that contains the memory
image of a running VM plus some hypervisor specific information.

The above items, plus some additional VM attributes like the OS kernel
and context information to be used inside the VM, are specified in a
template file.

Defining a VM in 3 Steps
========================

Virtual Machines are defined in an OpenNebula Template. Templates are
stored in a repository to easily browse and instantiate VMs from them.
To create a new Template you have to define 3 things

-  **Capacity & Name**, how big will the VM be?

+--------------+-------------------------------------------------------+-------------+--------------+
| Attribute    | Description                                           | Mandatory   | Default      |
+==============+=======================================================+=============+==============+
| **NAME**     | Name that the VM will get for description purposes.   | Yes         | one-<vmid>   |
+--------------+-------------------------------------------------------+-------------+--------------+
| **MEMORY**   | Amount of RAM required for the VM, in Megabytes.      | Yes         | -            |
+--------------+-------------------------------------------------------+-------------+--------------+
| **CPU**      | CPU ratio (e..g half a physical CPU is 0.5).          | Yes         | -            |
+--------------+-------------------------------------------------------+-------------+--------------+
| **VCPU**     | Number of virtual cpus.                               | No          | 1            |
+--------------+-------------------------------------------------------+-------------+--------------+

-  **Disks**. Each disk is defined with a DISK attribute. A VM can use
three types of disk:

-  **Use a persistent Image** changes to the disk image will persist
after the VM is shutdown.
-  **Use a non-persistent Image** images are cloned, changes to the
image will be lost.
-  **Volatile** disks are created on the fly on the target host.
After the VM is shutdown the disk is disposed.

DISK Attribute

Description

Mandatory

Default

Persistent and Clone Disks

**IMAGE\_ID**

The ID or Name of the image in the datastore

Yes

-

**IMAGE**

**IMAGE\_UID**

Select the IMAGE of a given user by her ID

No

self

**IMAGE\_UNAME**

Select the IMAGE of a given user by her NAME

No

self

Volatile

**TYPE**

Type of the disk:\ ``swap``, ``fs``. ``swap`` type will set the label to
``swap`` so it is easier to mount and the context packages will
automatically mount it.

Yes (for volatile)

-

**SIZE**

size in MB

Yes

-

**FORMAT**

filesystem for **fs** images: ``ext2``, ``ext3``, etc. ``raw`` will not
format the image. For VMs to run on ``vmfs`` or ``vmware shared``
configurations, the valid values are: ``vmdk_thin``,
``vmdk_zeroedthick``, ``vmdk_eagerzeroedthick``

Yes (for fs)

-  **Network Interfaces**. Each network interface of a VM is defined
with the ``NIC`` attribute.

NIC Attribute

Description

Mandatory

Default

**NETWORK\_ID**

The ID or Name of the network to attach this NIC

Yes

-

**NETWORK**

**NETWORK\_UID**

Select the NETWORK of a given user by her ID

No

self

**NETWORK\_UNAME**

Select the NETWORK of a given user by her NAME

No

self

The following example shows a VM Template file with a couple of disks
and a network interface, also a VNC section was added.

.. code:: code

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

Simple templates can be also created using the command line instead of
creating a template file. The parameters to do this for ``onetemplate``
are:

+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Parameter                    | Description                                                                                                                                                                                                     |
+==============================+=================================================================================================================================================================================================================+
| ``âname name``             | Name for the VM                                                                                                                                                                                                 |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âcpu cpu``               | CPU percentage reserved for the VM (1=100% one CPU)                                                                                                                                                             |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âvcpu vcpu``             | Number of virtualized CPUs                                                                                                                                                                                      |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âarch arch``             | Architecture of the VM, e.g.: i386 or x86\_64                                                                                                                                                                   |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âmemory memory``         | Memory ammount given to the VM                                                                                                                                                                                  |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âdisk disk0,disk1``      | Disks to attach. To use a disk owned by other user use user[disk]                                                                                                                                               |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ânic vnet0,vnet1``       | Networks to attach. To use a network owned by other user use user[network]                                                                                                                                      |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âraw string``            | Raw string to add to the template. Not to be confused with the RAW attribute. If you want to provide more than one element, just include an enter inside quotes, instead of using more than one â€“raw option   |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âvnc``                   | Add VNC server to the VM                                                                                                                                                                                        |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âssh [file]``            | Add an ssh public key to the context. If the file is omited then the user variable SSH\_PUBLIC\_KEY will be used.                                                                                               |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ânet_context``           | Add network contextualization parameters                                                                                                                                                                        |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âcontext line1,line2``   | Lines to add to the context section                                                                                                                                                                             |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``âboot device``           | Select boot device (``hd``, ``fd``, ``cdrom`` or ``network``)                                                                                                                                                   |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

A similar template as the previous example can be created with the
following command:

.. code::

$ onetemplate create --name test-vm --memory 128 --cpu 1 --disk "Arch Linux" --nic Public

|:!:| You may want to add VNC access, input hw or change the default
targets of the disks. Check the `VM definition file for a complete
reference </./template>`__

|:!:| OpenNebula Templates are designed to be hypervisor-agnostic, but
there are additional attributes that are supported for each hypervisor.
Check the `Xen </./xeng>`__, `KVM </./kvmg>`__ and
`VMware </./evmwareg>`__ configuration guides for more details

|:!:| Volatile disks can not be saved as. Pre-register a DataBlock image
if you need to attach arbitrary volumes to the VM

Managing Templates
==================

Users can manage the Template Repository using the command
`` onetemplate``, or the graphical interface `Sunstone </./sunstone>`__.
For each user, the actual list of templates available are determined by
the ownership and permissions of the templates.

Listing Available Templates
---------------------------

You can use the `` onetemplate list`` command to check the available
Templates in the system.

.. code::

$ onetemplate list a
ID USER     GROUP    NAME                         REGTIME
0 oneadmin oneadmin template-0            09/27 09:37:00
1 oneuser  users    template-1            09/27 09:37:19
2 oneadmin oneadmin Ubuntu_server         09/27 09:37:42

To get complete information about a Template, use `` onetemplate show``.

Here is a view of templates tab in Sunstone:

|image1|

Adding and Deleting Templates
-----------------------------

Using `` onetemplate create``, users can create new Templates for
private or shared use. The `` onetemplate delete`` command allows the
Template owner -or the OpenNebula administrator- to delete it from the
repository.

For instance, if the previous example template is written in the
vm-example.txt file:

.. code::

$ onetemplate create vm-example.txt
ID: 6

You can also clone an existing Template, with the ``onetemplate clone``
command:

.. code::

$ onetemplate clone 6 new_template
ID: 7

Via Sunstone, you can easily add templates using the provided wizards
(or copy/pasting a template file) and delete them clicking on the delete
button:

|image2|

Updating a Template
-------------------

It is possible to update a template by using the
`` onetemplate update``. This will launch the editor defined in the
variable ``EDITOR`` and let you edit the template.

.. code::

$ onetemplate update 3

Publishing Templates
--------------------

The users can share their Templates with other users in their group, or
with all the users in OpenNebula. See the `Managing Permissions
documentation </./chmod>`__ for more information.

Let's see a quick example. To share the Template 0 with users in the
group, the **USE** right bit for **GROUP** must be set with the
**chmod** command:

.. code::

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

The following command allows users in the same group **USE** and
**MANAGE** the Template, and the rest of the users **USE** it:

.. code::

$ onetemplate chmod 0 664

$ onetemplate show 0
...
PERMISSIONS
OWNER          : um-
GROUP          : um-
OTHER          : u--

The commands `` onetemplate publish`` and `` onetemplate unpublish`` are
still present for compatibility with previous versions. These commands
set/unset the ``GROUP USE`` bit.

Instantiating Templates
=======================

The `` onetemplate instantiate`` command accepts a Template ID or name,
and creates a VM instance (you can define the number of instances using
the ``âmultiple num_of_instances`` option) from the given template.

.. code::

$ onetemplate instantiate 6
VM ID: 0

$ onevm list
ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
0 oneuser1 users    one-0        pend   0      0K                 00 00:00:16

You can also merge another template to the one being instantiated. The
new attributes will be added, or will replace the ones fom the source
template. This can be more convinient that cloning an existing template
and updating it.

.. code::

$ cat /tmp/file
MEMORY = 512
COMMENT = "This is a bigger instance"

$ onetemplate instantiate 6 /tmp/file
VM ID: 1

The same options to create new templates can be used to be merged with
an existing one. See the above table, or execute 'onetemplate
instantiate â€“help' for a complete reference.

.. code::

$ onetemplate instantiate 6 --cpu 2 --memory 1024
VM ID: 2

Merge Use Case
--------------

The template merge functionality, combined with the restricted
attibutes, can be used to allow users some degree of customization for
predefined templates.

Let's say the administrator wants to provide base templates that the
users can customize, but with some restrictions. Having the following
`restricted attributes in
oned.conf </./oned_conf#restricted_attributes_configuration>`__:

.. code:: code

VM_RESTRICTED_ATTR = "CPU"
VM_RESTRICTED_ATTR = "VPU"
VM_RESTRICTED_ATTR = "NIC"

And the following template:

.. code:: code

CPU     = "1"
VCPU    = "1"
MEMORY  = "512"
DISK=[
IMAGE_ID = "0" ]
NIC=[
NETWORK_ID = "0" ]

Users can instantiate it customizing anything except the CPU, VCPU and
NIC. To create a VM with different memory and disks:

.. code::

$ onetemplate instantiate 0 --memory 1G --disk "Ubuntu 12.10"

|:!:| The merged attributes replace the existing ones. To add a new
disk, the current one needs to be added also.

.. code::

$ onetemplate instantiate 0 --disk 0,"Ubuntu 12.10"

Deployment
==========

The OpenNebula Scheduler will deploy automatically the VMs in one of the
available Hosts, if they meet the requirements. The deployment can be
forced by an administrator using the `` onevm deploy`` command.

Use `` onevm shutdown`` to shutdown a running VM.

Continue to the `Managing Virtual Machine Instances
Guide </./vm_guide_2>`__ to learn more about the VM Life Cycle, and the
available operations that can be performed.

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
.. |image1| image:: /./_media/documentation:rel4.0:sunstone_managing_perms.png?w=700
:target: /./_media/documentation:rel4.0:sunstone_managing_perms.png?id=
.. |image2| image:: /./_media/documentation:rel4.0:sunstone_template_create.png?w=700
:target: /./_detail/documentation:rel4.0:sunstone_template_create.png?id=
