==============
VMware Drivers
==============

The **VMware Drivers** enable the management of an OpenNebula cloud
based on VMware ESX and/or VMware Server hypervisors. They use
``libvirt`` and direct API calls using ``RbVmomi`` to invoke the Virtual
Infrastructure SOAP API exposed by the VMware hypervisors, and feature a
simple configuration process that will leverage the stability,
performance and feature set of any existing VMware based OpenNebula
cloud.

Requirements
============

In order to use the **VMware Drivers**, some software dependencies have
to be met:

-  **libvirt**: At the OpenNebula front-end, libvirt is used to access
the VMware hypervisors , so it needs to be installed with ESX
support. We recommend version 0.8.3 or higher, which enables
interaction with the vCenter VMware product, required to use vMotion.
This will be installed by the OpenNebula package.
-  **rbvmomi**: Also at the OpenNebula front-end, the `rbvmomi
gem <https://github.com/rlane/rbvmomi>`__ needs to be installed. This
will be installed by the OpenNebula package or the install\_gems
script.
-  **ESX, VMware Server**: At least one VMware hypervisor needs to be
installed. Further configuration for the ``DATASTORE`` is needed, and
it is explained in the TM part of the Configuration section.

**Optional Requirements**. To enable some OpenNebula features you may
need:

-  **vMotion**: VMware's vMotion capabilities allows to perform live
migration of a Virtual Machine between two ESX hosts, allowing for
load balancing between cloud worker nodes without downtime in the
migrated virtual machine. In order to use this capability, the
following requisites have to be meet:

-  **Shared storage** between the source and target host, mounted in
both hosts as the same DATASTORE (we are going to assume it is
called â€œimagesâ€? in the rest of this document)
-  **vCenter Server** installed and configured, details in the
`Installation Guide for ESX and
vCenter <http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.install.doc%2FGUID-BC044F6C-4733-4413-87E6-A00D3BDEDE58.html>`__.
-  A **datacenter** created in the vCenter server that includes all
ESX hosts between which Virtual Machines want to be live migrated
(we are going to assume it is called â€œonecenterâ€? in the rest
of this document).
-  A **user** created in vCenter with the same username and password
than the ones in the ESX hosts, with administrator permissions.

|:!:| Please note that the libvirt version shipped with some linux
distribution does not include ESX support. In these cases it may be
needed to recompile the libvirt package with the â€“with-esx option.

Considerations & Limitations
============================

-  Only one vCenter can be used for livemigration.

-  Datablock images and volatile disk images will be always created
without format, and thus have to be formatted by the guest.

-  In order to use the **attach/detach** functionality, the original VM
must have at least one SCSI disk, and the disk to be
attached/detached must be placed on a SCSI bus (ie, â€œsdâ€? as
DEV\_PREFIX).

-  The ESX hosts need to be properly licensed, with write access to the
exported API (as the Evaluation license does).

VMware Configuration
====================

Users & Groups
--------------

The creation of a user in the VMware hypervisor is recommended. Go to
the Users & Group tab in the VI Client, and create a new user (for
instance, â€œoneadminâ€?) with the same UID and username as the oneadmin
user executing OpenNebula in the front-end. Please remember to give full
permissions to this user (Permissions tab).

|image1|

|:!:| After registering a datastore, make sure that the â€œoneadminâ€?
user can write in said datastore (this is not needed if the â€œrootâ€?
user is used to access the ESX). In case â€œoneadminâ€? cannot write in
â€?/vmfs/volumes/<ds\_id>â€?, then permissions need to be adjusted. This
can be done in various ways, the recommended one being:

-  Add â€œoneadminâ€? to the â€œrootâ€? group using the Users & Group
tab in the VI Client
-  ``$ chmod g+w /vmfs/volumes/<ds_id>`` in the ESX host

SSH Access
----------

