.. _try_opennebula_hosted:

====================================================
Try an OpenNebula Front-end on Hosted Infrastructure
====================================================

For evaluation purposes, you can request and evaluate a complete OpenNebula Front-end running on infrastructure hosted by OpenNebula. The **OpenNebula Hosted Service** allows you to try OpenNebula on the **KVM** hypervisor, to configure it to your needs, and to provision new resources in the cloud and at the edge. You can then run and manage Virtual Machines and Kubernetes clusters.

A hosted OpenNebula installation offers two tools to create and manage resources and clusters:

    * **Sunstone**, a web-based UI used to define, provision and manage infrastructure resources
    * OpenNebula’s command-line interface (CLI)

.. note::

    Please note that the OpenNebula Hosted Service is available as a technology preview for purposes of proof-of-concept (PoC) and evaluation. It currently does not offer support for VMware resources.
    
This page describes how to request, configure and manage an OpenNebula hosted environment.

    #. Request a PoC
    #. Configure Access
    #. (Optional): Install the CLI


Step 1: Request a PoC
=====================

To request the OpenNebula Hosted service, you will need to `request a PoC <https://opennebula.io/request-a-hosted-poc-with-opennebula>`_ by completing the required form.

When completing the form, please provide the desired name for the subdomain that will be used to host your OpenNebula cloud. In this guide, we will assume that the subdomain is ``poc``, i.e. that the OpenNebula hosted environment will be available at ``poc.opennebula.cloud``. Throughout this guide, replace ``poc`` with the actual name of your subdomain.

After filling in the form, you will receive an email with your login information for connecting to **Sunstone**, the web-based UI where you can manage your cloud environment.

Step 2: Configure Access to Your Cloud
===========================================

Change the User Password
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before trying out the deployment, for security reasons we’ll change the password that you received by email.

To change the password, fire up a browser and go the Sunstone URL that you received by email. You should see the Sunstone login screen:

.. image:: /images/sunstone-login.png
    :scale: 50%
    :align: center

|

Log in with the username and password that you received by email. Sunstone will display the **Dashboard**:

.. image:: /images/fireedge_sunstone_admin_dashboard.png
    :scale: 50%
    :align: center

|

Open the left-hand pane (by hovering your mouse over it) and select **System**, then **Users**:

.. image:: /images/sunstone-system-users.png
    :scale: 50%
    :align: center

|

Select the user you want to update the password for. Then, in the user’s information pane click **Authentication**.

Enter your password in the ``Password`` field, then click **Save Changes**.

.. image:: /images/sunstone_change_password.png
..    :scale: 60%
..    :align: center

|

Add SSH Keys
^^^^^^^^^^^^^^^^^^^^^^^^^^

To access resources you create on your OpenNebula cloud, you need to add your public SSH key. The OpenNebula Front-end will distribute your key to VMs that you create on your cloud.

You can add your SSH key in the user’s **Authentication** tab, shown above. Click the icon next to **Edit Public SSH Key** and copy-paste your key into the field, then click **Save Changes**.

.. tip::

    You can add the SSH key of any user on your system. To generate an SSH key, use the ``ssh-keygen`` command.
    
    When logging in to a VM, you will log in as the ``root`` user.

Step 3. (Optional) Install the CLI
==================================

Besides the Sunstone GUI, you can also use the :ref:`OpenNebula Command Line Interface (CLI) <cli>`, to configure the Front-end, and to create and manage cloud infrastructure resources. (If you do not wish to install the CLI tools or you plan to do so later, you can :ref:`Skip to Step 4 <explore>`.)

The CLI comprises a set of command-line tools which are distributed in three software packages. Once installed on your local machine, you can use these tools to control the remote OpenNebula Front-end on hosted infrastructure.

To install the CLI tools, you need to install the software packages on a supported operating system. Currently, the supported operating systems are the following Linux distributions:

   * AlmaLinux: 8, 9
   * CentOS: 7, 8
   * Red Hat Enterprise Linux: 7, 8, 9
   * Debian: 10, 11, 128
   * Ubuntu: 148.04, 20.04, 22.04, 24.04

