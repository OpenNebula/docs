.. _vm_guide_2:

==========================
Managing Virtual Machines
==========================

This guide follows the :ref:`Creating Virtual Machines guide <vm_guide>`. Once a Template is instantiated to a Virtual Machine, there are a number of operations that can be performed using the ``onevm`` command.

Virtual Machine Life-cycle
==========================

The life-cycle of a Virtual Machine within OpenNebula includes the following stages:

.. warning:: Note that this is a simplified version. If you are a developer you may want to take a look at the complete diagram referenced in the :ref:`xml-rpc api page <api>`):

+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Short state |     State      |                                                                                                                                                 Meaning                                                                                                                                                  |
+=============+================+==========================================================================================================================================================================================================================================================================================================+
| ``pend``    | ``Pending``    | By default a VM starts in the pending state, waiting for a resource to run on. It will stay in this state until the scheduler decides to deploy it, or the user deploys it using the ``onevm deploy`` command.                                                                                           |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``hold``    | ``Hold``       | The owner has held the VM and it will not be scheduled until it is released. It can be, however, deployed manually.                                                                                                                                                                                      |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``prol``    | ``Prolog``     | The system is transferring the VM files (disk images and the recovery file) to the host in which the virtual machine will be running.                                                                                                                                                                    |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``boot``    | ``Boot``       | OpenNebula is waiting for the hypervisor to create the VM.                                                                                                                                                                                                                                               |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``runn``    | ``Running``    | The VM is running (note that this stage includes the internal virtualized machine booting and shutting down phases). In this state, the virtualization driver will periodically monitor it.                                                                                                              |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``migr``    | ``Migrate``    | The VM is migrating from one resource to another. This can be a life migration or cold migration (the VM is saved and VM files are transferred to the new resource).                                                                                                                                     |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``hotp``    | ``Hotplug``    | A disk attach/detach, nic attach/detach operation is in process.                                                                                                                                                                                                                                         |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``snap``    | ``Snapshot``   | A system snapshot is being taken.                                                                                                                                                                                                                                                                        |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``save``    | ``Save``       | The system is saving the VM files after a migration, stop or suspend operation.                                                                                                                                                                                                                          |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``epil``    | ``Epilog``     | In this phase the system cleans up the Host used to virtualize the VM, and additionally disk images to be saved are copied back to the system datastore.                                                                                                                                                 |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``shut``    | ``Shutdown``   | OpenNebula has sent the VM the shutdown ACPI signal, and is waiting for it to complete the shutdown process. If after a timeout period the VM does not disappear, OpenNebula will assume that the guest OS ignored the ACPI signal and the VM state will be changed to **running**, instead of **done**. |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``stop``    | ``Stopped``    | The VM is stopped. VM state has been saved and it has been transferred back along with the disk images to the system datastore.                                                                                                                                                                          |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``susp``    | ``Suspended``  | Same as stopped, but the files are left in the host to later resume the VM there (i.e. there is no need to re-schedule the VM).                                                                                                                                                                          |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``poff``    | ``PowerOff``   | Same as suspended, but no checkpoint file is generated. Note that the files are left in the host to later boot the VM there.                                                                                                                                                                             |
|             |                |                                                                                                                                                                                                                                                                                                          |
|             |                | When the VM guest is shutdown, OpenNebula will put the VM in this state.                                                                                                                                                                                                                                 |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unde``    | ``Undeployed`` | The VM is shut down. The VM disks are transfered to the system datastore. The VM can be resumed later.                                                                                                                                                                                                   |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``fail``    | ``Failed``     | The VM failed.                                                                                                                                                                                                                                                                                           |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``unkn``    | ``Unknown``    | The VM couldn't be reached, it is in an unknown state.                                                                                                                                                                                                                                                   |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``done``    | ``Done``       | The VM is done. VMs in this state won't be shown with ``onevm list`` but are kept in the database for accounting purposes. You can still get their information with the ``onevm show`` command.                                                                                                          |
+-------------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

