.. _hosts:
.. _hosts_guide:

================================================================================
Hosts
================================================================================

In order to use your existing physical nodes, you have to add them to OpenNebula as Hosts. To add a Host only its hostname and type is needed.

.. warning:: Before adding a Linux Host check that you can SSH to it without being prompted for a password.


Creating and Deleting Hosts
================================================================================

Hosts are the servers managed by OpenNebula responsible for running VMs. To use these Hosts in OpenNebula you need to register them so they are monitored and made available to the scheduler.

Creating a Host:

.. prompt:: bash $ auto

    $ onehost create host01 --im kvm --vm kvm
    ID: 0

The parameters are:

* ``--im``: Information Manager driver.
* ``--vm``: Virtual Machine Manager driver.

.. note:: In the examples included in this guide we'll use `KVM` as the hypervisor. Note that the procedure will be the same for any other hypervisor; only the name will need to be changed.

To remove a Host you can either specify it by ID or by name. The following commands are equivalent:

.. prompt:: bash $ auto

    $ onehost delete host01
    $ onehost delete 0

Showing and Listing Hosts
================================================================================

To display information about a single Host, use the ``show`` command:

.. prompt:: bash $ auto

    $ onehost show server

    HOST 0 INFORMATION
    ID                    : 0
    NAME                  : server
    CLUSTER               : default
    STATE                 : MONITORED
    IM_MAD                : kvm
    VM_MAD                : kvm
    LAST MONITORING TIME  : -

    HOST SHARES
    RUNNING VMS           : 0
    MEMORY
      TOTAL               : 31.1G
      TOTAL +/- RESERVED  : 31.1G
      USED (REAL)         : 0K
      USED (ALLOCATED)    : 0K
    CPU
      TOTAL               : 800
      TOTAL +/- RESERVED  : 800
      USED (REAL)         :
      USED (ALLOCATED)    : 0

    LOCAL SYSTEM DATASTORE #0 CAPACITY
    TOTAL:                : 467.7G
    USED:                 : 113.5G
    FREE:                 : 354.2G

    MONITORING INFORMATION
    ARCH="x86_64"
    CPUSPEED="3350"
    HOSTNAME="pc-ruben"
    HYPERVISOR="kvm"
    IM_MAD="kvm"
    KVM_CPU_MODEL="Skylake-Client-noTSX-IBRS"
    KVM_CPU_MODELS="486 pentium pentium2 pentium3 pentiumpro coreduo n270 core2duo qemu32 kvm32 cpu64-rhel5 cpu64-rhel6 qemu64 kvm64 Conroe Penryn Nehalem Nehalem-IBRS Westmere Westmere-IBRS SandyBridge SandyBridge-IBRS IvyBridge IvyBridge-IBRS Haswell-noTSX Haswell-noTSX-IBRS Haswell Haswell-IBRS Broadwell-noTSX Broadwell-noTSX-IBRS Broadwell Broadwell-IBRS Skylake-Client Skylake-Client-IBRS Skylake-Client-noTSX-IBRS Skylake-Server Skylake-Server-IBRS Skylake-Server-noTSX-IBRS Cascadelake-Server Cascadelake-Server-noTSX Icelake-Client Icelake-Client-noTSX Icelake-Server Icelake-Server-noTSX Cooperlake Snowridge athlon phenom Opteron_G1 Opteron_G2 Opteron_G3 Opteron_G4 Opteron_G5 EPYC EPYC-IBPB EPYC-Rome Dhyana"
    KVM_MACHINES="pc-i440fx-5.2 pc pc-q35-5.2 q35 pc-i440fx-2.12 pc-i440fx-2.0 pc-q35-4.2 pc-i440fx-2.5 pc-i440fx-4.2 pc-i440fx-1.5 pc-q35-2.7 pc-i440fx-2.2 pc-1.1 pc-i440fx-2.7 pc-q35-2.4 pc-q35-2.10 pc-i440fx-1.7 pc-q35-5.1 pc-q35-2.9 pc-i440fx-2.11 pc-q35-3.1 pc-q35-4.1 pc-i440fx-2.4 pc-1.3 pc-i440fx-4.1 pc-i440fx-5.1 pc-i440fx-2.9 isapc pc-i440fx-1.4 pc-q35-2.6 pc-i440fx-3.1 pc-q35-2.12 pc-i440fx-2.1 pc-1.0 pc-i440fx-2.6 pc-q35-4.0.1 pc-i440fx-1.6 pc-q35-5.0 pc-q35-2.8 pc-i440fx-2.10 pc-q35-3.0 pc-q35-4.0 microvm pc-i440fx-2.3 pc-1.2 pc-i440fx-4.0 pc-i440fx-5.0 pc-i440fx-2.8 pc-q35-2.5 pc-i440fx-3.0 pc-q35-2.11"
    MODELNAME="Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz"
    RESERVED_CPU=""
    RESERVED_MEM=""
    VERSION="6.1.80"
    VM_MAD="kvm"

    NUMA NODES

      ID CORES        USED FREE
       0 -- -- -- --  0    8

    NUMA MEMORY

     NODE_ID TOTAL    USED_REAL            USED_ALLOCATED       FREE
           0 31.1G    0K                   0K                   0K

    NUMA HUGEPAGES

     NODE_ID SIZE     TOTAL    FREE     USED
           0 2M       0        0        0
           0 1024M    0        0        0

    WILD VIRTUAL MACHINES

    NAME                                                      IMPORT_ID  CPU     MEMORY

    VIRTUAL MACHINES

    ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
    13 oneadmin oneadmin kvm1-13         runn  0.0   1024M server       8d 06h14

