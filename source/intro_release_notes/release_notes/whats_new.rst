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
- `Add option set cold migration type for rescheduling <http://github.com/OpenNebula/one/issues/2983>`__.
- `Add option to create formatted datablocks <https://github.com/OpenNebula/one/issues/4989>`__.
- Add support for document encrypted attributes, check :ref:`this <encrypted_attrs>` for more information.
- `VM terminate, poweroff and undeploy hard overrides their soft counterpart <https://github.com/OpenNebula/one/issues/2586>`__.
- `AR inherits IPAM_MAD from VNET <https://github.com/OpenNebula/one/issues/2593>`__.
- `INHERIT_VNET_ATTR, INHERIT_DATASTORE_ATTR and INHERIT_IMAGE_ATTR allows inherit of complex type <https://github.com/OpenNebula/one/issues/4090>`__.
- `Allow 'onevm disk-saveas' in undeployed and stopped state <https://github.com/OpenNebula/one/issues/1112>`__.
- `Terminate oned in HA in case of lost DB connection <https://github.com/OpenNebula/one/issues/5186>`__.
- `Unique VM identification, allow to force uuid to VM <https://github.com/OpenNebula/one/issues/1048>`__.

Storage
================================================================================
- New SSH transfer manager extension called :ref:`replica<replica_tm>`
- Usage of ``scp`` is deprecated in favour of `ssh+tar <https://github.com/OpenNebula/one/issues/5058>`__ and ssh+rsync. File based images are (re)sparsified.
- New :ref:`Image state events and hooks<hooks>`

Networking
================================================================================
- :ref:`VXLAN attributes<vxlan>` can be defined per network as well as system-wide in OpenNebulaNetwork.conf file.

Authentication
================================================================================


Sunstone
================================================================================
- VM info autorefresh with ZeroMQ. Check for more information :ref:`here <autorefresh>`.
- Add option to disable network configuration for service template instantiation. Check more information :ref:`here <suns_views_custom>`.
- Service registration time has been added to :ref:`service templates <appflow_elasticity>`. Available in Sunstone, enabled by default in :ref:`services instances views <suns_views>`.
- Added remove template and images when delete a service. Check form more information :ref:`here <appflow_use_cli_delete_service_template>`.
- Add option to automatic deletion to services when all associated VMs terminated. Check more information :ref:`here <appflow_use_cli_automatic_delete>`.
- Added VM name to :ref:`VNC Guacamole connections <requirements_guacamole_vnc_sunstone>`.
- Allow to attach external NIC alias. Check more information :ref:`here <template_network_section>`.
- Added states to role actions buttons. Check for more information :ref:`here <appflow_use_cli_life_cycle>`.
- Add EXTERNAL NIC attribute to VM IPs on Sunstone. Check more information :ref:`here <template_network_section>`.
- Add error message for asynchronous actions on Sunstone. Check more information :ref:`here <vm_life_cycle_and_states>`.
- Update Sunstone Host and VMs datatable columns. Check more information :ref:`here <suns_views>`.
- Added option to enable/disable users on Sunstone. Check more information :ref:`here <manage_users>`.
- Add support to avoid importing VM Template from the marketplace. Check more information :ref:`here <marketapp_download>`.
- Numa aware placement for vCenter. Check more information :ref:`here <numa>`.
- Added Dockerfile support for image create :ref:`here <dockerfile>`.
- Allow charters configuration within service/vm Template :ref:`here <service_charters>`.

Scheduler
================================================================================
- `Read http_proxy from config file <http://github.com/OpenNebula/one/issues/678>`__, override environment variable http_proxy .

OneFlow & OneGate
===============================================================================

- Registration time has been added to service templates.
- Start time has been added to services.
- Add new option to delete VM templates associated to a service template when deleting it. Check more information about new parameters :ref:`here <appflow_use_cli_delete_service_template>`.
- Add option to automatic delete service if all VMs has been terminated. Check more information :ref:`here <appflow_use_cli_automatic_delete>`.
- ``DONE`` and ``POWEROFF`` VM states are considered in transient states (``DEPLOYING`` and ``SCALING``) to avoid service hangs.
- Purge done operation has been implemented in order to remove services in **DONE** state. You can check more information :ref:`here <flow_purge_done>`.

CLI
================================================================================
- CLI can output JSON and YAML formats.  e.g: ``onevm list --json`` or ``onevm show --yaml 23``
- `Command to disable and enable user. <https://github.com/OpenNebula/one/issues/649>`__ Disabled users can't execute any commnad and can't log in to sunstone.
- Configuration management tool ``onecfg`` with new ad-hoc patch functionality is part of server package. See documentation :ref:`here <cfg_index>`.

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
- ERB syntax has been changed by a new syntax. Check more information :ref:`here <ddc_virtual_all>`.
- Dynamic user inputs has been added. This allow you to set multiple values inside the template. Check more information :ref:`here <ddc_user_inputs>`.

Packaging
================================================================================

- OpenNebula package names unified across distributions, see :ref:`here <compatibility_pkg>`.

KVM
===

- KVM defaults changed to leverage paravirtualized interfaces, see :ref:`here <compatibility_kvm>`.
- Default path to EMULATOR on points to unified symbolic link ``/usr/bin/qemu-kvm-one``, see :ref:`here <compatibility_kvm>`.
- `Support for iotune parameter size_iops_sec for kvm <https://github.com/OpenNebula/one/issues/5225>`__.

VMware Virtualization driver
============================

- Import secondary IPs as a NIC_ALIAS in OpenNebula, see :ref:`here <vcenter_wild_vm_nic_disc_import>`.
- Use a specific VM Templates in vCenter when import marketplace apps, see :ref:`here <marketapp_download>`.
- Assign VCENTER_VM_FOLDER automatically per user or group see :ref:`here <vm_template_definition_vcenter>`.
- Fix import networks in vCenter with special characters :ref:`Importing vCenter Networks<vcenter_import_networks>`.

Containers
==========

MicroVMs
========

DockerHub
==========
- Dockerfiles used to download images from DockerHub have been moved to external templates so they can be customized. You can find them under ``/usr/share/one/dockerhub`` directory.
- Export of Docker Hub images into OpenNebula preferably uses FUSE based ext2/3/4 mounts on front-end, instead of kernel native mounts.
- Add support to create images from Dockerfile specification. Check :ref:`this <dockerfile>` for more information.

MarketPlace
===========

- Add support for service templates, check :ref:`this <marketapp_import>` for more information.

Hooks
=====
- Change the way arguments are passed to ``host_error.rb`` from command line to standard input to avoid potential argument overflow `issue <https://github.com/OpenNebula/one/issues/5101>`__. When upgrading from previous OpenNebula versions, if :ref:`Host Failures <ftguide>` configured, it is needed to update the hook (``onehook update``) with ``ARGUMENTS_STDIN = "yes"``.

Other Issues Solved
================================================================================
- Allow live migration over SSH for KVM `<http://github.com/OpenNebula/one/issues/1644>`__.
- Make automatic LDAP group admin mapping configurable `<http://github.com/OpenNebula/one/issues/5210>`__.
- Fix virtual machine tabs not working on Sunstone`<http://github.com/OpenNebula/one/issues/5223>`__.
- Fix minimum VMs to scale action on Sunstone`<http://github.com/OpenNebula/one/issues/1019>`__.
- Fix service scale action in the Cloud View on Sunstone`<http://github.com/OpenNebula/one/issues/5231>`__.
- Fix schedule actions via Sunstone unexpected behavior on VMs `<https://github.com/OpenNebula/one/issues/5209>`__.
