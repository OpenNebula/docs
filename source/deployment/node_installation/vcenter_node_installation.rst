.. _vcenter_node:

================================================================================
vCenter Node Installation
================================================================================

This Section lays out the requirements configuration needed in the vCenter and ESX instances in order to be managed by OpenNebula.

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor, i.e. as an OpenNebula Host. This means that the representation is one OpenNebula Host per ESX Cluster.

Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level, vCenter then uses the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine, although the datastore can be explicitly selected from OpenNebula.

Requirements
================================================================================

The following must be met for a functional vCenter environment:

* vCenter 5.5 and/or 6.0, with at least one cluster aggregating at least one ESX 5.5 and/or 6.0 host.
* VMware tools are needed in the guestOS to enable several features (contextualization and networking feedback). Please install `VMware Tools (for Windows) <https://www.vmware.com/support/ws55/doc/new_guest_tools_ws.html>`__ or `Open Virtual Machine Tools <http://open-vm-tools.sourceforge.net/>`__ (for \*nix) in the guestOS.
* Define a vCenter user for OpenNebula. This vCenter user (let's call her ``oneadmin``) needs to have access to the ESX clusters that OpenNebula will manage. In order to avoid problems, the hassle free approach is to **declare this oneadmin user as Administrator**.
* Alternatively, in some enterprise environments declaring the user as Administrator is not allowed, in that case, you will need to grant these permissions (please note that the following permissions related to operations are related to the use that OpenNebula does with this operations):

+------------------------+---------------------------------------------+---------------------------------------------------+
|   vCenter Operation    |                  Privileges                 |                       Notes                       |
+------------------------+---------------------------------------------+---------------------------------------------------+
| CloneVM_Task           | VirtualMachine.Provisioning.DeployTemplate  | Creates a clone of a particular VM                |
+------------------------+---------------------------------------------+---------------------------------------------------+
| ReconfigVM_Task        | VirtualMachine.Interact.DeviceConnection    | Reconfigures a particular virtual machine.        |
|                        | VirtualMachine.Interact.SetCDMedia          |                                                   |
|                        | VirtualMachine.Interact.SetFloppyMedia      |                                                   |
|                        | VirtualMachine.Config.Rename                |                                                   |
|                        | VirtualMachine.Config.Annotation            |                                                   |
|                        | VirtualMachine.Config.AddExistingDisk       |                                                   |
|                        | VirtualMachine.Config.AddNewDisk            |                                                   |
|                        | VirtualMachine.Config.RemoveDisk            |                                                   |
|                        | VirtualMachine.Config.CPUCount              |                                                   |
|                        | VirtualMachine.Config.Memory                |                                                   |
|                        | VirtualMachine.Config.RawDevice             |                                                   |
|                        | VirtualMachine.Config.AddRemoveDevice       |                                                   |
|                        | VirtualMachine.Config.Settings              |                                                   |
|                        | VirtualMachine.Config.AdvancedConfig        |                                                   |
|                        | VirtualMachine.Config.SwapPlacement         |                                                   |
|                        | VirtualMachine.Config.HostUSBDevice         |                                                   |
|                        | VirtualMachine.Config.DiskExtend            |                                                   |
|                        | VirtualMachine.Config.ChangeTracking        |                                                   |
|                        | VirtualMachine.Provisioning.ReadCustSpecs   |                                                   |
|                        | VirtualMachine.Inventory.CreateFromExisting |                                                   |
|                        | VirtualMachine.Inventory.CreateNew          |                                                   |
|                        | VirtualMachine.Inventory.Move               |                                                   |
|                        | VirtualMachine.Inventory.Register           |                                                   |
|                        | VirtualMachine.Inventory.Remove             |                                                   |
|                        | VirtualMachine.Inventory.Unregister         |                                                   |
|                        | DVSwitch.CanUse                             |                                                   |
|                        | DVPortgroup.CanUse                          |                                                   |
|                        | Datastore.AllocateSpace                     |                                                   |
|                        | Datastore.BrowseDatastore                   |                                                   |
|                        | Datastore.LowLevelFileOperations            |                                                   |
|                        | Datastore.RemoveFile                        |                                                   |
|                        | Network.Assign                              |                                                   |
|                        | Resource.AssignVirtualMachineToResourcePool |                                                   |
+------------------------+---------------------------------------------+---------------------------------------------------+
| PowerOnVM_Task         | VirtualMachine.Interact.PowerOn             | Powers on a virtual machine                       |
+------------------------+---------------------------------------------+---------------------------------------------------+
| PowerOffVM_Task        | VirtualMachine.Interact.PowerOff            | Powers off a virtual machine                      |
+------------------------+---------------------------------------------+---------------------------------------------------+
| Destroy_Task           | VirtualMachine.Inventory.Delete             | Deletes a VM (including disks)                    |
+------------------------+---------------------------------------------+---------------------------------------------------+
| SuspendVM_Task         | VirtualMachine.Interact.Suspend             | Suspends a VM                                     |
+------------------------+---------------------------------------------+---------------------------------------------------+
| RebootGuest            | VirtualMachine.Interact.Reset               | Reboots VM's guest Operating System               |
+------------------------+---------------------------------------------+---------------------------------------------------+
| ResetVM_Task           | VirtualMachine.Interact.Reset               | Resets power on a virtual machine                 |
+------------------------+---------------------------------------------+---------------------------------------------------+
| ShutdownGuest          | VirtualMachine.Interact.PowerOff            | Shutdown guest Operating System                   |
+------------------------+---------------------------------------------+---------------------------------------------------+
| CreateSnapshot_Task    | VirtualMachine.State.CreateSnapshot         | Creates a new snapshot of a virtual machine.      |
+------------------------+---------------------------------------------+---------------------------------------------------+
| RemoveSnapshot_Task    | VirtualMachine.State.RemoveSnapshot         | Removes a snapshot form a virtual machine         |
+------------------------+---------------------------------------------+---------------------------------------------------+
| RevertToSnapshot_Task  | VirtualMachine.State.RevertToSnapshot       | Revert a virtual machine to a particular snapshot |
+------------------------+---------------------------------------------+---------------------------------------------------+
| CreateVirtualDisk_Task | Datastore.FileManagement                    | On all VMFS datastores represented by OpenNebula  |
+------------------------+---------------------------------------------+---------------------------------------------------+
| CopyVirtualDisk_Task   | Datastore.FileManagement                    | On all VMFS datastores represented by OpenNebula  |
+------------------------+---------------------------------------------+---------------------------------------------------+
| DeleteVirtualDisk_Task | Datastore.FileManagement                    | On all VMFS datastores represented by OpenNebula  |
+------------------------+---------------------------------------------+---------------------------------------------------+

.. note:: For security reasons, you may define different users to access different ESX Clusters. A different user can be defined in OpenNebula per ESX cluster, which is encapsulated in OpenNebula as an OpenNebula host.

* All ESX hosts belonging to the same ESX cluster to be exposed to OpenNebula **must** share at least one datastore among them.
* The ESX cluster **should** have DRS enabled. DRS is not required but it is recommended. OpenNebula does not schedule to the granularity of ESX hosts, DRS is needed to select the actual ESX host within the cluster, otherwise the VM will be launched in the ESX where the VM template has been created.
* **Save as VM Templates those VMs that will be instantiated through the OpenNebula provisioning portal**
* To enable VNC functionality, repeat the following procedure for each ESX:

  * In the vSphere client proceed to Home -> Inventory -> Hosts and Clusters
  * Select the ESX host, Configuration tab and select Security Profile in the Software category
  * In the Firewall section, select Edit. Enable GDB Server, then click OK
  * Make sure that the ESX hosts are reachable from the OpenNebula Front-end

.. important:: OpenNebula will **NOT** modify any vCenter configuration.

Configuration
================================================================================

There are a few simple steps needed to configure OpenNebula so it can interact with vCenter:

Step 1: Check connectivity
--------------------------------------------------------------------------------

The OpenNebula Front-end needs network connectivity to all the vCenters that it is supposed to manage.

Additionally, to enable VNC access to the spawned Virtual Machines, the Front-end also needs network connectivity to all the ESX hosts

Step 2: Enable the drivers in the Front-end (oned.conf)
--------------------------------------------------------------------------------

In order to configure OpenNebula to work with the vCenter drivers, the following sections need to be uncommented or added in the ``/etc/one/oned.conf`` file:

.. code::

    #-------------------------------------------------------------------------------
    #  vCenter Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    IM_MAD = [
        NAME          = "vcenter",
        SUNSTONE_NAME = "VMWare vCenter",
        EXECUTABLE    = "one_im_sh",
        ARGUMENTS     = "-c -t 15 -r 0 vcenter" ]
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    #  vCenter Virtualization Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #    -p more than one action per host in parallel, needs support from hypervisor
    #    -s <shell> to execute commands, bash by default
    #    -d default snapshot strategy. It can be either 'detach' or 'suspend'. It
    #       defaults to 'suspend'.
    #-------------------------------------------------------------------------------
    VM_MAD = [
        NAME          = "vcenter",
        SUNSTONE_NAME = "VMWare vCenter",
        EXECUTABLE    = "one_vmm_sh",
        ARGUMENTS     = "-p -t 15 -r 0 vcenter -s sh",
        default       = "vmm_exec/vmm_exec_vcenter.conf",
        TYPE          = "xml",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, poweroff,
            poweroff-hard, disk-attach, disk-detach, nic-attach, nic-detach,
            snap-create, snap-delete"
    ]
    #-------------------------------------------------------------------------------

