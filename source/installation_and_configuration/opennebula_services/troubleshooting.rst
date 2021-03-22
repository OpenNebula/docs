.. _log_debug:

===============
Troubleshooting
===============

Logging
=======

Every OpenNebula server generates logs with a configurable verbosity (level of detail) and through different means (file, syslog, or standard error output) to allow cloud administrators to troubleshoot the potential problems. Logs are stored in ``/var/log/one/`` on a Front-end host with a particular component. Some valuable error messages can be also seen by the end-users in :ref:`CLI <cli>` tools or the :ref:`Sunstone GUI <sunstone>`.

.. _log_debug_configure_the_logging_system:

Configure Logging System
------------------------

Follow guides of each component to find the logs location and configuration of log verbosity:

- OpenNebula Daemon: :ref:`logs <oned_conf_service>`, :ref:`configuration <oned_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Scheduler: :ref:`logs <sched_conf_service>`, :ref:`configuration <sched_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Monitoring: :ref:`logs <mon_conf_service>`, :ref:`configuration <mon_conf>` (parameter ``LOG/DEBUG_LEVEL``)
- Sunstone: :ref:`logs <sunstone_conf_service>`, :ref:`configuration <sunstone_conf>` (parameter ``:debug_level``)
- FireEdge: :ref:`logs <fireedge_conf_service>`, :ref:`configuration <fireedge_conf>` (parameter ``log``)
- OneFlow: :ref:`logs <oneflow_conf_service>`, :ref:`configuration <oneflow_conf>` (parameter ``:debug_level``)
- OneGate: :ref:`logs <onegate_conf_service>`, :ref:`configuration <onegate_conf>` (parameter ``:debug_level``)

After change of logging level, don't forget to restart the service to take affect.

.. important::

    Logs are rotated on (re)start of particular component, find a historic logs alongside the current logs with date/time suffixes (e.g., latest ``/var/log/one/oned.log`` might have following historic log ``/var/log/one/oned.log-20210321-1616319097``, or even older compressed log ``/var/log/one/oned.log-20210314-1615719402.gz``)

.. _log_debug_additional:

Additional Resources
--------------------

Except the common service logs, there are following other places to investigate and troubleshoot the problems:

- **Virtual Machines**: The information specific to a VM will be dumped into the log file ``/var/log/one/<vmid>.log``. All VMs controlled by OpenNebula have their own directory, ``/var/lib/one/vms/<VID>`` if syslog/stderr isn't enabled. You can find the following information in it:

   -  **Deployment description files** : Stored in ``deployment.<EXECUTION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM (``deployment.0`` for the first host, ``deployment.1`` for the second and so on).
   -  **Transfer description files** : Stored in ``transfer.<EXECUTION>.<OPERATION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM, and ``<OPERATION>`` is the stage where the script was used, e.g. ``transfer.0.prolog``, ``transfer.0.epilog``, or ``transfer.1.cleanup``.

- **Drivers**: Each driver can have its ``ONE_MAD_DEBUG`` variable activated in **RC** files. If enabled, the error information will be dumped to ``/var/log/one/name-of-the-driver-executable.log``. Log information from the drivers is in ``oned.log``.

OpenNebula Daemon Log Format
----------------------------

The structure of an OpenNebula Daemon log messages for a *file* based logging system is the following:

.. code-block:: none

    date [Z<zone_id>][module][log_level]: message body

In the case of *syslog* it follows the standard:

.. code-block:: none

    date hostname process[pid]: [Z<zone_id>][module][log_level]: message

where the ``zone_id`` is the ID of the zone in the federation (``0`` for single zone setups), the module is any of the internal OpenNebula components (``VMM``, ``ReM``, ``TM``, etc.), and the ``log_level`` is a single character indicating the log level (``I`` for informational, ``D`` for debugging, etc.).

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

Causes of Virtual Machines errors can be found in the details of VM. Any VM owner or cloud administrator can see the error via ``onevm show $ID`` command (or, in the Sunstone GUI). For example:

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

The error message here (see ``ERROR=[MESSAGE="Error executing image...``) shows an error when copying an image (file ``/tmp/some_file``). Source file most likely doesn't exist. Alternatively, you can check the detailed log of a particular VM in ``/var/log/one/$ID.log`` (in this case VM has ID ``0``, log file would be ``/var/log/one/0.log``)

.. note::

   Check the :ref:`Virtual Machines HA <ftguide>` guide, to learn how to recover a failed VM states.

Hosts
-----

Host errors can be investigate via ``onehost show $ID`` command. For example:

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

The error message here (see ``ERROR=[MESSAGE="Error monitoring host...``) shows an error with updating remote drivers on a host. To get more information, you have to check OpenNebula Daemon log (``/var/log/one/oned.log``) and for example, see this relevant error:

.. code-block:: none

    Tue Jul 19 17:17:22 2011 [InM][I]: Monitoring host host01 (1)
    Tue Jul 19 17:17:22 2011 [InM][I]: Command execution fail: scp -r /var/lib/one/remotes/. host01:/var/tmp/one
    Tue Jul 19 17:17:22 2011 [InM][I]: ssh: Could not resolve hostname host01: nodename nor servname provided, or not known
    Tue Jul 19 17:17:22 2011 [InM][I]: lost connection
    Tue Jul 19 17:17:22 2011 [InM][I]: ExitCode: 1
    Tue Jul 19 17:17:22 2011 [InM][E]: Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes

The error message (``Could not resolve hostname``) explains there is a wrong hostname of OpenNebula host, which can't be resolved in DNS.