The information of a Host contains:

* **General information** of the Host including its name and the drivers used to interact with it.
* **Capacity** (*Host Shares*) for CPU and memory.
* **Local datastore information** (*Local System Datastore*) if the Host is configured to use a local datastore (e.g. in SSH transfer mode).
* **Monitoring Information**, including PCI devices and NUMA information of the node. You can also find hypervisor specific information here.
* **Virtual Machines** allocated to the Host. *Wild* are virtual machines running on the Host but not started by OpenNebula, and can be imported.

To see a list of all the Hosts:

.. prompt:: bash $ auto

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 server          server      1    100 / 400 (25%) 1024M / 7.3G (13%) on
       1 kvm1            kvm         0                  -                  - off
       2 kvm2            kvm         0                  -                  - off

The above information can be also displayed in XML, JSON or CSV format using ``-x`` or ``-j`` or ``-c``, respectively.

.. _host_lifecycle:

Host States
================================================================================

In order to manage the life cycle of a Host it can be set to different operation modes: enabled (``on``), disabled (``dsbl``) and offline (``off``). The different operation status for each mode is described in the following table:

+----------------+------------+----------------+------------------------------------------------------------------------------------+
|                |            |  VM DEPLOYMENT |                                                                                    |
|   OP. MODE     | MONITORING +--------+-------+  MEANING                                                                           |
|                |            | MANUAL | SCHED |                                                                                    |
+================+============+========+=======+====================================================================================+
| ENABLED (on)   |    Yes     |  Yes   |  Yes  | The Host is fully operational                                                      |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| UPDATE (update)|    Yes     |  Yes   |  Yes  | The Host is being monitored                                                        |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| DISABLED (dsbl)|    Yes     |  Yes   |  No   | Disabled, e.g. to perform maintenance operations                                   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| OFFLINE (off)  |    No      |  No    |  No   | The Host is totally offline                                                        |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| ERROR (err)    |    Yes     |  Yes   |  No   | Error while monitoring the Host, use ``onehost show`` for the error description.   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+
| RETRY (retry)  |    Yes     |  Yes   |  No   | Monitoring a Host in error state                                                   |
+----------------+------------+--------+-------+------------------------------------------------------------------------------------+

Host Operations
================================================================================

The ``onehost`` tool provides commands to set the operation mode of a Host: ``disable``, ``offline`` and ``enable``, for example:

