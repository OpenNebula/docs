

================================================================================
Overview
================================================================================

* Architect
* KVM
* vCenter

The front-end is the central part of an OpenNebula installation. This is the machine where the server software is installed and where you connect to manage your cloud. It can be a physical node or a Virtual Machine.

How Should I Read This Chapter
================================================================================

First you should read the :ref:`Front-end Installation <frontend_installation>` guide. By default it uses a sqlite database that is not recommended for production so, if this is not a small proof of concept, you should head to :ref:`MySQL Setup <mysql_setup>` after that.

In the :ref:`Scheduler guide <schg>` you'll learn how to change the configuration to suit your needs. For example changing the scheduling policies or the number of VMs that will be sent per host.

Finally there is the :ref:`Front-end HA Setup <frontend_ha_setup>` section that will guide you on setting up two front-ends in and active/passive fashion. This setup requires the use of a MySQL database.

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
| :ref:`Front-end HA Setup <frontend_ha_setup>`         | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------+-----------------------------------------------+


