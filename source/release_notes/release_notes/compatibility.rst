.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.10.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.12.

OpenNebula Administrators
================================================================================

Virtual Data Centers
--------------------------------------------------------------------------------

- The previous Group Resoure Providers functionality has been moved to a new entity, VDCs. You can read more in the :ref:`Understanding OpenNebula guide <understand_compatibility>` and the :ref:`VDCs guide <manage_vdcs>`.

Security Groups
--------------------------------------------------------------------------------

.. todo:: previous FW drivers and new security groups

Developers and Integrators
================================================================================

This section lists all the changes in the API. Visit the :ref:`complete reference <api>` for more information.

XML-RPC API
--------------------------------------------------------------------------------

* New api calls:

  * ``one.vdc.info``
  * ``one.vdc.allocate``
  * ``one.vdc.update``
  * ``one.vdc.rename``
  * ``one.vdc.delete``
  * ``one.vdc.addgroup``
  * ``one.vdc.delgroup``
  * ``one.vdc.addcluster``
  * ``one.vdc.delcluster``
  * ``one.vdc.addhost``
  * ``one.vdc.delhost``
  * ``one.vdc.adddatastore``
  * ``one.vdc.deldatastore``
  * ``one.vdc.addvnet``
  * ``one.vdc.delvnet``
  * ``one.vdcpool.info``
  * ``one.secgroup.allocate``
  * ``one.secgroup.clone``
  * ``one.secgroup.delete``
  * ``one.secgroup.chown``
  * ``one.secgroup.chmod``
  * ``one.secgroup.update``
  * ``one.secgroup.rename``
  * ``one.secgroup.info``
  * ``one.secgrouppool.info``
  * ``one.vmpool.showback``
  * ``one.vmpool.calculateshowback``

* Deleted api calls:

  * ``one.group.addprovider``: Replaced by VDCs
  * ``one.group.delprovider``: Replaced by VDCs
