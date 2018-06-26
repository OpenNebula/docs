
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.6.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.6.

To consider only if upgrading from OpenNebula 5.x.x
================================================================================

OpenNebula Administrators
================================================================================

Fine grain tuning for MONITOR_INTERVAL
--------------------------------------------------------------------------------

The `MONITOR_INTERVAL` configuration has been split in multiple attributes to fine tune the monitoritzation of each component. If you have changed this value you need to adjust the associated new attribute, most probably `MONITORING_INTERVAL_HOST`.

New behavior of attributes
--------------------------------------------------------------------------------

  * Now empty attributes are just ignored or removed when merged. In prior versions produce a parse error or the old value was maintained, so it was impossible to remove attributes from Sunstone.

  .. code-block:: yaml

    ATTR = []

  * When creating an image DEFAUL_IMAGE_PERSISTENT_NEW can be overrriden by the PERSISTENT value of the new image. Sunstone and CLI provides a way to set this value to overrride the user/group default.

Security Groups
--------------------------------------------------------------------------------

When creating a VM, OpenNebula will check access to all the security groups involved in the request. This include security groups explicitly set in the NIC as well as security groups in the VNET and its ARs.

Image LOCK state
--------------------------------------------------------------------------------

When an operation is being performed on an image it is in LOCK state. Since 5.6, this LOCK state also implies an object lock to prevent for example deleting an image while it is being copied. This means that you may need to manually unlock the image if you want to perform any operation over it (e.g. chown or chmod) while it is being copied.


Precedence of Datastore and Image Attributes & Marketplace import
--------------------------------------------------------------------------------

The value precedence has been changed to VM Template (DISK) > Image > Datastore for the following attributes: CLONE_TARGET, LN_TARGET, DISK_TYPE & DRIVER.

Also images imported from a Marketplace do not follow the DRIVER attribute of the MarketPlaceApp when it may conflict with that defined in the Datastore.

Ruby OCA Update function
--------------------------------------------------------------------------------

The behavior of resource ``update`` has changed. If the new template is **nil**, the function will return a XMLRPC error.


Remote scripts configuration
--------------------------------------------------------------------------------

Configuration files from deep inside the remote scripts directory structure ``/var/lib/one/remotes/`` have been moved into dedicated directory ``/var/lib/one/remotes/etc/``. Check all the files on the new path, and apply any necessary changes to your environment.

Open vSwitch
--------------------------------------------------------------------------------

The ARP Cache Poisoning prevention rules has been more integrated into the filters logic and now works as another layer of security only if ``FILTER_IP_SPOOFING`` and/or ``FILTER_MAC_SPOOFING`` is enabled for the particular Virtual Network. Support for legacy firewall (``BLACK_PORTS_TCP``, ``BLACK_PORTS_UDP``, ``ICMP``) has been removed.

Network drivers
--------------------------------------------------------------------------------

If the KVM virtual network is defined with ``PHYDEV`` parameter, the missing bridge is created on demand and **destroyed when the physical interface is the only one left**. This behavior can be changed globally via option ``keep_empty_bridge`` inside ``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``, or per virtual network via ``CONF`` template attribute. If a bridge was initially created outside the OpenNebula with some configuration (e.g., assigned IP address), this state can be lost with the OpenNebula default settings. Applies to all KVM network drivers except the ``dummy``.

Note also that the "Bridged" modes are now mapped to the new driver ``bridge`` in Sunstone. You can still pick the old ``dummy`` driver by choosing a custom driver.

LVM drivers
--------------------------------------------------------------------------------

:ref:`LVM Drivers <lvm_drivers>` now zero the space when the volume is allocated, resized, and released. This may result in slower processing of the virtual machine states ``PROLOG``, ``DISK_RESIZE``, and ``EPILOG``.

HA
--------------------------------------------------------------------------------

Raft hook ``vip.sh`` now controls the OpenNebula Flow and Gate services via the service manager commands. Services are started only if they are enabled in the service manager (this would lead to start of the services on boot in the standalone deployment).

Marketplace
--------------------------------------------------------------------------------

MD5 attribute from marketplace app images will be carried to the OpenNebula image as FROM_APP_MD5 instead of MD5 as previous versions. This change won't be automatically upgraded, so if needed it must be done manually. This change prevents errors exporting these images as the file might be changed (for instance, if it has been made persistent) and hence the MD5 checksum will yield a different result.

Image allocate without checks for datastore capacity
--------------------------------------------------------------------------------

Command `oneimage create` accepts a new parameter `--no_check_capacity` to specify if you want OpenNebula to avoid checking datastore capacity.

Developers and Integrators
================================================================================

Authentication drivers
--------------------------------------------------------------------------------
Authentication drivers now accept parameters only on the standard input as the XML document; all custom authentication drivers need to be modified to follow this way. Check the :ref:`authentication driver <devel-auth>` documentation.

vCenter
================================================================================

Imported Names
--------------------------------------------------------------------------------

Due to the new onevcenter tool and driver changes, OpenNebula names of imported vCenter resources are different. See :ref:`new vCenter import tool <vcenter_new_import_tool>`.

In previous OpenNebula versions imported names were generated using a lot of data (vCenter host, long hash code, datacenter...) that had led to a situation in wich OpenNebula had very longs names ,this made cloud administration difficult in some cases.

That is why you can import right now any vCenter resource by default with the same name, just like the one showed on vSphere application.
In case of name collision, OpenNebula will resolve the situation adding 2 identification bytes at the end of the name.

.. prompt:: text $ auto

    You have already Imported a OpenNebula host called Cluster
    You want to import another from other vCenter host with the same name

    First OpenNebula Host with same name : Cluster
    Second OpenNebula Host with same name: Cluster-2c

Imported Networks
--------------------------------------------------------------------------------
It is possible to have imported Port Groups or Distributed Portgroups pointing to more than 1 cluster by default. The old behaviour of OpenNebula allowed to have one OpenNebula network per OpenNebula cluster/vCenter cluster, this has changed by default.

Sunstone
================================================================================

New view system
--------------------------------------------------------------------------------

The directory hierarchy in ``/etc/one/sunstone-views/`` has changed. Now, in sunstone-views there should be directories (KVM, vCenter, mixed) that contain the views configuration (yaml).

``sunstone-server.conf`` has the **mode** parameter, with which we will select :ref:`the directory of the views <suns_views>` we want.

Yamls changes
--------------------------------------------------------------------------------

If you are interested in adding a VMGroup or DS in vCenter Cloud View, you should make the following changes in ``/etc/one/sunstone-views/cloud_vcenter.yaml``:

- https://github.com/OpenNebula/one/commit/d019485e3d69588a7645fe30114c3b7c135d3065
- https://github.com/OpenNebula/one/commit/efdffc4723aae3d2b3f524a1e2bb27c81e43b13d

Sunstone addons
--------------------------------------------------------------------------------

Sunstone now uses directory ``/var/lib/one/sunstone/`` to store the preprocessed frontend source files. If Sunstone is running under the web server (e.g., via Passenger), additional directory permissions may be required for the web server identity to be able to access the ``/var/lib/one/sunstone/`` directory. Please see :ref:`Configuring Sunstone for Large Deployments <suns_advance>`.
