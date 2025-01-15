.. _resolved_issues_6103:

Resolved Issues in 6.10.3
--------------------------------------------------------------------------------

A complete list of solved issues for 6.10.3 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/81?closed=1>`__.

The following new features have been backported to 6.10.3:

- Added support for the new NVIDIA mediated devices framework introduced in Ubuntu 24.04. The legacy method remains unaffected by this new feature. For more details, see the :ref:`NVIDIA vGPU documentation <kvm_vgpu>`.

The following issues has been solved in 6.10.3:

- `Fix an error when downloading images from HTTP-based marketplaces caused by a missing trailing slash in the ENDPOINT attribute <https://github.com/OpenNebula/one/issues/6619>`__.
- `Fix corrupted quota after VM deploy and recover --recreate actions, in case RUNNING quota is exceeded <https://github.com/OpenNebula/one/issues/6823>`__.

The following issues have been solved in the Sunstone Web UI:

- `Fix currency symbol not displaying <https://github.com/OpenNebula/one/issues/6846>`__.
- `Fix making available "Flush" button on FSunstone to resched all VMs in another hosts <https://github.com/OpenNebula/one/issues/6763>`__.
- `Fix dettach disk or nic is disabled in regular users <https://github.com/OpenNebula/one/issues/6820>`__.