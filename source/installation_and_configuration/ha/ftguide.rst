.. _ftguide:

===================================
Virtual Machines High Availability
===================================

This section's objective is to provide information in order to prepare for failures in the Virtual Machines or Hosts, and recover from them. These failures are categorized depending on whether they come from the physical infrastructure (Host failures) or from the virtualized infrastructure (VM crashes). In both scenarios, OpenNebula provides a cost-effective failover solution to minimize downtime from server and OS failures.

Host Failures
=============

When OpenNebula detects that a host is down, a hook can be triggered to deal with the situation. OpenNebula comes with a script out-of-the-box that can act as a hook to be triggered when a host enters the ERROR state. This can very useful to limit the downtime of a service due to a hardware failure, since it can redeploy the VMs on another host.

To set up this Host hook, to be triggered in the ERROR state, you need to create it using the following template and command:

.. code::

    $ cat /usr/share/one/examples/host_hooks/error_hook

    ARGUMENTS = "$TEMPLATE -m -p 5"
    ARGUMENTS_STDIN = "yes"
    COMMAND   = "ft/host_error.rb"
    NAME      = "host_error"
    STATE     = "ERROR"
    REMOTE    = "no"
    RESOURCE  = HOST
    TYPE      = state

    $ onehook create /usr/share/one/examples/host_hooks/error_hook

We are defining a host hook, named ``host_error``, that will execute the script ``ft/host_error.rb`` locally with the following arguments:

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Argument      |                                                                                      Description                                                                                      |
+====================+=======================================================================================================================================================================================+
| **$TEMPLATE**      | Template of the object, which triggered the hook. In xml format, base64 encoded.                                                                                                      |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Action**         | This defines the action to be performed upon the VMs that were running in the host that went down.                                                                                    |
|                    |                                                                                                                                                                                       |
|                    | This can be:                                                                                                                                                                          |
|                    |                                                                                                                                                                                       |
|                    | - **-m** migrate VMs to another host. Only for images in shared storage                                                                                                               |
|                    | - **-r** delete+recreate VMs running in the host. State will be lost.                                                                                                                 |
|                    | - **-d** delete VMs running in the host                                                                                                                                               |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ForceSuspended** | [-f] force resubmission of suspended VMs                                                                                                                                              |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **AvoidTransient** | [-p <n>] avoid resubmission if host comes back after <n> monitoring cycles                                                                                                            |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

More information on hooks :ref:`here <hooks>`.

.. warning:: Note that spurious network errors may lead to a VM started twice in different hosts and possibly contend on shared resources. The previous script needs to fence the error host to prevent split brain VMs. You may use any fencing mechanism for the host and invoke it within the error hook.

.. _ftguide_virtual_machine_failures:

Virtual Machine Failures
========================

The overall state of a virtual machine in a failure condition will show as ``failure`` (or ``fail`` in the CLI). To find out the specific failure situation you need to check the ``LCM_STATE`` of the VM in the VM info tab (or ``onevm show`` in the CLI.). Moreover, a VM can be stuck in a transition (e.g. boot or save) because of a host or network failure. Typically these operations will eventually timeout and lead to a VM failure state.

The administrator has the ability to force a recovery action from Sunstone or from the CLI, with the ``onevm recover`` command. This command has the following options:

* ``--success``: If the operation has been confirmed to succeed. For example, the administrator can see the VM properly running in the hypervisor, but the driver failed to inform OpenNebula of the successful boot.
* ``--failure``: This will have the same effect as a driver reporting a failure. It is intended for VMs that get stuck in transient states. As an example, if a storage problem occurs and the administrator knows that a VM stuck in ``prolog`` is not going to finish the pending transfer, this action will manually move the VM to ``prolog_failure``.
* ``--retry``: To retry the previously failed action. Can be used, for instance, in case a VM is in ``boot_failure`` because the hypervisor crashed. The administrator can tell OpenNebula to retry the boot after the hypervisor is started again.
* ``--retry --interactive``: In some scenarios where the failure was caused by an error in the Transfer Manager actions, each action can be rerun and debugged until it works. Once the commands are successful, a ``success`` should be sent. See the specific section below for more details.
* ``--delete``: No recover action possible, delete the VM. This is equivalent to the deprecated OpenNebula < 5.0 command: ``onevm delete``.
* ``--recreate``: No recover action possible, delete and recreate the VM. This is equivalent to the deprecated OpenNebula < 5.0 command: ``onevm delete --recreate``.

