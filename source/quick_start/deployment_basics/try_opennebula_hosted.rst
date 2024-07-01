.. _try_opennebula_hosted:

====================================================
Try an OpenNebula Front-end on Hosted Infrastructure
====================================================

For evaluation purposes, you can request and evaluate a complete OpenNebula Front-end running on infrastructure hosted by OpenNebula. The OpenNebula Hosted Service Front-end allows you to try OpenNebula on the **KVM** hypervisor, to configure it to your needs, and to provision new resources in the cloud and at the edge. You can then run and manage Virtual Machines and Kubernetes clusters.

A hosted OpenNebula installation offers two tools to create and manage resources and clusters:

    * FireEdge, the new web-based GUI used to define, provision and manage infrastructure resources
    * OpenNebula's command-line interface (CLI)

.. note::

    Please note that the OpenNebula Hosted Service is available as a technology preview for purposes of proof-of-concept (PoC) and evaluation. It currently does not offer support for VMware resources.
    
This page describes how to request, configure and manage an OpenNebula hosted environment.

    #. Request a PoC
    #. Configure Access
    #. (Optional): Install the CLI


Step 1: Request a PoC
=====================

To request the OpenNebula Hosted service, you will need to `request a PoC <https://opennebula.io/request-a-hosted-poc-with-opennebula>`_ by completing the required form.

When completing the form, please provide the desired name for the subdomain that will be used to host you OpenNebula cloud. For the rest of this guide, we will assume that the subdomain is ``poc``, i.e. that the OpenNebula hosted environment will be available at ``poc.opennebula.cloud``. Throughout this guide, replace ``poc`` with the actual name of your subdomain.

After filling in the form, you will receive an email with your login information for connecting to **FireEdge**. Using FireEdge, you can manage your cloud environment and provision resources for running workloads.

Step 2: Configure Access
========================

Log in to the FireEdge GUI, using the credentials you received by email.

|sunstone_login|

Step 2.1: Change your Security Credentials
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
For security reasons, change the password that you received by email. To change the password you have to go to ``Settings`` Tab.

.. +add screenshot

|sunstone_change_password|

Step 2.2: Add your SSH Key
^^^^^^^^^^^^^^^^^^^^^^^^^^

You should also add your public SSH key in order to be able to connect to the resources that will be created in your cloud environment.

.. +add description

Step 3 (Optional): Install the CLI
==================================

Besides the FireEdge GUI, you can also use the :ref:`OpenNebula Command Line Interface (CLI) <cli>`, to configure the Front-end, and to create and manage cloud infrastructure resources.

The CLI comprises a set of command-line tools which are distributed in three software packages. To use the CLI, you need to install these software packages on a supported operating system. Currently, the supported operating systems are the following Linux distributions:

   * AlmaLinux >= 8, 9
   * CentOS >= 7, 8
   * Red Hat Enterprise Linux >= 7, 8, 9
   * Debian >= 10, 11, 128
   * Ubuntu >= 148.04, 20.04, 22.04, 24.04

To install the CLI, first add the :ref:`OpenNebula repositories <repositories>`, then follow your distribution's normal procedure to install the following packages:

    * ``opennebula-tools``
    * ``opennebula-flow``
    * ``opennebula-provision``

For example, in Debian/Ubuntu, run (as root):

.. code::

        apt install opennebula-tools opennebula-flow opennebula-provision

Step 3.1. Configure the CLI User
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The command-line tools run as the OpenNebula user ``oneadmin``. To log into the Front-end, you need to create an authentication file with the user's log in credentials.

In the ``oneadmin`` user's home directory, create a directory called ``.one``, and a file called ``one_auth``, with the following contents:

.. code:: bash

    one:<your password>

For example, run as Linux user ``oneadmin``:

.. code:: bash

    mkdir -p "$HOME/.one"
    echo 'one:password' > "$HOME/.one/one_auth"

For more information on user accounts in OpenNebula, see :doc:`Managing Users <../../management_and_operations/users_groups_management/manage_users>`.

Step 3.2. Define the CLI Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following variables must be set in the ``oneadmin`` user's environment:

.. code::

    ONE_XMLRPC=http://<your subdomain>.opennebula.cloud/xmlrpc
    ONEFLOW_URL=http://<your subdomain>.opennebula.cloud:2474

For convenience, we recommend you define these variables in the ``.bashrc`` file of the user's ``$HOME`` directory.


Exploring FireEdge and the Hosted Infrastructure
================================================

The cloud environment provided in the hosted infrastructure includes two OpenNebula hosts, already configured and ready to deploy VMs. 

|hosted_nodes|

Bear in mind that in this evaluation environment, the hosts use QEMU virtualization to run the VMs, with the consequent loss of efficiency and performance. This environment is not suitable for production; however, it is an easy-to-use tool for testing and getting a first experience in the management and operation of OpenNebula.

Provisioning Additional KVM Clusters
====================================

.. warning::

   The Hosted Cloud PoC provides users with an OpenNebula front-end that is hosted and paid for by OpenNebula Systems. Compute nodes can be provisioned using AWS and Equinix Metal public cloud resources, for which users are responsible via user-owned accounts.

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
.. |hosted_nodes| image:: /images/hosted_nodes.png
