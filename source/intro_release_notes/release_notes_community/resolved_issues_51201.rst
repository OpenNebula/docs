.. _resolved_issues_51201:

Resolved Issues in 5.12.0.1
--------------------------------------------------------------------------------

The following new features has been backported to 5.12.0.1:

- `Better same host detection for ssh/mv TM driver action <https://github.com/OpenNebula/one/issues/3460>`__.
- `PyONE call of system.config() returns correct object <https://github.com/OpenNebula/one/issues/4229>`__.
- `Contextualization packages are now included in the OpenNebula distribution <https://github.com/OpenNebula/one/issues/4944>`__.

The following issues has been solved in 5.12.0.1:

- `Fix vCenter monitoring stability issues <https://github.com/OpenNebula/one/commit/0c08d316d759ae8b7cdf58daf5f02818d0504d07>`__.
- `Fix monitoring of hybrid Amazon EC2 VMs <https://github.com/OpenNebula/one/commit/af801291dcbce981a778bae8afd540907771302b>`__.
- `Fix issue with hashed SSH known_hosts file and upcased hostname <https://github.com/OpenNebula/one/issues/4935>`__.
- `Fix Ruby library paths to support local overrides <https://github.com/OpenNebula/one/issues/4929>`__.
- `Fix systemd cleaning of SSH sockets that may lead to increased CPU usage <https://github.com/OpenNebula/one/issues/4939>`__.
- `Fix an error in monitoring that prevents state updates when there are wild VMs <https://github.com/OpenNebula/one/issues/4954>`__.
- `Fix microVM kernel boot process does not end properly when using docker image thingsboard/tb-postgres:3.0.1 <https://github.com/OpenNebula/one/issues/4952>`__.
- `Fix wrong monitoring of non oneadmin VMs <https://github.com/OpenNebula/one/issues/4978>`__.
