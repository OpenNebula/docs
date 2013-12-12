.. _host_guide:

===============
Managing Hosts
===============

In order to use your existing physical nodes, you have to add them to the system as OpenNebula hosts. You need the following information:

-  *Hostname* of the host or IP
-  *Information Driver* to be used to monitor the host, e.g. ``kvm``. These should match the Virtualization Drivers installed and more info about them can be found at the :ref:`Virtualization Subsystem guide <vmmg>`.
-  *Virtualization Driver* to boot, stop, resume or migrate VMs in the host, e.g. ``kvm``. Information about these drivers can be found in :ref:`its guide <vmmg>`.
-  *Networking Driver* to isolate virtual networks and apply firewalling rules, e.g. ``802.1Q``. Information about these drivers can be found in :ref:`its guide <nm>`.
-  *Cluster* where to place this host. The Cluster assignment is optional, you can read more about it in the :ref:`Managing Clusters <cluster_guide>` guide.

.. warning:: Before adding a host check that you can ssh to it without being prompt for a password

onehost Command
===============

The following sections show the basics of the ``onehost`` command with simple usage examples. A complete reference for these commands can be found :ref:`here <cli>`.

This command enables Host management. Actions offered are:

-  ``create``: Creates a new Host
-  ``delete``: Deletes the given Host
-  ``enable``: Enables the given Host
-  ``disable``: Disables the given Host
-  ``update``: Update the template contents.
-  ``sync``: Synchronizes probes in all the hosts.
-  ``list``: Lists Hosts in the pool
-  ``show``: Shows information for the given Host
-  ``top``: Lists Hosts continuously
-  ``flush``: Disables the host and reschedules all the running VMs it.

Create and Delete
-----------------

Hosts, also known as physical nodes, are the serves managed by OpenNebula responsible for Virtual Machine execution. To use these hosts in OpenNebula you need to register them so they are monitored and well-known to the scheduler.

Creating a host:

.. code::

    $ onehost create host01 --im dummy --vm dummy --net dummy
    ID: 0

The parameters are:

-  ``--im/-i``: Information Manager driver. Valid options: ``kvm``, ``xen``, ``vmware``, ``ec2``, ``ganglia``, ``dummy``.
-  ``--vm/-v``: Virtual Machine Manager driver. Valid options: ``kvm``, ``xen``, ``vmware``, ``ec2``, ``dummy``.
-  ``--net/-n``: Network manager driver. Valid options: ``802.1Q``,\ ``dummy``,\ ``ebtables``,\ ``fw``,\ ``ovswitch``,\ ``vmware``.

To remove a host, just like with other OpenNebula commands, you can either specify it by ID or by name. The following commands are equivalent:

.. code::

    $ onehost delete host01
    $ onehost delete 0

Show, List and Top
------------------

To display information about a single host the ``show`` command is used:

.. code::

    $ onehost show 0
    HOST 0 INFORMATION
    ID                    : 0
    NAME                  : host01
    CLUSTER               : -
    STATE                 : MONITORED
    IM_MAD                : dummy
    VM_MAD                : dummy
    VN_MAD                : dummy
    LAST MONITORING TIME  : 07/06 17:40:41

    HOST SHARES
    TOTAL MEM             : 16G
    USED MEM (REAL)       : 857.9M
    USED MEM (ALLOCATED)  : 0K
    TOTAL CPU             : 800
    USED CPU (REAL)       : 299
    USED CPU (ALLOCATED)  : 0
    RUNNING VMS           : 0

    MONITORING INFORMATION
    CPUSPEED="2.2GHz"
    FREECPU="501"
    FREEMEMORY="15898723"
    HOSTNAME="host01"
    HYPERVISOR="dummy"
    TOTALCPU="800"
    TOTALMEMORY="16777216"
    USEDCPU="299"
    USEDMEMORY="878493"

We can instead display this information in XML format with the ``-x`` parameter:

.. code::

    $ onehost show -x 0
    <HOST>
      <ID>0</ID>
      <NAME>host01</NAME>
      <STATE>2</STATE>
      <IM_MAD>dummy</IM_MAD>
      <VM_MAD>dummy</VM_MAD>
      <VN_MAD>dummy</VN_MAD>
      <LAST_MON_TIME>1341589306</LAST_MON_TIME>
      <CLUSTER_ID>-1</CLUSTER_ID>
      <CLUSTER/>
      <HOST_SHARE>
        <DISK_USAGE>0</DISK_USAGE>
        <MEM_USAGE>0</MEM_USAGE>
        <CPU_USAGE>0</CPU_USAGE>
        <MAX_DISK>0</MAX_DISK>
        <MAX_MEM>16777216</MAX_MEM>
        <MAX_CPU>800</MAX_CPU>
        <FREE_DISK>0</FREE_DISK>
        <FREE_MEM>12852921</FREE_MEM>
        <FREE_CPU>735</FREE_CPU>
        <USED_DISK>0</USED_DISK>
        <USED_MEM>3924295</USED_MEM>
        <USED_CPU>65</USED_CPU>
        <RUNNING_VMS>0</RUNNING_VMS>
      </HOST_SHARE>
      <TEMPLATE>
        <CPUSPEED><![CDATA[2.2GHz]]></CPUSPEED>
        <FREECPU><![CDATA[735]]></FREECPU>
        <FREEMEMORY><![CDATA[12852921]]></FREEMEMORY>
        <HOSTNAME><![CDATA[host01]]></HOSTNAME>
        <HYPERVISOR><![CDATA[dummy]]></HYPERVISOR>
        <TOTALCPU><![CDATA[800]]></TOTALCPU>
        <TOTALMEMORY><![CDATA[16777216]]></TOTALMEMORY>
        <USEDCPU><![CDATA[65]]></USEDCPU>
        <USEDMEMORY><![CDATA[3924295]]></USEDMEMORY>
      </TEMPLATE>
    </HOST>

To see a list of all the hosts:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM TCPU FCPU ACPU    TMEM    FMEM    AMEM STAT
       0 host01          -           0  800  198  800     16G   10.9G     16G on
       1 host02          -           0  800  677  800     16G    3.7G     16G on

It can also be displayed in XML format using ``-x``:

.. code::

    $ onehost list -x
    <HOST_POOL>
      <HOST>
        ...
      </HOST>
      ...
    </HOST_POOL>

The ``top`` command is similar to the ``list`` command, except that the output is refreshed until the user presses ``CTRL-C``.

Enable, Disable and Flush
-------------------------

The ``disable`` command disables a host, which means that no further monitorization is performed on this host and no Virtual Machines are deployed in it. It won't however affect the running VMs in the host.

.. code::

    $ onehost disable 0

To re-enable the host use the ``enable`` command:

.. code::

    $ onehost enable 0

The ``flush`` command will mark all the running VMs in the specified host as to be rescheduled, which means that they will be migrated to another server with enough capacity. At the same time, the specified host will be disabled, so no more Virtual Machines are deployed in it. This command is useful to clean a host of running VMs.

.. code::

    $ onehost list         
      ID NAME            CLUSTER   RVM TCPU FCPU ACPU    TMEM    FMEM    AMEM STAT  
       0 host01          -           3  800   96  500     16G   11.1G   14.5G on    
       1 host02          -           0  800  640  800     16G    8.5G     16G on    
       2 host03          -           3  800  721  500     16G    8.6G   14.5G on    
    $ onevm list                       
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 oneadmin oneadmin vm01            runn   54  102.4M host03       0d 00h01
         1 oneadmin oneadmin vm02            runn   91  276.5M host02       0d 00h01
         2 oneadmin oneadmin vm03            runn   13  174.1M host01       0d 00h01
         3 oneadmin oneadmin vm04            runn   72  204.8M host03       0d 00h00
         4 oneadmin oneadmin vm05            runn   49  112.6M host02       0d 00h00
         5 oneadmin oneadmin vm06            runn   87  414.7M host01       0d 00h00
    $ onehost flush host02
    $ onehost list
      ID NAME            CLUSTER   RVM TCPU FCPU ACPU    TMEM    FMEM    AMEM STAT  
       0 host01          -           3  800  264  500     16G    3.5G   14.5G on    
       1 host02          -           0  800  153  800     16G    3.7G     16G off   
       2 host03          -           3  800  645  500     16G   10.3G   14.5G on    
    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 oneadmin oneadmin vm01            runn   95  179.2M host03       0d 00h01
         1 oneadmin oneadmin vm02            runn   27  261.1M host03       0d 00h01
         2 oneadmin oneadmin vm03            runn   70    343M host01       0d 00h01
         3 oneadmin oneadmin vm04            runn    9  133.1M host03       0d 00h01
         4 oneadmin oneadmin vm05            runn   87  281.6M host01       0d 00h01
         5 oneadmin oneadmin vm06            runn   61  291.8M host01       0d 00h01

