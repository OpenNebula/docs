.. _host_guide:

================================================================================
Hosts
================================================================================

In order to use your existing physical nodes, you have to add them to the system as OpenNebula Hosts. To add a host only its hostname and type is needed. Hosts are usually organized in Clusters, you can read more about it in the :ref:`Managing Clusters <cluster_guide>` guide.

.. warning:: Before adding a Linux host check that you can ssh to it without being prompt for a password.


Create and Delete Hosts
================================================================================

Hosts are the servers managed by OpenNebula responsible for Virtual Machine execution. To use these hosts in OpenNebula you need to register them so they are monitored and made available to the scheduler.

Creating a host:

.. prompt:: bash $ auto

    $ onehost create host01 --im kvm --vm kvm
    ID: 0

The parameters are:

* ``--im/-i``: Information Manager driver.
* ``--vm/-v``: Virtual Machine Manager driver.

To remove a host, just like with other OpenNebula commands, you can either specify it by ID or by name. The following commands are equivalent:

.. prompt:: bash $ auto

    $ onehost delete host01
    $ onehost delete 0

Showing and Listing Hosts
================================================================================

To display information about a single host the ``show`` command is used:

.. prompt:: bash $ auto

    HOST 0 INFORMATION
    ID                    : 0
    NAME                  : server
    CLUSTER               : server
    STATE                 : MONITORED
    IM_MAD                : kvm
    VM_MAD                : kvm
    LAST MONITORING TIME  : 05/28 00:30:51

    HOST SHARES
    TOTAL MEM             : 7.3G
    USED MEM (REAL)       : 4.4G
    USED MEM (ALLOCATED)  : 1024M
    TOTAL CPU             : 400
    USED CPU (REAL)       : 28
    USED CPU (ALLOCATED)  : 100
    TOTAL VMS           : 1

    LOCAL SYSTEM DATASTORE #0 CAPACITY
    TOTAL:                : 468.4G
    USED:                 : 150.7G
    FREE:                 : 314.7G

    MONITORING INFORMATION
    ARCH="x86_64"
    CPUSPEED="1599"
    HOSTNAME="server"
    HYPERVISOR="kvm"
    IM_MAD="kvm"
    MODELNAME="Intel(R) Core(TM) i7-4650U CPU @ 1.70GHz"
    NETRX="0"
    NETTX="0"
    RESERVED_CPU=""
    RESERVED_MEM=""
    VERSION="5.00.0"
    VM_MAD="kvm"

    WILD VIRTUAL MACHINES

    NAME                                                      IMPORT_ID  CPU     MEMORY

    VIRTUAL MACHINES

        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
        13 oneadmin oneadmin kvm1-13         runn  0.0   1024M server       8d 06h14

The information of a host contains:

* General information of the hosts including its name and the drivers used to interact with it.
* Capacity information (*Host Shares*) for CPU and memory.
* Local datastore information (*Local System Datastore*) if the Host is configured to use a local datastore (e.g. Filesystem in ssh transfer mode).
* Monitoring Information, including PCI devices
* Virtual Machines actives on the hosts. *Wild* are virtual machines actives on the host but not started by OpenNebula, they can be imported into OpenNebula.

To see a list of all the hosts:

.. prompt:: bash $ auto

    $ onehost list
	  ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
	   0 server          server      1    100 / 400 (25%) 1024M / 7.3G (13%) on
	   1 kvm1            kvm         0                  -                  - off
	   2 kvm2            kvm         0                  -                  - off

The above information can be also displayed in XML format using ``-x``.


.. _host_lifecycle:

Host Life-cycle: Enable, Disable, Offline and Flush
================================================================================

In order to manage the life cycle of a host it can be set to different operation modes: enabled (on), disabled (dsbl) and offline (off). The different operation status for each mode is described by the following table:

+----------------+------------+----------------+------------------------------------------------------------------------------------+
|                |            |  VM DEPLOYMENT |                                                                                    |
|   OP. MODE     | MONITORING +--------+-------+  MEANING                                                                           |
|                |            | MANUAL | SCHED |                                                                                    |
+================+============+========+=======+====================================================================================+
| ENABLED (on)   |    Yes     |  Yes   |  Yes  | The host is fully operational                                                      |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| UPDATE (update)|    Yes     |  Yes   |  Yes  | The host is being monitored                                                        |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| DISABLED (dsbl)|    Yes     |  Yes   |  No   | Disabled, e.g. to perform maintenance operations                                   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| OFFLINE (off)  |    No      |  No    |  No   | Host is totally offline                                                            |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| ERROR (err)    |    Yes     |  Yes   |  No   | Error while monitoring the host, use ``onehost show`` for the error description.   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| RETRY (retry)  |    Yes     |  Yes   |  No   | Monitoring a host in error state                                                   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+

The ``onehost`` tool includes three commands to set the operation mode of a host: ``disable``, ``offline`` and ``enable``, for example:

.. prompt:: bash $ auto

    $ onehost disable 0

To re-enable the host use the ``enable`` command:

.. prompt:: bash $ auto

    $ onehost enable 0

