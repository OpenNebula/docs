.. _vcenter_ds:

================================================================================
vCenter Datastores
================================================================================

vCenter datastores hosts VMDK files and other file types so VMs and templates can use them, and these datastores can be represented in OpenNebula as both an Images datastore and a System datastore:

* Images Datastore. Stores the images repository. VMDK files are represented as OpenNebula images stored in this datastore.
* System Datastore. Holds disk for running virtual machines, copied or cloned from the Images Datastore.

For example, if we have a vcenter datastore called nfs, when we import the vCenter datastore into OpenNebula, two OpenNebula datastores will be created as an Images datastore and as a System datastore pointing to the same vCenter datastores:

.. image:: /images/vcenter_datastore_import_cli.png
    :width: 50%
    :align: center

.. image:: /images/vcenter_datastore_as_image_and_system.png
    :width: 70%
    :align: center

Images and disks
--------------------------------------------------------------------------------

When the vCenter hypervisor is used we have three OpenNebula image types:

* OS: A bootable disk Image. Every VM template must define one DISK referring to an Image of this type.
* CDROM: These Images are read-only data.
* DATABLOCK: A datablock Image is a storage for data. These Images can be created from previous existing data (e.g uploading a VMDK file), or as an empty drive.

OpenNebula images can be also classified in **persistent** and **non-persistent** images:

* Non-persistent images. These images are used by at least one VM. It can still be used by other VMs. When a new VM using a non-persistent image is deployed a copy of the VMDK file is created.
* Persistent images. A persistent image can be use only by a VM. It cannot be used by new VMs. The original file is used, no copies are created.

Disks attached to a VM will be backed by a non-persistent or persistent image although volatile disks are also supported. Volatile disks are created on-the-fly on the target hosts and they are disposed when the VM is shutdown.


The vCenter Transfer Manager
--------------------------------------------------------------------------------

OpenNebula’s vCenter Transfer Manager driver deals with disk images in the following way:

* New disk images created by OpenNebula are placed in an Images datastore. They can be created as persistent or non-persistent images.
* Persistent images are used by vCenter VMs from the datastore where the persistent images were created.
* Non-persistent images are copied from the Images datastore where they were created to a System datastore chosen by OpenNebula’s scheduler.
* Volatile images are created in a System datastore chosen by the scheduler and deleted from that datastore once it’s no longer needed (e.g disk detach or VM’s terminate action).
* Creation of empty datablocks and VMDK image cloning are supported, as well as image deletion.

The scheduler chooses the datastore according to the configuration in the /etc/one/sched.conf as explained in the Operation’s guide:

* By default it tries to optimize storage usage by selecting the datastore with less free space.
* It can optimize I/O by distributing the VMs across available datastores.

The vCenter datastore in OpenNebula is tied to a vCenter instance in the sense that all operations to be performed in the datastore are going to be performed through the vCenter instance and credentials stored in the datastore's template.

vCenter datastores can be represented in OpenNebula to achieve the following VM operations:
  - Choose a different datastore for VM deployment
  - Clone VMDKs images
  - Create empty datablocks
  - Delete VMDK images

.. important:: Note that if you change the vCenter credentials (e.g password change) you will have to update the OpenNebula datastore's template and provide the new credentials so OpenNebula can continue performing vCenter operations.

OpenNebula Clusters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A :ref:`Cluster<cluster_guide>` is a group of Hosts and clusters can have associated Datastores and Virtual Networks. When a vCenter cluster is imported, the import tool assigns automatically a cluster to the OpenNebula host representing the vCenter cluster.

.. important:: When a vCenter datastore is imported into OpenNebula, OpenNebula tries to add the datastores to an existing OpenNebula cluster. If you haven't previously imported a vCenter cluster that uses that datastore, the automatic assignment won't have found a suitable OpenNebula cluster and hence the scheduler won't know which are the right datastores that can be used when a VM is deployed. In this case you should add the datastores to the cluster where the OpenNebula host (representing the vCenter Cluster) is found as explained in the :ref:`Add Resources to Clusters<cluster_guide>` section.


File location used by the Transfer Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

VMDK files or ISO files are placed and named into a vcenter datastore, according to these rules:

* Persistent images. These images are placed following this pattern: IMAGE_DIR/IMAGE_ID/one-IMAGE_ID.vmdk, e.g: one/258/one-258.vmdk. IMAGE_DIR is by default the directory **one** but a different directory can be used thanks to the VCENTER_DS_IMAGE_DIR attribute.
* Non-persistent images. These images are placed following this pattern: IMAGE_DIR/IMAGE_ID/one-IMAGE_ID.vmdk, e.g: one/259/one-259.vmdk. IMAGE_DIR is by default the directory **one** but a different directory can be used thanks to the VCENTER_DS_IMAGE_DIR attribute.
* Non-persistent images used by a Virtual Machine. The copy of a non-persistent image follows this pattern: IMAGE_DIR/IMAGE_ID/one-VMID-IMAGE_ID-DISK_NUMBER.vmdk where VMID is replaced with the VM numeric identifier, IMAGE_ID would be the identifier of the original image and DISK_NUMBER is replaced with the position of the disk inside the VM.
* Volatile disks attached to a VM. These images are placed following this pattern: VOLATILE_DIR/one-VMID-DISK_NUMBER.vmdk, e.g one-volatile/285/one-285-2.vmdk. VOLATILE_DIR is by default the one-volatile directory but a different directory can be used thanks to the VCENTER_DS_VOLATILE_DIR attribute.


