.. _openvswitch_vxlan:

================================================================================
Open vSwitch on VXLAN Networks
================================================================================

This guide describes how to use the `Open vSwitch <http://openvswitch.org/>`__ on the VXLAN networks. The specialized driver combines features of existing :ref:`Open vSwitch <openvswitch>` and :ref:`VXLAN <vxlan>` drivers. It's necessary to be familiar with these two drivers, their configuration options, benefits, and drawbacks.

The VXLAN overlay network is used as a base with the Open vSwitch (instead of regular Linux bridge) on top. Traffic on the lowest level is isolated by the VXLAN encapsulation protocol, and Open vSwitch still allows to use the second level isolation by 802.1Q VLAN tags **inside the encapsulated traffic**. Main isolation is always provided by VXLAN, not 802.1Q VLANs. If 802.1Q is required to isolate the VXLAN, the driver needs to be configured with user-created 802.1Q tagged physical interface.

This hierarchy is important to understand.

OpenNebula Configuration
================================================================================

There is no configuration specific to this driver, except the options specified for :ref:`Open vSwitch <openvswitch>` and :ref:`VXLAN <vxlan>`.

Defining Open vSwitch on VXLAN Network
======================================

To create a network include the following information:

+-----------------------------+-------------------------------------------------------------------------+-----------+
| Attribute                   | Value                                                                   | Mandatory |
+=============================+=========================================================================+===========+
| **VN_MAD**                  | ovswitch_vxlan                                                          |  **YES**  |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **PHYDEV**                  | Name of the physical network device that will be attached to the bridge.|  **YES**  |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **BRIDGE**                  | Name of the Open vSwitch bridge to use                                  |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **OUTER_VLAN_ID**           | The outer VXLAN network ID.                                             |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **AUTOMATIC_OUTER_VLAN_ID** | If OUTER_VLAN_ID has been defined, this attribute is ignored.           |  NO       |
|                             | Set to YES if you want OpenNebula to generate an automatic ID.          |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **VLAN_ID**                 | The inner 802.1Q VLAN ID. If this attribute is not defined a VLAN ID    |  NO       |
|                             | will be generated if AUTOMATIC_VLAN_ID is set to YES.                   |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **AUTOMATIC_VLAN_ID**       | If VLAN_ID has been defined, this attribute is ignored.                 |  NO       |
|                             | Set to YES if you want OpenNebula to generate an automatic VLAN ID.     |           |
+-----------------------------+-------------------------------------------------------------------------+-----------+
| **MTU**                     | The MTU for the VXLAN interface and bridge                              |  NO       |
+-----------------------------+-------------------------------------------------------------------------+-----------+

The following example defines an Open vSwitch network

.. code::

    NAME    = "ovsvx_net"
    VN_MAD  = "ovswitch_vxlan"
    PHYDEV  = eth0
    BRIDGE  = ovsvxbr0.10000
    OUTER_VLAN_ID = 10000  # VXLAN VNI
    VLAN_ID = 50           # optional
    ...

In this scenario, the driver will check for the existence of bridge ``ovsvxbr0.10000``.  If it doesn't exist, it will be created. Also, the VXLAN interface ``eth0.10000`` will be created and attached to the Open vSwitch bridge ``ovsvxbr0.10000``. When a virtual machine is instantiated, its bridge ports will be tagged with 802.1Q VLAN 50.
