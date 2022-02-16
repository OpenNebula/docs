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
- NVIDIA vGPU support has been added to KVM driver, :ref:`check this <kvm_vgpu>` for more information.

Networking
================================================================================
- Security Groups can be added or removed from a VM network interface, if the VM is running it updates the associated rules.

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

LXC
===
- `Mount options for Storage Interfaces <https://github.com/OpenNebula/one/issues/5429>`__.

Other Issues Solved
================================================================================
- `Snapshot space are not taken into account for system DS quota <https://github.com/OpenNebula/one/issues/5524>`__.

Features Backported to 6.2.x
============================

Additionally, a lot of new functionality is present that was not in OpenNebula 6.2.0, although they debuted in subsequent maintenance releases of the 6.2.x series:
