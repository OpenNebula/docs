===================
Logging & Debugging
===================

OpenNebula provides logs for many resources. It supports two logging
systems: file based logging systems and syslog logging.

In the case of file based logging, OpenNebula keeps separate log files
for each active component, all of them stored in ``/var/log/one``. To
help users and administrators find and solve problems, they can also
access some of the error messages from the `CLI </./cli>`__ or the
`Sunstone GUI </./sunstone>`__.

With syslog the logging strategy is almost identical, except that the
logging message change slightly their format following syslog logging
conventions.

Configure the Logging System
============================

The Logging system can be changed in **``/etc/one/oned.conf``**,
specifically under the **``LOG``** section. Two parameters can be
changed: **``SYSTEM``**, which is either 'syslog' or 'file' (default),
and the **``DEBUG_LEVEL``** is the logging verbosity.

For the scheduler the logging system can be changed in the exact same
way. In this case the configuration is in **``/etc/one/sched.conf``**.

Log Resources
=============

There are different log resources corresponding to different OpenNebula
components:

-  **ONE Daemon**: The core component of OpenNebula dumps all its
logging information onto ``/var/log/one/oned.log``. Its verbosity is
regulated by DEBUG\_LEVEL in ``/etc/one/oned.conf``. By default the
one start up scripts will backup the last oned.log file using the
current time, e.g. oned.log.20121011151807. Alternatively, this
resource can be logged to the syslog.

-  **Scheduler**: All the scheduler information is collected into the
/var/log/one/sched.log file. This resource can also be logged to the
syslog.

-  **Virtual Machines**: The information specific of the VM will be
dumped in the log file ``/var/log/one/<vmid>.log``. All VMs
controlled by OpenNebula have their folder,
``/var/lib/one/vms/<VID>``, or to the syslog if enabled. You can find
the following information in it:

-  **Deployment description files** : Stored in
â€?\ ``deployment.<EXECUTION>``\ â€?, where ``<EXECUTION>`` is the
sequence number in the execution history of the VM (deployment.0
for the first host, deployment.1 for the second and so on).
-  **Transfer description files** : Stored in
â€?\ ``transfer.<EXECUTION>.<OPERATION>``\ â€?, where
``<EXECUTION>`` is the sequence number in the execution history of
the VM, ``<OPERATION>`` is the stage where the script was used,
e.g. transfer.0.prolog, transfer.0.epilog, or transfer.1.cleanup.

-  **Drivers**: Each driver can have activated its **ONE\_MAD\_DEBUG**
variable in their **RC** files (see the `Drivers configuration
section </./cg#drivers_configuration>`__ for more details). If so,
error information will be dumped to
``/var/log/one/name-of-the-driver-executable.log``; log information
of the drivers is in ``oned.log``.

Logging Fromat
==============

The anatomy of an OpenNebula message for a file based logging system is
the following:

.. code::

date [module][log_level]: message body

In the case of syslog it follows the standard:

.. code::

date hostname process[pid]: [module][log_level]: message body

Where module is any of the internal OpenNebula components: â€œVMMâ€?,
â€œReMâ€?, â€œTMâ€?, etc. And the log\_level is a single character
indicating the log level: I for info, D for debug, etc.

For the syslog, OpenNebula will also log the Virtual Machine events like
this:

.. code::

date hostname process[pid]: [VM id][module][log_level]: message body

Virtual Machine Errors
======================

Virtual Machine errors can be checked by the owner or an administrator
using the ``onevm show`` output:

.. code::

$ onevm show 0
VIRTUAL MACHINE 0 INFORMATION
ID                  : 0
NAME                : one-0
USER                : oneadmin
GROUP               : oneadmin
STATE               : FAILED
LCM_STATE           : LCM_INIT
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
SEQ        HOSTNAME REASON           START        TIME       PTIME
0          host01   erro  07/19 17:44:31 00 00:00:00 00 00:00:00

Here the error tells that it could not copy a file, most probably it
does not exist.

Alternatively you can also check the log files for the VM at
``/var/log/one/<vmid>.log``.

Host Errors
===========

Host errors can be checked executing the ``onehost show`` command:

.. code::

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
RUNNING VMS           : 0

MONITORING INFORMATION
ERROR=[
MESSAGE="Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes",
TIMESTAMP="Tue Jul 19 17:17:22 2011" ]

The error message appears in the ``ERROR`` value of the monitoring. To
get more information you can check ``/var/log/one/oned.log``. For
example for this error we get in the log file:

.. code:: code

Tue Jul 19 17:17:22 2011 [InM][I]: Monitoring host host01 (1)
Tue Jul 19 17:17:22 2011 [InM][I]: Command execution fail: scp -r /var/lib/one/remotes/. host01:/var/tmp/one
Tue Jul 19 17:17:22 2011 [InM][I]: ssh: Could not resolve hostname host01: nodename nor servname provided, or not known
Tue Jul 19 17:17:22 2011 [InM][I]: lost connection
Tue Jul 19 17:17:22 2011 [InM][I]: ExitCode: 1
Tue Jul 19 17:17:22 2011 [InM][E]: Error monitoring host 1 : MONITOR FAILURE 1 Could not update remotes

From the execution output we notice that the host name is not know,
probably a mistake naming the host.