|Virtual Machine States|

Managing Virtual Machines
=========================

The following sections show the basics of the ``onevm`` command with simple usage examples. A complete reference for these commands can be found :ref:`here <cli>`.

Create and List Existing VMs
----------------------------

.. warning:: Read the :ref:`Creating Virtual Machines guide <vm_guide>` for more information on how to manage and instantiate VM Templates.

.. warning:: Read the complete reference for :ref:`Virtual Machine templates <template>`.

Assuming we have a VM Template registered called *vm-example* with ID 6, then we can instantiate the VM issuing a:

.. code::

    $ onetemplate list
      ID USER     GROUP    NAME                         REGTIME
       6 oneadmin oneadmin vm_example            09/28 06:44:07

    $ onetemplate instantiate vm-example --name my_vm
    VM ID: 0


If the template has :ref:`USER INPUTS <vm_guide_user_inputs>` defined the CLI will prompt the user for these values:

.. code::

    $ onetemplate instantiate vm-example --name my_vm
    There are some parameters that require user input.
      * (BLOG_TITLE) Blog Title: <my_title>
      * (DB_PASSWORD) Database Password:
    VM ID: 0

Afterwards, the VM can be listed with the ``onevm list`` command. You can also use the ``onevm top`` command to list VMs continuously.

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin my_vm        pend   0      0K                 00 00:00:03

After a Scheduling cycle, the VM will be automatically deployed. But the deployment can also be forced by oneadmin using ``onevm deploy``:

.. code::

    $ onehost list
      ID NAME               RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM   STAT
       2 testbed              0    800    800    800    16G    16G    16G     on

    $ onevm deploy 0 2

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin my_vm        runn   0      0K         testbed 00 00:02:40

and details about it can be obtained with ``show``:

.. code::

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

Terminating VM Instances...
---------------------------

You can terminate a running instance with the following operations (either as ``onevm`` commands or through Sunstone):

-  ``shutdown``: Gracefully shuts down a running VM, sending the ACPI signal. Once the VM is shutdown the host is cleaned, and persistent and deferred-snapshot disk will be moved to the associated datastore. If after a given time the VM is still running (e.g. guest ignoring ACPI signals), OpenNebula will returned the VM to the ``RUNNING`` state.

-  ``shutdown --hard``: Same as above but the VM is immediately destroyed. Use this action instead of ``shutdown`` when the VM doesn't have ACPI support.

If you need to terminate an instance in any state use:

-  ``delete``: The VM is immediately destroyed no matter its state. Hosts are cleaned as needed but no images are moved to the repository, leaving then in error. Think of delete as kill -9 for a process, an so it should be only used when the VM is not responding to other actions.

All the above operations free the resources used by the VM

Pausing VM Instances...
-----------------------

There are two different ways to temporarily stop the execution of a VM: short and long term pauses. A **short term** pause keeps all the VM resources allocated to the hosts so its resume its operation in the same hosts quickly. Use the following ``onevm`` commands or Sunstone actions:

-  ``suspend``: the VM state is saved in the running Host. When a suspended VM is resumed, it is immediately deployed in the same Host by restoring its saved state.

-  ``poweroff``: Gracefully powers off a running VM by sending the ACPI signal. It is similar to suspend but without saving the VM state. When the VM is resumed it will boot immediately in the same Host.

-  ``poweroff --hard``: Same as above but the VM is immediately powered off. Use this action when the VM doesn't have ACPI support.

.. note:: When the guest is shutdown from within the VM, OpenNebula will put the VM in the ``poweroff`` state.

You can also plan a **long term pause**. The Host resources used by the VM are freed and the Host is cleaned. Any needed disk is saved in the system datastore. The following actions are useful if you want to preserve network and storage allocations (e.g. IPs, persistent disk images):

-  ``undeploy``: Gracefully shuts down a running VM, sending the ACPI signal. The Virtual Machine disks are transferred back to the system datastore. When an undeployed VM is resumed, it is be moved to the pending state, and the scheduler will choose where to re-deploy it.

