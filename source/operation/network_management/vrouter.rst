.. _vrouter:

================================================================================
Virtual Routers
================================================================================

Virtual Routers provide routing across Virtual Networks. The administrators can easily connect Virtual Networks from Sunstone and the CLI. The routing itself is implemented with a Virtual Machine appliance available though the market place. This Virtual Machine can be seamlessly deployed in high availability mode.

Download the Virtual Router Appliance
================================================================================

OpenNebula provides appliance which implements various Virtual Network Functions (VNFs), including the virtual router. The virtual router image is prepared to run in a HA mode, and process the context information from OpenNebula. So its base capabilities can be easily extended. Continue to the `VNF appliance documention <https://docs.opennebula.io/appliances/service/vnf.html>`_ for more details about the advanced usage and other implemented functions.

- Download the appliance from the OpenNebula Marketplace. For example to put the virtual router image in the default datastore and create a Virtual Router template named ``Service Virtual Router`` use:

.. code::

    $ onemarketapp export 'Service Virtual Router' vr --datastore default --vmname vr
    IMAGE
        ID: 9
    VMTEMPLATE
        ID: 8

- Check that the resources are properly created, an update them to your OpenNebula installation if needed.

.. code::

    $ oneimage show 9 # 9 is the IMAGE ID from the previous onemarketapp command
    $ onetemplate show 8 # 8 is for the VMTEMPLATE ID

Creating a new Virtual Router
================================================================================

New Virtual Routers are created from a special type of VM Template, as the one created automatically when downloading the market app.

.. _force_ipv4_sunstone:

Sunstone
--------------------------------------------------------------------------------

To create a new Virtual Router from Sunstone, follow the wizard to select the Virtual Networks that will get logically linked to it. This connection takes effect when the Virtual Machine containing the VR Appliance is automatically deployed, with a network interface attached to each Virtual Network.

For each Virtual Network, the following options can be defined:

* **Floating IP**. Only used in High Availability, explained bellow.

* **Force IPv4**. You can force the IP assigned to the network interface. When the VR is not configured in High Availability, this will be the IP requested for the Virtual Machine appliance.

* **Management interface**. If checked, this network interface will be a Virtual Router management interface. Traffic will not be forwarded to it.


Once ready, click the "create" button to finish. OpenNebula will create the Virtual Router and the Virtual Machines automatically.

|sunstone_create_vrouter|

CLI
--------------------------------------------------------------------------------

Virtual Routers can be managed with the ``onevrouter`` command.

To create a new Virtual Router from the CLI, first you need to create a VR Template file, with the following attributes:

Then use the ``onevrouter create`` command:

.. code::

    $ cat myvr.txt
    NAME = my-vr
    NIC = [
      NETWORK="blue-net",
      IP="192.168.30.5" ]
    NIC = [
      NETWORK="red-net" ]

    $ onevrouter create myvr.txt
    ID: 1

At this point the Virtual Router resource is created, but it does not have any Virtual Machines. A second step is needed to create one (or more, if High Availability is used):

.. code::

    $ onevrouter instantiate <vrouterid> <templateid>


Managing Virtual Routers
================================================================================

Using the Virtual Routers tab in Sunstone, or the ``onevrouter show`` command, you can retrieve the generic resource information such as owner and group, the list of Virtual Networks interconnected by this router, and the Virtual Machines that are actually providing the routing.

|sunstone_topology|

The Virtual Networks connected to the VR machines can be modified with the attach/detach actions.

In Sunstone the actions can be found in the Virtual Router's main information panel, in the networks table. The options to add a new Virtual Network are the same that were explained for the creation wizard, see previous section.

The ``onevrouter nic-attach`` command takes a file containing a single NIC attribute. Alternatively, you can provide the new virtual network settings with command options, see ``onevrouter nic-attach -h`` for more information.

After a NIC is attached or detached, the Virtual Machine appliances are automatically reconfigured to start routing to the new interface. No other action, like a reboot, is required.


Managing Virtual Router VMs
--------------------------------------------------------------------------------

The Virtual Machines that are associated to a Virtual Router have all actions allow except nic-attach/dettach. They can be terminated and new Virtual Machines can be added to an existing Virtual Router.

All the Virtual Machines associated with a Virtual Router are terminated automatically when the Virtual Router is deleted. Each VM can however be terminated individually at any time.

To create new VMs use the ``onevrouter instantiate`` command, or the "Instantiate VMs" dialog in Sunstone.

High Availability
================================================================================

More than one Virtual Machines can be associated to a Virtual Router in order to implement a high availability scenario. In this case, OpenNebula will also assign a floating IP to the group of Virtual Machines, that will coordinate to manage the traffic directed to that IP.

To enable a high availability scenario, you need to choose 2 or more number of instances when the Virtual Router is created in Sunstone. In the CLI, the number of VM instances is given with the ``-m`` option

.. code::

    $ onevrouter instantiate -h
    [...]
    -m, --multiple x          Instance multiple VMs

In this scenario, the following Virtual Router options became relevant:

* **Keepalived ID**: Optional. Sets keepalived configuration parameter ``virtual_router_id``.
* **Keepalived password**: Optional. Sets keepalived configuration parameter ``authentication/auth_pass``.

And for each Virtual Network Interface:

* **Floating IP**. Check it to enable the floating IP.
* **Force IPv4**. Optional. With the floating IP option selected, this field requests a fixed IP for that floating IP, not the individual VM IPs.

The floating IP assignment is managed in a similar way to normal VM IPs. If you open the information of the Virtual Network, it will contain a lease assigned to the Virtual Router (not a VM). Besides the floating IP, each VM will get their own individual IP.

Other Virtual Machines in the network will use the floating IP to contact the Virtual Router VMs. At any given time, only one VM is using that floating IP address. If the active VM crashes, the other VMs will coordinate to assign the floating IP to a new Virtual Router VM.

Customization
================================================================================

You can provide two optional parameters in the context to configure the keepalived service started in the Virtual Router VM:

* ``VROUTER_KEEPALIVED_PASSWORD``: Password used for the service to protect the service from packages of rogue machines. By default the service is configured without password.
* ``VROUTER_KEEPALIVED_ID``: Number identifier of the service (1-255). This is useful when you have several virtual routers or other keepalived services in the same network. By default it is generated from the Virtual Router ID (``$vrouter_id & 255``) but you can specify it manually if needed.

These parameters can also be provided in the Virtual Router creation wizard of Sunstone.

.. |sunstone_create_vrouter| image:: /images/sunstone_create_vrouter.png
.. |sunstone_topology| image:: /images/sunstone_topology.png
