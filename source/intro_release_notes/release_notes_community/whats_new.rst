.. _whats_new:

================================================================================
What's New in X.Y
================================================================================

..
   Conform to the following format for new features.
   Big/important features follow this structure
   - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
   Minor features are added in a separate block in each section as:
   - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- `Add option to disable raw section validation <http://github.com/OpenNebula/one/issues/5015>`__.
- `Add option set cold migration type for rescheduling <http://github.com/OpenNebula/one/issues/2983>`__.
- `Add option to create formatted datablocks <https://github.com/OpenNebula/one/issues/4989>`__.

Networking
================================================================================

Authentication
================================================================================


Sunstone
================================================================================
- VM info autorefresh with ZeroMQ. Check :ref:`this <autorefresh>` for more information.


Scheduler
================================================================================

OneFlow & OneGate
===============================================================================

CLI
================================================================================
- CLI can output JSON and YAML formats.  e.g: ``onevm list --json`` or ``onevm show --yaml 23``

Distributed Edge Provisioning
================================================================================

- Provision information is stored using a JSON document. New commands has been also added in the CLI, you can check all the information :ref:`here <ddc>`.

Packaging
================================================================================

VMware Virtualization driver
===============================================================================

Containers
==========

MicroVMs
========

Hooks
=====
- Change the way arguments are passed to ``host_error.rb`` from command line to standard input to avoid potential argument overflow `issue <https://github.com/OpenNebula/one/issues/5101>`__. When upgrading from previous OpenNebula versions, if :ref:`Host Failures <ftguide>` configured, it is needed to update the hook (``onehook update``) with ``ARGUMENTS_STDIN = "yes"``.

Other Issues Solved
================================================================================
- Allow live migration over SSH for KVM `<http://github.com/OpenNebula/one/issues/1644>`__.
