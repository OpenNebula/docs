.. _resolved_issues_6103:

Resolved Issues in 6.10.3
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/81?closed=1>`__.

The following new features have been backported to 6.10.3:

- Added support for the new NVIDIA mediated devices framework introduced in Ubuntu 24.04. The legacy method remains unaffected by this new feature. For more details, see the :ref:`NVIDIA vGPU documentation <kvm_vgpu>`.
- `Added capability to change CPU_MODEL/FEATURES with one.vm.updateconf request <https://github.com/OpenNebula/one/issues/6636>`__.
- `Added new cli command onevm snapshot-list <https://github.com/OpenNebula/one/issues/6623>`__.
- `Added support for auto keywork to set NIC virtio queues, same as DISK attribute <https://github.com/OpenNebula/one/issues/6435>`__.
- `Increment_flatten operation is executed using qemu-img commit instead of qemu-img convert <https://github.com/OpenNebula/one/issues/6547>`__.

The following issues has been solved in 6.10.3:

- `Fix an error when downloading images from HTTP-based marketplaces caused by a missing trailing slash in the ENDPOINT attribute <https://github.com/OpenNebula/one/issues/6619>`__.
- `Fix an error when detecting the logical volume filesystem of a LXC VM <https://github.com/OpenNebula/one/issues/6852>`__.
- `Fix an error with mapping qcow2 overlays with the LXC driver <https://github.com/OpenNebula/one/issues/6848>`__.
- `Fix VM cluster ID after moving host to different cluster <https://github.com/OpenNebula/one/issues/2226>`__.
- `Fix corrupted quota after VM deploy and recover --recreate actions, in case RUNNING quota is exceeded <https://github.com/OpenNebula/one/issues/6823>`__.
- `Fix onetemplate instantiate cli options to not override the whole CONTEXT attribute <https://github.com/OpenNebula/one/issues/6828>`__.
- `Fix VM save duplicate disks in target template <https://github.com/OpenNebula/one/issues/6831>`__.
- `Fix reset backup failed after restore individual disk on the VM <https://github.com/OpenNebula/one/issues/6741>`__.
- `Fix SPARSE attribute ignored on resize operation <https://github.com/OpenNebula/one/issues/6583>`__.
- `Fix incorrect error message when registering a non-existing or non-accessible image file <https://github.com/OpenNebula/one/issues/2109>`__.

The following issues have been solved in the Sunstone Web UI:

- `Fix currency symbol not displaying <https://github.com/OpenNebula/one/issues/6846>`__.
- `Fix making available "Flush" button on FSunstone to resched all VMs in another hosts <https://github.com/OpenNebula/one/issues/6763>`__.
- `Fix dettach disk or nic is disabled in regular users <https://github.com/OpenNebula/one/issues/6820>`__.
- `Fix wrong user groups being displayed <https://github.com/OpenNebula/one/issues/6794>`__.
- `Fix service template role name validation <https://github.com/OpenNebula/one/issues/6816>`__.
- `Fix missing IP/MAC spoofing switch <https://github.com/OpenNebula/one/issues/6806>`__.
- `Fix datastore, host and vnets tables in provision <https://github.com/OpenNebula/one/issues/6815>`__.
- `Fix actions in apps when the user select an app from Marketplace <https://github.com/OpenNebula/one/issues/6714>`__.
- `Fix spoofing and security groups filters for traffic addressed to the hypervisor <https://github.com/OpenNebula/one/issues/6704>`__.
- `Fix select datastore when importing app after validation error <https://github.com/OpenNebula/one/issues/6724>`__.
- `Fix info about costs when instantiate a vm in Sunstone <https://github.com/OpenNebula/one/issues/6639>`__.
- `Fix vnet review in Sunstone <https://github.com/OpenNebula/one/issues/6833>`__.
- `Fix allowed VM action states <https://github.com/OpenNebula/one/issues/6830>`__.
- `Fix select a network should be first than Advanced options when attaching a NIC <https://github.com/OpenNebula/one/issues/6728>`__.
- `Fix VM host placement <https://github.com/OpenNebula/one/issues/6845>`__.
- `Fix VM update configuration dialog <https://github.com/OpenNebula/one/issues/6844>`__.
- `Fix missing vGPU profile selector <https://github.com/OpenNebula/one/issues/6293>`__.
- `Fix list view crash in images tab <https://github.com/OpenNebula/one/issues/6839>`__.
- `Fix add auto switch for NIC transmission queues <https://github.com/OpenNebula/one/issues/6435>`__.
- `Fix creating security group within Virtual Network <https://github.com/OpenNebula/one/issues/6786>`__.
- `Fix PCI tab errors on host details <https://github.com/OpenNebula/one/issues/6814>`__.
- `Fix Add PCI tab when instantiate a vm <https://github.com/OpenNebula/one/issues/6799>`__.
- `Fix VNC button appears on VMs without VNC configuration <https://github.com/OpenNebula/one/issues/6861>`__.
- `Fix VM template update does not modify IMAGE_ID <https://github.com/OpenNebula/one/issues/6895>`__.
