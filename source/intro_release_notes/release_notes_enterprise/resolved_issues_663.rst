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

The following issues have been solved in 6.6.3:

- `Fix FSunstone currency change is not working <https://github.com/OpenNebula/one/issues/6222>`__.
- `Fix wrong management of labels in OpenNebula Prometheus exporter <https://github.com/OpenNebula/one/issues/6226>`__.
- `Fix Creating a new image ends with wrong DEV_PREFIX <https://github.com/OpenNebula/one/issues/6214>`__.
- `Include HostSyncManager as a gem dependency <https://github.com/OpenNebula/one/issues/6245>`__.
- `Fix onegate man page generation <https://github.com/OpenNebula/one/issues/6172>`__.
- Fix :ref:`onegather <support>` journal log collection when using systemd.
- :ref:`Onegather <support>` now includes execution logs within the package.
- `Fix VM operation permissions for disk-attach, nic-(de)attach and nic-update <https://github.com/OpenNebula/one/issues/6239>`__.
- `Fix reset flag for onevm backup --schedule <https://github.com/OpenNebula/one/issues/6193>`__.
