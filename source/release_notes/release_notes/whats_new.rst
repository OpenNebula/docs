.. _whats_new:

=================
What's New in 4.8
=================

OpenNebula 4.8 Lemon Slice brings significant improvements in different aspects. Sticking with our vision of bringing simplicity to cloud management, this release comes with improvements in the recently added Cloud View portal, designed for end users. One significant advantage of the new portal is the ability to control flows, groups of interconnected Virtual Machines that conform a service. Based on this Cloud View, a Virtual Datacenter administrators view has been included (VDCAdmin View), which enables VDC admins to easily manage the VDC users and resources.

|vdcadminview48|

An important highlight in this release is a vast improvement to the hybrid model. Support for two new public cloud providers have been added, widening the range of possibilities to offload VMs in case the local infrastructure is saturated. The hybrid model in OpenNebula enables a centralized management of both local and remote resources for the cloud administrator, and a transparent consumption of these resources for the end user. With these two new additions, namely support for Microsoft Azure and IBM SoftLayer, OpenNebula is increasing the possibilities to build powerful, robust, cost and performance efficient cloud infrastructures across administrative domains and public cloud providers.

The OneFlow component also has been improved, specially OneGate, easying the retrieval of metrics to be used in the service elasticity. Flows are now easier than ever to build and consume, since details like the virtual network the flow is going to use is defined later by the user, so the administrator doesn't have to deal with all the possible combinations. We are proud of OneFlow, we believe it is powerful and it can suit most of the services needs, so check it out!

Moreover, Virtual Networks underwent a thorough redesign. Definition of virtual networks are not longer restricted to the fixed and ranged model, but rather they can include any combination of ranges to accommodate any address distribution. Moreover, now it is possible to reserve a range of IP addresses. This was done as usual trying to maintain as much compatibility with older versions of OpenNebula as possible, so the migration path stays smooth.

Finally, several improvements are scattered across every other OpenNebula component: improvements in quotas management, multi boot available through Sunstone, availability of Windows contextualization packages, new raw device mapping datastore, better Ceph drivers, possiblity to clone images across datastores .... ladies and gentlemen, you are in for a treat.

As usual OpenNebula releases are named after a Nebula. The  `Lemon Slice nebula (IC 3568) <http://en.wikipedia.org/wiki/Lemon_slice_nebula>`__ is a planetary nebula that is 1.3 kiloparsecs (4500 ly) away from Earth in the constellation of Camelopardalis. It is a relatively young nebula and has a core diameter of only about 0.4 light years.

In the following list you can check the highlights of OpenNebula 4.8. (`a detailed list of changes can be found here
<http://dev.opennebula.org/projects/opennebula/issues?query_id=55>`__):

OpenNebula Core :: Virtual Networks
-----------------------------------

Virtual Networks have undergone an important upgrade in 4.8. The network definition is not longer tied to the traditional FIXED/RANGED model anymore:

- **New virtual network model**,  virtual networks can now include any combination of ranges to accommodate any address distribution. The :ref:`new network model <vgg_vn_model>` has been implemented through the address range (AR) abstraction, that decouples the physical implementation of the network (vlan id, bridges or driver), from the logical address map, its map and the associated context variables. The new VNETs preserve the original interface in terms of contextualization, address hold, addition and removal of addresses from the network or usage.

- **New Address Range concept**, the :ref:`new ARs <vgg_vn_ar>` define the address type being it IPv4, IPv6, dual stack IPv4 - IPv6, or just MAC addresses; this allow you to control the type of address of the network you want to generate and makes it representation more accurate in OpenNebula when an external DHCP service is providing the IP addresses. Address ranges can even overwrite some of the network configuration or context attributes to implement complex use cases that logically groups multiple networks under the same VNET.

- **Address Reservation**, a powerful reservation mechanism has been developed on top of the new VNET and ARs. Users can :ref:`reserve a subset of the address space <vgg_vn_reservations>`; this reservation is placed in a new VNET owned by the user so it can be consumed in the same way of a regular VNET.

- **Network defaults**, you can now define a :ref:`NIC_DEFAULT attribute <nic_default_template>` with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL = "virtio"``.

- **Securing your cloud**, ARP Cache poisoning prevention can be globally disabled in Open vSwitch: :ref:`arp_cache_poisoning <openvswitch_arp_cache_poisoning>`.

- **Specify default gateway for multiple NICs**, now the network gateway can be :ref:`defined separately for each NIC <cong_user_template>`.

OpenNebula Core :: Usage Quotas
--------------------------------------------------------------------------------

Quotas are easier to set than ever:

- **Limiting quotas**, now you can set a quota of '0' to completely disallow resource usage. Read the :ref:`Quota Management documentation <quota_auth>` for more information.

OpenNebula Core :: Federation
--------------------------------------------------------------------------------

Different instances of OpenNebula 4.8 can be easily federated:

- **Better management**, to ease federation management admins usually adopts a centralized syslog service. Each :ref:`log entry is now labeled with its Zone <log_debug_configure_the_logging_system>` ID to identify the originating Zone of the log message.

.. |sunstone_multi_boot| image:: /images/sunstone_multi_boot.png
.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_instantiate_hold| image:: /images/sunstone_instantiate_hold.png
.. |vdcadminview48| image:: /images/vdcadminview-48.png

OpenNebula Drivers :: Images and Storage
--------------------------------------------------------------------------------

The storage drivers in OpenNebula are always evolving:

- **Raw device mapping datastore**, OpenNebula 4.8 includes a :ref:`new datastore type to support raw device mapping <dev_ds>`. The new datastore allows your VMs to access raw physical storage devices exposed to the hosts. Together with the datastore a new set of transfer manager drivers has been developed to map the devices to the VM disk files.

- **Cloning to a different datastore**, images can now be :ref:`cloned to a different Datastore <img_guide>`. The only restriction is that the new Datastore must be compatible with the current one, i.e. have the same DS_MAD drivers.

- **Better Ceph drivers**, :ref:`these drivers have been also improved <ceph_ds>` in this release, support for RBD format 2 has been included and the use of qemu-img user land tools has been removed to relay only in the rbd tool set. Also CRDOM management in Ceph pools has been added.

- **Better IO control**, disk IO bandwidth can be :ref:`controlled in KVM using the parameters <template_volatile_disks_section>` ``TOTAL_BYTES_SEC``, ``READ_BYTES_SEC``, ``WRITE_BYTES_SEC``, ``TOTAL_IOPS_SEC``, ``READ_IOPS_SEC`` and ``WRITE_IOPS_SEC``. These parameters can be set to a default value in the ``KVM`` driver configuration or per disk in the VM template. By default these parameters can only be set by administrators belonging to ``oneadmin`` group.

Hybrid Clouds
--------------------------------------------------------------------------------

Support for two new public cloud provider has been added. This opens the possiblity to create templates with representations for VM specified in both local infrastructure, Amazon EC2, Microsoft Azure and IBM SoftLayer:

- **New driver for Microsoft Azure**, support added to outsource Virtual Machines to :ref:`Microsoft Azure cloud provider <azg>`.
- **New driver for IBM SoftLayer**, support added to outsource Virtual Machines to :ref:`IBM SoftLayer cloud provider <slg>`.

OneFlow
--------------------------------------------------------------------------------

General improvement in the OneFlow and OneGate components:

- **Dynamic information sharing**, using the OneGate component users can now request information about the service dynamically allowing therefore to pass information accross nodes in the service. Read the :ref:`OneGate <onegate_usage>` guide for more details.

- **Controlled deployment**, OneFlow can be configured to wait until a VM contacts OneGate to set it running state. This prevents deploying child roles before the nodes of the parent roles haven't completely booted up. Read more about :ref:`Running State <appflow_use_cli_running_state>`.

- **Improved network management**, network configuration can be defined for a service template. The number of network interfaces that will be used are :ref:`defined for a service <appflow_use_cli_networks>` and then each :ref:`role selects what interfaces will use <cloud_view_select_network>`. The network that is attached to each interface is defined by the user when the service template is instantiated.

Virtual Machine Templates
--------------------------------------------------------------------------------

Regarding Virtual Machine templates there has been significant improvements in its usability:

- **Default parameters**, you can now :ref:`define a NIC_DEFAULT attribute <nic_default_template>` with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL``, that final users may not be aware of.

.. code::

    NIC_DEFAULT = [ MODEL = "virtio" ]

- **User inputs**, you can define :ref:`user inputs for a given template <template_user_inputs>`. These attributes are provided by the user when the template is instantiated. For example you can define MYSQL_PASSWORD and each user can define a custom value for this variable for the new Virtual Machine. This feature is available through Sunstone and the CLI.

.. code::

    USER_INPUTS=[
      ROOT_PASSWORD="M|password|Password for the root user"
      ROOT_MSG="M|text|Text for the message” ]

Sunstone
--------------------------------------------------------------------------------

Sunstone, the portal to your OpenNebula cloud, has been improved to support flexible provisioning models:

- **VDCAdmin view**, a :ref:`new view based on the brand new cloud view <vdc_admin_view>` is available. VDC admin will be able to create new users and manage the resources of the VDC.

- **OneFlow easier to use**, OpenNebula Flow has been :ref:`integrated in the cloud and vdcadmin views <cloud_view_services>`, now users can instantiate new services and monitor groups of Virtual Machines.

- **Better views management**, in 4.6 you could select the available :ref:`sunstone views <suns_views>` for new groups. In case you have more than one, you can now also select the default view.

|sunstone_group_defview|

- **Instantiate on hold**, although templates could be `instantiated on hold </doc/4.8/cli/onevm.1.html>`__ before from the CLI, now you can also do that from Sunstone:

|sunstone_instantiate_hold|

- **Multi boot support**, although :ref:`this could be done via CLI <template_os_and_boot_options_section>`, now you can set multi boot options also in the Template wizard.

|sunstone_multi_boot|

- **Extended view configuration**, the table columns defined in the view.yaml file now apply not only to the main tab, but also to other places where the resources are used. You can see an example in the :ref:`Sunstone views documentation <suns_views_define_new>`.

- **Better view fine tuning**, The Virtual Network table has a new column that can be enabled in the :ref:`Sunstone view.yaml files <suns_views>`: VLAN ID.

- **Improved search**, now it is possible searching by any attribute in the users template in the :ref:`Sunstone Users dialog <manage_users_sunstone>`.

- :ref:`Accounting information <accounting_sunstone>` is now available in Sunstone.

Contextualization
-------------------------------------

Virtual Machine contextualization now supports more guest OS:

- **Windows guests contextualization**, now supported to several different windows flavours. The process of provisioning and contextualizing a Windows guest context is described :ref:`here <windows_context>`.

- **New Context repository**, `context packages moved to addon repositories <https://github.com/OpenNebula/addon-context-linux>`__ to ease the incorporation from linux distros
