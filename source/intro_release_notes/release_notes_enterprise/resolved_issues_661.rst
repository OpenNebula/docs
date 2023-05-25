.. _resolved_issues_661:

Resolved Issues in 6.6.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.6.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/64?closed=1>`__.

The following new features has been backported to 6.6.1:

- Restic and Rsync drivers allows to limit CPU and I/O resources consumed by the backup operations. See :ref:`the restic <vm_backups_restic>` and :ref:`the rsync <vm_backups_rsync>` documentation for more information.
- `Add support for nested group in LDAP <https://github.com/OpenNebula/one/issues/5952>`__.
- OneFlow Services support custom attributes for specific roles. See the :ref:`Using Custom Attributes in the Oneflow Service Management guide <appflow_use_cli>`
- `Restore incremental backups from a specific increment in the chain <https://github.com/OpenNebula/one/issues/6074>`__.
- `Automatically prune restic repositories <https://github.com/OpenNebula/one/issues/6062>`__.
- `Specify the base name of disk images and VM templates created when restoring a backup <https://github.com/OpenNebula/one/issues/6059>`__.
- `Retention policy for incremental backups <https://github.com/OpenNebula/one/issues/6029>`__.
- `Cluster provisions have been upgraded to use Ubuntu22.04 and Ceph Quincy versions <https://github.com/OpenNebula/one/issues/6116>`__.
- `OneStor was fixed to support persistent images <https://github.com/OpenNebula/one/issues/6147>`__.

The following issues has been solved in 6.6.1:

- `Fix disk RECOVERY_SNAPSHOT_FREQ on template instantiation on Ruby Sunstone <https://github.com/OpenNebula/one/issues/6067>`__.
- `Fix case sentive on FireEdge endpoints <https://github.com/OpenNebula/one/issues/6051>`__.
- `Fix multiple minor issues in Sunstone schedule actions forms <https://github.com/OpenNebula/one/issues/5974>`__.
- `Fix rsync backup driver to make use of RSYNC_USER value defined in the datastore template <https://github.com/OpenNebula/one/issues/6073>`__.
- `Fix locked resource by admin can be overriden by user lock. Fix lock --all flag <https://github.com/OpenNebula/one/issues/6022>`__.
- `Fix 'onetemplate instantiate' the persistent flag is not correctly handled <https://github.com/OpenNebula/one/issues/5916>`__.
- `Fix Enable/disable actions for host to reset monitoring timers <https://github.com/OpenNebula/one/issues/6039>`__.
- `Fix monitoring of NUMA memory and hugepages usage <https://github.com/OpenNebula/one/issues/6027>`__.
- `Fix AR removing on virtual network template <https://github.com/OpenNebula/one/issues/6061>`__.
- `Fix FS freeze value when QEMU Agent is selected on backup <https://github.com/OpenNebula/one/issues/6086>`__.
- `Fix trim of VNC/SPICE password <https://github.com/OpenNebula/one/issues/6085>`__.
- `Fix creating SWAP with CEPH datastore <https://github.com/OpenNebula/one/issues/6090>`__.
- `Fix CLI commands to not fail when config (/etc/one/cli/*.yaml) does not exist <https://github.com/OpenNebula/one/issues/5913>`__.
- `Fix permissions for 'onevm disk-resize', fix error code for 'onevm create-chart' <https://github.com/OpenNebula/one/issues/6068>`__.
- `Fix IPv6 was not being displayed on FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6106>`__.
- `Fix retry_if func in TM drivers <https://github.com/OpenNebula/one/issues/6078>`__.
- `Fix local characters for 'onedb upgrade' <https://github.com/OpenNebula/one/issues/6113>`__.
- `Fix filtered attributes for backup restoration (DEV_PREFIX, OS/UUID) <https://github.com/OpenNebula/one/issues/6044>`__.
- `Fix filtering MAC attribute only when no_ip is used <https://github.com/OpenNebula/one/issues/6048>`__.
- `Fix marketplace image download with wrong user from FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6048>`__.
- `Remove duplicated records in machine type and CPU model inputs <https://github.com/OpenNebula/one/issues/6135>`__.
- `Fix Sunstone backup dialog never shows up after deleting backups <https://github.com/OpenNebula/one/issues/6088>`__.
- `Fix Sunstone VM error when adding schedule action leases <https://github.com/OpenNebula/one/issues/6144>`__.
- `Fix Update the image name when it is selected in a template disk <https://github.com/OpenNebula/one/issues/6125>`__.
- `Fix catch error when XMLRPC is wrongly configured <https://github.com/OpenNebula/one/issues/6089>`__.
- `Fix one.vm.migrate call in Golang Cloud API (GOCA) <https://github.com/OpenNebula/one/issues/6108>`__.
- `Fix undeploy/stop actions leaving VMs defined in vCenter <https://github.com/OpenNebula/one/issues/5990>`__.
- `Fix Host system monitoring NETTX and NETRX <https://github.com/OpenNebula/one/issues/6114>`__.
- `Fix Sunstone overrides DISK SIZE attribute on instantiation <https://github.com/OpenNebula/one/issues/6215>`__.

Upgrading from OpenNebula 6.6.0 (Restic users only)
--------------------------------------------------------------------------------

Some of the new features of the backup module require a re-structure of the internal restic repositories. After upgrading you will need to:

- Create a new restic repository :ref:`as described in the restic guide (now the process is simpler) <vm_backups_restic>`.
- For VMs using incremental backups, create a new chain in the new backup datastore with the ``reset`` option.
- Update any scheduled backup action to point to the new backup datastore.
