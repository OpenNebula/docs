.. _whats_new:

================================================================================
What's New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 6.8 ‘Rosette’** is the fifth stable release of the OpenNebula 6 series. This version of OpenNebula focuses on features to improve the end user experience as well as to optimize the use of the HW resources in KVM based infrastructures.

The fist highlight is the addition of the Virtual Datacenter (VDC) and User tab to FireEdge Sunstone. As you may know, we are working hard on replacing the eyes of OpenNebula, Ruby Sunstone, which has served well for over a decade. FireEdge Sunstone is starting to exhibit a high percentage of the needed functionality, as well as starting to expand the functionality given by Ruby Sunstone. An example is the new User tab, which also includes Accounting and Showback information that can be exported and presented in several different charts. Also Quotas subtab has undergo a face lifting, with a more comprehensive way to convey information.

.. image:: /images/fireedge-rns-68.png
    :align: center

The second highlight is related with Backup functionality, with the introduction of Backup Jobs. Backup Jobs enables the definition of backup operations that involve multiple VMs, simplifying the management of your cloud infrastructure. It lets you establish a unified backup policy for multiple VMs, encompassing schedules, backup retention, and filesystem freeze mode, as well as maintain control over the execution of backup operations, ensuring they do not disrupt ongoing workloads. Moreover it allows for the monitoring the progress of backup operations, essential to estimate backup times accurately.

And third and last, but not least, there's been a myriad of improvements in the KVM drivers. To name a few: now is possible to fine tune the selection of CPU flags, to specify io_uring driver for disks, define a custom video device for VMs and utomatically define default set timers to improve Windows performance. This options have been implemented in the driver, and for the ones where it makes sense, are already exposes through Sunstone. Both flavours :)

As a bonus, the scheduler can be now configured to reach out to an external module (with a well defined REST API) to get recommendations on initial VM placement. The motivation behind this new feature is to able to integrate OpenNebula with different Machine Learning modules that can optimize different metrics to optimize a given criteria, or set of criterias: reduce energy consumption, reduce latency with respect to end user, reduce overall infrastructure cost, etc. Check below to learn what other goodies, and bugfixes, made it into OpenNebula.

As usual, OpenNebula 6.8 is named after a Nebula. The `Rosette Nebula <https://en.wikipedia.org/wiki/Rosette_Nebula>`__ (also known as Caldwell 49) is an H II region located near one end of a giant molecular cloud in the Monoceros region of the Milky Way Galaxy. The open cluster `NGC 2244 <https://en.wikipedia.org/wiki/NGC_2244>`__ (Caldwell 50) is closely associated with the nebulosity, the stars of the cluster having been formed from the nebula's matter.

