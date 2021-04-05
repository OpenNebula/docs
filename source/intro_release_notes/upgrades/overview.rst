.. _upgrade_overview:

================================================================================
Overview
================================================================================

Keeping your OpenNebula up-to-date is very important, as you will receive the latest functionality and, more importantly, the latest security patches. It is possible to upgrade to the latest OpenNebula release from earlier versions.

If you are using the Enterprise Edition you can upgrade from previous OpenNebula versions. If you are using the Community Edition you can only upgrade from the previous stable release if you are using your cloud for non-commercial purposes and you `need to request the migrator package <https://opennebula.io/get-migration>`__.

Hypervisor Compatibility
================================================================================

The upgrade procedure can be followed regardless of the hypervisor.

How Should I Read This Chapter
================================================================================

You only need to read this chapter if you are upgrading OpenNebula to a newer release. Make sure you have read the :ref:`Release Notes <rn>` and particularly the :ref:`Compatibility <compatibility>` section first.

The first stop is the :ref:`Start Here <start_here>` section that lays out the workflow needed to upgrade. The system will upgrade from the currently installed release to the latest release. If you are running an Enterprise Edition version older than the previous stable version please read the guide that describes extra steps; there is one for :ref:`5.6 <upgrade_56>` and other for :ref:`5.8 <upgrade_58>` (note: follow only one of them). Check :ref:`this <upgrade_from_previous>` if you need to upgrade from a version older than 5.6. In case something goes awry you can always :ref:`restore OpenNebula <restoring_version>` to the state previous to the update.

After the upgrade procedure you can continue using your upgraded OpenNebula Cloud.
