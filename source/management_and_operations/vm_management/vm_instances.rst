.. _vm_guide_2:
.. _vm_instances:

================================================================================
Managing Virtual Machines Instances
================================================================================

This guide follows the :ref:`Creating Virtual Machines guide <vm_guide>`. Once a Template is instantiated to a Virtual Machine, there are a number of operations that can be performed using the ``onevm`` command.

.. _vm_life_cycle_and_states:

Virtual Machine Life-cycle
==========================

The life-cycle of a Virtual Machine within OpenNebula includes the following stages:

.. note:: Note that this is a simplified version. If you are a developer you may want to take a look at the complete diagram referenced in the :ref:`Virtual Machines States Reference guide <vm_states>`):

+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Short state |        State         |                                                                                                                                                 Meaning                                                                                                                                                  |
+=============+======================+==========================================================================================================================================================================================================================================================================================================+
| ``pend``    | ``Pending``          | By default a VM starts in the pending state, waiting for a resource to run on. It will stay in this state until the scheduler decides to deploy it, or the user deploys it using the ``onevm deploy`` command.                                                                                           |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``hold``    | ``Hold``             | The owner has held the VM and it will not be scheduled until it is released. It can be, however, deployed manually.                                                                                                                                                                                      |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``clon``    | ``Cloning``          | The VM is waiting for one or more disk images to finish the initial copy to the repository (image state still in ``lock``)                                                                                                                                                                               |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``prol``    | ``Prolog``           | The system is transferring the VM files (disk images and the recovery file) to the host in which the virtual machine will be running.                                                                                                                                                                    |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``boot``    | ``Boot``             | OpenNebula is waiting for the hypervisor to create the VM.                                                                                                                                                                                                                                               |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``runn``    | ``Running``          | The VM is running (note that this stage includes the internal virtualized machine booting and shutting down phases). In this state, the virtualization driver will periodically monitor it.                                                                                                              |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``migr``    | ``Migrate``          | The VM is migrating from one resource to another. This can be a life migration or cold migration (the VM is saved, powered-off or powered-off hard and VM files are transferred to the new resource).                                                                                                    |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``hotp``    | ``Hotplug``          | A disk attach/detach, nic attach/detach operation is in process.                                                                                                                                                                                                                                         |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``snap``    | ``Snapshot``         | A system snapshot is being taken.                                                                                                                                                                                                                                                                        |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``save``    | ``Save``             | The system is saving the VM files after a migration, stop or suspend operation.                                                                                                                                                                                                                          |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``epil``    | ``Epilog``           | In this phase the system cleans up the Host used to virtualize the VM, and additionally disk images to be saved are copied back to the system datastore.                                                                                                                                                 |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``shut``    | ``Shutdown``         | OpenNebula has sent the VM the shutdown ACPI signal, and is waiting for it to complete the shutdown process. If after a timeout period the VM does not disappear, OpenNebula will assume that the guest OS ignored the ACPI signal and the VM state will be changed to **running**, instead of **done**. |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``stop``    | ``Stopped``          | The VM is stopped. VM state has been saved and it has been transferred back along with the disk images to the system datastore.                                                                                                                                                                          |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``susp``    | ``Suspended``        | Same as stopped, but the files are left in the host to later resume the VM there (i.e. there is no need to re-schedule the VM).                                                                                                                                                                          |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``poff``    | ``PowerOff``         | Same as suspended, but no checkpoint file is generated. Note that the files are left in the host to later boot the VM there.                                                                                                                                                                             |
|             |                      |                                                                                                                                                                                                                                                                                                          |
|             |                      | When the VM guest is shutdown, OpenNebula will put the VM in this state.                                                                                                                                                                                                                                 |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unde``    | ``Undeployed``       | The VM is shut down. The VM disks are transfered to the system datastore. The VM can be resumed later.                                                                                                                                                                                                   |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``fail``    | ``Failed``           | The VM failed.                                                                                                                                                                                                                                                                                           |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unkn``    | ``Unknown``          | The VM couldn't be reached, it is in an unknown state.                                                                                                                                                                                                                                                   |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``clea``    | ``Cleanup-resubmit`` | The VM is waiting for the drivers to clean the host after a ``onevm recover --recreate`` action                                                                                                                                                                                                          |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``done``    | ``Done``             | The VM is done. VMs in this state won't be shown with ``onevm list`` but are kept in the database for accounting purposes. You can still get their information with the ``onevm show`` command.                                                                                                          |
+-------------+----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|Virtual Machine States|

Managing Virtual Machines
=========================

The following sections show the basics of the ``onevm`` command with simple usage examples. A complete reference for these commands can be found :ref:`here <cli>`.

Create and List Existing VMs
----------------------------

.. note:: Read the :ref:`Creating Virtual Machines guide <vm_guide>` for more information on how to manage and instantiate VM Templates.

.. note:: Read the complete reference for :ref:`Virtual Machine templates <template>`.

|sunstone_admin_instantiate|

Assuming we have a VM Template registered called **vm-example** with ID 6, then we can instantiate the VM issuing a:

.. prompt:: text $ auto

    $ onetemplate list
      ID USER     GROUP    NAME                         REGTIME
       6 oneadmin oneadmin vm_example            09/28 06:44:07

    $ onetemplate instantiate vm-example --name my_vm
    VM ID: 0


If the template has :ref:`USER INPUTS <vm_guide_user_inputs>` defined the CLI will prompt the user for these values:

