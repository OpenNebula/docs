.. _vmwarenet:

==================
VMware Networking
==================

This guide describes how to use the VMware network driver in OpenNebula. This driver optionally provides network isolation through VLAN tagging. The VLAN id will be the same for every interface in a given network, calculated by adding a constant to the network id. It may also be forced by specifying an VLAN\_ID parameter in the :ref:`Virtual Network template <vnet_template>`.

Requirements
============

In order to use the dynamic network mode for VM disks, some extra configuration steps are needed in the ESX hosts.

.. code::

     $ su
     $ chmod +s /sbin/esxcfg-vswitch

Considerations & Limitations
============================

It should be noted that the drivers will not create/delete/manage VMware virtual switches, these should be created before-hand by VMware administrators.

Since the dynamic driver will however create VMware port groups, it should be noted that there's a default limit of 56 port groups per switch. Administrators should be aware of these limitations.

Configuration
=============

The vSphere hosts can work in two different networking modes, namely:

-  **pre-defined**: The VMWare administrator has set up the network for each vSphere host, defining the vSwitch'es and port groups for the VMs. This mode is associated with the ``dummy`` network driver. To configure this mode use ``dummy`` as the Virtual Network Manager driver parameter when the hosts are created:

.. code::

    $ onehost create host01 -i vmware -v vmware -n dummy

-  **dynamic**: In this mode OpenNebula will create on-the-fly port groups (with an optional VLAN\_ID) for your VMs. The VMWare administrator has to set up only the vSwitch to be used by OpenNebula. To enable this driver, use ``vmware`` as the VNM driver for the hosts:

.. code::

    $ onehost create host02 -i vmware -v vmware -n vmware

.. warning:: Dynamic and pre-defined networking modes can be mixed in a datacenter. Just use the desired mode for each host.

Usage
=====

Using the Pre-defined Network Mode
----------------------------------

In this mode there the VMware admin has created one or more port groups in the ESX hosts to bridge the VMs. The port group has to be specified for each Virtual Network in its template through the ``BRIDGE`` attribute (:ref:`check the Virtual Network usage guide for more info <vgg>`).

The NICs of the VM in this Virtual Network will be attached to the specified port group in the vSphere host. For example:

.. code::

    NAME    = "pre-defined_vmware_net"
    BRIDGE  = "VM Network"  # This is the port group  
     ...

.. _vmwarenet_using_the_dynamic_network_mode:

Using the Dynamic Network Mode
------------------------------

In this mode the driver will dynamically create a port-group with name ``one-pg-<network_id>`` in the specified vSwitch of the target host. In this scenario the vSwitch is specified by the ``BRIDGE`` attribute of the Virtual Network template.

Additionally the port groups can be tagged with a vlan\_id. You can set VLAN=“YES” in the Virtual Network template to automatically tag the port groups in each ESX host. Optionally the tag can be specified through the VLAN\_ID attribute. For example:

.. code::

    NAME    = "dynamic_vmware_net"
    BRIDGE  = "vSwitch0" # In this mode this is the vSwitch name
     
    VLAN    = "YES"
    VLAN_ID = 50       # optional
     
    ...

Tuning & Extending
==================

The predefined mode (dummy driver) does not execute any operation in the pre, post and clean steps (see :ref:`for more details on these phases <nm>`).

The strategy of the dynamic driver is to dynamically create a VMware port group attached to a pre-existing VMware virtual switch (standard or distributed) for each Virtual Network.

+-------------+--------------------------------------------------------------------+
| Action      | Description                                                        |
+=============+====================================================================+
| **Pre**     | Creates the VMware port group with name ``one-pg-<network_id>``.   |
+-------------+--------------------------------------------------------------------+
| **Post**    | No operation                                                       |
+-------------+--------------------------------------------------------------------+
| **Clean**   | No operation                                                       |
+-------------+--------------------------------------------------------------------+

Calculating VLAN ID
-------------------

The vlan id is calculated by adding the network id to a constant defined in ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.rb``. The administrator may customize that value to their own needs:

.. code::

    CONF = {
        :start_vlan => 2
    }

