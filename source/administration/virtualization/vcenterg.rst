.. _vcenterg:

======================
VMware vCenter Drivers
======================

OpenNebula seamlessly integrates vCenter virtualized infrastructures so leveraging the advanced features such as vMotion, HA or DRS scheduling provided by the VMware vSphere product family. On top of it, OpenNebula exposes a multi-tenant, cloud-like provisioning layer, including features like virtual data centers, datacenter federation or hybrid cloud computing to connect in-house vCenter infrastructures with public clouds. You also take a step toward liberating your stack from vendor lock-in.

These drivers are for companies that want to keep VMware management tools, procedures and workflows. For these companies, throwing away VMware and retooling the entire stack is not the answer. However, as they consider moving beyond virtualization toward a private cloud, they can choose to either invest more in VMware, or proceed on a tactically challenging but strategically rewarding path of open. 

The OpenNebula - vCenter combination allows you to deploy advanced provisioning infrastructures of virtualized resources. In this guide you'll learn how to configure OpenNebula to access one or more vCenters and set-up VMware-based virtual machines.

Overview and Architecture
=========================

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor, i.e. as an OpenNebula host. Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level, vCenter then uses the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine.

As the figure shows, OpenNebula components see two hosts where each represents a cluster in a vCenter. You can further group these hosts into OpenNebula clusters to build complex resource providers for your user groups and virtual data centers in OpenNebula.

.. note:: Together with the ESX Cluster hosts you can add other hypervisor types or even hybrid cloud instances like Microsoft Azure or Amazon EC2.

.. image:: /images/JV_architecture.png
    :width: 250px
    :align: center

Virtual Machines are deployed from VMware VM Templates that **must exist previously in vCenter**. There is a one-to-one relationship between each VMware VM Template and the equivalent OpenNebula Template. Users will then instantiate the OpenNebula Templates where you can easily build from any provisioning strategy (e.g. access control, quota...).

Therefore there is no need to convert your current Virtual Machines or import/export them through any process; once ready just save them as VM Templates in vCenter, following `this procedure <http://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-FE6DE4DF-FAD0-4BB0-A1FD-AFE9A40F4BFE_copy.html>`__.

.. note:: After a VM Template is cloned and booted into a vCenter Cluster it can access VMware advanced features and it can be managed through the OpenNebula provisioning portal or through vCenter (e.g. to move the VM to another datastore or migrate it to another ESX). OpenNebula will poll vCenter to detect these changes and update its internal representation accordingly.

Requirements
============

The following must be met for a functional vCenter environment:

- vCenter 5.1+, with at least one cluster aggregating at least one ESX 5.1+ host.

