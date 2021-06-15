.. _do_cluster:

==========================
DigitalOcean Edge Cluster
==========================

DigitalOcean supports **Virtual** Edge Clusters, that use a virtual machine instance to create OpenNebula Hosts. This provision is better suited for PaaS-like workloads. Virtual DigitalOcean Edge Clusters run primarily **LXC** to execute system containers.

DigitalOcean Providers
================================================================================

A DigitalOcean provider contains the credentials to interact with DigitalOcean service and also the region to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* London
* New York (US)
* San Franciso (US)
* Singapur

In order to define a DigitalOcean provider, you need the following information:

* **Credentials**: to authenticate with DigitalOcean service. You need to provide ``token``, check `this guide for more details <https://www.digitalocean.com/community/tutorials/how-to-use-oauth-authentication-with-digitalocean-as-a-user-or-developer>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://docs.digitalocean.com/products/platform/availability-matrix/>`__.

How to Add a New DigitalOcean Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a new provider you need a YAML template file with the following information:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'digitalocean-nyc3'

    description: 'cluster on DigitalOcean in Amsterdam 3'
    provider: 'digitalocean'

    plain:
      image: 'DIGITALOCEAN'
      location_key: 'region'
      provision_type: 'virtual'

    connection:
      token: 'DigitalOcean token'
      region: 'ams3'

    inputs:
    - name: 'digitalocean_droplet'
        type: 'list'
        options:
        - 'centos-8-x64'


Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/digitalocean``. You just need to enter valid connection ``token``.

How to Customize an Existing Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The provider information is stored in the OpenNebula database and it can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there.

DigitalOcean Edge Cluster Implementation
================================================================================

An Edge Cluster in DigitalOcean creates the following resources:

* **DigitalOcean droplets**: will be the OpenNebula hosts to run virtual machines.
* **DigitalOcean VPC**: it creates an isolated virtual network for all the deployed resources.
* **DigitalOcean firewall**: by default all the traffic is allowed, you can later setup custom Security Groups through the OpenNebula interface.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using port forwarding between the host and the VM. Each time a network is attached to the virtual machine, ports will be forwarded from the public IP of the host (droplet) where it is running.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|


Tutorial: Provision a Google Edge Cluster
================================================================================


Tutorial: Provision a Digital Ocean Edge Cluster
================================================================================

In this tutorial, we are going to show you how you can access an Alpine VM running inside DigitalOcean Edge Cluster.

Step 1: Deploy Edge Cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First you need to create a provision (see :ref:`this guide for more details<first_edge_cluster>`) and wait for it to be ready:

.. prompt:: bash $ auto

    $ oneprovision list
    ID NAME                  CLUSTERS HOSTS NETWORKS DATASTORES         STAT
     1 digitalocean-cluster         1     1        1          2      RUNNING

Step 2: Download Alpine From Marketplace
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ onemarketapp export 'Alpine Linux 3.13' 'Alpine' -d 'digitalocean-cluster-image'
    IMAGE
        ID: 0
    VMTEMPLATE
        ID: 0

Step 3: Instantiate the Template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ onetemplate instantiate 'Alpine' --name 'alpine_test' --nic 'digitalocean-cluster-public'
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

As you are using the same public networking in the cluster, these ports will never collision.

You can use the command ``onevm port-forward`` to check what port you need to connect to access services:

.. prompt:: bash $ auto

    $ onevm port-forward 0 80
    35.246.64.97@9080 -> 80

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

|image_fireedge|

.. |image_fireedge| image:: /images/oneprovision_fireedge.png
.. |image_cluster| image:: /images/digitalocean_deployment.png
