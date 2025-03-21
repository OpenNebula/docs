.. _resolved_issues_6104:

Resolved Issues in 6.10.4
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/83?closed=1>`__.

The following new features have been backported to 6.10.4:

- `Add support of using defined timezone by oneacct utility with flag -t/--timezone  <https://github.com/OpenNebula/one/issues/821>`__.

The following issues has been solved in 6.10.4:

- `Fix a bug when Restic passwords include quotes <https://github.com/OpenNebula/one/issues/6666/>`__.
- `Fix onevrouter instantiate command prompts for user input unnecessarily <https://github.com/OpenNebula/one/issues/6948/>`__.
- `Fix user-input option for CLI to support values containing commas and equal signs <https://github.com/OpenNebula/one/issues/6975/>`__.
- `Fix VM migration not executed on vCenter when src host ID is 0 <https://github.com/OpenNebula/one/issues/6997/>`__.

The following issues have been solved in the Sunstone Web UI:

Changes in Configuration Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since version 6.10.3 the following changes apply to OpenNebula services configuration files:


.. warning:: The following attributes are not included in the configuration files distributed with 6.10.4. If you wish to use these attributes, add them manually to the corresponding file.


FireEdge Service
^^^^^^^^^^^^^^^^

+----------------------+-----------------------------------------------+-----------------------------------------------------+-------------+
| Config file          | Description                                   | Action                                              | Values      |
+======================+===============================================+=====================================================+=============+
+----------------------+-----------------------------------------------+-----------------------------------------------------+-------------+
