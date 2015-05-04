.. _ftguide:

===================================
Virtual Machines High Availability
===================================

OpenNebula delivers the availability required by most applications running in virtual machines. This guide's objective is to provide information in order to prepare for failures in the virtual machines or physical nodes, and recover from them. These failures are categorized depending on whether they come from the physical infrastructure (Host failures) or from the virtualized infrastructure (VM crashes). In both scenarios, OpenNebula provides a cost-effective failover solution to minimize downtime from server and OS failures.

If you are interested in setting up a high available cluster for OpenNebula, check the :ref:`High OpenNebula Availability Guide <oneha>`.

Host Failures
=============

When OpenNebula detects that a host is down, a hook can be triggered to deal with the situation. OpenNebula comes with a script out-of-the-box that can act as a hook to be triggered when a host enters the ERROR state. This can very useful to limit the downtime of a service due to a hardware failure, since it can redeploy the VMs on another host.

Let's see how to configure ``/etc/one/oned.conf`` to set up this Host hook, to be triggered in the ERROR state. The following should be uncommented in the mentioned configuration file:

.. code::

    #-------------------------------------------------------------------------------
    HOST_HOOK = [
        name      = "error",
        on        = "ERROR",
        command   = "host_error.rb",
        arguments = "$HID -r",
        remote    = no ]
    #-------------------------------------------------------------------------------

We are defining a host hook, named ``error``, that will execute the script 'host\_error.rb' locally with the following arguments:

+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Argument      |                                                                                      Description                                                                                       |
+====================+========================================================================================================================================================================================+
| **Host ID**        | ID of the host containing the VMs to treat. It is compulsory and better left to **$HID**, that will be automatically filled by OpenNebula with the Host ID of the host that went down. |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Action**         | This defined the action to be performed upon the VMs that were running in the host that went down. This can be **-r** (recreate) or **-d** (delete).                                   |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ForceSuspended** | [-f] force resubmission of suspended VMs                                                                                                                                               |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **AvoidTransient** | [-p <n>] avoid resubmission if host comes back after <n> monitoring cycles                                                                                                             |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

More information on hooks :ref:`here <hooks>`.

.. warning:: Note that spurious network errors may lead to a VM started twice in different hosts and possibly contend on shared resources. The previous script needs to fence the error host to prevent split brain VMs. You may use any fencing mechanism for the host and invoke it within the error hook.

Virtual Machine Failures
========================

The overall state of a virtual machine in a failure condition will show as ``failure`` (or ``fail`` in the CLI). To find out the specific failure situation you need to check the ``LCM_STATE`` of the VM in the VM info tab (or ``onevm show`` in the CLI.). Moreover, a VM can be stuck in a transition (e.g. boot or save) because of a host or network failure. Typically these operations will eventually timeout and lead to a VM failure state.

Independent from the nature of the failure or if the VM is stuck, there are 3 recovery operations:

- **Success**, the operation has been confirmed to succeed (e.g. the VM has actually booted on the hyper visor). OpenNebula will update the VM status accordingly.

- **Retry**, the operation can be re-tried after a problem has been manually recovered (e.g. send again the boot order after bringing up a host again).

- **Fail**, will set the VM on failure to manually fix the infrastructure. Once the problem is fixed the VM can be recovered with any of the two previous operations.

Note also that OpenNebula will try to automatically recover some failure situations using the monitor information.

The following list details the specific failure conditions and steps needed to recover a VM in each case.

- ``BOOT_FAILURE``, The VM failed to boot but all the files needed by the VM are already in the host. Check the hypervisor logs to find out the problem, and once fixed recover the VM with the retry option.

- ``BOOT_MIGRATE_FAILURE``, same as above but during a migration. Check the target hypervisor and retry the operation.

- ``BOOT_UNDEPLOY_FAILURE``

- ``BOOT_STOPPED_FAILURE``

.. todo::

- ``PROLOG_FAILURE``, there was a problem setting up the disk images needed by the VM. Check the vm.log for the specific error (disk space, permissions, mis-configured datastore...). You can retry the operation once the problem is fixed. Note that you may need to manually rollback some operations.

- ``PROLOG_MIGRATE_FAILURE``

- ``PROLOG_MIGRATE_POWEROFF``

- ``EPILOG_FAILURE``

- ``EPILOG_FAILURE``

- ``EPILOG_STOP_FAILURE``

- ``EPILOG_UNDEPLOY_FAILURE``

- ``PROLOG_MIGRATE_POWEROFF_FAILURE``

- ``PROLOG_MIGRATE_SUSPEND``

- ``PROLOG_MIGRATE_SUSPEND_FAILURE``
