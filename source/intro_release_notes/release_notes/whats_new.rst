.. _whats_new:

================================================================================
What's New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 7.0 ‘’** is the fifth stable release of the OpenNebula 6 series. This version of OpenNebula focuses on features to improve the end user experience as well as to optimize the use of the HW resources in KVM-based infrastructures.

We’d like to thank all the people that :ref:`support the project<acknowledgements>`, OpenNebula is what it is thanks to its community! Please keep rocking.

OpenNebula Core
================================================================================
- **Generic Quotas**: Option to specify :ref:`custom quotas for OpenNebula VMs, <quota_auth_generic>`
- **PCI attach/detach**: generic PCI devices (e.g. GPU/vGPUs) now support :ref:`attach and detach operations <vm_guide2_pci>` in poweroff and undeployed states. Note that this functionality (in any state) is already present for NIC PCI passthrough/SRIOV devices.

Storage & Backups
================================================================================

FireEdge Sunstone
================================================================================

- Implemented VM Groups tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Backup Jobs tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Groups tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented restricted attributes on Images and Virtual Networks in :ref:`Restricted Attributes <oned_conf_restricted_attributes_configuration>`.
- Implemented ACL tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Cluster tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented OneFlow tabs in :ref:`FireEdge Sunstone <fireedge_sunstone>`.

API and CLI
================================================================================


KVM
================================================================================

Features Backported to 6.8.x
================================================================================

- For VMs with resched flag add ``HOST_ID`` to :ref:`External Scheduler API <external_scheduler>`.

Other Issues Solved
================================================================================

- `Fix for systemd unit files in the part responsible for log compression <https://github.com/OpenNebula/one/issues/6282>`__.
- `Fix sudoers path for systems tools to point to /usr/sbin for Debian OS <https://github.com/OpenNebula/one/issues/5909>`__.

Also, the following issues have been solved in the FireEdge Sunstone Web UI:

- `Fix multiple issues with image pool view <https://github.com/OpenNebula/one/issues/6380>`__.
- `Fix User Input list sorting error <https://github.com/OpenNebula/one/issues/6229>`__.
- `Fix missing host subtabs <https://github.com/OpenNebula/one/issues/6490>`__.
- `Fix VM action buttons respond to state updates <https://github.com/OpenNebula/one/issues/6384>`__.