OpenNebula needs to be restarted afterwards, this can be done with the following command:

.. prompt:: bash $ auto

    $ sudo service opennebula restart

.. _vcenter_import_tool:

Step 3: Importing vCenter Clusters
--------------------------------------------------------------------------------

OpenNebula ships with a powerful CLI tool to import vCenter clusters, VM Templates, Networks and running VMs. The tools is self-explanatory, just set the credentials and FQDN/IP to access the vCenter host and follow on screen instructions. A sample section follows:

.. prompt:: bash $ auto

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

Once the vCenter cluster is monitored, OpenNebula will display any existing VM as Wild. These VMs can be :ref:`imported <import_vcenter_resources>` and managed through OpenNebula.

.. note::

   OpenNebula will create a special key at boot time and save it in ``/var/lib/one/.one/one_key``. This key will be used as a private key to encrypt and decrypt all the passwords for all the vCenters that OpenNebula can access. Thus, the password shown in the OpenNebula host representing the vCenter is the original password encrypted with this special key.

.. _vcenter_suffix_note:

.. note::

   OpenNebula will add by default a ``one-<vid>-`` prefix to the name of the vCenter VMs it spawns, where ``<vid>`` is the id of the VM in OpenNebula. This value can be changed using a special attribute set in the vCenter cluster representation in OpenNebula, ie, the OpenNebula host. This attribute is called ``VM_PREFIX`` (which can be set in the OpenNebula host template), and will evaluate one variable, ``$i``, to the id of the VM. A value of ``one-$i-`` in that parameter would have the same behavior as the default.

After this guide, you may want to :ref:`verify your installation <verify_installation>` or learn how to setup the :ref:`vmware-based cloud infrastructure <vmware_infrastructure_setup_overview>`.

Step 4: Next Steps
--------------------------------------------------------------------------------

Jump to the :ref:`Verify your Installation <verify_installation>` section in order to get to launch a test VM.
