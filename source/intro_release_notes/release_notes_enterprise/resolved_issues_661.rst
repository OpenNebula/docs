.. _resolved_issues_661:

Resolved Issues in 6.6.1
--------------------------------------------------------------------------------


A complete list of solved issues for 6.6.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/64?closed=1>`__.

The following new features has been backported to 6.6.1:

- Restic and Rsync drivers allows to limit CPU and I/O resources consumed by the backup operations. See :ref:`the restic <vm_backups_restic>` and :ref:`the rsync <vm_backups_rsync>` documentation for more information.
- `Add support for nested group in LDAP <https://github.com/OpenNebula/one/issues/5952>`__.
- OneFlow Services support custom attributes for specific roles. See the :ref:`Using Custom Attributes in the Oneflow Service Management guide <appflow_use_cli>`

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
