.. _start_here:

=================================
Upgrading from OpenNebula 5.10.x
=================================

This guide describes the installation procedure for systems that are already running a 5.10.x OpenNebula Enterprise Edition. The upgrade to OpenNebula |version| can be done directly following this section; you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations, for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.

Get OneScape
=====================

OneScape is an enterprise tool that includes an upgrade facilitator, 'onecfg'. Please :ref:`install or update your existing OneScape installation <conf_management_module>`.

New OpenNebula major releases require the latest OneScape. You may experience the following error if your OneScape version is too old:

 .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.10.2
        Config:      5.8.0
        ERROR: Unsupported OpenNebula version 5.10.2

.. important::

    **For each OpenNebula upgrade (even between minor versions, e.g. 5.10.2 and 5.10.3), configuration files must be processed via 'onecfg upgrade'**. If you skip configuration upgrade step for some OpenNebula upgrade, the tool will lose the current version state and you'll have to handle files upgrade manually and :ref:`reinitialize <cfg_init>` the configuration version management state.

    .. prompt:: bash # auto

        # onecfg upgrade
        FATAL : FAILED - Configuration can't be processed as it looks outdated!
        You must have missed to run 'onecfg update' after previous OpenNebula upgrade.

        # onecfg status
        ...
        ERROR: Configurations metadata are outdated.

Upgrade OpenNebula
==============================================

Update your OpenNebula packages by following the guide that applies to your current OpenNebula configuration:

- :ref:`Upgrading a Single Front-End Deployment <upgrade_single_510>`
- :ref:`Upgrading an HA Cluster <upgrade_ha_510>`
- :ref:`Upgrading a Federation <upgrade_federation_510>`

 Follow :ref:`onecfg upgrade <cfg_upgrade>` documentation on how to upgrade and troubleshoot the configurations.

.. important::

   It's necessary to upgrade your current OpenNebula directly to **5.10.2** or later, which supports the automatic configuration backups. Also, configuration upgrade must be done after each OpenNebula upgrade!

Validate OpenNebula
==============================================

When all steps are done, run the OpenNebula and check the working state.

Check the configuration state via ``onecfg status``. There shouldn't be any errors and no new updates available. Your configuration should be current to the installed OpenNebula version. For example:

.. prompt:: bash # auto

    # onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.10.2
    Config:      5.10.0

    --- Available Configuration Updates -------
    No updates available.
