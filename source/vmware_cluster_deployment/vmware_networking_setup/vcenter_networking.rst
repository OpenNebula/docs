.. _vcenter_networking_setup:
.. _virtual_network_vcenter_usage:

vCenter Networking
================================================================================

vCenter virtual networks can be represented as OpenNebula virtual networks, where a one-to-one relationship exists between an OpenNebula's virtual network and a vSphere's port group. When :ref:`adding NICs in a VM template <vm_templates>` or :ref:`when attaching a NIC (hot-plugging) to a running VM <vm_instances>` in OpenNebula, a network interface can be attached to an OpenNebula's Virtual Machine that is connected to a particular vCenter virtual network.

OpenNebula can consume port groups or create port groups.

In vSphere's terminology, a port group can be seen as a template to create virtual ports with particular sets of specifications such as VLAN tagging. The VM's network interfaces connect to vSphere's virtual switches through port groups. vSphere provides two types of port groups:

- Port Group (or Standard Port Group). The port group is connected to a vSphere Standard Switch.
- Distributed Port Group. The port group is connected to a vSphere Distributed Switch.

According to `VMWare's vSphere Networking Guide <https://pubs.vmware.com/vsphere-60/topic/com.vmware.ICbase/PDF/vsphere-esxi-vcenter-server-60-networking-guide.pdf>`_ we have two virtual switches types:

- vSphere Standard Switch. It works much like a physical Ethernet switch. A vSphere standard switch can be connected to physical switches by using physical Ethernet adapters, also referred to as uplink adapters, to join virtual networks with physical networks. You create and configure the virtual standard switch on each ESXi host where you want that virtual switch to be available.
- vSphere Distributed Switch. It acts as a single switch across all associated hosts in a datacenter to provide centralized provisioning, administration, and monitoring of virtual networks. You configure a vSphere distributed switch on the vCenter Server system and the configuration is populated across all hosts that are associated with the switch. This lets virtual machines to maintain consistent network configuration as they migrate across multiple hosts.

If you want to associate OpenNebula's virtual networks to vSphere's port groups you have two choices:

- You can create the port groups using vSphere's Web Client and then consume them using the import tools or,
- You can create port groups directly from OpenNebula using a virtual network definition, adding the attribute ``VN_MAD=vcenter`` to the network template and letting OpenNebula create the network elements for you.


Consuming existing vCenter port groups
--------------------------------------

Existing vCenter networks are represented in OpenNebula as virtual networks which BRIDGE attribute  matches the name of the Network (port group) defined in vCenter.

OpenNebula supports both "Port Groups" and "Distributed Port Groups", and as such can create or consume any vCenter defined network resource.

Networks can be created using vSphere's web client, with any specific configuration like for instance VLANs. OpenNebula will use these networks with the defined characteristics representing them as Virtual Networks. OpenNebula additionally can handle on top of these networks three types of :ref:`Address Ranges: Ethernet, IPv4 and IPv6 <manage_vnets>`.

vCenter VM Templates can define their own NICs, and OpenNebula will manage them and its information (IP, MAC, etc) is known by OpenNebula. Any NIC present in the OpenNebula VM Template, or added through the attach_nic operation, will be handled by OpenNebula, and as such it is subject to be detached.

You can easily consume vCenter networks using the import tools as explained in the :ref:`Importing vCenter Networks <vcenter_import_networks>` section.

.. _vcenter_enhanced_networking:

Creating Port Groups from OpenNebula
------------------------------------

OpenNebula can create a vCenter network from a virtual network template if the vCenter network driver is used.

This is the workflow when OpenNebula needs to create a vCenter network:

