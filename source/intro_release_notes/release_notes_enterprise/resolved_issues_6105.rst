.. _resolved_issues_6105:

Resolved Issues in 6.10.5
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.5 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/85?closed=1>`__.

The following new features have been backported to 6.10.5:

- `Change ETH* context parameters on live VMs <https://github.com/OpenNebula/one/issues/6606>`__.

The following new features have been backported in the Sunstone Web UI to 6.10.5:


The following issues has been solved in 6.10.5:

- `Fix an issue with fs_lvm_ssh not honoring BRIDGE_LIST in the image datastore <https://github.com/OpenNebula/one/issues/7070>`__.
- `Fix validation issue during Group + Group Admin creation at the same time <https://github.com/OpenNebula/one/issues/6873>`__.
- `Fix scheduler allocation for VMs with NUMA pinning enabled <https://github.com/OpenNebula/one/issues/7071>`__.
- `Fix user_inputs order not considered when instantiating a template through the CLI <https://github.com/OpenNebula/one/issues/7040>`__.
- `Fix the KVMRC Ruby parser regexp that was preventing more than one parameter <https://github.com/OpenNebula/one/issues/7069>`__.
- `Fix Sunstone should prioritize user views <https://github.com/OpenNebula/one/issues/7082>`__.
- `Fix Sunstone Update VM Configuration wizard doesn't scale correctly <https://github.com/OpenNebula/one/issues/7062>`__.
- `Fix Sunstone VM search leads to blank page <https://github.com/OpenNebula/one/issues/7060>`__.
- `Fix Don't let add the ssh key more than one time <https://github.com/OpenNebula/one/issues/7140>`__.
- `Fix VIRTIO_QUEUES not applying to hot plugged virtio NICs <https://github.com/OpenNebula/one/issues/7195>`__.
- `Fix translation text when creating VMs <https://github.com/OpenNebula/one/issues/7222>` __.
- `Fix Fix ownership issue when instanciate Vm as a different user <https://github.com/OpenNebula/one/issues/7013>` __.
- `Fix Fix Ethernet text on Address Ranges when create VMs <https://github.com/OpenNebula/one/issues/6955>` __.
- `Fix re-arrange time orders when adding a scheduled action in Creating VMs <https://github.com/OpenNebula/one/issues/7031>` __.
- `Fix fsck to update history ETIME using EETIME or RETIME.<https://github.com/OpenNebula/one/issues/7250>` __.
- `Fix remove temporary files after creating Image. <https://github.com/OpenNebula/one/issues/7252>`

Changes in Configuration Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since version 6.10.5 the following changes apply to OpenNebula services configuration files:


.. warning:: The following attributes are not included in the configuration files distributed with 6.10.5. If you wish to use these attributes, add them manually to the corresponding file.

OpenNebula Service
^^^^^^^^^^^^^^^^^^

+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
| Config file          | Description                                                  | Action                                                | Values      |
+======================+==============================================================+=======================================================+=============+
| oned.conf            | New attribute: CONTEXT_ALLOW_ETH_UPDATES                     | Allow manual updates of CONTEXT->ETH* values.         | NO, YES     |
+----------------------+--------------------------------------------------------------+-------------------------------------------------------+-------------+
