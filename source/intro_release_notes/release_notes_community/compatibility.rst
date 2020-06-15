
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.12.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the following section (TODO).

.. todo::
   Add link to new upgrade guides

Visit the :ref:`Features list <features>` and the `Release Notes <https://opennebula.io/use/>`__ for a comprehensive list of what's new in OpenNebula 5.12.

OneFlow revamp
==============

In the new OneFlow server, the state **poweroff** sets the service state to **warning**.

MySQL Backend
=============

MySQL can be configured to use the BINARY clause in SELECT operations. This make object names to be case sensitive (as sqlite or PostgreSQL). The default behavior is to **not** use this feature to be backward compatible. Note that if you are using LDAP or AD as authentication backends this feature is not recommended.

SQLite Backend
==============

New configuration option for SQLite TIMEOUT defines timeout in milliseconds for acquiring lock to DB. You may consider increasing this value if you have following error messages in monitor.log or oned.log: ``SQL command was: ... error: database is locked``

New default restricted attributes
=================================

The ``PIN_POLICY`` and ``HUGEPAGE_SIZE`` attributes from ``TOPOLOGY`` are now restricted by default.

New monitoring
==============

The monitoring system has been redesigned to improve its scalability and to better support different deployment scenarios. This redesign introduces some incompatibilities:

- Custom probes need to be copied to the new locations, see :ref:`Monitoring Guide <mon>` to learn about the new locations.
- In order to speed-up DB access, monitoring and VM/Host data has been separated. The XPATH of some data had to be modified to accommodate the change. You may need to adapt any custom integration to the new XPATHS. In particular:

  - ``HOST/LAST_MON_TIME`` was removed
  - ``/HOST/HOST_SHARE/[DISK_USAGE,FREE_DISK,MAX_DISK,USED_DISK]`` was moved to ``/HOST/HOST_SHARE/DATASTORES/[DISK_USAGE,FREE_DISK,MAX_DISK,USED_DISK]``
  - ``/HOST/HOST_SHARE/[USED*, FREE*]`` was moved to monitoring object ``/MONITORING/CAPACITY/[USED*, FREE*]``
  - ``/HOST/TEMPLATE/[NETRX, NETTX]`` was moved to monitoring object ``/MONITORING/SYSTEM/[NETRX, NETTX]``

- No monitor information is sent in listing API call, neither hosts nor VMs.
- Configuration of monitoring probes and parameters has been moved to its own file, you may need to adapt/migrate your custom modifications from ``oned.conf`` to ``monitord.conf``.
- The monitoring system now may use TCP transport. You'll need to open incoming connections to port 4124 and TCP to the front-end, in addition to the UDP one.

Accounting and Showback
=======================

All the states that make Virtual Machines to remain in the host are taken in account to calculate the accounting and showback records. So now, the following states are also computed:

- Poweroff
- Suspend
