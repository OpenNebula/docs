.. _whats_new:

================================================================================
What's New in 6.4
================================================================================

OpenNebula 6.4 'Archeon' is the third stable release of the OpenNebula 6 series. This release presents a functional new Sunstone interface for VM and VM Template management, with a similar coverage in terms of functionality as the Cloud View of the still present current Sunstone interface. We want to encourage cloud admins to keep using the ruby-based Sunstone interface (port 9869), but favour the new Sunstone incarnation served by FireEdge in port 2616 for end users. The OpenNebula development team worked hard to streamline the functionality offered in the VM and VM Template tabs, and more UX improvements are on the way!

This release also includes the notion of network states. Your virtual networks now have states that will let you perform custom actions upon creation and destruction of the object; allowing a better integration with your datacenter network backbone. The state change events can be tied to the execution of hooks to further tune the behavior to your needs. There are two components that benefit from this change: OpenNebula flow, can now synchronize the creation of virtual networks and service VMs; and vCenter networking that now integrates seamlessly without the need of activating any hook.

Another exicting addition to 'Archeon' is the ability to automatically create and configure edge clusters based on Ceph Datastores. These clusters can be created either on-prem (just minimal OS and SSH access required) or remotely on AWS. Also for edge clusters, you can dynamically add more hosts in case your need more capacity.

There are also minor addition to the supported hypervisor family, for example the SR-IOV support for the NVIDIA GPU cards; the addition to fine-grain resource control for LXC or .... <vCenter>

OpenNebula 6.4 is named after the Archeon Nebula from the StarWars universe, a beautiful nebula where stars are born and a popular smuggling route... 


..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================
- VM snaphots size were highly overestimated. Count snapshot size only as fraction of original disk size. :ref:`See settings in oned.conf <oned_conf_datastores>`.
- VM logs can be generated in the VM folder (``/var/lib/one/vms/<VMID>/``). This make it easier to keep VM.logs in sync in multi-master installations, :ref:`see more details here <frontend_ha_shared>`.
- `Download process is more robust including retry options for http protocol <https://github.com/OpenNebula/one/issues/5773>`__.

Networking
================================================================================
- Security Groups can be added or removed from a VM network interface, if the VM is running it updates the associated rules.

vCenter Driver
================================================================================
- Configuration flag for :ref:`image persistency <driver_tuning>` of imported Wild VMs or VM Templates.
- New driver wide :ref:`configuration option <driver_tuning>` to set the VMDK format to either Sparse or regular.

Ruby Sunstone
================================================================================
- Add option to hide VM naming on instantiation in :ref:`Sunstone Views <suns_views>`.

React Sunstone
================================================================================
- `Add Single Sign on URL for React Sunstone <https://github.com/OpenNebula/one/issues/5779>`__.

CLI
================================================================================
- New commands to :ref:`attach/detach Security Group <vm_guide2_sg_hotplugging>` to Virtual Machine
- `Oneflow allows updating templates without specifying immutable attributes <https://github.com/OpenNebula/one/issues/5759>`__.

Distributed Edge Provisioning
================================================================================

KVM
===
- NVIDIA vGPU support has been added to KVM driver, :ref:`check this <kvm_vgpu>` for more information.

LXC
===
- `Mount options for Storage Interfaces <https://github.com/OpenNebula/one/issues/5429>`__.

Other Issues Solved
================================================================================
- `Fix the system DS quota to take into account the Snapshot space <https://github.com/OpenNebula/one/issues/5524>`__.
- `Fix [packages] oneflow depends on opennebula <https://github.com/OpenNebula/one/issues/5391>`__.
- `Fix object permissions when running "onedb fsck" <https://github.com/OpenNebula/one/issues/5202>`__.
- `Fix Golang client to handle escape characters in templates <https://github.com/OpenNebula/one/issues/5785>`__.
- `Fix LDAP driver to support password with spaces <https://github.com/OpenNebula/one/issues/5487>`__.
- `Fix migration from sqlite to mysql databases <https://github.com/OpenNebula/one/issues/5783>`__.

Features Backported to 6.2.x
============================

Additionally, a lot of new functionality is present that was not in OpenNebula 6.2.0, although they debuted in subsequent maintenance releases of the 6.2.x series:

- :ref:`Exclusively for the Enterprise Edition, a WHMCS module has bee nadded that allows the creation and management of OpenNebula users and groups with quotas <whmcs_tenants>`.
- `Add support to filter providers by provision type <https://github.com/OpenNebula/one/issues/5604>`__.
- `Add encrypted attributes to User template <https://github.com/OpenNebula/one/issues/5431>`__.
- `Add encryption to guacamole SSH private key and passphrase <https://github.com/OpenNebula/one/issues/5241>`__.
- `LXD Marketplace App VMTemplate has more customization <https://github.com/OpenNebula/one/issues/3667>`__.
- `Add new hosts to existing OpenNebula Edge Clusters <https://github.com/OpenNebula/one/issues/5593>`__.
- `Simple method to add/remove public IPs from OpenNebula Edge Clusters <https://github.com/OpenNebula/one/issues/5593>`__.
- `Make EXPIRE_DELTA and EXPIRE_MARGIN configurable for CloudAuth <https://github.com/OpenNebula/one/issues/5046>`__.
- `Support new CentOS variants on LXC Marketplace <https://github.com/OpenNebula/one/issues/3178>`__.
- `Allow to order and filter vCenter imports when using the vCenter Import Tool <https://github.com/OpenNebula/one/issues/5735>`__.
- `Show scheduler error message on Sunstone <https://github.com/OpenNebula/one/issues/5744>`__.
- `Add error condition to Sunstone list views <https://github.com/OpenNebula/one/issues/5745>`__.
- `Better live memory resize for KVM <https://github.com/OpenNebula/one/issues/5753>`__. **Note**: You need to do a power cycle for those VMs you want to resize its memory after the upgrade.
- :ref:`Add Q-in-Q support for Open vSwtich driver <openvswitch_qinq>`.
- :ref:`Add MTU support for Open vSwtich driver <openvswitch>`.
- `Filter Datastores and Networks by Host on VM instantiation <https://github.com/OpenNebula/one/issues/5743>`__.
- :ref:`Automatically create VM template in Vcenter when exporting an app from marketplace <vcenter_market>`.
- `Improve capacity range feedback in Sunstone <https://github.com/OpenNebula/one/issues/5757>`__.
- :ref:`Set VM IP not registered by ONE when importing a vCenter VM <vcenter_import_ip>`.
- `VM pool list documents include ERROR and scheduler messages so they can be added to list views (e.g. Sunstone) <https://github.com/OpenNebula/one/issues/5761>`__.
- `Support for cgroup2 on the LXC Driver <https://github.com/OpenNebula/one/issues/5599>`__.
- `Support for CPU Pinning using NUMA Topology on the LXC Driver <https://github.com/OpenNebula/one/issues/5506>`__.
- `Memory management improvements similar to LXD defaults on the LXC driver <https://github.com/OpenNebula/one/issues/5621>`__.
- :ref:`Default VM_PREFIX for vCenter VMs can be now be nulified with the empty string <vcenter_vm_prefix>`.
