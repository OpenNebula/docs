.. _whats_new:

================================================================================
What's New in 6.2
================================================================================

OpenNebula 6.4 XXX is ...

..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- VM snaphots size are highly overestimated. Count snapshot size only as fraction of original disk size. :ref:`See settings in oned.conf <oned_conf_datastores>`.
- VM logs can be generated in the VM folder (``/var/lib/one/vms/<VMID>/``). This make it easier to keep VM.logs in sync in multi-master installations, :ref:`see more details here <frontend_ha_shared>`.

Networking
================================================================================
- Security Groups can be added or removed from a VM network interface, if the VM is running it updates the associated rules.

vCenter Driver
================================================================================
- Configuration flag for :ref:`image persistency<driver_tuning>` of imported Wild VMs or VM Templates.

Sunstone
================================================================================

FireEdge
================================================================================

CLI
================================================================================
- New commands to :ref:`attach/detach Security Group <vm_guide2_sg_hotplugging>` to Virtual Machine

Distributed Edge Provisioning
================================================================================

KVM
===
- NVIDIA vGPU support has been added to KVM driver, :ref:`check this <kvm_vgpu>` for more information.

LXC
===
- `Mount options for Storage Interfaces <https://github.com/OpenNebula/one/issues/5429>`__.

Other Issues Solved
================================================================================
- `Snapshot space are not taken into account for system DS quota <https://github.com/OpenNebula/one/issues/5524>`__.
- `Fix [packages] oneflow depends on opennebula <https://github.com/OpenNebula/one/issues/5391>`__.
- `Fix object permissions when running "onedb fsck" <https://github.com/OpenNebula/one/issues/5202>`__.
- `Allow updating OneFlow Services without specifying the "registration_time" field. <https://github.com/OpenNebula/one/issues/5759>`__.

Features Backported to 6.2.x
============================

Additionally, a lot of new functionality is present that was not in OpenNebula 6.2.0, although they debuted in subsequent maintenance releases of the 6.2.x series:
