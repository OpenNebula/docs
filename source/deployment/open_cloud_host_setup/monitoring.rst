.. _mon:
.. _imudppushg:

====================
Monitoring
====================

This section provides an overview of the OpenNebula monitoring subsystem. The monitoring subsystem gathers information relative to the Hosts and the Virtual Machines, such as the Host status, basic performance indicators, as well as Virtual Machine status and capacity consumption. This information is collected by executing a set of probe programs provided by OpenNebula. The output of these probes is sent to OpenNebula using a push mechanism.

Overview
==================

Each host periodically sends monitoring data via the network to the frontend, which collects it and processes it in a dedicated module. This distributed monitoring system resembles the architecture of dedicated monitoring systems, using a lightweight communication protocol, and a push model.

As part of the regular boot up process, OpenNebula starts a ``onemonitord`` daemon running in the frontend that listens for network connections on port 4124, both UDP and TCP transports are used. Initially, OpenNebula connects to the host using ``ssh`` and starts a light agent that executes the probe scripts to collect and send data back to the ``onemonitord`` daemon in the frontend.

Probes are structured in information categories for host and virtual machine information. Every specific amount of seconds (configurable per category in the monitord.conf file) data is transmitted, so the monitoring subsystem doesn't need to make any additional connections to receive data.

|image0|

If information stop being received from a specific Host, OpenNebula will detect it (missing heartbeats) and will pro-actively restart the probe connecting through ``ssh``.

Requirements
============

* The firewall of the frontend (if enabled) must allow TCP and UDP packages incoming from the hosts on port 4124.

OpenNebula Configuration
========================

Enable the monitor daemon (onemonitord)
---------------------------------------

The monitor daemon should be activated by default in ``/etc/one/oned.conf`` as a monitor driver. Just verify you have the following lines:

.. code::

    IM_MAD = [
        NAME       = "monitord",
        EXECUTABLE = "onemonitord",
        ARGUMENTS  = "-c monitord.conf",
        THREADS    = 8 ]

This should be the only driver activated in this file. The following configuration attributes are available:

+------------------+------------------------------------------------------------------------------------+
| Parameter        | Description                                                                        |
+==================+====================================================================================+
| ``THREADS``      | number of threads used to process messages from monitor daemon                     |
+------------------+------------------------------------------------------------------------------------+

.. _mon_conf:

Configure the monitor daemon
----------------------------

The monitor daemon, ``onemonitord`` is configured in ``/etc/one/monitord.conf``. The following table describes the configuration attributes for it:

+---------------------+---------------------+------------------------------------------------------------------------------------+
| Parameter           | Attribute           | Description                                                                        |
+=====================+=====================+====================================================================================+
| ``MANAGER_TIMER``                         | Timer in seconds, monitord evaluates host timeouts                                 |
+---------------------+---------------------+------------------------------------------------------------------------------------+
| ``MONITORING_INTERVAL_HOST``              | Wait this time (seconds) without receiving any beacon before restarting the probes |
+---------------------+---------------------+------------------------------------------------------------------------------------+
| ``HOST_MONITORING_EXPIRATION_TIME``       | Seconds to expire host monitoring information, 0 to disable monitoring recording.  |
+---------------------+---------------------+------------------------------------------------------------------------------------+
| ``DB``              |  DB configuration will be that in ``oned.conf``, these are specifics for ``onemonitord``                 |
+                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``CONNECTIONS``     | DB connections. DB needs to be configured to support oned + monitord connections.  |
+---------------------+---------------------+------------------------------------------------------------------------------------+
|  ``NETWORK``        | Network configuration parameters                                                                         |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``ADDRESS``         | network address to bind the UDP/TCP listener to                                    |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``MONITOR_ADDRESS`` | Agents will send updates to this monitor address.                                  |
|                     |                     | If "auto" is used, agents will detect the address from the ssh connection          |
|                     |                     | frontend -> host ($SSH_CLIENT), "auto" is not usable for HA setup                  |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``PORT``            | listening port                                                                     |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``THREADS``         | number of threads used to receive messages from monitor probes                     |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``PUBKEY``          | Absolute path to public key. Empty for no encryption.                              |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``PRIKEY``          | Absolute path to private key. Empty for no encryption.                             |
+---------------------+---------------------+------------------------------------------------------------------------------------+
| ``PROBES_PERIOD``   | ``BEACON_HOST``     | Time in seconds to send heartbeat for the host                                     |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``SYSTEM_HOST``     | Time in seconds to send host static/configuration information                      |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``MONITOR_HOST``    | Time in seconds to send host variable information                                  |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``STATE_VM``        | Time in seconds to send VM status (ie. running, error, stopped...)                 |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``MONITOR_VM``      | Time in seconds to send VM resource usage metrics.                                 |
|                     +---------------------+------------------------------------------------------------------------------------+
|                     | ``SYNC_STATE_VM``   | Send a complete VM report if probes stopped more than ``SYNC_STATE_VM`` seconds    |
+---------------------+---------------------+------------------------------------------------------------------------------------+