- Define a vCenter user for OpenNebula. This vCenter user (let's call her oneadmin) needs to have access to the ESX clusters that OpenNebula will manage. In order to avoid problems, the hassle free approach is to declare this oneadmin user as Administrator. In production environments though, it may be needed to perform a more fine grained permission assigment (please note that the following permissions related to operations are related to the use that OpenNebula does with this operations):

+-----------------------+------------------------------------------+--------------------------------------------------+
|   vCenter Operation   |                Privileges                |                      Notes                       |
+-----------------------+------------------------------------------+--------------------------------------------------+
| CloneVM_Task          | None                                     | Creates a clone of a particular VM               |
+-----------------------+------------------------------------------+--------------------------------------------------+
| ReconfigVM_Task       | VirtualMachine.Interact.DeviceConnection | Reconfigures a particular virtual machine.       |
|                       | VirtualMachine.Interact.SetCDMedia       |                                                  |
|                       | VirtualMachine.Interact.SetFloppyMedia   |                                                  |
|                       | VirtualMachine.Config.Rename             |                                                  |
|                       | VirtualMachine.Config.Annotation         |                                                  |
|                       | VirtualMachine.Config.AddExistingDisk    |                                                  |
|                       | VirtualMachine.Config.AddNewDisk         |                                                  |
|                       | VirtualMachine.Config.RemoveDisk         |                                                  |
|                       | VirtualMachine.Config.CPUCount           |                                                  |
|                       | VirtualMachine.Config.Memory             |                                                  |
|                       | VirtualMachine.Config.RawDevice          |                                                  |
|                       | VirtualMachine.Config.AddRemoveDevice    |                                                  |
|                       | VirtualMachine.Config.EditDevice         |                                                  |
|                       | VirtualMachine.Config.Settings           |                                                  |
|                       | VirtualMachine.Config.Resource           |                                                  |
|                       | VirtualMachine.Config.AdvancedConfig     |                                                  |
|                       | VirtualMachine.Config.SwapPlacement      |                                                  |
|                       | VirtualMachine.Config.HostUSBDevice      |                                                  |
|                       | VirtualMachine.Config.DiskExtend         |                                                  |
|                       | VirtualMachine.Config.ChangeTracking     |                                                  |
|                       | VirtualMachine.Config.MksControl         |                                                  |
|                       | DVSwitch.CanUse                          |                                                  |
|                       | DVPortgroup.CanUse                       |                                                  |
|                       | VirtualMachine.Config.RawDevice          |                                                  |
|                       | VirtualMachine.Config.AddExistingDisk    |                                                  |
|                       | VirtualMachine.Config.AddNewDisk         |                                                  |
|                       | VirtualMachine.Config.HostUSBDevice      |                                                  |
|                       | Datastore.AllocateSpace                  |                                                  |
|                       | Network.Assign                           |                                                  |
+-----------------------+------------------------------------------+--------------------------------------------------+
| PowerOnVM_Task        | VirtualMachine.Interact.PowerOn          | Powers on a virtual machine                      |
+-----------------------+------------------------------------------+--------------------------------------------------+
| PowerOffVM_Task       | VirtualMachine.Interact.PowerOff         | Powers off a virtual machine                     |
+-----------------------+------------------------------------------+--------------------------------------------------+
| Destroy_Task          | VirtualMachine.Inventory.Delete          | Deletes a VM (including disks)                   |
+-----------------------+------------------------------------------+--------------------------------------------------+
| SuspendVM_Task        | VirtualMachine.Interact.Suspend          | Suspends a VM                                    |
+-----------------------+------------------------------------------+--------------------------------------------------+
| RebootGuest           | VirtualMachine.Interact.Reset            | Reboots VM's guest Operating System              |
+-----------------------+------------------------------------------+--------------------------------------------------+
| ResetVM_Task          | VirtualMachine.Interact.Reset            | Resets power on a virtual machine                |
+-----------------------+------------------------------------------+--------------------------------------------------+
| ShutdownGuest         | VirtualMachine.Interact.PowerOff         | Shutdown guest Operating System                  |
+-----------------------+------------------------------------------+--------------------------------------------------+
| CreateSnapshot_Task   | VirtualMachine.State.CreateSnapshot      | Creates a new snapshot of a virtual machine.     |
+-----------------------+------------------------------------------+--------------------------------------------------+
| RemoveSnapshot_Task   | VirtualMachine.State.RemoveSnapshot      | Removes a snapshot form a virtual machine        |
+-----------------------+------------------------------------------+--------------------------------------------------+
| RevertToSnapshot_Task | VirtualMachine.State.RevertToSnapshot    | Rever a virtual machine to a particular snapshot |
+-----------------------+------------------------------------------+--------------------------------------------------+


.. note:: For security reasons, you may define different users to access different ESX Clusters. A different user can defined in OpenNebula per ESX cluster, which is encapsulated in OpenNebula as an OpenNebula host.

- All ESX hosts belonging to the same ESXcluster to be exposed to OpenNebula **must** share one datastore among them. A cluster **may** have DRS enanled. and shared storage for the ESX Clusters that are going .

- **Save as VMs Templates those VMs that will be instantiated through the OpenNebula provisioning portal**

.. important:: OpenNebula will **NOT** modify any vCenter configuration or manage any existing Virtual Machine.

Considerations & Limitations
============================
- **No context**: Virtual Machines won't have the ability of being contextualized, so CONTEXT sections won't be honored
- **Unsupported Operations**: The following operations are **NOT** supported on vCenter VMs managed by OpenNebula, although they can be perfomed through vCenter:

+-------------+------------------------------------------------+
|  Operation  |                      Note                      |
+-------------+------------------------------------------------+
| attach_disk | Action of attaching a new disk to a running VM |
+-------------+------------------------------------------------+
| detach_disk | Action of detaching a new disk to a running VM |
+-------------+------------------------------------------------+
| attach_nic  | Action of attaching a new NIC to a running VM  |
+-------------+------------------------------------------------+
| detach_nic  | Action of detaching a new NIC to a running VM  |
+-------------+------------------------------------------------+
| migrate     | VMs cannot be migrated between ESX clusters    |
+-------------+------------------------------------------------+

- **No Security Groups**: Firewall rules as defined in Security Groups cannot be enforced in vCenter VMs.
- There is a known issue regarding **VNC ports**, preventing VMs with ID 89 to work correctly through VNC. This is being addressed `here <http://dev.opennebula.org/issues/2980>`__.
- OpenNebula treats **snapshots** a tad different from VMware. OpenNebula assumes that they are independent, whereas VMware builds them incrementally. This means that OpenNebula will still present snapshots that are no longer valid if one of their parent snapshots are deleted, and thus revert operatoins applied upon them will fail.

Configuration
=============

OpenNebula Configuration
------------------------

There are two simple steps needed to configure OpenNebula so it can interact with vCenter:

**Step 1: Check connectivity**

The OpenNebula front-end needs network connectivity to all the vCenters that it is supposed to manage.

Additionaly, to enable VNC access to the spawned Virtual Machines, the front-end also needs network connectivity to all the ESX hosts

**Step 2: Enable the drivers in oned.conf**

In order to configure OpenNebula to work with the vCenter drivers, the following sections need to be uncommented or added in the ``/etc/one/oned.conf`` file:

.. code::

    #-------------------------------------------------------------------------------
    #  vCenter Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    #IM_MAD = [
    #      name       = "vcenter",
    #      executable = "one_im_sh",
    #      arguments  = "-c -t 15 -r 0 vcenter" ]
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    #  vCenter Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    #VM_MAD = [
    #    name       = "vcenter",
    #    executable = "one_vmm_sh",
    #    arguments  = "-t 15 -r 0 vcenter -s sh",
    #    type       = "xml" ]
    #-------------------------------------------------------------------------------

**Step 3: Importing vCenter Clusters**

OpenNebula ships with a powerful CLI tool to import vCenter clusters and VM Templates. The tools is self-explanatory, just set the credentials and IP to access the vCenter host and follow on screen instructions. A sample section follows:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT   
                                                                                    
    $ onevcenter hosts --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>
    Connecting to vCenter: <vcenter-host>...done!
    Exploring vCenter resources...done!
    Do you want to process datacenter Development [y/n]? y
      * Import cluster clusterA [y/n]? y
        OpenNebula host clusterA with id 0 successfully created.

      * Import cluster clusterB [y/n]? y
        OpenNebula host clusterB with id 1 successfully created.

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 clusterA        -           0                  -                  - init
       1 clusterB        -           0                  -                  - init
    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 clusterA        -           0       0 / 800 (0%)      0K / 16G (0%) on
       1 clusterB        -           0                  -                  - init
    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 clusterA        -           0       0 / 800 (0%)      0K / 16G (0%) on
       1 clusterB        -           0      0 / 1600 (0%)      0K / 16G (0%) on


The following variables are added to the OpenNebula hosts representing ESX clusters:

+------------------+------------------------------------+
|    Operation     |                Note                |
+------------------+------------------------------------+
| VCENTER_HOST     | hostname or IP of the vCenter host |
+------------------+------------------------------------+
| VCENTER_USER     | Name of the vCenter user           |
+------------------+------------------------------------+
| VCENTER_PASSWORD | Password of the vCenter user       |
+------------------+------------------------------------+

TODO :: Sunstone dialog for host creation

**Step 4: Importing vCenter VM Templates**

The same **onevcenter** tool can be used to import existing VM templates from the ESX clusters:

.. code::

    $ ./onevcenter templates --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>

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

Usage
=====

VM Template definition
----------------------

In order to manually create a VM Template definition in OpenNebula that represents a vCenter VM Template, the following attributes are needed:

+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|     Operation      |                                                                               Note                                                                               |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CPU                | Physical CPUs to be used by the VM. This **must** relate to the CPUs used by the vCenter VM Template                                                             |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| MEMORY             | Physical CPUs to be used by the VM. This **must** relate to the CPUs used by the vCenter VM Template                                                             |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRAPHICS           | Multi-value - Only VNC supported, check the  :ref:`VM template reference <io_devices_section>`.                                                                  |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| PUBLIC_CLOUD       | Multi-value. TYPE must be set to vcenter, and VM_TEMPLATE must point to the uuid of the vCenter VM that is being represented                                     |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SCHED_REQUIREMENTS | NAME="name of the vCenter cluster where this VM Template can instantiated into a VM". See :ref:`VM Scheduling section <vm_scheduling_vcenter>` for more details. |
+--------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+

TODO :: Sunstone dialog for VM template creation?

.. _vm_scheduling_vcenter:

VM Scheduling
-------------

OpenNebula scheduler should only chose a particular OpenNebula host for a OpenNebula VM Template representing a vCenter VM Template, since it most likely only would be available in a particular vCenter cluster.

Since a vCenter cluster is an aggregation of ESX hosts, the ultimate placement of the VM on a particular ESX host would be managed by vCenter, in particular by the `Distribute Resource Scheduler (DRS) <https://www.vmware.com/es/products/vsphere/features/drs-dpm>`__.

In order to enforce this compulsory match between a vCenter cluster and a OpenNebula/vCenter VM Template, add the following to the OpenNebula VM Template:

.. code::

    SCHED_REQUIREMENTS = "NAME=\"name of the vCenter cluster where this VM Template can instantiated into a VM\""

VM Template Cloning Procedure
=============================

OpenNebula uses VMware cloning VM Template procedure to instantiate new Virtual Machines through vCenter. From the VMware documentation:

-- Deploying a virtual machine from a template creates a virtual machine that is a copy of the template. The new virtual machine  
   has the virtual hardware, installed software, and other properties that are configured for the template.

A VM Template is tied to the host where the VM was running, and also the datastore(s) where the VM disks where placed. Due to shared datastores, vCenter can instantiate a VM Template in any of the hosts beloning to the same cluster as the original one. 

OpenNebula uses several assumptions to instantitate a VM Template in an automatic way:

- **diskMoveType**: OpenNebul instructs vCenter to "move only the child-most disk backing. Any parent disk backings should be left in their current locations.". More information `here <https://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.DiskMoveOptions.html>`__

- Target **resource pool**: OpenNebula uses the default cluster resource pool to place the VM instantiated from the VM template