This is the first beta version for 6.8, aimed at testers and developers to try the new features. All the functionality is present and only bug fixes will happen between this release and final 6.8. Please check the :ref:`known issues <known_issues>` before submitting an issue through GitHub. Also note that being a development version, there is no migration path from the previous stable version (6.6.x) nor migration path to the final stable version (6.8.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/69>`__.

We’d like to thank all the people that support the project, OpenNebula is what it is thanks to its community! Please keep rocking.

OpenNebula Core
================================================================================
- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.
- :ref:`Add VCPU to VMs pool list <vm_guide_2>`. If you are upgrading from previous version, the ``VCPU`` will apear after first update of the VM. Use ``onevm update <vm_id> --append <empty_file>`` to force VM update.
- The scheduler has been extended so it can contact external modules to accomodate custom allocation policies easily, :ref:`see the external scheduler guide for more information <external_scheduler>`.
- Deployment XML for libvirt will now generate feature tags for :ref:`CPU features defined in the VM Template under CPU_MODEL/FEATURES. <cpu_model_options_section>`
- ``CPU_MODEL/FEATURES`` will now be added to :ref:`the Automatic Requirements. <scheduling>`

Networking
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

Storage & Backups
================================================================================
- `Shared datastore allows qcow2 backing link in CLONE action to be configurable  <https://github.com/OpenNebula/one/issues/6098>`__.
- `Allow the resize of qcow2 and Ceph disks with snapshots  <https://github.com/OpenNebula/one/issues/6292>`__.
- Backup Jobs enable you to define backup operations that involve multiple VMs, simplifying the management of your cloud infrastructure. With Backup Jobs, you can setup unified backup policies for multiple VMs, easily track it progress, and control the resources used.
- The ``VIRTIO_ISCSI_QUEUES`` attribute now offers support for the ``auto`` keyword, allowing you to automatically configure the number of queues to match the virtual CPU count of the Virtual Machine. For more information check the :ref:`VM Template Reference <template_features>` and the :ref:`KVM driver guide <kvmg>`.
- Added a new attribute, ``VIRTIO_BLK_QUEUES``, to activate the multi-queue functionality in the virtio-blk driver. This attribute can be configured for all ``DISK`` devices within a VM either through the ``FEATURES`` attribute or globally in the KVM driver configuration file. For more information check the :ref:`VM Template Reference <template_features>` and the :ref:`KVM driver guide <kvmg>`.

Ruby Sunstone
================================================================================
- `Adding 'io_uring' option for IO Policy on VM Templates <https://github.com/OpenNebula/one/issues/6167>`__.

FireEdge Sunstone
================================================================================
- Implemented VDCs tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Users tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.

OneFlow - Service Management
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

OneGate
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

API and CLI
================================================================================
- Add enable method for MarketPlace; and state for Markeplace and Markeplace Appliances objects in the :ref:`Golang API (GOCA) <go>`.
- `Allow STDIN passed templates for commands that accept template files <https://github.com/OpenNebula/one/issues/6242>`__.
- New ``onevmgroup`` commands ``role-add``, ``role-delete`` and ``role-update`` for :ref:`managing VM Group roles <onevmgroup_api>`.

KVM
================================================================================
- Added a monitoring script to add ``KVM_CPU_FEATURES`` to the :ref:`Host Monitoring Information <hosts>`.
- Added the ``VIDEO`` attribute for VM's to :ref:`define a custom video device for VM's <kvm_video>`.
- Extended support for Microsoft Windows guests: updated list of default ``HYPERV_OPTIONS`` and add a predefined set timers (configurable with ``HYPERV_TIMERS``) to the domain clock when ``HYPERV`` enhancements are enabled, :ref:`see the VM template reference <template_features>`.

Features Backported to 6.6.x
================================================================================

Additionally, the following functionalities are present that were not in OpenNebula 6.6.0, although they debuted in subsequent maintenance releases of the 6.6.x series:

- SR-IOV based NICs are live-updated when :ref:`updating the associated VNET attributes <vnet_update>`
- Optimize :ref:`appending with onedb change-body <onedb_change_body>`.
- Allow ``onedb purge-history`` to delete the history record of a :ref:`single VM <onedb_purge_history>`.
- Improve :ref:`onehost sync <host_guide_sync>` error logging.
- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.
- `Marketplace download app stepper should filter image DS <https://github.com/OpenNebula/one/issues/6213>`__.
- Improve :ref:`list commands <cli>`  help messages to point to :ref:`layout configuration files <cli_views>`.
- `Add VCPU to VMs pool list <https://github.com/OpenNebula/one/issues/6111>`__. If you are upgrading from previous version, the ``VCPU`` will apear after first update of the VM. Use ``onevm update <vm_id> --append <empty_file>`` to force VM update.
- Added a guide for :ref:`replacing a failing OpenNebula front-end host <Replace failing front-end>`.
- :ref:`Backup dialog in FireEdge Sunstone updated to make datastore selection optional if not needed <vm_backup>`.
- :ref:`Add support to delete "in-chain" disk snapshots for tree layouts (qcow2) <vm_guide_2_disk_snapshots_managing>`.
- :ref:`Customizable option to disable the Automatic Network Selection toggle on Sunstone <vgg_vn_automatic>`
- :ref:`Graceful stop of ongoing backup operations <vm_backups_operations>`.
- :ref:`Add support for CentOS 8 Stream, Amazon Linux, and openSUSE on LinuxContainers marketplace <market_linux_container>`.
- :ref:`Add the ability to pin the virtual CPUs and memory of a VM to a specific host NUMA node <numa>`.
- :ref:`Hugepages can be used without CPU pinning <numa>`.
- :ref:`Add remote authorization support in FireEdge Sunstone <remote_auth_fireedge>`.
- :ref:`Improve VM HA hook script host_error.rb to skip VMs deployed on local datastores <vm_ha>`.
- :ref:`Upgrade OneKE from 1.24 to 1.27 RKE2 release <oneke_guide>`.
- :ref:`Add Overcommitment dialog in host tab <overcommitment>`.
- :ref:`Reordering the schedule actions creation mode <vm_guide2_scheduling_actions>`.
- :ref:`Allow standalone qcow2 image on shared datastore <nas_ds>`.
- :ref:`Graceful stop of ongoing backup operations <vm_backups_overview>`.
- :ref:`FireEdge Sunstone datastores tab <fireedge_conf>`.
- :ref:`Add support Centos 8 Stream, Amazon Linux and Opensuse for LXD marketplace <market_linux_container>`.
- :ref:`Add ability to pin the virtual CPUs and memory of a VM to a specific NUMA node <numa>`.
- :ref:`Hugepages can be used without CPU pinning <numa>`.
- Restic and Rsync drivers allows to limit CPU and I/O resources consumed by the backup operations. See :ref:`the restic <vm_backups_restic>` and :ref:`the rsync <vm_backups_rsync>` documentation for more information.
- :ref:`Add support for nested group in LDAP <ldap>`.
- OneFlow Services support custom attributes for specific roles. See the :ref:`Using Custom Attributes in the Oneflow Service Management guide <appflow_use_cli>`
- :ref:`Restore incremental backups from a specific increment in the chain <vm_backups_overview>`.
- :ref:`Automatically prune restic repositories <vm_backups_restic>`.
- :ref:`Specify the base name of disk images and VM templates created when restoring a backup <vm_backups_overview>`.
- :ref:`Retention policy for incremental backups <vm_backups_overview>`.
- :ref:`Cluster provisions have been upgraded to use Ubuntu22.04 and Ceph Quincy versions <acd>`.
- :ref:`OneStor was fixed to support persistent images <onestor_ds>`.

Other Issues Solved
================================================================================

- `Fix dict to xml conversion in PyONE by replacing dicttoxml by dict2xml <https://github.com/OpenNebula/one/issues/6064>`__.
- `Updated some ruby deprecated methods incompatible with newer ruby releases <https://github.com/OpenNebula/one/issues/6246>`__.
- `Fix issue with block device backed disks causing libvirt to fail to boot a VM <https://github.com/OpenNebula/one/issues/6212>`__.
- `Fix issue when resuming a VM in 'pmsuspended' state in virsh <https://github.com/OpenNebula/one/issues/5793>`__.
- `Fix issue datastore creation ignores cluster selection <https://github.com/OpenNebula/one/issues/6211>`__.
- `Fix issue deploy VM after instantiate casues React app to crash <https://github.com/OpenNebula/one/issues/6276>`__.
- `Fix an issue where SSH auth driver would fail with openssh formatted private keys <https://github.com/OpenNebula/one/issues/6274>`__.
- `Fix an issue where LinuxContainers marketplace app templates would not match the LXC_UNPRIVILEGED setting handeld by the LXC driver <https://github.com/OpenNebula/one/issues/6190>`__.
- `Fix issue where an non admin user has the error "Restricted attribute DISK" when updating VM Template <https://github.com/OpenNebula/one/issues/6154>`__.
- `Fix schedule action is not setting the right day of the week in Sunstone on checkmark box <https://github.com/OpenNebula/one/issues/6260>`__.
- `Fix disk RECOVERY_SNAPSHOT_FREQ on template instantiation on Ruby Sunstone <https://github.com/OpenNebula/one/issues/6067>`__.
- `Fix case sentive on FireEdge endpoints <https://github.com/OpenNebula/one/issues/6051>`__.
- `Fix multiple minor issues in Sunstone schedule actions forms <https://github.com/OpenNebula/one/issues/5974>`__.
- `Fix rsync backup driver to make use of RSYNC_USER value defined in the datastore template <https://github.com/OpenNebula/one/issues/6073>`__.
- `Fix locked resource by admin can be overriden by user lock. Fix lock --all flag <https://github.com/OpenNebula/one/issues/6022>`__.
- `Fix 'onetemplate instantiate' the persistent flag is not correctly handled <https://github.com/OpenNebula/one/issues/5916>`__.
- `Fix Enable/disable actions for host to reset monitoring timers <https://github.com/OpenNebula/one/issues/6039>`__.
- `Fix monitoring of NUMA memory and hugepages usage <https://github.com/OpenNebula/one/issues/6027>`__.
- `Fix AR removing on virtual network template <https://github.com/OpenNebula/one/issues/6061>`__.
- `Fix FS freeze value when QEMU Agent is selected on backup <https://github.com/OpenNebula/one/issues/6086>`__.
- `Fix trim of VNC/SPICE password <https://github.com/OpenNebula/one/issues/6085>`__.
- `Fix creating SWAP with CEPH datastore <https://github.com/OpenNebula/one/issues/6090>`__.
- `Fix CLI commands to not fail when config (/etc/one/cli/*.yaml) does not exist <https://github.com/OpenNebula/one/issues/5913>`__.
- `Fix permissions for 'onevm disk-resize', fix error code for 'onevm create-chart' <https://github.com/OpenNebula/one/issues/6068>`__.
- `Fix IPv6 was not being displayed on FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6106>`__.
- `Fix retry_if func in TM drivers <https://github.com/OpenNebula/one/issues/6078>`__.
- `Fix local characters for 'onedb upgrade' <https://github.com/OpenNebula/one/issues/6113>`__.
- `Fix filtered attributes for backup restoration (DEV_PREFIX, OS/UUID) <https://github.com/OpenNebula/one/issues/6044>`__.
- `Fix filtering MAC attribute only when no_ip is used <https://github.com/OpenNebula/one/issues/6048>`__.
- `Fix marketplace image download with wrong user from FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6048>`__.
- `Remove duplicated records in machine type and CPU model inputs <https://github.com/OpenNebula/one/issues/6135>`__.
- `Fix Sunstone backup dialog never shows up after deleting backups <https://github.com/OpenNebula/one/issues/6088>`__.
- `Fix Sunstone VM error when adding schedule action leases <https://github.com/OpenNebula/one/issues/6144>`__.
- `Fix Update the image name when it is selected in a template disk <https://github.com/OpenNebula/one/issues/6125>`__.
- `Fix catch error when XMLRPC is wrongly configured <https://github.com/OpenNebula/one/issues/6089>`__.
- `Fix one.vm.migrate call in Golang Cloud API (GOCA) <https://github.com/OpenNebula/one/issues/6108>`__.
- `Fix undeploy/stop actions leaving VMs defined in vCenter <https://github.com/OpenNebula/one/issues/5990>`__.
- `Fix Host system monitoring NETTX and NETRX <https://github.com/OpenNebula/one/issues/6114>`__.
- `Fix FSunstone currency change is not working <https://github.com/OpenNebula/one/issues/6222>`__.
- `Fix wrong management of labels in OpenNebula Prometheus exporter <https://github.com/OpenNebula/one/issues/6226>`__.
- `Fix Creating a new image ends with wrong DEV_PREFIX <https://github.com/OpenNebula/one/issues/6214>`__.
- `Include HostSyncManager as a gem dependency <https://github.com/OpenNebula/one/issues/6245>`__.
- `Fix onegate man page generation <https://github.com/OpenNebula/one/issues/6172>`__.
- `Fix Incorrect service configuration for opennebula-fireedge.service <https://github.com/OpenNebula/one/issues/6241>`__.
- Fix :ref:`onegather <support>` journal log collection when using systemd.
- :ref:`Onegather <support>` now includes execution logs within the package.
- `Fix VM operation permissions for disk-attach, nic-(de)attach and nic-update <https://github.com/OpenNebula/one/issues/6239>`__.
- `Fix reset flag for onevm backup --schedule <https://github.com/OpenNebula/one/issues/6193>`__.
- `Fix OpenNebula Prometheus exporter to refresh data <https://github.com/OpenNebula/one/issues/6236>`__.
- `Fix missing defaults on Turnkey marketplace <https://github.com/OpenNebula/one/issues/6258>`__.
- `Fix LinuxContainers opensuse app not having SSH access <https://github.com/OpenNebula/one/issues/6257>`__.
- `Fix missing unit selectors on create images and vm templates <https://github.com/OpenNebula/one/issues/6136>`__.
- `Fix wrong configuration for FreeMemory10 in Prometheus rules <https://github.com/OpenNebula/one/issues/6225>`__.
- `Fix regular user cannot create a new VM template <https://github.com/OpenNebula/one/issues/6129>`__.
- `Fix logic mismatch when attaching volatile disks for block drivers <https://github.com/OpenNebula/one/issues/6288>`__.
- `Fix oned segmentation fault when configured to run cache mode <https://github.com/OpenNebula/one/pull/6301>`__.
- `Fix charset conversions for 'onedb fsck' and 'onedb sqlite2mysql' <https://github.com/OpenNebula/one/issues/6297>`__.
- `Fix initialization of 'sed' command avoiding repeating attributes <https://github.com/OpenNebula/one/issues/6306>`__.
- `Fix IP alias detach so it does not removes VM vNICs from bridge ports (OVS) <https://github.com/OpenNebula/one/issues/6306>`__.
- `Fix schedule action is not setting the right day of the week in Sunstone on checkmark box <https://github.com/OpenNebula/one/issues/6260>`__.
- `Fix Equinix provider to support the facility/metro change <https://github.com/OpenNebula/one/issues/6318>`__.
- `Fix the template update process to ensure that restricted attributes are always kept <https://github.com/OpenNebula/one/issues/6315>`__. It's worth noting that previous versions silently ignored the removal of restricted attributes. However, with this patch, an error will be generated in such cases.
- `Fix error when removing ipsets under heavy load <https://github.com/OpenNebula/one/issues/6299>`__.
- `Disable change owner and change group for public MarketPlaces <https://github.com/OpenNebula/one/issues/6331>`__.
