.. _whats_new:

============================
What's New in OpenNebula 4.6
============================

OpenNebula 4.6 introduces the possibility of managing Virtual Data Centers natively, via Sunstone and the CLI. The new OpenNebula Zones component, which is tightly integrated with the rest of the OpenNebula components, makes it very easy to federate OpenNebula deployments. Federated environments share the same users, groups and acls, while maintaining the other resources locally.Virtual Data Centers, VDCs, have been also greatly improved, both in multi-tenant deployments and in stand-alone OpenNebula installations.

The Sunstone graphical interface has been completely redesigned, making a very strong emphasis on simplifying the interface and delivering a more intuitive experience. The dialogs have been reworked in order to help the user workflows. It also supports federated environments natively and allows users to switch to another OpenNebula Zone from within Sunstone. It has also been improved in order to natively support the new Marketplace version, which provides the possibility of creating multi-disk virtual machines.

In the following list you can check the highlights of OpenNebula 4.6 Carina organised by component (`a detailed list of changes can be found here <http://dev.opennebula.org/projects/opennebula/issues?query_id=50>`__):

OpenNebula Core: End-user functionality
---------------------------------------

There has been several improvements for end-users:

-  **Add --list and --describe optiosn to oneacct**, see `oneacct <http://opennebula.org/doc/4.6/cli/oneacct.1.html>`__.
-  **Network parameters can now be changed**, by updating the template. This includes ``VLAN_ID``, ``BRIDGE``, ``VLAN`` and ``PHYDEV``. See the :ref:`Managing Virtual Networks <vgg>` guide for more information.
-  **Templates for GROUP resources** TODO: documentation?
-  **Allow to change the base_path for existing Datastores** TODO: documentation?
-  **Disable the XML-RPC log**, see the :ref:`ONED Configuration <oned_conf>` for more information.
-  **Support for limiting the Resources Exposed by a Host**, see :ref:`Scheduler <schg>` for more information.
-  **Support for an http proxy in the Ruby OCA client**, which can be passed as an option.
See the `Ruby API Documentation <http://docs.opennebula.org/doc/4.6/oca/ruby/OpenNebula/Client.html>`



OpenNebula Core: Internals & Administration Interface
-----------------------------------------------------

There has been several improvements for administrators and new features to enhance the robustness and scalability of OpenNebula core:

-  **Remove limitations for Datastores 0,1  and 2**, which can now be treated like any other datastore.
-  **Support for pool pagination**, which makes OpenNebula interfaces such as the CLI and Sunstone more responsive and improves scalability. See the :ref:`Scalability <one_scalability>` guide for more information.
-  **Optimized DB upgrade script**. It is one order of magnitude faster than with previous versions.
-  **Limit the XML-RPC message size**, see :ref:`Scheduler <schg>` for more information.

OpenNebula Drivers
------------------

The back-end of OpenNebula has been also improved in several areas, as described below:

Storage Drivers
~~~~~~~~~~~~~~~

-  **Support for Ceph RBD format 2**, more info :ref:`here <ceph_ds>`.
-  **Gluster support using libgfapi**, more info :ref:`here <gluster_ds>`.

Virtualization Drivers
~~~~~~~~~~~~~~~~~~~~~~

-  **KVM Hypervisor improvements** like tweakable SPICE parameters, KVM Hyper-V Enhancements, ``LOCALTIME``and ``MACHINE`` parameters support , see the :ref:`Template <template>` guide for more information.
-  **Support for Xen FEATURES parameters**, which includes options like ``PAE``, ``ACPI``, ``APIC``, etc. See the :ref:`Template <template>` guide for more information.

Sunstone
--------


OneFlow
-------

-  **Configurable setting to render names assigned to VMs**, being able to use placeholders like ``SERVICE_ID`` and ``SERVICE_NAME``, see the :ref:`OneFlow Server Configuration <appflow_configure>` guide for more information.

OpenNebula vDCs and Zones
-------------------------

