.. _whats_new:

================================================================================
What’s New in |version|
================================================================================

.. Attention: Substitutions doesn't work for emphasized text

**OpenNebula 6.10 “Bubble”** is the sixth stable release of the OpenNebula 6 series. This new release features the first complete implementation of the Sunstone UI functionality on the FireEdge server, as well as improvements in backups, support for new versions of operating systems for the Front-end node, new features included in the Community Edition, and streamlining by removing obsolete or little-used components, or providing them as legacy components.

The first major highlight in this release is the new Sunstone UI. The full power of OpenNebula’s web UI is now provided by the FireEdge server, which delivers the complete set of features previously offered by legacy Ruby-based Sunstone. The new Sunstone UI brings a clean, fast, highly-customizable and easy-to-use UI.

.. image:: /images/sunstone-full_dashboard.png
   :align: center
   :scale: 60%

The Sunstone UI provided by FireEdge is now the default. The Ruby-based Sunstone UI is included in this release as a legacy component, but will not be updated with new features or receive maintenance, and will be removed in a future release.

The second highlight in this release is improved backup functionality, thanks to the addition of the **in-place restore** backup mode. This feature replaces the old procedure for restoring a VM from a backup, and allows you to replace the disks of a VM with a backup copy without manually generating new images and VM templates. The feature is available through the CLI and the Sunstone UI, where it can be easily accessed in the Host controls for the selected VM (in **Instances** -> **VMs**).

This release also includes myriad improvements in core functionality, the API and CLI; such as support for PCI attach and detach operations, improved OneFlow message logging, and new functionality for searching for VMs.

Finally, OpenNebula is being streamlined by removing obsolete or little-used components. The following table lists components no longer included in the OpenNebula distribution, as well as their alternative components:

+-----------------------+--------------------------------------------------------------------+
| Component             | Alternative                                                        |
+=======================+====================================================================+
| LXD driver            | :ref:`LXC <market_linux_container>`                                |
+-----------------------+--------------------------------------------------------------------+
| Firecracker driver    | :ref:`KVM <kvmg>`                                                  |
+-----------------------+--------------------------------------------------------------------+
| Docker Machine        | `OneKE <https://github.com/OpenNebula/one-apps/wiki/oneke_intro>`_ |
+-----------------------+--------------------------------------------------------------------+
| DockerHub Marketplace | `OneKE <https://github.com/OpenNebula/one-apps/wiki/oneke_intro>`_ |
+-----------------------+--------------------------------------------------------------------+
| Docker Registry       | `OneKE <https://github.com/OpenNebula/one-apps/wiki/oneke_intro>`_ |
+-----------------------+--------------------------------------------------------------------+
| TurnkeyLinux          | :ref:`LXC <market_linux_container>`                                |
+-----------------------+--------------------------------------------------------------------+
| PostgreSQL - TP       | :ref:`MySQL <mysql_setup>`                                         |
+-----------------------+--------------------------------------------------------------------+

The components in the table below are now included in the distribution as legacy components. They no longer receive updates or bug fixes, and will be removed in future releases:

+----------------+------------------------------+
| Component      | Documentation                |
+================+==============================+
| Ruby Sunstone  | :ref:`ruby_sunstone`         |
+----------------+------------------------------+
| vCenter driver | :ref:`legacy_vcenter_driver` |
+----------------+------------------------------+

For the full documentation please refer to the :ref:`Legacy Components <legacy_components>` section.

Beginning on version 6.10, users of the :ref:`Community Edition <what_is_community>` will be able to access two features previously only available in the Enterprise Edition:

   * **Backups** using `Restic <https://restic.net/>`__, an open-source backup program designed for speed and security. The Community Edition now includes the possibility of using Restic as a backend for backup operations.
   * **System monitoring** using `Prometheus <https://prometheus.io/>`__, a set of open-source monitoring and alerting tools. The Community edition now includes the possibility of using Prometheus as a backend for monitoring infrastructure.

OpenNebula 6.10 is named after the `Bubble Nebula <https://www.constellation-guide.com/bubble-nebula-ngc-7635/>`__ (NGC 7635) in the constellation Cassiopeia. It is a young, glowing emission nebula energized by a hot, massive central star. Partly located in a group of stars between 7000 and 8000 light-years away from Earth, the Bubble Nebula is in expansion, with a central “bubble” measuring between six and ten light-years and an estimated temperature of more than 37,000 degrees Celsius (67,000 Fahrenheit). It was discovered by the celebrated astronomer William Herschel in 1787.

.. important:: This is the first beta version for 6.10, intended for testers and developers to try the new features. All new functionality is present in this release, and only bug fixes will be implemented between this release and the final 6.10 version. Please check the `known issues <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__ before submitting an issue through GitHub. Also note that being a development version, there is no migration path from the previous stable version (6.8.x) nor migration path to the final stable version (6.10.0). A list of open issues may be found at the `GitHub development portal <https://github.com/OpenNebula/one/milestone/76>`__.

We’d like to thank all the people that :ref:`support the project<acknowledgements>`, OpenNebula is what it is thanks to its community! Please keep rocking.

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
- `Fix the Restic Password with special characters cause restore to fail <https://github.com/OpenNebula/one/issues/6571>`__.

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