Additionally you need to enable the drivers that ``onemonitord`` will use to interface the hypervisors in your cloud. In general, the following attributes can be tuned in the ``arguments`` section of the driver configuration (``IM_MAD``):

+-----------+------------------------------------------------------------------------------------+
| Argument  | Description                                                                        |
+===========+====================================================================================+
| ``-r``    | number of retries when monitoring a host                                           |
+-----------+------------------------------------------------------------------------------------+
| ``-t``    | number of threads it limits the hosts (started/stopped) at the same time           |
+-----------+------------------------------------------------------------------------------------+
| ``-w``    | Timeout in seconds to execute external commands (e.g. ssh connections)             |
+-----------+------------------------------------------------------------------------------------+

(Optional) Configure encryption of monitor messages
----------------------------------------------------

You can configure the probes to encrypt the monitor messages sent to the front-end. This may help to secure your environment when some of the hypervisors are in cloud/edge locations. Follow the next steps to configure encryption:

1. Generate a dedicated public and private keys for the monitor system. And place them in a safe place, we'll use ``/etc/one``. Do not use any passphrase to encrypt the private key.

.. code::

    $ ssh-keygen -f /etc/one/onemonitor
    Generating public/private rsa key pair.
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /etc/one/onemonitor
    Your public key has been saved in /etc/one/onemonitor.pub
    The key fingerprint is:
    SHA256:XlFQK35lZ0i2ncAZUbmkKJ8F8ra5uQJA3VGa36OP10I V

2. Change the format of the public key to PKCS#1

.. code::

    $ ssh-keygen -f /etc/one/onemonitor.pub -e -m pem > /etc/one/onemonitor_pem.pub

3. Update onemonitord.conf to use these keys:

.. code::

    NETWORK = [
      ...
      PUBKEY = "/etc/one/onemonitor_pem.pub",
      PRIKEY = "/etc/one/onemonitor"
    ]

4. Restart OpenNebula
5. Restart the probes in the hosts to use the keys:

.. code::

    $ onehost sync -f

(Optional) Configuring monitoring in HA
------------------------------------------

If you are running OpenNebula in a HA cluster, it is recommended to use a virtual IP for the ``MONITOR_ADDRESS`` attribute. This way the RAFT hook will move the monitor address and the probes does not be restarted. Simply adjust the RAFT hook configuration to include the monitor IP, see more details on :ref:`HA Setup guide (Raft Hooks) <oneha>`

(Optional) Adjust Monitoring Interval Times
-------------------------------------------

For medium size clouds the default values should perform well. For lager environments you may need to tune your OpenNebula installation with appropriate values of the monitoring parameters and monitoring intervals in ``PROBES_PERIOD`` section. The final values should consider the number of hosts and vms that in turns will determine the processing requirements for OpenNebula. Also, you may need to increase the number of threads (``THREADS``) in ``oned.conf`` and drivers in ``monitord.conf``.

If the system is not working healthily it could be due to the database throughput. If the number of virtual machines and hosts is too large and the monitoring periods too low, OpenNebula will not be able to write that amount of data to the database.

Extending the Monitor System
============================

The monitor system can be easily customize to include additional monitor metrics. These new metrics can be used to implement custom scheduling policies or gather data of interest for the hosts or VMs. Metrics are gather by probes, simple programs that output the metric value to standard output using OpenNebula Template syntax. For example, in a KVM hypervisor the system usage probe outputs:

.. code::

    host/monitor$ ./inux_usage.rb
    HYPERVISOR=kvm
    USEDMEMORY=2147156
    FREEMEMORY=5831016
    FREECPU=792
    USEDCPU=8
    NETRX=0
    NETTX=0

or the NUMA configuration probe:

