.. _resolved_issues_5104:

Resolved Issues in 5.10.4
--------------------------------------------------------------------------------

A complete list of solved issues for 5.10.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/34>`__.

The following new features has been backported to 5.10.4:

- `Pyone, the Python API binding for OpenNebula, is now thread-safe <https://github.com/OpenNebula/one/issues/4236>`__.
- `Support for volatile disks on LXD <https://github.com/OpenNebula/one/issues/3297>`__.
- `Improve CLI filter operators handling <https://github.com/OpenNebula/one/issues/2506>`__.

The following issues has been solved in 5.10.4:

- `Fix default encoding when table encoding is not detected <https://github.com/OpenNebula/one/issues/4329>`__.
- `Fix Graphics when update VM template in Sunstone <https://github.com/OpenNebula/one/issues/4278>`__.
- `Fix Scheduling when update VM template in Sunstone <https://github.com/OpenNebula/one/issues/4274>`__.
- `Fix error messages when using onedb update-body <https://github.com/OpenNebula/one/issues/4337>`__.
- `Fix error in fsck when vnet lease has no ID <https://github.com/OpenNebula/one/issues/4328>`__.
- `Fix VMs & Images datatables in Sunstone <https://github.com/OpenNebula/one/issues/1388>`__.
- `Fix labels when service updating in Sunstone <https://github.com/OpenNebula/one/issues/4273>`__.
- `Fix ACLs check permissions when creating a template <https://github.com/OpenNebula/one/issues/4352>`__.
- `Fix create group with no permissions <https://github.com/OpenNebula/one/issues/3361>`__.
- `Fix NIC aliases are not working with NETWORK_SELECT = "NO" <https://github.com/OpenNebula/one/issues/4378>`__.
- `Fix uid and gid of new VMs when scaling a service <https://github.com/OpenNebula/one/issues/4406>`__.
- `Fix scheduler action are not working with END_TYPE = 0 <https://github.com/OpenNebula/one/issues/4380>`__.
- `Fix address range dialog when instantiate a VNet <https://github.com/OpenNebula/one/issues/4393>`__.
- `Fix display Roles in Service <https://github.com/OpenNebula/one/issues/4428>`__.
- `Fix installing augeas gem in Debians <https://github.com/OpenNebula/one/issues/4426>`__.
- `Fix required IPv4 when IPAM driver is selected <https://github.com/OpenNebula/one/issues/3615>`__.
- `Do not allow user to increase his privileages to manage VMs <https://github.com/OpenNebula/one/issues/4416>`__.
- `Do not allow wrong string in VM_*_OPERATIONS attribute <https://github.com/OpenNebula/one/issues/4417>`__.
