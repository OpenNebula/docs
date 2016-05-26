================================================================================
Overview
================================================================================

* Architect
* KVM
* vCenter

The Front-end is the central part of an OpenNebula installation. This is the machine where the server software is installed and where you connect to manage your cloud. It can be a physical node or a Virtual Machine.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read and understood the :ref:`Cloud Design <cloud_design>` chapter.

The aim of this chapter is to give you a quick-start guide to deploy OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup, with :ref:`Advanced Components <advanced_components>` (like :ref:`Host and VM High Availability <ha>`, :ref:`Cloud Bursting <introh>`, etc...).

First you should read the :ref:`Front-end Installation <frontend_installation>` section. Note that by default it uses a SQLite database that is not recommended for production so, if this is not a small proof of concept, while following the Installation section, you should enable :ref:`MySQL <mysql_setup>`.

After reading this chapter, read the :ref:`Node Installation <node_installation>` chapter next in order to add hypervisors to your cloud.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------------+-----------------------------------------------+
|                        Section                        |                 Compatibility                 |
+=======================================================+===============================================+
| :ref:`Front-end Installation <frontend_installation>` | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`MySQL Setup <mysql_setup>`                      | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------+-----------------------------------------------+
| :ref:`Scheduler <schg>`                               | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------+-----------------------------------------------+
