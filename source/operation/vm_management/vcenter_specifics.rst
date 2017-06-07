.. _vcenter_specifics:

================================================================================
vCenter Specifics
================================================================================

vCenter VM and VM Templates
================================================================================

To learn how to use VMs and VM Templates you can read the :ref:`Managing Virtual Machines Instances <vm_guide_2>` and :ref:`Managing Virtual Machine Templates <vm_guide>`, but first take into account the following considerations.

.. _vm_template_definition_vcenter:

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
| GRAPHICS           | Multi-value - Only VNC supported, check the :ref:`VM template reference <io_devices_section>`.                                                                                                                                                                                                                                               |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| PUBLIC_CLOUD       | Multi-value. TYPE must be set to vcenter, and VM_TEMPLATE must point to the uuid of the vCenter VM that is being represented                                                                                                                                                                                                                 |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SCHED_REQUIREMENTS | NAME="name of the vCenter cluster where this VM Template can instantiated into a VM". See :ref:`VM Scheduling section <vm_scheduling_vcenter>` for more details.                                                                                                                                                                             |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| CONTEXT            | All :ref:`sections <template_context>` will be honored except FILES. You can find more information about contextualization in the :ref:`vcenter Contextualization <vcenter_contextualization>` section.                                                                                                                                      |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| KEEP_DISKS_ON_DONE | (Optional) Prevent OpenNebula from erasing the VM disks upon reaching the done state (either via shutdown or cancel)                                                                                                                                                                                                                         |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| VCENTER_DATASTORE  | By default, the VM will be deployed to the datastore where the VM Template is bound to. This attribute allows to set the name of the datastore where this VM will be deployed. This can be overwritten explicitly at deployment time from the CLI or Sunstone. More information in the :ref:`vCenter Datastore Setup Section <vcenter_ds>`   |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| RESOURCE_POOL      | By default, the VM will be deployed to the default resource pool. If this attribute is set, its value will be used to confine this the VM in the referred resource pool. Check :ref:`this section <vcenter_resource_pool>` for more information.                                                                                             |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| DEPLOY_FOLDER      | (Optional) If you use folders to group your objects like VMs and you want a VM to be placed inside an specific folder, you can specify a Deployment Folder where the VM will be created. The Deployment Folder is a path which uses slashes to separate folders. More info in the :ref:`VM cloning Section <vcenter_cloning_procedure>`      |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

After a VM Template is instantiated, the life-cycle of the resulting virtual machine (including creation of snapshots) can be controlled through OpenNebula. Also, all the operations available in the :ref:`vCenter Admin view <vcenter_view>` can be performed, including:

- network management operations like the ability to attach/detach network interfaces
- capacity (CPU and MEMORY) resizing
- VNC connectivity
- Attach/detach VMDK images as disks

The following operations are not available for vCenter VMs:

- migrate
- livemigrate

The monitoring attributes retrieved from a vCenter VM are:

- ESX_HOST
- GUEST_IP
- GUEST_STATE
- VMWARETOOLS_RUNNING_STATUS
- VMWARETOOLS_VERSION
- VMWARETOOLS_VERSION_STATUS

.. _vcenter_cloning_procedure:

VM Template Cloning Procedure
--------------------------------------------------------------------------------

OpenNebula uses VMware cloning VM Template procedure to instantiate new Virtual Machines through vCenter. From the VMware documentation:

  Deploying a virtual machine from a template creates a virtual machine that is a copy of the template. The new virtual machine has the virtual hardware, installed software, and other properties that are configured for the template.

A VM Template is tied to the host where the VM was running, and also the datastore(s) where the VM disks where placed. By default, the VM will be deployed in that datastore where the VM Template is bound to, although another datastore can be selected at deployment time. Due to shared datastores, vCenter can instantiate a VM Template in any of the hosts belonging to the same cluster as the original one.

OpenNebula uses several assumptions to instantiate a VM Template in an automatic way:

- **diskMoveType**: OpenNebuls instructs vCenter to "move only the child-most disk backing. Any parent disk backings should be left in their current locations.". More information `here <https://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.DiskMoveOptions.html>`__

- Target **resource pool**: OpenNebula uses the default cluster resource pool to place the VM instantiated from the VM template, unless VCENTER_RESOURCE_POOL variable defined in the OpenNebula host template, or the tag RESOURCE_POOL is present in the VM Template inside the PUBLIC_CLOUD section.

