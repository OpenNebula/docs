.. _running_kubernetes:

============================
Running Kubernetes Clusters
============================

In order to successfully launch a Kubernetes cluster we need more computing power that the one provided by the Virtual Edge Cluster deployed in "Operations Basics". If you haven't done so already, please repeat the same steps but add a "Metal" type Provision and add at least two public IPs. We are going to assume the same naming schema "aws-cluster".

Step 1. Download the OneFlow Service from the marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for Kubernetes. Select the "Service Kubernetes X.XX for OneFlow - KVM" and click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|kubernetes_marketplace|

Now you need to select a datastore. For efficiency, and taking into account we are only going to run this appliaction in the OpenNeblua cluster created in "Operations Basics", select the aws-cluster-images datastore.

|aws_cluster_images_datastore|

The appliance will be ready when the image in ``Storage --> Images`` gets in READY from LOCKED state.

.. |kubernetes_marketplace| image:: /images/kubernetes_marketplace.png
.. |aws_cluster_images_datastore| image:: /images/aws_cluster_images_datastore.png

Step 2. Instantiate the VM
~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> VMs`` tab and select the "Service WordPress - KVM" VM Template (that should be the only one available``). Click on Instantiate.

Feel free to modify the capacity and to input data to configure the WordPress service. A required step is clicking on Network and selecting the aws-cluster-public network.

|select_aws_cluster_public_network|

Now proceed to ``Instances --> VMs`` and wait for the only VM there to get into RUNNING state.

.. |select_aws_cluster_public_network| image:: /images/select_aws_cluster_public_network.png

Step 3. Connect to WordPress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the public IP of the VM, which is highlighted in bold. You should only have one bold IP in that VM. Simply enter that in a new tab in your browser and you'll be greeted by the famous 5 min WordPress installation process! That's it, you have a working OpenNebula cloud. Congrats!

|wordpress_install_page|

.. |wordpress_install_page| image:: /images/wordpress_install_page.png

Containers
----------------
