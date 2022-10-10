.. _resolved_issues_642:

Resolved Issues in 6.4.2
--------------------------------------------------------------------------------


A complete list of solved issues for 6.4.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/61?closed=1>`__.

The following new features has been backported to 6.4.2:

- `Sunstone React Virtual Network Tab <https://github.com/OpenNebula/one/issues/5832>`__.
- For security reason restrict paths in ``CONTEXT/FILES`` by ``CONTEXT_RESTRICTED_DIRS`` (with exceptions in ``CONTEXT_SAFE_DIRS``) configured in :ref:`oned.conf <oned_conf>`

The following issues has been solved in 6.4.2:

- `Fix error when instantiating a VM Template the user attributes were not shown <https://github.com/OpenNebula/one/issues/5918>`__.
- `Fix oneflow not using CLI arguments credentials when instantiating service templates <https://github.com/OpenNebula/one/issues/5912>`__.
- `Fix onedb fsck to not remove network quotas without ID <https://github.com/OpenNebula/one/issues/5935>`__
- `Fix updateconf API call to honor value of VALIDATE attribute <https://github.com/OpenNebula/one/issues/5936>`__
- `Extended quota support in WHMCS Tenants Module to include disk, network, and running resources <https://github.com/OpenNebula/one/issues/5863>`__.
- `Fix client cancellation in WHMCS Tenants module <https://github.com/OpenNebula/one/issues/5865>`__.
- `Fix parsing of authentication drivers (LDAP) messages for admin groups <https://github.com/OpenNebula/one/issues/5946>`__.
- `Fix image usage counter in case VM uses the same image multiple times <https://github.com/OpenNebula/one/issues/937>`__.
- `Fix conflict in VNC port after onevm undeploy fails <https://github.com/OpenNebula/one/issues/5960>`__.
- `Fix host monitoring to only report virtual CPU models actually supported by the hypervisor <https://github.com/OpenNebula/one/issues/5869>`__.
- `Fix cloned images to preserve the original DRIVER attribute <https://github.com/OpenNebula/one/issues/5933>`__.
- `Removed logrotate on service restart, added maximum log size for rotation <https://github.com/OpenNebula/one/issues/5328>`__.
- `Fix domfsthaw timeout error for live disk snapshot for Ceph datastores <https://github.com/OpenNebula/one/issues/5927>`__.
- `Fix encoding in java binding <https://github.com/OpenNebula/one/issues/5243>`__.
- `Fix default scope for goca to gather all visible objects rather than just those owned by the user <https://github.com/OpenNebula/terraform-provider-opennebula/issues/331>`__.
- `Fix OneFlow token life-time management, this will prevent tokens from expiring while performing flow operations <https://github.com/OpenNebula/one/issues/5814>`__.
- `Fix Sunstone ignores volatile disks on VM Template instantiate <https://github.com/OpenNebula/one/issues/5970>`__.

