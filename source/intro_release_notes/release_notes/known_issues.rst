.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Network
================================================================================

- Edge Cluster Public IP: NIC_ALIAS on the public network can only be associated to a NIC on the same network.

Drivers - Storage
================================================================================

- **LXC**, XFS formatted disk images are incompatible with the ``fs_lvm`` driver. The image `fails to be mounted <https://github.com/OpenNebula/one/issues/5802>`_ on the host.

Sunstone
================================================================================

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow `these instructions <https://www.parallels.com/blogs/ras/disabling-network-level-authentication/>`__ in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.

- When instantiate a vrouter, the values filled in the form `are not used to replace the corresponding variables in the CONTEXT section <https://github.com/OpenNebula/one/issues/6725>`_ of the corresponding virtual machine.

Install Linux Graphical Desktop on KVM Virtual Machines
================================================================================

OpenNebula uses the ``cirrus`` graphical adapter for KVM Virtual Machines by default. It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver. You can force a VESA mode by configuring the kernel parameter ``vga=VESA_MODE`` in the GNU GRUB configuration file. `Here <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/>`__ you can find the VESA mode numbers. For example, adding ``vga=791`` as kernel parameter will select the 16-bit 1024×768 resolution mode.

vCenter Snapshot Behavior
=================================

VMs in vCenter 7.0 exhibit a new behavior regarding snapshots and disks attach/detach operations. When vCenter 7.0 detects any change in the number of disks attached to a VM, it automatically cleans all the VM snapshots. OpenNebula doesn't take this into account yet, so the snapshots stated by OpenNebula, after a disk attach or disk detach, point to a null vCenter reference, and cannot be used. Please bear in mind that the vCenter driver is a legacy component, and is included in the distribution but no longer receives updates or fixes.

Warning when Exporting an App from the Marketplace Using CLI
================================================================================

When exporting an application from the marketplace using the CLI the following warning can be seen:

.. prompt:: bash $ auto

    /usr/lib/one/ruby/opennebula/xml_element.rb:124: warning: Passing a Node as the second parameter to Node.new is deprecated. Please pass a Document instead, or prefer an alternative constructor like Node#add_child. This will become an error in a future release of Nokogiri.

This is harmless and can be discarded, it will be addressed in future releases.

Contextualization
=================

- ``GROW_ROOTFS`` and ``GROW_FS`` will not extend btrfs filesystems
- ``onesysprep`` does not support Debian 12 yet

Backups
=============

- OpenNebula stores the whole VM Template in a backup. When restoring it some attributes are wiped out as they are dynamic or they need to be re-generated (e.g. IP). However some attributes (e.g. DEV_PREFIX) would be better to keep them. It is recommended to review and adjust the resulting template for any missing (and required) attribute. The :ref:`list of attributes removed can be checked here <vm_backups_restore>`.

Market proxy settings
================================================================================

- The option ``--proxy`` in the ``MARKET_MAD`` may not be working correctly. To solve it, execute ``systemctl edit opennebula`` and add the following entries:

.. prompt:: bash $ auto

  [Service]
  Environment="http_proxy=http://proxy_server"
  Environment="https_proxy=http://proxy_server"
  Environment="no_proxy=domain1,domain2"

Where ``proxy_server`` is the proxy server to be used and ``no_proxy`` is a list of the domains or IP ranges that must not be accessed via proxy by opennebula. After that, reload systemd service configuration with ``systemctl daemon-reload`` and restart opennebula with a ``systemctl restart opennebula``
