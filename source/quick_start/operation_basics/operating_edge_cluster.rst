.. _operating_edge_cluster:

=========================
Operating an Edge Cluster
=========================

In this guide you will see all the resources created in OpenNebula as a part of the Edge Cluster. All the resources has been created using FireEdge OneProvision GUI in AWS.

Cluster
================================================================================

A cluster is the main object that groups all the physical resources and ensures that everything will work correctly, in terms of scheduling and the needed resources.

|image_cluster|

Check :ref:`this link <cluster_guide>` to get a complete vision of cluster management.

Hosts
================================================================================

A host is mainly anything that is able to run a VM, container or Micro VM. It is in charge of executing them and retrieve all the monitoring information. A host have two important attributes:

* ``VM_MAD``: this indicates the virtualization technology that is going to be used.
* ``IM_MAD``: this driver retrieves all the monitoring metrics from the host.

The following screenshot shows the information about the host, important information here is:

* The **state** of the host, as you can see it is in **MONITORED** state, this means the host is correctly monitored.
* The monitor metrics that can be found in attributes list.
* And some extra information like the VMs running on it and those kind of things.

|image_host|

The basic operations you can perform with the host are:

* **Offline**: host is totally offline.
* **Disable**: disable it, e.g to perform maintenance operations.
* **Enable**: enable it, so OpeNnebula monitors it and it comes to MONITORED again.

Check :ref:`this link <host_guide>` to get a complete vision of host management.

Datastores
================================================================================

There are two types of datastores:

* **System**: this datastore contains the information of running VMs, such as disks or context CD-ROM.
* **Image**: this datastore stores the images in your cloud.

Each Edge Cluster contains two datastores, one system and one image. Both of them use the SSH replica driver to decrease VMs deployment time using the cached images.

|image_datastore|

Check :ref:`this link <ds_op>` to get a complete vision of datastore management.

Virtual Networks: Public
================================================================================

A vitual network in OpenNebula basically resembles the physical network on the datacenter. Using this allow VMs to have connectivity between them and with rest of the world. Each Edge Cluster has one public networking with the number of the IPs chosen by the user, this will allow VMs to have public connectivity so the user can connect to them.

|image_public_net|

If you want to add more IPs to the network, you need to follow these steps:

* Click on the virtual network.
* Go to address ranges tab.
* Click on ``+ address range`` button.
* Fill the information according to the following screenshot:

|image_add_ar|

.. note:: You should put your valid provision ID and CIDR.

.. important:: You can only request 1 IP per address range.

Check :ref:`this link <net_guide>` to get a complete vision of virtual network management.

Virtual Networks: Private
================================================================================

A virtual network template contains all the physical information about the network defined by the administrator. Users need to provide only the logical attributes when instantiating it, like the IP or the number of address ranges.

The network uses driver VLXAN - BGP EVPN:

|image_private_net|

In order to instantiate it, you need to follow these steps:

* Click on the virtual network template.
* Click on ``instantiate`` button.
* Click on ``+ address range`` to add all the address ranges you need.

Check :ref:`this link <vn_templates>` to get a complete vision of virtual network templates management.

.. |image_cluster| image:: /images/edge_cluster.png
.. |image_host| image:: /images/edge_host.png
.. |image_datastore| image:: /images/edge_datastore.png
.. |image_public_net| image:: /images/edge_public_net.png
.. |image_add_ar| image:: /images/edge_add_ar.png
.. |image_private_net| image:: /images/edge_private_net.png
