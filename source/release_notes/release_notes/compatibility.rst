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

You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL``, that final users may not be aware of.

.. code::

    NIC_DEFAULT = [ MODEL = "virtio" ]


Virtual Networks
--------------------------------------------------------------------------------

.. todo::

Images
--------------------------------------------------------------------------------

Images can now be :ref:`cloned to a different Datastore <img_guide>`. The only restriction is that the new Datastore must be compatible with the current one, i.e. have the same DS_MAD.

.. code::

    $ oneimage clone Ubuntu new_image --datastore new_img_ds

Usage Quotas
--------------------------------------------------------------------------------

Up to 4.6, a quota of '0' meant unlimited usage. In 4.8, '0' means a limit of 0, and '-2' means unlimited. See the :ref:`quotas documentation <quota_auth>` for more information.


Developers and Integrators
================================================================================

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