Similarly to put the host offline:

.. prompt:: bash $ auto

    $ onehost offline 0

The ``flush`` command will migrate all the active VMs in the specified host to another server with enough capacity. At the same time, the specified host will be disabled, so no more Virtual Machines are deployed in it. This command is useful to clean a host of active VMs. The migration process can be done by a resched action or by a recover delete-recreate action, it can be configured at the ``/etc/one/cli/onehost.yaml`` by setting the field ``default_actions\flush`` to ``delete-recreate`` or to ``resched``. Here is an example:

.. prompt:: bash $ auto

    :default_actions:
      - :flush: delete-recreate



Custom Host Tags & Scheduling Policies
================================================================================

The Host attributes are inserted by the monitoring probes that run from time to time on the nodes to get information. The administrator can add custom attributes either :ref:`creating a probe in the host <devel-im>`, or updating the host information with: ``onehost update``.

For example to label a host as *production* we can add a custom tag *TYPE*:

.. prompt:: bash $ auto

	$ onehost update
	...
    TYPE="production"

This tag can be used at a later time for scheduling purposes by adding the following section in a VM template:

.. code-block:: bash

    SCHED_REQUIREMENTS="TYPE=\"production\""

That will restrict the Virtual Machine to be deployed in ``TYPE=production`` hosts. The scheduling requirements can be defined using any attribute reported by ``onehost show``, see the :ref:`Scheduler Guide <schg>` for more information.

This feature is useful when we want to separate a series of hosts or marking some special features of different hosts. These values can then be used for scheduling the same as the ones added by the monitoring probes, as a :ref:`placement requirement <template_placement_section>`.

.. _host_guide_sync:

Update Host Drivers
================================================================================

When OpenNebula monitors a host, it copies driver files to ``/var/tmp/one``. When these files are updated, they need to be copied again to the hosts with the ``sync`` command. To keep track of the probes version there's a file in ``/var/lib/one/remotes/VERSION``. By default this holds the OpenNebula version (e.g. '5.0.0'). This version can be seen in he hosts with a ``onehost show <host>``:

.. prompt:: bash $ auto

    $ onehost show 0
    HOST 0 INFORMATION
    ID                    : 0
    [...]
    MONITORING INFORMATION
    VERSION="5.0.0"
    [...]

The command ``onehost sync`` only updates the hosts with ``VERSION`` lower than the one in the file ``/var/lib/one/remotes/VERSION``. In case you modify the probes this ``VERSION`` file should be modified with a greater value, for example ``5.0.0.01``.

In case you want to force upgrade, that is, no ``VERSION`` checking you can do that adding ``--force`` option:

.. prompt:: bash $ auto

    $ onehost sync --force

You can also select which hosts you want to upgrade naming them or selecting a cluster:

.. prompt:: bash $ auto

    $ onehost sync host01,host02,host03
    $ onehost sync -c myCluster

``onehost sync`` command can alternatively use ``rsync`` as the method of upgrade. To do this you need to have installed ``rsync`` command in the frontend and the nodes. This method is faster that the standard one and also has the benefit of deleting remote files no longer existing in the frontend. To use it add the parameter ``--rsync``:

.. prompt:: bash $ auto

    $ onehost sync --rsync

.. _host_guide_information:

Host Information
================================================================================

Hosts include the following monitoring information. You can use this variables to create custom ``RANK`` and ``REQUIREMENTS`` expressions for scheduling. Note also that you can manually add any tag and use it also for ``RANK`` and ``REQUIREMENTS``

