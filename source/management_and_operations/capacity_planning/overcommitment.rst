.. _overcommitment:

================================================================================
Host Overcommitment
================================================================================

  When allocating a VM to a Host, the Scheduler checks that the capacity requested by the VM fits in the available capacity of the Host. The overall number of VMs assigned to a Host are controlled by:

  - Adjusting the total capacity announced by each Host.
  - Adjusting the capacity requested by the VM.


Virtual Machine Capacity
================================================================================

The resource allocation of the VM is expressed with the following attributes:

  - ``CPU``, percentage of CPU divided by 100 required for the VM, e.g. 0.5 will request half of a processor.
  - ``MEMORY``, total memory in MB.

It is important to not confuse with ``VCPU`` which is the number of virtual processors the Guest OS will see. Note also that the hypervisor is configured to follow the CPU allocations of the VM. In this way a VM with ``CPU=0.5`` will tend to use half of the CPU cycles of a VM with ``CPU=1.0``.

So for example a Host with 8 threads (``TOTAL CPU=800``) can host eight VMs with ``CPU=1`` or 16 VMs with ``CPU=0.5``. In this way ``CPU`` can be use to pack more VMs in a Host.


Host Capacity
================================================================================

The capacity of a Host is obtained by the monitor probes. You may alter the overall resources available to the VMs by reserving an amount of capacity. You can reserve this capacity:

* Cluster-wise, by updating the cluster template (e.g. ``onecluster update``). All the host of the cluster will reserve the same amount of capacity.
* Host-wise, by updating the host template (e.g. ``onehost update``). This value will override those defined at cluster level.

In particular the following capacity attributes can be reserved:

+------------------------+--------------------------------------------------------------------------+
|       Attribute        |                               Description                                |
+========================+==========================================================================+
| ``RESERVED_CPU``       | Unit CPU percentage. Applies to all the Hosts in this cluster. It will be|
|                        | subtracted from the TOTAL CPU. See :ref:`scheduler <schg_limit>`.        |
+------------------------+--------------------------------------------------------------------------+
| ``RESERVED_MEM``       | Unit KB. Applies to all the Hosts in this cluster. It will be subtracted |
|                        | from the TOTAL MEM. See :ref:`scheduler <schg_limit>`.                   |
+------------------------+--------------------------------------------------------------------------+

.. important:: These values can be negative, in that case you'll be actually increasing the overall capacity so overcommiting host capacity.

The above values can be absolute, e.g. ``RESERVED_MEM=-10240`` will add 1GB of memory to the Host, or in percentage, e.g. ``RESERVED_MEM=-10%`` will increase the memory of the host in a 10%.

Note also that the available storage capacity in a System Datastore is also checked before allocating a VM to it. However, you cannot overcommit this capacity.
