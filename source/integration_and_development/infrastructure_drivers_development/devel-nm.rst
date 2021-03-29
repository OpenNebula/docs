.. _devel-nm:

================================================================================
Networking Driver
================================================================================

This component is in charge of configuring the network in the hypervisors. The purpose of this guide is to describe how to create a new network manager driver.

Driver Configuration and Description
================================================================================

To enable a new network manager driver, the first requirement is to make a new directory with the name of the driver in ``/var/lib/one/remotes/vnm/remotes/<name>`` with three files:

-  **pre**: This driver should perform all the network related actions required before the Virtual Machine starts in a host.

-  **post**: This driver should perform all the network related actions required after the Virtual Machine starts (actions which typically require the knowledge of the ``tap`` interface the Virtual Machine is connected to).

-  **clean**: If any clean-up should be performed after the Virtual Machine shuts down, it should be placed here.

.. warning:: The above three files **must exist**. If no action is required in them a simple ``exit 0`` will be enough.

.. warning:: Remember that any change in the ``/var/lib/one/remotes`` directory won't be effective in the Hosts until you execute, as ``oneadmin``: ``onehost sync -f``

Virtual Machine actions and their relation with Network actions:

-  **Deploy**: ``pre`` and ``post``
-  **Shutdown**: ``clean``
-  **Cancel**: ``clean``
-  **Save**: ``clean``
-  **Restore**: ``pre`` and ``post``
-  **Migrate**: ``pre`` (target host), ``clean`` (source host), ``post`` (target host)
-  **Attach Nic**: ``pre`` and ``post``
-  **Detach Nic**: ``clean``

After that you need to define the bridging technology used by the driver at ``/etc/one/oned.conf``. OpenNebula support three different technologies, **Linux Bridge**, **Open vSwitch** and **vCenter Port Groups**. See the examples below:

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

    VN_MAD_CONF = [
        NAME = "custom"
        BRIDGE_TYPE = "none"
    ]

.. note:: Note that you can set ``BRIDGE_TYPE`` attribute to ``none`` if you need to leave the bridge empty.

.. _devel-nm-hook:

Driver Customization
================================================================================

Default driver actions support the execution of hooks after the main action is successfully executed. In order to create an action hook you need to place your custom configuration scripts in the corresponding **action.d** directory (``pre.d``, ``post.d``, ``clean.d``), inside the target networking driver directory. Files found in that directory will be run in an alphabetical order, excluding the ones ``oneadmin`` cannot run due to lack of permissions. If the main action fails the hooks won't be run. If a hook fails the corresponding network actions will be consider as a **FAILURE** and the VM will change its state accordingly. Note that the scripts will receive the same information as the main action through ``stdin``.

For example, this is the directory tree of the bridge driver synced to a virtualization node with some custom scripts

.. code-block:: text

    root@ubuntu1804-lxd-ssh-6ee11-2:/var/tmp/one/vnm/bridge# tree ./
    ./
    ├── clean
    ├── clean.d
    │   ├── 01_del_fdb
    │   ├── 02_del_routes
    ├── post
    ├── post.d
    │   ├── 01_add_fdb
    │   ├── 02_add_routes
    ├── pre
    ├── pre.d
    │   ├── 01_update_router
    └── update_sg

Driver Parameters
================================================================================

All three driver actions receive the **XML VM template** encoded in base64 format by ``stdin`` and the **deploy-id** of the Virtual Machine as parameter, e.g.: ``one-17``.

The ``clean`` action doesn't require **deploy-id**

The 802.1Q Driver
================================================================================

Driver Files
--------------------------------------------------------------------------------
The code can be enhanced and modified, by changing the following files in the frontend:

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

The code can be enhanced and modified, by changing the following files in the frontend:
* /var/lib/one/remotes/vnm/ovswitch/OpenvSwitch.rb
* /var/lib/one/remotes/vnm/ovswitch/post
* /var/lib/one/remotes/vnm/ovswitch/clean
* /var/lib/one/remotes/vnm/ovswitch/pre

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

The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/ebtables/Ebtables.rb
* /var/lib/one/remotes/vnm/ebtables/post
* /var/lib/one/remotes/vnm/ebtables/clean
* /var/lib/one/remotes/vnm/ebtables/pre

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

The Dummy Driver
================================================================================

The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/dummy/post
* /var/lib/one/remotes/vnm/dummy/clean
* /var/lib/one/remotes/vnm/dummy/pre

Driver Actions
--------------------------------------------------------------------------------

+-----------+--------------------------------------------------------------------------------+
|   Action  |                           Description                                          |
+===========+================================================================================+
| **Pre**   | Nothing is done. Just pass the arguments to the corresponding hooks.           |
+-----------+--------------------------------------------------------------------------------+
| **Post**  | Nothing is done. Just pass the arguments to the corresponding hooks.           |
+-----------+--------------------------------------------------------------------------------+
| **Clean** | Nothing is done. Just pass the arguments to the corresponding hooks.           |
+-----------+--------------------------------------------------------------------------------+

The Bridge Driver
================================================================================

The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/bridge/post
* /var/lib/one/remotes/vnm/bridge/clean
* /var/lib/one/remotes/vnm/bridge/pre

Driver Actions
--------------------------------------------------------------------------------

+-----------+--------------------------------------------------------------------------------+
|   Action  |                           Description                                          |
+===========+================================================================================+
| **Pre**   | Creates the bridge if it doesn't exists.                                       |
+-----------+--------------------------------------------------------------------------------+
| **Post**  | N/A                                                                            |
+-----------+--------------------------------------------------------------------------------+
| **Clean** | Remove the bridge if it's empty.                                               |
+-----------+--------------------------------------------------------------------------------+

The FW Driver
================================================================================

The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/fw/post
* /var/lib/one/remotes/vnm/fw/clean
* /var/lib/one/remotes/vnm/fw/pre

It performs the same action than Bridge driver but adding extra iptables rules to implement the security groups of the VM.

The Elastic Driver
================================================================================

The code can be enhanced and modified, by changing the following files in the frontend:

* /var/lib/one/remotes/vnm/elastic/post
* /var/lib/one/remotes/vnm/elastic/clean
* /var/lib/one/remotes/vnm/elastic/pre

Driver Actions
--------------------------------------------------------------------------------

+-----------+--------------------------------------------------------------------------------+
|   Action  |                           Description                                          |
+===========+================================================================================+
| **Pre**   | Creates the bridge if it doesn't exists. Setup forward rules                   |
+-----------+--------------------------------------------------------------------------------+
| **Post**  | Assign elastic IPs to the target host                                          |
+-----------+--------------------------------------------------------------------------------+
| **Clean** | Remove the bridge if it's empty. Unassigns elastic IPs                         |
+-----------+--------------------------------------------------------------------------------+


