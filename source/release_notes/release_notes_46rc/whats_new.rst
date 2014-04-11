.. _whats_new_46rc:

============================
What's New in OpenNebula 4.6
============================

OpenNebula 4.6 introduces important improvements in several areas. The
provisioning model has been greatly simplify by supplementing user groups with
resource providers. This extended model, the Virtual Data Center, offers an
integrated and comprehensive framework for resource allocation and isolation.

Another important new feature has taken place in the OpenNebula core. It has
undergone a minor re-design of its internal data model to allow federation of
OpenNebula daemons. With OpenNebula Carina your users can access resource
providers from multiple data-centers in a federated way.

With Carina the OpenNebula team has started a journey to deliver a more
intuitive and simpler provisioning experience for users. Our goal is level the
final user usability with the system administration and operation ones. First,
the Sunstone graphical interface has been tweaked to help the user workflows. It has also
been improved in order to support the new Marketplace version,
which makes even easier for a user to get a virtual application up and running.

Finally, some other areas has received the attention of the OpenNebula developers,
like for example a better `Gluster <gluster_ds>` support through libgfapi,
improved access to large pools pagination, or optionally limit the resources exposed
by a host, among many others are included in Carina.

As usual OpenNebula releases are named after a Nebula. The Carina Nebula (NGC
3372) is one of the largest nebulae the sky. It can only be seen from the
southern hemisphere, in the Carina constellation.

In the following list you can check the highlights of OpenNebula 4.6 Carina
organised by component (`a detailed list of changes can be found here 
<http://dev.opennebula.org/projects/opennebula/issues?query_id=50>`__):

OpenNebula Core: Virtual Data Centers
-------------------------------------

The provisioning model of OpenNebula 4.6 has been simplified to provide an
integrated and comprehensive framework for resource allocation and isolation in
federated data centers and hybrid cloud deployments:

- **User Groups** can be assigned one or more **resource providers**. Resource providers are defined as a cluster of servers, virtual networs, datastores and public clouds for cloud bursting in an OpenNebula zone. Read more in the :ref:`Users and Groups Management Guide <managing-resource-provider-within-groups>`.
- A special **administration group** can be defined to manage specific aspects of the group like user management or appliances definition. Read more in the :ref:`Managing Users and Groups <manage_users>` guide.
- **Suntone views** for new groups can be dynamically defined without the need of modifying the Suntone configuration files. More information in the :ref:`Sunstone Views <suns_views>` guide.
- Groups can now be tagged with custom attributes. Read more in the :ref:`Managing Users and Groups <manage_users>` guide.

OpenNebula Core: Federation & Zones
-----------------------------------

Federation has been integrated in OpenNebula core:

- Users can seamlessly provision virtual machines from multiple zones with an integrated interface both in Sunstone and CLI.
- A **new tool set** has been developed to upgrade, integrate new zones and import existing zones into an OpenNebula federation. Read more in the :ref:`Federation Configuration <federationconfig>` guide.
- **Integrated zone management** in OpenNebula core. Read more about this in the :ref:`Data Center Federation <introf>` guide.
- **Redesigned data model** to minimize replication data across zones and to tolerate large latencies. Read more about this in the :ref:`Data Center Federation <introf>` guide.

OpenNebula Core: Usability & Performance Enhancements
-----------------------------------------------------

There has been several improvements for end-users:

- **Datastore management** improved with the ability to redefine some configuration attributes and default datastores. Take a look at the :ref:`Filesystem Datastore <fs_ds>` guide to see the list of attributes.
- **Network management** also allows to change configuration attributes by updating the template. This includes ``VLAN_ID``, ``BRIDGE``, ``VLAN`` and ``PHYDEV``. See the :ref:`Managing Virtual Networks <vgg>` guide for more information. Network leases can be also deleted on hold.
- **Optionally limit resources** exposed by host or a cluster, see :ref:`Scheduler <schg>` for more information.
-  **Support for pool pagination**, which makes OpenNebula interfaces such as the CLI and Sunstone more responsive and improves scalability. See the :ref:`Scalability <one_scalability>` guide for more information.

OpenNebula Drivers
------------------

The back-end of OpenNebula has been also improved in several areas, as described below:

Storage Drivers
~~~~~~~~~~~~~~~

-  **Improved Support for Ceph**, includeing RBD format 2 and direct support for CDROM devices, more info :ref:`here <ceph_ds>`.
-  **Gluster support using libgfapi**, more info :ref:`here <gluster_ds>`.

Virtualization Drivers
~~~~~~~~~~~~~~~~~~~~~~

-  **KVM Hypervisor improvements** like tweakable SPICE parameters, KVM Hyper-V Enhancements, ``LOCALTIME`` and ``MACHINE`` parameters support , see the :ref:`Template <template>` guide for more information.
-  **Support for Xen FEATURES parameters**, which includes options like ``PAE``, ``ACPI``, ``APIC``, etc. See the :ref:`Template <template>` guide for more information.

Sunstone
--------

-  New cloud view with a simpler, clean and intuitive design
-  **Updated UI Library** providing a new look.
-  The **Sunstone View** for each user can be **specified in the User template or in the new Group template**, more info in the :ref:`Sunstone Views <suns_views>` guide.
-  **Support for Zone selection**, which allows users to switch between OpenNebula Zones from within the same Sunstone.
-  General usability enhancements for all the resources.


AppMarket
---------

-  **Native support of the new Marketplace version** by the CLI and Sunstone, which provides the possibility of importing multi-disk virtual machines. Read more in the `<https://github.com/OpenNebula/addon-appmarket>`__.
-  Support for **importing OVAs** processed by the **AppMarket Worker**. Read more `here <https://github.com/OpenNebula/addon-appmarket/blob/master/doc/usage.md#importing-an-appliance-from-sunstone>`__.
