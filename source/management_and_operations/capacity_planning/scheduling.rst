.. _scheduling:

================================================================================
Scheduling Policies
================================================================================

The OpenNebula scheduler uses a *Matchmaking* algorithm to allocate VMs to Hosts. A *matchmaking* request consists of two parts:

  - **Requirements**, the target resource needs to fulfill these to be considered to allocate the VM. Resources that does not fulfill the requirements are filtered out.
  - **Rank**, or preferences, a function that ranks the suitable resources to sort them. Resources with a higher rank are used first.

OpenNebula uses this algorithm to schedule all resources types:

  - **Hosts**, to select the Host where the VM will run.
  - **System Datastores**, to select the System Datastore to be used.
  - **Virtual Networks**, to select the Virtual Networks to attach the VM interfaces in ``auto`` mode.

Virtual Machine Automatic Requirements
================================================================================

OpenNebula will prevent you from using incompatible resources. When a Virtual Machine uses resources (Images or Virtual Networks) from a Cluster, OpenNebula adds the following :ref:`requirement <template_placement_section>` to the template:

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

These automatic requirements are added to any additional requirement included in the Virtual Machine template. There is also an implicit requirement that a resource needs to meet, it needs to have enough capacity to run the VM.

.. warning:: Any Host belonging to a given cluster **must** be able to access any System or Image Datastore defined in that cluster.

Scheduling Hosts
================================================================================

Virtual Machine Scheduling Policies
--------------------------------------------------------------------------------

You can define VM allocation policies with the placement attributes:

  - ``SCHED_REQUIREMENTS``, Boolean expression to select a Host (evaluates to true)
  - ``SCHED_RANK``, Arithmetic expression to sort the suitable Hosts

The expressions combine attributes of the Host and/or its Cluster templates.  Note that the Host attributes are inserted by the monitoring probes that run from time to time on the nodes to get information. The administrator can add custom attributes either :ref:`creating a probe in the host <devel-im>`, or updating the host information with: ``onehost update``.

For example, consider the following scenario, where you have hosts with a QoS Gold and others with Silver:

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

You can use these expressions to force the deployment on a Host with or without QoS Gold:

.. code-block:: bash

    SCHED_REQUIREMENTS = "QOS = GOLD"

    SCHED_REQUIREMENTS = "QOS != GOLD & HYPERVISOR = kvm"

Similarly you can express your preferences for Hosts with QoS Gold, for example:

.. code-block:: bash

   SCHED_RANK = FREE_CPU
   SCHED_REQUIREMENTS = "QOS = GOLD"

This expression will use first Hosts with a higher value of the FREE_CPU Attribute, i.e. those with less load.

System-wide Scheduling Policies
--------------------------------------------------------------------------------

You can also define global scheduling policies for all the VMs in the cloud. Please check the :ref:`Scheduler configuration guide to learn how to do so <schg>`.

.. _sched_ds:

Scheduling System Datastores
================================================================================

In order to distribute efficiently the I/O of the Virtual Machines across different disks, LUNs or several storage backends, OpenNebula is able to define multiple System Datastores per cluster. Scheduling algorithms take into account disk requirements of a particular VM, so OpenNebula is able to pick the best execution host based on capacity and storage metrics.

Virtual Machine Storage Scheduling Policies
--------------------------------------------------------------------------------

Similarly to the Host policies, you can control which Datastores are used to run a Virtual Machine with:

  - ``SCHED_DS_REQUIREMENTS``, A boolean expression to select System Datastores (evaluates to true) to run a VM.
  - ``SCHED_DS_RANK``, Arithmetic expression to sort the suitable System Datastores for this VM.

For example, to select Datastores that operate in *Production*, and trying to pack VMs in them, you may use the following attributes:

.. code-block:: bash

   SCHED_DS_REQUIREMENTS="MODE=Production"
   SCHED_DS_RANK=-FREE_MB

.. note:: The administrator needs to manually label Datastores with `MODE`

System-wide Scheduling Policies
--------------------------------------------------------------------------------

You can also define global storage scheduling policies for all the VMs in the cloud. Please check the :ref:`Scheduler configuration guide to learn how to do so <schg>`.

Scheduling Virtual Networks
================================================================================

You can also let the scheduler pick the Virtual Networks the VM NICs will be attached to. The OpenNebula scheduler will look for a suitable Virtual Network in the Cluster for those NICs with ``NETWORK_MODE = "auto"``. The selection process uses also the above matchmaking algorithm based on:

  - ``SCHED_DS_REQUIREMENTS``, A boolean expression to select Virtual Networks (evaluates to true) to attach the NIC.
  - ``SCHED_DS_RANK``, Arithmetic expression to sort the suitable Virtual Networks for this NIC.

Note that this attributes are set by NIC. For example a VM may include:

.. code-block:: bash

    NIC = [ NETWORK_MODE = "auto",
            SCHED_REQUIREMENTS = "TRAFFIC_TYPE = \"public\"",
            SCHED_RANK = "-USED_LEASES" ]

    NIC = [ NETWORK_MODE = "auto",
            SCHED_REQUIREMENTS = "TRAFFIC_TYPE = \"private\"" ]

The first NIC will look for a *public* network, and will pick that more free leases, the second NIC will simply look for a *private* network.

.. note:: The administrator needs to manually label the Virtual Networks with `TRAFFIC_TYPE`

