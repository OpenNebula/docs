.. _whats_new:

================================================================================
What's New in 5.4 Beta
================================================================================

OpenNebula 5.4 (Medusa) is the third release of the OpenNebula 5 series. A significant effort has been applied in this release to stabilize features introduced in 5.2 Excession, while keeping an eye in implementing those features more demanded by the community.

As usual almost every component of OpenNebula has been reviewed to target usability and functional improvements, trying to keep API changes to a minimum to avoid disrupting ecosystem components. An important focus has been on the vCenter integration, with a enhance network and storage managemnent. Also, new components have been added to enhance the OpenNebula experience.

A major overhaul has been applied to the vCenter integration. The team decided to go all the way and level the vCenter integration with the KVM support. This means a full network management -it is now possible to create vCenter standard port groups and distributed vSwitches directly from OpenNebula, specifying the VLAN ID if needed- , full storage management -persistent images are now supported, OpenNebula being aware of all VM disks, full stroage quotas enforcement-, support for linked clones, marketplace support, improved monitoring and import process (100x Speedup and the ability to enable VNC automatically), disk resize, removed naming limitations in imported resources and many more!

: .. todo::  vCenter network creation screenshot

A new resource to implement affinity/antiaffinity VM-to-VM and Host-to-Host has been added to OpenNebula, the VM Groups. A VM group is a set of related virtual machines that may impose placement constraints based on affinity and anti-affinity rules. A VM group is defined as a set of ROLEs. A Role defines a VM type or class, and expressions to the VM Group can be added to define affinity between VM roles, or between VM and hosts. This ensures a dynamic approach to affinity/antiaffinity since new VMs can be enroled to a particular Role.

: .. todo:: VMGroups image


: .. todo:: HA & federation paragraph and image


There are many other improvements in 5.4, like improved VM lifecycle, flexible resource permissions, life disk resizing, improved Ceph support, enhaced disk I/O feedback, showback cost estimate in Sunstone, flexible IPv6 definition, http proxy support for marketplace, purge tools for the OpenNebula database, resource group isolation, multiple Sunstone improvements (VNC, password dialogs, confirmatoin dialogs, etc), and many many more. As with previous releases, and in order to achieve a reliable cloud management platform, the team has gone great lenghts to fix reported bugs and improve general usability.


This OpenNebula release is named after the `Medula Nebula <https://en.wikipedia.org/wiki/Medusa_Nebula>`__, a large planetary nebula in the constellation of Gemini on the Canis Minor border. It also known as Abell 21 and Sharpless 2-274.  It was originally discovered in 1955 by UCLA astronomer George O. Abell, who classified it as an old planetary nebula. The braided serpentine filaments of glowing gas suggests the serpent hair of Medusa found in ancient Greek mythology.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release.

