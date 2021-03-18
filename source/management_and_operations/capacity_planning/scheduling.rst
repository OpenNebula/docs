.. _scheduling:




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


Scheduling and Clusters
=======================

Automatic Requirements
----------------------

When a Virtual Machine uses resources (Images or Virtual Networks) from a Cluster, OpenNebula adds the following :ref:`requirement <template_placement_section>` to the template:

.. prompt:: bash $ auto

    $ onevm show 0
    [...]
    AUTOMATIC_REQUIREMENTS="CLUSTER_ID = 100"

Because of this, if you try to use resources that do not belong to the same Cluster, the Virtual Machine creation will fail with a message similar to this one:

.. prompt:: bash $ auto

    $ onetemplate instantiate 0
    [TemplateInstantiate] Error allocating a new virtual machine. Incompatible cluster IDs.
    DISK [0]: IMAGE [0] from DATASTORE [1] requires CLUSTER [101]
    NIC [0]: NETWORK [1] requires CLUSTER [100]

Manual Requirements and Rank
----------------------------

The placement attributes :ref:`SCHED\_REQUIREMENTS and SCHED\_RANK <template_placement_section>` can use attributes from the Cluster template. Let’s say you have the following scenario:

.. prompt:: bash $ auto

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 host01          cluster_a   0       0 / 200 (0%)     0K / 3.6G (0%) on
       2 host02          cluster_a   0       0 / 200 (0%)     0K / 3.6G (0%) on
       3 host03          cluster_b   0       0 / 200 (0%)     0K / 3.6G (0%) on

    $ onecluster show cluster_a
    CLUSTER TEMPLATE
    QOS="GOLD"

    $ onecluster show cluster_b
    CLUSTER TEMPLATE
    QOS="SILVER"

You can use these expressions:

.. code-block:: bash

    SCHED_REQUIREMENTS = "QOS = GOLD"
     
    SCHED_REQUIREMENTS = "QOS != GOLD & HYPERVISOR = kvm"


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

