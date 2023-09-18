.. _resolved_issues_645:

Resolved Issues in 6.4.5
--------------------------------------------------------------------------------


A complete list of solved issues for 6.4.5 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/68?closed=1>`__.

The following new features has been backported to 6.4.5:

- Add ``sched-action`` and ``sg-attach`` to :ref:`VM Operation Permissions <oned_conf_vm_operations>`.

The following issues has been solved in 6.4.5:

- `Fix LinuxContainers monitoring to use images.json and not traversing links <https://github.com/OpenNebula/one/issues/6171>`__.
- `Fix Creating a new image ends with wrong DEV_PREFIX <https://github.com/OpenNebula/one/issues/6214>`__.
- `Fix onegate man page generation <https://github.com/OpenNebula/one/issues/6172>`__.
- Fix :ref:`onegather <support>` journal log collection when using systemd.
- :ref:`Onegather <support>` now includes execution logs within the package.
- `Fix missing defaults on Turnkey marketplace <https://github.com/OpenNebula/one/issues/6258>`__.
- `Fix LinuxContainers opensuse app not having SSH access <https://github.com/OpenNebula/one/issues/6257>`__.
- `Fix charset conversions for 'onedb fsck' and 'onedb sqlite2mysql' <https://github.com/OpenNebula/one/issues/6297>`__.
- `Fix initialization of 'sed' command avoiding repeating attributes <https://github.com/OpenNebula/one/issues/6306>`__.
- `Fix an issue where SSH auth driver would fail with openssh formatted private keys <https://github.com/OpenNebula/one/issues/6274>`__.
- `Fix an issue where LinuxContainers marketplace app templates would not match the LXC_UNPRIVILEGED setting handeld by the LXC driver <https://github.com/OpenNebula/one/issues/6190>`__.