.. prompt:: bash $ auto

    $ onehost disable 0

To re-enable the Host, use the ``enable`` command:

.. prompt:: bash $ auto

    $ onehost enable 0

Similarly, to take the Host offline:

.. prompt:: bash $ auto

    $ onehost offline 0

Apart from the commands above, the ``onehost`` tool also provides some commands that allow you to easily perform common operations on a Host.

You can use ``forceupdate`` subcommand to reset the monitoring process on the Host:

.. prompt:: bash $ auto

    $ onehost forceupdate 0

Also, the ``flush`` command will migrate all the active VMs in the specified Host to another server with enough capacity. At the same time, the specified Host will be disabled, so no more Virtual Machines are deployed in it. This command is useful to clean a Host of active VMs. The migration process can be done by a ``resched`` action or by a recover ``delete-recreate`` action; it can be configured in ``/etc/one/cli/onehost.yaml`` by setting the field ``default_actions\flush`` to ``delete-recreate`` or to ``resched``. Here is an example:

.. prompt:: bash $ auto

    :default_actions:
      - :flush: delete-recreate

.. _host_guide_information:

Host Monitoring
================================================================================

The monitoring probes gather information attributes and insert them in the Host template. This information is mainly used for:

  * Monitoring the status of the Host to detect any error condition.
  * Gathering the configuration of the Host (e.g. capacity, PCI devices or NUMA nodes). This information is used to control VM resource assignments.
  * Creating placement constraints for allocation of VMs, :ref:`see more details here <scheduling>`.

In general, you can find the following monitoring information in a Host. Note that each hypervisor may include additional attributes:

+------------+----------------------------------------------------------------------------------------------------+
|    Key     |                                            Description                                             |
+============+====================================================================================================+
| HYPERVISOR | Name of the hypervisor of the Host, useful for selecting the Hosts with a specific technology.     |
+------------+----------------------------------------------------------------------------------------------------+
| ARCH       | Architecture of the Host CPUs, e.g. x86_64.                                                        |
+------------+----------------------------------------------------------------------------------------------------+
| MODELNAME  | Model name of the Host CPU, e.g. Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz.                         |
+------------+----------------------------------------------------------------------------------------------------+
| CPUSPEED   | Speed in MHz of the CPUs.                                                                          |
+------------+----------------------------------------------------------------------------------------------------+
| HOSTNAME   | As returned by the ``hostname`` command.                                                           |
+------------+----------------------------------------------------------------------------------------------------+
| VERSION    | This is the version of the monitoring probes. Used to control local changes and the update process |
+------------+----------------------------------------------------------------------------------------------------+
| MAX_CPU    | Number of CPUs multiplied by 100. For example, a 16 cores machine will have a value of 1600.       |
|            | The value of RESERVED_CPU will be subtracted from the information reported by the                  |
|            | monitoring system.  This value is displayed as ``TOTAL CPU`` by the                                |
|            | ``onehost show`` command under ``HOST SHARE`` section.                                             |
+------------+----------------------------------------------------------------------------------------------------+
| MAX_MEM    | Maximum memory that can be used for VMs. It is advised to discount the memory                      |
|            | used by the hypervisor using RESERVED_MEM. This value is subtracted from the memory                |
|            | amount reported. The value is displayed as ``TOTAL MEM`` by the ``onehost show``                   |
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
| CPU_USAGE  | Total CPU allocated to VMs running on the Host as requested in ``CPU``                             |
|            | in each VM template. This value is displayed as ``USED CPU (ALLOCATED)``                           |
|            | by the ``onehost show`` command under ``HOST SHARE`` section.                                      |
+------------+----------------------------------------------------------------------------------------------------+
| MEM_USAGE  | Total MEM allocated to VMs running on the Host as requested in ``MEMORY``                          |
|            | in each VM template. This value is displayed as ``USED MEM (ALLOCATED)``                           |
|            | by the ``onehost show`` command under ``HOST SHARE`` section.                                      |
+------------+----------------------------------------------------------------------------------------------------+
| DISK_USAGE | Total size allocated to disk images of VMs running on the Host; computed                           |
|            | using the ``SIZE`` attribute of each image and considering the datastore characteristics.          |
+------------+----------------------------------------------------------------------------------------------------+
| NETRX      | Received bytes from the network                                                                    |
+------------+----------------------------------------------------------------------------------------------------+
| NETTX      | Transferred bytes to the network                                                                   |
+------------+----------------------------------------------------------------------------------------------------+
| WILD       | Comma-separated list of VMs running in the Host that were not launched                             |
|            | and are not currently controlled by OpenNebula                                                     |
+------------+----------------------------------------------------------------------------------------------------+
| ZOMBIES    | Comma-separated list of VMs running in the Host that were launched by                              |
|            | OpenNebula but are not currently controlled by it.                                                 |
+------------+----------------------------------------------------------------------------------------------------+

