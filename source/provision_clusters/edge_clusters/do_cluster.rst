.. _do_cluster:

================================================================================
DigitalOcean Edge Cluster
================================================================================

Edge Cluster Types
================================================================================

DigitalOcean supports **Virtual** Edge Clusters, that use a virtual machine instance to create OpenNebula Hosts. Virtual provisions can run the **LXC** or **KVM** hypervisors.

.. important::

    DigitalOcean is not enabled by default, please refer to the :ref:`DigitalOcean provider guide <do_provider>` to enable it.

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

.. warning:: If a VPC is created in an empty region (without any VPC) it becomes the DEFAULT one, and you will not be able to delete it. We recomend to populate the regions with a default VPC, for this default VPC let DigitalOcean pick the address range (recommended option in the DO console).

OpenNebula resources
================================================================================

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each DigitalOcean droplet
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking

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