-  ``undeploy --hard``: Same as above but the running VM is immediately destroyed.

-  ``stop``: Same as ``undeploy`` but also the VM state is saved to later resume it.

When the VM is successfully paused you can resume its execution with:

-  ``resume``: Resumes the execution of VMs in the stopped, suspended, undeployed and poweroff states.

Resetting VM Instances...
-------------------------

There are two ways of resetting a VM: in-host and full reset. The first one does not frees any resources and reset a RUNNING VM instance at the hypervisor level:

-  ``reboot``: Gracefully reboots a running VM, sending the ACPI signal.

-  ``reboot --hard``: Performs a 'hard' reboot.

A VM instance can be reset in any state with:

-  ``delete --recreate``: Deletes the VM as described above, but instead of disposing it the VM is moving again to PENDING state. As the delete operation this action should be used when the VM is not responding to other actions. Try undeploy or undeploy --hard first.

Delaying VM Instances...
------------------------

The deployment of a PENDING VM (e.g. after creating or resuming it) can be delayed with:

-  ``hold``: Sets the VM to hold state. The scheduler will not deploy VMs in the ``hold`` state. Please note that VMs can be created directly on hold, using 'onetemplate instantiate --hold' or 'onevm create --hold'.

Then you can resume it with:

-  ``release``: Releases a VM from hold state, setting it to pending. Note that you can automatically release a VM by scheduling the operation as explained below

Life-Cycle Operations for Administrators
----------------------------------------

There are some ``onevm`` commands operations meant for the cloud administrators:

**Scheduling:**

-  ``resched``: Sets the reschedule flag for the VM. The Scheduler will migrate (or migrate --live, depending on the :ref:`Scheduler configuration <schg_configuration>`) the VM in the next monitorization cycle to a Host that better matches the requirements and rank restrictions. Read more in the :ref:`Scheduler documentation <schg_re-scheduling_virtual_machines>`.
-  ``unresched``: Clears the reschedule flag for the VM, canceling the rescheduling operation.

**Deployment:**

-  ``deploy``: Starts an existing VM in a specific Host.
-  ``migrate --live``: The Virtual Machine is transferred between Hosts with no noticeable downtime. This action requires a :ref:`shared file system storage <sm>`.
-  ``migrate``: The VM gets stopped and resumed in the target host.

Note: By default, the above operations do not check the target host capacity. You can use the -e (-enforce) option to be sure that the host capacity is not overcommitted.

**Troubleshooting:**

-  ``boot``: Forces the hypervisor boot action of a VM stuck in UNKNOWN or BOOT state.
-  ``recover``: If the VM is stuck in any other state (or the boot operation does not work), you can recover the VM by simulating the failure or success of the missing action. You **have to check the VM state on the host** to decide if the missing action was successful or not.
-  ``migrate`` or ``resched``: A VM in the UNKNOWN state can be booted in a different host manually (``migrate``) or automatically by the scheduler (``resched``). This action must be performed only if the storage is shared, or manually transfered by the administrator. OpenNebula will not perform any action on the storage for this migration.

Disk Snapshoting
----------------

You can take a snapshot of a VM disk to preserve or backup its state at a given point of time. There are two types of disk snapshots in OpenNebula:

-  **Deferred snapshots**, changes to a disk will be saved as a new Image in the associated datastore when the VM is shutdown. The new image will be locked till the VM is properly shutdown and the transferred from the host to the datastore.
-  **Live snapshots**, just as the deferred snapshots, but the disk is copied to the datastore the moment the operation is triggered. Therefore, you must guarantee that the disk is in a consistent state during the copy operation (e.g. by umounting the disk from the VM). While the disk is copied to the datastore the VM will be in the HOTPLUG state.