1. Create a new OpenNebula virtual network template. Add the :ref:`required attributes <vcenter_network_attributes>` to the template including the OpenNebula's host ID which represents the vCenter cluster where the network elements will be created.
2. When the virtual network is created, a hook will create the network elements required on each ESX host that are members of the specified vCenter cluster.
3. The virtual network will be automatically assigned to the OpenNebula cluster which includes the vCenter cluster represented as an OpenNebula host.
4. The hooks works asynchronously so you may have to refresh the Virtual Network information until you find the VCENTER_NET_STATE attribute. If it completes the actions successfully that attribute will be set to READY and hence you can use it from VMs and templates. If the hook fails VCENTER_NET_STATE will be set to ERROR and the VCENTER_NET_ERROR attribute will offer more information.

Hooks information
--------------------------------------------------------------------------------

As soon as the first vCenter cluster is created, two hooks are registered in OpenNebula to deal with network creation and deletion.

- vcenter_net_create
- vcenter_net_delete

These hooks are the scripts responsible of creating the vCenter network elements and deleting them when the OpenNebula Virtual Network template is deleted.

The creation hook performs the following actions for each ESX host found in the cluster assigned to the template if a standard port group has been chosen:

* If the port group does not exist, it will create it.
* If the port group or switch name exist, they won't be updated ignoring new attributes to protect you from unexpected changes that may break your connectivity.

The **creation** hook performs the following actions if a distributed port group has been chosen:

* OpenNebula creates the distributed switch if it doesn't exist. If the switch exists, it's not updated ignoring any attribute you've set.
* OpenNebula creates the distributed port group if it doesn't exist in the datacenter associated with the vCenter cluster. If the distributed port group already exists **it won't be updated** to protect you from unexpected changes.
* For each ESX host found in the cluster assigned to the template, it adds the ESX host to the distributed switch.

Creation hook is asynchronous which means that you'll have to check if the VCENTER_NET_STATE attribute has been set. Once the hook finishes you'll find the VCENTER_NET_STATE either with the READY value or the ERROR value. If an error was found you can check what was wrong.

The **removal** hook performs the following actions:

* OpenNebula contacts with the vCenter server.
* For each ESX host found in the vCenter cluster assigned to the template, it tries to remove both the port group and the switch. If the switch has no more port groups left then the switch will be removed too.

In this case the hook is also asynchronous. If you want to know if it suceeded or failed you can run the following command:

.. code::

    grep EXECUTE /var/log/one/oned.log | grep vcenter_net_delete

If the script failed, you can check the lines before EXECUTE FAILURE in the /var/log/one/oned.log to get more information on the failure. If the removal hook fails you may have to check your vCenter server and delete those resources that could not be deleted automatically.

.. warning:: If a port group or switch is in use e.g a VM is running and have a NIC attached to that port group the remove operation will fail so please ensure that you have no VMs or templates using that port group before trying to remove the Virtual Network representation.

Check the :ref:`vCenter driver guide <vcenter_hooks>` for more information on how to operate the vCenter virtual network hooks.

.. _vcenter_network_attributes:

vCenter Network attributes
--------------------------------------------------------------------------------

You can easily create a Virtual Network definition from Sunstone but you can also create a template and apply it with the ``onevnet`` command. Here's the table with the attributes that must be added inside a TEMPLATE section:

+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|      Attribute              | Type       | Mandatory                          |                                                                                                                                                                                                                                                                                                 Description                                                                                                                                                                                                                                                                                                          |
+=============================+============+====================================+======================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``VN_MAD``                  | string     | Yes                                | Must be set to ``vcenter``                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE``                  | string     | Yes                                | It's the port group name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PHYDEV``                  | string     | No                                 | If you want to assign uplinks to your switch you can specify the names of the physical network interface cards of your ESXi hosts that will be used. You can use several physical NIC names using a comma between them e.g vmnic0,vmnic1. Note that two switches cannot share the same physical nics and that you must be sure that the same physical interface name exists and it's available for every ESX host in the cluster. This attribute will be ignored if the switch already exists.                                                                                                                       |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_PORTGROUP_TYPE``  | string     | Yes                                | There are two possible values Port Group and Distributed Port Group. Port Group means a Standard Port Group                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_ONE_HOST_ID``     | integer    | Yes                                | The OpenNebula host id which represents the vCenter cluster where the nework will be created.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_SWITCH_NAME``     | string     | Yes                                | The name of the virtual switch where the port group will be created. If the vcenter switch already exists it won't update it to avoid accidental connectivity issues                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_SWITCH_NPORTS``   | integer    | No                                 | The number of ports assigned to a virtual standard switch or the number of uplink ports assigned to the Uplink port group in a Distributed Virtual Switch. This attribute will be ignored if the switch already exists.                                                                                                                                                                                                                                                                                                                                                                                              |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MTU``                     | integer    | No                                 | The maximum transmission unit setting for the virtual switch. This attribute will be ignored if the switch already exists.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VLAN_ID``                 | integer    | Yes (unless ``AUTOMATIC_VLAN_ID``) | The VLAN ID, will be generated if not defined and AUTOMATIC_VLAN_ID is set to YES                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``AUTOMATIC_VLAN_ID``       | boolean    | Yes (unless ``VLAN_ID``)           | Mandatory and must be set to YES if VLAN_ID hasn't been defined so OpenNebula created a VLAN ID automatically                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VCENTER_IMPORTED``        | boolean    | No                                 | This attribute is a protection mechanism to prevent accidental deletion with vcenter_vnet_delete hook                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
+-----------------------------+------------+------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Settings applied to virtual switches and port groups created by OpeNebula
---------------------------------------------------------------------------------

OpenNebula uses the following values when creating virtual switches and port groups in vCenter according to what the vSphere's Web Client uses in the same operations:

- VLAN ID is set to 0, which means that no VLANs are used.
- MTU value is set to 1500.

Standard port groups created by OpenNebula have the following settings:

- Number of ports is set to Elastic. According to VMWare's documentation, the Elastic mode is used to ensure efficient use of resources on ESXi hosts where the ports of virtual switches are dynamically scaled up and down. In any case, the default port number for standard switches is 128.
- Security - Promiscuous mode is set to Reject, which means that the virtual network adapter only receives frames that are meant for it.
- Security - MAC Address Changes is set to Accept, so the ESXi host accepts requests to change the effective MAC address to other than the initial MAC address.
- Security - Forged transmits is set to Accept, which means that the ESXi host does not compare source and effective MAC addresses.
- Traffic Shaping policies to control the bandwidth and burst size on a port group are disabled. You can still set QoS for each NIC in the template.
- Physical NICs. The physical NICs used as uplinks are bridged in a bond bridge with teaming capabilities.

Distributed port groups created by OpenNebula have the following settings:

- Number of ports is set to Elastic. According to VMWare's documentation, the Elastic mode is used to ensure efficient use of resources on ESXi hosts where the ports of virtual switches are dynamically scaled up and down. The default port number for distributed switches is 8.
- Static binding. When you connect a virtual machine to a distributed port group, a port is immediately assigned and reserved for it, guaranteeing connectivity at all times. The port is disconnected only when the virtual machine is removed from the port group.
- Auto expand is enabled. When the port group is about to run out of ports, the port group is expanded automatically by a small predefined margin.
- Early Bindind is enabled. A free DistributedVirtualPort will be selected to assign to a Virtual Machine when the Virtual Machine is reconfigured to connect to the port group.


Creating a vCenter virtual network in Sunstone
--------------------------------------------------------------------------------

Go to ``Network --> Virtual Network`` in Sunstone. Click on the green "+" button and set a virtual network name.

