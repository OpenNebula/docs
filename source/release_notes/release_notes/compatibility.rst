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

Previous versions supported firewall management through special attributes in the VM templates `WHITE_PORTS_TCP`, etc. This has been deprecated in favour of the the new :ref:`Security Groups <security_groups>`, which are a new entity in OpenNebula. Security Groups can be created and updated, consisting of one or more rules, where each rule is either INBOUND or OUTBOUND, global or for a specific protocol, within each protocol it can be global or for specific subtype of the protocol or ports. Furthermore, the rule can be adjusted to be applied only for a specific source or target, custom defined or an OpenNebula Network.

Backwards compatibility will be kept. If a Virtual Machine template contains one of the following attributes it will ignore security groups and continue to work as before:

* ``WHITE_PORTS_TCP``
* ``BLACK_PORTS_TCP``
* ``WHITE_PORTS_UDP``
* ``BLACK_PORTS_UDP``
* ``ICMP``

Note that Open vSwitch is **not** affected by this change, as it still works with the old firewall management style. In particular, only these network drivers are affected:

* ``802.1Q``
* ``ebtables``
* ``fw``
* ``vxlan``

It is also worth noting that new networks will be assigned the default security group, which allows all outbound traffic but **blocks all inbound traffic**. Change the ``default`` security group for your infrastructure if you want it to be different.

Group Administrators
--------------------------------------------------------------------------------

Previous versions allowed to create one special group administrator when the group was created. Now any user can be made an administrator at any moment. The main difference with the previous mechanism is that now the administrators don't have a separate set of resources they are allowed to create, i.e. the ``--admin_resources`` option is not present in the ``onegroup create`` command.

Virtual Networks
--------------------------------------------------------------------------------

When a Virtual Network is shown to a user, it only includes the leases to his objects. This way, they can see the IPs given to their VMs, but not to other user's VMs. For 4.12, all the leases are included (leases on hold and other user's VMs) if the user requesting the Virtual Network is the owner (has ``MANAGE`` rights).

Restricted Attributes for VMs
--------------------------------------------------------------------------------

The :ref:`VM restricted attributes <template_restricted_attributes>` are now checked when a VM Template is created (or updated), as opposed to when it is instantiated. This means that users will know inmediately if they are creating a restricted template. It also enables administrators to create VM Templates with restributed attributes and later change the owner to a normal user, that will be able to instantiate it without problems.

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
