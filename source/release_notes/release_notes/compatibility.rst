.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.12.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.14.

OpenNebula Administrators and Users
================================================================================

Virtual Network
--------------------------------------------------------------------------------
The VXLAN and 802.1Q  drivers clean the interfaces on the hosts once there is no VM left
using it. This way the number of interfaces and multicast addresses are kept under  control.
Please note that any other service coallocated with a VM network may be affected.

Also recent versions of the network drivers relay on new tools (e.g. ipset) so be sure to update the host packages as well.

System Datastores
--------------------------------------------------------------------------------
For OpenNebula < 4.14 access control to System Datastores is not checked by the scheduler or oned. In OpenNebula 4.12, the scheduler enforces access rights for hosts, but once a host is selected the scheduler deploys the VM in the highest ranked System DS compatible with the that host. This behavior has been changed in 4.14 and now USE rights on the System DS is required to deploy a VM in it.

You may need to update the permissions on your System DS in order to make them accessible to the users/groups. The pre-4.14 behavior can be emulated by granting USE right to OTHERS.

Virtual Data Centers
--------------------------------------------------------------------------------
Check the previous issue about System DS; you may need to add one or more System DS to your VDCs.

Virtual Machine Recovery Process
--------------------------------------------------------------------------------
The recover process of VMs has been redesigned in 4.14. When a VM is in ``fail`` state the admin has 3 choices:

- recover with success, to move on to the next state.
- recover with retry, to retry the last driver operation.
- (*only for failed migrations*) recover with failure, to cancel the migration and go back to the previous host.

As a result the previous ``FAILED`` state, that was final and un-recoverable, has been removed from the VM life-cycle. New states for each point of failure have been added instead.

The ``onevm boot`` command is deprecated. To recover a boot failure, use ``onevm recover --retry`` instead. Read the :ref:`Virtual Machine Failures guide <ftguide_virtual_machine_failures>` for more information.

Any application checking for that ``FAILED`` state need to be upgraded for the new LCM states:

* BOOT_FAILURE
* BOOT_MIGRATE_FAILURE
* PROLOG_MIGRATE_FAILURE
* PROLOG_FAILURE
* EPILOG_FAILURE
* EPILOG_STOP_FAILURE
* EPILOG_UNDEPLOY_FAILURE
* PROLOG_MIGRATE_POWEROFF_FAILURE
* PROLOG_MIGRATE_SUSPEND_FAILURE
* BOOT_UNDEPLOY_FAILURE
* BOOT_STOPPED_FAILURE
* PROLOG_RESUME_FAILURE
* PROLOG_UNDEPLOY_FAILURE

Virtual Machine Hooks
--------------------------------------------------------------------------------
Hooks on ``FAILED`` states are no longer needed; any automatic recovery action needs to be hooked on the new ``LCM_STATES``.

Default Authentication Driver
-----------------------------

You can now specify ``DEFAULT_AUTH`` in ``oned.conf``, meaning that it is not necessary any more to create a link called ``default`` pointing to the desired default authentication driver, for example ``ldap``, in ``/var/lib/one/remotes/auth`` and it's not necessary any more to add ``default`` to the ``authn`` parameter in the ``AUTH_MAD`` section. However, for backwards compatibility it will continue to work, but we strongly recommend to specify directly the default auth in ``oned.conf``, for example: ``DEFAULT_AUTH = "ldap"``.


Virtual Machine Management
--------------------------------------------------------------------------------

Disks and NIC :ref:`attach/detach actions <vm_guide_2>` are now available for VMs in the ``POWEROFF`` state. They were previously restricted to VMs in ``RUNNING`` only.

Previous versions had a "save VM" functionality available through the Cloud View. This action has been redone to improve it, and make it available from other interfaces. Read more about it in the :ref:`Managing Virtual Machines guide <vm_guide2_clone_vm>`.

There are 3 ``disk-snapshot`` actions in **4.14**. These disk-snapshots are not related to the **4.12** action. While in 4.12 a disk-snapshot was a new image saved in the datastore, in 4.14 disk-snaphosts are similar to system snapshots. A disk has many different snapshots, and the user can revert a single disk to a previous state at any time. See the :ref:`Disk Snapshots <vm_guide_2_disk_snapshots>` guide for more info.

- ``disk-snapshot-create <vmid> <diskid> <tag>``: Creates a new snapshot of the specified disk.
- ``disk-snapshot-revert <vmid> <diskid> <snapshot_id>``: Reverts to the specified snapshot. The snapshots are immutable, therefore the user can revert to the same snapshot one and again, the disk will return always to the state of the snapshot at the time it was taken.
- ``disk-snapshot-delete <vmid> <diskid> <snapshot_id>``: Deletes a snapshot if it has no children and is not active.

