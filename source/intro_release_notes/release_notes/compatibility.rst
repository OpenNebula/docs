
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.4.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.6.

To consider only if upgrading from OpenNebula 5.x.x
================================================================================

OpenNebula Administrators
================================================================================

New behavior of attributes
--------------------------------------------------------------------------------

  * Now empty attributes are just ignored or removed when merged. In prior versions produce a parse error or the old value was maintained, so it was impossible to remove attributes from Sunstone.

  .. code-block:: yaml

    ATTR = []

  * When creating an image DEFAUL_IMAGE_PERSISTENT_NEW can be overrriden by the PERSISTENT value of the new image. Sunstone and CLI provides a way to set this value to overrride the user/group default.

Security Groups
--------------------------------------------------------------------------------

When creating a VM, OpenNebula will check access to all the security groups involved in the request. This include security groups explicitly set in the NIC as well as security groups in the VNET and its ARs.

Precedence of Datastore and Image Attributes & Marketplace import 
--------------------------------------------------------------------------------

The value precedence has been changed to VM Template (DISK) > Image > Datastore for the following attributes: CLONE_TARGET, LN_TARGET, DISK_TYPE & DRIVER.

Also images imported from a Marketplace do not follow the DRIVER attribute of the MarketPlaceApp as it may conflict with that defined in the Datastore.

Ruby OCA Update function
--------------------------------------------------------------------------------

The behavior of resource ``update`` has changed. If the new template is **nil**, the function will return a XMLRPC error.


Remote scripts configuration
--------------------------------------------------------------------------------

Configuration files from deep inside the remote scripts directory structure ``/var/lib/one/remotes/`` have been moved into dedicated directory ``/var/lib/one/remotes/etc/``. Check all the files on the new path, and apply any necessary changes to your environment.

Open vSwitch
--------------------------------------------------------------------------------

The ARP Cache Poisoning prevention rules has been more integrated into the filters logic and now works as another layer of security only if ``FILTER_IP_SPOOFING`` and/or ``FILTER_MAC_SPOOFING`` is enabled for the particular Virtual Network. Support for legacy firewall (``BLACK_PORTS_TCP``, ``BLACK_PORTS_UDP``, ``ICMP``) has been removed. If network is defined with ``PHYDEV``, the bridge is destroyed when the physical interface is the only one left and created again when needed.

HA
--------------------------------------------------------------------------------

Raft hook ``vip.sh`` now controls the OpenNebula Flow and Gate services via the service manager commands. Services are started only if they are enabled in the service manager (this would lead to start of the services on boot in the standalone deployment).

Marketplace
--------------------------------------------------------------------------------

MD5 attribute from marketplace app images will be carried to the OpenNebula image as FROM_APP_MD5 instead of MD5 as previous versions. This change won't be automatically upgraded, so if needed it must be done manually. This change prevents errors exporting these images as the file might be changed (for instance, if it has been made persistent) and hence the MD5 checksum will yield a different result.

Developers and Integrators
================================================================================

Authentication drivers
--------------------------------------------------------------------------------
Authentication drivers now accept parameters only on the standard input as the XML document; all custom authentication drivers need to be modified to follow this way. Check the :ref:`authentication driver <devel-auth>` documentation.

vCenter
================================================================================

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
