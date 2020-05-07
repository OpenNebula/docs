
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.11.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <https://opennebula.org/use/>`__ for a comprehensive list of what's new in OpenNebula 5.11.

OneFlow revamp
==============

In the new OneFlow server, the state **poweroff** sets the service state to warning.

New default restricted attributes
=================================

The ``PIN_POLICY`` and ``HUGEPAGE_SIZE`` attributes from ``TOPOLOGY`` are now restricted by default.

New monitoring
==============

The monitoring system has been re-design to improve its scalability and better support different deployment scenarios. This re-design introduce some incompatibilities:

- Custom probes needs to be copied to the new locations, see :ref:`Monitoring Guide <mon>` to learn about the new locations.
- In order to speed-up DB access monitoring and VM/Host data has been separated. The XPATH of some data had to be changed to accommodate the change. You may need to adapt any custom integration to the new XPATHS. In particular:

  - ``HOST/HOST_SHARE``
  - TODO Complete

- No monitor information is sent in listing API call, neither hosts nor VMs.
- Configuration of monitoring probes and parameters has been moved to its own file, you may need to adapt/migrate your custom modifications from ``oned.conf`` to ``monitord.conf``.
- The monitoring system now may use TCP transport, you'll need to open incoming connections to port 4124 and TCP to the front-end, in addition to the UDP one.