Custom Host Attributes
--------------------------------------------------------------------------------

You can add custom attributes either by :ref:`creating a probe in the host <devel-im>` or by updating the Host information with: ``onehost update``.

For example, to label a Host as *production* we can add a custom tag *TYPE*:

.. prompt:: bash $ auto

    $ onehost update
    ...
    TYPE="production"

This tag can be used at a later time for scheduling purposes, :ref:`see more details here <scheduling>`.

.. _host_guide_sync:

Updating Host Files
--------------------------------------------------------------------------------

When OpenNebula monitors a Host, it copies driver files to ``/var/tmp/one``. When these files are updated, they need to be copied again to the Hosts with the ``sync`` command. To keep track of the probes version there's a file in ``/var/lib/one/remotes/VERSION``. By default this holds the OpenNebula version (e.g. '6.1.80'). This version can be seen in the Hosts by using ``onehost show <host>``:

.. prompt:: bash $ auto

    $ onehost show 0
    HOST 0 INFORMATION
    ID                    : 0
    [...]
    MONITORING INFORMATION
    VERSION="6.1.80"
    [...]

The command ``onehost sync`` only updates the Hosts with ``VERSION`` lower than the one in the file ``/var/lib/one/remotes/VERSION``. In case you modify the probes this ``VERSION`` file should be modified with a greater value, for example ``6.1.80.01``.

In case you want to force an upgrade, that is, without any ``VERSION`` checking, you can do it by using the ``--force`` option:

.. prompt:: bash $ auto

    $ onehost sync --force

You can also select which Hosts you want to upgrade by naming them or selecting a cluster:

.. prompt:: bash $ auto

    $ onehost sync host01,host02,host03
    $ onehost sync -c myCluster

.. _import_wild_vms:

Importing Wild VMs
================================================================================

The monitoring mechanism in OpenNebula reports all VMs found in a hypervisor, even those not launched through OpenNebula. These VMs are referred to as Wild VMs and can be imported to be managed through OpenNebula. The Wild VMs can be spotted through the ``onehost show`` command:

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

And imported using the ``onehost importvm`` command:

.. prompt:: bash $ auto

      $ onehost importvm 0 CentOS7
      $ onevm list
      ID USER     GROUP    NAME            STAT UCPU    UMEM HOST               TIME
       3 oneadmin oneadmin CentOS7         runn    0    590M MyvCenterHost  0d 01h02

After a Virtual Machine is imported, its life-cycle (including creation of snapshots) can be controlled through OpenNebula. However, some  operations *cannot* be performed on an imported VM, including: poweroff, undeploy, migrate or delete-recreate.

.. warning:: Wild VMs' support and limitations may be different depending on the virtualization driver used (e.g KVM, LXC, ...). In order to find more specific information for the virtualization driver you're using, please check the corresponding driver guide.

Using Sunstone to Manage Hosts
================================================================================

You can also manage your Hosts using :ref:`Sunstone <sunstone>`. Select the Host tab, and there, you will be able to create, enable, disable, delete, and see information about your Hosts in a user-friendly way.

|image1|

.. |image1| image:: /images/hosts_sunstone.png