Note also that OpenNebula will try to automatically recover some failure situations using the monitor information. A specific example is that a VM in the ``boot_failure`` state will become ``running`` if the monitoring reports that the VM was found running in the hypervisor.

Hypervisor Problems
-------------------

The following list details failures states caused by errors related to the hypervisor.

* ``BOOT_FAILURE``: The VM failed to boot but all the files needed by the VM are already in the host. Check the hypervisor logs to find out the problem, and once fixed recover the VM with the retry option.
* ``BOOT_MIGRATE_FAILURE``: same as above but during a migration. Check the target hypervisor and retry the operation.
* ``BOOT_UNDEPLOY_FAILURE``: same as above but during a resume after an undeploy. Check the target hypervisor and retry the operation.
* ``BOOT_STOPPED_FAILURE``: same as above but during a resume after a stop. Check the target hypervisor and retry the operation.

Transfer Manager / Storage Problems
-----------------------------------

The following list details failure states caused by errors in the Transfer Manager driver. These states can be recovered by checking the ``vm.log`` and looking for the specific error (disk space, permissions, mis-configured datastore, etc). You can execute ``--retry`` to relaunch the Transfer Manager actions after fixing the problem (freeing disk space, etc). You can execute ``--retry --interactive`` to launch a Transfer Manager Interactive Debug environment that will allow you to: (1) see all the TM actions in detail (2) relaunch each action until its successful (3) skip TM actions.

* ``PROLOG_FAILURE``: there was a problem setting up the disk images needed by the VM.
* ``PROLOG_MIGRATE_FAILURE``: problem setting up the disks in the target host.
* ``EPILOG_FAILURE``: there was a problem processing the disk images (may be discard or save) after the VM execution.
* ``EPILOG_STOP_FAILURE``: there was a problem moving the disk images after a stop.
* ``EPILOG_UNDEPLOY_FAILURE``: there was a problem moving the disk images after an undeploy.
* ``PROLOG_MIGRATE_POWEROFF_FAILURE``: problem restoring the disk images after a migration in a poweroff state.
* ``PROLOG_MIGRATE_SUSPEND_FAILURE``: problem restoring the disk images after a migration in a suspend state.
* ``PROLOG_RESUME_FAILURE``: problem restoring the disk images after a stop.
* ``PROLOG_UNDEPLOY_FAILURE``: problem restoring the disk images after an undeploy.

Example of a Transfer Manager Interactive Debug environment (``onevm recover <id> --retry --interactive``):

.. prompt:: bash $ auto

    $ onevm show 2|grep LCM_STATE
    LCM_STATE           : PROLOG_UNDEPLOY_FAILURE

    $ onevm recover 2 --retry --interactive
    TM Debug Interactive Environment.

    TM Action list:
    (1) MV shared haddock:/var/lib/one//datastores/0/2/disk.0 localhost:/var/lib/one//datastores/0/2/disk.0 2 1
    (2) MV shared haddock:/var/lib/one//datastores/0/2 localhost:/var/lib/one//datastores/0/2 2 0

    Current action (1):
    MV shared haddock:/var/lib/one//datastores/0/2/disk.0 localhost:/var/lib/one//datastores/0/2/disk.0 2 1

    Choose action:
    (r) Run action
    (n) Skip to next action
    (a) Show all actions
    (q) Quit
    > r

    LOG I  Command execution fail: /var/lib/one/remotes/tm/shared/mv haddock:/var/lib/one//datastores/0/2/disk.0 localhost:/var/lib/one//datastores/0/2/disk.0 2 1
    LOG I  ExitCode: 1

    FAILURE. Repeat command.

    Current action (1):
    MV shared haddock:/var/lib/one//datastores/0/2/disk.0 localhost:/var/lib/one//datastores/0/2/disk.0 2 1

    Choose action:
    (r) Run action
    (n) Skip to next action
    (a) Show all actions
    (q) Quit
    > # FIX THE PROBLEM...

    > r

    SUCCESS

    Current action (2):
    MV shared haddock:/var/lib/one//datastores/0/2 localhost:/var/lib/one//datastores/0/2 2 0

    Choose action:
    (r) Run action
    (n) Skip to next action
    (a) Show all actions
    (q) Quit
    > r

    SUCCESS

    If all the TM actions have been successful and you want to
    recover the Virtual Machine to the RUNNING state execute this command:
    $ onevm recover 2 --success

    $ onevm recover 2 --success

    $ onevm show 2|grep LCM_STATE
    LCM_STATE           : RUNNING