Update
------

It's sometimes useful to store information in the host's template. To do so, the ``update`` command is used.

An example use case is to add the following line to the host's template:

.. code::

    TYPE="production"

Which can be used at a later time for scheduling purposes by adding the following section in a VM template:

.. code::

    SCHED_REQUIREMENTS="TYPE=\"production\""

That will restrict the Virtual Machine to be deployed in ``TYPE=production`` hosts.

Sync
----

When OpenNebula monitors a host, it copies a certain amount of files to ``/var/tmp/one``. When the administrator changes these files, they can be copied again to the hosts with the ``sync`` command. When executed this command will copy the probes to the nodes and will return the prompt after it has finished telling which nodes it could not update.

To keep track of the probes version there's a new file in ``/var/lib/one/remotes/VERSION``. By default this holds the OpenNebula version (ex. '4.4.0'). This version can be seen in he hosts with a ``onehost show <host>``:

.. code::

    $ onehost show 0
    HOST 0 INFORMATION
    ID                    : 0
    [...]
    MONITORING INFORMATION
    VERSION="4.4.0"
    [...]

The command ``onehost sync`` only updates the hosts with ``VERSION`` lower than the one in the file ``/var/lib/one/remotes/VERSION``. In case you modify the probes this ``VERSION`` file should be modified with a greater value, for example ``4.4.0.01``.

In case you want to force upgrade, that is, no ``VERSION`` checking you can do that adding ``–force`` option:

.. code::

    $ onehost sync --force

You can also select which hosts you want to upgrade naming them or selecting a cluster:

.. code::

    $ onehost sync host01,host02,host03
    $ onehost sync -c myCluster

``onehost sync`` command can alternatively use ``rsync`` as the method of upgrade. To do this you need to have installed ``rsync`` command in the frontend and the nodes. This method is faster that the standard one and also has the benefit of deleting remote files no longer existing in the frontend. To use it add the parameter ``–rsync``:

.. code::

    $ onehost sync --rsync

Host Life-cycle
===============

+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| Short state   | State                      | Meaning                                                                                                             |
+===============+============================+=====================================================================================================================+
| ``init``      | ``INIT``                   | Initial state for enabled hosts.                                                                                    |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| ``update``    | ``MONITORING_MONITORED``   | Monitoring a healthy Host.                                                                                          |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| ``on``        | ``MONITORED``              | The host has been successfully monitored.                                                                           |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| ``err``       | ``ERROR``                  | An error occurred while monitoring the host. See the Host information with ``onehost show`` for an error message.   |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| ``off``       | ``DISABLED``               | The host is disabled, and won't be monitored. The scheduler ignores Hosts in this state.                            |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+
| ``retry``     | ``MONITORING_ERROR``       | Monitoring a host in error state.                                                                                   |
+---------------+----------------------------+---------------------------------------------------------------------------------------------------------------------+

Scheduler Policies
==================

You can define global Scheduler Policies for all VMs in the sched.conf file, follow the :ref:`Scheduler Guide <schg>` for more information. Additionally, users can require their virtual machines to be deployed in a host that meets certain constrains. These constrains can be defined using any attribute reported by ``onehost show``, like the architecture (ARCH).