.. prompt:: text $ auto

    $ onetemplate instantiate vm-example --name my_vm
    There are some parameters that require user input.
      * (BLOG_TITLE) Blog Title: <my_title>
      * (DB_PASSWORD) Database Password:
    VM ID: 0

Afterwards, the VM can be listed with the ``onevm list`` command. You can also use the ``onevm top`` command to list VMs continuously.

.. prompt:: text $ auto

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin my_vm        pend   0      0K                 00 00:00:03

After a Scheduling cycle, the VM will be automatically deployed. But the deployment can also be forced by oneadmin using ``onevm deploy``:

.. prompt:: text $ auto

    $ onehost list
      ID NAME               RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM   STAT
       2 testbed              0    800    800    800    16G    16G    16G     on

    $ onevm deploy 0 2

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin my_vm        runn   0      0K         testbed 00 00:02:40

and details about it can be obtained with ``show``:

.. prompt:: text $ auto

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : my_vm
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    START TIME          : 04/14 09:00:24
    END TIME            : -
    DEPLOY ID:          : one-0

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    VIRTUAL MACHINE MONITORING
    NET_TX              : 13.05
    NET_RX              : 0
    USED MEMORY         : 512
    USED CPU            : 0

    VIRTUAL MACHINE TEMPLATE
    ...

    VIRTUAL MACHINE HISTORY
     SEQ        HOSTNAME REASON           START        TIME       PTIME
       0         testbed   none  09/28 06:48:18 00 00:07:23 00 00:00:00

.. _vm_search:

Searching VM Instances...
---------------------------

You can search for VM instances by using the ``--search`` option of the ``onevm list`` command. This is specially usefull on large environments with many VMs. The filter must be in a KEY=VALUE format and will return all the VMs which fit the filter.

The KEY must be in the VM template section or be one of the following:

    - UNAME
    - GNAME
    - NAME
    - LAST_POLL
    - PREV_STATE
    - PREV_LCM_STATE
    - RESCHED
    - STIME
    - ETIME
    - DEPLOY_ID

For example, for searching a VM with a specific MAC addres:

.. prompt:: text $ auto

    $onevm list --search MAC=02:00:0c:00:4c:dd
     ID    USER     GROUP    NAME    STAT UCPU UMEM HOST TIME
     21005 oneadmin oneadmin test-vm pend    0   0K      1d 23h11

Equivalently if there are more than one VM instance that matches the result they will be shown. for example, VMs with a given NAME:

.. prompt:: text $ auto

    $onevm list --search NAME=test-vm
     ID    USER     GROUP    NAME    STAT UCPU UMEM HOST TIME
     21005 oneadmin oneadmin test-vm pend    0   0K       1d 23h13
     2100  oneadmin oneadmin test-vm pend    0   0K      12d 17h59

.. warning:: This feature is only available for **MySQL** backend with a version higher or equal than **5.6**.

Terminating VM Instances...
---------------------------

You can terminate an instance with the ``onevm terminate`` command, from any state. It will shutdown (if needed) and delete the VM. This operation will free the resources (images, networks, etc) used by the VM.

If the instance is running, there is a ``--hard`` option that has the following meaning:

* ``terminate``: Gracefully shuts down and deletes a running VM, sending the ACPI signal. Once the VM is shutdown the host is cleaned, and persistent and deferred-snapshot disk will be moved to the associated datastore. If after a given time the VM is still running (e.g. guest ignoring ACPI signals), OpenNebula will returned the VM to the ``RUNNING`` state.
* ``terminate --hard``: Same as above but the VM is immediately destroyed. Use this action instead of ``terminate`` when the VM doesn't have ACPI support.

Pausing VM Instances...
-----------------------

There are two different ways to temporarily stop the execution of a VM: short and long term pauses. A **short term** pause keeps all the VM resources allocated to the hosts so its resume its operation in the same hosts quickly. Use the following ``onevm`` commands or Sunstone actions:

* ``suspend``: the VM state is saved in the running Host. When a suspended VM is resumed, it is immediately deployed in the same Host by restoring its saved state.
* ``poweroff``: Gracefully powers off a running VM by sending the ACPI signal. It is similar to suspend but without saving the VM state. When the VM is resumed it will boot immediately in the same Host.
* ``poweroff --hard``: Same as above but the VM is immediately powered off. Use this action when the VM doesn't have ACPI support.

.. note:: When the guest is shutdown from within the VM, OpenNebula will put the VM in the ``poweroff`` state.

You can also plan a **long term pause**. The Host resources used by the VM are freed and the Host is cleaned. Any needed disk is saved in the system datastore. The following actions are useful if you want to preserve network and storage allocations (e.g. IPs, persistent disk images):

* ``undeploy``: Gracefully shuts down a running VM, sending the ACPI signal. The Virtual Machine disks are transferred back to the system datastore. When an undeployed VM is resumed, it is be moved to the pending state, and the scheduler will choose where to re-deploy it.
* ``undeploy --hard``: Same as above but the running VM is immediately destroyed.
* ``stop``: Same as ``undeploy`` but also the VM state is saved to later resume it.

When the VM is successfully paused you can resume its execution with:

* ``resume``: Resumes the execution of VMs in the stopped, suspended, undeployed and poweroff states.

Rebooting VM Instances...
--------------------------------------------------------------------------------

Use the following commands to reboot a VM:

* ``reboot``: Gracefully reboots a running VM, sending the ACPI signal.
* ``reboot --hard``: Performs a 'hard' reboot.

