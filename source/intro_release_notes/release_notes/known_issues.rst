.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Storage
===============================================================================

- As `part of the improvement of sparse file management <https://github.com/OpenNebula/one/issues/5058>`_ the file system datastore drivers use fallocate. Be aware that some filesystems may not implement fallocate(2), a `fix to deal with this situation has been committed here <https://github.com/OpenNebula/one/commit/ead26711f1611653ec40f565849b9ab373745a11>`__.

- The restore operation of a backup may cause the restored VM to get stuck in ``clone`` state. In this case, if the restored images are not in ``lock`` state you can simple terminate the VM and instantiate it again. A `fix that prevents this from happening is available here <https://github.com/OpenNebula/one/commit/3333b780ce6e3a757b595bd96aac6688a2a97e0f>`__.

- **Ceph**, OpenNebula 6.0 uses a consistent format scheme that reduces the need of setting ``DRIVER`` and ``FORMAT`` attributes. However existing images in Ceph Datastores may have a wrong value for these attributes. If the usage of these Images fails after upgrading to OpenNebula 6.0, please update Images in Ceph datastores to have ``FORMAT`` and ``DRIVER`` set to ``raw``. If any running VM is affected by this, ``onedb update-body`` command can be used for changing the corresponding values for the VM disks.

- **LVM**, the situation described above for Ceph may also affect LVM based datastores, please verify that ``FORMAT`` and ``DRIVER`` are set to ``raw``.

- **LVM**, terminate a VM in undeployed state is broken, the result is different if persistent images are used or not. A detailed explanation can be found `here <https://github.com/OpenNebula/one/issues/5385>`__.

Drivers - Network
================================================================================

- If the nic-attach fails due to the libvirt bug (VM can not eject CD-ROM after reset) the nic appears in the VM (although without proper configuration) but it's not visible on OpenNebula VM `#5268 <http://github.com/OpenNebula/one/issues/5268>`_
- Edge Cluster Public IP: NIC_ALIAS on the public network can only can only be associated to a NIC on the same network.

High Availability
================================================================================

HA server configuration synchronization with the command `onezone serversync` does not work for the PostgreSQL and SQLite DB Back-end

Sunstone
================================================================================

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow `these instructions <https://www.parallels.com/blogs/ras/disabling-network-level-authentication/>`__ in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.
- When vCenter mode selected on sunstone-server.conf, Sunstone won’t let the users create images. You can add the following entries to the yaml files in `/etc/one/sunstone_views/vcenter` to add the functionality:

   .. prompt:: yaml $ auto

      template_creation_tabs:
         image: true
         docker: true

Install Linux Graphical Desktop on KVM Virtual Machines
================================================================================

OpenNebula uses the ``cirrus`` graphical adapter for KVM Virtual Machines by default.
It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver.
You can force a VESA mode by configuring the kernel parameter ``vga=VESA_MODE`` in the GNU GRUB configuration file.
`Here <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/>`__ you can find the VESA mode numbers.
For example, adding ``vga=791`` as kernel parameter will select the 16-bit 1024×768 resolution mode.

Authentication issue
================================================================================

Because of a FireEdge vulnerability present in OpenNebula 6.0 (which has been fixed in `OpenNebula 6.0.1 and 6.0.0.1 <https://forum.opennebula.io/t/ee-6-0-1-and-ce-6-0-0-1-available-for-download/9468>`__) login tokens were created automatically with the same value of the password. This results in an authentication problem once the token expires as ``oned`` will recognize the password as an expired token and won’t authenticate the user.

.. important:: This issue will only affect users that have logged in Sunstone or FireEdge using OpenNebula 6.0.0.

In order to recover the users ``oneuser token-delete-all`` and ``oneuser token-delete`` commands can be used for removing the token. If ``oneadmin`` user is affected by this and there's no other user belonging to ``oneadmin`` group that can remove its tokens, the corresponding record in the database has to be updated removing the token:

   - Get the body of ``oneadmin`` user: ``SELECT body FROM user_pool WHERE oid = 0``.
   - Remove the ``LOGIN_TOKEN`` section from it.
   - Update the ``oneadmin`` body: ``UPDATE user_pool SET body = '<new_body>' WHERE oid = 0``.

.. note:: It's recommended to create a DB backup before manually modifying it.

vCenter 7.0 Snapshot behavior
=================================

VMs in vCenter 7.0 exhibit a new behavior regarding snapshots and disks attach/detach operations. When vCenter 7.0 detects that any change in the number of disks attached to a VM, it automatically cleans all the VM snapshots. OpenNebula doesn't take this into account yet, so the snapshots stated by OpenNebula, after a disk attach or disk detach, are pointing to a null vCenter reference, and as such, cannot be used. Please keep this in mind before a solution is implemented.
