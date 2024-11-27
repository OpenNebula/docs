.. _resolved_issues_6102:

Resolved Issues in 6.10.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/80?closed=1>`__.

The following new features have been backported to 6.10.2:


The following issues has been solved in 6.10.2:

- `Fix bug in the DS Ceph driver: set the value for the --keyfile to CEPH_KEY instead of CEPH_USER in the export operation <https://github.com/OpenNebula/one/issues/6791>`__.
- `Fix GOCA OS vector attribute to include FIRMWARE, FIRMWARE_SECURE, UUID and SD_DISK_BUS <https://github.com/OpenNebula/one/issues/6782>`__.
- `Fix PyOne installation through pip <https://github.com/OpenNebula/one/issues/6784>`__.
- `Fix the list of attibutes that can be overriden in vmm_exec_kvm.conf <https://github.com/OpenNebula/one/issues/6548>`__.
- `Fix a rare crash in 'onedb fsck' caused by a locked MarketPlaceApp in a federated environment <https://github.com/OpenNebula/one/issues/6793>`__.
- `Fix iotune attributes not being passed to VM if value is greater than int capacity <https://github.com/OpenNebula/one-ee/pull/3300>` __.