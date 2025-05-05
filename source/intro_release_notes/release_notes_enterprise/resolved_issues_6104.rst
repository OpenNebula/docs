.. _resolved_issues_6104:

Resolved Issues in 6.10.4
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/83?closed=1>`__.

The following new features have been backported to 6.10.4:

- `Add support of using defined timezone by oneacct utility with flag -t/--timezone  <https://github.com/OpenNebula/one/issues/821>`__.
- Console logging for :ref:`LXC Driver <lxc_logs>`.

The following issues has been solved in 6.10.4:

- `Fix a bug when Restic passwords include quotes <https://github.com/OpenNebula/one/issues/6666/>`__.
- `Fix onevrouter instantiate command prompts for user input unnecessarily <https://github.com/OpenNebula/one/issues/6948/>`__.
- `Fix user-input option for CLI to support values containing commas and equal signs <https://github.com/OpenNebula/one/issues/6975/>`__.
- `Fix VM migration not executed on vCenter when src host ID is 0 <https://github.com/OpenNebula/one/issues/6997/>`__.
- `Fix VNet instance doesn't update BRIDGE_TYPE, when VN_MAD is updated <https://github.com/OpenNebula/one/issues/6858/>`__.
- `Fix oneacl rules not being cleaned-up after removing a group admin <https://github.com/OpenNebula/one/issues/6993/>`__.
- `Fix ability to add and remove existing users to existing groups and change main group from an user <https://github.com/OpenNebula/one/issues/6980/>`__. In order to add, remove or change main group from and user, please see **Changes in Configuration Files** section below.
- `Fix vGPU profile monitoring for legacy mode <https://github.com/OpenNebula/one/issues/7012/>`__.
- `Fix README.md links to old paths <https://github.com/OpenNebula/one/issues/7032>`__.
- `Fix a silent LXC container start fail <https://github.com/OpenNebula/one/issues/7028>`__.

The following issues have been solved in the Sunstone Web UI:

Changes in Configuration Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since version 6.10.3 the following changes apply to OpenNebula services configuration files:


.. warning:: The following attributes are not included in the configuration files distributed with 6.10.4. If you wish to use these attributes, add them manually to the corresponding file.


FireEdge Service
^^^^^^^^^^^^^^^^

+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| Config file          | Description                                                  | Action                                                | Values      |
+======================+==============================================================+=======================================================+=============+
| group-tab.yaml       | New attribute: info-tabs.user.actions.add_users              | Sets the 'Add user' button in Groups page             | true, false |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| group-tab.yaml       | New attribute: info-tabs.user.actions.remove_users           | Sets the 'Remove user' button in Groups page          | true, false |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| user-tab.yaml        | New attribute: info-tabs.group.actions.add_to_group          | Sets the 'Add to group' button in Users page          | true, false |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| user-tab.yaml        | New attribute: info-tabs.group.actions.remove_from_group     | Sets the 'Remove from group' button in Groups page    | true, false |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| user-tab.yaml        | New attribute: info-tabs.group.actions.change_primary_group  | Sets the 'Change primary group' button in Groups page | true, false |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
