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
