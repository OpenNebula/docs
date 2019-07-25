.. _whats_new:

================================================================================
What's New in 5.10
================================================================================

..
   Conform to the following format for new features.
   Big/importan features follow this structure
   - **<feature title>**: <one-to-two line description>, :ref:`<link to docs`
   Minor features are added in a separate block in each section as:
   - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.


OpenNebula Core
================================================================================
- **Update hashing algorithm**, now passwords and login tokens are hashed using sha256 instead of sha1. Also csrftoken is now hashed with SHA256 instead of MD5
- **NUMA and CPU pinning**, you can define virtual NUMA topologies and pin them to specific hypervisor resources. NUMA and pinning is an important feature to improve the performance of specific workloads. :ref:`You can read more here <numa>`.

Other minor features in OpenNebula core:

- `FILTER is now a VM_RESTRICTED attribute <https://github.com/OpenNebula/one/issues/3092>`__.
- `Increase size of indexes (log_index and fed_index) of logdb table from int to uint64 <https://github.com/OpenNebula/one/issues/2722>`__.

Storage
--------------------------------------------------------------------------------
- **Custom block size for Datablocks**, to allow users to modify block size for dd commands used for :ref:`Ceph <ceph_ds>`, :ref:`Fs <fs_ds>` and :ref:`LVM datastore drivers <lvm_drivers>`.
- **Configurable VM monitoring**, you can configure the frecuency to monitor VM disk usage in datastores drivers (:ref:`Fs <fs_ds>` and :ref:`LVM <lvm_drivers>`). Check :ref:`the oned.conf reference guide <oned_conf>`.

Networking
--------------------------------------------------------------------------------
- **DPDK Support**, the Open vSwitch drivers include an option to support DPDK datapaths, :ref:`read more here <openvswitch_dpdk>`.
- **Extensible Network Drivers**, You can extend network driver actions with customizable hooks, :ref:`see more details <devel-nm-hook>`.

Sunstone
--------------------------------------------------------------------------------
- :ref:`Added Two Factor Authentication <2f_auth>`.

OneFlow & OneGate
===============================================================================
- :ref:`Option to delete attibutes from VM user template via onegate <onegate_usage>`.

CLI
================================================================================
- :ref:`Add new cli options to allow better output parsing <cli>`. Check **adjust**, **expand** and **size** new options.

Other Issues Solved
================================================================================
- `Fixes an issue that makes the network drivers fail when a large number of secturiy groups rules are used <https://github.com/OpenNebula/one/issues/2851>`_.
- `Remove resource reference from VDC when resource is erased <https://github.com/OpenNebula/one/issues/1815>`_.