In the Conf tab, select vCenter from the Network Mode menu, so the vcenter network driver is used (the ``VN_MAD=vcenter`` attribute will be added to OpenNebula's template). The Bridge name will be the name of the port group, and by default it's the name of the Virtual Network but you can choose a different port group name.

Once you've selected the vCenter network mode, Sunstone will show several network attributes that can be defined. You have more information about these attributes in the :ref:`vCenter Network attributes <vcenter_network_attributes>` section, but we'll comment some of them now.

OpenNebula Host's ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to create a Virtual Network using the vCenter driver we must select which vCenter cluster, represented as an OpenNebula host, this virtual network will be associated to. OpenNebula will act on each of the ESX hosts which are members of the vCenter cluster.

Physical device
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to assign uplinks to your switch you can specify the names of the physical network interface cards of your ESXi hosts that will be used. You can use several physical NIC names using a comma between them e.g vmnic0,vmnic1. Note that you must check that two switches cannot share the same physical NIC and that you must be sure that the same physical interface name exists and it's available for every ESX host in the cluster.

Let's see an example. If you want to create a port group in a new virtual switch, we'll first check what physical adapters are free and unassigned in the hosts of my vCenter cluster. I've two hosts in my cluster:

In my first host, the vmnic1 adapter is free and is not assigned to any vSwitch:

.. image:: /images/vcenter_vmnic1_free_host1.png
    :width: 60%
    :align: center

In my second host, the vmnic1, vmnic2 and vmnic3 interfaces are free:

.. image:: /images/vcenter_vmnic1_free_host2.png
    :width: 60%
    :align: center

So if I want to specify an uplink, the only adapter that I could use in both ESX hosts would be **vmnic1** and OpenNebula will create the switches and uplinks as needed:

.. image:: /images/vcenter_vmnic1_assigned.png
    :width: 60%
    :align: center


Number of ports
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This attribute is optional. With this attribute we can specify the number of ports that the virtual switch is configured to use. If you set a value here please make sure that you know and understand the `maximums supported by your vSphere platform <https://www.vmware.com/pdf/vsphere6/r60/vsphere-60-configuration-maximums.pdf>`_.


VLAN ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This attribute is optional. You can set a manual VLAN ID, force OpenNebula to generate an automatic VLAN ID or set that no VLANs are used. This value will be assigned to the VLAN_ID attribute.


Address Ranges
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to create your Virtual Network you must also add an Address Range in the Addresses tab. Please visit the :ref:`Virtual Network Definition <vnet_template>` section.

.. _vcenter_networking_limitations:

Limitations
--------------------------------------------------------------------------------

**OpenNebula won't sync ESX hosts.** OpenNebula won't create or delete port groups or switches on ESX hosts that are added/removed after the virtual network was created. For example, if you're using vMotion and DPM and an ESX host is powered on, that ESX host won't have the switch and/or port group that was created by OpenNebula hence a VM cannot be migrated to that host.

**Virtual Network Update is not supported.** If you update a Virtual Network definition, OpenNebula won't update the attributes in existing port groups or switches so you should remove the virtual network and create a new one with the new attributes.

**Security groups.** Security Groups are not supported by the vSphere Switch mode.

**Network alias.** It is possible to use network interface alias with vCenter, however if you attach an alias when the vm is running the action will take action on the next reboot (OpenNebula deploy). If you do not want to reboot the machine you can manually execute the next command on the machine prompt:

.. prompt:: bash $ auto

    $ /usr/sbin/one-contextd all reconfigure

**Importing networks.** OpenNebula won't import a network if it does not belong to any host. In the case of distributed port groups if DVS has no host attached to it.

.. _network_monitoring:

Network monitoring
------------------

OpenNebula gathers network monitoring info for each VM. Real-time data is retrieved from vCenter thanks to the Performance Manager which collects data every 20 seconds and maintains it for one hour. Real-time samples are used so no changes have to be applied to vCenter's Statistics settings. Network metrics for transmitted and received traffic are provided as an average using KB/s unit.

The graphs provided by Sunstone are different from those found in vCenter under the ``Monitor -> Performance`` tab when selecting Realtime in the Time Range drop-down menu or in the Advanced view selecting the Network View. The reason is that Sunstone uses polling time as time reference while vCenter uses sample time on their graphs, so an approximation to the real values aggregating vCenter's samples between polls is needed. As a result, upload and download peaks will be different in value and different peaks between polls won't be depicted. Sunstone's graphs will provide a useful information about networking behaviour which can be examined on vCenter later with greater detail.
