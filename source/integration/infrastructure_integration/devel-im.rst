.. _devel-im:

==================
Monitoring Driver
==================

The Monitoring Drivers (or IM drivers) collect host and virtual machine monitoring data by executing a set of probes in the hosts. This data is either actively queried by OpenNebula or sent periodically by an agent running in the hosts to the frontend.

This guide describes the process of customize or add probes to the hosts. It is also a starting point on how to create a new IM driver from scratch.

Probe Location
==============

The default probes are installed in the frontend in the following path:

-  **KVM and Xen**: ``/var/lib/one/remotes/im/<hypervisor>-probes.d``
-  **VMware and EC2**: ``/var/lib/one/remotes/im/<hypervisor>.d``

In the case of ``KVM`` and ``Xen``, the probes are distributed to the hosts, therefore if the probes are changed, they **must** be distributed to the hosts by running ``onehost sync``.

General Probe Structure
=======================

An IM driver is composed of one or several scripts that write to ``stdout`` information in this form:

.. code::

    KEY1="value"
    KEY2="another value with spaces"

The drivers receive the following parameters:

+------------+-------------------------------------------------------------------------------------------------+
| Position   | Description                                                                                     |
+============+=================================================================================================+
| 1          | **hypervisor**: The name of the hypervisor: ``kvm``, ``xen``, etc...                            |
+------------+-------------------------------------------------------------------------------------------------+
| 2          | **datastore location**: path of the datastores directory in the host                            |
+------------+-------------------------------------------------------------------------------------------------+
| 3          | **collectd port**: port in which the ``collectd`` is listening on                               |
+------------+-------------------------------------------------------------------------------------------------+
| 4          | **monitor push cycle**: time in seconds between monitorization actions for the UDP-push model   |
+------------+-------------------------------------------------------------------------------------------------+
| 5          | **host\_id**: id of the host                                                                    |
+------------+-------------------------------------------------------------------------------------------------+
| 6          | **host\_name**: name of the host                                                                |
+------------+-------------------------------------------------------------------------------------------------+

Take into account that in shell script the parameters start at 1 (``$1``) and in ruby start at 0 (``ARGV[0]``). For shell script you can use this snippet to get the parameters:

.. code::

    hypervisor=$1
    datastore_location=$2
    collectd_port=$3
    monitor_push_cycle=$4
    host_id=$5
    host_name=$6

.. _devel-im_basic_monitoring_scripts:

Basic Monitoring Scripts
========================

You can add any key and value you want to use later in ``RANK`` and ``REQUIREMENTS`` for scheduling but there are some basic values you should output:

+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| Key           | Description                                                                                                                                       |
+===============+===================================================================================================================================================+
| HYPERVISOR    | Name of the hypervisor of the host, useful for selecting the hosts with an specific technology.                                                   |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| TOTALCPU      | Number of CPUs multiplied by 100. For example, a 16 cores machine will have a value of 1600.                                                      |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| CPUSPEED      | Speed in Mhz of the CPUs.                                                                                                                         |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| TOTALMEMORY   | Maximum memory that could be used for VMs. It is advised to take out the memory used by the hypervisor.                                           |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| USEDMEMORY    | Memory used, in kilobytes.                                                                                                                        |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| FREEMEMORY    | Available memory for VMs at that moment, in kilobytes.                                                                                            |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| FREECPU       | Percentage of idling CPU multiplied by the number of cores. For example, if 50% of the CPU is idling in a 4 core machine the value will be 200.   |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| USEDCPU       | Percentage of used CPU multiplied by the number of cores.                                                                                         |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| NETRX         | Received bytes from the network                                                                                                                   |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| NETTX         | Transferred bytes to the network                                                                                                                  |
+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------+

For example, a probe that gets memory information about a host could be something like:

.. code::

    #!/bin/bash
     
    total=$(free | awk ' /^Mem/ { print $2 }')
    used=$(free | awk '/buffers\/cache/ { print $3 }')
    free=$(free | awk '/buffers\/cache/ { print $4 }')
     
    echo "TOTALMEMORY=$total"
    echo "USEDMEMORY=$used"
    echo "FREEMEMORY=$free"

Executing it should give use memory values:

.. code::

    $ ./memory_probe
    TOTALMEMORY=1020696
    USEDMEMORY=209932
    FREEMEMORY=810724

For real examples check the directories at ``/var/lib/one/remotes/im``.

.. _devel-im_vm_information:

VM Information
==============

