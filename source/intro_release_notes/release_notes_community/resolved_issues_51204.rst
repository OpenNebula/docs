.. _resolved_issues_51204:

Resolved Issues in 5.12.0.4
--------------------------------------------------------------------------------

The following new features has been backported to 5.12.0.4:

- `Add OneGate features for VNF <https://github.com/OpenNebula/one/issues/5112>`__.
- `Add new infoset API call for vm pool <https://github.com/OpenNebula/one/issues/5112>`__.
- `Improve monitoring API calls performance <https://github.com/OpenNebula/one/issues/5147>`__.
- Distribution packages for Ubuntu 20.10 and Fedora 33

The following issues has been solved in 5.12.0.4:

- `Fix DB migration from 5.10 to 5.12 <https://github.com/OpenNebula/one/issues/5013>`__.
- `Fix force IP when instantiate a vm in Sunstone <https://github.com/OpenNebula/one/issues/5061>`__.
- `Fix for hot disk resize on vCenter <https://github.com/OpenNebula/one/issues/4569>`__.
- `Fix CLI command onevm disk-attach not setting return code when using a non existing file <https://github.com/OpenNebula/one/issues/5074>`__.
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
- `Fix VM created from "Schedule Actions for VM" <https://github.com/OpenNebula/one/issues/5016>`__
- `Fix bug when terminating a VM that belongs to a service <https://github.com/OpenNebula/one/issues/5142>`__.
- `Fix issue when using elasticity rules that reference to monitoring information <https://github.com/OpenNebula/one/issues/5143>`__.
- `Fix services not progressing from COOLDOWN when VMS are deleted <https://github.com/OpenNebula/one/issues/5145>`__.
- `Fix user inputs when instantiate flow template in Sunstone <https://github.com/OpenNebula/one/issues/5152>`__.
- `Do not recreate VNC password if password already exists <https://github.com/OpenNebula/one/issues/5139>`__. Note: If the VM template contains both attributes PASSWD and RANDOM_PASSWD the password will not be generated.
- `Fix RANK expressions that contains DATASTORES metrics MAX_DISK, FREE_DISK, USED_DISK and DISK_USAGE <https://github.com/OpenNebula/one/issues/5154>`__.
