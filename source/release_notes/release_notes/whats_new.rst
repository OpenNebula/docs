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

.. todo:: #2989 Integrate with Microsoft Azure API

.. todo:: #2959 Integrate with SoftLayer

OneFlow
--------------------------------------------------------------------------------

.. todo:: #2917 Pass information between roles, using onegate facilities


Sunstone
--------------------------------------------------------------------------------

.. todo:: New vdcadmin view
.. todo:: New flow integration in cloud views
.. todo:: #2977 Customize available actions in cloud/admin views

Virtual Networks
-------------------------------------

- Virtual Networks have undergone and important upgrade in 4.8. The network definition is not longer tied to the traditional FIXED/RANGED model anymore. Networks can now include any combination of ranges to accommodate any address distribution. The new model has been implemented through the address range (AR) abstraction, that decouples the physical implementation of the network (vlan id, bridges or driver), from the logical address map, its map and the associated context variables.

The new ARs define the address type being it IPv4, IPv6, dual stack IPv4 - IPv6, or just MAC addresses; this allow you to control the type of address of the network you want to generate and makes it representation more accurate in OpenNebula when an external DHCP service is providing the IP addresses. Address ranges can even overwrite some of the network configuration or context attributes to implement complex use cases that logically groups multiple networks under the same VNET.

Also a powerful reservation mechanism has been developed on top of the new VNET and ARs. Users can reserve a subset of the address space; this reservation is placed in a new VNET owned by the user so it can be consumed in the same way of a regular VNET.

The new VNETs preserve the original interface in terms of contextualization, address hold, addition and removal of addresses from the network or usage.

- You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL = "virtio``.

.. todo:: #2927 specify which default gateway to use if there are multiple nics

.. todo:: #2318 Block ARP cache poisoning in openvswitch


Contextualization
-------------------------------------

- .. todo:: #3008 Move context packages to addon repositories
- .. todo:: #2395 windows guest context

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
