.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Drivers - Auth
================================================================================

- OpenNebula does not parse admin groups correctly. Groups starting by * indicating admin rights fails to parse, this affects all external `auth drivers including LDAP <https://github.com/OpenNebula/one/issues/5946>`_.

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
- Creating a VM with SPICE graphics, on Alma9, will cause the VM to stay on FAILED state.
- To activate the SCALE button in Sunstone Service Instances Role subtab, the following setting needs to be activated in admin.yaml and user.yaml views:

  ``Role.scale_dialog: true``

Install Linux Graphical Desktop on KVM Virtual Machines
================================================================================

OpenNebula uses the ``cirrus`` graphical adapter for KVM Virtual Machines by default. It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver. You can force a VESA mode by configuring the kernel parameter ``vga=VESA_MODE`` in the GNU GRUB configuration file. `Here <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/>`__ you can find the VESA mode numbers. For example, adding ``vga=791`` as kernel parameter will select the 16-bit 1024×768 resolution mode.

vCenter Snapshot behavior
=================================

VMs in vCenter 7.0 exhibit a new behavior regarding snapshots and disks attach/detach operations. When vCenter 7.0 detects any change in the number of disks attached to a VM, it automatically cleans all the VM snapshots. OpenNebula doesn't take this into account yet, so the snapshots stated by OpenNebula, after a disk attach or disk detach, are pointing to a null vCenter reference, and as such, cannot be used. Please keep this in mind before a solution is implemented.

Virtual Machines Backup
================================================================================

- When taking a VM backup, if the upload process fails and the app results in ERROR state, the backup will complete successfully. A detailed explanation can be found `here <https://github.com/OpenNebula/one/issues/5454>`__.
- Running 'onedb fsck' deletes backup references, please refrain from using "onedb fsck" if you are using the backup functionality.
- OpenNebula stores the whole VM Template in a backup. When restoring it some attributes are wiped out as they are dynamic or they need to be re-generated (e.g. IP). However some attributes (e.g. DEV_PREFIX) would be better to keep them. It is recommended to review and adjust the resulting template for any missing (and required) attribute. The :ref:`list of attributes removed can be checked here <vm_backups_restore>`.

Warning when Exporting an App from the Marketplace Using CLI
================================================================================

When exporting an application from the marketplace using the CLI the following warning can be seen:

.. prompt:: bash $ auto

    /usr/lib/one/ruby/opennebula/xml_element.rb:124: warning: Passing a Node as the second parameter to Node.new is deprecated. Please pass a Document instead, or prefer an alternative constructor like Node#add_child. This will become an error in a future release of Nokogiri.

This is harmless and can be discarded, it will be addressed in future releases.

Contextualization
================================================================================

- ``GROW_ROOTFS`` and ``GROW_FS`` will not extend btrfs filesystems
- ``onesysprep`` does not support Debian 12 yet


WHMCS - Client Users
================================================================================

When the first client is created in WHMCS and purchases a product, following actions will fail due to targeting ID 0 (oneadmin).  Further client accounts past the first one will work as expected.

NUMA Free Hugepages
================================================================================

After upgrading to 6.6.3, the host xml may contain ``HOST_SHARE/NUMA_NODES/NODE/HUGEPAGE/FREE`` attributes always set to ``0``. This attribute shouldn't be there. Xml-linter will show unexpected attribute. The real value of free hugepages is stored in ``MONITORING/NUMA_NODE/HUGEPAGE/FREE``, this value is presented by ``onehost show`` command and sunstone.

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

Note: Passing arguments through command line will be deprecated in the next minor release (6.8)


Market proxy settings
================================================================================

- The option ``--proxy`` in the ``MARKET_MAD`` may not be working correctly. To solve it, execute ``systemctl edit opennebula`` and add the following entries:

.. prompt:: bash $ auto

  [Service]
  Environment="http_proxy=http://proxy_server"
  Environment="https_proxy=http://proxy_server"
  Environment="no_proxy=domain1,domain2"

Where ``proxy_server`` is the proxy server to be used and ``no_proxy`` is a list of the domains or IP ranges that must not be accessed via proxy by opennebula. After that, reload systemd service configuration with ``systemctl daemon-reload`` and restart opennebula with a ``systemctl restart opennebula``
