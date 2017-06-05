.. _whats_new:

================================================================================
What's New in 5.4 Beta
================================================================================

OpenNebula 5.4 (Medusa) is the third release of the OpenNebula 5 series. A significant effort has been applied in this release to stabilize features introduced in 5.2 Excession, while keeping an eye in implementing those features more demanded by the community.

As usual almost every component of OpenNebula has been reviewed to target usability and functional improvements, trying to keep API changes to a minimum to avoid disrupting ecosystem components. An important focus has been on the vCenter integration, with an enhanced network and storage management. Also, new components have been added to improve the OpenNebula experience.

A major overhaul has been applied to the vCenter integration. The team decided to go all the way and level the vCenter integration with the KVM support. This means:

- Full storage management. Non-Persistent images are now supported as well as volatile disks. OpenNebula is now aware of all VM disks and storage quotas can be enforced. Support for linked clones and Marketplace.
- Full network management. It is now possible to create vCenter standard and distributed port groups and even vSwitches directly from within OpenNebula. You can assign a VLAN ID to a port group created by OpenNebula.
- Improved monitoring. Up to two orders of magnitude of speedup.
- An enhanced import process where naming limitations in imported resources has been removed and the ability to enable VNC automatically for Wild VMs.
- Disk resizing, VM and Templates folder selection when a VM is deployed... and many more changes!


.. image:: /images/vcenter_network_create.png
    :width: 90%
    :align: center


A new resource to implement affinity/antiaffinity VM-to-VM and Host-to-Host has been added to OpenNebula, the VM Groups. A VM group is a set of related virtual machines that may impose placement constraints based on affinity and anti-affinity rules. A VM group is defined as a set of Roles. A Role defines a VM type or class, and expressions to the VM Group can be added to define affinity between VM roles, or between VM and hosts. This ensures a dynamic approach to affinity/antiaffinity since new VMs can be enroled to a particular Role at boot time, after the VM Group has been defined and other VMs added to it.

.. image:: /images/vmgroups_ilustration.png
    :width: 90%
    :align: center

To top it all, OpenNebula 5.4 brings to the table a native implementation of a consensus algorithm, which enables the High Availability deployment of the OpenNebula front-end without relying to third party components. This distributed consensus protocol provides fault-tolerance and state consistency across OpenNebula services. A consensus algorithm is built around two concepts, System State -the data stored in the database tables- and Log -a sequence of SQL statements that are consistently applied to the OpenNebula DB in all servers-. To preserve a consistent view of the system across servers, modifications to system state are performed through a special node, the leader. The servers in the OpenNebula cluster elects a single node to be the leader. The leader periodically sends heartbeats to the other servers (follower*) to keep its leadership. If a leader fails to send the heartbeat, followers promote to candidates and start a new election. This feature, with support from floating IPs and a proper Sunstone configuration, gives robustness to OpenNebula clouds. This new functionality of distributed system state is also used to implement OpenNebula federation. In both cases (Federation and HA) no support is needed from MySQL to create a clustered DB, so admins can forget about MySQL replication.

There are many other improvements in 5.4, like improved VM lifecycle, flexible resource permissions, life disk resizing, improved Ceph support, enhanced disk I/O feedback, showback cost estimate in Sunstone, flexible IPv6 definition, http proxy support for marketplace, purge tools for the OpenNebula database, resource group isolation, multiple Sunstone improvements (VNC, password dialogs, confirmation dialogs, better vCenter support, persistent labels, usability enhacenents), networking improvements, user inputs in OneFlow and many many more features to enrich your cloud experience. As with previous releases, and in order to achieve a reliable cloud management platform, the team has gone great lengths to fix reported bugs and improve general usability.

This OpenNebula release is named after the `Medula Nebula <https://en.wikipedia.org/wiki/Medusa_Nebula>`__, a large planetary nebula in the constellation of Gemini on the Canis Minor border. It also known as Abell 21 and Sharpless 2-274.  It was originally discovered in 1955 by UCLA astronomer George O. Abell, who classified it as an old planetary nebula. The braided serpentine filaments of glowing gas suggests the serpent hair of Medusa found in ancient Greek mythology.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release.

