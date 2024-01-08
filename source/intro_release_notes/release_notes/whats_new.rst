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

API and CLI
================================================================================

KVM
================================================================================

Features Backported to 6.8.x
================================================================================


Other Issues Solved
================================================================================
- `Fix for systemd unit files in the part responsible for log compression <https://github.com/OpenNebula/one/issues/6282>`__.
- `Fix [FSunstone] multiple issues with image pool view <https://github.com/OpenNebula/one/issues/6380>`__.
