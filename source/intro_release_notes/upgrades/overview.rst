.. _upgrade_overview:

================================================================================
Overview
================================================================================

Keeping your OpenNebula up-to-date is very important, as you will receive the latest functionality and more importantly, the latest security patches. It is possible to upgrade to the latest OpenNebula release from earlier versions.

Depending on wether you are using the Enterprise Edition or the Community Edition you can upgrade from the stable versions back for the former or only from the latest stable for the latter. Furthermore, Community Edition upgrades are only available for non-commercial users, and migrator package `need to be requested <https://opennebula.io/get-migration>`__.

Hypervisor Compatibility
================================================================================

The upgrade procedure can be followed regardless of the hypervisor.

How Should I Read This Chapter
================================================================================

You only need to read this chapter if you are upgrading OpenNebula to a newer release. Make sure you have read the :ref:`Release Notes <rn>` and particularly the :ref:`Compatibility <compatibility>` section first.

The first stop is the :ref:`Start Here <start_here>` section that lays out the workflow needed to upgrade. Upgrading is a sequential procedure. The system will upgrade from the currently installed release to the latest release going through each release (if any). Therefore it's important to also read the guides that describe extra steps if you are ugrading from a release previous to the latest stable. Check :ref:`this <upgrade_from_previous>` if you need to upgrade from a previous version. In case something goes awry you can always :ref:`restore OpenNebula <restoring_version_5.10>` to the state previous to the update.

After the upgrade procedure you can continue using your upgraded OpenNebula Cloud.
