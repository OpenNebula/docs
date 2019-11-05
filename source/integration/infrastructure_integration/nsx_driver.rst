.. _nsx_driver:

NSX Driver
==========

The NSX Driver for OpenNebula enables the interaction with NSX Manager API, to manage its different components, such as, logical switches, distributed firewall...

UML diagram
-----------

Here is the dependency between classes into the NSX driver.

.. image:: /images/nsx_driver_classes.png



NSX Integration
---------------

Logical switches integration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
OpenNebula can manage logical switches using NSX Driver and the hook subsystem. How does it work?

An action to create or delete a logical switch either from Sunstone, CLI or API, generates an specific event.

If there is a hook subscribed to that event, it will execute an action or script.

In the case of NSX, the hook will use the NSX Driver to send commands to the NSX Manager API, and will wait to the answer.

When NSX Manager finish the action, will return a response and the hook, based on that response, will end up as success or error.

Here in the image below you can see an example of how is the process of creating a logical switch


.. figure:: /images/nsx_driver_integration.png


.. _nsx_object_ref:

Object references
-----------------
All NSX object has its reference into the NSX Manager.

Some NSX objects also has its reference into vCenter Server. This is the case of logical switches, that have its object representation in vcenter.

Here is a table with the components and their reference formats in NSX and vCenter, and also the attributed used in OpenNebula to store that object:


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
In the last release, at this time, only Logical Switches are supported, but the intention is increase the number of managed components.

In the image below is shown which components are intended to be supported by OpenNebula through its NSX Driver.

.. figure:: /images/nsx_driver_managed_components.png


.. _nsx_limitations:

NSX Driver Limitations
----------------------
At this time there are the next limitations:

    - Cannot create/modify/delete Transport Zones
    - All parameters are not available when creating Logical Switches
    - Universal Logical Switches are not supported
    - Only support one NSX Manager per vCenter Server
    - The process of preparing a NSX cluster must be done from NSX Manager
    - Imported networks work with vcenter id instead of nsx id
