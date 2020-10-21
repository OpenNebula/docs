.. _resolved_issues_5125:

Resolved Issues in 5.12.5
--------------------------------------------------------------------------------

A complete list of solved issues for 5.12.5 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/41?closed=1>`__.

The following issues has been solved in 5.12.5:

- `Fix HookLog for PostgreSQL <https://github.com/OpenNebula/one/issues/5072>`__.
- `Fix oned monitoring API bug with PostgreSQL <https://github.com/OpenNebula/one/issues/5081>`__.
- `Fix quotas misbehavior when resuming a running VM <https://github.com/OpenNebula/one/issues/5106>`__
- `Fix boolean user inputs <https://github.com/OpenNebula/one/issues/5107>`__
- `Fix marketplace not displayed in federation zones (slaves) <https://github.com/OpenNebula/one/issues/5114>`__
- `Fix hosts remain in ERROR state on vCenter restart <https://github.com/OpenNebula/one/issues/5108>`__
- `Fix keep opennebula_manage attribute when disks are updated <https://github.com/OpenNebula/one/issues/5115>`__
- `Fix race condition when creating VDCs in a federated environment  <https://github.com/OpenNebula/one/issues/5110>`__
- `Fix user input when is empty <https://github.com/OpenNebula/one/issues/5120>`__
- `Fix Sunstone doesn't work with remote oned <https://github.com/OpenNebula/one/issues/5019>`__
- `Fix Sunstone VM charters illegible on data tables <https://github.com/OpenNebula/one/issues/4997>`__
- `Fix reconnect to MySQL and PostgreSQL DB <https://github.com/OpenNebula/one/issues/5094>`__
- `Fix NIC attribute overrides <https://github.com/OpenNebula/one/issues/5095>`__
- `Fix VNC allocation when migrating across clusters <https://github.com/OpenNebula/one/issues/5131>`__
- `Fix VM created from "Schedule Actions for VM <https://github.com/OpenNebula/one/issues/5016>"`__

.. warning:: Note that this version solves NIC attribute overrides. It preserves the precedence of NIC values so Virtual Network attributes can be overridden. Please update your oned.conf file ``VM_RESTRICTED_ATTR`` to prevent users from sensible overwriting Virtual Network values.
