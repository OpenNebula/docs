.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.14.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.14.

OpenNebula Administrators and Users
================================================================================

Scheduler
--------------------------------------------------------------------------------

The scheduler now considers secondary groups to schedule VMs for both hosts and
datastores (see `feature #4156 <http://dev.opennebula.org/issues/4156>`_). This
feature enable users to effictevly use multiple VDCs. This may **only** affect
to installation using multiple groups per user.

Disk Templates
--------------------------------------------------------------------------------

Any attribute defined explicitely in the ``DISK`` section of a Template or of a Virtual Machine template, will **not** be overriden by the same attribute defined in the Image template or in the Datastore template, even if the attribute is marked as ``INHERIT`` in ``oned.conf``. The precedency of the attributes is evaluated in this order (most important to least important):

- ``DISK`` section of the Template
- Image template
- Datastore template

Developers and Integrators
================================================================================

Transfer Manager
--------------------------------------------------------------------------------

**TODO** New monitor script para system datastores
