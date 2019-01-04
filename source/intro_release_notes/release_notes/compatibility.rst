
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.7.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.7.

OpenNebula API & Database Schema
================================================================================

* The virtual machine pool table includes a new column with a short XML description of the VM. This speedups list operations on the VM pool for large deployments. Note that the XML document includes only the most relevant information, you need to perform a show API call or command to get the full information of the VM.

XMLRPC API Changes
--------------------------------------------------------------------------------
* Listing operations (`one*pool.info`) are shorted in descending order by default. This behavior can be reverted by a configuration flag in `oned.conf`
* Deploy action (`one.vm.deploy`) for Virtual Machines accepts an extra template to define the NIC chosen.
* Disk snapshot rename action (`one.vm.disksnapshotrename`) allow to rename a disk snapshot.
* Recover action (`one.vm.recover`) has a new option, **delete-db** for deleting the VM from OpenNebula but keep it running at the hypervisor.

Authentication Drivers
================================================================================
* LDAP user names are case insensitive, the driver now follows this convention. The fsck operation will warn about multiple users with different casing colliding in the same LDAP user account.

OpenNebula Core
================================================================================

* When different system datastore are available the TM_MAD_SYSTEM attribute will be set after picking the datastore.