.. _scheduling:


Multiple System Datastore Setup
================================================================================

In order to distribute efficiently the I/O of the Virtual Machines across different disks, LUNs or several storage backends, OpenNebula is able to define multiple System Datastores per cluster. Scheduling algorithms take into account disk requirements of a particular VM, so OpenNebula is able to pick the best execution host based on capacity and storage metrics.

Configuring Multiple Datastores
--------------------------------------------------------------------------------

When more than one System Datastore is added to a cluster, all of them can be taken into account by the scheduler to place Virtual Machines into. System wide scheduling policies are defined in ``/etc/one/sched.conf``. The storage scheduling policies are:

* **Packing**. Tries to optimize storage usage by selecting the Datastore with less free space.
* **Striping**. Tries to optimize I/O by distributing the Virtual Machines across Datastores.
* **Custom**. Based on any of the attributes present in the Datastore template.

To activate for instance the Stripping storage policy, ``/etc/one/sched.conf`` must contain:

.. code::

    DEFAULT_DS_SCHED = [
       policy = 1
    ]

These policies may be overriden in the Virtual Machine Template, and so apply specific storage policies to specific Virtual Machines:

+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+
|       Attribute       |                    Description                                                    |                 Example                    |
+=======================+===================================================================================+============================================+
| SCHED_DS_REQUIREMENTS | Boolean expression to select System Datastores (evaluates to true) to run a  VM.  | ``SCHED_DS_REQUIREMENTS="ID=100"``         |
|                       |                                                                                   | ``SCHED_DS_REQUIREMENTS="NAME=GoldenDS"``  |
|                       |                                                                                   | ``SCHED_DS_REQUIREMENTS=FREE_MB > 250000`` |
+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+
| SCHED_DS_RANK         | Arithmetic expression to sort the suitable datastores for this VM.                | ``SCHED_DS_RANK= FREE_MB``                 |
|                       |                                                                                   | ``SCHED_DS_RANK=-FREE_MB``                 |
+-----------------------+-----------------------------------------------------------------------------------+--------------------------------------------+

After a VM is deployed in a System Datastore, the admin can migrate it to another System Datastore. To do that, the VM must be first :ref:`powered-off <vm_guide_2>`. The command ``onevm migrate`` accepts both a new Host and Datastore id, that must have the same ``TM_MAD`` drivers as the source Datastore.

.. warning:: Any Host belonging to a given cluster **must** be able to access any System or Image Datastore defined in that cluster.

.. warning:: Admins rights grant permissions to deploy a virtual machine to a certain datastore, using 'onevm deploy' command.

