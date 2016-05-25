.. _vcenter_ds:

================================================================================
vCenter Datastore
================================================================================

The vCenter datastore allows the representation in OpenNebula of VMDK images available in vCenter datastores. It is a persistent only datastore, meaning that VMDK images are not cloned automatically by OpenNebula when a VM is instantiated. vCenter handles the VMDK image copies, so no system datastore is needed in OpenNebula, and only vCenter image datastores are allowed.

No system datastore is needed since the vCenter support in OpenNebula does not rely on transfer managers to copy VMDK images, but rather this is delegated to vCenter. When a VM Template is instantiated, vCenter performs the VMDK copies, and deletes them after the VM ends its lifecycle. The OpenNebula vCenter datastore is a purely persistent images datastore to allow for VMDK cloning and enable disk attach/detach on running VMs.

The vCenter datastore in OpenNebula is tied to a vCenter OpenNebula host in the sense that all operations to be performed in the datastore are going to be performed through the vCenter instance associated to the OpenNebula host, which happens to hold the needed credentials to access the vCenter instance.

Creation of empty datablocks and VMDK image cloning are supported, as well as image deletion.

Limitations
================================================================================

- No VMDK image upload. This means that only VMDK images already existing in the vCenter datastore can be used and/or cloned, but no new images can be added to the datastore from OpenNebula.
- No support for snapshots in the vCenter datastore.

Requirements
================================================================================

-  In order to use the vCenter datastore, all the ESX servers controlled by vCenter need to mount the same VMFS datastore with the same name.

Configuration
================================================================================

In order to create a OpenNebula vCenter datastore that represents a vCenter VMFS datastore, a new OpenNebula datastore needs to be created with the following attributes:

- The OpenNebula vCenter datastore name needs to be exactly the same as the vCenter VMFS datastore available in the ESX hosts.
- The specific attributes for this datastore driver are listed in the following table:

+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Attribute      |                                                                                                                                                                                                                                                                             Description                                                                                                                                                                                                                                                                              |
+=====================+======================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``DS_MAD``          | Must be set to ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``          | Must be set ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_CLUSTER`` | Name of the OpenNebula host that represents the vCenter cluster that groups the ESX hosts that mount the represented VMFS datastore                                                                                                                                                                                                                                                                                                                                                                                                                                  |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ADAPTER_TYPE``    | Default adapter type used by virtual disks to plug inherited to VMs for the images in the datastore. It is inherited by images and can be overwritten if specified explicitly in the image. Possible values (careful with the case): lsiLogic, ide, busLogic. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.wssdk.apiref.doc/vim.VirtualDiskManager.VirtualDiskAdapterType.html>`__                                                                                                                          |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``       | Type of disk to be created when a DATABLOCK is requested. This value is inherited from the datastore to the image but can be explicitly overwritten. The type of disk has implications on performance and occupied space. Values (careful with the case): delta,eagerZeroedThick,flatMonolithic,preallocated,raw,rdm,rdmp,seSparse,sparse2Gb,sparseMonolithic,thick,thick2Gb,thin. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html>`__ |
+---------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. todo:: review

vCenter datastores can be represented in OpenNebula to achieve the following VM operations:

  - Choose a different datastore
  - Clone VMDKs
  - Create empty datablocks
  - Delete VMDKs

.. todo:: import datastores


Image management
================

Existing vCenter images (VMDKs) can be represented. In order to create an image in OpenNebula that represents a vCenter datastore, use the following parameters:

+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute     |                                                                                                                                                                                                   Description                                                                                                                                                                                                   |
+==================+=================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``NAME``         | Arbitrary name of the image                                                                                                                                                                                                                                                                                                                                                                                     |
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PERSISTENT``   | Must be set to 'YES'                                                                                                                                                                                                                                                                                                                                                                                            |
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PATH``         | Path of the VMDK file in the datastore. For instance, an image win10.vmdk in a Windows folder should be set to Windows/win10.vmdk                                                                                                                                                                                                                                                                               |
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ADAPTER_TYPE`` | Possible values (careful with the case): lsiLogic, ide, busLogic. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp#com.vmware.wssdk.apiref.doc/vim.VirtualDiskManager.VirtualDiskAdapterType.html>`__                                                                                                                                                                 |
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``    | The type of disk has implications on performance and occupied space. Values (careful with the case): delta,eagerZeroedThick,flatMonolithic,preallocated,raw,rdm,rdmp,seSparse,sparse2Gb,sparseMonolithic,thick,thick2Gb,thin. More information `in the VMware documentation <http://pubs.vmware.com/vsphere-60/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.VirtualDiskManager.VirtualDiskType.html>`__ |
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. todo:: Images can be upload to the vCenter datastore, cloned, ....
.. todo:: import images


Tuning and Extending
====================

Drivers can be easily customized please refer to the specific guide for each datastore driver or to the :ref:`Storage subsystem developer's guide <sd>`.

However you may find the files you need to modify here:

-  /var/lib/one/remotes/datastore/vcenter
-  /var/lib/one/remotes/tm/vcenter