SSH access from the front-end to the ESX hosts is required (or, at
least, they need it to unlock all the functionality of OpenNebula). to
ensure so, please remember to click the â€œGrant shell access to this
userâ€? checkbox when creating the ``oneadmin`` user.

The access via SSH needs to be passwordless. Please follow the next
steps to configure the ESX node:

-  login to the esx host (ssh <esx-host>)

.. code::

$ su -
$ mkdir /etc/ssh/keys-oneadmin
$ chmod 755 /etc/ssh/keys-oneadmin
$ su - oneadmin
$ vi  /etc/ssh/keys-oneadmin/authorized_keys
<paste here the contents of the oneadmin's front-end account public key (FE -> $HOME/.ssh/id_{rsa,dsa}.pub) and exit vi>
$ chmod 600 /etc/ssh/keys-oneadmin/authorized_keys

More information on passwordless ssh connections
`here <http://www.brandonhutchinson.com/Passwordless_ssh_logins.html>`__.

Tools Setup
-----------

-  In order to enable all the functionality of the drivers, several
short steps remain:

.. code::

$ su
$ chmod +s /sbin/vmkfstools

-  In order to use the **attach/detach functionality** for VM disks,
some extra configuration steps are needed in the ESX hosts. For ESX >
5.0

.. code::

$ su
$ chmod +s /bin/vim-cmd

-  In order to use the `dynamic network
mode </./vmwarenet#using_the_dynamic_network_mode>`__ for VM disks,
some extra configuration steps are needed in the ESX hosts. For ESX >
5.0

.. code::

$ su
$ chmod +s /sbin/esxcfg-vswitch

Persistency
-----------

Persistency of the ESX filesystem has to be handled with care. Most of
ESX 5 files reside in a in-memory filesystem, meaning faster access and
also non persistency across reboots, which can be inconvenient at the
time of managing a ESX farm for a OpenNebula cloud.

Here is a recipe to make the configuration needed for OpenNebula
persistent across reboots. The changes need to be done as root.

.. code::

# vi /etc/rc.local
##Â Add this at the bottom of the file

mkdir /etc/ssh/keys-oneadmin
cat > /etc/ssh/ssh-oneadmin/authorized_keys << _SSH_HEYS_
ssh-rsa <really long string with oneadmin's ssh public key>
_SSH_KEYS_
chmod 600 /etc/ssh/keys-oneadmin/authorized_keys
chmod +s /sbin/vmkfstools /bin/vim-cmd
chmod 755 /etc/ssh/keys-oneadmin
chown oneadmin /etc/ssh/keys-oneadmin/authorized_keys

# /sbin/auto-backup.sh

This information was based on this `blog
post <http://www.virtuallyghetto.com/2011/08/how-to-persist-configuration-changes-in.html>`__.

Storage
-------

There are additional configuration steps regarding storage. Please refer
to the `VMware Storage Model guide for more details </./vmware_ds>`__.

Networking
----------

Networking can be used in two different modes: **pre-defined** (to use
pre-defined port groups) or **dynamic** (to dynamically create port
groups and VLAN tagging). Please refer to the `VMware Networking guide
for more details </./vmwarenet>`__.

VNC
---

In order to access running VMs through VNC, the ESX host needs to be
configured beforehand, basically to allow VNC inbound connections via
their firewall. To do so, please follow this
`guide <http://t3chnot3s.blogspot.com.es/2012/03/how-to-enable-vnc-access-to-vms-on.html>`__.

OpenNebula Configuration
========================

OpenNebula Daemon
-----------------

-  In order to configure OpenNebula to work with the VMware drivers, the
following sections need to be uncommented or added in the
``/etc/one/oned.conf`` file.

.. code:: code

#-------------------------------------------------------------------------------
#  VMware Virtualization Driver Manager Configuration
#-------------------------------------------------------------------------------
VM_MAD = [
name       = "vmware",
executable = "one_vmm_sh",
arguments  = "-t 15 -r 0 vmware -s sh",
default    = "vmm_exec/vmm_exec_vmware.conf",
type       = "vmware" ]

