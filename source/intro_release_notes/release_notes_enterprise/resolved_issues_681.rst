.. _resolved_issues_681:

Resolved Issues in 6.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/71?closed=1>`__.

The following new features has been backported to 6.8.1:

- `Optimized implementation of standard input capable commands  <https://github.com/OpenNebula/one/issues/6242>`__. Other commands were updated as well to handle standard input.
- Minor optimization on the ``oneflow-template instantiate`` command when using the ``--multiple`` option.

The following issues has been solved in 6.8.1:

- Fix "NUMA" and "OS & CPU" tabs on Fireedge Sunstone return an error when at least one host contains a NUMA node that has exactly one hugepage.
- `Added the VM Group templates tab to Fireedge Sunstone <https://github.com/OpenNebula/one/issues/5901>`__.
  - The new configuration files can be downloaded from `here <https://bit.ly/one-68-maintenance-config>`__
- `Fix an issue where KVM system snapshots would not be carried over to the new host after live migrating a VM <https://github.com/OpenNebula/one/issues/6363>`__.
- `Certain graphs now correctly display the delta values <https://github.com/OpenNebula/one/issues/6347>`__.
- `Fix update of Virtual Network with empty attributes, which sometimes caused ERROR state <https://github.com/OpenNebula/one/issues/6367>`__.
- `Creating VM templates with NIC + alias NIC now works correctly <https://github.com/OpenNebula/one/issues/6349>`__.
- `Fix DockerHub downloader to handle images that are missing the Cmd property <https://github.com/OpenNebula/one/issues/6374>`__.
- `Fix DockerHub downloader to handle images that are missing the latest tag like RockyLinux <https://github.com/OpenNebula/one/issues/6196>`__.
- `Fix error management for DockerHub downloader on multiple steps of the import process <https://github.com/OpenNebula/one/issues/6197>`__.
