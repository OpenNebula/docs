.. _overcommitment:

VM Template ---> CPU and MEM

================================================================================
Hosts
================================================================================
Cluster Properties
------------------

Each cluster includes a generic template where cluster configuration properties or attributes can be defined. The following list of attributes are recognized by OpenNebula:

+------------------------+--------------------------------------------------------------------------+
|       Attribute        |                               Description                                |
+========================+==========================================================================+
| ``RESERVED_CPU``       | In percentage. Applies to all the Hosts in this cluster. It will be      |
|                        | subtracted from the TOTAL CPU. See :ref:`scheduler <schg_limit>`.        |
+------------------------+--------------------------------------------------------------------------+
| ``RESERVED_MEM``       | In KB. Applies to all the Hosts in this cluster. It will be subtracted   |
|                        | from the TOTAL MEM. See :ref:`scheduler <schg_limit>`.                   |
+------------------------+--------------------------------------------------------------------------+

You can easily update these values with the ``onecluster update`` command. Also, you can add as many variables as you want, following the standard template syntax. These variables will be used for now only for informational purposes.

Limiting the Resources Exposed by a Host
========================================

Prior to assigning a VM to a Host, the available capacity is checked to ensure that the VM fits in the host. The capacity is obtained by the monitor probes. You may alter this behavior by reserving an amount of capacity (MEMORY and CPU). You can reserve this capacity:

* Cluster-wise, by updating the cluster template (e.g. ``onecluster update``). All the host of the cluster will reserve the same amount of capacity.
* Host-wise, by updating the host template (e.g. ``onehost update``). This value will override those defined at cluster level.

In particular the following capacity attributes can be reserved:

* ``RESERVED_CPU`` in percentage. It will be subtracted from the ``TOTAL CPU``
* ``RESERVED_MEM`` in KB. It will be subtracted from the ``TOTAL MEM``

.. note:: These values can be negative, in that case you'll be actually increasing the overall capacity so overcommiting host capacity.

