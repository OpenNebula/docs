.. _resolved_issues_5102:

Resolved Issues in 5.10.2
--------------------------------------------------------------------------------

A complete list of solved issues for 5.10.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/31>`__.

The following new features has been backported to 5.10.2:

- `Add support for CentOS 8 auto-contextualization from LXD marketplace <https://github.com/OpenNebula/one/issues/4007>`__.
- `Automatic configurations backup before packages upgrade <https://github.com/OpenNebula/packages/issues/117>`__.
- `Add append option to onedb change-body <https://github.com/OpenNebula/one/issues/3999>`__.
- `Add OneAcl helper class to PyOne <https://github.com/OpenNebula/one/pull/4079>`__.
- `Add VM name on vCenter to vCenter information section <https://github.com/OpenNebula/one/issues/2771>`__.
- `Add vCenter custom names option for VMs <https://github.com/OpenNebula/one/issues/1973>`__.
- `Add option for set filter for the NIC in Sunstone <https://github.com/OpenNebula/one/issues/3383>`__.
- `Add onezone serversync command <https://github.com/OpenNebula/one/issues/4109>`__.
- `Add option to order wild vms in Sunstone <https://github.com/OpenNebula/one/issues/4131>`__.
- :ref:`Add onevcenter cleartags command to reimport vCenter Wild VMs <vcenter_reimport_wild_vms>`.
- :ref:`Add marketplace for TurnKey Linux <market_lxd>`.
- `Add RDP links in Sunstone <https://github.com/OpenNebula/one/issues/3969>`__.

The following issues has been solved in 5.10.2:

- `Fix onedb purge-done problem with end-time <https://github.com/OpenNebula/one/issues/4050>`__.
- `Fix bash 4.4 warnings about null byte <https://github.com/OpenNebula/one/issues/1690>`__.
- `Fix login form when auth config is remote <https://github.com/OpenNebula/one/issues/4096>`__.
- `Fix create vm template with NUMA without HUGEPAGES <https://github.com/OpenNebula/one/issues/4112>`__.
- `Fix boolean user inputs in CLI <https://github.com/OpenNebula/one/issues/4075>`__.
- `Fix IPv4 address not shown in VM network tab <https://github.com/OpenNebula/one/issues/3882>`__.
- `Fix ACL XSD schema. It also fixes ACL for PyONE <https://github.com/OpenNebula/one/issues/4076>`__.
- `Fix highlighting states <https://github.com/OpenNebula/one/issues/3450>`__.
- `Fix missing SNAPSHOTS element in vm_pool.xsd and PyONE <https://github.com/OpenNebula/one/issues/4136>`__.
- `Fix status of new NoVNC server <https://github.com/OpenNebula/one/issues/4020>`__.
- `Fix error message <https://github.com/OpenNebula/one/issues/4144>`__.
- `Fix Context ISO attributes to not include NIC detach information <https://github.com/OpenNebula/one/issues/4130>`__.
- `Fix a high memory usage of oned due to hook events saturation <https://github.com/OpenNebula/one/issues/4154>`__.
- `Fix a fsck for non-utf8 encoded databases <https://github.com/OpenNebula/one/issues/4165>`__.
