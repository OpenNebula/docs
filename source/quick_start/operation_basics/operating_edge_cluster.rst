.. _operating_edge_cluster:

=========================
Operating an Edge Cluster
=========================

In :ref:`Provisioning an Edge Cluster <first_edge_cluster>`, we used the OneProvision GUI to create an Edge Cluster in AWS.

This page provides an overview of all resources created in OpenNebula during that deployment, which together comprise the Edge Cluster.

All resources in the Edge Cluster are created from templates. Templates contain all of the information for the physical features of resources. For some templates, such as the network templates, users need to provide the logical attributes at the moment of instantiating the template, such as the IP or the address range.

Below you will find brief descriptions for the resources that comprise the Edge Cluster, with examples of their visual representation in the Sunstone UI and links to complete references for each resource.

Cluster
================================================================================

A cluster is the main object that groups all the physical resources and ensures that everything will work correctly in terms of scheduling and the resources required.

|image_cluster|

For a complete overview of Cluster management, see :ref:`Clusters <cluster_guide>`.

Hosts
================================================================================

A Host is any entity that is capable of running a VM or a container. Besides running them, it retrieves all monitoring information. A Host has two important attributes:

* ``VM_MAD``: the virtualization technology used on the Host.
* ``IM_MAD``: the driver that retrieves all monitoring metrics from the Host.

The screenshot below displays the information about the Host. The important information here is:

* The **State** of the Host: **MONITORED** indicates that the Host is currently being monitored.
* The **Attributes** section displays the monitoring metrics.
* The tabs to the right of the **Info** tab display additional information, such as the VMs running on the Host.

|image_host|

The basic operations you can perform on the Host are:

* **Offline**: take the Host totally offline.
* **Disable**: disable the Host, for example to perform maintenance operations.
* **Enable**: enable the Host, so that OpenNebula monitors it and it switches back to MONITORED state.

For a complete overview of Hosts management, see :ref:`Hists <hosts>`.

Datastores
================================================================================

There are two types of datastores:

* **System**: contains the information of running VMs, such as disks or context CD-ROM.
* **Image**: stores the images in your cloud.

Each Edge Cluster contains two datastores: one system and one image. Both of them use the SSH replica driver to decrease VMs’ deployment time using the images cached on the datastores.

|image_datastore|

For a complete overview of Datastore management, see :ref:`Datastores <datastores>`.

.. _edge_public:

Virtual Networks: Public
================================================================================

A virtual network in OpenNebula basically resembles the physical network in the data center. Virtual Networks allow VMs to have connectivity between them and with the rest of the world. Each Edge Cluster has one public network with the number of the IPs selected by the user in Sunstone. This allows VMs to have public connectivity so the user can connect to them.

|image_public_net|

.. _edge_private:

Virtual Networks: Private
================================================================================

As with the public network, a private network needs user input before instantiation, such as the IP or number of address ranges.

The network uses driver VXLAN - BGP EVPN:

|image_private_net|

For a complete overview, see :ref:`Virtual Network Templates <vn_templates>`.

.. |image_cluster| image:: /images/edge_cluster.png
.. |image_host| image:: /images/edge_host.png
.. |image_datastore| image:: /images/edge_datastore.png
.. |image_public_net| image:: /images/edge_public_net.png
.. |image_add_ar| image:: /images/edge_add_ar.png
.. |image_private_net| image:: /images/edge_private_net.png
