.. _resolved_issues_582:

Resolved Issues in 5.8.2
--------------------------------------------------------------------------------

A complete list of solved issues for 5.8.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/25>`__.

The following new features has been backported to 5.8.2:

- `Centralized credentials for vCenter resources <https://github.com/OpenNebula/one/issues/1408>`__.
- `Enhance vCenter driver actions pool calls <https://github.com/OpenNebula/one/issues/1896>`__.
- `Read driver action on attach_disk using STDIN for vcenter drivers <https://github.com/OpenNebula/one/issues/3292>`__.
- `Manage IPs when a VM is imported from vCenter <https://github.com/OpenNebula/one/issues/3112>`__.
- `Add methods to update memoize cache <https://github.com/OpenNebula/one/issues/2335>`__.
- `Add info extended VM data in sunstone <https://github.com/OpenNebula/one/issues/3308>`__. For more info on how to activate this feature, check the ```:get_extended_vm_info``` configuration attribute :ref:`here <sunstone_sunstone_server_conf>`.

The following issues has been solved in 5.8.2:

- `LXD now loads nbds_max param from running kernel module configuration <https://github.com/OpenNebula/one/issues/3177>`__
- `Fixed issues with LXD shutdown <https://github.com/OpenNebula/one/issues/3175>`__
- `Fix an issue with LXD and symlinked system datastores <https://github.com/OpenNebula/one/issues/3190>`__
- `Fix snap on vCenter to remove not affected disks <https://github.com/OpenNebula/one/issues/2275>`__.
- `Fix fsck to manage nils macs <https://github.com/OpenNebula/one/issues/3206>`__.
- `Fix list of virtual routers shown in virtual networks to follow user access permissions <https://github.com/OpenNebula/one/issues/3208>`__.
- `Fix issue add persistent image via sunstone <https://github.com/OpenNebula/one/issues/3018>`__.
- `Fix unresponsive OpenNebula right after start <https://github.com/OpenNebula/one/issues/3182>`__.
- `Fix DetachNic method to receive an integer by parameter instead of a string <https://github.com/OpenNebula/one/issues/3235>`__.
- `Fix an issue in provision cleanup option <https://github.com/OpenNebula/one/issues/3234>`__.
- `Fix cleanup and offline migration issues for LVM storage driver <https://github.com/OpenNebula/one/issues/2352>`__.
- `Fix fsck to compute running quotas <https://github.com/OpenNebula/one/issues/3082>`__.
- `Fix PCI release during migration process <https://github.com/OpenNebula/one/issues/3230>`__.
- `Fix an error in fsck when reparing network-cluster relationships <https://github.com/OpenNebula/one/issues/3263>`__.
- `Fix shutdown doesn't check VM status in vcenter <https://github.com/OpenNebula/one/issues/3134>`__.
- `Add IP6_LINK and IP6_GLOBAL attributes to VM short body <https://github.com/OpenNebula/one/issues/3296>`__.
- `Fix lock VM highlight in Sunstone <https://github.com/OpenNebula/one/issues/3193>`__.
- `Fix an issue with the DB upgrade for federated OpenNebulas <https://github.com/OpenNebula/one/issues/2758>`__.
- `Fix an issue for resume operation with FS LVM drivers <https://github.com/OpenNebula/one/issues/3246>`__.
- `Fix an error in onehost sync command and Ruby 2.5 (default in Ubuntu 18.04, 18.10 and Debian 10) <https://github.com/OpenNebula/one/issues/3229>`__.
- `Fix error multiple entries for a VF nic in sunstone <https://github.com/OpenNebula/one/issues/3101>`__.
- `Fix sunstone banner flash briefly <https://github.com/OpenNebula/one/issues/3213>`__.
- `Fix an error when removing OpenvSwitch flows <https://github.com/OpenNebula/one/issues/3305>`__.
