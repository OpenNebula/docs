.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.6 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.8.

OpenNebula Administrators and Users
================================================================================

Virtual Machines
--------------------------------------------------------------------------------

When a guest is shutdown, the OpenNebula VM will now move to the ``poweoff`` state, instead of ``unknown``.

Virtual Networks
--------------------------------------------------------------------------------

Virtual Networks have undergone and important upgrade in 4.8. The VNET data model has been extended to implement a flexible VNET definition along with a whole new set of functionality, like reservations or network groups. Applications dealing directly with the XML representation needs to be updated. Also two XML-RPC methods have been removed: addleases and rmleases; although these methods have been preserved at the OCA and CLI level.

Note also that the definition of a VNET is different in 4.8, so any application that automates VNET creation needs to be ported to the new format.

OpenNebula's upgrade process will automatically migrate your networks to the new format. There is no need to update VM templates or Virtual Machines.

.. todo:: #2318 Block ARP cache poisoning in openvswitch

Usage Quotas
--------------------------------------------------------------------------------

Up to 4.6, a quota of '0' meant unlimited usage. In 4.8, '0' means a limit of 0, and '-2' means unlimited. See the :ref:`quotas documentation <quota_auth>` for more information.

Context Packages
--------------------------------------------------------------------------------

.. todo:: #2927 GATEWAY_IFACE

OneFlow Services
--------------------------------------------------------------------------------

.. todo:: #2917 Pass information between roles, using onegate facilities

Sunstone
--------------------------------------------------------------------------------

- The easy provisioning wizard has been completely removed from Sunstone. The easy provisioning, or self-service view, was a wizard introduced in 4.4, and replaced in 4.6 by the more complete Cloud view (read more in the `4.6 compatibility guide <http://docs.opennebula.org/4.6/release_notes/release_notes/compatibility.html#sunstone-cloud-view>`_)

- The former vdcadmin view has been deprecated and a new version based on the simplified cloud view is available.

.. todo:: #2976 Search user table in Sunstone by any attribute in the user template
.. todo:: #2971 Add acct statistics to user dashboard (there is no user tab)

Developers and Integrators
================================================================================

Public Clouds APIs
--------------------------------------------------------------------------------

The OCCI server is no longer part of the distribution and now resides in an addon repository. If you are searching for an OCCI server you'd better use the `rOCCI Server <http://gwdg.github.io/rOCCI-server/>`_.

.. todo:: add OCCI addon repo URL

Storage
--------------------------------------------------------------------------------

OpenNebula 4.8 includes a new datastore type to support raw device mapping. Together with the datastore a new set of transfer manager drivers has been developed and included in the OpenNebula distribution.

Support for RBD format 2 has been extended and improved for Ceph datastore using this type.

Logs
--------------------------------------------------------------------------------

Log format has been extended to include the Zone ID to identify the originating Zone of the log message. Any application parsing directly ``oned.log`` may need to take this into account.

XML-RPC API
--------------------------------------------------------------------------------

* New api calls:

  * ``one.vn.reserve``: Reserve network addresses
  * ``one.vn.add_ar``: Adds address ranges to a virtual network
  * ``one.vn.rm_ar``: Removes an address range from a virtual network
  * ``one.vn.update_ar``: Updates the attributes of an address range
  * ``one.vn.free_ar``: Frees a reserved address range from a virtual network

* Deleted api calls:

  * ``one.vn.addleases``: Use ``one.vn.add_ar`` instead
  * ``one.vn.rmleases``: Use ``one.vn.rm_ar`` instead

* Changed api calls:

  * ``one.vn.update``: Now requires NET:ADMIN rights, instead of MANAGE
  * ``one.image.clone``: New optional parameter to set the target datastore

Monitoring Drivers
--------------------------------------------------------------------------------

Management of VMs in UNKOWN state has been improved in OpenNebula 4.8. When a
VM is not running in a hypervisor is moved to the POWEROFF state, while if the
hypervisor itself cannot be contacted the VMs are put in UNKOWN. Any custom monitoring driver needs to follow this behavior and include ``VM_POLL=YES`` even no VM is in the hypervisor list.
