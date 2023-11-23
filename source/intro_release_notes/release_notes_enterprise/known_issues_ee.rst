.. _known_issues_ee:

================================================================================
Known Issues
================================================================================

.. important:: Since 6.4.2 we rolled out new packages GPG signing key which means also public repository key is new.
               Pay attention to the difference in the key URL.  More details in :ref:`repositories configuration <repositories>`

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Network
================================================================================

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
- When creating a new group sunstone on Alma9 will throw an error and won't create the group. As a workaround groups can be created via CLI.
- Adding charters to a service template on Alma9 will duplicate the scheduled actions.
- When creating a new support ticket via Sunstone, users won't see the new ticket on the table however, it was created successfully.

FireEdge
================================================================================

- When trying to use the copy button functionality on M1 Macs the user interface won't be able to copy the text in the clipboard, as a workaround please select and copy the text.

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
- Debian 12 (pre-release) has an issue with ``systemd-networkd-wait-online`` which timeouts and delays contextualization

KVM - Live Memory Resize
================================================================================

For live memory resize user needs to specify ``MAX_MEMORY``, the available memory for the VM is in ``MEMORY`` attribute. But VM running Windows shows in Task Manager available physical memory as ``MAX_MEMORY`` although it can use only ``MEMORY``, this value is not visible in the Task Manager. Because of this it shows a high percentage of memory used. To double check the real available memory for the VM user should use command ``virsh dominfo <id>`` on the host.

KVM - Redefine Snapshot
================================================================================

Depending on the number of snapshots and their IDs, the driver might fail redefining the snapshots (e.g after resuming or migrating the VM). More information can be found `here <https://github.com/OpenNebula/one/issues/5991>`__.

NUMA Free Hugepages
================================================================================

After upgrading to 6.4.6, the host xml may contain ``HOST_SHARE/NUMA_NODES/NODE/HUGEPAGE/FREE`` attributes always set to ``0``. This attribute shouldn't be there. Xml-linter will show unexpected attribute. The real value of free hugepages is stored in ``MONITORING/NUMA_NODE/HUGEPAGE/FREE``, this value is presented by ``onehost show`` command and sunstone.

Datastore Drivers - ``Argument list too long``
================================================================================

Datastore driver actions take the information from the command line arguments. When the number of images in a datastore is big, it can exceed the argument size limit. Drivers has been updated to take arguments through stdin. This needs to be configured in oned by adding ``-i`` to the ``M̀ARKET_MAD`` and ``DATASTORE_MAD`` arguments:

.. prompt:: bash $ auto

    MARKET_MAD = [
        EXECUTABLE = "one_market",
        ARGUMENTS  = "-i -t 15 -m http,s3,one,linuxcontainers,turnkeylinux,dockerhub,docker_registry"
    ]

    DATASTORE_MAD = [
        EXECUTABLE = "one_datastore",
        ARGUMENTS  = "-i -t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter,restic,rsync -s shared,ssh,ceph,fs_lvm,fs_lvm_ssh,qcow2,vcenter"
    ]