When the VM is cloned from the VM template, you can found that VM in vSphere's Web Client, in the same location where the vCenter template is located. For instance, using the corelinux64 vcenter template I can find the OpenNebula's VM with the one- prefix in the same folder where my template lives.

.. image:: /images/vcenter_template_in_same_location_than_vm.png
    :width: 45%
    :align: center

Starting with OpenNebula 5.4, if you use folders to group your objects like VMs and you want a VM to be placed inside an specific folder, you can now specify a Deployment Folder where the VM will be created. The Deployment Folder is a path which uses slashes to separate folders. For instance, if we have the following tree and you want a VM to be placed inside the Devel folder, your path would be /Management/OpenNebula Systems/Devel.

.. image:: /images/vcenter_deploy_folder_sample_path_tree.png
    :width: 45%
    :align: center

The Deployment Folder is specified using the DEPLOY_FOLDER attribute. This attribute is a **Restricted attribute** which means that only users that are members of the oneadmin group can create or modify that attribute unless the VM_RESTRICTED_ATTR = "DEPLOY_FOLDER" row is deleted from the /etc/one/oned.conf file (the OpenNebula service must be restarted to apply changes to that file).

You can set the DEPLOY_FOLDER attribute in OpenNebula's template:

- If using the command line, placing it inside a file to be used with onetemplate.
- In Sunstone, using the Deployment Folder input in the General tab when Updating a Template if using the admin_vcenter view.

.. image:: /images/vcenter_deploy_folder_update_template.png
    :width: 75%
    :align: center

Also you can specify a different deployment folder which will override the DEPLOY_FOLDER element set in the template (if any) when instantiating or creating a VM:


- In OpenNebula's CLI, using the --deploy_folder path option with the onetemplate instantiate command.

.. image:: /images/vcenter_deploy_folder_cli_instantiate.png
    :width: 75%
    :align: center

- In Sunstone, in the admin_vcenter view

.. image:: /images/vcenter_deploy_folder_instantiate.png
    :width: 75%
    :align: center

In Sunstone, you can enable the Deployment Folder input for the admin, groupadmin, groupadmin_vcenter or user views, if the vcenter_deploy_folder feature is set to true in the YAML configuration file for each view under /etc/one/sunstone-views/.

.. _vcenter_instantiate_to_persistent:

Saving a VM Template: Instantiate to Persistent
--------------------------------------------------------------------------------

At the time of deploying a VM Template, a flag can be used to create a new VM Template out of the VM.

.. prompt:: bash $ auto

  $ onetemplate instantiate <tid> --persistent

Whenever the VM life-cycle ends, OpenNebula will instruct vCenter to create a new vCenter VM Template out of the VM, with the settings of the VM including any new disks or network interfaces added through OpenNebula. Any new disk added to the VM will be saved as part of the template, and when a new VM is spawned from this new VM Template the disk will be cloned by OpenNebula (ie, it will no longer be persistent).

A new OpenNebula VM Template will also be created pointing to this new VM Template, so it can be instantiated through OpenNebula. This new OpenNebula VM Template will be pointing to the original template until the VM is shutdown, at which point it will be converted to a vCenter VM Template and the OpenNebual VM Template updated to point to this new vCentre VM Template.

This functionality is very useful to create new VM Templates from a original VM Template, changing the VM configuration and/or installing new software, to create a complete VM Template catalog.

.. _vm_scheduling_vcenter:

VM Scheduling
--------------------------------------------------------------------------------

OpenNebula scheduler should only chose a particular OpenNebula host for a OpenNebula VM Template representing a vCenter VM Template, since it most likely only would be available in a particular vCenter cluster.

Since a vCenter cluster is an aggregation of ESX hosts, the ultimate placement of the VM on a particular ESX host would be managed by vCenter, in particular by the `Distribute Resource Scheduler (DRS) <https://www.vmware.com/es/products/vsphere/features/drs-dpm>`__.

In order to enforce this compulsory match between a vCenter cluster and a OpenNebula/vCenter VM Template, add the following to the OpenNebula VM Template:

.. code::

    SCHED_REQUIREMENTS = "NAME=\"name of the vCenter cluster where this VM Template can instantiated into a VM\""

