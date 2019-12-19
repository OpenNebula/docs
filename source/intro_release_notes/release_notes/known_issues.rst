.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

NIC alias and IP spoofing rules
================================================================================

For a NIC alias the IP spoofing rules are not triggered when the VM is created nor when the interface is attached. If you have configured IP spoofing for your virtual networks be aware that those will not be honored by NIC ALIAS interfaces. More info `here <https://github.com/OpenNebula/one/issues/3079>`__.

Wilds with snapshots in vCenter
================================================================================

Currently, OpenNebula does not support importing a Wild with snapshot into vCenter. Before importing a Wild in vCenter you must remove all snapshots. More information can be found `here <https://github.com/OpenNebula/one/issues/1268>`__.

CLI warning message
===================

Using some CLI commands in Ubuntu 18.04, due to ruby and gems version, you may see this message:

`warning: constant ::Fixnum is deprecated`

As a workaround you can use `export RUBYOPT="-W0`, this will disable the warning message (but, take in account that it will disable all warning messages from ruby)

Raw Device Mapping and system datastores
========================================

If you try to deploy a VM using an image from an RDM datastore into an ssh or shared datastore you might get an incompatibility error. To fix this you need to state the following config in **/etc/one/oned.conf**

.. code-block::

    TM_MAD_CONF = [
    NAME = "dev", LN_TARGET = "NONE", CLONE_TARGET = "NONE", SHARED = "YES",
    TM_MAD_SYSTEM = "ssh,shared", LN_TARGET_SSH = "SYSTEM", CLONE_TARGET_SSH = "SYSTEM",
    DISK_TYPE_SSH = "BLOCK", LN_TARGET_SHARED = "NONE",
    CLONE_TARGET_SHARED = "SELF", DISK_TYPE_SHARED = "BLOCK"
    ]