.. code::

    host/system $ ./numa_host.rb
    HUGEPAGE = [ NODE_ID = "0", SIZE = "2048", PAGES = "0" ]
    HUGEPAGE = [ NODE_ID = "0", SIZE = "1048576", PAGES = "0" ]
    CORE = [ NODE_ID = "0", ID = "3", CPUS = "3,7" ]
    CORE = [ NODE_ID = "0", ID = "1", CPUS = "1,5" ]
    CORE = [ NODE_ID = "0", ID = "2", CPUS = "2,6" ]
    CORE = [ NODE_ID = "0", ID = "0", CPUS = "0,4" ]
    MEMORY_NODE = [ NODE_ID = "0", TOTAL = "7978172", DISTANCE = "0" ]

Probes are structured in different directories that determine the frequency they are executed and data sent back to the frontend. The layout in the filesystem is:

.. code::

    <hypervisor_name>-probes.d
    |-- host
    |   |-- beacon
    |   |   |-- date.sh
    |   |   |-- ...
    |   |
    |   |-- monitor
    |   |   |-- linux_usage.rb
    |   |   |--...
    |   |
    |   `-- system
    |       |-- architecture.sh
    |       |-- ...
    `-- vm
        |-- monitor
        |   |-- monitor_ds_vm.rb
        |   |-- ...
        |
        `-- status
            `-- state.rb

The pupose of each directory is described in the following table:

+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+
| Directory        | Purpose                                                                                                          | Update Frequency    |
+==================+==================================================================================================================+=====================+
| ``host/beacon``  | Heartbeat & watchdog to collect rouge probe processes                                                            | BEACON_HOST (30s)   |
+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+
| ``host/monitor`` | Monitor information (variable) (e.g. memory usage) stored in ``HOST/MONITORING``                                 | MONITOR_HOST (120s) |
+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+
| ``host/system``  | General quasi-static information about the host (e.g. NUMA nodes) stored in ``HOST/TEMPLATE`` and ``HOST/SHARE`` | SYSTEM_HOST (600s)  |
+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+
| ``vm/monitor``   | Monitor information (variable) (e.g. used cpu, network usage) stored in ``VM/MONITORING``                        | MONITOR_VM (90s)    |
+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+
| ``vm/state``     | State change notification, only send when a change is detected                                                   | STATE_VM (5s)       |
+------------------+------------------------------------------------------------------------------------------------------------------+---------------------+

If you need to add custom metrics the procedure is:

1. Develop a program that gathers the metric and output it in stdout
2. Place the program in the target directory, depending on the nature and object it should be one of ``host/monitor``, ``host/system`` or ``vm/monitor``. You should not modify probes in the other directories.
3. Increment the VERSION number in ``/var/lib/one/remotes/VERSION``
4. Distribute changes to the hosts by running ``onehost sync``.

.. _monitoring_troubleshooting:

Troubleshooting
===============

.. important:: When debuging the monitor system we recomend to increase the DEBUG level for both oned and monitord, and restart OpenNebula

Healthy Monitoring System
-------------------------

Default location for monitoring log file is ``/var/log/one/monitor.log``.  Every (approximately) configured monitor period OpenNebula is receiving the monitoring data of every Virtual Machine and of a host like such:

.. code::

    Sun Mar 15 22:12:15 2020 [Z0][HMM][I]: Successfully monitored VM: 0
    Sun Mar 15 22:13:10 2020 [Z0][HMM][I]: Successfully monitored host: 0
    Sun Mar 15 22:13:45 2020 [Z0][HMM][I]: Successfully monitored VM: 2
    Sun Mar 15 22:15:10 2020 [Z0][HMM][I]: Successfully monitored host: 1

However, if in ``monitor.log`` a host is being monitored **actively** periodically (every ``MONITORING_INTERVAL_HOST`` seconds) then the monitorization is **not** working correctly:

.. code::

    Sun Mar 15 22:31:55 2020 [Z0][HMM][D]: Monitoring host localhost(0)
    Sun Mar 15 22:31:59 2020 [Z0][HMM][D]: Start monitor success, host: 0
    Sun Mar 15 22:35:10 2020 [Z0][HMM][D]: Monitoring host localhost(0)
    Sun Mar 15 22:35:19 2020 [Z0][HMM][D]: Start monitor success, host: 0

If this is the case it's probably because Monitor Daemon doesn't receive any data from probes, could be caused by wrong UDP settings. You should not see restarting of monitor process

Monitoring Probes
-----------------

For the troubleshooting of errors produced during the execution of the monitoring probes, try to execute them directly through the command line as oneadmin in the hosts. Information about malformed messages should be reported in ``oned.log`` or ``monitord.log``


.. |image0| image:: /images/collector.png
