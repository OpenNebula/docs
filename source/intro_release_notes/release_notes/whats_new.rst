.. _whats_new:

================================================================================
What's New in 5.0 Beta
================================================================================

OpenNebula 5.0 Beta (Wizard) is the first release of the major 5.0 update. As such, it comes with several improvements in different subsystems and components, with minimal changes in the API and the VM life-cycle states which embodies long overdue changes but implemented to minimize the impact and ensure backwards compatibility as far as possible. Sunstone never stops evolving, and this is the look and feel the team is most proud of to date.

.. image:: /images/admin_view.png
    :width: 90%
    :align: center

A myriad of outstanding new features make their debut in Wizard. Since sharing, provisioning and consuming cloud images is one of the main concerns when using Cloud, one of the most important new features is the new revamped Marketplaces. They can be seen as external datastores, where images from OpenNebula datastores can be imported and exported. One benefit from the new Marketplace architecture is the ability to share images between different OpenNebula instances if they are in a federation: a MarketPlace can be either Public, accessible universally by all OpenNebula's, or Private: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones). A MarketPlace is a repository of MarketPlaceApps. A MarketPlaceApp can be thought of as an external image optionally associated to a Virtual Machine Template.

.. image:: /images/marketapp_import.png
    :width: 90%
    :align: center

Native support for Virtual Routers is also great news in 5.0. Virtual Routers are an OpenNebula resource that provide routing across virtual networks. The routing itself is implemented with a VM appliance provided by the OpenNebula installation, which can be seamlessly deployed in high availability mode. This functionality is available for the VDC administrator, which can then join together virtual networks within her VDC.

.. image:: /images/sunstone_topology.png
    :width: 90%
    :align: center

For large scale deployments, a long overdue feature is the ability to group resources using labels, which is now present in Wizard's Sunstone. This new feature will enable the possibility to group the different resources under a given label and filter them in the admin and cloud views.

For vCenter based OpenNebula clouds, 5.0 is good news! Support for vCenter storage resources like Datastores and VMDKs enable a wealth of new functionality, like for instance VMDK upload, cloning and deleting, VM disk hotplug, choose Datastore for newly launched VMs and many more. Also, support for resource pools comes in this new major update, as well as the ability to instantiate to persistent (also available for KVM), all packed in an optimized driver.

There are many other improvements in 5.0 like dynamic context regeneration, new host offline mode, cluster resource sharing, VM configuration update, renamed VM life-cycle, support for DB change, improved KVM, vCenter, and datastore monitoring, better VNC port number assignment, dynamic security groups (this is a very nice to have!), support for qemu guest agent, improved VM life-cycle naming and operations, updated instance types for the supported public clouds, improved LVM drivers, enabling use of Ceph without a shared filesystem for system datastore, a humongous number of improvements in all areas and dialogs in Sunstone, enhanced OneGate component to report application metrics, and much much more. Also, and as usual, great effort was put in this release to help build and maintain robust private, hybrid and public clouds with OpenNebula, fixing reported bugs and improving general usability.

This OpenNebula release is named after `NGC 7380 (also known as the Wizard Nebula) <https://en.wikipedia.org/wiki/NGC_7380>`__, an open cluster also known as 142 in the 1959 Sharpless catalog (Sh2-142). This reasonably large nebula is located in Cepheus. It is extremely difficult to observe visually, usually requiring very dark skies and an O-III filter.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, hence not suitable for production environments. Feedback is more than welcome for the final release.

In the following list you can check the highlights of OpenNebula 5.0 Beta (`a detailed list of changes can be found here <http://dev.opennebula.org/projects/opennebula/issues?utf8=%E2%9C%93&set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=75&f%5B%5D=&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&group_by=category>`__):

OpenNebula Core
--------------------------------------------------------------------------------

- **New offline mode** for :ref:`host maintenance <host_lifecycle>`, OpenNebula keeps monitoring the host but the scheduler won't deploy new VMs
- **Instantiate to persistent**, new mechanism to clone a public template to a private template, with private copies of each image  [TODO documentation]
- **Resource sharing** in :ref:`clusters <cluster_guide>` is now possible, so for instance a virtual network can be shared among different clusters.
- **Dynamic VM configuration**, VMs in poweroff can have their boot order, features lie ACPI, VNC access, and so on :ref:`updated with the new "onevm update" command <vm_guide_2>`.
- **Support for DB change**, with a new :ref:`onedb sqlite2myql command <onedb_sqlite2mysql>`.
- **Renamed VM life-cycle**, with :ref:`renamed states <vm_guide_2>` like for instance terminate instead of shutdown in order to avoid confusion.
- **Revisited VM delete operation**, now part of the :ref:`onevm recover <vm_guide_2>` family and only available for admins.
- **Improved VNC port handling**, also with the :ref:`ability to reserve VNC ports <vm_guide_2>`.
- **Attach NIC operations** now :ref:`check cluster constrains <vm_guide_2>`.


OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------

- **Network drivers definition** now in the :ref:`Virtual Network <vgg>`, in previous versions the network driver was defined in the host.
- **Virtual Router** as a new OpenNebula resource. Virtual Networks can be joined together using HA deployed :ref:`Virtual Routers <vrouter>`.
- **Improved network interface naming**, to avoid problems with libvirt and :ref:`security groups <security_groups>`.
- **Dynamic security groups**, now changes to :ref:`security groups <security_groups>` will dynamically apply to VMs.
- **Improved spoofing features** in :ref:`security groups <security_groups>`.


