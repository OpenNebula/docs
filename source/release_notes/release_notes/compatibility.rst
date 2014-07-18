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

Virtual Networks
--------------------------------------------------------------------------------

Virtual Networks have undergone and important upgrade in 4.8. The VNET data model has been extended to implement a flexible VNET definition along with a whole new set of functionality, like reservations or network groups. Applications dealing directly with the XML representation needs to be updated. Also two XML-RPC methods have been removed: addleases and rmleases; although these methods have been preserved at the OCA and CLI level.

Note also that the definition of a VNET is different in 4.8, so any application that automates VNET creation needs to be ported to the new format.

OpenNebula's upgrade process will automatically migrate your networks to the new format. There is no need to update VM templates or Virtual Machines.

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

- Although templates could be instantiated on hold before from the CLI, now you can also do that from Sunstone:

|sunstone_instantiate_hold|

.. todo:: #2976 Search user table in Sunstone by any attribute in the user template
.. todo:: #2971 Add acct statistics to user dashboard (there is no user tab)
.. todo:: #2934 Add rename and modify description/logo for templates
.. todo:: #2977 Customize available actions in cloud/admin views


Developers and Integrators
================================================================================

Sunstone
--------------------------------------------------------------------------------

- The table columns defined in the :ref:`view.yaml file <suns_views>` now apply not only to the main tab, but also to other places where the resources are used. For example, if the admin.yaml file defines only the Name and Running VMs columns:

.. code::

    hosts-tab:
        table_columns:
            #- 0         # Checkbox
            #- 1         # ID
            - 2         # Name
            #- 3         # Cluster
            - 4         # RVMs
            #- 5         # Real CPU
            #- 6         # Allocated CPU
            #- 7         # Real MEM
            #- 8         # Allocated MEM
            #- 9         # Status
            #- 10        # IM MAD
            #- 11        # VM MAD
            #- 12        # Last monitored on

These will be the only visible columns in the main host list:

|sunstone_yaml_columns1|

And also in the dialogs where a host needs to be selected, like the VM deploy action:

|sunstone_yaml_columns2|

- The Virtual Network table has a new column that can be enabled in the :ref:`Sunstone view.yaml files <suns_views>`: VLAN ID

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


.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_multi_boot| image:: /images/sunstone_multi_boot.png
.. |sunstone_instantiate_hold| image:: /images/sunstone_instantiate_hold.png
.. |sunstone_yaml_columns1| image:: /images/sunstone_yaml_columns1.png
.. |sunstone_yaml_columns2| image:: /images/sunstone_yaml_columns2.png
