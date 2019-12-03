.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is oficially published.

NIC alias and IP spoofing rules
================================================================================

For NIC alias the IP spoofing rules are not triggered when the VM is created nor when the interface is attached. If you have configured IP spoofing for your virtual networks be aware that those will not be honored by NIC ALIAS interfaces. More info `here <https://github.com/OpenNebula/one/issues/3079>`__.

Wilds with snapshots in vCenter
================================================================================

Currently, OpenNebula does not support importing a Wild with snapshot into vCenter. Before importing a Wild in vCenter you must remove all snapshots. More information can be found `here <https://github.com/OpenNebula/one/issues/1268>`__.

CLI warning message
===================

Using some CLI commands in Ubuntu 18.04, due to ruby and gems version, you may see this message:

`warning: constant ::Fixnum is deprecated`

As a workaround you can use `export RUBYOPT="-W0`, this will disable the warning message (but, take in account that it will disable all warning messages from ruby)

Shared Storage Drivers
======================

`VM directory is not created when running from persistant image on shared FS datastore <https://github.com/OpenNebula/one/issues/4002>`_. This can be fixed by `applying this patch <https://github.com/OpenNebula/one/commit/eb73ce30080b19cccde491631458182016c2560d>`_ to the driver script `/var/lib/one/remotes/tm/shared/ln`.
