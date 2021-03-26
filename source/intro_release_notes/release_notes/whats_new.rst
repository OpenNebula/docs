.. _whats_new:

================================================================================
What's New in 6.0
================================================================================

OpenNebula 6.0 ‘Mutara’ is the first stable release of the new OpenNebula 6 series. This release comes with a significant number of new functionalities, among which we can highlight the maturity of the new innovative edge features developed in the context of the `ONEedge <http://oneegde.io>`__ innovation project to deploy on-demand distributed edge cloud environments based on OpenNebula. These new edge computing features enable IT organizations to deploy true hybrid and multi-cloud environments that avoid vendor lock-in, reducing operational costs, expanding service availability, and enabling new ultra-low-latency applications. Organizations maintain a single control panel with centralized operations and management that abstracts cloud functionality and ensures portability across clouds. IT organizations can now automatically deploy and manage multiple Kubernetes clusters across edge locations to enable truly multi-tenant and large-scale container orchestration.

These new edge features in OpenNebula 6.0 include:

- A powerful distributed cloud architecture for OpenNebula that is composed of edge clusters that can run any workload—both virtual machines and application containers— on any resource—bare metal or virtualized— anywhere—on-premises and on a cloud provider. This hyperconverged edge cloud solution maximizes workload performance and availability, and comes with a native 3-tier storage architecture that simplifies and speeds up the deployment of containers and services across edge locations.
- A fully featured command line interface and a modern, slick web interface—FireEdge—to easily manage public cloud and edge providers  and the seamless provisioning of OpenNebula’s edge clusters. You can quickly expand on-demand your OpenNebula cloud with third-party resources thanks to this point and click interface and create an “Edge as a Service” environment in just a few minutes!
- A first set of templates and drivers to expand your OpenNebula cloud using  AWS and Equinix Metal resources, creating edge clusters based on QEMU, KVM and Firecracker.
- The new support for Dockerfiles and a revamped Marketplace for VM templates, which now is able to store service templates, which considerably improves user experience in the  execution of complex container workflows, multi-tier services and management of CNCF-certified Kubernetes clusters on the edge.

Additionally, OpenNebula 6.0 ‘Mutara’ comes with the following goodies:

- There have been multitude of improvements in Sunstone: revamped VNC dialogs, asynchronous operation warnings, extra information for OneFlow services, NUMA placement for VMware VMs, etc. Additionally, a new FireEdge server is now shipped with OpenNebula, enabling new functionality in Sunstone—OpenNebula’s WebUI: auto refresh for VM and host states, VMRC console access for VMware VMs, Guacamole VNC/SSH and RDP, and more.
- Support for VM Backups, periodically save the data of your VMs in a remote storage location set up as a private marketplace.
- Several OneFlow improvements, mostly related to the life cycle management of OneFlow Services, both in the engine and the GUI.
- Hypervisor driver improvements like vSphere 7 support and additional VM tuning parameters for KVM. OpenNebula 6.0 also features a new driver for LXC containers, easing the use of containerized apps across platforms.

As usual, OpenNebula 6.0 codename refers to a nebula, in this case to the Mutara Nebula, an interstellar dust cloud located in the Mutara sector of the Beta Quadrant. In 2285, it was the site of the epic battle between the USS Reliant (commanded by the infamous Khan Noonien Singh) and the USS Enterprise (commanded by Captain James T. Kirk), which ended [Spoiler Alert] with the detonation of the Genesis Device and the USS Enterprise making a last-minute escape thanks to the dramatic self-sacrifice of Mr Spock—as seen in Star Trek II: The Wrath of Khan :)

This is a Release Candidate version for 6.0, aimed at testers and developers to try the new features. All the functionality is present and only bugfixes will happen between this release and final 6.0. Please check the :ref:`known issues <known_issues>` before submitting an `issue through GitHub <https://github.com/OpenNebula/one/issues/new?template=bug_report.md>`__. Also note that being a development version, there is no migration path from the previous stable version (5.12.x) nor migration path to the final stable version (6.0). A list of open issues can be found in the `GitHub development portal <https://github.com/OpenNebula/one/milestone/32>`__.


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
- `Enable live CPU and memory resize <https://github.com/OpenNebula/one/issues/1660>`__.