In the following example we can see that the file associated to the Image with OpenNebula's ID 8 contains the VMDK file using the placement logic explained above.

.. image:: /images/vcenter_datastore_one_folder.png
    :width: 70%
    :align: center


Limitations
--------------------------------------------------------------------------------

* No support for disk snapshots in the vCenter datastore.
* Image names and paths cannot contain spaces.


Requirements
--------------------------------------------------------------------------------

In order to use the vCenter datastore, the following requirements need to be met:

* All the ESX servers controlled by vCenter need to mount the same VMFS datastore with the same name.
* The ESX servers need to be part of the Cluster controlled by OpenNebula


Configuration
--------------------------------------------------------------------------------

In order to create a OpenNebula vCenter datastore that represents a vCenter VMFS datastore, a new OpenNebula datastore needs to be created with the following attributes. The :ref:`import tools <vcenter_import_datastores>`creates a datastore representation with the required attributes.

+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Attribute              |                                                                                                                                                                                                                                                                                                     Description                                                                                                                                                                                                                                                                                                      |
+=============================+======================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``DS_MAD``                  | Must be set to ``vcenter`` if TYPE is SYSTEM_DS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``                  | Must be set ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TYPE``                    | Must be set to ``SYSTEM_DS`` ot ``IMAGE_DS``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_ADAPTER_TYPE``    | Default adapter type used by virtual disks to plug inherited to VMs for the images in the datastore. It is inherited by images and can be overwritten if specified explicitly in the image. Possible values (careful with the case): lsiLogic, ide, busLogic. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.wssdk.apiref.doc/vim.VirtualDiskManager.VirtualDiskAdapterType.html>`__. Known as "Bus adapter controller" in Sunstone.                                                                                                                          |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_DISK_TYPE``       | Type of disk to be created when a DATABLOCK is requested. This value is inherited from the datastore to the image but can be explicitly overwritten. The type of disk has implications on performance and occupied space. Values (careful with the case): delta,eagerZeroedThick,flatMonolithic,preallocated,raw,rdm,rdmp,seSparse,sparse2Gb,sparseMonolithic,thick,thick2Gb,thin. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html>`__. Known as "Disk Provisioning Type" in Sunstone. |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_DS_REF``          | Managed Object Reference of the vCenter datastore. Please visit the :ref:`Managed Object Reference <vcenter_managed_object_reference>`section to know more about these references.                                                                                                                                                                                                                                                                                                                                                                                                                                   |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_DC_REF``          | Managed Object Reference of the vCenter datacenter. Please visit the :ref:`Managed Object Reference <vcenter_managed_object_reference>`section to know more about these references.                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_INSTANCE_ID``     | The vCenter instance ID. Please visit the :ref:`Managed Object Reference <vcenter_managed_object_reference>`section to know more about these references.                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_HOST``            | Hostname or IP of the vCenter host                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_USER``            | Name of the vCenter user.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_PASSWORD``        | Password of the vCenter user. It's encrypted when the datastore template is updated using the secret stored in the ``/var/lib/one/.one/one_key`` an                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_DS_IMAGE_DIR``    | (Optional) Specifies what folder under the root directory of the datastore will host persistent and non-persistent images e.g one                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_DS_VOLATILE_DIR`` | (Optional) Specifies what folder under the root directory of the datastore will host the volatile disks                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

All OpenNebula datastores are actively monitoring, and the scheduler will refuse to deploy a VM onto a vCenter datastore with insufficient free space.


Datastore clusters with Storage DRS
================================================================================

Thanks to OpenNebula’s scheduler, you can manage your datastores clusters with load distribution but you may already be using `vCenter’s Storage DRS <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.vsphere.hostclient.doc%2FGUID-598DF695-107E-406B-9C95-0AF961FC227A.html>`__ capabilities. Storage DRS allows you to manage the aggregated resources of a datastore cluster. If you're using Storage DRS, OpenNebula can delegate the decision of selecting a datastore to the Storage DRS cluster (SDRS) but as this behavior interferes with OpenNebula’s scheduler and vSphere’s API impose some restrictions, there will be some limitations in StorageDRS support in OpenNebula.

When you import a SDRS cluster using onevcenter or Sunstone:

* The cluster will be imported as a SYSTEM datastore only. vSphere’s API does not provide a way to upload or create files directly into the SDRS cluster so it can’t be used as an IMAGE datastore.
* OpenNebula detects the datastores grouped by the SDRS cluster so you can still import those datastores as both IMAGE and SYSTEM datastores.
* Non-persistent images are not supported by a SDRS as vSphere’s API does not provide a way to create, copy or delete files to a SDRS cluster as a whole, however you can use persistent and volatile images with the VMs backed by your SDRS.
* Linked clones are not supported by OpenNebula, so when a VM clone is created a full clone is performed.

In order to delegate the datastore selection to the SDRS cluster you must inform OpenNebula's scheduler that you want to use specifically the SYSTEM datastore representing the storage cluster. You can edit a VM template and add the following expression: ID=DATASTORE_ID to the attribute SCHED_DS_REQUIREMENTS, where DATASTORE_ID must be replaced with the numeric id assigned by OpenNebula to the datastore. Thanks to this attribute OpenNebula will always use this datastore when deploying a VM.

.. image:: /images/vcenter_datastore_storage_drs
    :width: 70%
    :align: center

Tuning and Extending
================================================================================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage subsystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/vcenter
-  /var/lib/one/remotes/tm/vcenter
