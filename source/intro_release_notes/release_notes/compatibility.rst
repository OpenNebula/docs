
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.8.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.8.

OpenNebula API & Database Schema
================================================================================

* The virtual machine pool table includes a new column with a short XML description of the VM. This speeds up list operations on the VM pool for large deployments. Note that the XML document includes only the most relevant information, you need to perform a show API call or command to get the full information of the VM.
* The VM pool includes two new indexes, a full-text-search index to perform VM searches on any attribute and an oid-state index to speed-up state based queries.

XMLRPC API Changes
--------------------------------------------------------------------------------
* Listing operations (`one*pool.info`) are shorted in descending order by default. This behavior can be reverted by a configuration flag in `oned.conf`
* Deploy action (`one.vm.deploy`) for Virtual Machines accepts an extra template to define the NIC chosen.
* Disk snapshot rename action (`one.vm.disksnapshotrename`) allow to rename a disk snapshot.
* Recover action (`one.vm.recover`) has a new option, **delete-db** for deleting the VM from OpenNebula but keep it running at the hypervisor.
* Lock action (`one.resource.lock`) now return the ID of the resource on success, instead of a boolean value. In case of failure an error of type ACTION is returned.
* `one.vmpool.info` return a short version of the VM body documents, in order improve the scalability on large environments. Note that the new search functionality of the vmpool can further aliviate this issues.

.. note:: The old behavior of `one.vmpool.info` call can be achieved via `one.vmpool.infoextended`. If an hypervisor different from KVM or LXD is used some attributes used by Sunstone can be unavailable with `one.vmpool.info` (:ref:`more info <monitoring_information_not_showing_on_vm_list_in_sunstone>`), for this case, Sunstone can be forced to use the extended pool, check the ```:get_extended_vm_info``` configuration attribute :ref:`here <sunstone_sunstone_server_conf>`.

Authentication Drivers
================================================================================
* LDAP user names are case insensitive, the driver now follows this convention. The fsck operation will warn about multiple users with different casing colliding in the same LDAP user account.

OpenNebula Core
================================================================================

* When different system datastores are available the TM_MAD_SYSTEM attribute is automatically set to the DS chosen by the scheduler.
* Images are not locked on creation so the metadata can be updated while the image is being downloaded but. In order to delete the image while it's in LOCKED state the user needs ADMIN permissions over the image.

KVM Drivers
=================================================================================
* oned.conf needs to be updated to set KEEP_SNAPSHOTS to yes in oned.conf for the KVM driver. Note that this change will be only available for new VMs. Existing VMs would not be able to revert a pre-upgrade snapshots after a migration.

vCenter Drivers
=================================================================================
* New VM migration (host and DS) functionality may require ESX_MIGRATION_LIST parameter added to the target host. Check :ref:`here <vcenter_migrate>` for details.

LVM Datastore Drivers
=================================================================================
* Volatile disks are now created as logical volume instead of a file.

Packages
=================================================================================
* All Ruby gem dependencies should be installed in required versions only via ``/usr/share/one/install_gems``. To avoid version mismatch, the OpenNebula packages for Ubuntu and Debian now conflict with the following distribution packages:

  - thin
  - ruby-rack
  - ruby-rack-protection
  - ruby-sinatra
