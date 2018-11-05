.. _devel-nm:

================================================================================
Networking Driver
================================================================================

This component is in charge of configuring the network in the hypervisors. The purpose of this guide is to describe how to create a new network manager driver.

Driver Configuration and Description
================================================================================

To enable a new network manager driver, the frist requirement is to make a new directory with the name of the driver in ``/var/lib/one/remotes/vnm/remotes/<name>`` with three files:

-  **Pre**: This driver should perform all the network related actions required before the Virtual Machine starts in a host.

-  **Post**: This driver should perform all the network related actions required after the Virtual Machine starts (actions which typically require the knowledge of the ``tap`` interface the Virtual Machine is connected to).

-  **Clean**: If any clean-up should be performed after the Virtual Machine shuts down, it should be placed here.

.. warning:: The above three files **must exist**. If no action is required in them a simple ``exit 0`` will be enough.

.. warning:: Remember that any change in the ``/var/lib/one/remotes`` directory won't be effective in the Hosts until you execute, as oneadmin: ``onehost sync -f``

Virtual Machine actions and their relation with Network actions:

-  **Deploy**: ``pre`` and ``post``
-  **Shutdown**: ``clean``
-  **Cancel**: ``clean``
-  **Save**: ``clean``
-  **Restore**: ``pre`` and ``post``
-  **Migrate**: ``pre`` (target host), ``clean`` (source host), ``post`` (target host)
-  **Attach Nic**: ``pre`` and ``post``
-  **Detach Nic**: ``clean``

After that you need to define the bridging technology used by the driver at ``/etc/one/oned.conf``. OpenNebula support three differents technologies, **Linux Bridge**, **Open vSwitch** y **vCenter Port Groups**. See the examples below:

.. code-block:: bash

    VN_MAD_CONF = [
        NAME = "vcenter"
        BRIDGE_TYPE = "vcenter_port_groups"
    ]

    VN_MAD_CONF = [
        NAME = "ovswitch_vxlan"
        BRIDGE_TYPE = "openvswitch"
    ]

    VN_MAD_CONF = [
        NAME = "bridge"
        BRIDGE_TYPE = "linux"
    ]


Driver Parameters
================================================================================

All three driver actions have a first parameter which is the XML VM template encoded in base64 format.

Additionally the ``post`` driver has a second parameter which is the deploy-id of the Virtual Machine e.g.: ``one-17``.

The 802.1Q Driver
================================================================================

Driver Files
--------------------------------------------------------------------------------
The code can be enhanced and modified, by chaning the following files in the frontend:

* /var/lib/one/remotes/vnm/802.1Q/post
* /var/lib/one/remotes/vnm/802.1Q/vlan_tag_driver.rb
* /var/lib/one/remotes/vnm/802.1Q/clean
* /var/lib/one/remotes/vnm/802.1Q/pre

Driver Actions
--------------------------------------------------------------------------------
+-----------+----------------------------------------------------------------------------------------------------------+
|   Action  |                                               Description                                                |
+===========+==========================================================================================================+
| **Pre**   | Creates a VLAN tagged interface in the Host and a attaches it to a dynamically created bridge.           |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Post**  | N/A                                                                                                      |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The VLAN tagged interface and bridge are kept in the Host to speed up future VMs |
+-----------+----------------------------------------------------------------------------------------------------------+

The VXLAN Driver
================================================================================

Driver Files
--------------------------------------------------------------------------------
The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/vxlan/vxlan_driver.rb
* /var/lib/one/remotes/vnm/vxlan/post
* /var/lib/one/remotes/vnm/vxlan/clean
* /var/lib/one/remotes/vnm/vxlan/pre

Driver Actions
--------------------------------------------------------------------------------
+-----------+----------------------------------------------------------------------------------------------------------+
|   Action  |                                               Description                                                |
+===========+==========================================================================================================+
| **Pre**   | Creates a VXLAN interface through PHYDEV, creates a bridge (if needed) and attaches the vxlan device.    |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Post**  | When the VM is associated to a security group, the corresponding iptables rules are applied.             |
+-----------+----------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The VXLAN interface and bridge are kept in the Host to speed up future VMs       |
+-----------+----------------------------------------------------------------------------------------------------------+

The Open vSwitch Driver
================================================================================

Driver Actions
--------------------------------------------------------------------------------
+-----------+--------------------------------------------------------------------------------------------------------------+
|   Action  |                                                 Description                                                  |
+===========+==============================================================================================================+
| **Pre**   | N/A                                                                                                          |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Post**  | Performs the appropriate Open vSwitch commands to tag the virtual tap interface.                             |
+-----------+--------------------------------------------------------------------------------------------------------------+
| **Clean** | It doesn't do anything. The virtual tap interfaces will be automatically discarded when the VM is shut down. |
+-----------+--------------------------------------------------------------------------------------------------------------+


The ebtables Driver
================================================================================

Driver Actions
--------------------------------------------------------------------------------

+-----------+------------------------------------------------------------------+
|   Action  |                           Description                            |
+===========+==================================================================+
| **Pre**   | N/A                                                              |
+-----------+------------------------------------------------------------------+
| **Post**  | Creates EBTABLES rules in the Host where the VM has been placed. |
+-----------+------------------------------------------------------------------+
| **Clean** | Removes the EBTABLES rules created during the ``Post`` action.   |
+-----------+------------------------------------------------------------------+

