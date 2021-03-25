.. _cfg_overview:

=========
Overview
=========

.. important::

   Complete feature is available in OpenNebula **Enterprise Edition**.
   Only a single functionality comes in **Community Edition**.

OpenNebula has tens of configuration files, where cloud administrators can fine-tune the behavior of his cloud environment. When doing an upgrade to a newer minor OpenNebula version (``X.Y``), unfortunately, all custom changes in configuration files must be migrated to new configuration files. OpenNebula **Enterprise Edition** comes with a dedicated tool (``onecfg``), which automates and simplifies the upgrade of configuration files.

This chapter describes how to use the configuration management tool to

- Upgrade your configuration files for the new OpenNebula version.
- Check the verion status of the current installation.
- Identify custom changes made to the configuration files.
- Apply changes to configuration files based on differential file (available also in **Community Edition**).
- Validate configuration files.

How Should I Read This Chapter
==============================

In this chapter, you will find all the information about how to manage your configuration files. Although this knowledge is not so important for the new installations, it's essential for the OpenNebula upgrades which might happen in the near future.

First, get familiar with the :ref:`Basic Usage <cfg_usage>` of the tool ``onecfg``. Continue to the :ref:`Diff Format <cfg_diff_formats>`, which describes the custom changes you already have or you want to apply. Then get familiar how configuration upgrade automation fits into the :ref:`OpenNebula Upgrade Workflow <cfg_workflow>` and how to :ref:`Troubleshoot <cfg_conflicts>` potential conflicts.

The :ref:`Appendix <cfg_files>` presents list of supported configuration files and their types.

Hypervisor Compatibility
================================================================================

This chapter applies to all supported hypervisors.
