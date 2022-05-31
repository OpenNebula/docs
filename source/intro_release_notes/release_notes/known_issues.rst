.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Network
================================================================================

- If the nic-attach fails due to the libvirt bug (VM can not eject CD-ROM after reset) the nic appears in the VM (although without proper configuration) but it's not visible on OpenNebula VM `#5268 <http://github.com/OpenNebula/one/issues/5268>`_
- Edge Cluster Public IP: NIC_ALIAS on the public network can only can only be associated to a NIC on the same network.

Drivers - Storage
================================================================================

- **LXC**, XFS formatted disk images are incompatible with the ``fs_lvm`` driver. The image `fails to be mounted <https://github.com/OpenNebula/one/issues/5802>`_ on the host.

High Availability
================================================================================

HA server configuration synchronization with the command `onezone serversync` does not work for the PostgreSQL and SQLite DB Back-end

Sunstone
================================================================================

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow `these instructions <https://www.parallels.com/blogs/ras/disabling-network-level-authentication/>`__ in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.
- When hidding the VM name setting on instantiate form, Sunstone does not continue with the instantintiation process. To be able to instantiate templates please set `VM.instantiate_name` to `true` in the corresponding YAML file.

Install Linux Graphical Desktop on KVM Virtual Machines
================================================================================

OpenNebula uses the ``cirrus`` graphical adapter for KVM Virtual Machines by default. It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver. You can force a VESA mode by configuring the kernel parameter ``vga=VESA_MODE`` in the GNU GRUB configuration file. `Here <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/>`__ you can find the VESA mode numbers. For example, adding ``vga=791`` as kernel parameter will select the 16-bit 1024×768 resolution mode.

vCenter Snapshot behavior
=================================

VMs in vCenter 7.0 exhibit a new behavior regarding snapshots and disks attach/detach operations. When vCenter 7.0 detects any change in the number of disks attached to a VM, it automatically cleans all the VM snapshots. OpenNebula doesn't take this into account yet, so the snapshots stated by OpenNebula, after a disk attach or disk detach, are pointing to a null vCenter reference, and as such, cannot be used. Please keep this in mind before a solution is implemented.

Virtual Machines Backup
================================================================================

When taking a VM backup, if the upload process fails and the app results in ERROR state, the backup will complete successfully. A detailed explanation can be found `here <https://github.com/OpenNebula/one/issues/5454>`__.

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

FireEdge
=================

- When creating an onprem provision the second step (``Provider``) shows and empty list instead of the ``onprem`` provider. In order to workaround the issue just click on the next button at the top right corner.

- When deploying an HCI onprem provision it will fails because of the Ansible version used. In order to workaround the issue you need to fix the value of ``CEPH_ANSIBLE_BRANCH`` to ``v6.0.26`` at ``/usr/lib/one/oneprovision/lib/provision/ansible.rb`` file in the Front-end node.

OneProvision Equinix Provider
================================================================================

Due to changes in the facilities names in Equinix, this provider is currently not working.
