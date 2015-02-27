.. _whats_new:

=======================
What's New in 4.12 Beta
=======================

OpenNebula 4.12 Beta (Cotton Candy) ships with several improvements in different subsystems and components. For the first time, OpenNebula will be able to generate cost reports that can be integrated with chargeback and billing platforms, and also presented to both the administrators and the end users. Each VM Template defined by the Cloud administrator can define a cost per cpu and per memory per hour.

.. image:: /images/vdcadmin_vdc_showback.png
    :width: 80%
    :scale: 80%
    :align: center

Starting with Cotton Candy, Virtual Datacenters are a new kind of OpenNebula resource with its own ID, name, etc. and the term Resource Provider disappears. Making VDCs a separate resource has several advantages over the previous Group/VDC concept, since they can have one or more Groups added to them. This gives the Cloud Admin greater resource assignment flexibility.

In addition to the well known VNC support in Sunstone, OpenNebula 4.12 will include support to interact with Virtual Machines using the SPICE protocol. This feature can be enabled for any Virtual Machine just checking the option in the input/output section of the Template creation form.

Networking has been vastly improved in 4.12, with the addition of Security Groups, allowing administrators to define the firewall rules and apply them to the Virtual Machines. Also, Virtual Extensible LAN (VXLAN) is a network virtualization technology aimed to solve large cloud deployments problems, encapsulating Ethernet frames within UDP packets, and thus solving the 4096 VLAN limit problem. Cotton Candy is fully capable of managing VXLANs using the linux kernel integration.

Important new features related to the newly introduced vCenter support are available in OpenNebula 4.12: the ability to import running VMs and networks, including the attach/detach NIC functionality, a new cloud view tailored for vCenter, VM contextualization support and reacquire VM Templates with their logo and description.

Finally, several improvements are scattered across every other OpenNebula component: the possibility to flush and disable a system datastore, improvements in Sunstone for better user workflow, and many other bugfixes that stabilized features introduced in Fox Fur.

As usual OpenNebula releases are named after a Nebula. The `Cotton Candy Nebula (IRAS 17150-3224) <http://en.wikipedia.org/wiki/Cotton_Candy_Nebula>`__ is located in the constellation of Ara.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, and send a more than welcomed feedback for the final release.

In the following list you can check the highlights of OpenNebula 4.12. (`a detailed list of changes can be found here
<http://dev.opennebula.org/projects/opennebula/issues?query_id=64>`__):

OpenNebula Core
---------------

New features are:

- **Showback support**, the core maintains the cost schema defined as **cost per cpu per hour**, and **cost per memory MB per hour** in order to provide :ref:`showback functionality <showback>`.
- **Datastore maintenance feature**, the :ref:`system datastore can now be disabled <disable_system_ds>` so OpenNebula won't schedule VMs in it.

Virtual Network improvements include:

- **Leases visibility**, users with manage rights on a :ref:`network and address ranges <nm>` should see leases on HOLD.

VDC management improvements also in the core:

- **VDC are now first class citizens**, with a :ref:`VDC core pool <manage_vdcs>` and their own ID.
- **Management of groups administrators** using the group template, to be able to add and remove :ref:`group administrators <manage_groups_permissions>` dynamically.


OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

Several improvements in the vCenter drivers:

- **Running VMs support** , ability to import :ref:`that allows to automatically import an existing infrastructure <vcenterg>`
- **Reacquire VM templates**, after the :ref:`vCenter host has been created <reacquire_vcenter_resources>`, with their logo and description.

OpenNebula Drivers :: Networking
--------------------------------------------------------------------------------

Important new features in Networking, including:

- **Ability to define Security Groups** to :ref:`define access to Virtual Machines <security_groups>` (inbound and outbound)

- **Enable Network isolation provided through the VXLAN**, create a :ref:`bridge for each OpenNebula Virtual Network and attach a VXLAN tagged network interface to the bridge <vxlan>`

Improvements specific to vCenter networking:

- **Manage vCenter networks**, including the ability to :ref:`import them <import_vcenter_resources>` as well as distributed vSwitches.
- **Attach/detach NIC** to :ref:`running Virtual Machines <virtual_network_vcenter_usage>` in vCenter


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

As usual, storage drivers were improved for the different supported backends:

- **Better Ceph support**, :ref:`ceph drivers <ceph_ds>` now come with the ability to use the CEPH "MAX AVAIL" attribute.
- **Support for BRIDGE_LIST**, in :ref:`fs/share and fs/ssh drivers <fs_ds>`.

Sunstone
--------------------------------------------------------------------------------

Sunstone is the all encompasing access to OpenNebula, so it reflects all the improvements and some of its own:

- **Support for SPICE protocol**, access your :ref:`VMs through the powerful remote access protocol <remote_access_sunstone>`, as well as using VNC.
- **Cloud vCenter View**, tailored to :ref:`provision resources to end user from vCenter based infrastructures <vcenter_cloud_view>`.
- **Improvements in networking informatoin**, for :ref:`hybrid <introh>` and :ref:`vcenter <vcenterg>` based VMs.
- **Support for VXLAN**, in the :ref:`network tab <vxlan>`.
- **Support for Showback** capabilities, for :ref:`both users and cloud administrators <showback>`.
- **Search for any attribute in the VM template**, useful to searh for organization specific attributes. 
- **Proxy capabilities** for the :ref:`commercial support integration with Zendesk <commercial_support_sunstone>`. (TODO documentation?)


Contextualization
-------------------------------------

Contextualizatoin improvements are related to the vCenter support:

- **vCenter VM contextualization support**, with the ability to :ref:`contextualize both windows and linux VMs <vm_template_definition_vcenter>`


