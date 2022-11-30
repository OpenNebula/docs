.. _vm_backups_operations:

================================================================================
Overview
================================================================================

This chapter contains documentation on how to create and manage Virtual Machines Backups. Backups are managed through the datastore and image abstractions. In this way, all the concepts that apply to these objects also apply to backups like access control or quotas. Backup datastores can be defined using two backends (datastore drivers):

  - restic (**Only EE**) based on the `restic backup tool <https://restic.net/>`_
  - rsync, that uses the `rsync utility <https://rsync.samba.org/>`_ to transfer backup files.


How Should I Read This Chapter
================================================================================

Hypervisor & Storage Compatibility
================================================================================

