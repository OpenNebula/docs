.. _mon:
.. _imudppushg:

====================
Monitoring Overview
====================

This section provides an overview of the OpenNebula monitoring subsystem. The monitoring subsystem gathers information relative to the hosts and the virtual machines, such as the host status, basic performance indicators, as well as VM status and capacity consumption. This information is collected by executing a set of static probes provided by OpenNebula. The output of these probes is sent to OpenNebula using a push mechanism.

Overview
==================

Each host periodically sends monitoring data via UDP to the frontend which collects it and processes it in a dedicated module. This distributed monitoring system resembles the architecture of dedicated monitoring systems, using a lightweight communication protocol, and a push model.

OpenNebula starts a ``collectd`` daemon running in the frontend host that listens for UDP connections on port 4124. In the first monitoring cycle the OpenNebula connects to the host using ``ssh`` and starts a daemon that will execute the probe scripts and sends the collected data to the collectd daemon in the fronted every specific amount of seconds (configurable with the ``-i`` option of the ``collectd IM_MAD``). This way the monitoring subsystem doesn't need to make new ssh connections to the hosts when it needs data.

|image0|

If the agent stops in a specific host, OpenNebula will detect that no monitorization data is received from that hosts and will restart the probe with SSH.

Requirements
============

* The firewall of the frontend (if enabled) must allow UDP packages incoming from the hosts on port 4124.

OpenNebula Configuration
========================

Enabling the Drivers
--------------------

To enable this monitoring system ``/etc/one/oned.conf`` must be configured with the following snippets:

``collectd`` must be enabled both for KVM:

.. code::

    #-------------------------------------------------------------------------------
    #  Information Collector for KVM IM's.
    #-------------------------------------------------------------------------------
    #  This driver CANNOT BE ASSIGNED TO A HOST, and needs to be used with KVM
    #    -h  prints this help.
    #    -a  Address to bind the collectd sockect (defults 0.0.0.0)
    #    -p  UDP port to listen for monitor information (default 4124)
    #    -f  Interval in seconds to flush collected information (default 5)
    #    -t  Number of threads for the server (defult 50)
    #    -i  Time in seconds of the monitorization push cycle. This parameter must
    #        be smaller than MONITORING_INTERVAL, otherwise push monitorization will
    #        not be effective.
    #-------------------------------------------------------------------------------
    IM_MAD = [
          NAME       = "collectd",
          EXECUTABLE = "collectd",
          ARGUMENTS  = "-p 4124 -f 5 -t 50 -i 20" ]
    #-------------------------------------------------------------------------------

Valid arguments for this driver are:

-  **-a**: Address to bind the collectd socket (defaults 0.0.0.0)
-  **-p**: port number
-  **-f**: Interval in seconds to flush collected information to OpenNebula (default 5)
-  **-t**: Number of threads for the collectd server (defult 50)
-  **-i**: Time in seconds of the monitorization push cycle. This parameter must be smaller than MONITORING_INTERVAL (see below), otherwise push monitorization will not be effective.

**KVM**:

.. code::

    #-------------------------------------------------------------------------------
    #  KVM UDP-push Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    IM_MAD = [
          NAME          = "kvm",
          SUNSTONE_NAME = "KVM",
          EXECUTABLE    = "one_im_ssh",
          ARGUMENTS     = "-r 3 -t 15 kvm" ]
    #-------------------------------------------------------------------------------

The arguments passed to this driver are:

-  **-r**: number of retries when monitoring a host
-  **-t**: number of threads, i.e. number of hosts monitored at the same time

Monitoring Configuration Parameters
-----------------------------------

OpenNebula allows to customize the general behavior of the whole monitoring subsystem:

+------------------------+-----------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                               |
+========================+===========================================================================================================+
| MONITORING_INTERVAL    | Time in seconds between host and VM monitorization. It must have a value greater than the manager timer   |
+------------------------+-----------------------------------------------------------------------------------------------------------+
| HOST_PER_INTERVAL      | Number of hosts monitored in each interval.                                                               |
+------------------------+-----------------------------------------------------------------------------------------------------------+

.. warning:: Note that in this case HOST_PER_INTERVAL is only relevant when bootstrapping the monitor agents. Once the agents are up and running, OpenNebula does not polls the hosts.

.. _monitoring_troubleshooting:

Troubleshooting
===============

Healthy Monitoring System
-------------------------

Every (approximately) ``monitoring_push_cycle`` of seconds OpenNebula is receiving the monitoring data of every Virtual Machine and of a host like such:

.. code::

    Mon Nov 18 22:25:00 2013 [InM][D]: Host thost001 (1) successfully monitored.
    Mon Nov 18 22:25:01 2013 [VMM][D]: VM 0 successfully monitored: ...
    Mon Nov 18 22:25:21 2013 [InM][D]: Host thost001 (1) successfully monitored.
    Mon Nov 18 22:25:21 2013 [VMM][D]: VM 0 successfully monitored: ...
    Mon Nov 18 22:25:40 2013 [InM][D]: Host thost001 (1) successfully monitored.
    Mon Nov 18 22:25:41 2013 [VMM][D]: VM 0 successfully monitored: ...

However, if in ``oned.log`` a host is being monitored **actively** periodically (every ``MONITORING_INTERVAL`` seconds) then the monitorization is **not** working correctly:

.. code::

    Mon Nov 18 22:22:30 2013 [InM][D]: Monitoring host thost087 (87)
    Mon Nov 18 22:23:30 2013 [InM][D]: Monitoring host thost087 (87)
    Mon Nov 18 22:24:30 2013 [InM][D]: Monitoring host thost087 (87)

If this is the case it's probably because OpenNebula is receiving probes faster than it can process. See the Tuning section to fix this.

Monitoring Probes
-----------------

For the troubleshooting of errors produced during the execution of the monitoring probes, please refer to the :ref:`troubleshooting <monitoring_troubleshooting>` section.

Tuning & Extending
==================

Adjust Monitoring Interval Times
--------------------------------

In order to tune your OpenNebula installation with appropriate values of the monitoring parameters you need to adjust the **-i** option of the ``collectd IM_MAD`` (the monitoring push cycle).

If the system is not working healthily it will be due to the database throughput since OpenNebula will write the monitoring information to a database, an amount of ~4KB per VM. If the number of virtual machines is too large and the monitoring push cycle too low, OpenNebula will not be able to write that amount of data to the database.

Driver Files
------------

The probes are specialized programs that obtain the monitor metrics. Probes are defined for each hypervisor, and are located at ``/var/lib/one/remotes/im/kvm-probes.d`` for KVM.

You can easily write your own probes or modify existing ones, please see the :ref:`Information Manager Drivers <devel-im>` guide. Remember to synchronize the monitor probes in the hosts using ``onehost sync`` as described in the :ref:`Managing Hosts <host_guide_sync>` guide.

.. |image0| image:: /images/collector.png
