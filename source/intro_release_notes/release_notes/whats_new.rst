.. _whats_new:

================================================================================
What's New in 6.1
================================================================================

OpenNebula 6.2 ‘XXXX’ is  ....

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
- New :ref:`XMLRPC API for scheduled actions <onevm_api>`: ``one.vm.schedadd``, ``one.vm.schedupdate``, ``one.vm.scheddelete``. The new API reduces race condition issues while handliing scheduled actions.
- :ref:`IPv6 no-SLAAC <vn_template_ar6_nslaac>` computes ``SIZE`` from ``PREFIX_LENGTH``. Max size increased from 2^32 to 2^64.

Storage
================================================================================

Networking
================================================================================

Sunstone
================================================================================

Scheduler
================================================================================

OneFlow & OneGate
===============================================================================


CLI
================================================================================

onedb
================================================================================

Distributed Edge Provisioning
================================================================================


Packaging
================================================================================

KVM
===

VMware
============================


MarketPlace
===========


Hooks
=====

Other Issues Solved
================================================================================
