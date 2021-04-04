.. _equinix_cluster:

================================================================================
Equinix Edge Cluster
================================================================================

Edge Cluster Types
================================================================================

Equinix supports **metal** elastic clusters that use bare-metal instances to create OpenNebula Hosts. You can run the following hypervisors in metal clusters:

* **KVM**, runs virtual machines.
* **Firecracker**, runs microVMs.
* **LXC**, runs system containers.

Equinix Provider
================================================================================

An Equinix provider contains the credentials to interact with Equinix and also the location to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* Parsippany (NJ, US)
* Tokyo
* California (US)

In order to define an Equinix provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``token`` and ``project``. You can follow `this guide <https://metal.equinix.com/developers/api/>`__ to get this data.
* **Facility**: this is the location in the world where the resources are going to be deployed. All the available `facilities are listed here <https://www.equinix.com/data-centers/>`__.
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Create an Equinix Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a new provider you need to write the previous data in YAML template:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'packet-amsterdam'

    description: 'Edge cluster in Equinix Amsterdam'
    provider: 'packet'

    connection:
      token: 'Packet token'
      project: 'Packet project'
      facility: 'ams1'

    inputs:
      - name: 'packet_os'
        type: 'list'
        options:
          - 'centos_8'
      - name: 'packet_plan'
        type: 'list'
        options:
          - 'baremetal_0'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/<type>/providers/packet``. You just need to enter valid credentials.

How to Customize an Existing Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

Equinix Edge Cluster Implementation
================================================================================

An Edge Cluster in Equinix creates the following resources:

* **Packet Device**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemeted using elastic IPs from Equinix and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Equinix. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Equinix.

* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Equinix Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/equinix_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