Delaying VM Instances...
------------------------

The deployment of a PENDING VM (e.g. after creating or resuming it) can be delayed with:

* ``hold``: Sets the VM to hold state. The scheduler will not deploy VMs in the ``hold`` state. Please note that VMs can be created directly on hold, using 'onetemplate instantiate --hold' or 'onevm create --hold'.

Then you can resume it with:

* ``release``: Releases a VM from hold state, setting it to pending. Note that you can automatically release a VM by scheduling the operation as explained below

.. _vm_guide_2_disk_snapshots:

Disk Snapshots
--------------

There are two kinds of operations related to disk snapshots:

* ``disk-snapshot-create``, ``disk-snapshot-revert``, ``disk-snapshot-delete``, ``disk-snapshot-rename``: Allows the user to take snapshots of the disk states and return to them during the VM life-cycle. It is also possible to rename or delete snapshots.
* ``disk-saveas``: Exports VM disk (or a previously created snapshot) to an image. This is a live action.

.. warning:: Disk Snapshots are not supported in vCenter

.. _vm_guide_2_disk_snapshots_managing:

Managing Disk Snapshots
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A user can take snapshots of the disk states at any moment in time (if the VM is in ``RUNNING``, ``POWEROFF`` or ``SUSPENDED`` states). These snapshots are organized in a tree-like structure, meaning that every snapshot has a parent, except for the first snapshot whose parent is ``-1``. At any given time a user can revert the disk state to a previously taken snapshot. The active snapshot, the one the user has last reverted to, or taken, will act as the parent of the next snapshot. In addition, it's possible to delete snapshots that are not active and that have no children.

.. warning:: The default behavior described previously can be overridden by the storage driver; and it may allow a flat snapshot structure without parent/child relationship. In that case, snapshots can be freely removed.

- ``disk-snapshot-create <vmid> <diskid> <name>``: Creates a new snapshot of the specified disk.
- ``disk-snapshot-revert <vmid> <diskid> <snapshot_id>``: Reverts to the specified snapshot. The snapshots are immutable, therefore the user can revert to the same snapshot as many times as he wants, the disk will return always to the state of the snapshot at the time it was taken.
- ``disk-snapshot-delete <vmid> <diskid> <snapshot_id>``: Deletes a snapshot if it has no children and is not active.

|sunstone_disk_snapshot|

``disk-snapshot-create`` can take place when the VM is in ``RUNNING`` state, provided that the drivers support it, while ``disk-snapshot-revert`` requires the VM to be ``POWEROFF`` or ``SUSPENDED``. Live snapshots are only supported for some drivers:

- Hypervisor ``VM_MAD=kvm`` combined with ``TM_MAD=qcow2`` datastores. In this case OpenNebula will request that the hypervisor executes ``virsh snapshot-create``.
- Hypervisor ``VM_MAD=kvm`` with Ceph datastores (``TM_MAD=ceph``). In this case OpenNebula will initially create the snapshots as Ceph snapshots in the current volume.

With CEPH and qcow2 datastores and KVM hypervisor you can :ref:`enable QEMU Guest Agent <enabling_qemu_guest_agent>`. With this agent enabled the filesystem will be frozen while the snapshot is being done.

OpenNebula will not automatically handle non-live ``disk-snapshot-create`` and ``disk-snapshot-revert`` operations for VMs in ``RUNNING`` if the drivers do not support it. In this case the user needs to suspend or poweroff the VM before creating the snapshot.

See the :ref:`Storage Driver <sd_tm>` guide for a reference on the driver actions invoked to perform live and non-live snapshost.

Persistent Image Snapshots
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These actions are available for both persistent and non-persistent images. In the case of persistent images the snapshots **will** be preserved upon VM termination and will be able to be used by other VMs using that image. See the :ref:`snapshots <img_guide_snapshots>` section in the Images guide for more information.

Back-end Implementations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The snapshot operations are implemented differently depending on the storage back-end:

+----------------------+-----------------------------------------------------------------------------------------+---------------------------------------------------+---------------------------------------------------------------------------+------------------+
| **Operation/TM_MAD** |                                           Ceph                                          |                  Shared  and SSH                  |                                   Qcow2                                   | Dev, FS_LVM, LVM |
+======================+=========================================================================================+===================================================+===========================================================================+==================+
| Snap Create          | Creates a protected snapshot                                                            | Copies the file.                                  | Creates a new qcow2 image with the previous disk as the backing file.     | *Not Supported*  |
+----------------------+-----------------------------------------------------------------------------------------+---------------------------------------------------+---------------------------------------------------------------------------+------------------+
| Snap Create (live)   | Creates a protected snapshot and quiesces the guest fs.                                 | *Not Supported*                                   | (For KVM only) Launches ``virsh snapshot-create``.                        | *Not Supported*  |
+----------------------+-----------------------------------------------------------------------------------------+---------------------------------------------------+---------------------------------------------------------------------------+------------------+
| Snap Revert          | Overwrites the active disk by creating a new snapshot of an existing protected snapshot | Overwrites the file with a previously copied one. | Creates a new qcow2 image with the selected snapshot as the backing file. | *Not Supported*  |
+----------------------+-----------------------------------------------------------------------------------------+---------------------------------------------------+---------------------------------------------------------------------------+------------------+
| Snap Delete          | Deletes a protected snapshot                                                            | Deletes the file.                                 | Deletes the selected qcow2 snapshot.                                      | *Not Supported*  |
+----------------------+-----------------------------------------------------------------------------------------+---------------------------------------------------+---------------------------------------------------------------------------+------------------+

