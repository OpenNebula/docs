.. _start_here:

=================================
Start Here
=================================

This guide describes the upgrade procedure for systems that are already running a 5.12.x OpenNebula Enterprise Edition or older. The upgrade to OpenNebula |version| can be done directly by following this section; you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, Hosts, resources and configurations, for both SQLite and MySQL/MariaDB Back-ends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what's new in OpenNebula |version|.

.. important::

    Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this `online form <https://opennebula.io/get-migration>`__.

Previous Steps
==============

Community Edition
------------------

See the warning above. After you get the 'opennebula-migration-community' package, you need to install it in the OpenNebula Front-end:

CentOS/RHEL
~~~~~~~~~~~

.. prompt:: bash # auto

		# rpm -i opennebula-migration-community*.rpm

Debian/Ubuntu
~~~~~~~~~~~~~

.. prompt:: bash # auto

		# dpkg -i opennebula-migration-community*.deb

Enterprise Edition
------------------

Enterprise Edition is distributed with a tool ``onecfg`` as part of the main server package (in 5.12 and earlier it was provided via the OneScape project and repository). This tool simplifies the upgrade process of configuration files and always comes in the latest version of OpenNebula.

.. important::

    **For each OpenNebula upgrade (even between minor versions, e.g. 5.10.2 and 5.10.3), configuration files must be processed via 'onecfg upgrade'**. If you skip the configuration upgrade step for an OpenNebula upgrade, the tool will lose the current version state and you'll have to handle the files upgrade manually and :ref:`reinitialize <cfg_init>` the configuration version management state.

    .. prompt:: bash # auto

        # onecfg upgrade
        FATAL : FAILED - Configuration can't be processed as it looks outdated!
        You must have missed to run 'onecfg update' after previous OpenNebula upgrade.

        # onecfg status
        ...
        ERROR: Configurations metadata are outdated.

.. _upgrade_guides:

Upgrade OpenNebula
==============================================


Update your OpenNebula packages by following only the guide that applies to your current OpenNebula configuration:

- :ref:`Upgrading a Single Front-End Deployment <upgrade_single>`
- :ref:`Upgrading an HA Cluster <upgrade_ha>`
- :ref:`Upgrading a Federation <upgrade_federation>`

Follow :ref:`onecfg upgrade <cfg_upgrade>` documentation for information on how to upgrade and troubleshoot the configurations.

.. important::

    Please read the corresponding guides (only the one that applies to the specific version you are upgrading from) if you are upgrading from OpenNebula :ref:`5.6 <upgrade_56>` or :ref:`5.8 <upgrade_58>` and make sure you apply all the required changes described in the corresponding guide.


.. _validate_upgrade:

Validate OpenNebula
==============================================

When all steps are done, run OpenNebula and check the working state.

Check the configuration state via ``onecfg status``. There shouldn't be any errors and no new updates available. Your configuration should be up-to-date for the currently installed OpenNebula version. For example:

.. prompt:: bash # auto

    # onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.10.2
    Config:      5.10.0

    --- Available Configuration Updates -------
    No updates available.
