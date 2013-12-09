===================
Monitoring Overview
===================

This guide provides an overview of the OpenNebula monitoring subsystem.
The monitoring subsystem gathers information relative to the hosts and
the virtual machines, such as the host status, basic performance
indicators, as well as VM status and capacity consumption. This
information is collected by executing a set of static probes provided by
OpenNebula. The output of these probes is sent to OpenNebula in two
different ways: using a push or a pull paradigm. Below you can find a
brief description of the two models and when to use one or the other.

The UDP-push Model
==================

|:!:| **Default**. This is the default IM for KVM and Xen in OpenNebula
>= 4.4.

In this model, each host periodically sends monitoring data via UDP to
the frontend which collects it and processes it in a dedicated module.
This distributed monitoring system resembles the architecture of
dedicated monitoring systems, using a lightweight communication
protocol, and a push model.

This model is highly scalable and its limit (in terms of number of VMs
monitored per second) is bounded to the performance of the server
running oned and the database server.

Please read the `UDP-push guide </./imudppushg>`__ for more information.

When to Use the UDP-push Model
------------------------------

This mode can be used only with Xen and KVM (VMware only supports the
SSH-pull mode).

This monitoring model is adequate when:

-  You are using KVM or Xen (VMware is not supported in this mode)
-  Your infrastructure has a medium-to-high number of hosts (e.g. more
than 50)
-  You need a high responsive system
-  You need a high frequently updated monitor information
-  All your hosts communicate through a secure network (UDP packages are
not encrypted and their origin is not verified)

The Pull Model
==============

When using this mode OpenNebula periodically actively queries each host
and executes the probes via ``ssh``. In KVM and Xen this means
establishing an ssh connection to each host and executing several
scripts to retrieve this information. Note that VMware uses the VI API
for this, instead of a ``ssh`` connection.

This mode is limited by the number of active connections that can be
made concurrently, as hosts are queried sequentially.

Please read the `KVM and Xen SSH-pull guide </./imsshpullg>`__ or the
`ESX-pull guide </./imesxpullg>`__ for more information.

When to Use the SSH-pull Model
------------------------------

This mode can be used with VMware, Xen and KVM.

This monitoring model is adequate when:

-  Your infrastructure has a low number of hosts (e.g. 50 or less)
-  You are communicating with the hosts through an insecure network
-  You do not need to update the monitoring with a high frequency (e.g.
for 50 hosts the monitoring period would be typically of about 5
minutes)

Other Monitorization Systems
============================

OpenNebula can be easily integrated with other monitorization system.
Please read the `Information Manager Driver integration
guide </./devel-im>`__ for more information.

The Monitor Metrics
===================

The information manage by the monitoring system includes the typical
performance and configuration parameters for the host and VMs, e.g. CPU
or network consumption, Hostname or CPU model.

These metrics are gathered by specialized programs, called probes, that
can be easily added to the system. Just write your own program, or shell
script that returns the metric that you are interested in. Please read
the `Information Manager Driver integration guide </./devel-im>`__ for
more information.

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
