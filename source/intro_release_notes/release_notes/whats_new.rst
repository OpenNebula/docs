.. _whats_new:

================================================================================
What's New in 5.4
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
    :width: 60%
    :align: center


A new resource, the VM Groups, has been added to implement affinity/anti-affinity VM-to-VM and Host-to-Host. A VM group is a set of related virtual machines that may impose placement constraints based on affinity and anti-affinity rules. A VM group is defined as a set of Roles. A Role defines a VM type or class, and expressions to the VM Group can be added to define affinity between VM roles, or between VM and hosts. This ensures a dynamic approach to affinity/anti-affinity since new VMs can be enroled to a particular Role at boot time, after the VM Group has been defined and other VMs added to it.

.. image:: /images/vmgroups_ilustration.png
    :width: 60%
    :align: center

To top it all, OpenNebula 5.4 brings to the table a native implementation of a consensus algorithm, which enables the High Availability deployment of the OpenNebula front-end without relying to third party components. This distributed consensus protocol provides fault-tolerance and state consistency across OpenNebula services. A consensus algorithm is built around two concepts, System State -the data stored in the database tables- and Log -a sequence of SQL statements that are consistently applied to the OpenNebula DB in all servers-. To preserve a consistent view of the system across servers, modifications to system state are performed through a special node, the leader. The servers in the OpenNebula cluster elects a single node to be the leader. The leader periodically sends heartbeats to the other servers (follower*) to keep its leadership. If a leader fails to send the heartbeat, followers promote to candidates and start a new election. This feature, with support from floating IPs and a proper Sunstone configuration, gives robustness to OpenNebula clouds. This new functionality of distributed system state is also used to implement OpenNebula federation. In both cases (Federation and HA) no support is needed from MySQL to create a clustered DB, so admins can forget about MySQL replication.

There are many other improvements in 5.4, like improved VM lifecycle, flexible resource permissions, life disk resizing, improved Ceph support, enhanced disk I/O feedback, showback cost estimate in Sunstone, flexible IPv6 definition, http proxy support for marketplace, purge tools for the OpenNebula database, resource group isolation, multiple Sunstone improvements (VNC, password dialogs, confirmation dialogs, better vCenter support, persistent labels, usability enhacenents), networking improvements, user inputs in OneFlow and many many more features to enrich your cloud experience. As with previous releases, and in order to achieve a reliable cloud management platform, the team has gone great lengths to fix reported bugs and improve general usability.

This OpenNebula release is named after the `Medula Nebula <https://en.wikipedia.org/wiki/Medusa_Nebula>`__, a large planetary nebula in the constellation of Gemini on the Canis Minor border. It also known as Abell 21 and Sharpless 2-274. It was originally discovered in 1955 by UCLA astronomer George O. Abell, who classified it as an old planetary nebula. The braided serpentine filaments of glowing gas suggests the serpent hair of Medusa found in ancient Greek mythology.

OpenNebula 5.4 Medusa is considered to be a stable release and as such, and update is available in production environments.


