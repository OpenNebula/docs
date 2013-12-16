.. _imsshpullg:

================================
KVM and Xen SSH-pull Monitoring
================================

KVM and Xen can be monitored with this ``ssh`` based monitoring system. The OpenNebula frontend starts a driver which triggers ``ssh`` connections to the hosts which return the monitoring information of the host and of all the virtual machines running within.

Requirements
============

-  ``ssh`` access from the frontends to the hosts as ``oneadmin`` without password has to be possible.
-  ``ruby`` is required in the hosts.
-  KVM hosts: ``libvirt`` must be enabled.
-  Xen hosts: ``sudo`` access to run ``xl`` or ``xm`` and ``xentop`` as ``oneadmin``.

OpenNebula Configuration
========================

Enabling the Drivers
--------------------

To enable this monitoring system ``/etc/one/oned.conf`` must be configured with the following snippets:

**KVM**:

.. code::

    IM_MAD = [
          name       = "kvm",
          executable = "one_im_ssh",
          arguments  = "-r 0 -t 15 kvm-probes" ]

**Xen 3.x**:

.. code::

    IM_MAD = [
        name       = "xen",
        executable = "one_im_ssh",
        arguments  = "-r 0 -t 15  xen3-probes" ]

**Xen 4.x**:

.. code::

    IM_MAD = [
        name       = "xen",
        executable = "one_im_ssh",
        arguments  = "-r 0 -t 15 xen4-probes" ]

The arguments passed to this driver are:

-  **-r**: number of retries when monitoring a host
-  **-t**: number of threads, i.e. number of hosts monitored at the same time

Monitoring Configuration Parameters
-----------------------------------

OpenNebula allows to customize the general behaviour of the whole monitoring subsystem:

+------------------------+-----------------------------------------------------------------------------------------------------------+
| Parameter              | Description                                                                                               |
+========================+===========================================================================================================+
| MONITORING\_INTERVAL   | Time in seconds between host and VM monitorization. It must have a value greater than the manager timer   |
+------------------------+-----------------------------------------------------------------------------------------------------------+
| HOST\_PER\_INTERVAL    | Number of hosts monitored in each interval.                                                               |
+------------------------+-----------------------------------------------------------------------------------------------------------+
| VM\_PER\_INTERVAL      | Number of VMs monitored in each interval.                                                                 |
+------------------------+-----------------------------------------------------------------------------------------------------------+

.. warning:: VM\_PER\_INTERVAL is only relevant in case of host failure when OpenNebula pro-actively monitors each VM.

The information gathered by the probes is also stored in a monitoring table. This table is used by Sunstone to draw monitoring graphics and can be queried using the OpenNebula API. The size of this table can be controlled with:

+--------------------------------------+---------------------------------------------------------------------------------------------------+
| Parameter                            | Description                                                                                       |
+======================================+===================================================================================================+
| HOST\_MONITORING\_EXPIRATION\_TIME   | Time, in seconds, to expire monitoring information. Use 0 to disable HOST monitoring recording.   |
+--------------------------------------+---------------------------------------------------------------------------------------------------+
| VM\_MONITORING\_EXPIRATION\_TIME     | Time, in seconds, to expire monitoring information. Use 0 to disable VM monitoring recording.     |
+--------------------------------------+---------------------------------------------------------------------------------------------------+

.. _imsshpullg_troubleshooting:

Troubleshooting
===============

In order to test the driver, add a host to OpenNebula using **onehost**, specifying the defined IM driver:

.. code::

    $ onehost create ursa06 --im xen --vm xen --net dummy

Now give it time to monitor the host (this time is determined by the value of MONITORING\_INTERVAL in ``/etc/one/oned.conf``). After one interval, check the output of **onehost list**, it should look like the following:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 ursa06          -           0       0 / 400 (0%)     0K / 7.7G (0%) on

Host management information is logged to ``/var/log/one/oned.log``. Correct monitoring log lines look like this:

.. code::

    Fri Nov 22 12:02:26 2013 [InM][D]: Monitoring host ursa06 (0)
    Fri Nov 22 12:02:30 2013 [InM][D]: Host ursa06 (0) successfully monitored.

Both lines have the ID of the host being monitored.

If there are problems monitoring the host you will get an ``err`` state:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 ursa06          -           0       0 / 400 (0%)     0K / 7.7G (0%) err

The way to get the error message for the host is using ``onehost show`` command, specifying the host id or name:

.. code::

    $ onehost show 0
    [...]
    MONITORING INFORMATION
    ERROR=[
      MESSAGE="Error monitoring host 0 : MONITOR FAILURE 0 Could not update remotes",
      TIMESTAMP="Nov 22 12:02:30 2013" ]

The log file is also useful as it will give you even more information on the error:

.. code::

    Mon Oct  3 15:26:57 2011 [InM][I]: Monitoring host ursa06 (0)
    Mon Oct  3 15:26:57 2011 [InM][I]: Command execution fail: scp -r /var/lib/one/remotes/. ursa06:/var/tmp/one
    Mon Oct  3 15:26:57 2011 [InM][I]: ssh: Could not resolve hostname ursa06: nodename nor servname provided, or not known
    Mon Oct  3 15:26:57 2011 [InM][I]: lost connection
    Mon Oct  3 15:26:57 2011 [InM][I]: ExitCode: 1
    Mon Oct  3 15:26:57 2011 [InM][E]: Error monitoring host 0 : MONITOR FAILURE 0 Could not update remotes

In this case the node ``ursa06`` could not be found in the DNS or ``/etc/hosts``.

Tuning & Extending
==================

The probes are specialized programs that obtain the monitor metrics. Probes are defined for each hypervisor, and are located at ``/var/lib/one/remotes/im/<hypervisor>-probes.d`` for Xen and KVM.

You can easily write your own probes or modify existing ones, please see the :ref:`Information Manager Drivers <devel-im>` guide. Remember to synchronize the monitor probes in the hosts using ``onehost sync`` as described in the :ref:`Managing Hosts <host_guide_sync>` guide.

