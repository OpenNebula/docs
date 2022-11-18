.. _resolved_issues_643:

Resolved Issues in 6.4.3
--------------------------------------------------------------------------------


A complete list of solved issues for 6.4.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/63?closed=1>`__.

The following new features has been backported to 6.4.3:

- The autostart hooks include a new mode:``always`` to :ref:`restart a VM when a host is rebooted regardless its previous state. <hook_manager_autostart>`

The following issues has been solved in 6.4.3:

- `Fix an error that prevents migrating a VM when it has more than 10 defined snapshots <https://github.com/OpenNebula/one/issues/5991>`__.
- `Fix RETIME after onevm recover <https://github.com/OpenNebula/one/issues/5950>`__.
- `Fix when a very long label is added, the text is incomplete <https://github.com/OpenNebula/one/issues/5998>`__.
- `Fix min/max vms data type overwrite on update <https://github.com/OpenNebula/one/issues/5983>`__.
- `Fix charter icon in services list not being updated <https://github.com/OpenNebula/one/issues/6007>`__.
- `Fix group creation on Alma9 <https://github.com/OpenNebula/one/issues/5993>`__.
- `Fix Sunstone advanced serach with special characters <https://github.com/OpenNebula/one/issues/6021>`__.
- `Fix for vCenter upload/download functionality broken in ruby3 <https://github.com/OpenNebula/one/issues/5996>`__.
