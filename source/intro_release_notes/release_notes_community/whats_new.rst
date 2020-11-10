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
- Add support for document encrypted attributes, check :ref:`this <encrypted_attrs>` for more information.

Storage
================================================================================
- New SSH transfer manager extension called :ref:`replica<replica_tm>`

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

- Registration time has been added to service templates.
- Start time has been added to services.
- Add new option to delete VM templates associated to a service template when deleting it. Check more information about new parameters :ref:`here <appflow_use_cli_delete_service_template>`.
- Add option to automatic delete service if all VMs has been terminated. Check more information :ref:`here <appflow_use_cli_automatic_delete>`.

CLI
================================================================================
- CLI can output JSON and YAML formats.  e.g: ``onevm list --json`` or ``onevm show --yaml 23``

onedb
================================================================================
- ``version`` command have been improved to be aware of available upgrades.
- ``upgrade`` command have been improved to create backup only if necessary. Also ``--no-backup`` have been added to avoid backup creation always.

Distributed Edge Provisioning
================================================================================

- Provision information is stored using a JSON document. New commands has been also added in the CLI, you can check all the information :ref:`here <ddc>`.
- Provider concept has been included in OpenNebula, you can check all the information :ref:`here <ddc_provider>`.
- Provision template concept has been included in OpenNebula, you can check all the information :ref:`here <ddc_provision_template_document>`.
- Provision operations has been implemented using Terraform. The same functionality is supported, but actions are triggered using Terraform.
- Terraform is able to create more resources on the remote provider. Check more information :ref:`here <terraform_advanced>`.
- Count attribute has been addded. This allow you to create multiple same hosts. Check more information :ref:`here <ddc_provision_template_devices>`.

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
