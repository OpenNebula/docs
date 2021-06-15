.. _google_cluster:

===================
Google Edge Cluster
===================

Google supports **virtual** Edge Clusters, that use a Virtual Machine instance to create OpenNebula Hosts. This provision is better suited for PaaS-like workloads. Virtual Google Edge Clusters primarily run **LXC** to execute system containers.

Google Providers
================================================================================

A Google provider contains the credentials to interact with Google and also the region of the provider to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Belgium
* London
* Moncks (US)
* Oregon (US)

In order to define a Google provider, you need the following information:

* **Credentials**: these are used to interact with the Google Compute Engine service. You need to provide a ``credentials`` JSON file, see more details `in this guide <https://cloud.google.com/docs/authentication/getting-started>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://cloud.google.com/compute/docs/regions-zones>`__.
* **Google instance and image**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Add a New Google Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a new provider you need a YAML template file with the following information:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'google-belgium'

    description: 'Elastic cluster on Google in Belgium'
    provider: 'google'

    plain:
      image: 'GOOGLE'
      location_key:
        - 'region'
        - 'zone'
      provision_type: 'virtual'

    connection:
      credentials: 'JSON credentials file path'
      project: 'Google Cloud Plataform project ID'
      region: 'europe-west1'
      zone: 'europe-west1-b'

    inputs:
      - name: 'google_image'
        type: 'list'
        options:
          - 'centos-8-v20210316'
      - name: 'google_machine_type'
        type: 'list'
        options:
          - 'e2-standard-2'
          - 'e2-standard-4'
          - 'e2-standard-8'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/google``. You just need to enter valid credentials.

How to Customize an Existing Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The provider information is stored in the OpenNebula database and it can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

Google Edge Cluster Implementation
================================================================================

An Edge Cluster in Google creates the following resources:

* **Google compute instance**: host to run Virtual Machines.
* **Google compute network**: it creates an isolated virtual network for all the deployed resources.
* **Google compute firewall**: by default all the traffic is allowed but you can set up custom Security Groups through the OpenNebula interface later.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using port forwarding between the host and the VM. Each time a network is attached to the Virtual Machine, ports will be forwarded from the public IP of the host where it is running.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

Tutorial: Provision a Google Edge Cluster
================================================================================

In this tutorial, we are going to show you how you can access an Alpine VM running inside Google Edge Cluster.

Step 1: Deploy Edge Cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First, you need to create a provision (see :ref:`this guide for more details<first_edge_cluster>`) and wait for it to be ready:

.. prompt:: bash $ auto

    $ oneprovision list
    ID NAME            CLUSTERS HOSTS NETWORKS DATASTORES         STAT
     1 google-cluster         1     1        1          2      RUNNING

Step 2: Download Alpine from Marketplace
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ onemarketapp export 'Alpine Linux 3.13' 'Alpine' -d 'google-cluster-image'
    IMAGE
        ID: 0
    VMTEMPLATE
        ID: 0

Step 3: Instantiate the Template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ onetemplate instantiate 'Alpine' --name 'alpine_test' --nic 'google-cluster-public'
    VM ID: 0

Step 4: Connect to the VM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ onevm ssh 'alpine_test'
    localhost:~# cat /etc/os-release
    NAME="Alpine Linux"
    ID=alpine
    VERSION_ID=3.13.3
    PRETTY_NAME="Alpine Linux v3.13"
    HOME_URL="https://alpinelinux.org/"
    BUG_REPORT_URL="https://bugs.alpinelinux.org/"
    localhost:~#

If you check the VM template, you will see the port ranges assigned by OpenNebula:

.. prompt:: bash $ auto

      <EXTERNAL_PORT_RANGE><![CDATA[9001:9100]]></EXTERNAL_PORT_RANGE>
      <INTERNAL_PORT_RANGE><![CDATA[1-100/9001]]></INTERNAL_PORT_RANGE>

As you are using the same public networking in the cluster, these ports will never collide.

You can use the command ``onevm port-forward`` to check which port you need to connect to in order to access services:

.. prompt:: bash $ auto

    $ onevm port-forward 0 80
    35.246.64.97@9080 -> 80

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Google Cluster using OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/google_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
