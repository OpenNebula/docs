.. _rancher_integration:

================================================================================
Rancher Integration
================================================================================

`Rancher <https://rancher.com/>`_ is an open source software stack to run and manage containers and `Kubernetes <https://kubernetes.io/>`_ clusters while providing other integrated tools to enhance DevOps workflows.

Rancher Installation
--------------------------------------------------------------------------------
For full information regarding the Rancher installation you can refer to the official `documentation <https://rancher.com/docs/rancher/v2.x/en/installation>`__.

You can install Rancher within your OpenNebula cloud by using one of the following options:

**Docker Install**

You need to create a VM with OpenNebula's Docker appliance, or by using OpenNebula :ref:`Docker Machine driver <docker_machine>`. You can find information about this step here :ref:`Step 3 - Start your First Docker Host <start_your_first_docker_host>`.

Once the machine is created, you can proceed to install the Rancher server on the Docker host using the following command:

.. prompt:: bash # auto

    $ docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:latest

For all the different options to run Rancher on a single Docker Host, you can check the `Rancher documentation <https://rancher.com/docs/rancher/v2.x/en/installation/other-installation-methods/single-node-docker/>`_

**Kubernetes Install**

For production environments, it is recommended to install Rancher in a high-availability configuration. Rancher can be installed on a Kubernetes Single Node or on a multiple-node Kubernetes Clusters using `Helm <https://helm.sh>`_.

Within OpenNebula you can deploy Kubernetes Clusters by instantiating the :ref:`OpenNebula Kubernetes Appliance <running_kubernetes_clusters>` or by instantiating the :ref:`OpenNebula K3s Appliance <running_k3s_clusters>`.

Once you setup a Kubernetes cluster within OpenNebula you can follow the documentation to `install Rancher on a Kubernetes Cluster <https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/helm-rancher/>`_ by using Helm.

**Adding OpenNebula Provider to Rancher**

Once Rancher is up and running, you can connect to it and bring up the Rancher UI. 

|rancher_drivers|

To add OpenNebula as a provider to Rancher, we need to add the OpenNebula docker machine driver to the Rancher Node Drivers that are used to provision hosts which Rancher uses to launch and manage Kubernetes clusters.

|rancher_node_drivers|

A Linux binary of the OpenNebula machine driver is available at https://downloads.opennebula.io/packages/opennebula-6.1.80/opennebula-docker-machine-6.1.80.tar.gz

|add_opennebula_rancher_node_driver|

Once you added the OpenNebula docker machine driver, it should be active and available in Rancher for creating Kubernetes Clusters.

**Create OpenNebula Kubernetes Clusters**

In order to deploy Kubernetes clusters with Rancher on OpenNebula, you need to add node templates

|add_opennebula_rancher_node_template|

In the node template, select the OpenNebula driver, and insert in the available options at the least the following ones:

* Authentication: user, password
* OpenNebula endpoint: xmlrpcurl (http://one:2633/RPC2)
* ImageID
* NetworkID

Once you have created the OpenNebula node templates

|added_opennebula_rancher_node_template|

you can proceed to create the first OpenNebula Kubernetes cluster in Rancher

|add_opennebula_rancher_cluster|

Once the cluster has been provisioned, you can deploy containers on it using Rancher.

.. |rancher_drivers| image:: /images/rancher_drivers.png
.. |rancher_node_drivers| image:: /images/rancher_node_drivers.png
.. |add_opennebula_rancher_node_driver| image:: /images/add_opennebula_rancher_node_driver.png
.. |add_opennebula_rancher_node_template| image:: /images/add_opennebula_rancher_node_template.png
.. |added_opennebula_rancher_node_template| image:: /images/added_opennebula_rancher_node_templates.png
.. |add_opennebula_rancher_cluster| image:: /images/add_opennebula_rancher_cluster.png

