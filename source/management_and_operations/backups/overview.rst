.. _vm_backups_overview:

================================================================================
Overview
================================================================================

This chapter contains documentation on how to create and manage Virtual Machines Backups. Backups are managed through the datastore and image abstractions. In this way, all the concepts that apply to these objects also apply to backups like access control or quotas. Backup datastores can be defined using two backends (datastore drivers):

  - restic (**Only EE**) based on the `restic backup tool <https://restic.net/>`_
  - rsync, that uses the `rsync utility <https://rsync.samba.org/>`_ to transfer backup files.


How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This Chapter is structured as follows:

  - First, you will learn how to setup a datastore to save your VM backups, :ref:`for the restic backend <vm_backups_restic>` and :ref:`for the rsync datastore <vm_backups_rsync>`.
  - And then, you will find out :ref:`how to perform and schedule VM backups, as well as to restore them<vm_backups_operations>`.

Hypervisor & Storage Compatibility
================================================================================

Performing a VM backup may require some support from the hypervisor or the disk image formats. The following table summarizes the backup modes supported for each hypervisor and storage system.

+------------+------------------------+------+-----------+------+-----------+
| Hypervisor | Storage                | Full             | Incremental      |
+            +                        +------+-----------+------+-----------+
|            |                        | Live | Power off | Live | Power off |
+============+========================+======+===========+======+===========+
|  KVM       | File\ :sup:`*` (qcow2) | Yes  | Yes       |  Yes |   Yes     |
+            +------------------------+------+-----------+------+-----------+
|            | File\ :sup:`*` (raw)   | Yes  | Yes       |  No  |   No      |
+            +------------------------+------+-----------+------+-----------+
|            | Ceph                   | Yes  | Yes       |  No  |   No      |
+            +------------------------+------+-----------+------+-----------+
|            | LVM                    | Not supported                       |
+------------+------------------------+------+-----------+------+-----------+
|  LXC       | File (any format)      | No   | Yes       |  No  |   No      |
|            +------------------------+------+-----------+------+-----------+
|            | Ceph                   | No   | Yes       |  No  |   No      |
|            +------------------------+------+-----------+------+-----------+
|            | LVM                    | Not supported                       |
+------------+------------------------+------+-----------+------+-----------+
|  vCenter   | vCenter                | Not supported                       |
+------------+------------------------+------+-----------+------+-----------+

\ :sup:`*` Means any datastore based on files with the given format, i.e. NFS/SAN or SSH
