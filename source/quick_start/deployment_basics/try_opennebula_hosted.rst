.. _try_opennebula_hosted:

===============================
Try OpenNebula Hosted Front-end
===============================

This guide will walk you through the steps to request, setup and manage an OpenNebula Hosted Environment, to provision new resources and to create an environment for your cloud and edge computing needs.

The OpenNebula Hosted service allows corporate users to try OpenNebula on **KVM** for the execution of virtual machines and Kubernetes clusters.

OpenNebula Hosted service provides two tools to create and manage resources and clusters:

  - **Sunstone**, a web-based UI that can be used by both administrators and end users to manage in one central and uniform point all the resources
  - **FireEdge**, a web-based UI that is used to provision OpenNebula Clusters on public cloud using different providers (AWS, Equinix) and on-premise resources.

.. note::

    The OpenNebula Hosted Service does not offer support for VMware resources. 
 
.. note:: 

    OpenNebula Hosted Service is currently available as a technology preview for evaluation and PoC purposes.

Request a PoC
=============

In order to request a PoC, you have to fill the following `form <https://opennebula.io/request-a-hosted-poc-with-opennebula>`_.

Once you fill the form, you will receive an email containing information on how to connect to **Sunstone** and **FireEdge** to manage your cloud environment and provision resources for running your workloads (Virtual Machines and/or Kubernetes Clusters).

.. note::

    When filling up the form, you have to choose a name for the subdomain.

    For the rest of the guide we assume that the name of the subdomain is *poc* (i.e. the OpenNebula hosted environment will be available at ``poc.opennebula.cloud``). You have to replace *poc* with your *subdomain* in the guide.

First Setup
============

First you need to login to Sunstone.

|sunstone_login|

Once you login with the credentials that you have received in your email, for security reasons change your password that you have received by email. To change the password you have to go to ``Settings`` Tab.

|sunstone_change_password|

You should also add your public SSH key in order to be able to connect to the resources that will be created in your cloud environment.

As an alternative to using the GUIs, you can use the :ref:`OpenNebula Command Line Interface (CLI) <cli>`.

In order to use the CLI, you need to install the required dependencies. Make sure you are using the :ref:`OpenNebula repositories <repositories>`, then proceed to install:

.. prompt:: yaml $ auto

    # On Debian/Ubuntu
    apt install opennebula-tools opennebula-flow opennebula-provision
    # On Centos
    yum install opennebula opennebula-flow opennebula-provision

Create the authentication file one_auth with the admin credentials (replace ``password`` with your password).

.. code:: bash

    mkdir -p "$HOME/.one"
    echo 'one:password' > "$HOME/.one/one_auth"


You should have the following environment variables set, you may want to place them in the ``.bashrc`` of the users' Unix account for convenience:

.. code:: bash

    ONE_XMLRPC=http://poc.opennebula.cloud/xmlrpc
    ONEFLOW_URL=http://poc.opennebula.cloud:2474


Provisioning KVM Clusters
=========================

In order to provision new clusters within your cloud environment, you have to connect to https://poc.opennebula.cloud/fireedge/provision and login using username and password

|fireedge_login|

You can provision KVM clusters on different public cloud providers (AWS and Equinix) or using on-premise resources.

You can follow this :ref:`guide <first_edge_cluster>` to provision your first edge cluster on AWS.

Once you create  a cluster, you can manage it using the Sunstone GUI (https://poc.opennebula.cloud). Please follow this :ref:`guide <operating_edge_cluster>` that explains how to operate an Edge Cluster.

Running Virtual Machines and Kubernetes Clusters
=================================================
Once you have provisioned resources, you can refer to :ref:`Usage Basics guide <usage_basics>` to run virtual machines and Kubernetes Clusters in your cloud environment.

.. |sunstone_login| image:: /images/sunstone-login.png
.. |sunstone_change_password| image:: /images/sunstone_settings.png
.. |fireedge_login| image:: /images/fireedge_for_rns.png
