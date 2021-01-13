.. _opennebula_installation_overview:

================================================================================
Overview
================================================================================

The Frontend is the central part of an OpenNebula installation. This is the machine where the server software is installed and where you connect to manage your cloud. It can be a physical node or a virtual instance.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read and understood the :ref:`Cloud Design <cloud_design>` chapter.

The aim of this chapter is to give you a quick-start guide to deploy OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup, with :ref:`Advanced Components <advanced_components>` (like :ref:`Host and VM High Availability <ha>`, :ref:`Cloud Bursting <introh>`, etc...).

First you should read the :ref:`Front-end Installation <frontend_installation>` section. Note that by default it uses an SQLite database that is not recommended for production. So, if this is not a small proof of concept, while following the Installation section you should use the :ref:`MySQL <mysql_setup>`.

After reading this chapter, read the :ref:`Node Installation <node_installation>` chapter next in order to add hypervisors to your cloud.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------------+-----------------------------------------------+
|                        Section                        |                 Compatibility                 |
+=======================================================+===============================================+
| :ref:`Front-end Installation <frontend_installation>` | This Section applies to all hypervisors       |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`MySQL Setup <mysql_setup>`                      | This Section applies to all hypervisors       |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`Scheduler <schg>`                               | This Section applies to all hypervisors       |
+-------------------------------------------------------+-----------------------------------------------+
