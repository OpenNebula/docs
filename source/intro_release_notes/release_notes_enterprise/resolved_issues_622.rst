.. _resolved_issues_622:

Resolved Issues in 6.2.2
--------------------------------------------------------------------------------


A complete list of solved issues for 6.2.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/57?closed=1>`__.

The following new features has been backported to 6.2.2:

- `Make EXPIRE_DELTA and EXPIRE_MARGIN configurable for CloudAuth <https://github.com/OpenNebula/one/issues/5046>`__.
- `Support new CentOS variants on LXC Marketplace <https://github.com/OpenNebula/one/issues/3178>`__.
- `Allow to order and filter vCenter imports when using the vCenter Import Tool <https://github.com/OpenNebula/one/issues/5735>`__.
- `Show scheduler error message on Sunstone <https://github.com/OpenNebula/one/issues/5744>`__.
- `Add error condition to Sunstone list views <https://github.com/OpenNebula/one/issues/5745>`__.
- `Better live memory resize for KVM <https://github.com/OpenNebula/one/issues/5753>`__. **Note**: You need to do a power cycle for those VMs you want to resize its memory after the upgrade.
- :ref:`Add Q-in-Q support for Open vSwtich driver <openvswitch_qinq>`.
- :ref:`Add MTU support for Open vSwtich driver <openvswitch>`.
- `Filter Datastores and Networks by Host on VM instantiation <https://github.com/OpenNebula/one/issues/5743>`__.
- :ref:`Automatically create VM template in Vcenter when exporting an app from marketplace <vcenter_market>`.
- `Improve capacity range feedback in Sunstone <https://github.com/OpenNebula/one/issues/5757>`__.
- `VM pool list documents include ERROR and scheduler messages so they can be added to list views (e.g. Sunstone) <https://github.com/OpenNebula/one/issues/5761>`__.
- `Support for cgroup2 on the LXC Driver <https://github.com/OpenNebula/one/issues/5599>`__.
- `Support for CPU Pinning using NUMA Topology on the LXC Driver <https://github.com/OpenNebula/one/issues/5506>`__.
- `Memory management improvements similar to LXD defaults on the LXC driver <https://github.com/OpenNebula/one/issues/5621>`__.

The following issues has been solved in 6.2.2:

- `Fix Sunstone does not use remote host for memcache-dalli <https://github.com/OpenNebula/one/issues/5156>`__.
- `Fix VCPU_MAX and MEMORY_MAX value when disabling hot resize <https://github.com/OpenNebula/one/issues/5451>`__.
- `Fix Sunstone login cookie expire time <https://github.com/OpenNebula/one/issues/5730>`__.
- `Fix OneFlow CLI is broken when using username and password <https://github.com/OpenNebula/one/issues/5413>`__.
- `Fix --as_gid and --as_uid arguments are not available for onevm create command <https://github.com/OpenNebula/one/issues/4969>`__.
- `Fix Services in WARNING state do not go back to RUNNING when the VMs are DONE <https://github.com/OpenNebula/one/issues/5532>`__.
- `Fix OneFlow CLI utility is not aware of the current zone <https://github.com/OpenNebula/one/issues/5396>`__.
- `Fix vCenter disk mapping could lead to VM disk deletion <https://github.com/OpenNebula/one/issues/5740>`__.
- `Fix VMs list after render virtual network leases in Sunstone <https://github.com/OpenNebula/one/issues/5747>`__.
- `Fix import only resources from local zone in Sunstone <https://github.com/OpenNebula/one/issues/5736>`__.
- `Fix HA recovery hooks for Ceph and SAN (LVM) datastores <https://github.com/OpenNebula/one/issues/5653>`__.
- `Fix vSphere 7.0 erases snapshots on disk change <https://github.com/OpenNebula/one/issues/5409>`__.
- `Fix OneFlow Services perform action in Sunstone <https://github.com/OpenNebula/one/issues/5758>`__.
- `Fix disk size not showing correctly in Sunstone <https://github.com/OpenNebula/one/issues/5560>`__.
- `Fix scheduler message that contains double quotes <https://github.com/OpenNebula/one/issues/5762>`__.
