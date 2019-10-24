.. _nsx_driver:

NSX Driver
==========

The NSX Driver for OpenNebula enables the interaction with NSX Manager API, to manage its different components, such as, logical switches, distributed firewall...

UML diagram
-----------

Here is the dependency between classes into the NSX driver.

.. image:: /images/nsx_driver_classes.png

.. nsx_object_ref:

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
