.. _vultr_virtual_cluster:

==========================
Vultr Edge Cluster
==========================

Vultr supports both virtual and metal clusters. Metal Edge Clusters are not available yet in Vultr.  Vultr **virtual** Edge Clusters use a Virtual Machine instance to create OpenNebula Hosts. This provision is better suited for PaaS-like workloads. Virtual Vultr Edge Clusters primarily run **LXC** to execute system containers.

Vultr Virtual Provider
================================================================================

A Vultr virtual provider contains the credentials to interact with Vultr and also the location to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* London
* Chicago
* San Francisco

In order to define a Vultr virtual provider, you need the following information:

* **Key**: this is used to interact with the remote provider. You need to provide ``key``. You can follow `this guide <https://www.vultr.com/api/#section/Authentication>`__ to get this data.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available `regions are listed here <https://www.vultr.com/features/datacenter-locations/>`__.
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Create an Vultr Virtual Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a new provider you need to write the previous data in YAML template:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'vultr-amsterdam'

    description: 'Edge cluster in Vultr Amsterdam'
    provider: 'vultr_virtual'

    plain:
      image: 'VULTR'
      location_key: 'region'
      provision_type: 'virtual'

    connection:
      key: 'Vultr key'
      region: 'ams'

    inputs:
      - name: 'vultr_os'
        type: 'list'
        options:
          - '362'
      - name: 'vultr_plan'
        type: 'list'
        options:
          - 'vc2-1c-1gb'
          - 'vc2-1c-2gb'
          - 'vc2-1c-4gb'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/vultr``. You just need to enter valid credentials.

How to Customize an Existing Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

Vultr Virtual Edge Cluster Implementation
================================================================================

An Edge Cluster in Vultr creates the following resources:

* **Instance**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemeted using elastic IPs from Vultr and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Vultr. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Vultr.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Vultr Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/vultr_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