The ``onevm disk-snapshot`` command can be run while the VM is RUNNING, POWEROFF or SUSPENDED. A deferred disk snapshot can be canceled with the ``onevm disk-snapshot-cancel`` command. See the :ref:`Image guide <img_guide_save_changes>` for specific examples of the disk-snapshot command.

Disk Hotpluging
---------------

New disks can be hot-plugged to running VMs with the ``onevm`` ``disk-attach`` and ``disk-detach`` commands. For example, to attach to a running VM the Image named **storage**:

.. code::

    $ onevm disk-attach one-5 --image storage

To detach a disk from a running VM, find the disk ID of the Image you want to detach using the ``onevm show`` command, and then simply execute ``onevm detach vm_id disk_id``:

.. code::

    $ onevm show one-5
    ...
    DISK=[
      DISK_ID="1",
    ...
      ]
    ...

    $ onevm disk-detach one-5 1

|image2|

.. _vm_guide2_nic_hotplugging:

NIC Hotpluging
--------------

You can also hotplug network interfaces to a RUNNING VM. Simply, specify the network where the new interface should be attach to, for example:

.. code::

    $ onevm show 2

    VIRTUAL MACHINE 2 INFORMATION
    ID                  : 2
    NAME                : centos-server
    USER                : ruben
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : RUNNING
    RESCHED             : No
    HOST                : cloud01

    ...

    VM NICS
    ID NETWORK      VLAN BRIDGE   IP              MAC
     0 net_172        no vbr0     172.16.0.201    02:00:ac:10:0

    VIRTUAL MACHINE HISTORY
     SEQ HOST            REASON           START            TIME     PROLOG_TIME
       0 cloud01         none    03/07 11:37:40    0d 00h02m14s    0d 00h00m00s
    ...

    $ onevm attachnic 2 --network net_172

After the operation you should see two NICs 0 and 1:

.. code::

    $ onevm show 2
    VIRTUAL MACHINE 2 INFORMATION
    ID                  : 2
    NAME                : centos-server
    USER                : ruben
    GROUP               : oneadmin

    ...


    VM NICS
    ID NETWORK      VLAN BRIDGE   IP              MAC
     0 net_172        no vbr0     172.16.0.201    02:00:ac:10:00:c9
                                  fe80::400:acff:fe10:c9
     1 net_172        no vbr0     172.16.0.202    02:00:ac:10:00:ca
                                  fe80::400:acff:fe10:ca
    ...

Also, you can detach a NIC by its ID. If you want to detach interface 1 (MAC=02:00:ac:10:00:ca), just:

.. code::

    > onevm detachnic 2 1

|image3|

.. _vm_guide2_snapshotting:

Snapshotting
------------

You can create, delete and restore snapshots for running VMs. A snapshot will contain the current disks and memory state.

.. warning:: The snapshots will only be available during the ``RUNNING`` state. If the state changes (stop, migrate, etc...) the snapshots **will** be lost.

.. code::

    $ onevm snapshot-create 4 "just in case"

    $ onevm show 4
    ...
    SNAPSHOTS
      ID         TIME NAME                                           HYPERVISOR_ID
       0  02/21 16:05 just in case                                   onesnap-0

    $ onevm snapshot-revert 4 0 --verbose
    VM 4: snapshot reverted

Please take into consideration the following limitations:

-  **The snapshots are lost if any life-cycle operation is performed, e.g. a suspend, migrate, delete request.**
-  KVM: Snapshots are only available if all the VM disks use the :ref:`qcow2 driver <img_template>`.
-  VMware: the snapshots will persist in the hypervisor after any life-cycle operation is performed, but they will not be available to be used with OpenNebula.
-  Xen: does not support snapshotting

|image4|

.. _vm_guide2_resizing_a_vm:

Resizing a VM
-------------

You may re-size the capacity assigned to a Virtual Machine in terms of the virtual CPUs, memory and CPU allocated. VM re-sizing can be done when the VM is not ACTIVE, an so in any of the following states: PENDING, HOLD, FAILED and specially in POWEROFF.

If you have created a Virtual Machine and you need more resources, the following procedure is recommended:

