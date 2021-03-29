.. _troubleshoot:

===============
Troubleshooting
===============

Logging
=======

Every OpenNebula server generates logs with a configurable verbosity (level of detail) and through different means (file, syslog, or standard error output) to allow cloud administrators to troubleshoot the potential problems. Logs are stored in ``/var/log/one/`` on a Front-end Host with a particular component. Some valuable error messages can be also seen by the end-users in :ref:`CLI <cli>` tools or the :ref:`Sunstone GUI <sunstone>`.

Configure Logging System
------------------------

Follow the guides of each component to find the logs' location and configuration of log verbosity:

- OpenNebula Daemon: :ref:`logs <oned_conf_service>`, :ref:`configuration <oned_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Scheduler: :ref:`logs <sched_conf_service>`, :ref:`configuration <sched_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Monitoring: :ref:`logs <mon_conf_service>`, :ref:`configuration <mon_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Sunstone: :ref:`logs <sunstone_conf_service>`, :ref:`configuration <sunstone_conf>` (parameter ``:debug_level``)
- FireEdge: :ref:`logs <fireedge_conf_service>`, :ref:`configuration <fireedge_conf>` (parameter ``log``)
- OneFlow: :ref:`logs <oneflow_conf_service>`, :ref:`configuration <oneflow_conf>` (parameter ``:debug_level``)
- OneGate: :ref:`logs <onegate_conf_service>`, :ref:`configuration <onegate_conf>` (parameter ``:debug_level``)

After changing the logging level, don't forget to restart the service so that it can take effect.

.. important::

    Logs are rotated on (re)start of a particular component. Find a historic log alongside the current logs with date/time suffixes (e.g., latest ``/var/log/one/oned.log`` might have the following historic log ``/var/log/one/oned.log-20210321-1616319097``, or an even older compressed log ``/var/log/one/oned.log-20210314-1615719402.gz``)

.. _troubleshoot_additional:

Additional Resources
--------------------

As well as the common service logs, the following are other places to investigate and troubleshoot problems:

- **Virtual Machines**: The information specific to a VM will be dumped in the log file ``/var/log/one/<vmid>.log``. All VMs controlled by OpenNebula have their own directory, ``/var/lib/one/vms/<VID>`` if syslog/stderr isn't enabled. You can find the following information in it:

   -  **Deployment description files** : Stored in ``deployment.<EXECUTION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM (``deployment.0`` for the first host, ``deployment.1`` for the second and so on).
   -  **Transfer description files** : Stored in ``transfer.<EXECUTION>.<OPERATION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM, and ``<OPERATION>`` is the stage where the script was used, e.g. ``transfer.0.prolog``, ``transfer.0.epilog``, or ``transfer.1.cleanup``.

- **Drivers**: Each driver can have its ``ONE_MAD_DEBUG`` variable activated in **RC** files. If enabled, the error information will be dumped in ``/var/log/one/name-of-the-driver-executable.log``. Log information from the drivers is in ``oned.log``.

OpenNebula Daemon Log Format
----------------------------

The structure of OpenNebula Daemon log messages for a *file* based logging system is the following:

.. code-block:: none

    date [Z<zone_id>][module][log_level]: message body

In the case of *syslog* it follows the standard:

.. code-block:: none

    date hostname process[pid]: [Z<zone_id>][module][log_level]: message

where the ``zone_id`` is the ID of the Zone in the federation (``0`` for single Zone setups), the module is any of the internal OpenNebula components (``VMM``, ``ReM``, ``TM``, etc.), and the ``log_level`` is a single character indicating the log level (``I`` for informational, ``D`` for debugging, etc.).

For *syslog*, OpenNebula will also log the Virtual Machine events like this:

.. code-block:: none

    date hostname process[pid]: [VM id][Z<zone_id>][module][log_level]: message

and similarly for *stderr* logging.

For ``oned`` and VM events the formats are:

.. code-block:: none

    date [Z<zone_id>][module][log_level]: message
    date [VM id][Z<zone_id>][module][log_level]: message

Infrastructure Failures
=======================

.. _vm_history:

Virtual Machines
----------------

The causes of Virtual Machine errors can be found in the details of VM. Any VM owner or cloud administrator can see the error via the ``onevm show $ID`` command (or in the Sunstone GUI). For example:

.. prompt:: bash $ auto

    $ onevm show 0
    VIRTUAL MACHINE 0 INFORMATION
    ID                  : 0
    NAME                : one-0
    USER                : oneadmin
    GROUP               : oneadmin
    STATE               : ACTIVE
    LCM_STATE           : PROLOG_FAILED
    START TIME          : 07/19 17:44:20
    END TIME            : 07/19 17:44:31
    DEPLOY ID           : -

    VIRTUAL MACHINE MONITORING
    NET_TX              : 0
    NET_RX              : 0
    USED MEMORY         : 0
    USED CPU            : 0

    VIRTUAL MACHINE TEMPLATE
    CONTEXT=[
      FILES=/tmp/some_file,
      TARGET=hdb ]
    CPU=0.1
    ERROR=[
      MESSAGE="Error executing image transfer script: Error copying /tmp/some_file to /var/lib/one/0/images/isofiles",
      TIMESTAMP="Tue Jul 19 17:44:31 2011" ]
    MEMORY=64
    NAME=one-0
    VMID=0

    VIRTUAL MACHINE HISTORY
     SEQ        HOSTNAME ACTION           START        TIME       PTIME
       0          host01   none  07/19 17:44:31 00 00:00:00 00 00:00:00

The error message here (see ``ERROR=[MESSAGE="Error executing image...``) shows an error when copying an image (file ``/tmp/some_file``). The source file most likely doesn't exist. Alternatively, you can check the detailed log of a particular VM in ``/var/log/one/$ID.log`` (in this case the VM has ID ``0`` and the log file would be ``/var/log/one/0.log``)

.. _ftguide_virtual_machine_failures:

Recover from VM Failure
^^^^^^^^^^^^^^^^^^^^^^^

The overall state of a virtual machine in a failure condition will show as ``failure`` (or ``fail`` in the CLI). To find out the specific failure situation you need to check the ``LCM_STATE`` of the VM in the VM info tab (or ``onevm show`` in the CLI.). Moreover, a VM can be stuck in a transition (e.g. boot or save) because of a host or network failure. Typically these operations will eventually time out and lead to a VM failure state.

The administrator has the ability to force a recovery action from Sunstone or from the CLI, with the ``onevm recover`` command. This command has the following options:

* ``--success``: If the operation has been confirmed to succeed. For example, the administrator can see the VM properly running in the hypervisor, but the driver failed to inform OpenNebula of the successful boot.
* ``--failure``: This will have the same effect as a driver reporting a failure. It is intended for VMs that get stuck in transient states. As an example, if a storage problem occurs and the administrator knows that a VM stuck in ``prolog`` is not going to finish the pending transfer, this action will manually move the VM to ``prolog_failure``.
* ``--retry``: To retry the previously failed action. It can be used, for instance, if a VM is in ``boot_failure`` because the hypervisor crashed. The administrator can tell OpenNebula to retry the boot after the hypervisor is started again.
* ``--retry --interactive``: In some scenarios where the failure was caused by an error in the Transfer Manager actions, each action can be rerun and debugged until it works. Once the commands are successful, a ``success`` should be sent. See the specific section below for more details.
* ``--delete``: No recovery action possible, delete the VM. This is equivalent to the deprecated OpenNebula < 5.0 command: ``onevm delete``.
* ``--recreate``: No recovery action possible, delete and recreate the VM. This is equivalent to the deprecated OpenNebula < 5.0 command: ``onevm delete --recreate``.

Note also that OpenNebula will try to automatically recover some failure situations using the monitor information. A specific example is that a VM in the ``boot_failure`` state will become ``running`` if the monitoring reports that the VM was found running in the hypervisor.

Hypervisor Problems
"""""""""""""""""""

The following list details failure states caused by errors related to the hypervisor.

* ``BOOT_FAILURE``: The VM failed to boot but all the files needed by the VM are already in the Host. Check the hypervisor logs to find out the problem and, once fixed, recover the VM with the retry option.
* ``BOOT_MIGRATE_FAILURE``: same as above but during a migration. Check the target hypervisor and retry the operation.
* ``BOOT_UNDEPLOY_FAILURE``: same as above but during a resume after an undeploy. Check the target hypervisor and retry the operation.
* ``BOOT_STOPPED_FAILURE``: same as above but during a resume after a stop. Check the target hypervisor and retry the operation.

Transfer Manager / Storage Problems
"""""""""""""""""""""""""""""""""""

The following list details failure states caused by errors in the Transfer Manager driver. These states can be recovered by checking the ``vm.log`` and looking for the specific error (disk space, permissions, misconfigured datastore, etc). You can execute ``--retry`` to relaunch the Transfer Manager actions after fixing the problem (freeing disk space, etc). You can execute ``--retry --interactive`` to launch a Transfer Manager Interactive Debug environment that will allow you to: (1) see all the TM actions in detail (2) relaunch each action until it's successful (3) skip TM actions.

* ``PROLOG_FAILURE``: there was a problem setting up the disk images needed by the VM.
* ``PROLOG_MIGRATE_FAILURE``: problem setting up the disks in the target host.
* ``EPILOG_FAILURE``: there was a problem processing the disk images (may be discard or save) after the VM execution.
* ``EPILOG_STOP_FAILURE``: there was a problem moving the disk images after a stop.
* ``EPILOG_UNDEPLOY_FAILURE``: there was a problem moving the disk images after an undeploy.
* ``PROLOG_MIGRATE_POWEROFF_FAILURE``: problem restoring the disk images after a migration in a poweroff state.
* ``PROLOG_MIGRATE_SUSPEND_FAILURE``: problem restoring the disk images after a migration in a suspend state.
* ``PROLOG_RESUME_FAILURE``: problem restoring the disk images after a stop.
* ``PROLOG_UNDEPLOY_FAILURE``: problem restoring the disk images after an undeploy.

Here's an example of a Transfer Manager Interactive Debug environment (``onevm recover <id> --retry --interactive``):

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

Hosts
-----

Host errors can be investigated via the ``onehost show $ID`` command. For example:

.. prompt:: text $ auto

    $ onehost show 1
    HOST 1 INFORMATION
    ID                    : 1
    NAME                  : host01
    STATE                 : ERROR
    IM_MAD                : im_kvm
    VM_MAD                : vmm_kvm
    TM_MAD                : tm_shared

    HOST SHARES
    MAX MEM               : 0
    USED MEM (REAL)       : 0
    USED MEM (ALLOCATED)  : 0
    MAX CPU               : 0
    USED CPU (REAL)       : 0
    USED CPU (ALLOCATED)  : 0
    TOTAL VMS             : 0

    MONITORING INFORMATION
    ERROR=[
      MESSAGE="Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes",
      TIMESTAMP="Tue Jul 19 17:17:22 2011" ]

The error message here (see ``ERROR=[MESSAGE="Error monitoring host...``) shows an error when updating remote drivers on a host. To get more information, you have to check OpenNebula Daemon log (``/var/log/one/oned.log``) and, for example, see this relevant error:

.. code-block:: none

    Tue Jul 19 17:17:22 2011 [InM][I]: Monitoring host host01 (1)
    Tue Jul 19 17:17:22 2011 [InM][I]: Command execution fail: scp -r /var/lib/one/remotes/. host01:/var/tmp/one
    Tue Jul 19 17:17:22 2011 [InM][I]: ssh: Could not resolve hostname host01: nodename nor servname provided, or not known
    Tue Jul 19 17:17:22 2011 [InM][I]: lost connection
    Tue Jul 19 17:17:22 2011 [InM][I]: ExitCode: 1
    Tue Jul 19 17:17:22 2011 [InM][E]: Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes

The error message (``Could not resolve hostname``) explains there is the incorrect hostname of OpenNebula Host, which can't be resolved in DNS.
