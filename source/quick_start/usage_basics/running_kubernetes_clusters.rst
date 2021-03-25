.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System marketplace there are also services available that lets you deploy a multi-VM application. In this exercise we are going to import a Kubernetes cluster service and launch a Kubernetes cluster with it.

We need a metal KVM edge cluster for this. If you haven't already done so, you can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and kvm hypervisor. Make sure you request two public IPs.

We are going to assume the edge cluster naming schema "metal-kvm-aws-cluster".

Step 1. Download the OneFlow Service from the marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for Kubernetes. Select the "Service Kubernetes X.XX for OneFlow - KVM" and click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|kubernetes_marketplace|

Now you need to select a datastore, select the metal-kvm-aws-cluster-images datastore.

|metal_kvm_aws_cluster_images_datastore|

The appliance will be ready when the image in ``Storage --> Images`` gets in READY from LOCKED state.

.. |kubernetes_marketplace| image:: /images/kubernetes_marketplace.png
.. |metal_kvm_aws_cluster_images_datastore| image:: /images/metal_kvm_aws_cluster_images_datastore.png

Step 2. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> Services`` tab and select the "Service Kubernetes 1.18 for OneFlow - KVM" Service Template (that should be the only one available``). Click on "+" and then Instantiate.

A required step is clicking on Network and selecting the metal-kvm-aws-cluster-public network.

|select_metal_aws_cluster_public_network|

Feel free to modify the capacity and to input data to configure the Kubernetes cluster.

|configure_kubernetes_cluster|

Now proceed to ``Instances --> Services`` and wait for the only Service there to get into RUNNING state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. |select_metal_aws_cluster_public_network| image:: /images/select_metal_aws_cluster_public_network.png
.. |configure_kubernetes_cluster| image:: /images/configure_kubertes_cluster.png

Step 3. Validate the Kubernetes cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
