.. _resolved_issues_543:

Resolved Issues in 5.4.3
--------------------------------------------------------------------------------

A complete list of solved issues for 5.4.3 can be found in the `project development portal <https://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=92&f%5B%5D=tracker_id&op%5Btracker_id%5D=%3D&v%5Btracker_id%5D%5B%5D=1&v%5Btracker_id%5D%5B%5D=2&v%5Btracker_id%5D%5B%5D=7&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__.

New functionality for 5.4.3 has been introduced:

- `Explain how to add HTTPS to XMLRPC <https://dev.opennebula.org/issues/5257>`__.
- `Force even memory values for MEM attribute <https://dev.opennebula.org/issues/4801>`__.
- `Wild VMs should import NICs and Disks <https://dev.opennebula.org/issues/5247>`__.

The following issues has been solved in 5.4.3:

- `Gemfile lock for Ubuntu 17.10 <https://dev.opennebula.org/issues/5517>`__.
- `onedb change-body should not include volatile AR parameters <https://dev.opennebula.org/issues/5492>`__.
- `onedb purge-history only works with VMs with multiple history records in the body <https://dev.opennebula.org/issues/5460>`__.
- `oneacct gives ruby error <https://dev.opennebula.org/issues/5455>`__.
- `Changes of oneadmin password may broke federation/HA log synchronization <https://dev.opennebula.org/issues/5496>`__.
- `Not reseale VNC port when stop the virtual machine <https://dev.opennebula.org/issues/5465>`__.
- `Term is overwritten when the leader is stopped <https://dev.opennebula.org/issues/5451>`__.
- `When importing a slave with higher UID/GID than master, quotas entries prevent synchronization from occuring <https://dev.opennebula.org/issues/5450>`__.
- `sql opennebula.logdb table grows indefinitely in solo mode <https://dev.opennebula.org/issues/5432>`__.
- `Fix user oned's session cache for users <https://dev.opennebula.org/issues/5425>`__.
- `After importing wild VM with an unavailable VNC por it throws an error but the VM is stuck in HOLD <https://dev.opennebula.org/issues/5356>`__.
- `Warn user (or throw error) when VNET does not exist when instantiating <https://dev.opennebula.org/issues/4967>`__.
- `Do not include both tm_common.sh and scripts_common.sh <https://dev.opennebula.org/issues/5329>`__.
- `Snapshots of non-persistent images are not deleted on VM termination <https://dev.opennebula.org/issues/5063>`__.
- `OneFlow sends a delete to VMs if terminate fails <https://dev.opennebula.org/issues/5397>`__.
- `Scheduler cannot handle hosts with more than 2TB memory <https://dev.opennebula.org/issues/5110>`__.
- `Script injection in SPICE viewer (only Firefox) <https://dev.opennebula.org/issues/5502>`__.
- `IMAGE_UNAME field must be quoted when adding files in the context section <https://dev.opennebula.org/issues/5500>`__.
- `Can't change vcenter credentials <https://dev.opennebula.org/issues/5480>`__.
- `Can not select English language, if default language is set to another one <https://dev.opennebula.org/issues/5478>`__.
- `"VM.create_dialog: false" is not disables plus button on dashboard widget <https://dev.opennebula.org/issues/5471>`__.
- `Importing vcenter resources without any Host <https://dev.opennebula.org/issues/5459>`__.
- `VDC resources are not being retrieved properly in Sunstone <https://dev.opennebula.org/issues/5447>`__.
- `Linked clones are always created when importing templates <https://dev.opennebula.org/issues/5429>`__.
- `Import templates discards linked clones value <https://dev.opennebula.org/issues/5416>`__.
- `Problem with IE11 and current (5.4) <https://dev.opennebula.org/issues/5311>`__.
- `Import datastores without any vcenter cluster <https://dev.opennebula.org/issues/5458>`__.
- `vCenter automatic_vlan_id does not work <https://dev.opennebula.org/issues/5418>`__.
- `vCenter VM can have different NIC MAC than requested <https://dev.opennebula.org/issues/5413>`__.
- `vCenter VM NICs pointing to the same network are not correctly identified <https://dev.opennebula.org/issues/5286>`__.