In the following list you can check the highlights of OpenNebula 5.4 (`a detailed list of changes can be found here <https://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=86&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&v%5Btracker_id%5D%5B%5D=2&v%5Btracker_id%5D%5B%5D=7&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__):

OpenNebula Core
--------------------------------------------------------------------------------

- **Improved VM lifecycle** covering also :ref:`recover from snapshot failures <onevm_api>` and :ref:`termination of failed VMs <vm_guide_2>`.
- **Flexible resource permissions** for VMs, now is possible to redefine the semantics of :ref:`ADMIN, MANAGE and USE <oned_conf_vm_operations>`
- **Improved VM history** now logs :ref:`the UID <vm_history>` (TODO update onevm show output form the reference)
- **Disk cache modification** now possible through :ref:`vm update operations <template>`.
- **New HA model**, providing HA in the OpenNebula core and Sunstone without third party dependencies. (TODO)
- **New VM Group resource** to implement :ref:`VM affinity <vmgroups>`.


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

- **Life disk resizing**, in the :ref:`VM running state <vm_guide2_resize_disk>`.
- **Improved Ceph support** with trim/discard option (TODO)
- **Enhanced disk I/O feedback**, shown per VM in :ref:`Sunstone <sunstone>`, accounted for in :ref:`OpenNebula monitoring <mon>`.
- **Multi queue virtio-scsi** (TODO)

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

- **Linked clones for vCenter** (TODO).
- **EC2 improvements** (TODO)


OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------

- **Flexible IPv6 definition**, with the :ref:`new Non-SLAAC IPv6 <manage_vnet_ar>`.
- **Add default MTU**, for network drivers (TODO)
- **Support for spanning tree parameters** at the bridge definition level (TODO)
- **Per network settings** for MAC spoofing and arp cache poisoning (TODO)

OpenNebula Drivers :: Marketplace
--------------------------------------------------------------------------------

- **Enable access behind HTTP proxy** for :ref:`marketplaces <marketplace>`.

Database
--------------------------------------------------------------------------------

- **New tools** to purge history records, update corrupted data  and more through the :ref:`onedb <onedb>` command. 

Scheduler
--------------------------------------------------------------------------------

- **Affinity/Anttiaffinity** for VM-to-VM and VM-to-Host using the new :ref:`VM Group resource <vmgroups>`.


Sunstone
--------------------------------------------------------------------------------

- **Resource group isolation**, easy group swith only shows current group resources (TODO)
- **Improved customization** with more flags to restrict action usage and enahnced logo customization (TODO)
- **Persistent resource labels** that do not expire if no resource is tagged with a :ref:`label <labels>` (TODO)
- **Configurable session parameters** like for instance session length (TODO)
- **Added confirmation dialogs** for destructive actions for enhanced security
- **Enhanced image upload control** with progress feedback and resume capabilities (TODO)
- **Better groups dialogs** allowing to change the primary and secondary groups directly fom the groups panel
- **Fixed multilanguage keyboard support** in VNC feature
- **Improved showback support**, with better dialogs to define and estimate the :ref:`VM Template showback section <template_showback_section>`.
- **A significant number of usability enhancements**:
  - More secure password change dialog 
  - ESC support for VNC dialog
  - :ref:`improved overcommitment dialogs <dimensioning_the_cloud>`
  - more presence of the VM logo in the VM Template and instance dialogs and tabs
  - warning displayed when reverting disks, erasing VMs, etc
  - use image name instead of IDs for files datastores
  - better :ref:`federation <federationconfig>` support


vCenter
--------------------------------------------------------------------------------

The significant milestone is the vCenter is no longer treated as a public cloud by OpenNebula, but rather as a fully fledged hypervisor.

- **VNC for imported VMs**, now VNC is automatically added to a VM at :ref:`import time <import_vcenter_resources>`.
- **vCenter resources tied to their cluster**, this is automatically set during :ref:`import process <import_vcenter_resources>`.
- **Improve API call management**, :ref:`vCenter driver <vcenterg>` does not leave open sessions in the server.
- **Removed naming limitations**, like for :ref:`instance vCenter cluster names <vcenter_limitations>` with spaces are now supported.
- **Better StoragePod support**, now :ref:`clustered datastores <storage_drs_pods>` are clearly differentiated at import time.
- **Marketplace support**, with the ability to download VMDK from the :ref:`marketplace <marketplace>`.
- **Improved Datastore & image management**, :ref:`non-persistent images <vcenter_ds>` are now supported and they're cloned automatically by OpenNebula, also now vCenter VMs can use volatile images.
- **Disks can be resized**, when a :ref:`VM is deployed <vm_guide2_resize_disk>`.
- **Disks and NICs in vCenter template are now visible**, when a vCenter template is imported images and networks representing disks and nics are created. (TODO networking)
- **Disks can be saved as**, it the VM is in poweroff state a copy of a disk can be performed. KEEP_DISKS_ON_DONE attribute is no longer available. (TODO)
- **Network creation support**, a new vCenter network mode is available in virtual network definition, standard port groups and distributed vSwotches with different VLANs can be created from within OpenNebula (TODO)
- **Inventory folder selection**, a folder inside vSphere's VMs and Templates view can be specified so deployed VMs are seen under that folder. (TODO)
- **VNC port configuration for wild VMs**, when a wild VM is imported, the VNC port is added automatically to VM's config.
- **vCenter default values**, some default values for vCenter attributes e.g NIC model, can be specified in a new configuration file (TODO)
- **Attaching a CDROM works even though a CDROM drive is not already present in the VM**, an IDE CDROM is used. (TODO)
- **Linked Clones can be used**, :ref:`onevcenter tool <vcenter_import_tool>` gives the chance to prepare a template being imported so it can benefit from VM linked clone.



