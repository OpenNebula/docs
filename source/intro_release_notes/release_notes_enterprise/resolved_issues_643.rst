.. _resolved_issues_643:

Resolved Issues in 6.4.5
--------------------------------------------------------------------------------


A complete list of solved issues for 6.4.5 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/63?closed=1>`__.

The following new features has been backported to 6.4.5:

- The autostart hooks include a new mode:``always`` to :ref:`restart a VM when a host is rebooted regardless its previous state. <hook_manager_autostart>`

The following issues has been solved in 6.4.5:

- `Fix an error that prevents migrating a VM when it has more than 10 defined snapshots <https://github.com/OpenNebula/one/issues/5991>`__.
- `Fix RETIME after onevm recover <https://github.com/OpenNebula/one/issues/5950>`__.
- `Fix when a very long label is added, the text is incomplete <https://github.com/OpenNebula/one/issues/5998>`__.
- `Fix min/max vms data type overwrite on update <https://github.com/OpenNebula/one/issues/5983>`__.
- `Fix charter icon in services list not being updated <https://github.com/OpenNebula/one/issues/6007>`__.
- `Fix group creation on Alma9 <https://github.com/OpenNebula/one/issues/5993>`__.
- `Fix Sunstone advanced serach with special characters <https://github.com/OpenNebula/one/issues/6021>`__.
- `Fix for vCenter upload/download functionality broken in ruby3 <https://github.com/OpenNebula/one/issues/5996>`__.
- `Fix VM and VNET drivers so they do not evaluate execution quotes through STDIN <https://github.com/OpenNebula/one/pull/6011>`__.
- `Fix oneflow-server default endpoint on Sunstone <https://github.com/OpenNebula/one/issues/6026>`__.
- `Fix support tab to show new tickets <https://github.com/OpenNebula/one/issues/5995>`__.
- `Fix vnet creation when changing the network mode to vCenter and then changing it again <https://github.com/OpenNebula/one/issues/5996>`__.
- `Fix filter by label on FireEdge Sunstone <https://github.com/OpenNebula/one/issues/5999>`__.
- `Fix LDAP driver to work with Ruby 2.0 <https://github.com/OpenNebula/one/commit/33552502055e9893fa3e1bf5c86062d7e14390f0>`__.
- `Fix regex in the fix_dir_slashes function for bash datastore/transfer manager drivers <https://github.com/OpenNebula/one/issues/5668>`__.
- `Fix arguments parsing for onemonitord <https://github.com/OpenNebula/one/issues/5728>`__.
- `Fix ceph clone operation <https://github.com/OpenNebula/one/commit/af5044f2676b4bfda0845dc9873db2b87bb15b72>`__.
- `Fix NETRX and NETTX for accounting <https://github.com/OpenNebula/one/issues/5640>`__.
- `Fix locked resource by admin can be overriden by user lock. Fix lock --all flag <https://github.com/OpenNebula/one/issues/6022>`__.
- `Fix 'onetemplate instantiate' the persistent flag is not correctly handled <https://github.com/OpenNebula/one/issues/5916>`__.
- `Fix Enable/disable host actio to reset monitoring timers <https://github.com/OpenNebula/one/issues/6039>`__.
- `Fix monitoring of NUMA node memory and hugepages usage <https://github.com/OpenNebula/one/issues/6027>`__.
- `Fix AR removing on virtual network template <https://github.com/OpenNebula/one/issues/6061>`__.
- `Fix typo in FireEdge sunstone Topology functionality <https://github.com/OpenNebula/one/issues/6094>`__.
- `Fix trim of VNC/SPICE password <https://github.com/OpenNebula/one/issues/6085>`__.
- `Fix creating SWAP with CEPH datastore <https://github.com/OpenNebula/one/issues/6090>`__.
- `Add support to HTTPS proxy <https://github.com/OpenNebula/one/issues/6100>`__.
