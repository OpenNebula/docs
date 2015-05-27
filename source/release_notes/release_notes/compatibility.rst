.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.12.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.14.

OpenNebula Administrators
================================================================================

System Datastores
--------------------------------------------------------------------------------
For OpenNebula < 4.14 access control to System Datastores is not checked by the scheduler or oned. In OpenNebula 4.12, the scheduler enforces access rights for hosts, but once a host is selected the scheduler deploys the VM in the highest ranked System DS compatible with the that host. This behavior has been changed in 4.14 and now USE rights on the System DS is required to deploy a VM in it.

You may need to update the permissions on your System DS in order to make them accessible to the users/groups. The pre-4.14 behavior can be emulated by granting USE right to OTHERS.

Virtual Data Centers
--------------------------------------------------------------------------------
Check the previous issue about System DS; you may need to add one or more System DS to your VDCs.

Virtual Machine Recovery Process
--------------------------------------------------------------------------------
The recover process of VMs has been redesign in 4.14. When a VM is in ``fail`` state it can be:

- recover with success, to move on to the next state.
- recover with retry, to retry the last driver operation.
- (*only for failed migrations*) recover with failure, to cancel the migration and go back to the previous host.

As a result the pre-4.14 final, and *un-recoverable*, FAILED state has been removed; and split for each point of failure. Any application checking for FAILED state needs to be upgraded for the new functionality.

.. todo::
    Update xsd files in the documentation. Add note in upgrade guide to remove FAILED VMs before upgrade.

Virtual Machine Hooks
--------------------------------------------------------------------------------
Hooks on ``FAILED`` states are no longer needed; any automatic recovery action needs to be hooked on the new ``LCM_STATES``.

Default Authentication Driver
-----------------------------

You can now specify ``DEFAULT_AUTH`` in ``oned.conf``, meaning that it is not necessary any more to create a link called ``default`` pointing to the desired default authentication driver, for example ``ldap``, in ``/var/lib/one/remotes/auth`` and it's not necessary any more to add ``default`` to the ``authn`` parameter in the ``AUTH_MAD`` section. However, for backwards compatibility it will continue to work, but we strongly recommed to specify directly the default auth in ``oned.conf``, for example: ``DEFAULT_AUTH = "ldap"``.


Virtual Machines
--------------------------------------------------------------------------------

* Disks and NIC :ref:`attach/detach actions <vm_guide_2>` are now available for VMs in the ``POWEROFF`` state. They were previously restricted to VMs in ``RUNNING`` only.
* Previous versions had a "save VM" functionality available through the Cloud View. This action has been redone to improve it, and make it available from other interfaces. Read more about it in the :ref:`Managing Virtual Machines guide <vm_guide2_clone_vm>`.

.. todo:: onevm disk-snapshot-cancel


Developers and Integrators
================================================================================

VM History Actions
--------------------------------------------------------------------------------

The :ref:`accounting records <accounting>` are individual Virtual Machine history records. A new record is created when a VM is stopped, suspended, migrated, etc. Starting in 4.14 a new record is also created when the Virtual Machine has a disk/nic attached or detached. Since the history record contains a copy of the Virtual Machine contents, this helps developers to keep track of the changes made to the disks and network interfaces of a Virtual Machine.

Virtual Machine Monitor Probes
--------------------------------------------------------------------------------
.. todo::
    * Add templates to probes for import
* When the monitor probe returns state 'e' for a Virtual Machine now it is moved to UNKNOWN state; instead of FAILED state, now removed.

XML-RPC API
--------------------------------------------------------------------------------

This section lists all the changes in the API. Visit the :ref:`complete reference <api>` for more information.

* New API calls:

  * ``one.vm.savediskcancel``

* API upgrades:

  * ``one.vm.recover`` now takes an integer as argument: 0 for failure, 1 for success and 2 for retries. Applications using the pre-4.14 interface may work because of the casting of the boolean recovery operation to the new integer value. However, given the extended functionality of the new recover implementation it is recommended to review the logic of any application using this API call.
  * ``one.vm.savedisk`` has one parameter less. The last boolean parameter was used to create a clone of the VM's source Template, replacing the first disk with the new snapshot. A new improved method was created in the :ref:`oca ruby <ruby>`. See the ``save_as_template`` `method for VirtualMachines </doc/stable/oca/ruby/OpenNebula/VirtualMachine.html>`_
  * ``one.document.lock``: New method to lock the document at the API level. The lock automatically expires after 2 minutes.
  * ``one.document.unlock``: New method to unlock the document at the API level.
