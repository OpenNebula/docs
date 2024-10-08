.. _resolved_issues_6101:

Resolved Issues in 6.10.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/79?closed=1>`__.

The following new features have been backported to 6.10.1:

- Backup datastore capacity is checked before attempting to create a backup. This test can be disable with the ``DATASTORE_CAPACITY_CHECK`` attribute, either globally or per datastore.
- Add a "disk-snapshot-list" option to :ref:`onevm cli <cli>`.
- `Optimize handling of VM history records, it greatly improves perfomance of all VM operations for VMs with many history records <https://github.com/OpenNebula/one/issues/2111>`__.
- `Add support for incremental backups in Ceph <https://github.com/OpenNebula/one/issues/6411>`__.

The following issues has been solved in 6.10.1:

- `Fix KVM VM migration when CLEANUP_MEMORY_STOP is not defined in the driver configuration <https://github.com/OpenNebula/one/issues/6665>`__.
- `Fix a very uncommon error while initializing drivers <https://github.com/OpenNebula/one/issues/6694>`__.
- `Fix restore of volatile disks from a VM backup <https://github.com/OpenNebula/one/issues/6607>`__.
- `Fix backups of volatile disks in Ceph drivers <https://github.com/OpenNebula/one/issues/6505>`__.
- `Fix backup of VM with ISO images to skip the backup of CD drives <https://github.com/OpenNebula/one/issues/6578>`__.
- `Fix Sunstone/OneProvision configuration mismatch <https://github.com/OpenNebula/one/issues/6711>`__.
- `Fix Sunstone check button for backing up volatile disks <https://github.com/OpenNebula/one/issues/6532>`__.
- `Fix the reloading process of the monitor drivers <https://github.com/OpenNebula/one/issues/6687>`__.
- `Fix oned initialization when the configuration file contains drivers with the same name <https://github.com/OpenNebula/one/issues/5801>`__.
- `Fix PyOne dependencies to not mix pip and python3-* packages <https://github.com/OpenNebula/one/issues/6577>`__.
- `Fix inconsistent CPU pinning after VM cold migration <https://github.com/OpenNebula/one/issues/6596>`__.
- `Fix User inputs doesn't propagate value to context attribute of vm using Sunstone <https://github.com/OpenNebula/one/issues/6725>`__.
- `Fix VM disk selection when restoring backups <https://github.com/OpenNebula/one/issues/6739>`__.
- `Fix Sunstone card view for large installations adding a new row mode style <https://github.com/OpenNebula/one/issues/6718>`__.
- `Fix Sunstone datastore limit parsing <https://github.com/OpenNebula/one/issues/6746>`__.
- `Fix reset backup failed after restore individual disk on the VM <https://github.com/OpenNebula/one/issues/6741>`__.
