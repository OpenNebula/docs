.. _whats_new:

================================================================================
What's New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 6.8 ‘-----’** is the fifth stable release of the OpenNebula 6 series...

OpenNebula Core
================================================================================
- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.

Networking
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

Storage & Backups
================================================================================
- `Shared datastore allows qcow2 backing link in CLONE action to be configurable  <https://github.com/OpenNebula/one/issues/6098>`__.

Ruby Sunstone
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

FireEdge Sunstone
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

OneFlow - Service Management
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

OneGate
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

CLI
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

KVM
================================================================================
- `Feature 1 <https://github.com/OpenNebula/one/issues/1234>`__.

Other Issues Solved
================================================================================

- `Fix dict to xml conversion in PyONE by replacing dicttoxml by dict2xml <https://github.com/OpenNebula/one/issues/6064>`__.

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
