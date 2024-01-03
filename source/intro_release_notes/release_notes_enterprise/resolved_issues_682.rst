.. _resolved_issues_682:

Resolved Issues in 6.8.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/73?closed=1>`__.

The following new features have been backported to 6.8.2:

- Virtual Routers now support ``FLOATING_ONLY`` attributes for their network NICs. When this attribute is set to ``yes`` no additional IPs are allocated for the VMs of the VR, :ref:`see more information on the Virtual Router guide <vrouter>`.

The following issues has been solved in 6.8.2:

- `Fix possible segfault in VM disk resize <https://github.com/OpenNebula/one/issues/6432>`__.
- `Fix monitoring encryption <https://github.com/OpenNebula/one/issues/6445>`__.
- `Fix accounting after resizing VM memory or CPU <https://github.com/OpenNebula/one/issues/6387>`__.