In the following list you can check the highlights of OpenNebula 5.4 (`a detailed list of changes can be found here <https://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=86&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&v%5Btracker_id%5D%5B%5D=2&v%5Btracker_id%5D%5B%5D=7&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__):

OpenNebula Core
--------------------------------------------------------------------------------

- **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.

- **Simplified Federation setups**, it is no longer required to setup and maintain a MySQL replicated DB using the :ref:`new distributed system state <federationconfig>` feature implemented in OpenNebula.

- **Advanced access control policies** for VMs, now it is possible to redefine the access level (:ref:`ADMIN, MANAGE and USE <oned_conf_vm_operations>`) required for each VM action.

- **Improved traceability on VM actions**, :ref:`VM history records <vm_history>` logs the data associated to the action performed on a VM.

- **VM Groups** to define groups of related VMs and set :ref:`VM affinity <vmgroups>` rules across them.

- **Database maitenance tools** to purge history records, update corrupted data and more through the :ref:`onedb <onedb>` command.


Storage
--------------------------------------------------------------------------------

- **Improved VM disk management**, including options to resize disks for :ref:`running VMs <vm_guide2_resize_disk>`, enhanced I/O feedback and :ref:`monitoring <mon>`.

- **Improved Ceph integration**, by default Ceph disk snapshots are in a flat hierarchy (this can be also be :ref:`selected for other storage backends <oned_conf_transfer_driver>`). Also it is now easier to setup multiple clusters with different :ref:`authentication attributes <ceph_ds_templates>` and finally a new option has been added for :ref:`trim/discard option <reference_vm_template_disk_section>`.

Networking
--------------------------------------------------------------------------------

- **Better IPv6 support**, including support for :ref:`Security Groups <security_groups>` and the definition of :ref:`Non-SLAAC IPv6 Address Range <manage_vnet_ar>`.

- **Improved network settings** that may :ref:`override multiple default options <vnet_template_interface_creation>` used when creating links in the hypervisors including MAC spoofing, arp cache poisoning, interface MTU or STP among others.

Hybrid Clouds: Amazon EC2
--------------------------------------------------------------------------------

- **Enhanced EC2 monitoring and VM lifecycle**, with better handling of :ref:`CloudWatch <ec2g>` datapoints to avoid errors after long-term network problems.

- **Better EC2 resource characterization** the information to access and EC2 zone is now stored in the corresponding OpenNebula Host including EC2 :ref:`credentials <ec2_driver_conf>`, capacity limits and EC2 zone name.


Scheduler
--------------------------------------------------------------------------------

- **Affinity/Anti-affinity** for VM-to-VM, VM-to-Role and VM-to-Host using the new :ref:`VM Group resource <vmgroups>`.

- **VM prioritization**, a static VM priority can be assigned to pending/reschedule VMs to alter the default :ref:`FIFO ordering when dispatching VMs <schg_limit>`.


Sunstone
--------------------------------------------------------------------------------

- **Improved customization** with more flags to :ref:`restrict action usage <suns_views_actions>` and :ref:`enhanced logo customization <suns_views_custom>`.
- **Persistent resource labels** that do not expire if no resource is tagged with a :ref:`label <suns_views_labels>`.
- **Enhanced image upload control** with progress feedback and resume capabilities.
- **Better groups isolation** allowing to change the primary and secondary groups directly from the groups panel. Also group switch only shows :ref:`current group resources <manage_groups_sunstone>` to work by project easily.
- **Extended user inputs**, with new :ref:`types <template_user_inputs>` like booleans and the possiblity to define the order.
- **Fixed multilanguage keyboard support** in :ref:`VNC feature <remote_access_sunstone>`.
- **Improved showback support**, with better dialogs to define and estimate the :ref:`VM Template showback section <template_showback_section>`.

- **A significant number of usability enhancements**:

  - More secure password change dialog.
  - ESC support for VNC dialog.
  - :ref:`Improved overcommitment dialogs <dimensioning_the_cloud>`.
  - More presence of the VM logo in the VM Template and instance dialogs and tabs.
  - Confirmation dialog for destructive actions like reverting disks or erasing VMs.
  - Cloud view improved. Diff between own VMs and group VMs.

.. image:: /images/view_cloud_new.png
    :width: 90%
    :align: center

vCenter
--------------------------------------------------------------------------------

The significant milestone is that vCenter is no longer treated as a public cloud by OpenNebula, but rather as a fully fledged hypervisor. The monitoring and import process have been optimized with a two orders of magnitude improvement in time efficiency.

- **Improved VM and VM Template management**, attach CDROM to a VM :ref:`without a drive<vcenter_attach_cdrom>`, add VNC capabilities to :ref:`imported wild VMs<import_vcenter_resources>`, :ref:`save VM as an OpenNebula template<vcenter_save_as_template>`, :ref:`linked clones capabilities<vcenter_linked_clones_description>`, images and networks representing disks and nics are created for :ref:`imported vCenter template<vcenter_import_templates>` and :ref:`folder placement features<vcenter_folder_placement>`, among others.

- **Network creation support**, a new vCenter network mode is available in virtual network definition, standard and different port groups and vSwitches :ref:`can be created from within OpenNebula <vcenter_enhanced_networking>`. VLAN IDs, MTUs and number of ports can be specified when a port group is created.

- **Improved Storage (datastore, Image and disk management)**, :ref:`non-persistent images and volatiles disks <vcenter_ds>` are now supported, :ref:`clustered datastores <storage_drs_pods>` are clearly differentiated at import time, :ref:`disk resize capabilities <vm_guide2_resize_disk>`, :ref:`save disk functionality <disk_save_as_action>` and :ref:`disks statistics monitoring<disk_monitoring>`.

- **vCenter default values**, some default values for vCenter attributes e.g NIC model, can be specified in :ref:`a new configuration file <vcenter_default_config_file>`.

- **Removed naming limitations**, like for instance vCenter cluster and datastore names with spaces are now supported.
