.. _ftguide:
.. _vm_ha:

================================================================================
Virtual Machines High Availability
================================================================================

The goal of this section is to provide information to prepare for failures of the Virtual Machines or Hosts and to recover from them. These failures are categorized depending on whether they come from the physical infrastructure (Host failures) or from the virtualized infrastructure (VM crashes). In both scenarios, OpenNebula provides a cost-effective failover solution to minimize downtime from server and OS failures.

Host Failures
================================================================================

When OpenNebula detects that a Host is down, a hook can be triggered to deal with the situation. OpenNebula comes out-of-the-box with a script that can act as a hook to be triggered when a host enters the ``ERROR`` state. This can very useful to limit the downtime of a service due to a hardware failure, since it can redeploy the VMs on another host.

To set up this Host hook to be triggered in the ``ERROR`` state, you need to create it using the following template and command:

.. code::

    $ cat /usr/share/one/examples/host_hooks/error_hook

    ARGUMENTS       = "$TEMPLATE -m -p 5"
    ARGUMENTS_STDIN = "yes"
    COMMAND         = "ft/host_error.rb"
    NAME            = "host_error"
    STATE           = "ERROR"
    REMOTE          = "no"
    RESOURCE        = HOST
    TYPE            = state

    $ onehook create /usr/share/one/examples/host_hooks/error_hook

We are defining a host hook, named ``host_error``, that will execute the script ``ft/host_error.rb`` locally with the following arguments:

+---------------------+----------------------------------------------------------------------------------------------------+---------+
| Argument            | Description                                                                                        | Default |
+=====================+====================================================================================================+=========+
| ``$TEMPLATE``       | Template of the HOST which triggered the hook. In XML format, base64 encoded.                      | NA      |
+---------------------+----------------------------------------------------------------------------------------------------+---------+
| **Action**          | This defines the action to be performed upon the VMs that were running in the host that went down. | NA      |
|                     |                                                                                                    |         |
|                     | This can be:                                                                                       |         |
|                     |                                                                                                    |         |
|                     | - ``-m`` migrate VMs to another host. Only for images on shared storage (NFS, Ceph, ...)           |         |
|                     |    This option skips VMs deployed on local datastores, so they can be started after host recovery. |         |
|                     | - ``-r`` delete and recreate VMs running in the host. Their **state will be lost**!                |         |
|                     | - ``-d`` delete VMs running in the host.                                                           |         |
+---------------------+----------------------------------------------------------------------------------------------------+---------+
| **Force Inactive**  | ``-f`` force resubmission of VMs in SUSPEND and POWEROFF states                                    | False   |
+---------------------+----------------------------------------------------------------------------------------------------+---------+
| **Avoid Transient** | ``-p <n>`` avoid resubmission if host comes back after ``<n>`` monitoring cycles                   | 2       |
+---------------------+----------------------------------------------------------------------------------------------------+---------+
| **Avoid Fencing**   | ``--no-fencing`` avoid host fencing                                                                | False   |
+---------------------+----------------------------------------------------------------------------------------------------+---------+

More information on hooks :ref:`here <hooks>`.

.. warning:: Note that spurious network errors may lead to a VM being started twice on different hosts and possibly clashing on shared resources. The previous script needs to fence the error host to prevent split brain VMs. You may use any fencing mechanism for the host and invoke it within the error hook.

Tuning HA responsiveness
================================================================================

This HA mechanism is based on the host state monitoring. How long the host the host takes to be reported in ``ERROR`` is crucial for how quickly you want the VMs to be available.

There are multiple timers that you can adjust on ``/etc/one/monitord.conf`` to adjust this. ``BEACON_HOST`` dictates how often the host is checked to make sure it is responding. If it doesn't respond past ``MONITORING_INTERVAL_HOST`` then the frontend will attempt to restart the monitoring on the host.

This process tries to connect to the host via SSH, synchronize the probes and start their execution. It might be possible that this SSH connection hangs if the host is not responsive. This can lead to a situation where the VM workloads running on said host will be unavailable and the HA will not be present during this process. You can adjust how much are you comfortable with waiting for this ssh to fail by setting the parameter ``ConnectTimeout`` on the oneadmin ssh configuration at ``/var/lib/one/.ssh/config``.

The following is a an example configuration

.. code-block:: language

    Host *
    ServerAliveInterval 10
    ControlMaster no
    ControlPersist 70s
    ControlPath /run/one/ssh-socks/ctl-M-%C.sock
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ConnectTimeout 15

.. warning:: Consider that a temporary network/host problem or a small hiccup combined with short timers can lead to an overkill situation where the HA hook gets triggered too fast when waiting a few more seconds could have been fine. This is a tradeoff you'll have to be aware of when implementing HA.

Enabling Fencing
================================================================================

In order to enable fencing you need to implement file ``/var/lib/one/remotes/hooks/ft/fence_host.sh``:

- Update your hosts using ``onehost update <HOST_ID>`` and add there the attribute ``FENCE_IP`` with the fencing device IP.
- Update the above script and add ``USERNAME`` and ``PASSWORD`` of your fencing device.
- Remove the line ``echo ""Fence host not configured, please edit ft/fence_host.sh"" && exit 1`` from above script.
- Depending on your hardware provider, you will need to use a different tool to control the ILO, so please check your hardware manual, for example:

.. prompt:: bash $ auto

    while [ "$RETRIES" -gt 0 ]
    do
        fence_ilo5 -P --ip=$FENCE_IP --password="${PASSWORD}" --username="${USERNAME}" --action="${ACTION}" && exit 0
        RETRIES=$((RETRIES-1))
        sleep $SLEEP_TIME
    done

Continue with :ref:`Troubleshooting <ftguide_virtual_machine_failures>` guide to understand how to **recover failed VMs**.
