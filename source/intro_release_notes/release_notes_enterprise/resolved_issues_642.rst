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
