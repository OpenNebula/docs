.. _whats_new:

================================================================================
What's New in 5.10
================================================================================

OpenNebula Core
================================================================================
- **Update hashing algorithm**, now passwords and login tokens are hashed using sha256 instead of sha1. Also csrftoken is now hashed with SHA256 instead of MD5
- `FILTER is now a VM_RESTRICTED attribute <https://github.com/OpenNebula/one/issues/3092>`__.
- `Increase size of indexes (log_index and fed_index) of logdb table from int to uint64 <https://github.com/OpenNebula/one/issues/2722>`__.

Storage
--------------------------------------------------------------------------------
- `Allows user to modify block size for dd commands used for Ceph, Fs and LVM datastore drivers <https://github.com/OpenNebula/one/issues/2808>`_.

Networking
--------------------------------------------------------------------------------
- `Extend network driver actions with customizable hooks <https://github.com/OpenNebula/one/issues/2451>`_.

OneFlow & OneGate
===============================================================================
- `Option to delete attibutes from VM user template via onegate <https://github.com/OpenNebula/one/issues/1414>`__.

CLI
================================================================================
- `Add new cli options to allow better output parsing <https://github.com/OpenNebula/one/issues/688>`__.

Other Issues Solved
================================================================================
- `Fixes an issue that makes the network drivers fail when a large number of secturiy groups rules are used <https://github.com/OpenNebula/one/issues/2851>`_.
