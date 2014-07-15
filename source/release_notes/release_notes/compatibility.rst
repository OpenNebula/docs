.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.6 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.8.

OpenNebula Administrators and Users
================================================================================

Virtual Machine Templates
--------------------------------------------------------------------------------

- You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL``, that final users may not be aware of.

.. code::

    NIC_DEFAULT = [ MODEL = "virtio" ]

- Sunstone now supports multiple boot devices. Although this could be done via CLI, now you can set them also in the Template wizard.

|sunstone_multi_boot|


Virtual Machines
--------------------------------------------------------------------------------

When a guest is shutdown, the OpenNebula VM will now move to the ``poweoff`` state, instead of ``unknown``.

.. todo:: #2530 disk iotune

Virtual Networks
--------------------------------------------------------------------------------

.. todo::


.. todo:: #2318 Block ARP cache poisoning in openvswitch

Images
--------------------------------------------------------------------------------

Images can now be :ref:`cloned to a different Datastore <img_guide>`. The only restriction is that the new Datastore must be compatible with the current one, i.e. have the same DS_MAD drivers.

.. code::

    $ oneimage clone Ubuntu new_image --datastore new_img_ds

Usage Quotas
--------------------------------------------------------------------------------

Up to 4.6, a quota of '0' meant unlimited usage. In 4.8, '0' means a limit of 0, and '-2' means unlimited. See the :ref:`quotas documentation <quota_auth>` for more information.

Context Packages
--------------------------------------------------------------------------------

.. todo:: #2927 GATEWAY_IFACE

.. todo:: #2395 windows guest context


OneFlow Services
--------------------------------------------------------------------------------

.. todo:: #2917 Pass information between roles, using onegate facilities

Sunstone
--------------------------------------------------------------------------------

- The easy provisioning wizard has been completely removed from Sunstone. The easy provisioning, or self-service view, was a wizard introduced in 4.4, and replaced in 4.6 by the more complete Cloud view (read more in the `4.6 compatibility guide <http://docs.opennebula.org/4.6/release_notes/release_notes/compatibility.html#sunstone-cloud-view>`_)
- In 4.6 you could select the available :ref:`sunstone views <suns_views>` for new groups. In case you have more than one, you can now also select the default view.

|sunstone_group_defview|

.. todo:: #2976 Search user table in Sunstone by any attribute in the user template
.. todo:: #2971 Add acct statistics to user dashboard (there is no user tab)
.. todo:: #2953 Add hold option to VM template instantiate dialog
.. todo:: #2934 Add rename and modify description/logo for templates
.. todo:: #2860 Create VM wizard should show template owner and group columns - Visible columns are configured in the .yaml file
.. todo:: #2807 Migrate dialog should show the host's cluster - Visible columns are configured in the .yaml file
.. todo:: #2787 Add the possibility to show vlan id in virtual network list
.. todo:: #2977 Customize available actions in cloud/admin views


Developers and Integrators
================================================================================

Public Clouds APIs
--------------------------------------------------------------------------------

.. todo:: #3041 Move OCCI from the main repository to an addon

Storage
--------------------------------------------------------------------------------

.. todo:: #2970 Enable use of devices as disks

.. todo:: #2877 RBD format 2 support for MKFS

Logs
--------------------------------------------------------------------------------

.. todo:: #2950 zone id in logs

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

.. todo:: VM_POLL=YES in case of hypervisor failure


.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_multi_boot| image:: /images/sunstone_multi_boot.png