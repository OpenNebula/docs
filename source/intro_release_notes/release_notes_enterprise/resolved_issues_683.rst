.. _resolved_issues_683:

Resolved Issues in 6.8.3
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/75?closed=1>`__.


The following new features have been backported to 6.8.3:

- Option to restore individual disk from backup Image see :ref:`Restoring Backups <vm_backups_restore>`.

.. note::
   In order to use the new functionality introduced in Fireedge sunstone, please refer to the following :ref:`guide <fireedge_files_note>`.


The following issues have been solved in 6.8.3:

- `Fix quota after VM disk (de)attach for CEPH, LVM datastores <https://github.com/OpenNebula/one/issues/6506>`__.
- `Fix disk size and quotas after VM disk revert to snapshot with smaller size <https://github.com/OpenNebula/one/issues/6503>`__.
- `Fix README.md to include a reference to the Quick Start guide <https://github.com/OpenNebula/one/issues/6513>`__.
- `Fix incorrect filtering of remove_off_hosts <https://github.com/OpenNebula/one/issues/6472>`__.
- `Fix error reporting of CLI tools for JSON and YAML output <https://github.com/OpenNebula/one/issues/6509>`__.
- `Fix LDAP group athorization for AD <https://github.com/OpenNebula/one/issues/6528>`__.
- `Fix CLI listing formatting ignored when passing --search <https://github.com/OpenNebula/one/issues/6511>`__.
- `Fix upgrade of Scheduled Actions, 'onedb fsck' checks Scheduled Action consistency <https://github.com/OpenNebula/one/issues/6541>`__.


Also, the following issues have been backported in the FireEdge Sunstone Web UI:

- `Implement Support Tab <https://github.com/OpenNebula/one/issues/5905>`__.
- `Implement Zone Tab <https://github.com/OpenNebula/one/issues/6120>`__.
- Added the Marketplace tab to Fireedge Sunstone. See :ref:`the Marketplaces guide <marketplaces>` for more information.
