.. _resolved_issues_561:

Resolved Issues in 5.6.1
--------------------------------------------------------------------------------

A complete list of solved issues for 5.6.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/17>`__.

The following new features has been backported to 5.6.1:

- List commands use pagination when in an interactive shell, the default pager is set to less but it can be customize through ``ONE_PAGER`` environment vairbale.
- Order of elements in list API calls (e.g. as in onevm list) can be selected (ascending or descending), see :ref:`the group configuration guide <manage_users_primary_and_secondary_groups>` for details.
- XMLRPC calls can report the client IP and PORT, see :ref:`XML-RPC Server Configuration <oned_conf_xml_rpc_server_configuration>` for details.


The following issues has been solved in 5.6.1:

- `User quotas error <https://github.com/OpenNebula/one/issues/2316>`__.
- `Migrate vCenter machines provide feedback to oned <https://github.com/OpenNebula/one/issues/2230>`__.
- `Fixed problem migrating vCenter machines to a cluster with a lot of ESX <https://github.com/OpenNebula/one/issues/2230>`__.
- `Improve feedback for 'mode' option in Sunstone server <https://github.com/OpenNebula/one/issues/2319>`__.
- `Accounting data does not display <https://github.com/OpenNebula/one/issues/2315>`__.
- `Spurios syntax help on onehost delete <https://github.com/OpenNebula/one/issues/2254>`__.
- `No way for hide Lock/Unlock button for VM in Sunstone view <https://github.com/OpenNebula/one/issues/2331>`__.
