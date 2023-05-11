.. _resolved_issues_662:

Resolved Issues in 6.6.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.6.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/66?closed=1>`__.

The following new features has been backported to 6.6.2:

- `Graceful stop of ongoing backup operations <https://github.com/OpenNebula/one/issues/6030>`__.
- `Add support Centos 8 Stream, Amazon Linux and Opensuse <https://github.com/OpenNebula/one/issues/3178>`__.
- `Add ability to pin the virtual CPUs and memory of a VM to a specific host NUMA node <https://github.com/OpenNebula/one/issues/5966>`__.
- `Hugepages can be used without CPU pinning <https://github.com/OpenNebula/one/issues/6185>`__.
- `Add remote authorization support in FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6112>`__.

The following issues has been solved in 6.6.2:

- `Fix default scheduler NIC policies <https://github.com/OpenNebula/one/issues/6149>`__.
- `Fix error when disabling the FireEdge configuration attributes in sunstone-server.conf <https://github.com/OpenNebula/one/issues/6163>`__.
- `Fix datastore driver actions error: argument list too long <https://github.com/OpenNebula/one/issues/6162>`__.
- `Fix termination time for scheduled actions with repeat times <https://github.com/OpenNebula/one/issues/6181>`__.
- `Fix LinuxContainers marketplace monitoring <https://github.com/OpenNebula/one/issues/6184>`__.
- `Improve VM HA hook script host_error.rb to skip VMs deployed on local datastores <https://github.com/OpenNebula/one/issues/6099>`__.
- `Fix disk_type and source for block CD <https://github.com/OpenNebula/one/issues/6140>`__.
- `Fix Address Range IP6_END value <https://github.com/OpenNebula/one/issues/6156>`__.
- `Fix restore dialog to properly set restore options <https://github.com/OpenNebula/one/issues/6187>`__.
- `Reordering the schedule actions creation mode <https://github.com/OpenNebula/one/issues/6091>`__.
- `Fix locks under certain condition while doing backup operations <https://github.com/OpenNebula/one/issues/6199>`__.
- `Fix error when making the first incremental backup in a VM in poweroff state <https://github.com/OpenNebula/one/issues/6200>`__.
- `Fix fsck for backup images <https://github.com/OpenNebula/one/issues/6195>`__.
- `Fix missing actions in Firecracker driver <https://github.com/OpenNebula/one/issues/6173>`__.
- `Fix some LinuxContainers marketplace applications failing to auto-contextualize <https://github.com/OpenNebula/one/issues/6190>`__.
