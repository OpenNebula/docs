.. _nsx_driver:

NSX Driver
==========

The NSX Driver for OpenNebula enables the interaction with NSX Manager API to manage its different components, such as logical switches and distributed firewall.

Here is the dependency between classes into the NSX driver.

.. image:: /images/nsx_driver_classes.png

NSX Integration
---------------

Logical switches integration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula manages logical switches using NSX Driver and the hook subsystem.

An action to create or delete a logical switch either from Sunstone, CLI or API, generates an specific event. If there is a hook subscribed to that event, it will execute an action or script. In the NSX integration a hook will use the NSX Driver to send commands to the NSX Manager API and will wait for an answer.

When NSX Manager finishes the action it will return a response and the hook, based on that response, will end up as success or error. The process of creating a logical switch is depicted below.

.. figure:: /images/nsx_driver_integration.png

Security Groups integration
^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula security groups defines rules, associated to vnet, that are applied into NSX Distributed Firewall over a specific virtual machine logical port group. NSXDriver is in charge of translating OpenNebula security group rules into DFW rules, on both NSX-T and NSX-V.

Here are the actions that affect to the creation, modification or deletion of rules in the Distributed Firewall.

+-----------------------------------+--------------------+--------------------+
| OpenNebula action                 | NET driver actions | NSX driver action  |
+===================================+====================+====================+
| Instantiate                       | PRE & POST         | Create rules       |
+-----------------------------------+--------------------+--------------------+
| Terminate                         | CLEAN              | Delete rules       |
+-----------------------------------+--------------------+--------------------+
| PowerOn                           | PRE & POST         | Create rules       |
+-----------------------------------+--------------------+--------------------+
| PowerOff                          | CLEAN              | Delete rules       |
+-----------------------------------+--------------------+--------------------+
| Attach nic                        | PRE & POST         | Create rules       |
+-----------------------------------+--------------------+--------------------+
| Detach nic                        | CLEAN              | Delete rules       |
+-----------------------------------+--------------------+--------------------+
| Update Security Group             | UPDATE_SG          | Modify rules       |
+-----------------------------------+--------------------+--------------------+

.. warning:: The actions above only apply when a Security Group belongs to a NSX-T or NSX-V vnet.

When the above OpenNebula actions are executed, the OpenNebula network driver run one or more actions. Each action type uses NSX driver to create / modify / delete rules into the NSX Distributed Firewall.

What does each network driver action do?

    - **PRE**: Check if NSX_STATUS is OK. If NSX_STATUS is not OK then the OpenNebula action will fail.
    - **POST**: Uses NSX driver to create rules in DFW.
    - **CLEAN**: Uses NSX driver to remove rules in DFW.
    - **UPDATE_SG**: Uses NSX driver to update rules in DFW.

.. _nsx_object_ref:

Object references
-----------------

All NSX object has its reference within the NSX Manager.

Some NSX objects also has its reference into vCenter Server. This is the case of logical switches, that have its object representation in vCenter.

Here is a table with the components and their reference formats in NSX and vCenter, and also the attributes used in OpenNebula to store that object:

+-----------------------------------+----------+---------------+--------------------------------------+--------------------+
| Object                            | NSX type | ONE Attribute | NSX ref. format                      | vCenter ref format |
+===================================+==========+===============+======================================+====================+
| Logical Switch ( Opaque Network ) | NSX-T    | NSX_ID        | xxxxxxxx-yyyy-zzzz-aaaa-bbbbbbbbbbbb | network-oXXX       |
+-----------------------------------+----------+---------------+--------------------------------------+--------------------+
| Logical Switch ( VirtualWire )    | NSX-V    | NSX_ID        | virtualwire-XXX                      | dvportgroup-XXX    |
+-----------------------------------+----------+---------------+--------------------------------------+--------------------+
| Transport Zone                    | NSX-T    | TZ_ID         | xxxxxxxx-yyyy-zzzz-aaaa-bbbbbbbbbbbb | N/A                |
+-----------------------------------+----------+---------------+--------------------------------------+--------------------+
| Transport Zone                    | NSX-V    | TZ_ID         | vdnscope-XX                          | N/A                |
+-----------------------------------+----------+---------------+--------------------------------------+--------------------+

Managed components
------------------

Currently Logical Switches and Distributed Firewall ( DFW ) are supported. These componentes are known as NSX-T / NSX-V vnets and Security Groups respectively in OpenNebula. In the image below is shown which components are intended to be supported by OpenNebula through its NSX Driver in the near future.

.. figure:: /images/nsx_driver_managed_components.png
