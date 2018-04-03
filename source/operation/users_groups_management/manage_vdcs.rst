.. _manage_vdcs:
.. _managing_resource_provider_within_groups:

==========================
Managing VDCs
==========================

A VDC (Virtual Data Center) defines an assignment of one or several :ref:`groups <manage_groups>` to a pool of physical resources. This pool of Physical Resources consists of resources from one or several Clusters that could belong to different Zones or public external clouds for hybrid cloud computing. You can read more about OpenNebula's approach to VDCs and the cloud from the perspective of different user roles in the :ref:`Understanding OpenNebula <understand>` guide.

The Default VDC
================================================================================

There is a special ``default`` VDC created during the installation that allows the use of ``ALL`` the physical resources.

The ``users`` group belongs to this VDC, and any new group is automatically added to the ``default`` VDC. You can modify the VDC physical resources, even remove all of them, but it can't be deleted.

.. note::

    Before adding a new group to a specific VDC, you may want to remove it from the ``default`` one, since it allows the use of ``ALL`` the physical resources.

Adding and Deleting VDCs
================================================================================

Your can use the ``onevdc`` command line tool to manage VDCs in OpenNebula.

To create new VDCs:

.. code::

    $ onevdc list
      ID NAME
       0 default

    $ onevdc create "high-performance"
    ID: 100

The new VDC has ID 100 to differentiate the default VDC from the user-defined ones.

Adding Groups to VDCs
================================================================================

By default a group doesn't belong to any VDC, so users won't be entitled to use any resource until explicitly added to one.

To add groups to a VDC:

.. code::

    $ onevdc addgroup <vdc_id> <group_id>

Adding Physical Resources to VDCs
================================================================================

Physical resources (hosts, virtual networks, and datastores) can be added to the VDC. Internally, the VDC will create ACL Rules that will allow the VDC groups to use this pool of resources.

Typically, you will want to add Clusters to the VDC. For instance, Cluster 7 from Zone 0:

.. code::

    $ onevdc addcluster <vdc_id > 0 7

But you can also add individual hosts, virtual networks, and datastores:

.. code::

    $ onevdc addhost <vdc_id> 0 3
    $ onevdc addvnet <vdc_id> 0 9
    $ onevdc adddatastore <vdc_id> 0 102

The special id ``ALL`` can be used to add all clusters/hosts/vnets/datastores from the given zone:

.. code::

    $ onevdc addcluser <group_id> 0 ALL


To remove physical resources from the VDC, use the symmetric operations ``delcluster``, ``delhost``, ``delvnet``, ``deldatastore``.

When you assign physical resources to a VDC, users in that VDC's groups will be able to use the Datastores and Virtual Networks. The scheduler will also deploy VMs from that group to any of the VDC Hosts.

If you are familiar with :ref:`ACL rules <manage_acl>`, you can take a look at the rules that are created with ``oneacl list``. These rules are automatically added, and should not be manually edited. They will be removed by the ``onevdc del*`` commands. The default permissions for these rules can be configured into :ref:`oned.conf <oned_conf>`

Examples
================================================================================

The VDC management offers plenty of flexibility to suit many different scenarios. This section lists a few of them to help to visualize the possibilities of your OpenNebula infrastructure.

For example, let's say Web Development, Human Resources, and Big Data Analysis as business units represented by Groups in a private OpenNebula cloud, with resources allocated from your zones and public clouds in order to create three different VDCs.

* **VDC BLUE**: VDC that allocates resources from DC_West_Coast + Cloudbursting to Web Development
* **VDC RED**: VDC that allocates resources from DC_West_Coast + DC_Europe + Cloudbursting to Human Resources
* **VDC GREEN**: VDC that allocates resources from DC_West_Coast + DC_Europe to Big Data Analysis

|VDC Organization|

Flexible Groups
--------------------------------------------------------------------------------

If you plan to have a small infrastructure, the VDC management may seem like an unnecessary extra step to assign physical resources to each Group. But having an independent VDC object allows it to have more than one Group, and at the same time a Group can be part of more than one VDC.

In practical terms, this means that once you organize your Users into Groups, and then your physical resources into VDCs, you can easily assign more or less resources to those Groups.

Using the previous scenario as an example, the Cloud Admin can add the Group Web Development to the VDCs RED and GREEN if their workload increases, and then remove it again a few days later.

Create Super-Clusters
--------------------------------------------------------------------------------

A VDC can have more than one physical resource of each type (Cluster, Hosts, VNets, Datastores), and a physical resource can be in more than one VDC. In contrast a Host can be part of only one Cluster. This means that you can decide to create a VDC that encompasses resources that may not be part of the same physical Cluster.

For example, a VDC called 'high-performance' may contain Hosts from two incompatible Clusters, let's say 'kvm-ceph' and 'kvm-qcow2'. These Hosts may be part of the same VDC, but from the deployment point of view, the important factor is their Cluster. The scheduler will decide the deployment target based on each Host's Cluster, and this guarantees that the VMs are always deployed in a compatible Host.

Partition a Cluster
--------------------------------------------------------------------------------

Since a VDC can contain individual Hosts, VNets and Datastores, you can use VDCs to partition a Cluster into "sub-clusters" that contain a few Hosts.

Following the previous example, you may have a big "kvm-ceph" Cluster. A VDC with one or two Hosts can be created to isolate a small portion of the Cluster. In this case, remember to add the necessary Datastores and VNets to the VDC, otherwise the Users won't be able to instantiate the VM Templates.

Share Physical Resources
--------------------------------------------------------------------------------

You may have two Groups with a similar workload, but want to keep their users and virtual resources isolated. In this case, both can be added to the same VDC. In a similar way, a physical resource (such as a host) can be part of two different VDCs.

The Groups will share the physical resources, but without being aware of it. If the physical resources are not exclusively assigned to a Group, you may want to set :ref:`usage quotas <quota_auth>`.

Managing VDCs in Sunstone
================================================================================

All the described functionality is available graphically using :ref:`Sunstone <sunstone>`:

|qs_vdc13|

.. |VDC Organization| image:: /images/vdc_organization.png
.. |qs_vdc13| image:: /images/qs_vdc13.png
   :width: 100 %