.. warning::

  Depending on the ``DISK/CACHE`` attribute the live snapshot may or may not work correctly. To be sure, you can use ``CACHE=writethrough``, although this delivers the slowest performance.

.. _disk_save_as_action:

Exporting Disk Images with ``disk-saveas``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any VM disk can be exported to a new image (if the VM is in ``RUNNING``, ``POWEROFF``, ``SUSPENDED``, ``UNDEPLOYED`` or ``STOPPED`` states). This is a live operation that happens immediately. This operation accepts ``--snapshot <snapshot_id>`` as an optional argument, which specifies a disk snapshot to use as the source of the clone, instead of the current disk state (value by default).

.. warning::

  This action is not in sync with the hypervisor. If the VM is in ``RUNNING`` state make sure the disk is unmounted (preferred), synced or quiesced in some way or another before taking the snapshot.

.. note:: In vCenter, the save as operation can only be performed when the VM is in POWEROFF state. Performing this action in a different state won't work as vCenter cannot unlock the VMDK file.


.. _disk_hotplugging:

Disk Hot-plugging
--------------------------------------------------------------------------------

New disks can be hot-plugged to running VMs with the ``onevm`` ``disk-attach`` and ``disk-detach`` commands. For example, to attach to a running VM the Image named **storage**:

.. prompt:: text $ auto

    $ onevm disk-attach one-5 --image storage

To detach a disk from a running VM, find the disk ID of the Image you want to detach using the ``onevm show`` command, and then simply execute ``onevm detach vm_id disk_id``:

.. prompt:: text $ auto

    $ onevm show one-5
    ...
    DISK=[
      DISK_ID="1",
    ...
      ]
    ...

    $ onevm disk-detach one-5 1

.. _vm_guide2_nic_hotplugging:

NIC Hot-plugging
--------------------------------------------------------------------------------

You can hot-plug network interfaces to VMs in the ``RUNNING``, ``POWEROFF`` or ``SUSPENDED`` states. Simply specify the network where the new interface should be attached to, for example:

.. prompt:: text $ auto

    $ onevm show 2

    VIRTUAL MACHINE 2 INFORMATION
    ID                  : 2
    NAME                : centos-server
    STATE               : ACTIVE
    LCM_STATE           : RUNNING

    ...

    VM NICS
    ID NETWORK      VLAN BRIDGE   IP              MAC
     0 net_172        no vbr0     172.16.0.201    02:00:ac:10:0

    ...

    $ onevm nic-attach 2 --network net_172

After the operation you should see two NICs, 0 and 1:

.. prompt:: text $ auto

    $ onevm show 2
    VIRTUAL MACHINE 2 INFORMATION
    ID                  : 2
    NAME                : centos-server
    STATE               : ACTIVE
    LCM_STATE           : RUNNING

    ...


    VM NICS
    ID NETWORK      VLAN BRIDGE   IP              MAC
     0 net_172        no vbr0     172.16.0.201    02:00:ac:10:00:c9
                                  fe80::400:acff:fe10:c9
     1 net_172        no vbr0     172.16.0.202    02:00:ac:10:00:ca
                                  fe80::400:acff:fe10:ca
    ...

You can also detach a NIC by its ID. If you want to detach interface 1 (MAC ``02:00:ac:10:00:ca``), execute:

.. prompt:: text $ auto

    $ onevm nic-detach 2 1

.. _vm_guide2_snapshotting:

Snapshotting
------------

You can create, delete and restore snapshots for running VMs. A snapshot will contain the current disks and memory state.

.. prompt:: text $ auto

    $ onevm snapshot-create 4 "just in case"

    $ onevm show 4
    ...
    SNAPSHOTS
      ID         TIME NAME                                           HYPERVISOR_ID
       0  02/21 16:05 just in case                                   onesnap-0

    $ onevm snapshot-revert 4 0 --verbose
    VM 4: snapshot reverted

.. warning:: **For KVM only**. Please take into consideration the following limitations:

    -  The snapshots are lost if any life-cycle operation is performed, e.g. a suspend, migrate, delete request.
    -  Snapshots are only available if all the VM disks use the :ref:`qcow2 driver <img_template>`.

|image4|

.. _vm_guide2_resizing_a_vm:

Resizing VM Capacity
----------------------

You may resize the capacity assigned to a Virtual Machine in terms of the virtual CPUs, memory and CPU allocated. VM resizing can be done in any of the following states:
POWEROFF, UNDEPLOYED and with some limitations also in RUNNING state.

If you have created a Virtual Machine and you need more resources, the following procedure is recommended:

-  Perform any operation needed to prepare your Virtual Machine for shutting down, e.g. you may want to manually stop some services
-  Poweroff the Virtual Machine
-  Resize the VM
-  Resume the Virtual Machine using the new capacity

Note that using this procedure the VM will preserve any resource assigned by OpenNebula, such as IP leases.

The following is an example of the previous procedure from the command line:

.. prompt:: text $ auto

    $ onevm poweroff web_vm
    $ onevm resize web_vm --memory 2G --vcpu 2
    $ onevm resume web_vm

From Sunstone:

|image5|

.. warning:: If the Virtual Machine is from vCenter, other considerations are needed, check :ref:`here <vcenter_live_resize>` for more information.

.. _vm_guide2_resize_disk:

Hotplug Resize VM Capacity
--------------------------

