.. _whats_new:

================================================================================
What's New in 6.0
================================================================================


OpenNebula 6.0 (Mutara) is the first stable release of the OpenNebula 6 series. This release comes with a significant number of new functionality, among which we can highlight the maturity of the automatic provision component, that enables any OpenNebula cloud to automatically add new OpenNebula clusters using the offering of different cloud and edge providers. This new functionality includes:

  * A fully featured command line interface to manage providers (public cloud and edge offerings) and provisions (OpenNebula clusters with a certified Edge architecture)
  * A modern, slick web interface delivered by a new web server, FireEdge, which implements a wrapper for the OpenNebula XMLRPC and OneFlow REST APIs. Create remote OpenNebula clusters with a point and click interface!
  * A special hyperconverged architecture to maximize workload performance. It uses a novel 3-tier storage architecture that allows to deploy any marketplace application using a new replica transfer manager driver.
  * A set of templates to instantiate providers (initially for Amazon AWS and Equinix/Packet) and provisions (the remote OpenNebula clusters, based on KVM, Firecracker or qemu).

Additionally, Mutara comes with the following goodies:

* The new Firedge server enables new functionality in Sunstone: autorefresh for VM and host states, VMRC console access for VMware VMs, Guacamole VNC/SSH and RDP, and more.
* Additionally there has been multitude of improvements in Sunstone: revamped VNC dialogs, asynchronous operation warnings, extra information for OneFlow services, NUMA placement for VMware VMs, etc.
* Support for VM Backups, periodically save the data of your VMs in a remote storage location set up as a private marketplace.
* Several OneFlow improvements, mostly related to the life cycle management of OneFlow Services, both in the engine and the GUI.
* Add support for Dockerfiles! Define your Docker apps directly in Sunstone, and have OpenNebula create and deploy the Docker app for you.
* Revamped marketplace subsystem, now it allows to store not only images but also multi disk VM Templates and even OneFlow services.

OpenNebula 6.0 codename refers to a nebula, in this case the Mutara Nebula, an interstellar dust cloud located in the Mutara sector of the Beta Quadrant. The nebula contained high levels of static discharge and was comprised largely of ionized gases. The combined effect of this made a starship's sensors highly unreliable and shields inoperable when inside. In March of 2285, the nebula ceased to exist when the Genesis Device detonated. As seen on Star Trek :)

The OpenNebula team is now transitioning to "bug-fixing mode". Note that this is a first beta release aimed at testers and developers to try the new features, and we welcome you to send feedback for the final release. Please check the :ref:`known issues <known_issues>` before submitting an `issue through GitHub <https://github.com/OpenNebula/one/issues/new?template=bug_report.md>`__. Also note that being a beta, there is no migration path from the previous stable version (5.12.x) nor migration path to the final stable version (6.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/32>`__.

In the following list you can check the highlights of OpenNebula 6.0 (a detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/32?closed=1>`__):

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
- Allow charters configuration within service Template :ref:`here <service_charters>`.
- Added show information of Charters in service list :ref:`here <service_charters>`.
- Added option to hide schedule actions on VM instantiate. Check more information :ref:`here <suns_views_custom>`.
- Add new Sunstone labels normalization. Check more information :ref:`here <suns_views_labels_behavior>`.
- Add option to change boot device when instantiate a VM Template. Check more information :ref:`here <template_os_and_boot_options_section>`.
- Add option to set VM Backups. Check more information :ref:`here <template_os_and_boot_options_section>`.
- Add option to format Datablocks. Check more information :ref:`here <img_template>`.

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
- `Support for iothreads <https://github.com/OpenNebula/one/issues/1226>`__.

VMware Virtualization driver
============================

- Import secondary IPs as a NIC_ALIAS in OpenNebula, see :ref:`here <vcenter_wild_vm_nic_disc_import>`.
- Use a specific VM Templates in vCenter when import marketplace apps, see :ref:`here <marketapp_download>`.
- Assign VCENTER_VM_FOLDER automatically per user or group see :ref:`here <vm_template_definition_vcenter>`.
- Option to avoid deleting disk not managed in OpenNebula, see :ref:`here <driver_tuning>`.
- Fix :ref:`import networks <vcenter_import_networks>` in vCenter with special characters.

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
- `Allow live migration over SSH for KVM <http://github.com/OpenNebula/one/issues/1644>`__.
- `Make automatic LDAP group admin mapping configurable <http://github.com/OpenNebula/one/issues/5210>`__.
- `Fix virtual machine tabs not working on Sunstone <http://github.com/OpenNebula/one/issues/5223>`__.
- `Fix minimum VMs to scale action on Sunstone <http://github.com/OpenNebula/one/issues/1019>`__.
- `Fix service scale action in the Cloud View on Sunstone <http://github.com/OpenNebula/one/issues/5231>`__.
- `Fix schedule actions via Sunstone unexpected behavior on VMs <https://github.com/OpenNebula/one/issues/5209>`__.
- `Fix error when create app if OneFlow Server not runnnig <https://github.com/OpenNebula/one/issues/5227>`__.
- `Fix Sunstone overrides disks when VM Template instantiate XMLRPC API call <https://github.com/OpenNebula/one/issues/5238>`__.
- `Fix Sunstone doesn't lock and unlock VMs <https://github.com/OpenNebula/one/issues/5200>`__.
- `Fix Sunstone doesn't delete roles on Service update <https://github.com/OpenNebula/one/issues/5254>`__.
- `Hide remote actions buttons until vCenter VM is monitored <https://github.com/OpenNebula/one/issues/5002>`__.
- `Fix Sunstone VM warning box blocks other VM tabs <https://github.com/OpenNebula/one/issues/5266>`__.
