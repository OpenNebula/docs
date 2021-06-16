.. _resolved_issues_5121:

Resolved Issues in 5.12.1
--------------------------------------------------------------------------------

A complete list of solved issues for 5.12.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/36>`__.

The following new features has been backported to 5.12.1:

- `Add support for VM Charters in the CLI <https://github.com/OpenNebula/one/issues/4552>`__.
- `New failover combinations for Provision module <https://github.com/OpenNebula/one/issues/4205>`__.
- `Add CLI autocomplete on tab feature <https://github.com/OpenNebula/one/issues/607>`__.
- `Arguments and format in CLI tools help messages are sorted in alphabetical order <https://github.com/OpenNebula/one/issues/4943>`__.
- `Better same host detection for ssh/mv TM driver action <https://github.com/OpenNebula/one/issues/3460>`__.
- `PyONE call of system.config() returns correct object <https://github.com/OpenNebula/one/issues/4229>`__.
- `Contextualization packages are now included in the OpenNebula distribution <https://github.com/OpenNebula/one/issues/4944>`__.
- `LDAP auth driver allows choosing the LDAP server by maching username to a list of regexp <https://github.com/OpenNebula/one/issues/4924>`__.

The following issues has been solved in 5.12.1:

- `Fix vCenter monitoring stability issues <https://github.com/OpenNebula/one/commit/0c08d316d759ae8b7cdf58daf5f02818d0504d07>`__.
- `Fix monitoring of hybrid Amazon EC2 VMs <https://github.com/OpenNebula/one/commit/af801291dcbce981a778bae8afd540907771302b>`__.
- `Fix logging information for services <https://github.com/OpenNebula/one/issues/796>`__.
- `Fix onevnet updatear command to include --append option <https://github.com/OpenNebula/one/issues/810>`__.
- `Fix onevcenter list -o datastores command to show the full REF <https://github.com/OpenNebula/one/issues/2703>`__.
- `Fix scheduled policy start_time to support POSIX time definition <https://github.com/OpenNebula/one/issues/668>`__.
- `Fix Firecracker deployment and cleanup race condition error <https://github.com/OpenNebula/one/issues/4926>`__.
- `Fix issue with hashed SSH known_hosts file and upcased hostname <https://github.com/OpenNebula/one/issues/4935>`__.
- `Fix Ruby library paths to support local overrides <https://github.com/OpenNebula/one/issues/4929>`__.
- `Fix systemd cleaning of SSH sockets that may lead to increased CPU usage <https://github.com/OpenNebula/one/issues/4939>`__.
- `Fix sort by used CPU and used Memory in VM list <https://github.com/OpenNebula/one/issues/4031>`__.
- `Fix remote buttons after state VM switches to RUNNING in Sunstone <https://github.com/OpenNebula/one/issues/4948>`__.
- `Fix VM instantiate doesn't ask for user inputs in Sunstone <https://github.com/OpenNebula/one/issues/4946>`__.
- `Fix disk resize doesn't show error on VCenter with snapshots in Sunstone <https://github.com/OpenNebula/one/issues/4928>`__.
- `Fix Cloud View dashboard doesn't have a correct value for running VMs quota in Sunstone <https://github.com/OpenNebula/one/issues/4951>`__.
- `Fix microVM kernel boot process does not end properly when using docker image thingsboard/tb-postgres:3.0.1 <https://github.com/OpenNebula/one/issues/4952>`__.
- `Fix an error in monitoring that prevents state updates when there are wild VMs <https://github.com/OpenNebula/one/issues/4954>`__.
- `Fix for vCenter monitoring memory consumption <https://github.com/OpenNebula/one/issues/4965>`__.