The attributes and values for a host are inserted by the monitoring probes that run from time to time on the nodes to get information. The administrator can add custom attributes either :ref:`creating a probe in the host <img>`, or updating the host information with: ``onehost update <HOST_ID>``. Calling this command will fire up an editor (the one specified in the ``EDITOR`` environment variable) and you will be able to add, delete or modify some of those values.

.. code::

    $ onehost show 3
    [...]
    MONITORING INFORMATION
    CPUSPEED=2.2GHz
    FREECPU=800
    FREEMEMORY=16777216
    HOSTNAME=ursa06
    HYPERVISOR=dummy
    TOTALCPU=800
    TOTALMEMORY=16777216
    USEDCPU=0
    USEDMEMORY=0

    $ onehost update 3

    [in editor, add CUSTOM_ATTRIBUTE=VALUE]

    $onehost show 3
    [...]
    MONITORING INFORMATION
    CPUSPEED=2.2GHz
    FREECPU=800
    FREEMEMORY=16777216
    HOSTNAME=ursa06
    HYPERVISOR=dummy
    TOTALCPU=800
    TOTALMEMORY=16777216
    USEDCPU=0
    USEDMEMORY=0
    CUSTOM_ATTRIBUTE=VALUE

This feature is useful when we want to separate a series of hosts or marking some special features of different hosts. These values can then be used for scheduling the same as the ones added by the monitoring probes, as a :ref:`placement requirement <template#placement_section>`:

.. code::

    SCHED_REQUIREMENTS = "CUSTOM_ATTRIBUTE = \"SOME_VALUE\""

A Sample Session
================

Hosts can be added to the system anytime with the ``onehost`` command. You can add the hosts to be used by OpenNebula like this:

.. code::

    $ onehost create host01 --im kvm --vm kvm --net dummy
    $ onehost create host02 --im kvm --vm kvm --net dummy

The status of the hosts can be checked with the ``onehost list`` command:

.. code::

    $ onehost list
      ID NAME         CLUSTER     RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM STAT
       0 host01       -             7    400    290    400   3.7G   2.2G   3.7G   on
       1 host02       -             2    400    294    400   3.7G   2.2G   3.7G   on
       2 host03       -             0    400    312    400   3.7G   2.2G   3.7G  off

And specific information about a host with ``show``:

.. code::

    $ onehost show host01
    HOST 0 INFORMATION
    ID                    : 0
    NAME                  : host01
    CLUSTER               : -
    STATE                 : MONITORED
    IM_MAD                : kvm
    VM_MAD                : kvm
    VN_MAD                : dummy
    LAST MONITORING TIME  : 1332756227

    HOST SHARES
    MAX MEM               : 3921416
    USED MEM (REAL)       : 1596540
    USED MEM (ALLOCATED)  : 0
    MAX CPU               : 400
    USED CPU (REAL)       : 74
    USED CPU (ALLOCATED)  : 0
    RUNNING VMS           : 7

    MONITORING INFORMATION
    ARCH=x86_64
    CPUSPEED=2393
    FREECPU=326.0
    FREEMEMORY=2324876
    HOSTNAME=rama
    HYPERVISOR=kvm
    MODELNAME="Intel(R) Core(TM) i5 CPU M 450 @ 2.40GHz"
    NETRX=0
    NETTX=0
    TOTALCPU=400
    TOTALMEMORY=3921416
    USEDCPU=74.0
    USEDMEMORY=1596540

If you want not to use a given host you can temporarily disable it:

.. code::

    $ onehost disable host01

A disabled host should be listed with ``STAT off`` by ``onehost list``. You can also remove a host permanently with:

.. code::

    $ onehost delete host01

.. warning:: Detailed information of the ``onehost`` utility can be found :ref:`in the Command Line Reference <cli#onehost>`

Using Sunstone to Manage Hosts
==============================

You can also manage your hosts using :ref:`Sunstone <sunstone>`. Select the Host tab, and there, you will be able to create, enable, disable, delete and see information about your hosts in a user friendly way.

|image1|

.. |image1| image:: /images/hosts_sunstone.png
