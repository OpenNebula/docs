.. _operating_edge_cluster:

=========================
Operating an Edge Cluster
=========================

In this guide you will see all the resources created in OpenNebula as a part of the Edge Cluster. These resources have all been created using FireEdge OneProvision GUI in AWS.

Cluster
================================================================================

A cluster is the main object that groups all the physical resources and ensures that everything will work correctly in terms of scheduling and the resources required.

|image_cluster|

Check :ref:`this link <cluster_guide>` to get a full understanding of cluster management.

Hosts
================================================================================

A Host is mainly anything that is able to run a VM, container or Micro VM. It is in charge of executing them and retrieves all of the monitoring information. A Host has two important attributes:

* ``VM_MAD``: this indicates the virtualization technology that is going to be used.
* ``IM_MAD``: this driver retrieves all the monitoring metrics from the host.

The following screenshot shows the information about the Host. The important information here is:

* The **state** of the Host: as you can see it's in **MONITORED** state, meaning the Host is correctly being monitored.
* The monitor metrics that can be found in the attributes list.
* Extra information, such as the VMs running on it.

|image_host|

The basic operations you can perform with the Host are:

* **Offline**: take the Host totally offline.
* **Disable**: disable it, e.g., to perform maintenance operations.
* **Enable**: enable it, so OpenNebula monitors it and it switches back to MONITORED state.

Check :ref:`this link <hosts>` to get a complete understanding of Host management.

Datastores
================================================================================

There are two types of datastores:

* **System**: this datastore contains the information of running VMs, such as disks or context CD-ROM.
* **Image**: this datastore stores the images in your cloud.

Each Edge Cluster contains two datastores, one system and one image. Both of them use the SSH replica driver to decrease VMs' deployment time using the cached images.

|image_datastore|

Check :ref:`this link <datastores>` to get a sound overview of datastore management.

.. _edge_public:

Virtual Networks: Public
================================================================================

A virtual network in OpenNebula basically resembles the physical network in the datacenter. Virtual Networks allow VMs to have connectivity between them and with the rest of the world. Each Edge Cluster has one public network with the number of the IPs chosen by the user (in FireEdge); this will allow VMs to have public connectivity so the user can connect to them.

|image_public_net|

If you want to add more IPs to the network, you need to follow these steps:

* Click on the virtual network.
* Go to address ranges tab.
* Click on the ``+ address range`` button.
* Fill the information according to the following screenshot:

|image_add_ar|

.. note:: You should put your valid provision ID.

.. important:: You can only request 1 IP per address range.

Check :ref:`this link <net_guide>` to read more about virtual network management.

.. _edge_private:

Virtual Networks: Private
================================================================================

A virtual network template contains all the physical information about the network as defined by the administrator. Users need to provide only the logical attributes when instantiating it, like the IP or the number of address ranges.

The network uses driver VLXAN - BGP EVPN:

|image_private_net|

In order to instantiate it, you need to follow these steps:

* Click on the virtual network template.
* Click on the ``instantiate`` button.
* Click on the ``+ address range`` to add all the address ranges you need.

Check :ref:`this link <vn_templates>` to get a complete picture of virtual network templates management.

.. |image_cluster| image:: /images/edge_cluster.png
.. |image_host| image:: /images/edge_host.png
.. |image_datastore| image:: /images/edge_datastore.png
.. |image_public_net| image:: /images/edge_public_net.png
.. |image_add_ar| image:: /images/edge_add_ar.png
.. |image_private_net| image:: /images/edge_private_net.png
