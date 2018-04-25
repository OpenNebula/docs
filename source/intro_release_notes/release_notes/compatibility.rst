
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

New behavior of empty attributes
--------------------------------------------------------------------------------

.. code-block:: yaml

  ATTR = []

Now empty attributes are just ignored or removed when merged. In prior versions produce a parse error or the old value was maintained, so it was impossible to remove attributes from Sunstone.

Ruby OCA Update function
--------------------------------------------------------------------------------

The behavior of resource ``update`` has changed. If the new template is **nil**, the function will return a XMLRPC error.

OpenNebula Daemon
--------------------------------------------------------------------------------

Remote scripts configuration
--------------------------------------------------------------------------------

Configuration files from deep inside the remote scripts directory structure ``/var/lib/one/remotes/`` have been moved into dedicated directory ``/var/lib/one/remotes/etc/``. Check all the files on the new path, and apply any necessary changes to your environment.

Open vSwitch
--------------------------------------------------------------------------------

The ARP Cache Poisoning prevention rules has been more integrated into the filters logic and now works as another layer of security only if ``FILTER_IP_SPOOFING`` and/or ``FILTER_MAC_SPOOFING`` is enabled for the particular Virtual Network. Support for legacy firewall (``BLACK_PORTS_TCP``, ``BLACK_PORTS_UDP``, ``ICMP``) has been removed. If network is defined with ``PHYDEV``, the bridge is destroyed when the physical interface is the only one left and created again when needed.

HA
--------------------------------------------------------------------------------

Raft hook ``vip.sh`` now controls the OpenNebula Flow and Gate services via the service manager commands. Services are started only if they are enabled in the service manager (this would lead to start of the services on boot in the standalone deployment).

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
