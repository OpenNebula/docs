.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Network
=======================

- If the nic-attach fails due to the libvirt bug (VM can not eject CD-ROM after reset) the nic appears in the VM (although without proper configuration) but it's not visible on OpenNebla VM `#5268 <http://github.com/OpenNebula/one/issues/5268>`_
- Edge Cluster Public IP: NIC_ALIAS on the public network can only can only be associated to a NIC on the same network.

High Availability
=================
HA server configuration synchronization with the command `onezone serversync` does not work for the PostgreSQL and SQLite DB Back-end

Sunstone
================================================================================

- Remote connections to Guacamole from Sunstone have a mouse related issue, however noVNC can still be used if needed.
- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow `these instructions <https://www.parallels.com/blogs/ras/disabling-network-level-authentication/>`__ in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.
