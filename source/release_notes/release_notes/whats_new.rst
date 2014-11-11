.. _whats_new:

==================
What's New in 4.10
==================

OpenNebula 4.10 (Fox Fur) ships with several improvements in different subsystems and components. But, more importantly, it features a little revolution in shape of vCenter support. 

This is the first OpenNebula release that allows to automatically import an existing infrastructure, since the new vCenter drivers allow to import Clusters and Virtual Machines from a vCenter installation, significantly smoothing the set up curve. The concept of the vCenter drivers is akin to the hybrid cloud approach in the sense that OpenNebula will delegate a number of aspects to vCenter, instead of pursuing the management of almost every aspect as it traditionally does with the three supported hypervisors: XEN, KVM and VMware ESX. OpenNebula will use pre defined Virtual Machine Templates existing in the vCenter set up to launch Virtual Machines, very much like it does in its hybrid drivers to access Amazon EC2, IBM SoftLayer and Microsoft Azure, although offering extra features like for instance VNC support and more lifecycle actions.

.. image:: /images/vcenter_create.png
    :width: 80%
    :scale: 80%
    :align: center

A refinement has been performed in the OpenNebula networking system, extended in the previous release in order to allow a flexible management of IP leases, decoupling the host-hypervisor configuration attributes (e.g. BRIDGE, PHYDEV or VLAN_ID) with the IP/L3 configuration attributes. In this refinement, end users are allowed to update their VNET reservations and also the address range of their reservations, so they can introduce attributes to be passed along their VMs through contextualization, customizing their VMs network settings in this manner.

We are aware that in production environments, access to professional, efficient support is a must, and this is why we have introduced an :ref:`integrated tab in Sunstone to access OpenNebula Systems (the company behind OpenNebula, formerly C12G)  professional support <commercial_support_sunstone>`. In this way, support tickets management can be performed through Sunstone, avoiding disruption of work and enhancing productivity.

Finally, several improvements are scattered across every other OpenNebula component: improvements in the hybrid drivers, including better Sunstone support, improved auth mechanisms (login token functionality), a solution for the spurious Poweroff state, and many other bugfixes that stabilized features introduced in Lemon Slice. 

As usual OpenNebula releases are named after a Nebula. The `Fox Fur Nebula (IC 3568) <http://en.wikipedia.org/wiki/Fox_Fur_Nebula>`__ is located in Monoceros and included in the NGC 2264 Region.

Want to take OpenNebula 4.10 for a test drive? Use one of the `SandBoxes <http://opennebula.org/tryout/>`__ to try out OpenNebula in no time, or proceed to the :ref:`Quick Start guides <qs_guides>`.

In the following list you can check the highlights of OpenNebula 4.10. (`a detailed list of changes can be found here
<http://dev.opennebula.org/projects/opennebula/issues?query_id=59>`__):

OpenNebula Core
---------------

- **Login token functionality**, a requested security update was made to OpenNebula implementing :ref:`login token <manage_users_managing_users>` functionality to password based logins. Storing passwords in the .one_auth file is less than ideal from a security standpoint. This is especially true with ldap/AD when that password may be used across the company for email and other password protected services.

Virtual Network improvements include:

- **Leases and reservation visibility** now is subject to :ref:`ACL filters <manage_acl>`.

- **Improvements in the CLI and vnet updates**, with a easier to use `onevnet command </doc/4.10/cli/onevnet.1.html>`__, displaying more information about leases. Moeover, users being able to now update their own leases and reservations.

- **Different BRIDGE according to vnet driver**, allows for a more heterogenous network support, mixing clusters with different :ref:`network bridge names <openvswitch_different_bridge>`.

Several improvements in the Virtual Machine lifecycle and operations:

- **Clean state recreate operation**, now it doesn't take into account previous states so a clean start is guaranteed using `onevm delete --recreate </doc/4.10/cli/onevm.1.html>`__.

- **VM Disaster Recovery without resubmit of harddisk images**, this avoids losing volatile disks on host crash for instance (provided there is shared storage between the virtualization hosts). See the :ref:`HA guide <ftguide>` for more details.

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

- **vCenter support** :ref:`that allows to automatically import an existing infrastructure <vcenterg>` 

OpenNebula Drivers :: Authorization
--------------------------------------------------------------------------------

- **Group support for ldap/AD auth driver**, it is now possible to automatically input new :ref:`ldap/AD users into predefined OpenNebula groups <ldap_group_mapping>`.

OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

As usual, storage drivers were improved for the different supported backends:

- **Better Ceph support**, :ref:`ceph drivers <ceph_ds>` now come with the ability to set CEPH_USER attribute.

Sunstone
--------------------------------------------------------------------------------

Sunstone, the portal to your OpenNebula cloud, has been improved with usablity features and, more importantly, vCenter support as well as smoothering the hybrid support for external public provider like Amaon EC2, Microsoft Azure and IBM SoftLayer:

- **vCenter support**, integrating the :ref:`vCenter infrastructure automatic import tool <vcenter_import_tool>`, and awareness of the presence of ESX hosts behind vCenter.

.. image:: /images/host_esx.png
    :width: 90%
    :align: center

- **More resilient image upload**, now with the possiblity of resuming a broken :ref:`image upload <sunstone_upload_images>`.

- **Ability to build templates with several hybrid representations**, allowing for multiple PUBLIC_CLOUD definitions in the same template for :ref:`hybrid clouds <introh>`.

- **Better hybrid support**: now the VM update template dialog in Sunstone takes :ref:`hybrid <introh>` templates into account, as well as support for hybrid drivers at the time of adding hybrid hosts to the OpenNebula infrastructure:

.. image:: /images/hybrid_vm_template_create.png
    :width: 90%
    :align: center

- **Updated JavaScript libraries**, to ensure the latest security and display fixes.

- **Proffesional Support** from within Sunstone is now possible thanks to the newly introduced :ref:`Zendesk integration <commercial_support_sunstone>`.

OneFlow
--------------------------------------------------------------------------------

- **Improved service template wizard**, now allowing for RAW template editing, previously only available through the :ref:`command line interface <appflow_use_cli>`.

Contextualization
-------------------------------------

- **Better placement for context CDROM**, avoiding clashes with user added CDROM drivers. More information about context :ref:`here <context_overview>`.

Command Line Interface
-------------------------------------

- **Improve SSL support**, allow  client to disable SSL peer certificate verification as well as to provide a certification location through config or environment variable.
