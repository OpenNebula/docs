.. _whats_new:

========================
What's New in 4.14 Beta2
========================

OpenNebula 4.14 Beta2 (Great A'Tuin) ships with several improvements in different subsystems and components. The Sunstone interface has been completely refactored, for maintenance and performance reasons. Expect major improvements in Sunstone from now on. Also, we are sure you will like the subtle changes in the look and feel.

.. image:: /images/sunsdash414.png
    :width: 90%
    :align: center

Several major features have been introduced in Great A'Tuin. One of the most interesting for cloud users and administrators is the ability to create and maintain a tree of VM disks snapshots, in this version for Ceph and qcow2 backends. Now VM disks can be reverted to a previous state at any given time, and they are preserved in the image if it is persistent in the image datastore. For instance, you can attach a disk to a VM, create a snapshot, detach it and attach it to a new VM, and revert to a previous state. Very handy, for instance, to keep a working history of datablocks that can contain dockerized applications.

.. image:: /images/snaptree414.png
    :width: 90%
    :align: center

Another major feature is the ability to resize an existing disk, for all the supported OpenNebula backends. If your VM needs more disk space than the one provided by the images used for its disk, you can now set a new size prior to instantiate the VM, OpenNebula will grow the disk and the guest OS will adapt the filesystem to the now bigger disk at boot time. The disk space is not an issue anymore.These two features (snapshot + resizing) are taken into account for quotas, accounting and showback, so cloud admins can keep track of disk usage in their infrastructure.

To support HPC oriented infrastructures based on OpenNebula, 4.14 also enables the consumption of raw GPU devices existing on a physical host from a Virtual Machine. There is no overcommitment possible nor sharing of GPU devices among different Virtual Machines, so a new type of consumable has been defined in OpenNebula and taken into account by the scheduler. VMs can now request a GPU, and if OpenNebula finds one free resource of type GPU available, it will set up the VM with PCI passthrough access to the GPU resource, enabling applications to get the performance boost of the direct access to a GPU card.

.. image:: /images/gpupcilist.png
    :width: 90%
    :align: center

The ability to save VMs into VM Templates for later use is another feature that must be highlighted in this release. This new operation is accessible both from the cloud view and the admin Sunstone view, as well as from the command line interface.

One great improvement for cloud admins is a much better state management of VMs. It is now possible to recover VMs from failed state instructing OpenNebula to take the last action as success, to retry it or to make it fail gracefully, to recover for instance from failed migrations.

There are many other improvements in 4.14, like a more flexible definition of context network attributes, the ability to import running VMs not launched by OpenNebula from all the supported hypervisors (including the hybrid ones, for instance now it is possible to manage through OpenNebula Azure, SoftLayer and EC2 VMs launched through their respective management portals); the possibility to cold attach disks and network interfaces to powered off machines (which complements the hot attach functionality), improvements in accounting to keep track of disk usage, better logging in several areas, the ability to pass scripts to VMs for guest OS customization, and many others. A great effort was put in this release to help build and maintain robust private, hybrid and public clouds with OpenNebula.

This OpenNebula release is named after `Great A'Tuin <https://en.wikipedia.org/wiki/Discworld_(world)#Great_A.27Tuin>`__, the Giant Star Turtle (of the fictional species Chelys galactica) who travels through the Discworld universe's space, carrying four giant elephants who in turn carry the Discworld. Allegedly, it is "the only turtle ever to feature on the Hertzsprung–Russell diagram."

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release.

In the following list you can check the highlights of OpenNebula 4.14 Beta2. (`a detailed list of changes can be found here
<http://tinyurl.com/qd7esk5>`__):

OpenNebula Core
---------------

The OpenNebula Core handles the abstractions that allows to orchestrate the DC resources. In this release, the following additions and improvements are present:

- **Better logging of error messages**, more information now present :ref:`in the logs <log_debug>` to better debug errors.
- **Support for GPU consumables**, giving the ability to give exlcusive :ref:`PCI passthrough access to VMs to GPU cards <kvm_pci_passthrough>`, for HPC computing.
- **Improved VM recovery and lifecycle flexibility**, thanks to new :ref:`state transitions <vm_life_cycle_and_states>`, like for instance recover failed VMs back to running state, cancel deferred snapshots.
- **New maintenance operations**, using :ref:`cold migration now also lets switch between system datastores <life_cycle_ops_for_admins>`. This can be achived both from the CLI and Sunstone.
- **Running VMs can now be imported in all hypervisors**, not only in vCenter. This operation is available through a new :ref:`WILDS tab in the hosts <reacquire_vcenter_resources>`.
- **Better support for poweroff state**, with for instance the ability of cold :ref:`disk and NIC <vm_guide_2>` attaching.
- **Saving VMs for latter use**, introducing the ability to :ref:`clone a VM <vm_guide2_clone_vm>` in the poweroff state into a VM template that can be instantiated latter on.
- **More administration flexibility**, with the ability to update :ref:`host <host_guide>` drivers.
- **Improved history logging**, :ref:`accounting records <accounting>` are also created when the Virtual Machine has a disk/nic attached or detached.
- **Flexible default auth driver definition**, now it can be set in the core :ref:`configuration file <oned_auth_manager_conf>`.

New perks also for developers:

- **More robust API**, with the addition of :ref:`locks <document_api>` at the core level in the document pools, now you can use the core to synchronize operations.

OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------

OpenNebula networking is getting better and better:

- **Host housekeeping**, cleaning :ref:`VXLAN devices <vxlan>` when no VMs are running in the hypervisor.
- **Set Maximum Transmission Unit**, from the network templates in the hypervisor through the :ref:`802.1q drivers <hm-vlan>`.

OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

Exciting new features in the storage subsystem:

- **New disk snapshot capabilities**, now it is possible to :ref:`snapshot a disk <vm_guide_2_disk_snapshots>` from within OpenNebula and keep a tree of snapshots in the VM and back in the image datastore, reverting (or flattening) at any moment to any snapshot in the tree. If the VM disk where the snapshot is taken is a persistent image, the `snapshots will be persisted back into the image datastore <img_guide_snapshots>`. :ref:`Different backends <storage_snapshot_compatilibity>` (like ceph and qcow2) are supported.
- **Disk snapshots in VM running state**, for qcow2 backends.
- **Disk resizing**, :ref:`grow a VM disk at instantiation time <vm_guide2_resize_disk>` on your VM while conforming with your quotas and being noted down for accounting.

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

- **Get the real and virtual usage for disks**, file based storage not always use the maximum virtual size of the disk. (for example qcow2 or sparse raw files). Improvements in :ref:`monitoring <mon>` take now care of this reporting.
- **Running VMs support** , ability to :ref:`import VMs <import_wild_vms>` running in hypervisors (all of them now supported, even the hybrids) that have not being launched by OpenNebula.
- **Spice support for more hypervisors**, now supported as well in :ref:`XEN <xeng>`.
- **Control how disks are managed in vCenter**, through :ref:`a new VM template variable <vm_template_definition_vcenter>`. Protect users data against accidental deletions.

Scheduler
--------------------------------------------------------------------------------

- **Better logging**, now is easier to understand what is going on in the :ref:`scheduler <schg>`
- **Control System DS deployment with ACL rules**, the scheduler (and core) has been update to enforce :ref:`access rights <manage_acl>` on system datastores, checking that the user can access the System DS. This is useful to implement different allocation policies and VDC-based provision schemes.


Sunstone
--------------------------------------------------------------------------------

Sunstone has been completely refactored, in order to make it easier to maintain and to improve its performance. We hope you like the subtle look and feel changes as well. In addition:

- **Improvements in view selector**, now :ref:`views <suns_views>` can be selected easier and names can be customized.
- **Better user preferences support**, the :ref:`number of elements displayed in the datatables <sunstone_settings>` are remembered per user.
- **Improvements in usability**, to avoid errors, :ref:`Sunstone <sunstone>` now disables VM actions depending on the current state.
- **Ability to save VMs as templates**, for later use. :ref:`Saved VMs <save_vm_as_template_cloudview>` can have now more than one disk.


Contextualization
-------------------------------------

Contextualization improvements are also present:

- **Added ability to run arbitrary script**, to help customize guest OS using the START_SCRIPTS and START_SCRIPTS_BASE64 new :ref:`attributes <cong_user_template>`.
- **More flexible network attributes contextualization**, with the ability of overriding parameters from the network in the :ref:`Context section <bcont>`.

Command Line Interface
--------------------------------------------------------------------------------

The CLI has not been neglected in this release, to offer all the functionality developed and also to improve several aspects:

- **Default columns for the output reviewed**, to maximize the usefulness of the :ref:`cli <cli>` output. For instance, now the IP is shown in the output of onevm list, and the output of the leases table in the onevnet show command has been improved to fit in the owner information.
- **Context shown as another image**, so the target for instance of the :ref:`context CDROM <context_overview>` can be easily found.
- **Better logging and feedback**, for instance for the `onedb fsck </doc/4.12/cli/onedb.1.html>`__ tool and in `onevm </doc/4.12/cli/onevm.1.html>`__ help message. Moreover, the onedb upgrade + fsck now save the version of the DB when it backs it up.
- **Ability to import wild VMs**, using the the new `onehost importvm </doc/4.12/cli/onehost.1.html>`__ command. Also, now onehost sync is disallowed from root accounts to avoid permissions problems.


