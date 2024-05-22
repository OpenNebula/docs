.. _resolved_issues_684:

Resolved Issues in 6.8.4
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/77?closed=1>`__.


The following new features have been backported to 6.8.4:

- Allow VM recover recreate in poweroff and suspended state, see :ref:`Recover from VM Failures <ftguide_virtual_machine_failures>`.



The following issues have been solved in 6.8.4:

- `Fix monitoring of Ceph SYSTEM datastores when using quotas <https://github.com/OpenNebula/one/issues/6564>`__.
- `Fix bug where SPARSE attribute was not being used on cloning scripts for Local and NAS/SAN Datastores <https://github.com/OpenNebula/one/issues/6487>`__.
- `Fix and issue in OneFlow that prevented the creation/reservation of Virtual Networks <https://github.com/OpenNebula/terraform-provider-opennebula/issues/527>`__.
- `Fix crash in 'onetemplate instantiate' overriding SCHED_ACTION with empty value <https://github.com/OpenNebula/one/issues/6580>`__.
- `Fix attach NIC action to use DEFAULT_ATTACH_NIC_MODEL defined in kvmrc <https://github.com/OpenNebula/one/issues/6575>`__.

Also, the following issues have been backported in the FireEdge Sunstone Web UI:

- `Add description for views in create form group <https://github.com/OpenNebula/one/issues/6399>`__.

.. note::
   In order to use the new functionality introduced in Fireedge sunstone, please refer to the following :ref:`guide <fireedge_files_note>`.