+------------+----------------------------------------------------------------------------------------------------+
|    Key     |                                            Description                                             |
+============+====================================================================================================+
| HYPERVISOR | Name of the hypervisor of the host, useful for selecting the hosts with an specific technology.    |
+------------+----------------------------------------------------------------------------------------------------+
| ARCH       | Architecture of the host CPU's, e.g. x86_64.                                                       |
+------------+----------------------------------------------------------------------------------------------------+
| MODELNAME  | Model name of the host CPU, e.g. Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz.                         |
+------------+----------------------------------------------------------------------------------------------------+
| CPUSPEED   | Speed in MHz of the CPU's.                                                                         |
+------------+----------------------------------------------------------------------------------------------------+
| HOSTNAME   | As returned by the ``hostname`` command.                                                           |
+------------+----------------------------------------------------------------------------------------------------+
| VERSION    | This is the version of the monitoring probes. Used to control local changes and the update process |
+------------+----------------------------------------------------------------------------------------------------+
| MAX_CPU    | Number of CPU's multiplied by 100. For example, a 16 cores machine will have a value of 1600.      |
|            | The value of RESERVED_CPU will be subtracted from the information reported by the                  |
|            | monitoring system.  This value is displayed as ``TOTAL CPU`` by the                                |
|            | ``onehost show`` command under ``HOST SHARE`` section.                                             |
+------------+----------------------------------------------------------------------------------------------------+
| MAX_MEM    | Maximum memory that could be used for VMs. It is advised to take out the memory                    |
|            | used by the hypervisor using RESERVED_MEM. This values is subtracted from the memory               |
|            | amount reported. This value is displayed as ``TOTAL MEM`` by the ``onehost show``                  |
|            | command under ``HOST SHARE`` section.                                                              |
+------------+----------------------------------------------------------------------------------------------------+
| MAX_DISK   | Total space in megabytes in the DATASTORE LOCATION.                                                |
+------------+----------------------------------------------------------------------------------------------------+
| USED_CPU   | Percentage of used CPU multiplied by the number of cores. This value is displayed                  |
|            | as ``USED CPU (REAL)`` by the ``onehost show`` command under ``HOST SHARE`` section.               |
+------------+----------------------------------------------------------------------------------------------------+
| USED_MEM   | Memory used, in kilobytes. This value is displayed as ``USED MEM (REAL)``                          |
|            | by the ``onehost show`` command under ``HOST SHARE`` section.                                      |
+------------+----------------------------------------------------------------------------------------------------+
| USED_DISK  | Used space in megabytes in the DATASTORE LOCATION.                                                 |
+------------+----------------------------------------------------------------------------------------------------+
| FREE_CPU   | Percentage of idling CPU multiplied by the number of cores. For example,                           |
|            | if 50% of the CPU is idling in a 4 core machine the value will be 200.                             |
+------------+----------------------------------------------------------------------------------------------------+
| FREE_MEM   | Available memory for VMs at that moment, in kilobytes.                                             |
+------------+----------------------------------------------------------------------------------------------------+
| FREE_DISK  | Free space in megabytes in the DATASTORE LOCATION                                                  |
+------------+----------------------------------------------------------------------------------------------------+
| CPU_USAGE  | Total CPU allocated to VMs running on the host as requested in ``CPU``                             |
|            | in each VM template. This value is displayed as ``USED CPU (ALLOCATED)``                           |
|            | by the ``onehost show`` command under ``HOST SHARE`` section.                                      |
+------------+----------------------------------------------------------------------------------------------------+
| MEM_USAGE  | Total MEM allocated to VMs running on the host as requested in ``MEMORY``                          |
|            | in each VM template. This value is displayed as ``USED MEM (ALLOCATED)``                           |
|            | by the ``onehost show`` command under ``HOST SHARE`` section.                                      |
+------------+----------------------------------------------------------------------------------------------------+
| DISK_USAGE | Total size allocated to disk images of VMs running on the host computed                            |
|            | using the ``SIZE`` attribute of each image and considering the datastore characteristics.          |
+------------+----------------------------------------------------------------------------------------------------+
| NETRX      | Received bytes from the network                                                                    |
+------------+----------------------------------------------------------------------------------------------------+
| NETTX      | Transferred bytes to the network                                                                   |
+------------+----------------------------------------------------------------------------------------------------+
| WILD       | Comma separated list of VMs running in the host that were not launched                             |
|            | and are not currently controlled by OpenNebula                                                     |
+------------+----------------------------------------------------------------------------------------------------+
| ZOMBIES    | Comma separated list of VMs running in the host that were launched by                              |
|            | OpenNebula but are not currently controlled by it.                                                 |
+------------+----------------------------------------------------------------------------------------------------+

.. _import_wild_vms:

Importing Wild VMs
================================================================================

The monitoring mechanism in OpenNebula reports all VMs found in a hypervisor, even those not launched through OpenNebula. These VMs are referred to as Wild VMs, and can be imported to be managed through OpenNebula. This includes all supported hypervisors, even the hybrid ones.

The Wild VMs can be spotted through the ``onehost show`` command:

.. prompt:: bash $ auto

      $ onehost show 3
      HOST 3 INFORMATION
      ID                    : 3
      NAME                  : MyvCenterHost
      CLUSTER               : -
      STATE                 : MONITORED
      [...]
      WILD VIRTUAL MACHINES
                          NAME                            IMPORT_ID  CPU     MEMORY
                 Ubuntu14.04VM 4223f951-243a-b31a-018f-390a02ff5c96    1       2048
                       CentOS7 422375e7-7fc7-4ed1-e0f0-fb778fe6e6e0    1       2048

And imported through the ``onehost importvm`` command:

.. prompt:: bash $ auto

      $ onehost importvm 0 CentOS7
      $ onevm list
      ID USER     GROUP    NAME            STAT UCPU    UMEM HOST               TIME
       3 oneadmin oneadmin CentOS7         runn    0    590M MyvCenterHost  0d 01h02

After a Virtual Machine is imported, their life-cycle (including creation of snapshots) can be controlled through OpenNebula. However, some  operations *cannot* be performed on an imported VM, including: poweroff, undeploy, migrate or delete-recreate.

The same import mechanism is available graphically through Sunstone. Running and Powered Off VMs can be imported through the WILDS tab in the Host info tab.

Using Sunstone to Manage Hosts
================================================================================

You can also manage your hosts using :ref:`Sunstone <sunstone>`. Select the Host tab, and there, you will be able to create, enable, disable, delete and see information about your hosts in a user friendly way.

|image1|

.. |image1| image:: /images/hosts_sunstone.png
