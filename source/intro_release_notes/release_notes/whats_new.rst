.. _whats_new:

================================================================================
What's New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 6.8 ‘-----’** is the fifth stable release of the OpenNebula 6 series...

OpenNebula Core
================================================================================
- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.
- `Add VCPU to VMs pool list <https://github.com/OpenNebula/one/issues/6111>`__. If you are upgrading from previous version, the ``VCPU`` will apear after first update of the VM. Use ``onevm update <vm_id> --append <empty_file>`` to force VM update.
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

Features Backported to 6.6.x
================================================================================

Additionally, the following functionalities are present that were not in OpenNebula 6.6.0, although they debuted in subsequent maintenance releases of the 6.6.x series:

- `Restore incremental backups from an specific increment in the chain <https://github.com/OpenNebula/one/issues/6074>`__.
- `Automatically prune restic repositories <https://github.com/OpenNebula/one/issues/6062>`__.
- `Specify the base name of disk images and VM templates created when restoring a backup <https://github.com/OpenNebula/one/issues/6059>`__.
- `Retention policy for incremental backups <https://github.com/OpenNebula/one/issues/6029>`__.
- `Graceful stop of ongoing backup operations <https://github.com/OpenNebula/one/issues/6030>`__.
- `FireEdge Sunstone datastores tab <https://github.com/OpenNebula/one/issues/6095>`__.
- `Add support Centos 8 Stream, Amazon Linux and Opensuse for LXD marketplace <https://github.com/OpenNebula/one/issues/3178>`__.
- `Add ability to pin the virtual CPUs and memory of a VM to a specific NUMA node <https://github.com/OpenNebula/one/issues/5966>`__.
- `Hugepages can be used without CPU pinning <https://github.com/OpenNebula/one/issues/6185>`__.
