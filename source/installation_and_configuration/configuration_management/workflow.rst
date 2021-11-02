.. _cfg_workflow:

===========================
OpenNebula Upgrade Workflow
===========================

This section describes the typical OpenNebula upgrade process incorporating the Onecfg.

.. important::

    **For every OpenNebula upgrade (even between maintenance releases, e.g. 5.10.2 and 5.10.3), configuration files must be processed via 'onecfg upgrade'!** If you skip the configuration upgrade step for any OpenNebula upgrade, the tool will lose the current version state and you'll have to handle the files upgrade manually and :ref:`reinitialize <cfg_init>` the configuration version management state.

    .. prompt:: bash # auto

        # onecfg upgrade
        FATAL : FAILED - Configuration can't be processed as it looks outdated!
        You must have missed to run 'onecfg update' after previous OpenNebula upgrade.

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.12.0
        Config:      5.8.0
        ERROR: Configurations metadata are outdated.

Step 1 - Prepare Onecfg
--------------------------

Before upgrading OpenNebula, you need to ensure that the state of the Onecfg configuration tool is clean and without any pending migrations from past or outdated configurations. Run ``onecfg status`` to check the configuration state.

A clean state might look like:

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.0

        --- Available Configuration Updates -------
        No updates available.

Unknown Configuration Version Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you get an error message about unknown configuration version, you don't need to do anything. The configuration version will be automatically initialized during OpenNebuyla upgrade. The version of current configuration will be based on the former OpenNebula version.

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      unknown
        ERROR: Unknown config version

Configuration Metadata Outdated Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the ``onecfg`` tool complains about outdated metadata, you have not run the configuration upgrade during some OpenNebula upgrades in the past. Please note configuration must be upgraded or processed even with OpenNebula maintenance releases.

The following invalid state:

    .. prompt:: bash # auto

        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.0
        ERROR: Configurations metadata are outdated.

needs to be fixed by reinitialization of the configuration state. Any unprocessed upgrades will be lost and the current state will be initialized based on your current OpenNebula version and configurations located in the system directories.

    .. prompt:: bash # auto

        # onecfg init --force
        # onecfg status
        --- Versions ------------------------------
        OpenNebula:  5.8.5
        Config:      5.8.5

        --- Available Configuration Updates -------
        No updates available.

Step 2 - Upgrade OpenNebula
---------------------------

Upgrade your OpenNebula packages by following the :ref:`Upgrades <upgrade>` chapter for the specific OpenNebula version you are upgrading from and to. Take into account that step **Update Configuration Files** in **Enterprise Edition** can be fully automated by running ``onecfg upgrade``. Follow the :ref:`onecfg upgrade <cfg_upgrade>` documentation on how to upgrade and troubleshoot the configurations.

Step 3 - Validation
-------------------

When all steps are done, run OpenNebula and check the working state as explained :ref:`here <validate_upgrade>`.
