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
        arguments = "$HID -r n",
        remote    = no ]
    #-------------------------------------------------------------------------------

We are defining a host hook, named “error”, that will execute the script 'host\_error.rb' locally with the following arguments:

+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Argument          | Description                                                                                                                                                                              |
+===================+==========================================================================================================================================================================================+
| **Host ID**       | ID of the host containing the VMs to treat. It is compulsory and better left to **$HID**, that will be automatically filled by OpenNebula with the Host ID of the host that went down.   |
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Action**        | This defined the action to be performed upon the VMs that were running in the host that went down. This can be **-r** (recreate) or **-d** (delete).                                     |
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **DoSuspended**   | This argument tells the hook to perform Action to suspended VMs belonging to the host that went down (**y**), or not to perform Action to them (**n**) .                                 |
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

More information on hooks :ref:`here <hooks>`.

Additionally, there is a corner case that in critical production environments should be taken into account. OpenNebula also has become tolerant to network errors (up to a limit). This means that a spurious network error won't trigger the hook. But if this network error stretches in time, the hook may be triggered and the VMs deleted and recreated. When (and if) the network comes back, there will be a potential clash between the old and the reincarnated VMs. In order to prevent this, a script can be placed in the cron of every host, that will detect the network error and shutdown the host completely (or delete the VMs).

Virtual Machine Failures
========================

The Virtual Machine lifecycle management can fail in several points. The following two cases should cover them:

-  **VM fails**: This may be due to a network error that prevents the image to be staged into the node, a hypervisor related issue, a migration problem, etc. The common symptom is that the VM enters the FAILED state. In order to deal with these errors, a Virtual Machine hook can be set to “recreate” the failed VM (or, depending the production scenario, delete it). This can be achieved by uncommenting the following (for recreating, the deletion hook is also present in the same file) in ``/etc/one/oned.conf`` (and restarting ``oned``):

.. code::

    #-------------------------------------------------------------------------------
    VM_HOOK = [
       name      = "on_failure_recreate",
       on        = "FAILURE",
       command   = "onevm delete --recreate",
       arguments = "$VMID" ]
    #-------------------------------------------------------------------------------

-  **VM crash**: This point is concerned with crashes that can happen to a VM **after** it has been successfully booted (note that here boot doesn't refer to the actual VM boot process, but to the OpenNebula boot process, that comprises staging and hypervisor deployment). OpenNebula is able to detect such crashes, and report it as the VM being in an UNKNOWN state. This failure can be recovered from using the “onevm boot” functionality.

