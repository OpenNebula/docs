.. _ftguide:
.. _vm_ha:

===================================
Virtual Machines High Availability
===================================

Goal of this section is to provide information in order to prepare for failures of the Virtual Machines or Hosts, and recover from them. These failures are categorized depending on whether they come from the physical infrastructure (Host failures) or from the virtualized infrastructure (VM crashes). In both scenarios, OpenNebula provides a cost-effective failover solution to minimize downtime from server and OS failures.

Host Failures
=============

When OpenNebula detects that a Host is down, a hook can be triggered to deal with the situation. OpenNebula comes out-of-the-box with a script that can act as a hook to be triggered when a host enters the ``ERROR`` state. This can very useful to limit the downtime of a service due to a hardware failure, since it can redeploy the VMs on another host.

To set up this Host hook, to be triggered in the ``ERROR`` state, you need to create it using the following template and command:

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

+----------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Argument                    |                                                                                      Description                                                                                      |
+==================================+=======================================================================================================================================================================================+
| ``$TEMPLATE``                    | Template of the object, which triggered the hook. In XML format, base64 encoded.                                                                                                      |
+----------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Action**                       | This defines the action to be performed upon the VMs that were running in the host that went down.                                                                                    |
|                                  |                                                                                                                                                                                       |
|                                  | This can be:                                                                                                                                                                          |
|                                  |                                                                                                                                                                                       |
|                                  | - ``-m`` migrate VMs to another host. Only for images on shared storage (NFS, Ceph, ...)                                                                                              |
|                                  | - ``-r`` delete and recreate VMs running in the host. Their **state will be lost**!                                                                                                   |
|                                  | - ``-d`` delete VMs running in the host                                                                                                                                               |
+----------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Force Suspended**              | ``-f`` force resubmission of suspended VMs                                                                                                                                            |
+----------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Avoid Transient**              | ``-p <n>`` avoid resubmission if host comes back after ``<n>`` monitoring cycles                                                                                                      |
+----------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

More information on hooks :ref:`here <hooks>`.

.. warning:: Note that spurious network errors may lead to a VM started twice in different hosts and possibly clash on shared resources. The previous script needs to fence the error host to prevent split brain VMs. You may use any fencing mechanism for the host and invoke it within the error hook.

Continue with :ref:`Troubleshooting <ftguide_virtual_machine_failures>` guide to understand how to **recover failed VMs**.