If you need to resize the capacity in the RUNNING state you have to setup some extra attributes to VM template, this attributes must be set befere the VM is started.

+-----------------+------------------------------------------------------------------------------------------------+
|  Attribute      |                              Description                                                       |
+=================+================================================================================================+
| ``VCPU_MAX``    | Maximum number of VCPUs which could be hotplugged                                              |
+-----------------+------------------------------------------------------------------------------------------------+
| ``MEMORY_MAX``  | Maximum memory which could be hotplugged                                                       |
+-----------------+------------------------------------------------------------------------------------------------+
| ``MEMORY_SLOTS``| Optional, slots for hotplugging memory. Limits the number of hotplug operations. Defaults to 8 |
+-----------------+------------------------------------------------------------------------------------------------+

.. Note::

  Hotplug implemented only for KVM and vCenter


Resizing VM Disks
-------------------

If the disks assigned to a Virtual Machine need more size, this can achieved at instantiation time of the VM. The SIZE parameter of the disk can be adjusted and, if it is bigger than the original size of the image, OpenNebula will:

- Increase the size of the disk container prior to launching the VM
- Using the :ref:`contextualization packages <context_overview>`, at boot time the VM will grow the filesystem to adjust to the new size. **This is only available for Linux guests in KVM and vCenter**.

This can be done with an extra file given to the ``instantiate`` command:

.. prompt:: text $ auto

    $ cat /tmp/disk.txt
    DISK = [ IMAGE_ID = 4,
             SIZE = 2000]   # If Image 4 is 1 GB, OpenNebula will resize it to 2 GB

    $ onetemplate instantiate 7 /tmp/disk.txt

Or with CLI options:

.. prompt:: text $ auto

    $ onetemplate instantiate <template> --disk image0:size=20000

This can also be achieved from Sunstone, both in Cloud and Admin View, at the time of instantiating a VM Template:

|sunstone_admin_instantiate|

.. important:: In vCenter a disk can be resized only if the VM is in poweroff state and the VM has no snapshots or the template, which the VM is based on, doesn't use linked clones.

.. _vm_updateconf:

Updating VM Configuration
--------------------------------------------------------------------------------

Some of the VM configuration attributes defined in the VM Template can be updated after the VM is created. The ``onevm updateconf`` command will allow you to change the following attributes:

+--------------+-------------------------------------------------------------------------+
|  Attribute   |                              Sub-attributes                             |
+==============+=========================================================================+
| ``OS``       | ``ARCH``, ``MACHINE``, ``KERNEL``, ``INITRD``, ``BOOTLOADER``, ``BOOT``,|
|              | ``SD_DISK_BUS``, ``UUID``                                               |
+--------------+-------------------------------------------------------------------------+
| ``FEATURES`` | ``ACPI``, ``PAE``, ``APIC``, ``LOCALTIME``, ``HYPERV``, ``GUEST_AGENT``,|
|              | ``IOTHREADS``                                                           |
+--------------+-------------------------------------------------------------------------+
| ``INPUT``    | ``TYPE``, ``BUS``                                                       |
+--------------+-------------------------------------------------------------------------+
| ``GRAPHICS`` | ``TYPE``, ``LISTEN``, ``PASSWD``, ``KEYMAP``                            |
+--------------+-------------------------------------------------------------------------+
| ``RAW``      | ``DATA``, ``DATA_VMX``, ``TYPE``                                        |
+--------------+-------------------------------------------------------------------------+
| ``CONTEXT``  | Any value. **Variable substitution will be made**                       |
+--------------+-------------------------------------------------------------------------+

.. note:: Visit the :ref:`Virtual Machine Template reference <template>` for a complete description of each attribute

.. warning:: If the VM is running, the action may fail and the context will not be changed. You can try to manualy trigger the action again.

.. note:: In running state only changes in CONTEXT take effect immediately, other values may need a VM restart


In Sunstone this action is inside the 'Conf' VM panel:

|sunstone_updateconf_1|

.. _vm_guide2_clone_vm:

Cloning a VM
--------------------------------------------------------------------------------

A VM Template or VM instance can be copied to a new VM Template. This copy will preserve the changes made to the VM disks after the instance is terminated. The template is private, and will only be listed to the owner user.

There are two ways to create a persistent private copy of a VM:

* Instantiate a template 'to persistent'
* Save a existing VM instance with ``onevm save``

Instantiate to persistent
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When **instantiating to persistent** the Template is cloned recursively (a private persistent clone of each disk Image is created), and that new Template is instantiated.

To "instantiate to persistent" use the ``--persistent`` option:

.. prompt:: text $ auto

    $ onetemplate instantiate web_vm --persistent --name my_vm
    VM ID: 31

    $ onetemplate list
      ID USER            GROUP           NAME                                REGTIME
       7 oneadmin        oneadmin        web_vm                       05/12 14:53:11
       8 oneadmin        oneadmin        my_vm                        05/12 14:53:38

    $ oneimage list
      ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
       7 oneadmin   oneadmin   web-img         default       200M OS   Yes used    1
       8 oneadmin   oneadmin   my_vm-disk-0    default       200M OS   Yes used    1

In sunstone, activate the "Persistent" switch next to the create button:

|sunstone_persistent_1|

Please bear in mind the following ``ontemplate instantiate --persistent`` limitation:

- Volatile disks cannot be persistent, and the contents will be lost when the VM is terminated. The cloned VM Template will contain the definition for an empty volatile disk.

