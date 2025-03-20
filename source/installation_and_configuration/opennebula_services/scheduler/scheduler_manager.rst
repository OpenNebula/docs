.. _scheduler_manager:

=====================
Scheduler Manager
=====================

The Scheduler Manager is the core component responsible for generating and handling both placement and optimization plans. It interacts with the scheduler driver, processes VM placement/optimization actions, and triggers the corresponding plan execution.

Schedulers Configuration
------------------------
Scheduler-related parameters are defined in the OpenNebula Daemon configuration file (``/etc/one/oned.conf``):


* ``SCHED_MAD``: Defines the scheduler driver used to manage scheduling operations.
* ``EXECUTABLE``: The path to the scheduler driver executable (absolute or relative to ``/usr/lib/one/mads/``).
* ``ARGUMENTS``: Options passed to the driver, such as:

  * ``-t``: Number of concurrent threads.
  * ``-p``: Scheduler for initial placement (e.g., ``rank`` for the default match-making algorithm).
  * ``-o``: Scheduler for optimizing VM allocation (e.g., ``one_drs``).

These parameters determine when the scheduler dispatches a placement request:

* ``SCHED_MAX_WND_TIME``: Maximum time (in seconds) that a scheduling window remains open.
* ``SCHED_MAX_WND_LENGTH``: Maximum number of queued VMs before a placement action is triggered.

Retry and Timeout Settings:

* ``SCHED_RETRY_TIME``: Interval (in seconds) at which placement is retried for VMs that could not be allocated.
* ``ACTION_TIMEOUT``: Time (in seconds) after which pending actions are marked as failed due to timeout.
* ``MAX_ACTIONS_PER_HOST``: Limit on the number of concurrent actions at the host level.
* ``MAX_ACTIONS_PER_CLUSTER``: Limit on the number of concurrent actions at the cluster level.

Rescheduling Options:

* ``LIVE_RESCHEDS``: Indicates whether to perform live (``1``) or cold (``0``) migrations when rescheduling.
* ``COLD_MIGRATE_MODE``: Specifies the type of cold migration:

  * ``0``: Save (default)
  * ``1``: Poweroff
  * ``2``: Poweroff-hard

DRS Interval:

* ``DRS_INTERVAL``: Time (in seconds) between Distributed Resource Scheduler actions; set to ``-1`` to disable.

This is an example configuration snippet from ``/etc/one/oned.conf``:

.. code-block:: ini

    SCHED_MAD = [
          EXECUTABLE = "one_sched",
          ARGUMENTS  = "-t 15 -p rank -o one_drs"
    ]

    SCHED_MAX_WND_TIME   = 10
    SCHED_MAX_WND_LENGTH = 7

    SCHED_RETRY_TIME = 60

    MAX_ACTIONS_PER_HOST    = 1
    MAX_ACTIONS_PER_CLUSTER = 30

    ACTION_TIMEOUT = 300

    LIVE_RESCHEDS     = 0
    COLD_MIGRATE_MODE = 0

    DRS_INTERVAL = -1


Protocol
--------

The scheduler driver implements two main actions that define the protocol for scheduling:

- **OPTIMIZE:** This action optimizes the workload of a cluster. Its outcomes are:
  
  - **SUCCESS:** A plan is returned and attached to the cluster. The plan can be applied either automatically or manually (after user review).
  - **FAILURE:** The optimization cannot be computed; an error is returned and attached to the cluster.
  
  **Format:**  ``OPTIMIZE <CLUSTER_ID> <SCHED_ACTION_DOCUMENT>``

- **PLACE:** This action allocates VMs in the *PENDING* state and re-schedules VMs flagged for rescheduling.
  
  - **SUCCESS:** A plan is returned and automatically executed. (Note: A successful status may include VMs that could not be allocated if free resources are lacking.)
  - **FAILURE:** An error is returned, and the failure is logged to inform the user.
  
  **Format:**  ``PLACE - <SCHED_ACTION_DOCUMENT>``


Data Model
----------

The scheduler driver communicates using an XML-based protocol defined in a ``<SCHED_ACTION_MESSAGE>`` which includes:

- **/VM_POOL/VM:** Lists all VMs matching the scheduling request:
  
  - For PLACE: VMs in *PENDING* or *RESCHED* states.
  - For OPTIMIZE: VMs running in the specified cluster.

- **/HOST_POOL/HOST:** Lists hosts to consider:
  
  - For PLACE: all available hosts.
  - For OPTIMIZE: only hosts in the target cluster.

- **/DATASTORE_POOL/DATASTORE:** Lists datastores:
  
  - For PLACE: all datastores.
  - For OPTIMIZE: only cluster-associated datastores.

- **/VNET_POOL/VNET:**  Lists virtual networks:
  
  - For PLACE: all networks.
  - For OPTIMIZE: only cluster-associated networks.

- **/VMGROUP_POOL/VMGROUP:**  Lists defined VM groups.

- **/REQUIREMENTS/VM/:**  Contains placement requirements for each VM, such as:
  
  - ``<ID>``: VM identifier.
  - ``<HOSTS>/<ID>``: IDs of eligible hosts.
  - ``<NIC>/<ID>``: NIC identifier.
  - ``<NIC>/<VNETS>/<ID>``: Virtual network ID for the NIC.
  - ``<DATASTORE>/<ID>``: Datastore ID.

- **/CLUSTER:**  The cluster document, including:
  
  - ``TEMPLATE/DRS``: DRS configuration (e.g. MIGRATION_THRESHOLD, POLICY, COST_FUNCTION, MODE).
  - ``PLAN``: The previous optimization plan (if any), which may be reused for faster re-optimization.


The result of a scheduling action is an XML plan document. This plan specifies the operations to be executed on VMs and includes detailed information about each action. 

- **PLAN/ID:**  Cluster ID which the plan is appliad for (``-1`` ofr initial placement actions)

- **ACTION:** Each Plan action contains:

  - ``VM_ID``: Identifier of the target VM.
  - ``OPERATION``: The operation to perform (e.g., ``deploy``, ``migrate``, ``poweroff``).
  - ``HOST_ID/DS_ID``: For operations like deploy and migrate, the target host and datastore are specified.
  - ``NIC``: (For deploy operations) Contains one or more NIC configurations with:

    - ``NIC_ID``: Identifier of the NIC.
    - ``NETWORK_ID``: The associated virtual network.

Example of an XML Plan:

.. code-block:: xml

<PLAN>
  <ID>-1</ID>
  <ACTION>
    <VM_ID>23</VM_ID>
    <OPERATION>deploy</OPERATION>
    <HOST_ID>12</HOST_ID>
    <DS_ID>100</DS_ID>
    <NIC>
      <NIC_ID>0</NIC_ID>
      <NETWORK_ID>101</NETWORK_ID>
    </NIC>
    <NIC>
      <NIC_ID>1</NIC_ID>
      <NETWORK_ID>100</NETWORK_ID>
    </NIC>
  </ACTION>
  <ACTION>
    <VM_ID>24</VM_ID>
    <OPERATION>migrate</OPERATION>
    <HOST_ID>15</HOST_ID>
    <DS_ID>200</DS_ID>
  </ACTION>
  <ACTION>
    <VM_ID>25</VM_ID>
    <OPERATION>poweroff</OPERATION>
  </ACTION>
</PLAN>