The scripts should also provide information about the VMs running in the host. This is useful as it will only need one call to gather all that information about the VMs in each host. The output should be in this form:

.. code::

    VM_POLL=YES
    VM=[
      ID=86,
      DEPLOY_ID=one-86,
      POLL="USEDMEMORY=918723 USEDCPU=23 NETTX=19283 NETRX=914 STATE=a" ]
    VM=[
      ID=645,
      DEPLOY_ID=one-645,
      POLL="USEDMEMORY=563865 USEDCPU=74 NETTX=2039847 NETRX=2349923 STATE=a" ]

The first line (``VM_POLL=YES``) is used to indicate OpenNebula that VM information will follow. Then the information about the VMs is output in that form.

+------------+------------------------------------------------------------------------------+
|    Key     |                                 Description                                  |
+============+==============================================================================+
| ID         | OpenNebula VM id. It can be -1 in case this VM was not created by OpenNebula |
+------------+------------------------------------------------------------------------------+
| DEPLOY\_ID | Hypervisor name or identifier of the VM                                      |
+------------+------------------------------------------------------------------------------+
| POLL       | VM monitoring info, in the same format as :ref:`VMM driver <devel-vmm>` poll |
+------------+------------------------------------------------------------------------------+

For example here is a simple script to get qemu/kvm VMs status from libvirt. As before, check the scripts from OpenNebula for a complete example:

.. code::

    #!/bin/bash
     
    echo "VM_POLL=YES"
     
    virsh -c qemu:///system list | grep one- | while read vm; do
        deploy_id=$(echo $vm | cut -d' ' -f 2)
        id=$(echo $deploy_id | cut -d- -f 2)
        status_str=$(echo $vm | cut -d' ' -f 3)
     
        if [ $status_str == "running" ]; then
            state="a"
        else
            state="e"
        fi
     
        echo "VM=["
        echo "  ID=$id,"
        echo "  DEPLOY_ID=$deploy_id,"
        echo "  POLL=\"STATE=$state\" ]"
    done

.. code::

    $ ./vm_poll
    VM_POLL=YES
    VM=[
      ID=0,
      DEPLOY_ID=one-0,
      POLL="STATE=a" ]
    VM=[
      ID=1,
      DEPLOY_ID=one-1,
      POLL="STATE=a" ]

System Datastore Information
============================

Information Manager drivers are also responsible to collect the datastore sizes and its available space. To do so there is an already made script that collects this information for filesystem and lvm based datastores. You can copy it from the KVM driver (``/var/lib/one/remotes/im/kvm-probes.d/monitor_ds.sh``) into your driver directory.

In case you want to create your own datastore monitor you have to return something like this in STDOUT:

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

The DATASTORE LOCATION is the path where the datastores are mounted. By default is ``/var/lib/one/datastores`` but it is specified in the second parameter of the script call.

Creating a New IM Driver
========================

Choosing the Execution Engine
-----------------------------

OpenNebula provides two IM probe execution engines: ``one_im_sh`` and ``one_im_ssh``. ``one_im_sh`` is used to execute probes in the frontend, for example ``vmware`` uses this engine as it collects data via an API call executed in the frontend. On the other hand, ``one_im_ssh`` is used when probes need to be run remotely in the hosts, which is the case for ``Xen`` and ``KVM``.

Populating the Probes
---------------------

Both ``one_im_sh`` and ``one_im_ssh`` require an argument which indicates the directory that contains the probes. This argument is appended with ”.d”.

**Example**: For ``VMware`` the execution engine is ``one_im_sh`` (local execution) and the argument is ``vmware``, therefore the probes that will be executed in the hosts are located in ``/var/lib/one/remotes/im/vmware.d``

Making Use of Colllectd
-----------------------

If the new IM driver wishes to use the ``collectd`` component, it needs to:

-  Use ``one_im_ssh``
-  The ``/var/lib/one/remotes/im/<im_name>.d`` should **only** contain 2 files, the sames that are provided by default inside ``kvm.d`` and ``xen.d``, which are: ``collectd-client_control.sh`` and ``collectd-client.rb``.
-  The probes should be actually placed in the ``/var/lib/one/remotes/im/<im_name>-probes.d`` folder.

Enabling the Driver
-------------------

A new IM section should be placed added to ``oned.conf``.

Example:

.. code::

    IM_MAD = [
          name       = "ganglia",
          executable = "one_im_sh",
          arguments  = "ganglia" ]

