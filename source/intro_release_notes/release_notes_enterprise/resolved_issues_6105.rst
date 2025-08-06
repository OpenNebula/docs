.. _resolved_issues_6105:

Resolved Issues in 6.10.5
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.5 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/85?closed=1>`__.

The following new features have been backported to 6.10.5:


The following new features have been backported in the Sunstone Web UI to 6.10.5:


The following issues has been solved in 6.10.5:

- `Fix an issue with fs_lvm_ssh not honoring BRIDGE_LIST in the image datastore <https://github.com/OpenNebula/one/issues/7070>`__.
- `Fix validation issue during Group + Group Admin creation at the same time <https://github.com/OpenNebula/one/issues/6873>`__.
- `Fix scheduler allocation for VMs with NUMA pinning enabled <https://github.com/OpenNebula/one/issues/7071>`__.
- `Fix user_inputs order not considered when instantiating a template through the CLI <https://github.com/OpenNebula/one/issues/7040>`__.
- `Fix the KVMRC Ruby parser regexp that was preventing more than one parameter <https://github.com/OpenNebula/one/issues/7069>`__.
- `Fix Sunstone should prioritize user views <https://github.com/OpenNebula/one/issues/7082>`__.
- `Fix Sunstone VM search leads to blank page <https://github.com/OpenNebula/one/issues/7060>`__.
- `Fix Don't let add the ssh key more than one time <https://github.com/OpenNebula/one/issues/7140>`__.


The following issues have been solved in the Sunstone Web UI:

Changes in Configuration Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since version 6.10.5 the following changes apply to OpenNebula services configuration files:


.. warning:: The following attributes are not included in the configuration files distributed with 6.10.5. If you wish to use these attributes, add them manually to the corresponding file.
