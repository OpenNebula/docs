.. _resolved_issues_583:

Resolved Issues in 5.8.3
--------------------------------------------------------------------------------

A complete list of solved issues for 5.8.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/26>`__.

The following new features has been backported to 5.8.3:

- `Implement retry on vCenter driver actions <https://github.com/OpenNebula/one/issues/3337>`__.
- `Allow FILES in vCenter context <https://github.com/OpenNebula/one/issues/964>`__.
- `Allow alternative search base for ldap groups <https://github.com/OpenNebula/one/issues/3366>`__.
- `Show the federation index in onezone list command <https://github.com/OpenNebula/one/issues/3378>`__. If you want to enable this column, please update your `/etc/one/cli/onezone.yaml <https://github.com/OpenNebula/one/blob/master/src/cli/etc/onezone.yaml>`__ file.

The following issues has been solved in 5.8.3:

- `Fix Ceph monitoring when using erasure code pools <https://github.com/OpenNebula/one/issues/3222>`__.
- `Fix an issue when importing vCenter hosts and an OpenNebula cluster with the same name exists <https://github.com/OpenNebula/one/issues/3280>`__.
- `Fix wild VM import process to not default to host 0 <https://github.com/OpenNebula/one/issues/3281>`__.
- `Fix Sunstone support token configuration not working behind a proxy <https://github.com/OpenNebula/one/issues/3331>`__.
- `Fix NIC Alias id generation to be consecutive <https://github.com/OpenNebula/one/issues/3357>`__.
- `Fix onedb fsck to not remove NIC Alias from Address Range leases <https://github.com/OpenNebula/one/issues/3362>`__.
- `Fix onedb purge-done to not eat too much ram <https://github.com/OpenNebula/one/issues/3269>`__.
- `Fix missing datastores when import appliance from marketplace <https://github.com/OpenNebula/one/issues/3368>`__.
- `Fix bug in quotas FSCK when having reserved networks <https://github.com/OpenNebula/one/issues/1710>`__.
- `Fix missing DEPLOY_ID when import Wilds VM <https://github.com/OpenNebula/one/issues/3057>`__.
- `Fix error in onegate when trying to make an operation in an specific VM <https://github.com/OpenNebula/one/issues/2047>`__.
- `Fix an error that propagates local quota information to other zones <https://github.com/OpenNebula/one/issues/3409>`__.
