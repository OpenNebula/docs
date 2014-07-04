.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.6 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.8.

OpenNebula Administrators and Users
===================================

Usage Quotas
--------------------------------------------------------------------------------

Up to 4.6, a quota of '0' meant unlimited usage. In 4.8, '0' means a limit of 0, and '-2' means unlimited. See the :ref:`quotas documentation <quota_auth>` for more information.


Developers and Integrators
==========================