Step 3.1. Add the Software Repositories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To install the CLI, first add the :ref:`OpenNebula repositories <repositories>`. Then, follow your distribution’s normal procedure to install the following packages:

    * ``opennebula-tools``
    * ``opennebula-flow``
    * ``opennebula-provision``

For example, in Debian/Ubuntu, run (as root):

.. code::

        apt install opennebula-tools opennebula-flow opennebula-provision

Step 3.2. Configure Credentials for the CLI User
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To communicate with the Front-end, the CLI commands need the password for the OpenNebula user, that you received by email. This password must be stored in the file ``$HOME/.one/one_auth``, with the following format:

.. code:: bash

    one:<your password>

You can create the file with the below commands, replacing “password” with your actual password:

.. code:: bash

    mkdir -p "$HOME/.one"
    echo 'one:password' > "$HOME/.one/one_auth"

.. tip::

    For more information on user accounts in OpenNebula, see :doc:`Managing Users <../../management_and_operations/users_groups_management/manage_users>`.
    


Step 3.3. Define the CLI Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To ensure proper operation of the CLI tools, you will need to set the variables ``ONE_XMLRPC`` and ``ONEFLOW_URL`` on your shell environment, with the following contents:

.. code::

    ONE_XMLRPC=http://<your subdomain>.opennebula.cloud/xmlrpc
    ONEFLOW_URL=http://<your subdomain>.opennebula.cloud:2474

For convenience, we recommend you define these variables in the ``.bashrc`` file of your user’s ``$HOME`` directory.

.. tip::

    After adding the variables to ``.bashrc``, you can export them directly to your environment (i.e. without logging out and back in) by running ``source ~/.bashrc``.

.. _explore:

Exploring Sunstone and the Hosted Infrastructure
================================================

The cloud environment provided in the hosted infrastructure includes two OpenNebula hosts, already configured and ready to deploy VMs. 

.. image:: /images/hosted_nodes.png
    :align: center

|

In this evaluation environment, the hosts use QEMU virtualization to run the VMs, with the consequent loss of efficiency and performance. This environment is not suitable for production; however, it is an easy-to-use tool for testing and getting a first experience in the management and operation of OpenNebula.

Provisioning Additional KVM Clusters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can provision new resources to your OpenNebula cloud, either on-premises or on public cloud providers such as AWS or Equinix. Bear in mind that provisioning additional infrastructure on public cloud providers may entail additional fees and charges billed to your accounts on these providers.

You can quickly and easily add new resources using the Sunstone Provision GUI. Log in to the GUI by pointing your browser to the following URL:

.. code::

    https://<your subdomain>/fireedge/provision

  
For example:

.. code::

    https://poc.opennebula.cloud/fireedge/provision

Then, log in with your username and password.

You should see the Sunstone OneProvision Dashboard:

.. image:: /images/fireedge_for_rns.png
    :align: center

|

Here you can add infrastructure providers and resources, with just a few clicks. For instance, to provision your first edge cluster on AWS, you can follow the :doc:`Provisioning an Edge Cluster Guide <../operation_basics/provisioning_edge_cluster>`.

.. warning::

   The Hosted Cloud PoC provides you with an OpenNebula Front-end that is hosted and paid for by OpenNebula Systems. If you provision resources on the OpenNebula cloud using public cloud providers, you will need appropriate user accounts on these platforms, which may apply additional charges for your infrastructure deployment.

Running Virtual Machines and Kubernetes Clusters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Once you have provisioned resources, you can refer to the :ref:`Usage Basics Guide <usage_basics>` to run virtual machines and Kubernetes Clusters in your cloud environment.

.. |sunstone_login| image:: /images/sunstone-login.png
.. |sunstone_change_password| image:: /images/sunstone_change_password.png
.. |sunstone_add_ssh_key| image:: /images/sunstone-add_public_ssh_key2.png
.. |fireedge_login| image:: /images/fireedge_for_rns.png
.. |hosted_nodes| image:: /images/hosted_nodes.png
.. |sunstone_users| image:: /images/sunstone-system-users.png
