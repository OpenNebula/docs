.. _resolved_issues_681:

Resolved Issues in 6.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/71?closed=1>`__.

The following new features have been backported to 6.8.1:

- Added support for :ref:`vSphere 8<vcenter_nodes_platform_notes>`.
- Optimized implementation of :ref:`standard input capable commands <cli>`. Other commands were updated as well to handle standard input.
- Minor optimization on the ``oneflow-template instantiate`` command when using the :ref:`--multiple <cli_flow>` option.
- Added the VM Group templates tab to Fireedge Sunstone. See :ref:`the VM affinity guide <vmgroups>` for more information.

  - The new configuration files can be downloaded from `here <https://bit.ly/one-68-maintenance-config>`__

- Implemented :ref:`Backup Jobs <vm_backup_jobs>` tab in FireEdge Sunstone.
- Added the Groups tab to Fireedge Sunstone. See :ref:`the Groups guide <manage_groups>` for more information.

  - The new configuration files can be downloaded from `here <https://bit.ly/groups-tab>`__

- Implemented restricted attributes on Images and Virtual Networks in :ref:`Restricted Attributes <oned_conf_restricted_attributes_configuration>`.
- Incremental backups now support a snapshot mode to track changes using :ref:`snapshots instead of CBT checkpoints <vm_backups_operations>`.
- Backups can be configured to use a custom path in the hosts FS for :ref:`restic <vm_backups_restic>` and :ref:`rsync <vm_backups_rsync>`.
- Added numerous :ref:`CLI improvements <cli>` for the backup management.
- Added more CLI formatting options to some :ref:`oneflow commands <cli_flow>`.

The following issues has been solved in 6.8.1:

- `Fix an issue where KVM system snapshots would not be carried over to the new host after live migrating a VM <https://github.com/OpenNebula/one/issues/6363>`__.
- `Fix certain graphs to correctly display delta values <https://github.com/OpenNebula/one/issues/6347>`__.
- `Fix update of Virtual Network with empty attributes, which sometimes caused ERROR state <https://github.com/OpenNebula/one/issues/6367>`__.
- `Fix creation of VM templates with NIC + alias NIC <https://github.com/OpenNebula/one/issues/6349>`__.
- `Fix DockerHub downloader to handle images that are missing the Cmd property <https://github.com/OpenNebula/one/issues/6374>`__.
- `Fix DockerHub downloader to handle images that are missing the latest tag like RockyLinux <https://github.com/OpenNebula/one/issues/6196>`__.
- `Fix error management for DockerHub downloader on multiple steps of the import process <https://github.com/OpenNebula/one/issues/6197>`__.
- `Fix VM templates with NIC and NIC alias <https://github.com/OpenNebula/one/issues/6349>`__.
- `Fix error handling when reusing names while downloading Marketplace service appliances <https://github.com/OpenNebula/one/issues/6370>`__.
- `Fix memory leak in Scheduler and optimize memory usage in Cluster objects <https://github.com/OpenNebula/one/issues/6365>`__.
- `Fix to label naming conventions, no text transforms are being applied to the names of labels anymore <https://github.com/OpenNebula/one/issues/6362>`__.
- `Fix duplicate CPU model input <https://github.com/OpenNebula/one/issues/6375>`__.
- `Fix accounting (history records) for VM disk actions <https://github.com/OpenNebula/one/issues/6320>`__.
- `Fix datasources patching for configuration with single Front-end node in HA configuration <https://github.com/OpenNebula/one/issues/6343>`__.
- `Fix CLI output after all disk snapshots are deleted <https://github.com/OpenNebula/one/issues/6388>`__.
- `Fix authentication errors in scheduler and vcenter monitoring after oneadmin password change <https://github.com/OpenNebula/one/issues/6354>`__.
- `Fix text in Support tab <https://github.com/OpenNebula/one/issues/6393>`__.
- `Fix memory default size from MB to GB in FireEdge <https://github.com/OpenNebula/one/issues/6221>`__.
- `Fix VIRTIO_BLK_QUEUES parameter so it can be used with VM templates with non-virtio bus (e.g. ide or scsi) <https://github.com/OpenNebula/one/issues/6401>`__.
- `Fix OTP time for 2FA in Sunstone <https://github.com/OpenNebula/one/issues/6385>`__.
- `Fix KERNEL and RAMDISK inputs functionality when upgrading or creating a template in FireEdge <https://github.com/OpenNebula/one/issues/6334>`__.
- `Fix User inputs not displayed when instantiating VM template in FireEdge <https://github.com/OpenNebula/one/issues/6392>`__.
- `Fix one.vm.updateconf ignoring VIRTIO_BLK_QUEUES  <https://github.com/OpenNebula/one/issues/6414>`__.
- `Fix OneFlow VMs that may not include vm_info parameter in some cases <https://github.com/OpenNebula/one/issues/6406>`__.
- `Fix vCenter nic_attach action throwing parsing error <https://github.com/OpenNebula/one/issues/6391>`__.
- `Fix labeling system in FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6362>`__.
- `Fix Sunstone issues unnecessary call when creating a marketplace app <https://github.com/OpenNebula/one/issues/6334>`__.
- `Fix missing catalan keymap <https://github.com/OpenNebula/one/issues/6420>`__.
- `Fix snapshot revert action to use custom script names (regression introduced by 2efd976) <https://github.com/OpenNebula/one/issues/6382>`__.
- `Fix several cases where VM quotas were corrupted after stop, undeploy or terminate command <https://github.com/OpenNebula/one/issues/6355>`__.
- `Fix Datastore monitoring <https://github.com/OpenNebula/one/issues/6409>`__.