The 4.12 ``onevm disk-snapshot`` action has now been renamed to ``onevm disk-saveas``.

* ``onevm disk-snapshot`` (deferred), can now be accomplished by running ``onevm poweroff`` and once it's in that state, any disk can be saved by doing a new operation called ``onevm disk-saveas``. Note that now you can directly run ``onevm shutdown`` on a machine that is in ``POWEROFF`` state (i.e. you don't need to resume the VM).
* ``onevm disk-snapshot --live`` is now called ``onevm disk-saveas``

Sunstone
--------

* The ``marketplace_url`` param in sunstone-server.conf should not include the /appliance path since it will be automatically included in order to support proxy configurations

Developers and Integrators
================================================================================

VM History Actions
--------------------------------------------------------------------------------

The :ref:`accounting records <accounting>` are individual Virtual Machine history records. A new record is created when a VM is stopped, suspended, migrated, etc. Starting in 4.14 a new record is also created when the Virtual Machine has a disk/nic attached or detached. Since the history record contains a copy of the Virtual Machine contents, this helps developers to keep track of the changes made to the disks and network interfaces of a Virtual Machine.

Virtual Machine Monitor Probes
--------------------------------------------------------------------------------

* Monitor probes return :ref:`two additional attributes (IMPORT_TEMPLATE and VM_NAME) <devel-im_vm_information>` for each found VM, to aid the import workflow.

* When the monitor probe returns state 'e' for a Virtual Machine now it is moved to the ``UNKNOWN`` state. In previous versions VMs went to the ``FAILED`` state, now removed.

Datastore Drivers
--------------------------------------------------------------------------------

* There are 3 new Datastore Driver actions. The interface is documented in the :ref:`Storage Driver <sd>` guide. The end-user functionality is documented in the :ref:`Images <img_guide_snapshots>` guide.

  * ``snap_revert``: Overwrite the current image state with a snapshot. This operation discards any unsaved data in the current image state.
  * ``snap_flatten``: Reverts the current image state to a snapshot and removes all the snapshots.
  * ``snap_delete``: Deletes a snapshot.

Transfer Manager
--------------------------------------------------------------------------------

* There are 3 new TM actions. The interface is documented in the :ref:`Storage Driver <sd>` guide. The end-user functionality is documented in the :ref:`Virtual Machines <vm_guide_2_disk_snapshots_managing>` guide.

  * ``snap_create``: Handles the creation of a new disk-snapshot.
  * ``snap_revert``: Overwrite the current disk state with a disk-snapshot.
  * ``snap_delete``: Deletes a snapshot.

* The ``mvds`` now only manages saving persistent images back to the system datastore. For shared system datastores it will be a simple ``exit 0``. In previous OpenNebula versions this script also served the purpose saving disk marked withed ``SAVEAS`` at the end of the VM lifecycle (what used to be called a deferred disk-snapshot). Since this action is no longer possible (has been replaced with ``onevm disk-saveas`` -- see above) the ``mvds`` action has been largely simplified.

* The ``cpds`` action now accepts a ``snap_id`` argument. This is documented in the :ref:`Storage Driver <sd>` guide.

XML-RPC API
--------------------------------------------------------------------------------

This section lists all the changes in the API. Visit the :ref:`complete reference <api>` for more information.

* New API calls:

  * ``one.vm.disksnapshotcreate``
  * ``one.vm.disksnapshotrevert``
  * ``one.vm.disksnapshotdelete``

  * ``one.vm.disksaveas``

  * ``one.image.snapshotdelete``
  * ``one.image.snapshotrevert``
  * ``one.image.snapshotflatten``

  * ``one.document.lock``: New method to lock the document at the API level. The lock automatically expires after 2 minutes.
  * ``one.document.unlock``: New method to unlock the document at the API level.

* Deleted API methods:

  * ``one.vm.saveasdisk``

* Changed api calls:

  * ``one.vm.recover`` now takes an integer as argument: 0 for failure, 1 for success and 2 for retries. Applications using the pre-4.14 interface may work because of the casting of the boolean recovery operation to the new integer value. However, given the extended functionality of the new recover implementation it is recommended to review the logic of any application using this API call.
  * ``one.vm.action``: The action string "boot" is not available anymore.
  * ``one.template.info``: New parameter, "extended", to process the template and include extended information such as the SIZE for each DISK.

Sunstone
--------

* The Sunstone code base has been refactored and existing plugins develovep for OpenNebula < 4.14 will not work and should be adapted to the new module oriented implentation.

