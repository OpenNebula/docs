.. _monitor_alert_resource:

================================================================================
OpenNebula Resource Metrics
================================================================================

This document provides an overview of the metrics collected by OpenNebula's default probes for each resource type and explains how this data is utilized within the system

Virtual Machine
--------------------------------------------------------------------------------
The monitoring probes gather information attributes and insert them in the VM template. This information is mainly used for:

  * Monitoring the status of the VM.
  * Gathering the resource usage data of the VM.

In general, you can find the following monitoring information for a VM. Note that each hypervisor may include additional attributes:

+---------------+-----------------------------------------------------------------------------------+
| Key           | Description                                                                       |
+===============+===================================================================================+
| ``ID``        | ID of the VM in OpenNebula.                                                       |
+---------------+-----------------------------------------------------------------------------------+
| ``UUID``      | Unique ID, must be unique across all hosts.                                       |
+---------------+-----------------------------------------------------------------------------------+
| ``MONITOR``   | Base64 encoded monitoring information (see details below).                        |
+---------------+-----------------------------------------------------------------------------------+

The MONITOR information includes the following data:

+-----------------+-----------------------------------------------------------------------------------+
| Key             | Description                                                                       |
+=================+===================================================================================+
| ``TIMESTAMP``   | Timestamp of the measurement.                                                     |
+-----------------+-----------------------------------------------------------------------------------+
| ``CPU``         | Percentage of 1 CPU consumed (two fully consumed CPUs is 2.0).                    |
+-----------------+-----------------------------------------------------------------------------------+
| ``MEMORY``      | MEMORY consumption in kilobytes.                                                  |
+-----------------+-----------------------------------------------------------------------------------+
| ``DISKRDBYTES`` | Amount of bytes read from disk.                                                   |
+-----------------+-----------------------------------------------------------------------------------+
| ``DISKRDIOPS``  | Number of IO read operations.                                                     |
+-----------------+-----------------------------------------------------------------------------------+
| ``DISKWRBYTES`` | Amount of bytes written to disk.                                                  |
+-----------------+-----------------------------------------------------------------------------------+
| ``DISKWRIOPS``  | Number of IO write operations.                                                    |
+-----------------+-----------------------------------------------------------------------------------+
| ``NETRX``       | Received bytes from the network.                                                  |
+-----------------+-----------------------------------------------------------------------------------+
| ``NETTX``       | Sent bytes to the network.                                                        |
+-----------------+-----------------------------------------------------------------------------------+

The metrics above are directly read from and stored in the monitoring database.

Additionally, the following derived metrics are calculated from the stored metrics and used for forecasting. These derived metrics are not stored in the database but are computed on-demand:

+-------------------+-----------------------------------------------------------------------------------+
| Key               | Description                                                                       |
+===================+===================================================================================+
| ``NETRX_BW``      | Network received bandwidth (rate of change of NETRX).                             |
+-------------------+-----------------------------------------------------------------------------------+
| ``NETTX_BW``      | Network transmitted bandwidth (rate of change of NETTX).                          |
+-------------------+-----------------------------------------------------------------------------------+
| ``DISKRD_BW``     | Disk read bandwidth (rate of change of DISKRDBYTES).                              |
+-------------------+-----------------------------------------------------------------------------------+
| ``DISKWR_BW``     | Disk write bandwidth (rate of change of DISKWRBYTES).                             |
+-------------------+-----------------------------------------------------------------------------------+
| ``DISKRDIOPS_BW`` | Rate of change of disk read IOPS.                                                 |
+-------------------+-----------------------------------------------------------------------------------+
| ``DISKWRIOPS_BW`` | Rate of change of disk write IOPS.                                                |
+-------------------+-----------------------------------------------------------------------------------+

Host
--------------------------------------------------------------------------------

The monitoring probes gather information attributes and insert them in the Host template. This information is mainly used for:

  * Monitoring the status of the Host to detect any error condition.
  * Gathering the configuration of the Host (e.g., capacity, PCI devices, or NUMA nodes). This information is used to control VM resource assignments.
  * Creating placement constraints for allocation of VMs, :ref:`see more details here <scheduler_overview>`.

In general, you can find the following monitoring information in a Host. Note that each hypervisor may include additional attributes:

