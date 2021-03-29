.. _devel-im:

================================================================================
Monitoring Driver
================================================================================

The Monitoring Drivers (or IM drivers) collect host and virtual machine monitoring data by executing a monitoring agent in the hosts. The agent periodically executes probes to collect data and periodically send them to the frontend.

This guide describes the internals of the monitoring system. It is also a starting point on how to create a new IM driver from scratch.

Message structure
================================================================================

The structure of monitoring message is:

.. code::

    MESSAGE_TYPE ID RESULT TIMESTAMP PAYLOAD

+-----------------+--------------------------------------------------------------------------+
| Name            | Description                                                              |
+=================+==========================================================================+
| MESSAGE_TYPE    | SYSTEM_HOST, MONITOR_HOST, BEACON_HOST, MONITOR_VM or STATE_VM           |
+-----------------+--------------------------------------------------------------------------+
| ID              | ID of the host, which generates the message.                             |
+-----------------+--------------------------------------------------------------------------+
| RESULT          | Result of the action, possible values SUCCESS or FAILURE                 |
+-----------------+--------------------------------------------------------------------------+
| TIMESTAMP       | Timestamp of the message as unix epoch time                              |
+-----------------+--------------------------------------------------------------------------+
| PAYLOAD         | Message data, depends on MESSAGE_TYPE                                    |
+-----------------+--------------------------------------------------------------------------+

Description of message types:

- **SYSTEM_HOST** - General information about the host, which doesn't change too often (e.g. total memory, disk cpacity, datastores, pci devices, NUMA nodes, ...)
- **MONITOR_HOST** - Monitoring information: used memory, used cpu, network traffic, ...
- **BEACON_HOST** - notification message, indicating that the agent is still alive
- **MONITOR_VM** - VMs monitoring information: used memory, used CPUs, disk io, ...
- **STATE_VM** - VMs state: running, poweroff, ...

The provided hypervisors compose each message from data provided by probes in a specific directory:

- SYSTEM_HOST - ``im/<hypervisor>-probes.d/host/system``
- MONITOR_HOST - ``im/<hypervisor>-probes.d/host/monitor``
- BEACON_HOST - ``im/<hypervisor>-probes.d/host/beacon``
- MONITOR_VM - ``im/<hypervisor>-probes.d/vm/monitor``
- STATE_VM - ``im/<hypervisor>-probes.d/vm/status``

Each IM probe is composed of one or several scripts that write to ``stdout`` information in this form:

.. code::

    KEY1="value"
    KEY2="another value with spaces"

.. _devel-im_basic_monitoring_scripts:

Basic Monitoring Scripts
================================================================================

Mandatory values for each category are described below:

SYSTEM_HOST Message
-------------------
+---------------+-----------------------------------------------------------+
| Key           | Description                                               |
+===============+===========================================================+
| HYPERVISOR    | Name of the hypervisor of the host, useful for            |
|               | selecting the hosts with an specific technology.          |
+---------------+-----------------------------------------------------------+
| TOTALCPU      | Number of CPUs multiplied by 100. For example,            |
|               | a 16 cores machine will have a value of 1600.             |
+---------------+-----------------------------------------------------------+
| CPUSPEED      | Speed in Mhz of the CPUs.                                 |
+---------------+-----------------------------------------------------------+
| TOTALMEMORY   | Maximum memory that could be used for VMs. It is advised  |
|               | to take out the memory used by the hypervisor.            |
+---------------+-----------------------------------------------------------+


MONITOR_HOST Message
--------------------
+---------------+-----------------------------------------------------------------------------------+
| Key           | Description                                                                       |
+===============+===================================================================================+
| USEDMEMORY    | Memory used, in kilobytes.                                                        |
+---------------+-----------------------------------------------------------------------------------+
| FREEMEMORY    | Available memory for VMs at that moment, in kilobytes.                            |
+---------------+-----------------------------------------------------------------------------------+
| FREECPU       | Percentage of idling CPU multiplied by the number of cores. For example, if 50%   |
|               | of the CPU is idling in a 4 core machine the value will be 200.                   |
+---------------+-----------------------------------------------------------------------------------+
| USEDCPU       | Percentage of used CPU multiplied by the number of cores.                         |
+---------------+-----------------------------------------------------------------------------------+
| NETRX         | Received bytes from the network                                                   |
+---------------+-----------------------------------------------------------------------------------+
| NETTX         | Transferred bytes to the network                                                  |
+---------------+-----------------------------------------------------------------------------------+


BEACON_HOST Message
-------------------
No data


MONITOR_VM Message
------------------
The format of the MONITOR_VM Message:

.. code::

    VM = [ ID="0",
           UUID="6c1e1565-50f4-43b6-ba71-0fe46477d2ec",
           MONITOR="Q1BVPSIxLjAxIgpNRU1PUlk9IjE0MDgxNiIKTkVUUlg9IjAiCk5FVFRYPSIwIgpESVNLUkRCWVRFUz0iNDQxNjU0NDQiCkRJU0tXUkJZVEVTPSIxMjY2Njg4IgpESVNLUkRJT1BTPSIxMjg5IgpESVNLV1JJT1BTPSI4ODEiCg=="]
    VM = [ ID="1",
           ... ]

