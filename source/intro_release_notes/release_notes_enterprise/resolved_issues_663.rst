.. _resolved_issues_663:

Resolved Issues in 6.6.3
--------------------------------------------------------------------------------

A complete list of solved issues for 6.6.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/67?closed=1>`__.

The following new features have been backported to 6.6.3:

- Optimize :ref:`appending with onedb change-body <onedb_change_body>`.
- Allow ``onedb purge-history`` to delete the history record of a :ref:`single VM <onedb_purge_history>`.
- Improve :ref:`onehost sync <host_guide_sync>` error logging.
- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.
- `Marketplace download app stepper should filter image DS <https://github.com/OpenNebula/one/issues/6213>`__.
- Improve :ref:`list commands <cli>`  help messages to point to :ref:`layout configuration files <cli_views>`.
- `Add VCPU to VMs pool list <https://github.com/OpenNebula/one/issues/6111>`__. If you are upgrading from previous version, the ``VCPU`` will apear after first update of the VM. Use ``onevm update <vm_id> --append <empty_file>`` to force VM update.
- Added a guide for :ref:`replacing a failing OpenNebula front-end host <Replace failing front-end>`.
- :ref:`Backup dialog in FireEdge Sunstone updated to make datastore selection optional if not needed <vm_backup>`.
- :ref:`Add support to delete "in-chain" disk snapshots for tree layouts (qcow2) <vm_guide_2_disk_snapshots_managing>`.


The following issues have been solved in 6.6.3:

- `Fix FSunstone currency change is not working <https://github.com/OpenNebula/one/issues/6222>`__.
- `Fix wrong management of labels in OpenNebula Prometheus exporter <https://github.com/OpenNebula/one/issues/6226>`__.
- `Fix Creating a new image ends with wrong DEV_PREFIX <https://github.com/OpenNebula/one/issues/6214>`__.
- `Include HostSyncManager as a gem dependency <https://github.com/OpenNebula/one/issues/6245>`__.
- `Fix onegate man page generation <https://github.com/OpenNebula/one/issues/6172>`__.
- `Fix Incorrect service configuration for opennebula-fireedge.service <https://github.com/OpenNebula/one/issues/6241>`__.
- Fix :ref:`onegather <support>` journal log collection when using systemd.
- :ref:`Onegather <support>` now includes execution logs within the package.
- `Fix VM operation permissions for disk-attach, nic-(de)attach and nic-update <https://github.com/OpenNebula/one/issues/6239>`__.
- `Fix reset flag for onevm backup --schedule <https://github.com/OpenNebula/one/issues/6193>`__.
- `Fix OpenNebula Prometheus exporter to refresh data <https://github.com/OpenNebula/one/issues/6236>`__.
- `Fix missing defaults on Turnkey marketplace <https://github.com/OpenNebula/one/issues/6258>`__.
- `Fix LinuxContainers opensuse app not having SSH access <https://github.com/OpenNebula/one/issues/6257>`__.
- `Fix missing unit selectors on create images and vm templates <https://github.com/OpenNebula/one/issues/6136>`__.
- `Fix wrong configuration for FreeMemory10 in Prometheus rules <https://github.com/OpenNebula/one/issues/6225>`__.
- `Fix regular user cannot create a new VM template <https://github.com/OpenNebula/one/issues/6129>`__.


Upgrade Notes
--------------------------------------------------------------------------------
Apart from the general considerations :ref:`described in the upgrade guide <upgrade_66>`, consider this note (Disk Snapshots) in the :ref:`Compatiblity Guide <compatiblity_disk_snapshots>`.
