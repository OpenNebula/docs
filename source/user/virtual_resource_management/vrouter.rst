.. _vrouter:

================================================================================
Virtual Routers
================================================================================

Virtual Routers are an OpenNebula resource that provide routing across Virtual Networks. The administrators can easily connect Virtual Networks from Sunstone and the CLI.
The routing itself is implemented with a Virtual Machine appliance provided by the OpenNebula installation. This Virtual Machine can be seamlessly deployed in high availability mode.

Creating a new Virtual Router
================================================================================

New Virtual Routers are created from a special type of VM Template. The installation will create a default Template that can be later customized.

Virtual Router Appliance Images
-------------------------------

There are two already prepared images with the needed configuration to act as a Virtual Router instance. These are for KVM and vcenter hypervisors.

KVM
~~~

You can download the image from the `OpenNebula Marketplace <http://marketplace.opennebula.systems/>`__ and its name is "`alpine-vrouter (KVM) <http://marketplace.opennebula.systems/appliance/56e156618fb81d0768000001>`__". The image only needs 256 Mb of RAM to run and supports SSH contextualization. This is the configuration needed in the template:

* Enable network contextualization.
* Use ``vd`` as disk prefix and ``virtio`` as default network model, this can be set in the template wizzard at the bottom of networks tab.
* Do not add any network to the template as these will be added when the Virtual Router is created.
* Mark the template as Virtual Router at the bottom of the General tab. The button is labeled "Make this template available for Virtual Router machines only".

vcenter
~~~~~~~

An ova with the preconfigured image can be imported from the following URL:

.. code::

    https://s3-eu-west-1.amazonaws.com/opennebula-marketplace/alpine-vrouter.ova

After that you'll only need to import new templates from vcenter and set the template as Virtual Router at the bottom of the General tab of the template update wizzard.


Sunstone
--------------------------------------------------------------------------------

To create a new Virtual Router from Sunstone, follow the wizard to select the Virtual Networks that will get logically linked to it. This connection takes effect when the Virtual Machine containing the VR Appliance is automatically deployed, with a network interface attached to each Virtual Network.

For each Virtual Network, the following options can be defined:

* **Floating IP**. Only used in High Availability, explained bellow.
* **Force IPv4**. You can force the IP assigned to the network interface. When the VR is not configured in High Availability, this will be the IP requested for the Virtual Machine appliance.
* **Management interface**. If checked, this network interface will be a Virtual Router management interface. Traffic will not be forwarded.

The Virtual Router needs a VM Template from which to create the VM containing the routing appliance. You should at least have the default one created following the instructions from "Virtual Router Appliance Images" section.

In here you can also define a name for the VM, if it should be created on hold, and the number of instances. If more than one VM instance is required, they will work in High Availability mode (see bellow).

Click the "create" button to finish. OpenNebula will create the Virtual Router and the Virtual Machines automatically.

CLI
--------------------------------------------------------------------------------

Virtual Routers can be managed with the ``onevrouter`` command.

To create a new Virtual Router from the CLI, first you need to create a VR Template file, with the following attributes:

.. todo:: list of VR attributes, name, nics, etc

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

    $ instantiate <vrouterid> <templateid>


Managing Virtual Routers
================================================================================

Using the Virtual Routers tab in Sunstone, or the ``onevrouter show`` command, you can retrieve the generic resource information such as owner and group, the list of Virtual Networks interconnected by this router, and the Virtual Machines that are actually providing the routing.

.. todo:: sunstone screenshots

The Virtual Networks connected to the VR machines can be modified with the attach/detach actions.

In Sunstone the actions can be found in the Virtual Router's main information panel, in the networks table. The options to add a new Virtual Network are the same that were explained for the creation wizard, see previous section.

The ``onevrouter nic-attach`` command takes a file containing a single NIC attribute. Alternatively, you can provide the new virtual network settings with command options, see ``onevrouter nic-attach -h`` for more information.

After a NIC is attached or detached, the Virtual Machine appliances are automatically reconfigured to start routing to the new interface. No other action, like a reboot, is required.


Managing Virtual Router VMs
--------------------------------------------------------------------------------

The Virtual Machines that are associated to a Virtual Router have a limited set of actions. Specifically, any action that changes the VM state cannot be executed, including VM shutdown or delete.

To shut down a VM associated with a Virtual Router, you need to delete the Virtual Router.

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

.. todo:: sunstone screenshot, VM NICs table

Other Virtual Machines in the network will use the floating IP to contact the Virtual Router VMs. At any given time, only one VM is using that floating IP address. If the active VM crashes, the other VMs will coordinate to assign the floating IP to a new Virtual Router VM.

Customization
================================================================================

.. todo:: customization options, how to create new VR Templates.

You can provide two optional parameters in the context to configure the keepalived service started in the Virtual Router VM:

* ``VROUTER_KEEPALIVED_PASSWORD``: Password used for the service to protect the service from packages of rogue machines. By default the service is configured without password.
* ``VROUTER_KEEPALIVED_ID``: Number identifier of the service (0-255). This is useful when you have several virtual routers or other keepalived services in the same network. By default it is generated from the Virtual Router ID (``$vrouter_id & 255``) but you can specify it manually if needed.

These parameters can also be provided in the Virtual Router creation wizzard of sunstone.