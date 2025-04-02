.. _devel_sched:

================================================================================
Scheduler Driver
================================================================================

The scheduler driver allows you to develop custom schedulers to work with OpenNebula. A scheduler driver is an executable that generated plans to be executed by ``oned``. A plan is a set of actions to be executed over a VM (e.g. migrate a VM to another host).


Scheduler Driver Actions
================================================================================

The main drivers are located under ``/var/lib/one/remotes/scheduler/<scheduler_driver>``. The default installation of OpenNebula includes the ``dummy``, ``rank`` and ``one_drs`` schedulers. A scheduler needs to implement two actions:

- **OPTIMIZE:** This action optimizes the workload of a cluster. Its outcomes are:

  - **SUCCESS:** A plan is returned and attached to the cluster. The plan can be applied either automatically or manually (after user review).
  - **FAILURE:** The optimization cannot be computed; an error is returned and attached to the cluster.

  **Format:**  ``OPTIMIZE <CLUSTER_ID> <SCHED_ACTION_DOCUMENT>``

- **PLACE:** This action allocates VMs in the *PENDING* state and re-schedules VMs flagged for rescheduling.

  - **SUCCESS:** A plan is returned and automatically executed. (Note: A successful status may include VMs that could not be allocated if free resources are lacking.)
  - **FAILURE:** An error is returned, and the failure is logged to inform the user.

  **Format:**  ``PLACE - <SCHED_ACTION_DOCUMENT>``


Data Model
--------------------------------------------------------------------------------

The scheduler driver communicates using an XML-based protocol defined in a ``<SCHED_ACTION_MESSAGE>`` which includes the following elements:

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

  - ``TEMPLATE/ONE_DRS``: OneDRS configuration (e.g. MIGRATION_THRESHOLD, POLICY, COST_FUNCTION, MODE).
  - ``PLAN``: The previous optimization plan (if any), which may be reused for faster re-optimization.


Example of an ``<SCHEDULER_DRIVER_ACTION>``:

