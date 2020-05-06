
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

Monitoring have been redesigned. If you have custem monitoring drivers, see the :ref:`Monitoring Driver <devel-im>` how to build custom driver.