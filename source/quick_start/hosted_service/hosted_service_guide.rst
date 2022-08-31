.. _hosted_service_guide:

=====================
Hosted Service Guide
=====================

This guide will walk you through the steps to request, setup and manage an OpenNebula Hosted Environment; to provision new resources and to create an environment for your cloud and edge computing needs.

The OpenNebula Hosted Service allows users to try OpenNebula on **KVM**, **LXC** and **Firecracker** for the execution of virtual 
machines, application containers and Kubernetes clusters. 

OpenNebula hosted service provides two tools to create and manage resources and clusters:

  - **Sunstone**, a web-based UI that can be used by both administrators and end users to manage in one central and uniform point all the resources 
  - **FireEdge**, a web-based UI that is used to provision OpenNebula Clusters on public cloud using different providers (AWS, Equinix, Vultr, Digital Ocean, Google) and on-premise resources. 

.. note::

    The OpenNebula Hosted Service does not offer support for VMWare resources. 
 
.. note:: 

    OpenNebula Hosted Service is currently available as a technology preview for evaluation and PoC purposes.

Request a PoC
=============

In order to request a PoC, you have to fill the following `form <https://opennebula.io/request-a-hosted-poc-with-opennebula>`_. 

Once you fill the form, you will receive an email containing information on how to connect to **Sunstone** and **FireEdge** to manage your cloud environment and create edge resources.

.. note::
    
    When filling up the form, you have to choose a name for the subdomain. 
    
    For the rest of the guide we assume that the name of the subdomain is *poc* (i.e. the OpenNebula hosted environment will be available at ``poc.opennebula.cloud``). You have to replace *poc* with your *subdomain* in the guide.

First Setup
============

First you need to login to Sunstone. 

|sunstone_login|

Once you login with the credentials that you have received in your email, for security reasons change the password of admin user. To change the password you have to go to Setting Tab. 
 
|sunstone_change_password|
 
As an alternative to using the GUIs, you can use the :ref:`OpenNebula Command Line Interface (CLI) <cli>`. 

In order to use the CLI, you need to install the required dependencies. Make sure you are using the :ref:`OpenNebula repositories <repositories>`, then proceed to install:
 
.. prompt:: yaml $ auto

    # On Debian/Ubuntu
    apt install opennebula-tools opennebula-flow opennebula-provision
    # On Centos
    yum install opennebula opennebula-flow opennebula-provision
 
Create the authentication file one_auth with the admin credentials (replace ``password`` with your admin password).

.. code:: bash

    mkdir -p "$HOME/.one"
    echo 'oneadmin:password' > "$HOME/.one/one_auth"


You should have the following environment variables set, you may want to place them in the ``.bashrc`` of the users' Unix account for convenience:

.. code:: bash

    ONE_XMLRPC=http://poc.opennebula.cloud/xmlrpc
    ONE_FLOW_URL=http://poc.opennebula.cloud:2474


Provisioning Clusters
======================
In this guide :ref:`Operating Edge Clusters <operating_edge_cluster>` you can check all the steps needed to deploy an Edge Cluster. This involves the FireEdge OneProvision GUI and Sunstone to manage the resources created in OpenNebula.

You have to connect to https://poc.opennebula.cloud/fireedge and login using username and password

|fireedge_login|

You can provision resources on different public cloud providers, with the following type of clusters:

.. list-table:: Title
   :widths: 25 25 50
   :header-rows: 1

   * - Providers
     - Metal
     - Virtual
   * - :ref:`Amazon Web Service (AWS) <aws_cluster>`
     - KVM, Firecracker, LXC
     - LXC, Qemu
   * - :ref:`Equinix <equinix_cluster>`
     - KVM, Firecracker, LXC
     - N/A 
   * - :ref:`Google Cloud <google_cluster>` 
     - N/A
     - LXC, Qemu
   * - :ref:`Digital Ocean <do_cluster>`
     - N/A
     - LXC, Qemu
   * - :ref:`Vultr <vultr_cluster>`
     - KVM, Firecracker, LXC
     - LXC, Qemu

You can find more information about the edge cluster in this guide :ref:`Edge Cluster Management <true_hybrid_clusters_deployment>`

You can follow this :ref:`guide <first_edge_cluster>` to provision your first edge cluster on AWS 

FireEdge can be used to provision on-premises resources by using the on-premise driver. OpenNebula requires *root access to the hosts* that are going to be configured using the onprem provider. You need to configure the hosts with root **passwordless SSH** access by adding the ssh public key received by email in the ``authorized_keys`` of the hosts.
Please look at the following :ref:`guide <onprem_cluster>` for more information.

Once you create  a cluster, you can manage it using the Sunstone GUI (https://poc.opennebula.cloud). Please follow this :ref:`guide <operating_edge_cluster>` that explains how to operate an Edge Cluster.

Running Virtual Machine and Applications
========================================
You can refer to :ref:`Usage Basics guide <usage_basics>` to run virtual machines, container-based applications and Kubernetes Clusters on your cloud environment.


.. |sunstone_login| image:: /images/sunstone-login.png
.. |sunstone_change_password| image:: /images/sunstone_settings.png
.. |fireedge_login| image:: /images/fireedge_for_rns.png