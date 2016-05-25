.. _vcenterg:

================================================================================
vCenter Node
================================================================================ 

The vCenter driver for OpenNebula enables the interaction with vCenter to control the life-cycle of vCenter resources such as Virtual Machines, Templates, Networks and VMDKs.

OpenNebula approach to vCenter interaction
================================================================================

OpenNebula consumes resources from vCenter, and with exceptions (VMs and VMDKs) does not create these resources, but rather offers mechanisms to import them into OpenNebula to be controlled.

Virtual Machines are deployed from VMware VM Templates that **must exist previously in vCenter**. There is a one-to-one relationship between each VMware VM Template and the equivalent OpenNebula Template. Users will then instantiate the OpenNebula Templates where you can easily build from any provisioning strategy (e.g. access control, quota...).

Networking is handled by creating Virtual Network representations of the vCenter networks. OpenNebula additionally can handle on top of these networks three types of Address Ranges: Ethernet, IPv4 and IPv6. This networking information can be passed to the VMs through the contextualization process.

Therefore there is no need to convert your current Virtual Machines or import/export them through any process; once ready just save them as VM Templates in vCenter, following `this procedure <http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-FE6DE4DF-FAD0-4BB0-A1FD-AFE9A40F4BFE_copy.html>`__.

.. note:: After a VM Template is cloned and booted into a vCenter Cluster it can access VMware advanced features and it can be managed through the OpenNebula provisioning portal -to control the life-cycle, add/remove NICs, make snapshots- or through vCenter (e.g. to move the VM to another datastore or migrate it to another ESX). OpenNebula will poll vCenter to detect these changes and update its internal representation accordingly.


Considerations & Limitations
================================================================================

- **Unsupported Operations**: The following operations are **NOT** supported on vCenter VMs managed by OpenNebula, although they can be performed through vCenter:

+----------------+-----------------------------------------------------+
|   Operation    |                         Note                        |
+----------------+-----------------------------------------------------+
| migrate        | VMs cannot be migrated between ESX clusters         |
+----------------+-----------------------------------------------------+
| disk snapshots | Only system snapshots are available for vCenter VMs |
+----------------+-----------------------------------------------------+

- **No Security Groups**: Firewall rules as defined in Security Groups cannot be enforced in vCenter VMs.
- There is a known issue regarding **VNC ports**, preventing VMs with ID 89 to work correctly through VNC. This is being addressed `here <http://dev.opennebula.org/issues/2980>`__.
- OpenNebula treats **snapshots** a tad different than VMware. OpenNebula assumes that they are independent, whereas VMware builds them incrementally. This means that OpenNebula will still present snapshots that are no longer valid if one of their parent snapshots are deleted, and thus revert operations applied upon them will fail.

- **No files in context**: Passing entire files to VMs is not supported, but all the other CONTEXT sections will be honored
- Cluster name cannot contain spaces
- vCenter credential password cannot have more than 22 characters
- If you are running Sunstone using nginx/apache you will have to forward the following headers to be able to interact with vCenter, HTTP_X_VCENTER_USER, HTTP_X_VCENTER_PASSWORD and HTTP_X_VCENTER_HOST (or, alternatively, X_VCENTER_USER, X_VCENTER_PASSWORD and X_VCENTER_HOST). For example in nginx you have to add the following attrs to the server section of your nginx file (underscores_in_headers on; proxy_pass_request_headers on;)

.. _import_vcenter_resources:

Importing vCenter VM Templates and running VMs
================================================================================

The same **onevcenter** tool can be used to import existing VM templates from the ESX clusters:

.. prompt:: bash $ auto

    $ onevcenter templates --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>

    Connecting to vCenter: <vcenter-host>...done!

    Looking for VM Templates...done!

    Do you want to process datacenter Development [y/n]? y

      * VM Template found:
          - Name   : ttyTemplate
          - UUID   : 421649f3-92d4-49b0-8b3e-358abd18b7dc
          - Cluster: clusterA
        Import this VM template [y/n]? y
        OpenNebula template 4 created!

      * VM Template found:
          - Name   : Template test
          - UUID   : 4216d5af-7c51-914c-33af-1747667c1019
          - Cluster: clusterB
        Import this VM template [y/n]? y
        OpenNebula template 5 created!

    $ onetemplate list
      ID USER            GROUP           NAME                                REGTIME
       4 oneadmin        oneadmin        ttyTemplate                  09/22 11:54:33
       5 oneadmin        oneadmin        Template test                09/22 11:54:35

    $ onetemplate show 5
    TEMPLATE 5 INFORMATION
    ID             : 5
    NAME           : Template test
    USER           : oneadmin
    GROUP          : oneadmin
    REGISTER TIME  : 09/22 11:54:35

    PERMISSIONS
    OWNER          : um-
    GROUP          : ---
    OTHER          : ---

    TEMPLATE CONTENTS
    CPU="1"
    MEMORY="512"
    PUBLIC_CLOUD=[
      TYPE="vcenter",
      VM_TEMPLATE="4216d5af-7c51-914c-33af-1747667c1019" ]
    SCHED_REQUIREMENTS="NAME=\"devel\""
    VCPU="1"