+---------------+----------------------------------------------------------------------------------------------+
| Key           | Description                                                                                  |
+===============+==============================================================================================+
| ID            | ID of the VM in OpenNebula.                                                                  |
+---------------+----------------------------------------------------------------------------------------------+
| UUID          | Unique ID, must be unique across all hosts.                                                  |
+---------------+----------------------------------------------------------------------------------------------+
| MONITOR       | Base64 encoded monitoring information, the monitoring information includes following data:   |
+---------------+----------------------------------------------------------------------------------------------+
| TIMESTAMP     | Timestamp of the measurement.                                                                |
+---------------+----------------------------------------------------------------------------------------------+
| CPU           | Percentage of 1 CPU consumed (two fully consumed cpu is 200).                                |
+---------------+----------------------------------------------------------------------------------------------+
| MEMORY        | MEMORY consumption in kilobytes.                                                             |
+---------------+----------------------------------------------------------------------------------------------+
| DISKRDBYTES   | Amount of bytes read from disk.                                                              |
+---------------+----------------------------------------------------------------------------------------------+
| DISKRDIOPS    | Number of IO read operations.                                                                |
+---------------+----------------------------------------------------------------------------------------------+
| DISKWRBYTES   | Amount of bytes written to disk.                                                             |
+---------------+----------------------------------------------------------------------------------------------+
| DISKWRIOPS    | Number of IO write operations.                                                               |
+---------------+----------------------------------------------------------------------------------------------+
| NETRX         | Received bytes from the network.                                                             |
+---------------+----------------------------------------------------------------------------------------------+
| NETTX         | Sent bytes to the network.                                                                   |
+---------------+----------------------------------------------------------------------------------------------+


STATE_VM Message
----------------
The format of the STATE_VM message is:

.. code::

    VM=[
      ID=115,
      DEPLOY_ID=one-115,
      UUID="6c1e1565-50f4-43b6-ba71-0fe46477d2ec",
      STATE="RUNNING" ]
    VM=[
      ID=116,
      DEPLOY_ID=one-116,
      UUID="1a3f2513-50f4-43b6-ba71-0fe46477d2ec",
      STATE="POWEROFF" ]

+---------------+-------------------------------------------------------------------------------------------+
| Key           | Description                                                                               |
+===============+===========================================================================================+
| ID            | ID of the VM in OpenNebula.                                                               |
+---------------+-------------------------------------------------------------------------------------------+
| DEPLOY_ID     | ID of the VM in the hypervisor, usually unique in host.                                   |
+---------------+-------------------------------------------------------------------------------------------+
| UUID          | Unique ID, must be unique across all hosts.                                               |
+---------------+-------------------------------------------------------------------------------------------+
| STATE         | State of the VM (running, poweroff, ...).                                                 |
+---------------+-------------------------------------------------------------------------------------------+

.. _devel-im_vm_information:

System Datastore Information
================================================================================

Monitoring probes are also responsible to collect the datastore sizes and its available space. The datastores information is included in SYSTEM_HOST message.

.. code::

    DS_LOCATION_USED_MB=1
    DS_LOCATION_TOTAL_MB=12639
    DS_LOCATION_FREE_MB=10459
    DS = [
      ID = 0,
      USED_MB = 1,
      TOTAL_MB = 12639,
      FREE_MB = 10459
    ]
    DS = [
      ID = 1,
      USED_MB = 1,
      TOTAL_MB = 12639,
      FREE_MB = 10459
    ]
    DS = [
      ID = 2,
      USED_MB = 1,
      TOTAL_MB = 12639,
      FREE_MB = 10459
    ]

These are the meanings of the values:

+---------------------------+----------------------------------------------------------------------+
| Variable                  | Description                                                          |
+===========================+======================================================================+
| DS\_LOCATION\_USED\_MB    | Used space in megabytes in the DATASTORE LOCATION                    |
+---------------------------+----------------------------------------------------------------------+
| DS\_LOCATION\_TOTAL\_MB   | Total space in megabytes in the DATASTORE LOCATION                   |
+---------------------------+----------------------------------------------------------------------+
| DS\_LOCATION\_FREE\_MB    | FREE space in megabytes in the DATASTORE LOCATION                    |
+---------------------------+----------------------------------------------------------------------+
| ID                        | ID of the datastore, this is the same as the name of the directory   |
+---------------------------+----------------------------------------------------------------------+
| USED\_MB                  | Used space in megabytes for that datastore                           |
+---------------------------+----------------------------------------------------------------------+
| TOTAL\_MB                 | Total space in megabytes for that datastore                          |
+---------------------------+----------------------------------------------------------------------+
| FREE\_MB                  | Free space in megabytes for that datastore                           |
+---------------------------+----------------------------------------------------------------------+

The DATASTORE LOCATION is the path where the datastores are mounted. By default, it is ``/var/lib/one/datastores`` but it is specified in the second parameter of the script call.

Creating a New IM Driver
================================================================================

Choosing the Execution Engine
--------------------------------------------------------------------------------

OpenNebula provides two IM probe execution engines: ``one_im_sh`` and ``one_im_ssh``. ``one_im_sh`` is used to execute probes in the frontend, for example ``vcenter`` uses this engine as it collects data via an API call executed in the frontend. On the other hand, ``one_im_ssh`` is used when probes need to be run remotely in the hosts, which is the case for ``KVM``.

Populating the Probes
--------------------------------------------------------------------------------

Both ``one_im_sh`` and ``one_im_ssh`` require an argument which indicates the directory that contains the probes. This argument is appended with ”.d”. Also, you need to create:

-  The ``/var/lib/one/remotes/im/<im_name>.d`` directory with **only** 2 files, the same ones that are provided by default inside ``kvm.d``, which are: ``collectd-client_control.sh`` and ``collectd-client.rb``.
-  The probes should be actually placed in the ``/var/lib/one/remotes/im/<im_name>-probes.d`` folder.

Enabling the Driver
--------------------------------------------------------------------------------

A new IM section should be placed added to ``monitord.conf``.

Example:

.. code::

    IM_MAD = [
          name       = "ganglia",
          executable = "one_im_sh",
          arguments  = "ganglia" ]

