.. _imesxpullg:

===========================
VMware VI API-pull Monitor
===========================

Requirements
============

-  VI API access to the ESX hosts.
-  ESX hosts configured to work with OpenNebula

OpenNebula Configuration
========================

In order to configure VMware you need to:

-  Enable the VMware monitoring driver in ``/etc/one/oned.conf`` by uncommenting the following lines:

.. code::

    IM_MAD = [
          name       = "vmware",
          executable = "one_im_sh",
          arguments  = "-c -t 15 -r 0 vmware" ]

-  Make sure that the configuration attributes for VMware drivers are set in ``/etc/one/vmwarerc``, see the :ref:`VMware guide <evmwareg>`

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

.. warning:: VM\_PER\_INTERVAL is only relevant in case of host failure when OpenNebula pro-actively monitors each VM. You need to set VM_INDIVIDUAL_MONITORING to "yes" in oned.conf.

The information gathered by the probes is also stored in a monitoring table. This table is used by Sunstone to draw monitoring graphics and can be queried using the OpenNebula API. The size of this table can be controlled with:

+--------------------------------------+---------------------------------------------------------------------------------------------------+
| Parameter                            | Description                                                                                       |
+======================================+===================================================================================================+
| HOST\_MONITORING\_EXPIRATION\_TIME   | Time, in seconds, to expire monitoring information. Use 0 to disable HOST monitoring recording.   |
+--------------------------------------+---------------------------------------------------------------------------------------------------+
| VM\_MONITORING\_EXPIRATION\_TIME     | Time, in seconds, to expire monitoring information. Use 0 to disable VM monitoring recording.     |
+--------------------------------------+---------------------------------------------------------------------------------------------------+

Troubleshooting
===============

In order to test the driver, add a host to OpenNebula using **onehost**, specifying the defined IM driver:

.. code::

    $ onehost create esx_node1 --im vmware --vm vmware --net dummy

Now give it time to monitor the host (this time is determined by the value of MONITORING\_INTERVAL in ``/etc/one/oned.conf``). After one interval, check the output of **onehost list**, it should look like the following:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 esx_node1       -           0       0 / 400 (0%)     0K / 7.7G (0%) on

Host management information is logged to ``/var/log/one/oned.log``. Correct monitoring log lines look like this:

.. code::

    Fri Nov 22 12:02:26 2013 [InM][D]: Monitoring host esx_node1 (0)
    Fri Nov 22 12:02:30 2013 [InM][D]: Host esx1_node (0) successfully monitored.

Both lines have the ID of the host being monitored.

If there are problems monitoring the host you will get an ``err`` state:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 esx_node1        -           0       0 / 400 (0%)     0K / 7.7G (0%) err

The way to get the error message for the host is using ``onehost show`` command, specifying the host id or name:

.. code::

    $ onehost show 0
    [...]
    MONITORING INFORMATION
    ERROR=[
      MESSAGE="Error monitoring host 0 : MONITOR FAILURE 0 Could not update remotes",
      TIMESTAMP="Nov 22 12:02:30 2013" ]

The log file is also useful as it will give you even more information on the error.

Tuning & Extending
==================

The probes are specialized programs that obtain the monitor metrics. VMware probes are obtained by querying the ESX server through the VI API. The probe is located at ``/var/lib/one/remotes/im/vmware.d``.

You can easily write your own probes or modify existing ones, please see the :ref:`Information Manager Drivers <devel-im>` guide.