In Sunstone, a host abstracting a vCenter cluster will have an extra tab showing the ESX hosts that conform the cluster.

.. image:: /images/host_esx.png
    :width: 90%
    :align: center


vCenter Images
================================================================================

You can follow the :ref:`Managing Images Section <img_guide>` to learn how to manage images, considering that all images in vCenter are persistent and that VMDK snapshots are not supported as well as the following considerations.

vCenter VMDK images managed by OpenNebula are always persistent, ie, OpenNebula won't copy them for new VMs, but rather the originals will be used. This means that only one VM can use one image at the same time.

vCenter VM Templates with already defined disks will be imported without this information in OpenNebula. These disks will be invisible for OpenNebula, and therefore cannot be detached from the VMs. The imported Templates in OpenNebula can be updated to add new disks from VMDK images imported from vCenter (please note that these will always be persistent).

There are three ways of adding VMDK representations in OpenNebula:

- Upload a new VMDK from the local filesystem
- Register an existent VMDK image already in the datastore
- Create a new empty datablock

The following image template attributes need to be considered for vCenter VMDK image representation in OpenNebula:

+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute     |                                                                                                                                                                                                    Description                                                                                                                                                                                                     |
+==================+====================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``PERSISTENT``   | Must be set to 'YES'                                                                                                                                                                                                                                                                                                                                                                                               |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PATH``         | This can be either:                                                                                                                                                                                                                                                                                                                                                                                                |
|                  |                                                                                                                                                                                                                                                                                                                                                                                                                    |
|                  | * local filesystem path to a VMDK to be uploaded, which can be a single VMDK or tar.gz of vmdk descriptor and flat files (no OVAs supported). If using a tar.gz file which contains the flat and descriptor files, both files must live in the first level of the archived file as folders and subfolders are not supported inside the tar.gz file, otherwise a "Could not find vmdk" error message would show up. |
|                  | * path of an existing VMDK file in the vCenter datastore. In this case a ''vcenter://'' prefix must be used (for instance, an image win10.vmdk in a Windows folder should be set to vcenter://Windows/win10.vmdk)                                                                                                                                                                                                  |
|                  |                                                                                                                                                                                                                                                                                                                                                                                                                    |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ADAPTER_TYPE`` | Possible values (careful with the case): lsiLogic, ide, busLogic.                                                                                                                                                                                                                                                                                                                                                  |
|                  | More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.wssdk.apiref.doc/vim.VirtualDiskManager.VirtualDiskAdapterType.html>`__. Known as "Bus adapter controller" in Sunstone.                                                                                                                                                                                      |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``    | The type of disk has implications on performance and occupied space. Values (careful with the case): delta,eagerZeroedThick,flatMonolithic,preallocated,raw,rdm,rdmp,seSparse,sparse2Gb,sparseMonolithic,thick,thick2Gb,thin. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html>`__    |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

VMDK images in vCenter datastores can be:

- Cloned
- Deleted
- Hotplugged to VMs

Images can be imported from the vCenter datastore using the **onevcenter** tool:

.. prompt:: text $ auto

    $ onevcenter images datastore1 --vcenter <vcenter-host> --vuser <vcenter-username> --vpass <vcenter-password>

    Connecting to vCenter: vcenter.vcenter3...done!

    Looking for Images...done!

      * Image found:
          - Name      : win-test-context-fixed2 - datastore1
          - Path      : win-test-context-fixed2/win-test-context-fixed2.vmdk
          - Type      : VmDiskFileInfo
        Import this Image [y/n]? n

      * Image found:
          - Name      : windows-2008R2 - datastore1
          - Path      : windows/windows-2008R2.vmdk
          - Type      : VmDiskFileInfo
        Import this Image [y/n]? y
        OpenNebula image 0 created!

.. warning: Both "ADAPTER_TYPE" and "DISK_TYPE" need to be set at either the Datastore level, the Image level or the VM Disk level. Otherwise image related operations may fail.

.. warning: Images spaces are not allowed for import

.. note: By default, OpenNebula checks the datastore capacity to see if the image fits. This may cause a "Not enough space in datastore" error. To avoid this error, disable the datastore capacity check before importing images. This can be changes in /etc/one/oned.conf, using the DATASTORE_CAPACITY_CHECK set to "no".