In the following list you can check the highlights of OpenNebula 5.4 (`a detailed list of changes can be found here <https://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=86&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&v%5Btracker_id%5D%5B%5D=2&v%5Btracker_id%5D%5B%5D=7&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__):

OpenNebula Core
--------------------------------------------------------------------------------

- **Improved VM lifecycle** covering also :ref:`recover from snapshot failures <onevm_api>` and :ref:`termination of failed VMs <vm_guide_2>`.
- **Flexible resource permissions** for VMs, now is possible to redefine the semantics of :ref:`ADMIN, MANAGE and USE <oned_conf_vm_operations>`.
- **Improved VM history**, now VM history records log :ref:`the UID <vm_history>` that perfomed the action. (TODO update onevm show output form the reference)
- **Disk cache modification** now possible through :ref:`vm update operations <template>`.
- **New HA model**, providing HA in the OpenNebula core and Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.
- **Federation without DB replication**, using the :ref:`new distributed system state <federationconfig>` feature implemented in OpenNebula
- **New VM Group resource** to implement :ref:`VM affinity <vmgroups>`.


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

- **Life disk resizing**, in the :ref:`VM running state <vm_guide2_resize_disk>`.
- **Improved Ceph support** with trim/discard option (TODO)
- **Enhanced disk I/O feedback**, shown per VM in :ref:`Sunstone <sunstone>`, accounted for in :ref:`OpenNebula monitoring <mon>`.
- **Multi queue virtio-scsi** (TODO)
- **Configurable Image Persistency Setting**, making the persistency of the images configurable for users and groups of users (TODO)

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

- **Enhanced EC2 monitoring**, with better handling of :ref:`CloudWatch <ec2g>` datapoints to avoid errors after long-term network problems.
- **Improved VM lifecycle** for :ref:`EC2 <ec2g>` VMs.
- **Increased security** for EC2 :ref:`credentials <ec2_driver_conf>`, stored encrypted in the OpenNebula EC2 host representation.


OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------

- **Flexible IPv6 definition**, with the :ref:`new Non-SLAAC IPv6 Address Range <manage_vnet_ar>`.
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

- **Affinity/Anti-affinity** for VM-to-VM and VM-to-Host using the new :ref:`VM Group resource <vmgroups>`.

OneFlow
--------------------------------------------------------------------------------

- **Enhanced Functionality** in :ref:`OneFlow <oneapps_overview>`, now supporting :ref:`user inputs <vm_guide_user_inputs>` in the service definition.

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

The significant milestone is that vCenter is no longer treated as a public cloud by OpenNebula, but rather as a fully fledged hypervisor.

- **VNC port configuration for wild VMs**, when a wild VM is imported, the VNC port is added automatically to VM's config at :ref:`import time <import_vcenter_resources>`.
- **vCenter resources tied to their cluster**, this is automatically set during :ref:`import process <import_vcenter_resources>`.
- **Improve API call management**, :ref:`vCenter driver <vcenterg>` does not leave open sessions in the server.
- **Removed naming limitations**, like for :ref:`instance vCenter cluster names <vcenter_limitations>` with spaces are now supported.
- **Better StoragePod support**, now :ref:`clustered datastores <storage_drs_pods>` are clearly differentiated at import time.
- **Marketplace support**, with the ability to download VMDK from the :ref:`marketplace <marketplace>`.
- **Improved Datastore & Image management**, :ref:`non-persistent images <vcenter_ds>` are now supported and they're cloned automatically by OpenNebula, also now vCenter VMs can use volatile images.
- **Disks can be resized**, when a :ref:`VM is deployed <vm_guide2_resize_disk>`.
- **Disks and NICs in vCenter template are now visible**, when a vCenter template is imported images and networks representing disks and nics are created. (TODO networking)
- **Disks can be saved as**, it the VM is in poweroff state a copy of a disk can be performed. KEEP_DISKS_ON_DONE attribute is no longer available. (TODO)
- **Network creation support**, a new vCenter network mode is available in virtual network definition, standard and different port groups and vSwitches can be created from within OpenNebula. VLAN IDs, MTUs and number of ports can be specified when a port group is created. (TODO)
- **Inventory folder selection**, a folder inside vSphere's VMs and Templates view can be specified so deployed VMs are seen under that folder. (TODO)
- **vCenter default values**, some default values for vCenter attributes e.g NIC model, can be specified in a new configuration file (TODO)
- **Attaching a CDROM works even though a CDROM drive is not already present in the VM**, an IDE CDROM is used. (TODO)
- **Linked Clones can be used**, :ref:`onevcenter tool <vcenter_import_tool>` gives the chance to prepare a template being imported so it can benefit from VM linked clone.