#-------------------------------------------------------------------------------
#  VMware Information Driver Manager Configuration
#-------------------------------------------------------------------------------
IM_MAD = [
name       = "vmware",
executable = "one_im_sh",
arguments  = "-c -t 15 -r 0 vmware" ]
#-------------------------------------------------------------------------------

SCRIPTS_REMOTE_DIR=/tmp/one

VMware Drivers
--------------

The configuration attributes for the VMware drivers are set in the
``/etc/one/vmwarerc`` file. In particular the following values can be
set:

+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SCHEDULER OPTIONS   | DESCRIPTION                                                                                                                                                              |
+=====================+==========================================================================================================================================================================+
| **:libvirt\_uri**   | used to connect to VMware through libvirt. When using VMware Server, the connection string set under LIBVIRT\_URI needs to have its prefix changed from *esx* to *gsx*   |
+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **:username**       | username to access the VMware hypervisor                                                                                                                                 |
+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **:password**       | password to access the VMware hypervisor                                                                                                                                 |
+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **:datacenter**     | (only for vMotion) name of the datacenter where the hosts have been registered.                                                                                          |
+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **:vcenter**        | (only for vMotion) name or IP of the vCenter that manage the ESX hosts                                                                                                   |
+---------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Example of the configuration file:

.. code:: code

:libvirt_uri: "esx://@HOST@/?no_verify=1&auto_answer=1"
:username: "oneadmin"
:password: "mypass"
:datacenter: "ha-datacenter"
:vcenter: "London-DC"

|:!:| Please be aware that the above rc file, in stark contrast with
other rc files in OpenNebula, uses yaml syntax, therefore please input
the values between quotes.

VMware Physical Hosts
---------------------

The physical hosts containing the VMware hypervisors need to be added
with the appropriate **VMware Drivers**. If the box running the VMware
hypervisor is called, for instance, **esx-host**, the host would need to
be registered with the following command (dynamic netwotk mode):

.. code:: code

$ onehost create esx-host -i vmware -v vmware -n vmware

or for pre-defined networking

.. code:: code

$ onehost create esx-host -i vmware -v vmware -n dummy

Usage
=====

Images
------

To register an existing VMware disk in an OpenNebula image catalog you
need to:

-  Place all the .vmdk files that conform a disk (they can be easily
spotted, there is a main <name-of-the-image>.vmdk file, and various
<name-of-the-image-sXXX.vmdk flat files) in the same directory, with
no more files than these.
-  Afterwards, an image template needs to be written, using the the
absolut path to the directory as the PATH value. For example:

.. code:: code

NAME = MyVMwareDisk
PATH =/absolute/path/to/disk/folder
TYPE = OS

|:!:| To register a .iso file with type CDROM there is no need to create
a folder, just point with PATH to he absolute path of the .iso file.

|:!:| In order to register a VMware disk through Sunstone, create a zip
compressed tarball (.tar.gz) and upload that (it will be automatically
decompressed in the datastore). Please note that the tarball is only of
the folder with the .vmdk files inside, no extra directories can be
contained in that folder.

Once registered the image can be used as any other image in the
OpenNebula system as described in the `Virtual Machine Images
guide </./img_guide>`__.

Datablocks & Volatile Disks
---------------------------

Datablock images and volatile disks will appear as a raw devices on the
guest, which will then need to be formatted. The FORMAT attribute is
compulsory, possible values (more info on this
`here <http://communities.vmware.com/message/716009>`__) are:

-  **vmdk\_thin**
-  **vmdk\_zeroedthick**
-  **vmdk\_eagerzeroedthick**

Virtual Machines
----------------

The following attributes can be used for VMware Virtual Machines:

-  GuestOS: This parameter can be used in the OS section of the VM
template. The os-identifier can be one of `this
list <http://www.vmware.com/support/developer/vc-sdk/visdk25pubs/ReferenceGuide/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html>`__.

