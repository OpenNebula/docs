.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Network
=======================

If the nic-attach fails due to libvirt bug (VM can not eject cdrom after reset) the nic appears in the VM (although without proper configuration) but it's not visible on OpenNebla VM `#5268 <http://dev.opennebula.org/issues/5268>`_

High Availability
=================
HA server configuration synchronization by command `onezone serversync` do not work for PostgreSQL and SQLite DB backend