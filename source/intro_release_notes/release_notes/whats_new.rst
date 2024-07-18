.. _whats_new:

================================================================================
What's New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 6.10 ‘’** is the fifth stable release of the OpenNebula 6 series. This version of OpenNebula focuses on features to improve the end user experience as well as to optimize the use of the HW resources in KVM-based infrastructures.

..
   * Sunstone -> FSunstone. Fully functional, this is now the default
   * Keeping the name, FireEdge is just the front-end.
   * Improvements on Backups
   * Legacy components, we are keeping them but not maintaining them, ie we won't support new relesaes of vCenter for instance, nor adding new functionality to RSunstone


We’d like to thank all the people that :ref:`support the project<acknowledgements>`, OpenNebula is what it is thanks to its community! Please keep rocking.

Remove components, no longer included in the OpenNebula distribution:

- LXD driver
- Firecracker driver
- Docker Machine
- DockerHub Marketplace
- Docker Registry
- TurnkeyLinux
- PostgreSQL - TP

Legacy components, included in the distribution but no longer receive updates or bug fixes:

- Ruby Sunstone
- vCenter Driver

..
   Beta Release
   Bubble Nebula https://en.wikipedia.org/wiki/Bubble_Nebula

OpenNebula Core
================================================================================
- **Generic Quotas**: Option to specify :ref:`custom quotas for OpenNebula VMs, <quota_auth_generic>`
- **PCI attach/detach**: generic PCI devices (e.g. GPU/vGPUs) now support :ref:`attach and detach operations <vm_guide2_pci>` in poweroff and undeployed states. Note that this functionality (in any state) is already present for NIC PCI passthrough/SRIOV devices.
- **Search Virtual Machines**: The new :ref:`JSON search syntax <vm_search>` allow advanced search by ``onevm list --search`` command. It also greatly improves the performance of  searches. See also the :ref:`compatibility notes <compatibility>`.
- **Additional settings at cluster level**: The ``FEATURES`` attribute for ``CPU_MODEL`` can be :ref:`set at cluster level <kvmg_default_attributes>` so all VMs running in a given cluster will use the same CPU features by default.

Storage & Backups
================================================================================
- **In-place restore**: Users now have access to a streamlined operation for restoring VM disk backups directly onto existing VMs, eliminating the need of generating new images and VM templates. For further information, please refer to the :ref:`backup documentation <vm_backups_restore>`.

FireEdge Sunstone
================================================================================

- Implemented VM Groups tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Backup Jobs tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Groups tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented restricted attributes on Images and Virtual Networks in :ref:`Restricted Attributes <oned_conf_restricted_attributes_configuration>`.
- Implemented ACL tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Cluster tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented OneFlow tabs in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Marketplace tab in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Implemented Virtual Router tabs in :ref:`FireEdge Sunstone <fireedge_sunstone>`.
- Improve management of virtual machine templates solving minor issues, simplifying the way to manage alias and adding a new PCI tab to easily manage PCI devices in :ref:`FireEdge Sunstone <fireedge_sunstone>`.

API and CLI
================================================================================
- ``onedb create-index`` command has been removed, a new :ref:`VM search <vm_search>` engine has been implemented to allow flexible queries and improve performance.
- `OneFlow message logging improved <https://github.com/OpenNebula/one/issues/6553>`__.


KVM
================================================================================

Features Backported to 6.8.x
================================================================================

Additionally, the following functionalities are present that were not in OpenNebula 6.8.0, although they debuted in subsequent maintenance releases of the 6.8.x series:

- For VMs with resched flag add ``HOST_ID`` to :ref:`External Scheduler API <external_scheduler>`.
- Option to restore individual disk from backup Image see :ref:`Restoring Backups <vm_backups_restore>`.
- Allow VM recover recreate in poweroff and suspended state, see :ref:`Recover from VM Failures <ftguide_virtual_machine_failures>`.

Other Issues Solved
================================================================================

- `Fix for systemd unit files in the part responsible for log compression <https://github.com/OpenNebula/one/issues/6282>`__.
- `Fix sudoers path for systems tools to point to /usr/sbin for Debian OS <https://github.com/OpenNebula/one/issues/5909>`__.
- `Fix LDAP group athorization for AD <https://github.com/OpenNebula/one/issues/6528>`__.
- `Fix an uncommon error in TM drivers when domfsfreeze hangs indefinitely  <https://github.com/OpenNebula/one/issues/5921>`__.
- `Fix the oneflow and oneflow-template delete functions  <https://github.com/OpenNebula/one/issues/6305>`__.
- `Fix not possible to navigate within almost all VM graphs <https://github.com/OpenNebula/one/issues/6637>`__.

Also, the following issues have been solved in the FireEdge Sunstone Web UI:

- `Fix multiple issues with image pool view <https://github.com/OpenNebula/one/issues/6380>`__.
- `Fix User Input list sorting error <https://github.com/OpenNebula/one/issues/6229>`__.
- `Fix missing host subtabs <https://github.com/OpenNebula/one/issues/6490>`__.
- `Fix VM action buttons respond to state updates <https://github.com/OpenNebula/one/issues/6384>`__.
- `Fix table selection issue <https://github.com/OpenNebula/one/issues/6507>`__.
- `Fix global API timeout configurability <https://github.com/OpenNebula/one/issues/6537>`__.
- `Fix refresh table Host after create a new host <https://github.com/OpenNebula/one/issues/6451>`__.
- `Fix enhance placement tab <https://github.com/OpenNebula/one/issues/6419>`__.
- `Fix change user password on FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6471>`__.
- `Fix separate Vms and vm views <https://github.com/OpenNebula/one/issues/6092>`__.
- `Fix modify "Show All" option on switch group menu <https://github.com/OpenNebula/one/issues/6455>`__.
- `Fix mixed up comments for some of columns in some sunstone views <https://github.com/OpenNebula/one/issues/6562>`__.
- `Fix QoL improvements for ERROR Dismiss popup <https://github.com/OpenNebula/one/issues/6069>`__.
- `Fix detailed view stuck in fullscreen <https://github.com/OpenNebula/one/issues/6613>`__.
- `Fix unnecesary extra step when creating Image <https://github.com/OpenNebula/one/issues/6386>`__.
- `Fix simplified view of the table <https://github.com/OpenNebula/one/issues/6075>`__.