Save a VM Instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Alternatively, a VM that was not created as persistent can be **saved** before it is destroyed. To do so, the user has to ``poweroff`` the VM first and then use the ``save`` operation.

This action clones the VM source Template, replacing the disks with snapshots of the current disks (see the disk-snapshot action). If the VM instance was resized, the current capacity is also used. The new cloned Images can be made persistent with the ``--persistent`` option. NIC interfaces are also overwritten with the ones from the VM instance, to preserve any attach/detach action.

.. prompt:: text $ auto

    $ onevm save web_vm copy_of_web_vm --persistent
    Template ID: 26

In the :ref:`Cloud View <cloud_view>`:

|sunstone_persistent_3|

From the :ref:`Admin View <suns_views>`:

|image10|

Please bear in mind the following ``onevm save`` limitations:

- The VM's source Template will be used. If this Template was updated since the VM was instantiated, the new contents will be used.
- Volatile disks cannot be saved, and the current contents will be lost. The cloned VM Template will contain the definition for an empty volatile disk.
- Disks and NICs will only contain the target Image/Network NAME and UNAME if defined. If your Template requires extra configuration (such as DISK/DEV_PREFIX), you will need to update the new Template.

.. _vm_guide2_scheduling_actions:

Scheduled Actions
-----------------

We have two types of schedule actions, punctual and relative actions. Punctual actions can also be periodic.

One-Time Punctual Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Most of the onevm commands accept the ``--schedule`` option, allowing users to delay the actions until the given date and time.

Here is an usage example:

.. prompt:: text $ auto

    $ onevm suspend 0 --schedule "09/20"
    VM 0: suspend scheduled at 2016-09-20 00:00:00 +0200

    $ onevm resume 0 --schedule "09/23 14:15"
    VM 0: resume scheduled at 2016-09-23 14:15:00 +0200

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : one-0

    [...]

    SCHEDULED ACTIONS
    ID ACTION             SCHEDULED                  REP                  END         DONE MESSAGE
     0 suspend     09/20 00:00            																							 -
     1 resume      09/23 14:15            																							 -

These actions can be deleted or edited using the ``onevm update`` command. The time attributes use Unix time internally.

.. prompt:: text $ auto

    $ onevm update 0

    SCHED_ACTION=[
      ACTION="suspend",
      ID="0",
      TIME="1379628000" ]
    SCHED_ACTION=[
      ACTION="resume",
      ID="1",
      TIME="1379938500" ]

Periodic Punctual Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To schedule periodic actions also use the option --schedule. However this command also needs more options to define the periodicity of the action.

	- ``--weekly``: defines a weekly periodicity, so, the action will be execute all weeks, the days that the user defines.
	- ``--monthly``: defines a monthly periodicity, so, the action will be execute all months, the days that the user defines.
	- ``--yearly``: defines a yearly periodicity, so, the action will be execute all year, the days that the user defines.
	- ``--hourly``: defines a hourly periodicity, so, the action will be execute each 'x' hours.
	- ``--end``: defines when you want that the relative action finishes.

The option ``--weekly``, ``--monthly`` and ``--yearly`` need the number of the days that the users wants execute the action.

	- ``--weekly``: days separate with commas between 0 and 6. [0,6]
	- ``--monthly``: days separate with commas between 1 and 31. [0,31]
	- ``--weekly``: days separate with commas between 0 and 365. [0,365]

The option ``--hourly`` needs a number with the number of hours. [0,168] (1 week)

The option ``--end`` can be a number or a date:

	- Number: defines the number of repetitions.
	- Date: defines the date that the user wants to finished the action.

Here is an usage example:

.. prompt:: text $ auto

    $ onevm suspend 0 --schedule "09/20" --weekly "1,5" --end 5
    VM 0: suspend scheduled at 2018-09-20 00:00:00 +0200

    $ onevm resume 0 --schedule "09/23 14:15" --weekly "2,6" --end 5
    VM 0: resume scheduled at 2018-09-23 14:15:00 +0200

		$ onevm snapshot-create 0 --schedule "09/23" --hourly 10 --end "12/25"
    VM 0: resume scheduled at 2018-09-23 14:15:00 +0200

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : one-0

    [...]

    SCHEDULED ACTIONS
    ID ACTION             SCHEDULED                  REP                  END         DONE MESSAGE
		 0 suspend          09/23 00:00           Weekly 1,5        After 5 times            -
 		 1 resume           09/23 00:00           Weekly 2,6        After 5 times            -
 		 2 snapshot-create  09/23 00:00         Each 5 hours        	On 12/25/18            -

These actions can be deleted or edited using the ``onevm update`` command. The time attributes use Unix time internally.

.. prompt:: text $ auto

    $ onevm update 0

    SCHED_ACTION=[
        ACTION="suspend",
        DAYS="1,5",
        END_TYPE="1",
        END_VALUE="5",
        ID="0",
        REPEAT="0",
        TIME="1537653600" ]
	SCHED_ACTION=[
        ACTION="resume",
        DAYS="2,6",
        END_TYPE="1",
        END_VALUE="5",
        ID="1",
        REPEAT="0",
        TIME="1537653600" ]
	SCHED_ACTION=[
        ACTION="snapshot-create",
        DAYS="5",
        END_TYPE="2",
        END_VALUE="1545692400",
        ID="2",
        REPEAT="3",
        TIME="1537653600" ]


Relative Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Scheduled actions can be also relative to the Start Time of the VM. That is, it can be set on a VM Template, and apply to the number of seconds after the VM is instantiated.

For instance, a VM Template with the following SCHED_ACTION will spawn VMs that will automatically shutdown after 1 hour of being instantiated.

.. prompt:: text $ auto

    $ onetemplate update 0

    SCHED_ACTION=[
       ACTION="terminate",
       ID="0",
       TIME="+3600" ]


This functionality is present graphically in Sunstone in the VM Template creation and update dialog, and in the VM Actions tab:

.. _schedule_actions:

|sunstone_schedule_action|

These are the commands that can be scheduled:

-  ``terminate [--hard]``
-  ``undeploy [--hard]``
-  ``hold``
-  ``release``
-  ``stop``
-  ``suspend``
-  ``resume``
-  ``delete``
-  ``delete-recreate``
-  ``reboot [--hard]``
-  ``poweroff [--hard]``
-  ``snapshot-create``
-  ``snapshot-revert``
-  ``snapshot-delete``
-  ``disk-snapshot-create``
-  ``disk-snapshot-revert``
-  ``disk-snapshot-delete``

Some of the above actions need some parameters to run (e.g. a disk ID or a snapshot name). You can pass those arguments to the scheduled actions using the parameter ``ARGS`` in the action definition. For example:

.. prompt:: text $ auto

    $ onevm update 0

    SCHED_ACTION=[
        ACTION="disk-snapshot-create",
        ARGS="0, disksnap_example",
        DAYS="1,5",
        END_TYPE="1",
        END_VALUE="5",
        ID="0",
        REPEAT="0",
        TIME="1537653600" ]

In this example, the first argument would be the disk and the second the snapshot name.

The actions that need arguments, are the following:

+----------------------+------------------+
| Action               | Arguments        |
+----------------------+------------------+
| snapshot-create      | name             |
+----------------------+------------------+
| snapshot-revert      | snap ID          |
+----------------------+------------------+
| snapshot-delete      | snap ID          |
+----------------------+------------------+
| disk-snapshot-create | disk ID, name    |
+----------------------+------------------+
| disk-snapshot-revert | disk ID, snap ID |
+----------------------+------------------+
| disk-snapshot-delete | disk ID, snap ID |
+----------------------+------------------+

.. note:: These arguments are mandatory. If you use the CLI or Sunstone they are generated automatically for the actions.

.. _vm_charter:

VM Charter
----------

This functionality auto add scheduling actions in VM templates. For add this only need add this in ``sunstone-server.conf`` file

|vm_charter|

.. prompt:: text $ auto

  :leases:
    suspend:
      time: "+1209600"
      color: "#000000"
      warning:
        time: "-86400"
        color: "#085aef"
    terminate:
      time: "+1209600"
      color: "#e1ef08"
      warning:
        time: "-86400"
        color: "#ef2808"

In the previous example you can see how scheduled actions are added and you can see the following values:

+---------+-------------------------------------------------------------------------------------------------------+
| time    | Time for tha action in secs example: +1209600 is to weeks.                                            |
|         | The order is very important since time adds to the previous scheduled action.                         |
+---------+-------------------------------------------------------------------------------------------------------+
| color   | Is the color in hexadecimal since the icon will appear in the Vms table                               |
+---------+-------------------------------------------------------------------------------------------------------+
| warning | It is an alert (color change of the icon in the VM table) that will change when the limit has elapsed |
|         | minus the time placed                                                                                 |
+---------+-------------------------------------------------------------------------------------------------------+

This functionality is also available in the CLI, through the following commands:

- onevm create-chart
- onevm update-chart
- onevm delete-chart

The charters can be added into the configuration file ``/etc/one/cli/onevm.yaml``:

.. code::

    :charters:
      :suspend:
        :time: "+1209600"
        :warning:
          :time: 86400
      :terminate:
        :time: "+1209600"
        :warning:
          :time: 86400

The information about the charters can be checked with the command ``onevm show``:

.. prompt:: bash $ auto

    SCHEDULED ACTIONS
    ID    ACTION  ARGS   SCHEDULED REPEAT   END  DONE                             MESSAGE CHARTER
     1 terminate     - 01/01 03:00                  -                                   - In 1.25 hours *

.. warning:: If the CHARTER has a * it shows the warning message as it was configured previously.

.. _vm_guide2_user_defined_data:

User Defined Data
-----------------

Custom attributes can be added to a VM to store metadata related to this specific VM instance. To add custom attributes simply use the ``onevm update`` command.

.. prompt:: text $ auto

    $ onevm show 0
    ...

    VIRTUAL MACHINE TEMPLATE
    ...
    VMID="0"

    $ onevm update 0
    ROOT_GENERATED_PASSWORD="1234"
    ~
    ~

    $onevm show 0
    ...

    VIRTUAL MACHINE TEMPLATE
    ...
    VMID="0"

    USER TEMPLATE
    ROOT_GENERATED_PASSWORD="1234"

Manage VM Permissions
---------------------

OpenNebula comes with an advanced :ref:`ACL rules permission mechanism <manage_acl>` intended for administrators, but each VM object has also :ref:`implicit permissions <chmod>` that can be managed by the VM owner. To share a VM instance with other users, to allow them to list and show its information, use the ``onevm chmod`` command:

.. prompt:: text $ auto

    $ onevm show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    $ onevm chmod 0 640

    $ onevm show 0
    ...
    PERMISSIONS
    OWNER          : um-
    GROUP          : u--
    OTHER          : ---

Administrators can also change the VM's group and owner with the ``chgrp`` and ``chown`` commands.