+-----------------+----------------------------------------------------------------------------------------------------+
|    Key          |                                            Description                                             |
+=================+====================================================================================================+
| ``HYPERVISOR``  | Name of the hypervisor of the Host, useful for selecting the Hosts with a specific technology.     |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``ARCH``        | Architecture of the Host CPUs, e.g., x86_64.                                                       |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``MODELNAME``   | Model name of the Host CPU, e.g., Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz.                        |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``CPUSPEED``    | Speed in MHz of the CPUs.                                                                          |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``HOSTNAME``    | As returned by the ``hostname`` command.                                                           |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``VERSION``     | This is the version of the monitoring probes. Used to control local changes and the update process.|
+-----------------+----------------------------------------------------------------------------------------------------+
| ``MAX_CPU``     | Number of CPUs multiplied by 100. For example, a 16-core machine will have a value of 1600.        |
|                 | The value of RESERVED_CPU will be subtracted from the information reported by the                  |
|                 | monitoring system. This value is displayed as ``TOTAL CPU`` by the                                 |
|                 | ``onehost show`` command under the ``HOST SHARE`` section.                                         |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``MAX_MEM``     | Maximum memory that can be used for VMs. It is advised to discount the memory                      |
|                 | used by the hypervisor using RESERVED_MEM. This value is subtracted from the memory                |
|                 | amount reported. The value is displayed as ``TOTAL MEM`` by the ``onehost show``                   |
|                 | command under the ``HOST SHARE`` section.                                                          |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``MAX_DISK``    | Total space in megabytes in the DATASTORE LOCATION.                                                |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``USED_CPU``    | Percentage of used CPU multiplied by the number of cores. This value is displayed                  |
|                 | as ``USED CPU (REAL)`` by the ``onehost show`` command under the ``HOST SHARE`` section.           |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``USED_MEMORY`` | Memory used, in kilobytes. This value is displayed as ``USED MEMORY (REAL)``                       |
|                 | by the ``onehost show`` command under the ``HOST SHARE`` section.                                  |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``USED_DISK``   | Used space in megabytes in the DATASTORE LOCATION.                                                 |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``FREE_CPU``    | Percentage of idling CPU multiplied by the number of cores. For example,                           |
|                 | if 50% of the CPU is idling in a 4-core machine, the value will be 200.                            |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``FREE_MEMORY`` | Available memory for VMs at that moment, in kilobytes.                                             |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``FREE_DISK``   | Free space in megabytes in the DATASTORE LOCATION.                                                 |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``CPU_USAGE``   | Total CPU allocated to VMs running on the Host as requested in ``CPU``                             |
|                 | in each VM template. This value is displayed as ``USED CPU (ALLOCATED)``                           |
|                 | by the ``onehost show`` command under the ``HOST SHARE`` section.                                  |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``MEM_USAGE``   | Total MEM allocated to VMs running on the Host as requested in ``MEMORY``                          |
|                 | in each VM template. This value is displayed as ``USED MEM (ALLOCATED)``                           |
|                 | by the ``onehost show`` command under the ``HOST SHARE`` section.                                  |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``DISK_USAGE``  | Total size allocated to disk images of VMs running on the Host; computed                           |
|                 | using the ``SIZE`` attribute of each image and considering the datastore characteristics.          |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``NETRX``       | Received bytes from the network.                                                                   |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``NETTX``       | Transferred bytes to the network.                                                                  |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``WILD``        | Comma-separated list of VMs running in the Host that were not launched                             |
|                 | and are not currently controlled by OpenNebula.                                                    |
+-----------------+----------------------------------------------------------------------------------------------------+
| ``ZOMBIES``     | Comma-separated list of VMs running in the Host that were launched by                              |
|                 | OpenNebula but are not currently controlled by it.                                                 |
+-----------------+----------------------------------------------------------------------------------------------------+

The metrics above are directly read from and stored in the monitoring database.

Additionally, the following derived metrics are calculated from the stored metrics and used for forecasting. These derived metrics are not stored in the database but are computed on-demand:

+---------------+-----------------------------------------------------------------------------------+
| Key           | Description                                                                       |
+===============+===================================================================================+
+---------------+-----------------------------------------------------------------------------------+
| ``NETRX_BW``  | Network received bandwidth (rate of change of NETRX).                             |
+---------------+-----------------------------------------------------------------------------------+
| ``NETTX_BW``  | Network transmitted bandwidth (rate of change of NETTX).                          |
+---------------+-----------------------------------------------------------------------------------+
