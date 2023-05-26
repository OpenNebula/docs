.. _resolved_issues_662:

Resolved Issues in 6.6.2
--------------------------------------------------------------------------------

A complete list of solved issues for 6.6.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/66?closed=1>`__.

The following new features have been backported to 6.6.2:

- `Graceful stop of ongoing backup operations <https://github.com/OpenNebula/one/issues/6030>`__.
- `Add support for CentOS 8 Stream, Amazon Linux, and openSUSE on LinuxContainers marketplace <https://github.com/OpenNebula/one/issues/3178>`__.
- `Add the ability to pin the virtual CPUs and memory of a VM to a specific host NUMA node <https://github.com/OpenNebula/one/issues/5966>`__.
- `Hugepages can be used without CPU pinning <https://github.com/OpenNebula/one/issues/6185>`__.
- `Add remote authorization support in FireEdge Sunstone <https://github.com/OpenNebula/one/issues/6112>`__.
- :ref:`Improve VM HA hook script host_error.rb to skip VMs deployed on local datastores <vm_ha>`.
- `Add Overcommitment dialog in host tab <https://github.com/OpenNebula/one/issues/5755>`__.
- `Reordering the schedule actions creation mode <https://github.com/OpenNebula/one/issues/6091>`__.
- `Allow standalone qcow2 image on shared datastore <https://github.com/OpenNebula/one/issues/6098>`__, see :ref:`configuration <nas_ds>`.

.. note::

   In order to use the 'standalone qcow2 image on shared datastore' functionality above in OpenNebula 6.6, the following attribute needs to be added to /etc/one/oned.conf

   ``INHERIT_DATASTORE_ATTR  = "QCOW2_STANDALONE"``

   Remember to restart OpenNebula after applying the configuration change.

The following issues have been solved in 6.6.2:

- `Fix default scheduler NIC policies <https://github.com/OpenNebula/one/issues/6149>`__.
- `Fix error when disabling the FireEdge configuration attributes in sunstone-server.conf <https://github.com/OpenNebula/one/issues/6163>`__.
- `Fix datastore driver actions error: argument list too long <https://github.com/OpenNebula/one/issues/6162>`__.
- `Fix termination time for scheduled actions with repeat times <https://github.com/OpenNebula/one/issues/6181>`__.
- `Fix LinuxContainers marketplace monitoring <https://github.com/OpenNebula/one/issues/6184>`__.
- `Fix disk_type and source for block CD <https://github.com/OpenNebula/one/issues/6140>`__.
- `Fix Address Range IP6_END value <https://github.com/OpenNebula/one/issues/6156>`__.
- `Fix restore dialog to properly set restore options <https://github.com/OpenNebula/one/issues/6187>`__.
- `Fix locks under certain condition while doing backup operations <https://github.com/OpenNebula/one/issues/6199>`__.
- `Fix error when making the first incremental backup in a VM in poweroff state <https://github.com/OpenNebula/one/issues/6200>`__.
- `Fix fsck for backup images <https://github.com/OpenNebula/one/issues/6195>`__.
- `Fix missing actions in Firecracker driver <https://github.com/OpenNebula/one/issues/6173>`__.
- `Fix some LinuxContainers marketplace applications failing to auto-contextualize <https://github.com/OpenNebula/one/issues/6190>`__.
- `Fix incremental backups after resetting ("--reset") and performing a poweroff cycle on the VM <https://github.com/OpenNebula/one/issues/6206>`__.
- `Fix Ceph trash to also clean base snapshots to prevent data loss on persistent images <https://github.com/OpenNebula/one/issues/6207>`__.
- `Fix LinuxContainers monitoring to use images.json and not traversing links <https://github.com/OpenNebula/one/issues/6171>`__.
- `Fix Context Custom variables get key and values changed to upcase <https://github.com/OpenNebula/one/issues/6201>`__.
- `Fix Scale button does not show on service role tab <https://github.com/OpenNebula/one/issues/6164>`__.
- `Fix Sunstone overrides DISK SIZE attribute on instantiation <https://github.com/OpenNebula/one/issues/6215>`__.
- `Fix Context Custom variables gets key and values changed to upcase <https://github.com/OpenNebula/one/issues/6201>`__.
- `Add Overcommitment dialog in host tab <https://github.com/OpenNebula/one/issues/5755>`__.