Storage
================================================================================
- New SSH transfer manager extension called :ref:`replica<replica_tm>`
- Usage of ``scp`` is deprecated in favour of `ssh+tar <https://github.com/OpenNebula/one/issues/5058>`__ and ssh+rsync. File based images are (re)sparsified.
- New :ref:`Image state events and hooks<hooks>`

Networking
================================================================================
- :ref:`VXLAN attributes<vxlan>` can be defined per network as well as system-wide in OpenNebulaNetwork.conf file.

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
- Add option to purge services in DONE state. Check more information :ref:`here <flow_purge_done>`.
- Add option to set IOTHREAD id on disks in Sunstone. Check more information :ref:`here <reference_vm_template_disk_section>`.

Scheduler
================================================================================
- `Read http_proxy from config file <http://github.com/OpenNebula/one/issues/678>`__, override environment variable http_proxy.

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

- Provision information is stored using a JSON document. New commands has been also added in the CLI, you can check all the information :ref:`here <cluster_operations>`.
- Provider concept has been included in OpenNebula, you can check all the information :ref:`here <provider_operations>`.
- Provision operations has been implemented using Terraform. The same functionality is supported, but actions are triggered using Terraform.
- Count attribute has been addded. This allow you to create multiple same hosts. Check more information :ref:`here <ddc_virtual>`.
- ERB syntax has been changed by a new syntax. Check more information :ref:`here <ddc_virtual>`.
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
- `Support for shareable disk <https://github.com/OpenNebula/one/issues/727>`__
- `Option to compact memory on VM start/stop <https://github.com/OpenNebula/one/issues/3124>`__

VMware Virtualization driver
============================

- Import secondary IPs as a NIC_ALIAS in OpenNebula, see :ref:`here <vcenter_wild_vm_nic_disc_import>`.
- Use a specific VM Templates in vCenter when import marketplace apps, see :ref:`here <marketapp_download>`.
- Assign VCENTER_VM_FOLDER automatically per user or group see :ref:`here <vm_template_definition_vcenter>`.
- Option to avoid deleting disk not managed in OpenNebula, see :ref:`here <driver_tuning>`.
- Fix :ref:`import networks <vcenter_import_networks>` in vCenter with special characters.
- Support for vSphere 7.0, see :ref:`here <vmware_node_deployment>`.

DockerHub
==========
- Dockerfiles used to download images from DockerHub have been moved to external templates so they can be customized. You can find them under ``/usr/share/one/dockerhub`` directory.
- Export of Docker Hub images into OpenNebula preferably uses FUSE based ext2/3/4 mounts on front-end, instead of kernel native mounts.
- Add support to create images from Dockerfile specification. Check :ref:`this <dockerfile>` for more information.

MarketPlace
===========

- Add support for service templates, check :ref:`this <marketapp>` for more information.

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
- `Fix show the CPU cost calculation in VM template wizard <https://github.com/OpenNebula/one/issues/5288>`__.
- `CLI interprete backslash escapes <https://github.com/OpenNebula/one/issues/4981>`__.
- `Add instantiate VMs persistent by default <https://github.com/OpenNebula/one/issues/1501>`__.
- `Remove CLI extra columns <https://github.com/OpenNebula/one/issues/4974>`__.
- `Improve interoperability between Datastore and Market drivers <https://github.com/OpenNebula/one/issues/1159>`__.
- `Allow = symbols in OneGate update <https://github.com/OpenNebula/one/issues/5240>`__.
- `Prevent xtables (iptables/iptables6) collisions with non-OpenNebula related processes <https://github.com/OpenNebula/one/issues/3624>`__.
- `Fix bug when updating VM configuration with non admin users <https://github.com/OpenNebula/one/issues/5096>`__.
- `Fix bug when updating VCPU that blocked NUMA sockets <https://github.com/OpenNebula/one/issues/5291>`__.
