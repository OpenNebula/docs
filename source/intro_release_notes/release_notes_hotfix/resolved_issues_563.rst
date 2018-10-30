.. _resolved_issues_563:

Resolved Issues in 5.6.3
--------------------------------------------------------------------------------

A complete list of solved issues for 5.6.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/XXXX>`__. TODO

The following new features has been backported to 5.6.3:

- `Allow creation of "Empty disk image" for type OS <https://github.com/OpenNebula/one/issues/1089>`__.
- `VMs can be removed from OpenNebula with the onevm recover command without affecting the running VM. This can be used to re-import existing VMs <https://github.com/OpenNebula/one/issues/1246>`__.
- `The "$" character can be escaped in VM templates <https://github.com/OpenNebula/one/issues/2456>`__.
- `Admin can disable Advanced options from Cloud view tabs <https://github.com/OpenNebula/one/issues/1745>`__.

The following issues has been solved in 5.6.3:

- `Add missing field Size on instantiate advanced options section <https://github.com/OpenNebula/one/issues/2450>`__.
- `Fix issue when creating vmgroups using advanced mode <https://github.com/OpenNebula/one/issues/2522>`__.
- `Fix issue when instantiating a VM with RESTRICTED_ATTR DISK/SIZE <https://github.com/OpenNebula/one/issues/2533>`__.
- `Fix the amount of memory reported by KVM virtual machines <https://github.com/OpenNebula/one/issues/2179>`__.
- `Fix ssh disk transfer to prevent inconsistency <https://github.com/OpenNebula/one/issues/2438>`__.
- `Fix an issue that prevents Network model to work in vCenter <https://github.com/OpenNebula/one/issues/2474>`__.
- `Remove unselect button in Sustone selection labels <https://github.com/OpenNebula/one/issues/2538>`__.
- `Fix an issue that prevents removal of FILE_DS attribute <https://github.com/OpenNebula/one/issues/2540>`__.
- `vCenter vms do not fail when removing unmanaged nets in parent template <https://github.com/OpenNebula/one/issues/2558>`__.

Sunstone Note
--------------------------------------------------------------------------------

Advanced options can be hidden. If you want to hide them you need to add the following attributes to false in sunstone-views yamls, it just works on cloud and groupadmin views:

   show_attach_disk_advanced

   show_attach_nic_advanced