OpenNebula Drivers :: Monitoring
--------------------------------------------------------------------------------

- **Improved KVM monitoring**, to skip failed checks in the :ref:`poll script <mon>`.
- **Improved DS monitoring**, with smarter :ref:`system DS monitoring <system_ds>`.


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

- **iSCSI support** in the :ref:`Devices datastore <dev_ds>`.
- **Improved LVM drivers**, now :ref:`FS LVM driver <lvm_drivers>` do not need cLVM.
- **Ceph as a system DS**, removing the need of a shared filesystem for :ref:`Ceph based <ceph_ds>` deployments.
- **Cloning options for qcow2**, with a variable called :ref:`QCOW2_OPTIONS <qcow2_options>` that can be used to set the parameters.


OpenNebula Drivers :: KVM Virtualization
--------------------------------------------------------------------------------

- **VM Template recursive cloning**, the :ref:`VM Template clone <vm_template_clone>` operation now also clones the VM Template images. This also applies to the delete operation.
- **Additional information in the metadata field**, new element in the :ref:`VM XML document <vm_guide_2>`.
- **Support for qemu guest agent**, a new option :ref:`GUEST available in the VM template <template>`.
- **Generic disk polling for block devices** [TODO]


OpenNebula Drivers :: vCenter Virtualization
--------------------------------------------------------------------------------

- **Dynamic VM reconfiguration**, for certain VM configuration values when the VM is in poweroff state [TODO]
- **vCenter VM name configurable** using a configurable vCenter name :ref:`suffix <vcenter_suffix_note>`.
- **Support for Resource Pools**, with the ability to :ref:`select one <vcenter_resource_pool>` for a launched VM or delegate the choice to the user.
- **Support for vCenter storage**, with :ref:`storage functionality <vcenter_ds>` like for instance VMDK upload, cloning and deleting, VM disk hotplug and choose Datastore for newly launched VMs.
- **Improved VM import**, with the ability to :ref:`import powered off VMs <import_vcenter_resources>`.
- **New reconfigure driver action**, to notify running VMs of context changes [TODO]
- **Instantiate to persistent**, for VMs creating a new VM Template in vCenter [TODO]
- **Control VM disk deletion** on VM shutdown with a new `VM Template attribute <vm_template_definition_vcenter>`.

OpenNebula Drivers :: Hybrid Virtualization
--------------------------------------------------------------------------------

- **Updated instance types**, for both :ref:`ec2 <ec2g>` and :ref:`azure <azg>`.

OpenNebula Drivers :: Marketplace
--------------------------------------------------------------------------------

- **New Marketplace resource**, a first class citizen in OpenNebula to export an import :ref:`MarketplaceApps <marketapp>`, which can be images with associated VM templates.

Scheduler
--------------------------------------------------------------------------------

- **Secondary groups**, now used to :ref:`schedule <schg>` VMs.
- **oned XMLRPC endpoint**, now :ref:`configurable <schg>`.

Sunstone
--------------------------------------------------------------------------------

- **Upgrade Foundation** from version 5 to version 6
- **Dynamic configuration inputs**, based on the OpenNebula core active configuration. For instance, show KVM drivers in host creation dialog only if they are active.
- **Resource labels**, to better organize and search for any resource, like for instance :ref:`VM Templates <vm_templates_labels>` and OneFlow templates and services.
- **Refactored left menu**, to present resources in a more organize manner.
- **Improved wizard descriptions and usability**.
- **Improved user tab**, to allow graphical edit of secondary groups.
- **Updated default listen address**, for :ref:`Sunstone server <sunstone>`.
- **Better string escape handling** that prevents resource template mangling.
- **Overcommitment better presented**, in the host creation dialog.
- **Ability to select IP for NIC** at instantiation time.
- **Add custom template logos**, to support other logos than the ones shipped out of the box.

OneFlow
--------------------------------------------------------------------------------

- **Clone support**, for :ref:`OneFlow Templates <appflow_use_cli>`.
- **Rename available**, for :ref:`OneFlow Templates <appflow_use_cli>`.

OneGate
--------------------------------------------------------------------------------

- **Support for network information** in :ref:`EC2 instances <ec2g>`.
- **Secure configuration supported** for the :ref:`OneGate service<onegate_configure>`.
- **Support for operations** for :ref:`VMs that are not part of a service <onegate_usage>`.
- **Honor restructured attribute**, to avoid modifying critical attributes from :ref:`VM templates <template>`.

Contextualization
-------------------------------------

- **Support for Alpine Linux** [TODO]
- **Context generated when a VM is started** or when a NIC is attached/detached from the VM. The :ref:`context <context_overview>` will be updated with any change in the network attributes, and those changes will be reflected in the context ISO.

Components Moved to the Add-ons Catalog
--------------------------------------------------------------------------------

Some of the infrastructure drivers that were available in OpenNebula 4.x have been moved to the add-ons catalog. This decision has been made based on user demands and with the aim of delivering an OpenNebula distribution supporting the most widely used cloud environments.

- `Xen hypervisor <https://github.com/OpenNebula/addon-xen>`__
- `LVM storage backend <https://github.com/OpenNebula/addon-lvm>`__
- `SoftLayer public cloud <https://github.com/OpenNebula/addon-softlayer>`__

OpenNebula users interested in using these components can install them from the add-ons catalog after installing OpenNebula 5.0.
