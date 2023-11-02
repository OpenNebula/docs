.. _resolved_issues_681:

Resolved Issues in 6.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/71?closed=1>`__.

The following new features has been backported to 6.8.1:

- `Optimized implementation of standard input capable commands  <https://github.com/OpenNebula/one/issues/6242>`__. Other commands were updated as well to handle standard input.
- Minor optimization on the ``oneflow-template instantiate`` command when using the ``--multiple`` option.
- `Added the VM Group templates tab to Fireedge Sunstone <https://github.com/OpenNebula/one/issues/5901>`__.
  - The new configuration files can be downloaded from `here <https://bit.ly/one-68-maintenance-config>`__

The following issues has been solved in 6.8.1:

- Fix "NUMA" and "OS & CPU" tabs on Fireedge Sunstone return an error when at least one host contains a NUMA node that has exactly one hugepage.
- Fix disk live-snapshot operation for the SSH drivers.
- `Fix an issue where KVM system snapshots would not be carried over to the new host after live migrating a VM <https://github.com/OpenNebula/one/issues/6363>`__.
- `Fix certain graphs to correctly display delta values <https://github.com/OpenNebula/one/issues/6347>`__.
- `Fix update of Virtual Network with empty attributes, which sometimes caused ERROR state <https://github.com/OpenNebula/one/issues/6367>`__.
- `Fix VM templates with NIC and NIC alias <https://github.com/OpenNebula/one/issues/6349>`__.
- `Fix error handling when reusing names while downloading Marketplace service appliances <https://github.com/OpenNebula/one/issues/6370>`__.
