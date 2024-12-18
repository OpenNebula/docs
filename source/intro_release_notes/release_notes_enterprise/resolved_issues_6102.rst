.. _resolved_issues_6102:

Resolved Issues in 6.10.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/80?closed=1>`__.

The following new features have been backported to 6.10.2:

- `Add support for VLAN filtering to the Linux bridge drivers <https://github.com/OpenNebula/one/issues/6669>`__. This allows to limit the VLANs in trunk mode, as well as in QinQ mode. For more information check the :ref:`bridge driver <bridged>` and the :ref:`802.1Q VLAN driver <hm-vlan>` documentation guides.

The following issues has been solved in 6.10.2:

- `Fix bug in the DS Ceph driver: set the value for the --keyfile to CEPH_KEY instead of CEPH_USER in the export operation <https://github.com/OpenNebula/one/issues/6791>`__.
- `Fix GOCA OS vector attribute to include FIRMWARE, FIRMWARE_SECURE, UUID and SD_DISK_BUS <https://github.com/OpenNebula/one/issues/6782>`__.
- `Fix PyOne installation through pip <https://github.com/OpenNebula/one/issues/6784>`__.
- `Fix the list of attibutes that can be overriden in vmm_exec_kvm.conf <https://github.com/OpenNebula/one/issues/6548>`__.
- `Fix a rare crash in 'onedb fsck' caused by a locked MarketPlaceApp in a federated environment <https://github.com/OpenNebula/one/issues/6793>`__.
- `Fix iotune attributes not being passed to VM if value is a big number <https://github.com/OpenNebula/one/issues/6750>`__.
- `Fix SecurityGroup rule validation logic to include additional checks for port ranges <https://github.com/OpenNebula/one/issues/6759>`__.
- `Fix KVM domain definition to set up CPU affinity to the auto-selected NUMA node when using huge pages without CPU pinning <https://github.com/OpenNebula/one/issues/6185>`__.
- `Fix multiple problems with QEMU Guest Agent monitoring <https://github.com/OpenNebula/one/issues/6765>`__. Additional monitor commands for the qemu-agent probe are `shown here <https://github.com/OpenNebula/one/blob/master/src/im_mad/remotes/kvm-probes.d/guestagent.conf>`__. You can add them to your existing 6.10 configuration files.
- `Fix Checkpoint file is not always cleaned up on VM Action <https://github.com/OpenNebula/one/issues/6729>`__.
- `Fix Set NEXT_SNAPSHOT=1 for persistent images <https://github.com/OpenNebula/one/issues/6600>`__.
- `Fix Restored disks of VM additional disks does not show the real size of the original disk <https://github.com/OpenNebula/one/issues/6734>`__.

The following issues have been solved in the Sunstone Web UI:

- `Fix DEV_PREFIX wrong when using Sunstone <https://github.com/OpenNebula/one/issues/6817>`__.
- `Fix Sunstone host graph not showing information <https://github.com/OpenNebula/one/issues/6788>`__.
- `Fix number of instances ignored in service instantiation <https://github.com/OpenNebula/one/issues/6716>`__.
- `Fix Sunstone filter VMs on "Locked" gives empty white page <https://github.com/OpenNebula/one/issues/6768>`__.
- `Fix missing boot order selector <https://github.com/OpenNebula/one/issues/6757>`__.