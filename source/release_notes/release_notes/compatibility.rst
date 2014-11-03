.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.8 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.10.

OpenNebula Administrators and Users
================================================================================

Authentication
--------------------------------------------------------------------------------

- ``oneuser login``: This command now generated the tokens in ``.one_auth``. :ref:`Manage Users <manage_users>`.

Virtual Machines
--------------------------------------------------------------------------------

- Feature `#1639 <http://dev.opennebula.org/issues/1639>`_: VMs can now be migrated from the ``UNKNOWN`` state.

- Feature `#3158 <http://dev.opennebula.org/issues/3158>`_: The context is now the last cdrom. This avoids boot problems users were having when the context was automatically assigned the 'hda' target.

Virtual Networks
--------------------------------------------------------------------------------

- Feature `#3167 <http://dev.opennebula.org/issues/3167>`_: Users can now edit their reservations to add context attributes, with the commands ``onevnet update`` and ``onevnet updatear``. Administrators can restrict the allowed attributes with the new ``VNET_RESTRICTED_ATTR`` configuration option in oned.conf.

- Feature `#3156 <http://dev.opennebula.org/issues/3156>`_: Different BRIDGE according to vnet driver, allows for a more heterogenous network support, mixing clusters with different network bridge names.

Developers and Integrators
================================================================================

XML-RPC API
--------------------------------------------------------------------------------

* New api calls:

  * ``one.user.login``: Generates or sets a login token.

* Changed api calls:

  * ``one.vn.info``: The Virtual Network includes information about the VMs and VNets using the requested VNet. Now these are filtered to contain only the VMs and VNets that the user has right to see (USE permission).
  * ``one.vn.update``: Now requires NET:MANAGE rights, instead of ADMIN
  * ``one.vn.update_ar``: Now requires NET:MANAGE rights, instead of ADMIN
