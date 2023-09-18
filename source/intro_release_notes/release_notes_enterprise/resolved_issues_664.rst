.. _resolved_issues_664:

Resolved Issues in 6.6.4
--------------------------------------------------------------------------------

A complete list of solved issues for 6.6.4 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/70?closed=1>`__.

The following new features have been backported to 6.6.4:

- SR-IOV based NICs are live-updated when :ref:`updating the associated VNET attributes <vnet_update>`

The following issues have been solved in 6.6.4:

- `Fix logic mismatch when attaching volatile disks for block drivers <https://github.com/OpenNebula/one/issues/6288>`__.
- `Fix oned segmentation fault when configured to run cache mode <https://github.com/OpenNebula/one/pull/6301>`__.
- `Fix charset conversions for 'onedb fsck' and 'onedb sqlite2mysql' <https://github.com/OpenNebula/one/issues/6297>`__.
- `Fix initialization of 'sed' command avoiding repeating attributes <https://github.com/OpenNebula/one/issues/6306>`__.
- `Fix IP alias detach so it does not removes VM vNICs from bridge ports (OVS) <https://github.com/OpenNebula/one/issues/6306>`__.
- `Fix schedule action is not setting the right day of the week in Sunstone on checkmark box <https://github.com/OpenNebula/one/issues/6260>`__.

Upgrade Notes
================================================================================

Apart from the general considerations :ref:`described in the upgrade guide <upgrade_66>`, consider this note (Disk Snapshots) in the :ref:`Compatiblity Guide <compatiblity_disk_snapshots>`.