.. code::

OS=[GUESTOS=<os-identifier]

-  PCIBridge: This parameter can be used in the FEATURES section of the
VM template. The <bridge-number> is the number of PCI Bridges that
will be available in the VM (that is, 0 means no PCI Bridges, 1 means
PCI Bridge with ID = 0 present, 2 means PCI Bridges with ID = 0,1
present, and so on).

.. code::

FEATURES=[PCIBRIDGE=<bridge-number>]

Custom VMX Attributes
=====================

You can add metadata straight to the .vmx file using RAW/DATA\_VMX. This
comes in handy to specify for example a specific guestOS type, more info
`here </./template?&#raw_section>`__.

Following the two last sections, if we want a VM of guestOS type
â€œWindows 7 server 64bitâ€?, with disks plugged into a LSI SAS SCSI
bus, we can use a template like:

.. code:: code

NAME = myVMwareVM

CPU    = 1
MEMORY = 256

DISK = [IMAGE_ID="7"]
NIC  = [NETWORK="public"]

RAW=[
DATA="<devices><controller type='scsi' index='0' model='lsisas1068'/></devices>",
DATA_VMX="pciBridge0.present = \"TRUE\"\npciBridge4.present = \"TRUE\"\npciBridge4.virtualDev = \"pcieRootPort\"\npciBridge4.functions = \"8\"\npciBridge5.present = \"TRUE\"\npciBridge5.virtualDev = \"pcieRootPort\"\npciBridge5.functions = \"8\"\npciBridge6.present = \"TRUE\"\npciBridge6.virtualDev = \"pcieRootPort\"\npciBridge6.functions = \"8\"\npciBridge7.present = \"TRUE\"\npciBridge7.virtualDev = \"pcieRootPort\"\npciBridge7.functions = \"8\"\nguestOS = \"windows7srv-64\"",
TYPE="vmware" ]

Tuning & Extending
==================

The **VMware Drivers** consists of three drivers, with their
corresponding files:

-  **VMM Driver**

-  ``/var/lib/one/remotes/vmm/vmware`` : commands executed to perform
actions.

-  **IM Driver**

-  ``/var/lib/one/remotes/im/vmware.d`` : vmware IM probes.

-  **TM Driver**

-  ``/usr/lib/one/tm_commands`` : commands executed to perform
transfer actions.

And the following driver configuration files:

-  **VMM Driver**

-  ``/etc/one/vmm_exec/vmm_exec_vmware.conf`` : This file is home for
default values for domain definitions (in other words, OpenNebula
templates). For example, if the user wants to set a default value
for **CPU** requirements for all of their VMware domain
definitions, simply edit the
``/etc/one/vmm_exec/vmm_exec_vmware.conf`` file and set a

.. code:: code

CPU=0.6

into it. Now, when defining a template to be sent to a VMware resource,
the user has the choice of â€œforgettingâ€? to set the **CPU**
requirement, in which case it will default to 0.6.

It is generally a good idea to place defaults for the VMware-specific
attributes, that is, attributes mandatory for the VMware hypervisor that
are not mandatory for other hypervisors. Non mandatory attributes for
VMware but specific to them are also recommended to have a default.

-  **TM Driver**

-  ``/etc/one/tm_vmware/tm_vmware.conf`` : This files contains the
scripts tied to the different actions that the TM driver can
deliver. You can here deactivate functionality like the DELETE
action (this can be accomplished using the dummy tm driver,
dummy/tm\_dummy.sh) or change the default behavior.

More generic information about drivers:

-  `Virtual Machine Manager drivers reference </./devel-vmm>`__
-  `Transfer Manager driver reference </./sd>`__
-  `Image Manager drivers reference </./img_mad>`__

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
.. |image1| image:: /./_media/documentation:rel3.4:adduservmware.png?w=500
:target: /./_detail/documentation:rel3.4:adduservmware.png?id=