-  Perform any operation needed to prepare your Virtual Machine for shutting down, e.g. you may want to manually stop some services...
-  Poweroff the Virtual Machine
-  Re-size the VM
-  Resume the Virtual Machine using the new capacity

Note that using this procedure the VM will preserve any resource assigned by OpenNebula (e.g. IP leases)

The following is an example of the previous procedure from the command line (the Sunstone equivalent is straight forward):

.. code::

    > onevm poweroff web_vm
    > onevm resize web_vm --memory 2G --vcpu 2
    > onevm resume web_vm

From Sunstone:

|image5|

.. _vm_guide2_scheduling_actions:

Scheduling Actions
------------------

Most of the onevm commands accept the '--schedule' option, allowing users to delay the actions until the given date and time.

Here is an usage example:

.. code::

    $ onevm suspend 0 --schedule "09/20"
    VM 0: suspend scheduled at 2013-09-20 00:00:00 +0200

    $ onevm resume 0 --schedule "09/23 14:15"
    VM 0: resume scheduled at 2013-09-23 14:15:00 +0200

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : one-0

    [...]

    SCHEDULED ACTIONS
    ID ACTION        SCHEDULED         DONE MESSAGE
     0 suspend     09/20 00:00            -
     1 resume      09/23 14:15            -

These actions can be deleted or edited using the 'onevm update' command. The time attributes use Unix time internally.

.. code::

    $ onevm update 0

    SCHED_ACTION=[
      ACTION="suspend",
      ID="0",
      TIME="1379628000" ]
    SCHED_ACTION=[
      ACTION="resume",
      ID="1",
      TIME="1379938500" ]

These are the commands that can be scheduled:

-  ``shutdown``
-  ``shutdown --hard``
-  ``undeploy``
-  ``undeploy --hard``
-  ``hold``
-  ``release``
-  ``stop``
-  ``suspend``
-  ``resume``
-  ``boot``
-  ``delete``
-  ``delete-recreate``
-  ``reboot``
-  ``reboot --hard``
-  ``poweroff``
-  ``poweroff --hard``
-  ``snapshot-create``

.. _vm_guide2_user_defined_data:

User Defined Data
-----------------

Custom tags can be associated to a VM to store metadata related to this specific VM instance. To add custom attributes simply use the ``onevm update`` command.

.. code::

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

.. code::

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

Sunstone
========

You can manage your virtual machines using the :ref:`onevm command <cli>` or :ref:`Sunstone <sunstone>`.

In Sunstone, you can easily instantiate currently defined :ref:`templates <vm_guide>` by clicking ``New`` on the Virtual Machines tab and manage the life cycle of the new instances

|image6|

Using the noVNC Console
-----------------------

In order to use this feature, make sure that:

-  The VM template has a ``GRAPHICS`` section defined, that the ``TYPE`` attribute in it is set to ``VNC``.

-  The specified VNC port on the host on which the VM is deployed is accessible from the Sunstone server host.

-  The VM is in ``running`` state.

If the VM supports VNC and is ``running``, then the VNC icon on the Virtual Machines view should be visible and clickable:

|image7|

When clicking the VNC icon, the process of starting a session begins:

-  A request is made and if a VNC session is possible, Sunstone server will add the VM Host to the list of allowed vnc session targets and create a random token associated to it.

-  The server responds with the session token, then a ``noVNC`` dialog pops up.

-  The VNC console embedded in this dialog will try to connect to the proxy either using websockets (default) or emulating them using ``Flash``. Only connections providing the right token will be successful. Websockets are supported from Firefox 4.0 (manual activation required in this version) and Chrome. The token expires and cannot be reused.

|image8|

In order to close the VNC session just close the console dialog.

.. note:: From Sunstone 3.8, a single instance of the VNC proxy is launched when Sunstone server starts. This instance will listen on a single port and proxy all connections from there.

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
.. |image8| image:: /images/sunstonevnc4.png
