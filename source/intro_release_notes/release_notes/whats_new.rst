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

Networking
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

Storage & Backups
================================================================================
- `Shared datastore allows qcow2 backing link in CLONE action to be configurable  <https://github.com/OpenNebula/one/issues/6098>`__.
- `Allow resizing qcow2 and Ceph disks with snapshots  <https://github.com/OpenNebula/one/issues/6292>`__.
- Backup Jobs enable you to define backup operations that involve multiple VMs, simplifying the management of your cloud infrastructure. With Backup Jobs, you can setup unified backup policies for multiple VMs, easily track it progress, and control the resources used.

Ruby Sunstone
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

FireEdge Sunstone
================================================================================
- Implemented VDCs tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.

OneFlow - Service Management
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

OneGate
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

CLI
================================================================================
- `Allow STDIN passed templates for commands that accept template files <https://github.com/OpenNebula/one/issues/6242>`__.

KVM
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

Other Issues Solved
================================================================================

- `Fix dict to xml conversion in PyONE by replacing dicttoxml by dict2xml <https://github.com/OpenNebula/one/issues/6064>`__.
- `Updated some ruby deprecated methods incompatible with newer ruby releases <https://github.com/OpenNebula/one/issues/6246>`__.
- `Fix issue when resuming a VM in 'pmsuspended' state in virsh <https://github.com/OpenNebula/one/issues/5793>`__.

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
