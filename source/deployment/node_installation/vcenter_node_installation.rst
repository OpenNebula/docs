.. _vcenter_node:

================================================================================
vCenter Node Installation
================================================================================

This Section lays out the requirements configuration needed in the vCenter and ESX instances in order to be managed by OpenNebula.

The VMware vCenter drivers enable OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is presented in OpenNebula as an aggregated hypervisor, i.e. as an OpenNebula Host. This means that the representation is one OpenNebula Host per ESX Cluster.

Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level, vCenter then uses the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine.

Requirements
================================================================================

The following must be met for a functional vCenter environment:

* vCenter 5.5, 6.0 and/or 6.5, with at least one cluster aggregating at least one ESX 5.5, 6.0 and/or 6.5 host.
* Define a vCenter user for OpenNebula. This vCenter user (let's call her ``oneadmin``) needs to have access to the ESX clusters that OpenNebula will manage. In order to avoid problems, the hassle free approach is to **declare this oneadmin user as Administrator**. Alternatively, in some enterprise environments declaring the user as Administrator is not allowed, in that case, you will need to grant permissions to perform some tasks. A table with the permissions requires is found at the end of this chapter.
* All ESX hosts belonging to the same ESX cluster to be exposed to OpenNebula **must** share at least one datastore among them.
* The ESX cluster **should** have DRS enabled. DRS is not required but it is recommended. OpenNebula does not schedule to the granularity of ESX hosts, DRS is needed to select the actual ESX host within the cluster, otherwise the VM will be launched in the ESX where the VM template has been created.
* If virtual standard switches are used, check that those switches exist in every ESX hosts belonging to the same ESX cluster, so the network represented by a port group can be used by a VM, no matter in what ESX host it's running. If you use distributed virtual switches, check that ESX hosts have been added to switches.
* To enable VNC functionality, repeat the following procedure for each ESX:

  * In the vSphere client proceed to Home -> Inventory -> Hosts and Clusters.
  * Select the ESX host, Configuration tab and select Security Profile in the Software category.
  * In the Firewall section, select Edit. Enable GDB Server, then click OK.
  * Make sure that the ESX hosts are reachable from the OpenNebula Front-end.

  .. image:: ../../images/vcenter_enable_gdb_server.png
      :width: 90%
      :align: center

.. important:: OpenNebula will **NOT** modify any vCenter configuration with some exceptions, the creation of virtual switches and port groups if the vcenter network driver is used and the creation of images for VMDK and/or ISO files.

.. note:: For security reasons, you may define different users to access different ESX Clusters. A different user can be defined in OpenNebula per ESX cluster, which is encapsulated in OpenNebula as an OpenNebula host.

Configuration
================================================================================

There are a few simple steps needed to configure OpenNebula so it can interact with vCenter:

Step 1: Check connectivity
--------------------------------------------------------------------------------

The OpenNebula Front-end needs network connectivity to all the vCenters that it is supposed to manage.

Additionally, to enable VNC access to the spawned Virtual Machines, the Front-end also needs network connectivity to all the ESX hosts

.. warning:: OpenNebula uses port 443 to communicate with vCenter instances. Port 443 is the default port used by vCenter so unless you're filtering that port or you've configured a different port to listen for connections from the vSphere Web Client, OpenNebula will be able to connect with the right credentials.

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

As a Virtualization driver, the vCenter driver accept a series of parameters that control their execution. The parameters allowed are:

+----------------+-------------------------------------------------------------------+
| parameter      | description                                                       |
+================+===================================================================+
| -r <num>       | number of retries when executing an action                        |
+----------------+-------------------------------------------------------------------+
| -t <num        | number of threads, i.e. number of actions done at the same time   |
+----------------+-------------------------------------------------------------------+

See the :ref:`Virtual Machine drivers reference <devel-vmm>` for more information about these parameters, and how to customize and extend the drivers.

OpenNebula needs to be restarted afterwards, this can be done with the following command:

.. prompt:: bash $ auto

    $ sudo systemctl restart opennebula

.. _vcenter_import_host_tool:

Step 3: Importing vCenter Clusters
--------------------------------------------------------------------------------

OpenNebula ships with a powerful CLI tool to import vCenter clusters, VM Templates, Networks and running VMs. The tool **onevcenter** is self-explanatory, just set the credentials and FQDN/IP to access the vCenter host and follow on screen instructions. A sample section follows:

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

Once the vCenter cluster is monitored successfully ON will show as the host status. If ERROR is shown please check connectivity and have a look to the /var/log/one/oned.log file in order to find out the possible cause.

The following variables are added to the OpenNebula hosts representing ESX clusters:

+---------------------+------------------------------------+
|    Operation        |                Note                |
+---------------------+------------------------------------+
| VCENTER_HOST        | hostname or IP of the vCenter host |
+---------------------+------------------------------------+
| VCENTER_USER        | Name of the vCenter user           |
+---------------------+------------------------------------+
| VCENTER_PASSWORD    | Password of the vCenter user       |
+---------------------+------------------------------------+
| VCENTER_VERSION     | The vcenter version detected by    |
|                     | OpenNebula e.g 5.5                 |
+---------------------+------------------------------------+
| VCENTER_CCR_REF     | The Managed Object Reference to    |
|                     | the vCenter cluster                |
+---------------------+------------------------------------+
| VCENTER_INSTANCE_ID | The vCenter instance UUID          |
|                     | identifier                         |
+---------------------+------------------------------------+

.. note::

   OpenNebula will create a special key at boot time and save it in ``/var/lib/one/.one/one_key``. This key will be used as a private key to encrypt and decrypt all the passwords for all the vCenters that OpenNebula can access. Thus, the password shown in the OpenNebula host representing the vCenter is the original password encrypted with this special key.

.. note::

   You have more information about what is a Managed Object Reference and what is the vCenter instance UUID in the TODO ref `vCenter driver<vcenter_managed_object_reference>` section.


Step 4: Next Steps
--------------------------------------------------------------------------------

Jump to the :ref:`Verify your Installation <vcenter_based_cloud_verification>` section in order to launch a VM or learn how to setup the :ref:`VMWare infrastructure <vmware_infrastructure_setup_overview>`.


Permissions requirement
================================================================================

If the user account that is going to be used in vCenter operations is not declared as an Administrator the following table summarizes the privileges required by the tasks performed in vCenter by OpenNebula:

+---------------------------------------------+----------------------------------------------------------------------------+
|                  Privileges                 |                       Notes                                                |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.DeviceConnection    | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.SetCDMedia          | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.SetFloppyMedia      | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.Rename                | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.Annotation            | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.AddExistingDisk       | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.AddNewDisk            | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.RemoveDisk            | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.CPUCount              | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.Memory                | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.RawDevice             | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.AddRemoveDevice       | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.Settings              | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.AdvancedConfig        | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.SwapPlacement         | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.HostUSBDevice         | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.DiskExtend            | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Config.ChangeTracking        | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Provisioning.ReadCustSpecs   | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.CreateFromExisting | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.CreateNew          | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Move               | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Register           | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Remove             | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Unregister         | Required by a virtual machine reconfigure action                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Delete             | Required to delete a virtual machine                                       |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Provisioning.DeployTemplate  | Required to deploy a virtual machine from a particular template            |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Provisioning.CloneTemplate   | Required to create a copy of a particular template                         |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.PowerOn             | Required to power on a virtual machine                                     |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.PowerOff            | Required to power off or shutdown a virtual machine                        |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.Suspend             | Required to suspend a virtual machine                                      |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Interact.Reset               | Required to reset/reboot a VM's guest Operating System                     |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.Inventory.Delete             | Required to delete a virtual machine or template                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.State.CreateSnapshot         | Required to create a new snapshot of a virtual machine.                    |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.State.RemoveSnapshot         | Required to remove snapshots from a virtual machine                        |
+---------------------------------------------+----------------------------------------------------------------------------+
| VirtualMachine.State.RevertToSnapshot       | Required to revert a virtual machine to a particular snapshot              |
+---------------------------------------------+----------------------------------------------------------------------------+
| Resource.AssignVirtualMachineToResourcePool | Required to assign a resource pool to a virtual machine                    |
+---------------------------------------------+----------------------------------------------------------------------------+
| Resource.ApplyRecommendation                | On all Storage Pods (Storage DRS cluster) represented by OpenNebula        |
+---------------------------------------------+----------------------------------------------------------------------------+
| Datastore.AllocateSpace                     | On all VMFS datastores represented by OpenNebula                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| Datastore.LowLevelFileOperations            | On all VMFS datastores represented by OpenNebula                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| Datastore.RemoveFile                        | On all VMFS datastores represented by OpenNebula                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| Datastore.Browse                            | On all VMFS datastores represented by OpenNebula                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| Datastore.FileManagement                    | On all VMFS datastores represented by OpenNebula                           |
+---------------------------------------------+----------------------------------------------------------------------------+
| Network.Assign                              | Required on any network the Virtual Machine will be connected to           |
+---------------------------------------------+----------------------------------------------------------------------------+
| System.Read                                 | Required to rename Uplink port group for a distributed switch only if you  |
|                                             | want OpenNebula to create distributed virtual switches.                    |
+---------------------------------------------+----------------------------------------------------------------------------+
| Host.Config.Network                         | Required an all **ESX hosts** where you want OpenNebula to create, update  |
|                                             | or delete virtual switches and port groups                                 |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.CanUse                             | Required to connect a VirtualEthernetAdapter to a distributed virtual      |
|                                             | switch either it was created in vSphere or created by OpenNebula           |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.Create                             | Required if you want OpenNebula to create distributed virtual switches     |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.HostOp                             | Required if you want OpenNebula to create distributed virtual switches     |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.PortSetting                        | Required if you want OpenNebula to create distributed virtual switches     |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.Modify                             | Required if you want OpenNebula to create distributed virtual switches     |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.Delete                             | Required if you want OpenNebula to destroy a distributed virtual switches  |
|                                             | that was previously created by OpenNebula.                                 |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVPortgroup.Create                          | Required if you want OpenNebula to create distributed port groups          |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVPortgroup.CanUse                          | Required to connect a VirtualEthernetAdapter to a distributed virtual port |
|                                             | group either it was created in vSphere or created by OpenNebula            |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVSwitch.Modify                             | Required if you want OpenNebula to create distributed port groups          |
+---------------------------------------------+----------------------------------------------------------------------------+
| DVPortgroup.Delete                          | Required if you want OpenNebula to destroy a distributed port group that   |
|                                             | was previously created by OpenNebula.                                      |
+---------------------------------------------+----------------------------------------------------------------------------+
