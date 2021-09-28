.. _whats_new:

================================================================================
What's New in 6.1
================================================================================

OpenNebula 6.2 XXXX is  ....

..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- Option to :ref:`disable Zone <frontend_ha_zone>`, this new feature is useful for maintenance operations.
- New :ref:`XMLRPC API for scheduled actions <onevm_api>`: ``one.vm.schedadd``, ``one.vm.schedupdate``, ``one.vm.scheddelete``. The new API reduces race condition issues while handling scheduled actions.

Storage
================================================================================

Networking
================================================================================

Sunstone
================================================================================
- Support for new scheduled actions api on :ref:`Sunstone <sunstone>`.
- Error message for failed :ref:`scheduled actions <vm_guide2_scheduling_actions>` in VM info view.

FireEdge
================================================================================
- Support to delete command with cleanup parameter in OneProvision GUI. Check :ref:`this <cluster_operations>` for more information.

Scheduler
================================================================================

OneFlow & OneGate
===============================================================================


CLI
================================================================================
- :ref:`Append option <api_onevmmupdateconf>` for ``onevm updateconf``. If no option is provided the 6.0 behavior is preserved.

onedb
================================================================================

Distributed Edge Provisioning
================================================================================
- Packet provider has been renamed to :ref:`Equinix<equinix_cluster>`.
- Ability to dynamically load providers into OneProvision. Check :ref:`this <devel-provider>` to see how to add a new provider.

Packaging
================================================================================

KVM
===
- Option to specify :ref:`default attribute values <kvmg_default_attributes>` for VM ``GRAPHICS`` section.

LXC
===
- Add support for Images with custom *user:group* offset on the filesystem. OpenNebula will `preserve the shift present in the image filesystem when creating the container <https://github.com/OpenNebula/one/issues/5501>`_.
- `Allow admins to set custom bindfs mount options to further tune the how the container filesystems are exposed, :ref:`see the LXC driver documentation for more details <lxcmg>`.
- Add support for privileged containers by simple label them with the attribute **LXC_UNPRIVILEGED=FALSE** in the VM Template. :ref:`See the LXC documentation for more information on how to tune this setting <lxcmg>`.

VMware
============================


MarketPlace
===========


Hooks
=====

Other Issues Solved
================================================================================
- `Hide VNC button in cloud view <https://github.com/OpenNebula/one/issues/5547>`__.