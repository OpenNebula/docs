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

Group Administrators
--------------------------------------------------------------------------------

Previous versions allowed to create one special group administrator when the group was created. Now any user can be made an administrator at any moment. The main difference with the previous mechanism is that now the administrators don't have a separate set of resources they are allowed to create, i.e. the ``--admin_resources`` option is not present in the ``onegroup create`` command.

Virtual Networks
--------------------------------------------------------------------------------

When a Virtual Network is shown to a user, it only includes the leases to his objects. This way, they can see the IPs given to their VMs, but not to other user's VMs. For 4.12, all the leases are included (leases on hold and other user's VMs) if the user requesting the Virtual Network is the owner (has ``MANAGE`` rights).

Developers and Integrators
================================================================================

XML-RPC API
--------------------------------------------------------------------------------

This section lists all the changes in the API. Visit the :ref:`complete reference <api>` for more information.

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
  * ``one.group.addadmin``
  * ``one.group.deladmin``
  * ``one.datastore.enable``

* Deleted api calls:

  * ``one.group.addprovider``: Replaced by VDCs
  * ``one.group.delprovider``: Replaced by VDCs
