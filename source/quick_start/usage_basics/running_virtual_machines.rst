.. _running_virtual_machines:

========================
Running Virtual Machines
========================

.. important:: This guide uses a metal Edge Cluster and KVM as *virtualization* technology, but it **also applies** to metal Edge Clusters running LXC.

OpenNebula Systems maintains a curated set of Virtual Machines in the `public marketplace <http://marketplace.opennebula.io>`__. We are going to use the WordPress appliance to try out our brand new cloud.

.. warning:: In order to deploy VMs, you need a metal KVM Edge Cluster. You can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and kvm hypervisor. If you are planning to go all the way through the quick start guide (i.e., launching a L8s cluster next), make sure you request two public IPs.

We are going to assume the Edge Cluster naming schema "metal-kvm-aws-cluster".

Step 1. Download the image from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for WordPress. Select it and click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|wordpress_marketplace|

Now you need to select a datastore. For efficiency, and taking into account we are only going to run this appliaction in the OpenNebula cluster created in "Operations Basics", select the aws-cluster-Images Datastore.

|aws_cluster_images_datastore|

The appliance will be ready when the image in ``Storage --> Images`` moves to READY from its LOCKED state.

.. |wordpress_marketplace| image:: /images/wordpress_marketplace.png
.. |aws_cluster_images_datastore| image:: /images/aws_cluster_images_datastore.png

Step 2. Instantiate the VM
~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> VMs`` tab and select the "Service WordPress - KVM" VM Template (that should one of two available, along with the default CentOS 7 pulled from the Marketplace by miniONE). Click on Instantiate.

Feel free to modify the capacity and input data to configure the WordPress service. A required step is clicking on Network and selecting the aws-cluster-public network.

|select_aws_cluster_public_network|

Now proceed to ``Instances --> VMs`` and wait for the only VM there to get into RUNNING state.

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.

.. |select_aws_cluster_public_network| image:: /images/select_aws_cluster_public_network.png

Step 3. Connect to WordPress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the public IP of the VM, which is highlighted in bold. You should only have one bold IP in that VM. Simply enter that in a new tab in your browser and you'll be greeted by the famous five minute WordPress installation process! That's it, you have a working OpenNebula cloud. Congrats!

|wordpress_install_page|

.. |wordpress_install_page| image:: /images/wordpress_install_page.png