.. _life_cycle_ops_for_admins:

Life-Cycle Operations for Administrators
----------------------------------------

There are some ``onevm`` commands operations meant for the cloud administrators:

**Scheduling:**

-  ``resched``: Sets the reschedule flag for the VM. The Scheduler will migrate (or migrate --live, depending on the :ref:`Scheduler configuration <schg_configuration>`) the VM in the next monitorization cycle to a Host that better matches the requirements and rank restrictions. Read more in the :ref:`Scheduler documentation <schg_re-scheduling_virtual_machines>`.
-  ``unresched``: Clears the reschedule flag for the VM, canceling the rescheduling operation.

**Deployment:**

-  ``deploy``: Starts an existing VM in a specific Host.
-  ``migrate --live``: The Virtual Machine is transferred between Hosts with no noticeable downtime. This action requires a :ref:`shared file system storage <sm>`.
-  ``migrate``: The VM gets stopped and resumed in the target host. In an infrastructure with :ref:`multiple system datastores <system_ds_multiple_system_datastore_setups>`, the VM storage can be also migrated (the datastore id can be specified).

Note: By default, the above operations do not check the target host capacity. You can use the ``--enforce`` option to be sure that the host capacity is not overcommitted.

**Troubleshooting:**

-  ``recover``: If the VM is stuck in any other state (or the boot operation does not work), you can recover the VM with the following options. Read the :ref:`Virtual Machine Failures guide <ftguide_virtual_machine_failures>` for more information.

   - ``--success``: simulates the success of the missing driver action
   - ``--failure``: simulates the failure of the missing driver action
   - ``--retry``: retries to perform the current driver action. Optionally the ``--interactive`` can be combined if its a Transfer Manager problem.
   - ``--delete``: Deletes the VM, moving it to the DONE state immediately
   - ``--recreate``: Deletes the VM, and moves it to the PENDING state

-  ``migrate`` or ``resched``: A VM in the UNKNOWN state can be booted in a different host manually (``migrate``) or automatically by the scheduler (``resched``). This action must be performed only if the storage is shared, or manually transfered by the administrator. OpenNebula will not perform any action on the storage for this migration.

VNC/Spice Access through Sunstone
================================================================================

If the VM supports VNC or Spice and is ``running``, then the VNC icon on the Virtual Machines view should be visible and clickable:

|image7|

.. note:: In LXD instances, VNC access is provided through a command executed via ``lxc exec <container> -- <command>``. By default this command is ``/bin/login`` and it can be updated by editing **/var/tmp/one/etc/vmm/lxd/lxdrc** in the LXD node.

The command can also be set for each container, by updating the ``GRAPHICS`` section in the VM template.

|lxd_vnc|

.. note:: For the correct functioning of the SPICE Web Client, we recommend defining by default some SPICE parameters in ``/etc/one/vmm_mad/vmm_exec_kvm.conf``.
  In this way, once modified the file and restarted OpenNebula, it will be applied to all the VMs instantiated from now on.
  You can also override these SPICE parameters in VM Template. For more info check :ref:`Driver Defaults <kvmg_default_attributes>` section.

.. warning:: It is advised for RPM distros to update the command since it doesn't work when running it through ``lxc exec``. For example, a valid command would be ``/bin/bash``. Keep in mind it grants a root shell inside the container.


The Sunstone documentation contains a section on :ref:`Accesing your VMs Console and Desktop <remote_access_sunstone>` section.

Information for Developers and Integrators
==========================================

-  Although the default way to create a VM instance is to register a Template and then instantiate it, VMs can be created directly from a template file using the ``onevm create`` command.
-  When a VM reaches the ``done`` state, it disappears from the ``onevm list`` output, but the VM is still in the database and can be retrieved with the ``onevm show`` command.
-  OpenNebula comes with an :ref:`accounting tool <accounting>` that reports resource usage data.
-  The monitoring information, shown with nice graphs in :ref:`Sunstone <sunstone>`, can be retrieved using the XML-RPC methods :ref:`one.vm.monitoring and one.vmpool.monitoring <api>`.

.. |Virtual Machine States| image:: /images/states-simple.png
    :width: 100 %
.. |image2| image:: /images/sunstone_vm_attach.png
.. |image3| image:: /images/sunstone_vm_attachnic.png
.. |image4| image:: /images/sunstone_vm_snapshot.png
.. |image5| image:: /images/sunstone_vm_resize.png
.. |image6| image:: /images/sunstone_vm_list.png
.. |image7| image:: /images/sunstone_vnc.png
.. |image10| image:: /images/sunstone_save_button.png
.. |image11| image:: /images/sunstone_save_dialog.png
.. |image12| image:: /images/sunstone_cloud_save_button.png
.. |vm_charter| image:: /images/vm_charter.png
.. |sunstone_admin_instantiate| image:: /images/sunstone_admin_instantiate.png
.. |sunstone_disk_snapshot| image:: /images/sunstone_disk_snapshot.png
.. |sunstone_persistent_1| image:: /images/sunstone_persistent_1.png
.. |sunstone_persistent_2| image:: /images/sunstone_persistent_2.png
.. |sunstone_persistent_3| image:: /images/sunstone_persistent_3.png
.. |sunstone_schedule_action| image:: /images/sunstone_schedule_action.png
.. |sunstone_updateconf_1| image:: /images/sunstone_updateconf_1.png
.. |lxd_vnc| image:: /images/lxd_vnc.png
