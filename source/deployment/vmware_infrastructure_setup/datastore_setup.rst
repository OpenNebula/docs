.. _vcenter_ds:

================================================================================
vCenter Datastore
================================================================================

The vCenter datastore allows the representation in OpenNebula of VMDK images available in vCenter datastores. It is a persistent only datastore, meaning that VMDK images are not cloned automatically by OpenNebula when a VM is instantiated. vCenter handles the VMDK image copies, so no system datastore is needed in OpenNebula, and only vCenter image datastores are allowed.

No system datastore is needed since the vCenter support in OpenNebula does not rely on transfer managers to copy VMDK images, but rather this is delegated to vCenter. When a VM Template is instantiated, vCenter performs the VMDK copies, and deletes them after the VM ends its life-cycle. The OpenNebula vCenter datastore is a purely persistent images datastore to allow for VMDK cloning and enable disk attach/detach on running VMs.

The vCenter datastore in OpenNebula is tied to a vCenter OpenNebula host in the sense that all operations to be performed in the datastore are going to be performed through the vCenter instance associated to the OpenNebula host, which happens to hold the needed credentials to access the vCenter instance.

Creation of empty datablocks and VMDK image cloning are supported, as well as image deletion.

Limitations
================================================================================

* No support for snapshots in the vCenter datastore.
* Only one disk is allowed per directory in the vCenter datastores.
* Image names and paths cannot contain spaces.

Requirements
================================================================================

In order to use the vCenter datastore, the following requirements need to be met:

* All the ESX servers controlled by vCenter need to mount the same VMFS datastore with the same name.
* The ESX servers need to be part of the Cluster controlled by OpenNebula

Configuration
================================================================================

In order to create a OpenNebula vCenter datastore that represents a vCenter VMFS datastore, a new OpenNebula datastore needs to be created with the following attributes:

- The OpenNebula vCenter datastore name needs to be exactly the same as the vCenter VMFS datastore available in the ESX hosts.
- The specific attributes for this datastore driver are listed in the following table:

+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Attribute      |                                                                                                                                                                                                                                                                                                     Description                                                                                                                                                                                                                                                                                                      |
+=====================+======================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``DS_MAD``          | Must be set to ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``          | Must be set ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_CLUSTER`` | Name of the OpenNebula host that represents the vCenter cluster that groups the ESX hosts that mount the represented VMFS datastore                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ADAPTER_TYPE``    | Default adapter type used by virtual disks to plug inherited to VMs for the images in the datastore. It is inherited by images and can be overwritten if specified explicitly in the image. Possible values (careful with the case): lsiLogic, ide, busLogic. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.wssdk.apiref.doc/vim.VirtualDiskManager.VirtualDiskAdapterType.html>`__. Known as "Bus adapter controller" in Sunstone.                                                                                                                          |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``       | Type of disk to be created when a DATABLOCK is requested. This value is inherited from the datastore to the image but can be explicitly overwritten. The type of disk has implications on performance and occupied space. Values (careful with the case): delta,eagerZeroedThick,flatMonolithic,preallocated,raw,rdm,rdmp,seSparse,sparse2Gb,sparseMonolithic,thick,thick2Gb,thin. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html>`__. Known as "Disk Provisioning Type" in Sunstone. |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

vCenter datastores can be represented in OpenNebula to achieve the following VM operations:
  - Choose a different datastore for VM deployment
  - Clone VMDKs images 
  - Create empty datablocks
  - Delete VMDK images 

All OpenNebula datastores are actively monitoring, and the scheduler will refuse to deploy a VM onto a vCenter datastore with insufficient free space.

The **onevcenter** tool can be used to import vCenter datastores:

.. prompt:: text $ auto

    $ onevcenter datastores --vuser <VCENTER_USER> --vpass <VCENTER_PASS> --vcenter <VCENTER_FQDN>

    Connecting to vCenter: vcenter.vcenter3...done!

    Looking for Datastores...done!

    Do you want to process datacenter Datacenter [y/n]? y

      * Datastore found:
          - Name      : datastore2
          - Total MB  : 132352
          - Free  MB  : 130605
          - Cluster   : Cluster
        Import this Datastore [y/n]? y
        OpenNebula datastore 100 created!

.. warning: Both "ADAPTER_TYPE" and "DISK_TYPE" need to be set at either the Datastore level, the Image level or the VM Disk level. Otherwise image related operations may fail.

.. _storage_drs_pods:

Storage DRS and datastore cluster
================================================================================

Storage DRS allows you to manage the aggregated resources of a datastore cluster. A StoragePod data object aggregates the storage resources of associated Datastores in a datastore cluster managed by Storage DRS. 

In OpenNebula, a StoragePod can be imported as a datastore using Sunstone or CLI's onevcenter datastore command. The StoragePod will be imported as a SYSTEM datastore so it won't be possible to use it to store images but it will be possible to deploy VMs on it. 

Datastores which are member of the cluster, represented by the StoragePod, can be imported as individual IMAGE datastores where VMs can be deployed and images can be stored. 

Current support has the following limitations:

* Images in StoragePods can't be imported through Sunstone or CLI's onevcenter command though it's possible to import them from a datastore, which is a member of a storage cluster, if it has been imported previously as an individual datastore.

* New images like VMDK files cannot be created or uploaded to the StoragePod as it's set as a SYSTEM datastore. However, it's possible to create an image and upload it to a datastore which is a member of a storage cluster it has been imported previously as an individual datastore.

.. warning:: When a VM is deployed, a cloning operation is involved. The moveAllDisksBackingsAndDisallowSharing move type is used when target datastore is a StoragePod. According to VMWare's documentation all of the virtual disk's backings should be moved to the new datastore. It is not acceptable to attach to a disk backing with the same content ID on the destination datastore. During a clone operation any delta disk backings will be consolidated. The moveChildMostDiskBacking is used for datastores which are not StoragePods in the cloning operation.

.. warning:: If you import a StorageDRS cluster you must edit /etc/one/oned.conf and add vcenter the -s argument list in the DATASTORE_MAD section so the StorageDRS cluster can be monitored as a SYSTEM datastore:

.. prompt:: text $ auto

    DATASTORE_MAD = [
      EXECUTABLE = "one_datastore",
      ARGUMENTS = "-t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter -s shared,ssh,ceph,fs_lvm,qcow2,vcenter" 
    ]

Tuning and Extending
================================================================================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage subsystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/vcenter
-  /var/lib/one/remotes/tm/vcenter