.. code-block:: xml

   <?xml version="1.0"?>
   <SCHEDULER_DRIVER_ACTION>
     <VM_POOL>
       <VM>
         <ID>0</ID>
         <UID>0</UID>
         <GID>0</GID>
         <UNAME>oneadmin</UNAME>
         <GNAME>oneadmin</GNAME>
         <NAME>testvm-0</NAME>
         <PERMISSIONS>
         ...
         </PERMISSIONS>
         <LAST_POLL>1743093418</LAST_POLL>
         <STATE>3</STATE>
         <LCM_STATE>3</LCM_STATE>
         <PREV_STATE>3</PREV_STATE>
         <PREV_LCM_STATE>3</PREV_LCM_STATE>
         <RESCHED>0</RESCHED>
         <STIME>1743093368</STIME>
         <ETIME>0</ETIME>
         <DEPLOY_ID>host0:testvm-0:dummy</DEPLOY_ID>
         <MONITORING>
           <CPU><![CDATA[0]]></CPU>
           ...
           <TIMESTAMP><![CDATA[1743093418]]></TIMESTAMP>
         </MONITORING>
         <SCHED_ACTIONS/>
         <TEMPLATE>
           <AUTOMATIC_REQUIREMENTS><![CDATA[!(PIN_POLICY = PINNED)]]></AUTOMATIC_REQUIREMENTS>
           <CPU><![CDATA[0.1]]></CPU>
           <MEMORY><![CDATA[128]]></MEMORY>
           <VMID><![CDATA[0]]></VMID>
         </TEMPLATE>
         <USER_TEMPLATE/>
         <HISTORY_RECORDS>
         ...
         </HISTORY_RECORDS>
         <BACKUPS>
           <BACKUP_CONFIG/>
           <BACKUP_IDS/>
         </BACKUPS>
       </VM>
       <VM>
       ...
       </VM>
     </VM_POOL>
     <HOST_POOL>
       <HOST>
         <ID>0</ID>
         <NAME>host0</NAME>
         <STATE>2</STATE>
         <PREV_STATE>2</PREV_STATE>
         <IM_MAD><![CDATA[dummy]]></IM_MAD>
         <VM_MAD><![CDATA[dummy]]></VM_MAD>
         <CLUSTER_ID>100</CLUSTER_ID>
         <CLUSTER>test_cluster</CLUSTER>
         <HOST_SHARE>
           <MEM_USAGE>1048576</MEM_USAGE>
           <CPU_USAGE>80</CPU_USAGE>
           <TOTAL_MEM>4005824</TOTAL_MEM>
           <TOTAL_CPU>200</TOTAL_CPU>
           <MAX_MEM>4005824</MAX_MEM>
           <MAX_CPU>200</MAX_CPU>
           <RUNNING_VMS>8</RUNNING_VMS>
           <VMS_THREAD>1</VMS_THREAD>
           <DATASTORES>
             <DISK_USAGE><![CDATA[0]]></DISK_USAGE>
             <DS>
               <FREE_MB><![CDATA[56766]]></FREE_MB>
               <ID><![CDATA[0]]></ID>
               <TOTAL_MB><![CDATA[63328]]></TOTAL_MB>
               <USED_MB><![CDATA[6546]]></USED_MB>
             </DS>
             <FREE_DISK><![CDATA[56766]]></FREE_DISK>
             <MAX_DISK><![CDATA[63328]]></MAX_DISK>
             <USED_DISK><![CDATA[6546]]></USED_DISK>
           </DATASTORES>
           <PCI_DEVICES/>
           <NUMA_NODES>
           ...
           </NUMA_NODES>
         </HOST_SHARE>
         <VMS>
           <ID>0</ID>
           <ID>1</ID>
           <ID>2</ID>
           <ID>3</ID>
           <ID>4</ID>
           <ID>5</ID>
           <ID>6</ID>
           <ID>7</ID>
         </VMS>
         <TEMPLATE>
           <ARCH><![CDATA[x86_64]]></ARCH>
           <CGROUPS_VERSION><![CDATA[2]]></CGROUPS_VERSION>
           <CPUSPEED><![CDATA[0]]></CPUSPEED>
           <HOSTNAME><![CDATA[ubuntu2204-kvm-ssh-6-99-c94e-1.test]]></HOSTNAME>
           ...
         </TEMPLATE>
         <MONITORING>
           <TIMESTAMP>1743093419</TIMESTAMP>
           <ID>0</ID>
           <CAPACITY>
             <FREE_CPU><![CDATA[2]]></FREE_CPU>
             <FREE_MEMORY><![CDATA[3573260]]></FREE_MEMORY>
             <USED_CPU><![CDATA[198]]></USED_CPU>
             <USED_MEMORY><![CDATA[432564]]></USED_MEMORY>
           </CAPACITY>
           <SYSTEM>
             <NETRX><![CDATA[4751228]]></NETRX>
             <NETTX><![CDATA[9932392]]></NETTX>
           </SYSTEM>
           <NUMA_NODE>
             <HUGEPAGE>
               <FREE><![CDATA[0]]></FREE>
               <SIZE><![CDATA[2048]]></SIZE>
             </HUGEPAGE>
             ...
             <MEMORY>
               <FREE><![CDATA[3170204]]></FREE>
               <USED><![CDATA[835620]]></USED>
             </MEMORY>
             <NODE_ID><![CDATA[0]]></NODE_ID>
           </NUMA_NODE>
         </MONITORING>
         <CLUSTER_TEMPLATE>
         ...
         </CLUSTER_TEMPLATE>
       </HOST>
       <HOST>
       ...
       </HOST>
     </HOST_POOL>
     <DATASTORE_POOL>
       <DATASTORE>
         <ID>0</ID>
         <UID>0</UID>
         <GID>0</GID>
         <UNAME>oneadmin</UNAME>
         <GNAME>oneadmin</GNAME>
         <NAME>system</NAME>
         <PERMISSIONS>
         ...
         </PERMISSIONS>
         <DS_MAD><![CDATA[-]]></DS_MAD>
         <TM_MAD><![CDATA[dummy]]></TM_MAD>
         <BASE_PATH><![CDATA[/var/lib/one//datastores/0]]></BASE_PATH>
         <TYPE>1</TYPE>
         <DISK_TYPE>0</DISK_TYPE>
         <STATE>0</STATE>
         <CLUSTERS>
           <ID>0</ID>
         </CLUSTERS>
         <TOTAL_MB>4796800</TOTAL_MB>
         <FREE_MB>3333260</FREE_MB>
         <USED_MB>1429920</USED_MB>
         <IMAGES/>
         <TEMPLATE>
           <ALLOW_ORPHANS><![CDATA[NO]]></ALLOW_ORPHANS>
           <DS_MIGRATE><![CDATA[YES]]></DS_MIGRATE>
           <SHARED><![CDATA[YES]]></SHARED>
           <TM_MAD><![CDATA[dummy]]></TM_MAD>
           <TYPE><![CDATA[SYSTEM_DS]]></TYPE>
         </TEMPLATE>
       </DATASTORE>
       <DATASTORE>
       ...
       </DATASTORE>
     </DATASTORE_POOL>
     <VNET_POOL/>
     <VM_GROUP_POOL/>
     <CLUSTER_POOL>
       <CLUSTER>
         <ID>100</ID>
         <NAME>test_cluster</NAME>
         <HOSTS>
           <ID>0</ID>
           <ID>1</ID>
           <ID>2</ID>
           <ID>3</ID>
         </HOSTS>
         <DATASTORES>
           <ID>100</ID>
         </DATASTORES>
         <VNETS/>
         <TEMPLATE>
           <ONE_DRS>
             <AUTOMATION><![CDATA[full]]></AUTOMATION>
             <CPU_USAGE_WEIGHT><![CDATA[0.2]]></CPU_USAGE_WEIGHT>
             <CPU_WEIGHT><![CDATA[0.2]]></CPU_WEIGHT>
             <DISK_WEIGHT><![CDATA[0.1]]></DISK_WEIGHT>
             <MEMORY_WEIGHT><![CDATA[0.4]]></MEMORY_WEIGHT>
             <MIGRATION_THRESHOLD><![CDATA[10]]></MIGRATION_THRESHOLD>
             <NET_WEIGHT><![CDATA[0.1]]></NET_WEIGHT>
             <POLICY><![CDATA[balance]]></POLICY>
             <PREDICTIVE><![CDATA[0.2]]></PREDICTIVE>
           </ONE_DRS>
           <RESERVED_CPU><![CDATA[]]></RESERVED_CPU>
           <RESERVED_MEM><![CDATA[]]></RESERVED_MEM>
         </TEMPLATE>
       </CLUSTER>
     </CLUSTER_POOL>
     <REQUIREMENTS>
       <VM>
         <ID>0</ID>
         <HOSTS>
           <ID>0</ID>
           <ID>1</ID>
           <ID>2</ID>
           <ID>3</ID>
         </HOSTS>
         <DATASTORES>
           <ID>100</ID>
         </DATASTORES>
       </VM>
       <VM>
       ...
       </VM>
     </REQUIREMENTS>
   </SCHEDULER_DRIVER_ACTION>


The result of a scheduling action is an XML plan document. This plan specifies the operations to be executed on VMs and includes detailed information about each action.

- **PLAN/ID:**  Cluster ID which the plan is applied for (``-1`` for initial placement actions)

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
