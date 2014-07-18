.. _whats_new:

=================
What's New in 4.8
=================

.. todo:: intro

In the following list you can check the highlights of OpenNebula 4.8 .. todo:: Carina
organised by component (`a detailed list of changes can be found here
<http://dev.opennebula.org/projects/opennebula/issues?query_id=55>`__):

.. todo:: link to redmine release 4.8 is missing the tickets planned for 4.8 beta


Hybrid Clouds
--------------------------------------------------------------------------------

Support for two new public cloud provider has been added. This opens the possiblity to create templates with representations for VM specified in both local infrastructure, Amazon EC2, Microsoft Azure and IBM SoftLayer:

- Support added to outsource Virtual Machine to :ref:`Microsoft Azure cloud provider <azg>`
- Support added to outsource Virtual Machine to :ref:`IBM SoftLayer cloud provider <slg>`

OneFlow
--------------------------------------------------------------------------------

.. todo:: #2917 Pass information between roles, using onegate facilities

- Network configuration can be defined for a service template. The number of network interfaces that will be used are defined for a service and then each role selects what interfaces will use. The network that is attached to each interface is defined by the user when the service template is instantiated.

Virtual Machine Templates
--------------------------------------------------------------------------------

- You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL``, that final users may not be aware of.

.. code::

    NIC_DEFAULT = [ MODEL = "virtio" ]

- Sunstone now supports multiple boot devices. Although this could be done via CLI, now you can set them also in the Template wizard.

|sunstone_multi_boot|

- You can define user inputs for a given template. These attributes are provided by the user when the template is instantiated. For example you can define MYSQL_PASSWORD and each user can define a custom value for this variable for the new Virtual Machine. This feature is not available using the CLI.

.. code::

    USER_INPUTS=[
      ROOT_PASSWORD="M|password|Password for the root user"
      ROOT_MSG="M|text|Text for the message” ]

Sunstone
--------------------------------------------------------------------------------

- In 4.6 you could select the available :ref:`sunstone views <suns_views>` for new groups. In case you have more than one, you can now also select the default view.

|sunstone_group_defview|

- Although templates could be instantiated on hold before from the CLI, now you can also do that from Sunstone:

|sunstone_instantiate_hold|

- Sunstone now supports multiple boot devices. Although this could be done via CLI, now you can set them also in the Template wizard.

|sunstone_multi_boot|

- The table columns defined in the view.yaml file now apply not only to the main tab, but also to other places where the resources are used. You can see an example in the :ref:`Sunstone views documentation <suns_views_define_new>`.

- The Virtual Network table has a new column that can be enabled in the :ref:`Sunstone view.yaml files <suns_views>`: VLAN ID

- A new vdcadmin view based on the brand new cloud view is available. vDC admin will be able to create new users and manage the resources of the vDC

- OpenNebula Flow has been integrated in the cloud and vdcadmin views, now users can instantiate new services and monitor groups of Virtual Machines

Virtual Networks
-------------------------------------

- Virtual Networks have undergone and important upgrade in 4.8. The network definition is not longer tied to the traditional FIXED/RANGED model anymore. Networks can now include any combination of ranges to accommodate any address distribution. The new model has been implemented through the address range (AR) abstraction, that decouples the physical implementation of the network (vlan id, bridges or driver), from the logical address map, its map and the associated context variables.

The new ARs define the address type being it IPv4, IPv6, dual stack IPv4 - IPv6, or just MAC addresses; this allow you to control the type of address of the network you want to generate and makes it representation more accurate in OpenNebula when an external DHCP service is providing the IP addresses. Address ranges can even overwrite some of the network configuration or context attributes to implement complex use cases that logically groups multiple networks under the same VNET.

Also a powerful reservation mechanism has been developed on top of the new VNET and ARs. Users can reserve a subset of the address space; this reservation is placed in a new VNET owned by the user so it can be consumed in the same way of a regular VNET.

The new VNETs preserve the original interface in terms of contextualization, address hold, addition and removal of addresses from the network or usage.

- You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL = "virtio"``.

.. todo:: #2927 specify which default gateway to use if there are multiple nics

.. todo:: #2318 Block ARP cache poisoning in openvswitch


Contextualization
-------------------------------------

- .. todo:: #3008 Move context packages to addon repositories

- Windows guests contextualization is now supported to several different windows flavours. The process of provisioning and contextualizing a Windows guestwindows guest context is described :ref:`here <windows_context>`.

Usage Quotas
--------------------------------------------------------------------------------

- Now you can set a quota of '0' to completely disallow resource usage. Read the :ref:`Quota Management documentation <quota_auth>` for more information.

Images and Storage
--------------------------------------------------------------------------------

- OpenNebula 4.8 includes a new datastore type to support raw device mapping. The new datastore allows your VMs to access raw physical storage devices exposed to the hosts. Together with the datastore a new set of transfer manager drivers has been developed to map the devices to the VM disk files.

- Images can now be :ref:`cloned to a different Datastore <img_guide>`. The only restriction is that the new Datastore must be compatible with the current one, i.e. have the same DS_MAD drivers.

- Ceph drivers have been also improved in this release, support for RBD format 2 has been included and the use of qemu-img user land tools has been removed to relay only in the rbd tool set. Also CRDOM management in Ceph pools has been added.

- Disk IO bandwidth can be controlled in KVM using the parameters ``TOTAL_BYTES_SEC``, ``READ_BYTES_SEC``, ``WRITE_BYTES_SEC``, ``TOTAL_IOPS_SEC``, ``READ_IOPS_SEC`` and ``WRITE_IOPS_SEC``. These parameters can be set to a default value in the ``KVM`` driver configuration or per disk in the VM template. By default these parameters can only be set by ``oneadmin`` the administrators.

Public Clouds APIs
--------------------------------------------------------------------------------

The OCCI server is no longer part of the distribution and now resides in an addon repository. If you are searching for an OCCI server you'd better use the `rOCCI Server <http://gwdg.github.io/rOCCI-server/>`_.

.. todo:: add OCCI addon repo URL

Packaging
--------------------------------------------------------------------------------
.. todo:: #2429 Compatibility with heartbeat


Federation
--------------------------------------------------------------------------------

To ease federation management admins usually adopts a centralized syslog service. Each log entry is now labeled with its Zone ID to identify the originating Zone of the log message.

.. |sunstone_multi_boot| image:: /images/sunstone_multi_boot.png
.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_instantiate_hold| image:: /images/sunstone_instantiate_hold.png