To import existing VMs, the 'onehost importvm" command can be used. VMs in running state can be imported, and also VMs defined in vCenter that are not in power.on state (this will import the VMs in OpenNebula as in the poweroff state).

.. prompt:: bash $ auto

    $ onehost show 0
      HOST 0 INFORMATION
      ID                    : 0
      NAME                  : MyvCenterHost
      CLUSTER               : -
      [....]

      WILD VIRTUAL MACHINES

                        NAME                            IMPORT_ID  CPU     MEMORY
                   RunningVM 4223cbb1-34a3-6a58-5ec7-a55db235ac64    1       1024
      [....]

    $ onehost importvm 0 RunningVM
    $ onevm list
    ID USER     GROUP    NAME            STAT UCPU    UMEM HOST               TIME
     3 oneadmin oneadmin RunningVM       runn    0    590M MyvCenterHost  0d 01h02

After a Virtual Machine is imported, their life-cycle (including creation of snapshots) can be controlled through OpenNebula. The following operations *cannot* be performed on an imported VM:

- Delete --recreate
- Undeploy (and Undeploy --hard)
- Migrate (and Migrate --live)
- Stop

Also, network management operations are present like the ability to attach/detach network interfaces, as well as capacity (CPU and MEMORY) resizing operations and VNC connections if the ports are opened before hand.

.. _reacquire_vcenter_resources:

The same import mechanism is available graphically through Sunstone for hosts, networks, templates and running VMs. vCenter hosts can be imported using the vCenter host create dialog, and Networks and VM Templates through the Import button in the Virtual Networks and Templates tab respectively. Running and Powered Off VMs can be imported through the WILDS tab in the Host info tab.

.. image:: /images/vcenter_create.png
    :width: 90%
    :align: center

.. note:: running VMS can only be imported after the vCenter host has been successfully acquired.


.. _vm_scheduling_vcenter:

VM Scheduling
================================================================================

OpenNebula scheduler should only chose a particular OpenNebula host for a OpenNebula VM Template representing a vCenter VM Template, since it most likely only would be available in a particular vCenter cluster.

Since a vCenter cluster is an aggregation of ESX hosts, the ultimate placement of the VM on a particular ESX host would be managed by vCenter, in particular by the `Distribute Resource Scheduler (DRS) <https://www.vmware.com/es/products/vsphere/features/drs-dpm>`__.

In order to enforce this compulsory match between a vCenter cluster and a OpenNebula/vCenter VM Template, add the following to the OpenNebula VM Template:

.. code::

    SCHED_REQUIREMENTS = "NAME=\"name of the vCenter cluster where this VM Template can instantiated into a VM\""

In Sunstone, a host abstracting a vCenter cluster will have an extra tab showing the ESX hosts that conform the cluster.

.. image:: /images/host_esx.png
    :width: 90%
    :align: center

VM Template Cloning Procedure
================================================================================

OpenNebula uses VMware cloning VM Template procedure to instantiate new Virtual Machines through vCenter. From the VMware documentation:

-- Deploying a virtual machine from a template creates a virtual machine that is a copy of the template. The new virtual machine has the virtual hardware, installed software, and other properties that are configured for the template.

A VM Template is tied to the host where the VM was running, and also the datastore(s) where the VM disks where placed. By default, the VM will be deployed in that datastore where the VM Template is bound to, although another datastore can be selected at deployment time. Due to shared datastores, vCenter can instantiate a VM Template in any of the hosts belonging to the same cluster as the original one.

OpenNebula uses several assumptions to instantiate a VM Template in an automatic way:

- **diskMoveType**: OpenNebuls instructs vCenter to "move only the child-most disk backing. Any parent disk backings should be left in their current locations.". More information `here <https://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.DiskMoveOptions.html>`__

- Target **resource pool**: OpenNebula uses the default cluster resource pool to place the VM instantiated from the VM template, unless VCENTER_RESOURCE_POOL variable defined in the OpenNebula host template, or the tag RESOURCE_POOL is present in the VM Template inside the PUBLIC_CLOUD section.

.. todo:: save as persistent

Usage
================================================================================

.. _vm_template_definition_vcenter:

VM Template definition
--------------------------------------------------------------------------------

In order to manually create a VM Template definition in OpenNebula that represents a vCenter VM Template, the following attributes are needed:

+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|     Operation      |                                                                                                                                                                     Note                                                                                                                                                                     |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CPU                | Physical CPUs to be used by the VM. This does not have to relate to the CPUs used by the vCenter VM Template, OpenNebula will change the value accordingly                                                                                                                                                                                   |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| MEMORY             | Physical Memory in MB to be used by the VM. This does not have to relate to the CPUs used by the vCenter VM Template, OpenNebula will change the value accordingly                                                                                                                                                                           |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NIC                | Check :ref:`VM template reference <template_network_section>`. Valid MODELs are: virtuale1000, virtuale1000e, virtualpcnet32, virtualsriovethernetcard, virtualvmxnetm, virtualvmxnet2, virtualvmxnet3.                                                                                                                                      |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DISK               | Check :ref:`VM template reference <reference_vm_template_disk_section>`. Take into account that all images are persistent, as explained in :ref:`vCenter Datastore Setup <vcenter_ds>`.                                                                                                                                                      |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRAPHICS           | Multi-value - Only VNC supported, check the  :ref:`VM template reference <io_devices_section>`.                                                                                                                                                                                                                                              |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| PUBLIC_CLOUD       | Multi-value. TYPE must be set to vcenter, and VM_TEMPLATE must point to the uuid of the vCenter VM that is being represented                                                                                                                                                                                                                 |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SCHED_REQUIREMENTS | NAME="name of the vCenter cluster where this VM Template can instantiated into a VM". See :ref:`VM Scheduling section <vm_scheduling_vcenter>` for more details.                                                                                                                                                                             |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CONTEXT            | All :ref:`sections <template_context>` will be honored except FILES. You can find more information about contextualization in the :ref:`vcenter Contextualization <vcenter_context>` section.                                                                                                                                                |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| KEEP_DISKS_ON_DONE | (Optional) Prevent OpenNebula from erasing the VM disks upon reaching the done state (either via shutdown or cancel)                                                                                                                                                                                                                         |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| VCENTER_DATASTORE  | By default, the VM will be deployed to the datastore where the VM Template is bound to. This attribute allows to set the name of the datastore where this VM will be deployed.  This can be overwritten explicitly at deployment time from the CLI or Sunstone. More information in the :ref:` vCenter Datastore Setup Section <vcenter_ds>` |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| RESOURCE_POOL      | By default, the VM will be deployed to the default resource pool. If this attribute is set, its value will be used to confine this the VM in the referred resource pool. Check :ref:`this section <vcenter_resource_pool>` for more information.                                                                                             |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

After a VM Template is instantiated, the life-cycle of the resulting virtual machine (including creation of snapshots) can be controlled through OpenNebula. Also, all the operations available in the :ref:`vCenter Admin view <vcenter_view>` can be performed, including:

- network management operations like the ability to attach/detach network interfaces
- capacity (CPU and MEMORY) resizing
- VNC connectivity
- Attach/detach VMDK images as disks

The monitoring attributes retrieved from a vCenter VM are:

- ESX_HOST
- GUEST_IP
- GUEST_STATE
- VMWARETOOLS_RUNNING_STATUS
- VMWARETOOLS_VERSION
- VMWARETOOLS_VERSION_STATUS

Resource Pool
================================================================================

.. _vcenter_resource_pool:

OpenNebula can place VMs in different Resource Pools. There are two approaches to achieve this, fixed per Cluster basis or flexible per VM Template basis.

In the fixed per Cluster basis approach, the vCenter credentials that OpenNebula use can be confined into a Resource Pool, to allow only a fraction of the vCenter infrastructure to be used by OpenNebula users. The steps to confine OpenNebula users into a Resource Pool are:

- Create a new vCenter user
- Create a Resource Pool in vCenter and assign the subset of Datacenter hardware resources wanted to be exposed through OpenNebula
- Give vCenter user Resource Pool Administration rights over the Resource Pool
- Give vCenter user Resource Pool Administration (or equivalent) over the Datastores the VMs are going to be running on

Afterwards, these credentials can be used to add to OpenNebula the host representing the vCenter cluster. Add a new tag called VCENTER_RESOURCE_POOL to the host template representing the vCenter cluster (for instance, in the info tab of the host, or in the CLI), with the name of the Resource Pool.

.. image:: /images/vcenter_rp.png
   :width: 90%
   :align: center

The second approach is more flexible in the sense that all Resource Pools defined in vCenter can be used, and the mechanism to select which one the VM is going to reside into can be defined using the attribute RESOURCE_POOL  in the OpenNebula VM Template:

Nested Resource Pools can be represented using '/'. For instance, a Resource Pool "RPChild" nested under "RPAncestor" can be represented both in VCENTER_RESOURCE_POOL and RESOURCE_POOL attributes as "RPAncestor/RPChild".

.. code::

    RESOURCE_POOL="RPAncestor/RPChild"
    PUBLIC_CLOUD=[
      HOST="Cluster",
      TYPE="vcenter",
      VM_TEMPLATE="4223067b-ed9b-8f73-82ba-b1a98c3ff96e" ]


Tuning & Extending
================================================================================

The driver consists of the following files:

-  ``/usr/lib/one/mads/one_vmm_exec`` : generic VMM driver.
-  ``/var/lib/one/remotes/vmm/vcenter`` : commands executed to perform actions.

And the following driver configuration files:

-  ``/etc/one/vmm_exec/vmm_exec_vcenter.conf`` : This file is home for default values for OpenNebula VM templates

It is generally a good idea to place defaults for the vCenter-specific attributes, that is, attributes mandatory in the Vcenter driver that are not mandatory for other hypervisors. Non mandatory attributes for vCenter but specific to them are also recommended to have a default.
