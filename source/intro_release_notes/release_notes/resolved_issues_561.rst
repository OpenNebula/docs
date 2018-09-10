.. _resolved_issues_561:

Resolved Issues in 5.6.1
--------------------------------------------------------------------------------

A complete list of solved issues for 5.6.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/17>`__.

The following new features has been backported to 5.6.1:

- List commands use pagination when in an interactive shell, the default pager is set to less but it can be customize through ``ONE_PAGER`` environment vairbale.
- Order of elements in list API calls (e.g. as in onevm list) can be selected (ascending or descending), see :ref:`the group configuration guide <manage_users_primary_and_secondary_groups>` for details.
- XMLRPC calls can report the client IP and PORT, see :ref:`XML-RPC Server Configuration <oned_conf_xml_rpc_server_configuration>` for details.
- New quotas for VMS allow you to configure limits for VMs "running", see :ref:`quotas <quota_auth>` for more details.
- Update Host hook triggers to include all possible states, the states are define :ref:`here <hooks>`.

The following issues has been solved in 5.6.1:

- `User quotas error <https://github.com/OpenNebula/one/issues/2316>`__.
- `Migrate vCenter machines provide feedback to oned <https://github.com/OpenNebula/one/issues/2230>`__.
- `Fixed problem migrating vCenter machines to a cluster with a lot of ESX <https://github.com/OpenNebula/one/issues/2230>`__.
- `Improve feedback for 'mode' option in Sunstone server <https://github.com/OpenNebula/one/issues/2319>`__.
- `Accounting data does not display <https://github.com/OpenNebula/one/issues/2315>`__.
- `Spurios syntax help on onehost delete <https://github.com/OpenNebula/one/issues/2254>`__.
- `No way for hide Lock/Unlock button for VM in Sunstone view <https://github.com/OpenNebula/one/issues/2331>`__.
- `Fix for fs_lvm driver when live migrating with shared devices <https://github.com/OpenNebula/one/pull/2344>`__.
- `Update LDAP driver to use new escaping functionality <https://github.com/OpenNebula/one/pull/2345>`__ (and `issue <https://github.com/OpenNebula/one/issues/2372>`__).
- `Start script base64 enconding fails when using non utf8 characters <https://github.com/OpenNebula/one/issues/2384>`__.
- `Error when creating a vnet from Sunstone using advanced mode <https://github.com/OpenNebula/one/issues/2348>`__.
- `Restricted attributes not enforced on attach disk operation <https://github.com/OpenNebula/one/issues/2374>`__.
- `Improve the dialog when attach nic or instanciated vm in network tab <https://github.com/OpenNebula/one/issues/2394>`__.
- `VNC on ESXi Can Break Firewall <https://github.com/OpenNebula/one/issues/1728>`__.
- `Slow monitoring of the live migrating VMs on destination host <https://github.com/OpenNebula/one/issues/2388>`__.
- `onehost sync should ignore vCenter hosts <https://github.com/OpenNebula/one/issues/2398>`__.
- `Unable to query VMs with non ASCII character <https://github.com/OpenNebula/one/issues/2355>`__.
