.. _log_debug:

====================
Troubleshooting
====================

OpenNebula provides logs for many resources. It supports three logging systems: file based logging systems, syslog logging and logging to the standard error stream.

In the case of file based logging, OpenNebula keeps separate log files for each active component, all of them stored in ``/var/log/one``. To help users and administrators find and solve problems, they can also access some of the error messages from the :ref:`CLI <cli>` or the :ref:`Sunstone GUI <sunstone>`.

With syslog or standard error, the logging strategy is almost identical, except that the logging messages slightly change their format following syslog logging conventions and resource information.

.. _log_debug_configure_the_logging_system:

Configure the Logging System
============================

The Logging system can be changed in :ref:`/etc/one/oned.conf <oned_conf>`, specifically under the ``LOG`` section. Two parameters can be changed: ``SYSTEM``, which is 'syslog', 'file' (default) or 'std', and the ``DEBUG_LEVEL`` is the logging verbosity.

For the scheduler the logging system can be changed in the exact same way. In this case the configuration is in :ref:`/etc/one/sched.conf <schg>`.

Log Resources
=============

There are different log resources corresponding to different OpenNebula components:

-  **ONE Daemon**: The core component of OpenNebula dumps all its logging information onto ``/var/log/one/oned.log``. Its verbosity is regulated by DEBUG_LEVEL in ``/etc/one/oned.conf``. By default the ONE start up scripts will backup the last ``oned.log`` file using the current time, e.g. ``oned.log.20121011151807``. Alternatively, this resource can be logged to the syslog.
-  **Scheduler**: All the scheduler information is collected into the ``/var/log/one/sched.log`` file. This resource can also be logged to the syslog.
-  **Virtual Machines**: The information specific to a VM will be dumped into the log file ``/var/log/one/<vmid>.log``. All VMs controlled by OpenNebula have their own directory, ``/var/lib/one/vms/<VID>`` if syslog/stderr isn't enabled. You can find the following information in it:

   -  **Deployment description files** : Stored in ``deployment.<EXECUTION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM (``deployment.0`` for the first host, ``deployment.1`` for the second and so on).
   -  **Transfer description files** : Stored in ``transfer.<EXECUTION>.<OPERATION>``, where ``<EXECUTION>`` is the sequence number in the execution history of the VM, and ``<OPERATION>`` is the stage where the script was used, e.g. ``transfer.0.prolog``, ``transfer.0.epilog``, or ``transfer.1.cleanup``.

-  **Drivers**: Each driver can have its **ONE\_MAD\_DEBUG** variable activated in **RC** files. If so, error information will be dumped to ``/var/log/one/name-of-the-driver-executable.log``. Log information from the drivers is in ``oned.log``.

Otherwise, the information is sent to syslog/stderr.

Logging Format
==============

The structure of an OpenNebula message for a file based logging system is the following:

.. code-block:: none

    date [Z<zone_id>][module][log_level]: message body

In the case of syslog it follows the standard:

.. code-block:: none

    date hostname process[pid]: [Z<zone_id>][module][log_level]: message

where the zone_id is the ID of the zone in the federation, 0 for single zone set ups, the module is any of the internal OpenNebula components: ``VMM``, ``ReM``, ``TM``, etc., and the log\_level is a single character indicating the log level: I for info, D for debug, etc.

For syslog, OpenNebula will also log the Virtual Machine events like this:

.. code-block:: none

    date hostname process[pid]: [VM id][Z<zone_id>][module][log_level]: message

and similarly for stderr logging.

For ``oned`` and VM events the formats are:

.. code-block:: none

    date [Z<zone_id>][module][log_level]: message
    date [VM id][Z<zone_id>][module][log_level]: message

.. _vm_history:

Virtual Machine Errors
======================

Virtual Machine errors can be checked by the owner or an administrator using the ``onevm show`` output:

.. prompt:: text $ auto

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
      MESSAGE="Error excuting image transfer script: Error copying /tmp/some_file to /var/lib/one/0/images/isofiles",
      TIMESTAMP="Tue Jul 19 17:44:31 2011" ]
    MEMORY=64
    NAME=one-0
    VMID=0

    VIRTUAL MACHINE HISTORY
     SEQ        HOSTNAME ACTION           START        TIME       PTIME
       0          host01   none  07/19 17:44:31 00 00:00:00 00 00:00:00

Here the error message that it could not copy a file most probably means the file does not exist.

Alternatively you can check the log files for the VM at ``/var/log/one/<vmid>.log``.

.. note::

   Check the :ref:`Virtual Machines High Availability Guide<ftguide>`, to learn how to recover a VM in ``fail`` state.

Host Errors
===========

Host errors can be checked executing the ``onehost show`` command:

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

The error message appears in the ``ERROR`` value of the monitoring. To get more information you can check ``/var/log/one/oned.log``. For example for this error we get in the log file:

.. code-block:: none

    Tue Jul 19 17:17:22 2011 [InM][I]: Monitoring host host01 (1)
    Tue Jul 19 17:17:22 2011 [InM][I]: Command execution fail: scp -r /var/lib/one/remotes/. host01:/var/tmp/one
    Tue Jul 19 17:17:22 2011 [InM][I]: ssh: Could not resolve hostname host01: nodename nor servname provided, or not known
    Tue Jul 19 17:17:22 2011 [InM][I]: lost connection
    Tue Jul 19 17:17:22 2011 [InM][I]: ExitCode: 1
    Tue Jul 19 17:17:22 2011 [InM][E]: Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes

From the execution output we notice that the host name is not known, probably due to a mistake naming the host.
