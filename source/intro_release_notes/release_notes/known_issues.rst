.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

LXD Guest OS issues
================================================================================

The following issues have been detected for several Linux OS versions when running in a LXD container:

* Centos6 KVM market app boots into emergency runlevel when used as a LXD image. A workaround for this issue is to manually input ``telinit 3``. The full description is `here <https://github.com/OpenNebula/one/issues/3023>`__.
* Centos6 LXD market app fails to correclty set hostname contextualization. The behavior and workaround is described `here <https://github.com/OpenNebula/one/issues/3132>`__.
* Gentoo LXD market app not imported correclty- The content of the image seems truncated when dumping the linux fs into the block. More info `here <https://github.com/OpenNebula/one/issues/3049>`__.

LXD Host issues
================================================================================

Sometimes after a container is powered off, `LXD doesn't remove the host-side NIC of the veth pair <https://github.com/OpenNebula/one/issues/3189>`__

It could be handled by using a custom lxc hook

.. code-block:: text

    root@lxd_node:# cat /usr/share/lxc/config/common.conf.d/custom.conf
    lxc.hook.post-stop = /usr/share/lxc/hooks/delete-static-veths

    root@lxd_node:# cat /usr/share/lxc/hooks/delete-static-veths
    #!/usr/bin/env bash
    # https://github.com/lxc/lxc/issues/2878

    LXC_INTERFACES=$(ip link show | sed -n -E "s/^[0-9]+: ($LXC_NAME-[0-9]+)@.*/\1/p")
    if [ -z "$LXC_INTERFACES" ]; then
    exit 0
    fi

    for interface in $LXC_INTERFACES; do
    ip link set $interface down
    ip link delete $interface
    done

Qcow2 Image Datastores and SSH transfer mode
================================================================================

Qcow2 image datastores are compatible with SSH system datastore (SSH transfer mode). However the configuration attributes are missing. To enable this mode for qcow2 you need to:

1. Stop OpenNebula
2. Update ``/etc/one/oned.conf`` file so the ``qcow2`` configuration reads as follows:

.. code-block:: bash

   TM_MAD_CONF = [
       NAME = "qcow2", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES",
       DS_MIGRATE = "YES", TM_MAD_SYSTEM = "ssh", LN_TARGET_SSH = "SYSTEM",
       CLONE_TARGET_SSH = "SYSTEM", DISK_TYPE_SSH = "FILE", DRIVER = "qcow2"
   ]

3. Restart OpenNebula
4. Force the update of the qcow2 image datastores by executing ``onedatastore update <datastore_id>``. Simply save the file as is, OpenNebula will add the extra attributes for you.

NIC alias and IP spoofing rules
================================================================================

For NIC alias the IP spoofing rules are not triggered when the VM is created nor when the interface is attached. If you have configured IP spoofing for your virtual networks be aware that those will not be honored by NIC ALIAS interfaces. More info `here <https://github.com/OpenNebula/one/issues/3079>`__.

.. _monitoring_information_not_showing_on_vm_list_in_sunstone:

Monitoring information not showing on VM list in Sunstone
================================================================================

vCenter and Amazon drivers store some guest IP addresses in the monitoring section of the VM. This information is no longer sent as part as the VM pool data and it will not be shown in Sunstone list table. Note that this information can be still queried in the detailed view of the VM. More information can be found `here <https://github.com/OpenNebula/one/issues/3308>`__.

LOCK mark for VMs in Sunstone
================================================================================

There is a bug which makes disappear the LOCK highlight for VMs in Sunstone. This bug has been fixed but to let the fix take effect it's necessary to force a VM DB update. You can trigger this update with a state change or a template update without modifying any field.

This is only necessary when updating to 5.8.2 from 5.8.x.

FSCK network problem
================================================================================

There are two bugs affecting the onedb fsck command related to networks. These bugs have been fixed, so please replace your fsck/network.rb file (located in /usr/lib/one/ruby/onedb/fsck) by https://github.com/OpenNebula/one/blob/master/src/onedb/fsck/network.rb

Onedb purge-done problem
========================

There is a bug when running the command with end-time parameter. The bug has been fixed, you can find information about it `here <https://github.com/OpenNebula/one/issues/4050>`__.

DB Size Increase due to FTS index
=================================

FTS index used for VM searching is consuming too much disk size.

In order to remove the index while a new release reduces the indexing and alleviates the issue, run the following SQL sentence in your MySQL OpenNebula DB:

.. code::

   ALTER TABLE vm_pool DROP INDEX ftidx;


More information can be found `here <https://github.com/OpenNebula/one/issues/3393>`__.


Federation master overrides quotas on slave zones
=================================================

Defined quotas on slave zones get overridden by the same quota if it is defined on master zone.

More information can be found `here <https://github.com/OpenNebula/one/issues/3409>`__.

CLI warning message
===================

Using some CLI commands in Ubuntu 18.04, due to ruby and gems version, you may see this message:

`warning: constant ::Fixnum is deprecated`

As a workaround you can use `export RUBYOPT="-W0`, this will disable the warning message (but, take in account that it will disable all warning messages from ruby)

System VM Snapshots
====================
`When a VM system snapshot is deleted <https://github.com/OpenNebula/one/issues/4018>`_ the associated metadata for other snapshots of that VM get corrupted. This breaks the snapshots preventing the VM to revert to other saved snapshot states. Note: This issue affects KVM and qcow2 datastores.
