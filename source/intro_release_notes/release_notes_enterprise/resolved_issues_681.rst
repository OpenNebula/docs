.. _resolved_issues_681:

Resolved Issues in 6.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/71?closed=1>`__.

The following new features has been backported to 6.8.1:

- `Optimized implementation of standard input capable commands  <https://github.com/OpenNebula/one/issues/6242>`__. Other commands were updated as well to handle standard input.
- Minor optimization on the ``oneflow-template instantiate`` command when using the :ref:`--multiple <cli_flow>` option.
- Added the VM Group templates tab to Fireedge Sunstone. See :ref:`the VM affinity guide <vmgroups>` for more information.
  - The new configuration files can be downloaded from `here <https://bit.ly/one-68-maintenance-config>`__
- Implemented :ref:`Backup Jobs <vm_backup_jobs>` tab in FireEdge Sunstone.

The following issues has been solved in 6.8.1:

- `Fix an issue where KVM system snapshots would not be carried over to the new host after live migrating a VM <https://github.com/OpenNebula/one/issues/6363>`__.
- `Fix certain graphs to correctly display delta values <https://github.com/OpenNebula/one/issues/6347>`__.
- `Fix update of Virtual Network with empty attributes, which sometimes caused ERROR state <https://github.com/OpenNebula/one/issues/6367>`__.
- `Fix VM templates with NIC and NIC alias <https://github.com/OpenNebula/one/issues/6349>`__.
- `Fix error handling when reusing names while downloading Marketplace service appliances <https://github.com/OpenNebula/one/issues/6370>`__.
- `Refactored label naming conventions, no text transforms are being applied to the names of labels anymore <https://github.com/OpenNebula/one/issues/6362>`__.
- `Fix duplicate CPU model input <https://github.com/OpenNebula/one/issues/6375>`__.
- `Fix datasources patching for configuration with single Front-end node in HA configuration <https://github.com/OpenNebula/one/issues/6343>`__.
