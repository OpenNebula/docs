
.. _first_edge_cluster:

============================
Provisioning an Edge Cluster
============================

In the first tutorial of this Quick Start Guide, we installed an :ref:`OpenNebula Front-end <deployment_basics>` on AWS. In this tutorial, we’ll use that Front-end to provision an **Edge Cluster** on AWS, using the Sunstone GUI for the whole process, in just a few clicks.

The edge cluster we’ll create includes a KVM hypervisor. It’s a suitable platform for deploying both Virtual Machines and Kubernetes clusters, as described in the :ref:`Usage Basics section <usage_basics>`.

To create the cluster, we’ll follow these high-level steps:

    #. Configure AWS.
    #. Create an AWS Provider in OpenNebula.
    #. Provision a Metal Edge Cluster.
    #. Validate the New Infrastructure.

.. important:: As mentioned above, in this tutorial we’ll deploy using the OpenNebula Front-end created and deployed on AWS :ref:`previously <deployment_basics>` in this Quick Start Guide. To complete this tutorial, you need the OpenNebula Front-end up and running, and access to its Sunstone web UI.

.. _brief_overview:

Brief Overview of the Provision
===============================

This section explains what OpenNebula creates behind the scenes when provisioning an Edge Cluster.

OpenNebula provides a ready-to-use specification for an Edge Cluster, which is comprised of resources in OpenNebula and their corresponding resources in AWS. Together, these resources provide the functionality for running with a minimal footprint at edge locations. During provisioning, OpenNebula creates all of the cluster’s resources in OpenNebula and, with the aid of Terraform, their corresponding objects on AWS.

The following resources are created *in OpenNebula*:

    * **Cluster**: each provision creates one cluster. There is a one-to-one relationship between the provision and the cluster, so each provision can only have one cluster.
    * **Datastore**: each provision deploys two datastores, for the system and the image. Datastores for edge clusters are based on OpenNebula’s :ref:`Local Storage datastores <local_ds>`; datastores for HCI clusters are based on Ceph.
    * **Hosts**: After provisioning, you can deploy as many as desired, to run VMs.
    * **Virtual Networks**: To ensure that VMs have public connectivity, the provision includes a pre-configured private network, and a public network that pre-allocates elastic IPs.

To create the OpenNebula hosts and ensure connectivity, OpenNebula creates the following resources *in AWS*:

    * A **Virtual Private Cloud** (VPC) to allocate AWS instances as OpenNebula hosts.
    * A **CIDR block of IPs** to assign secondary IPs to the hosts, and to allocate elastic IPs.
    * An **Internet Gateway** to provide internet access for the hosts and VMs.
    * A **routing table** for directing network traffic between these elements.

.. note:: Sunstone will request Elastic IPs for the public IPs you request. If you receive an error message about not being able to request more IPs when creating a provision, check the `limits of your account <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html>`__ in your zone.

In the following steps, we’ll use the Sunstone GUI to create a provider and provision a Metal Edge Cluster in AWS.

Step 1: Configure AWS
=====================

.. important:: Creating an AWS account is covered in the previous tutorial in this Quick Start Guide, on installing an :ref:`OpenNebula Front-end on AWS <try_opennebula_on_kvm>`. If you completed that tutorial, you should have your AWS account already configured and ready, and can skip to the :ref:`next step <Step 2 ref>`. If you haven’t, we highly recommend you follow that tutorial before completing this one.

As a first step, if you don’t already have one, create an account in AWS. AWS publishes a complete guide: `How do I create and activate a new AWS account? <https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/>`__

After you have created your account, you’ll need to obtain the ``access_key`` and ``secret_key`` of a user with the necessary permissions to manage instances. The relevant AWS guide is `Configure tool authentication with AWS <https://docs.aws.amazon.com/IAM/latest/UserGuide/access-keys-admin-managed.html>`__.

Next, you need to choose the region where you want to deploy the new resources. You can check the available regions in AWS’s documentation: `Regions, Availability Zones, and Local Zones <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.

.. _Step 2 ref:

Step 2: Create an AWS Provider in Sunstone
==========================================

When you have your AWS account set up, it’s time to log in to Sunstone and create your AWS provider in OpenNebula. We will log in as user ``oneadmin``.

.. note:: You can log in as any other OpenNebula user, as long as the user is part of the ``oneadmin`` group (if not, Sunstone will not display the providers).

To log in, point your browser to the OneProvision address:

.. code:: bash

    https://<FRONT-END IP>:2616/fireedge/provision

In the log-in screen, enter the credentials for user ``oneadmin``.

Sunstone will display the **OneProvision** screen:

.. image:: /images/oneprovision.png
    :align: center
    :scale: 80%
    
|

.. .. warning::

   The Hosted Cloud PoC provides users with an OpenNebula front-end that is hosted and paid for by OpenNebula Systems. Compute nodes can be provisioned using AWS and Equinix Metal public cloud resources, for which users are responsible via user-owned accounts.

To create a provider in AWS, open the left-hand pane (by hovering the mouse over the icons to the left of the screen), then click **Providers**. Sunstone will display the **Providers** screen:

.. image:: /images/fireedge_cpi_provider_list1.png
    :align: center
    :scale: 60%

|

To add a new provider, click the **Plus icon** |icon1| on the right:

.. image:: /images/oneprovision-add_provider.png
    :align: center
    :scale: 70%

|

Sunstone displays the **Provider template** screen, showing the **Provision type** and **Provider type** drop-down menus as well as additional information. Leave the **Provision type** drop-down on ``metal``. For **Provider type**, select ``AWS``. Then, click the box that displays the desired location for your provision, for example **aws-frankfurt**, as shown below.

|image_provider_create_step1|

Click **Next**. In the next screen, you can enter a description for your provider:

|image_provider_create_step2|

Click **Next**. In the final screen, you will need to provide your AWS access key and secret key:

|image_provider_create_step3|

Click **FINISH**. Sunstone should now display the **Providers** screen, showing your new provider:

.. image:: /images/oneprovision-new_aws_provider.png
    :align: center


|

At this point, you have registered AWS as a new provider on your OpenNebula cloud. In the next step, we will provision an edge cluster on this provider.

Step 3: Provision a Metal Edge Cluster
======================================

To provision the cluster, open the left-hand pane, select **Provisions**, and click the **Plus icon** |icon1| on the right:

.. image:: /images/oneprovision-new_provision.png
    :align: center
    :scale: 80%
    
|

.. +add screenshot
.. based on image:: /images/fireedge_cpi_provider_list1.png

Sunstone displays the **Create Provision** screen. Here you can select provision and provider type, and choose between the provision templates available for a particular provider. In this case, the AWS provider offers two provision templates: **aws-hci-cluster** and **aws-edge-cluster**:

.. image:: /images/oneprovision-aws_provider_options.png
    :align: center
    :scale: 80%

|

Click the **aws-edge-cluster** box, then click **Next**.

OneProvision now displays the **Provider** screen showing the available providers (in this case, the AWS provider we previously created). Click the AWS box to select it, then click **Next**.

.. image:: /images/oneprovision-provider.png
    :align: center
    :scale: 80%

|

In the next screen, you can enter a description for your cluster, if desired:

.. image:: /images/fireedge_cpi_provision_create3.png
    :align: center
    :scale: 60%

|


Click **Next**. The final screen displays the default values for the edge cluster provision, as shown below:

.. image:: /images/oneprovision-edge_cluster_inputs.png
    :align: center
    :scale: 70%

|

The input field **Number of public IPs to get** determines how many public IPs will be made available to the edge cluster. Make sure to set this number to at least ``2``.

.. important:: Make sure to specify at least two public IPs for the edge cluster, or you will not be able to deploy VMs or Kubernetes on the cluster.

You can leave the other values at their defaults:

    * **Number of AWS instances to create**: ``1``
    * **Comma-separated list of DNS servers for public network**: ``1.1.1.1``
    * **AWS instance root volume size, in GB**: ``512``
    * **Virtualization technology for the cluster hosts**: ``kvm``
    * **AWS AMI image**: ``default``
    * **AWS instance type, user bare-metal instances**: ``c5.metal``
    
To provision the cluster, click **Finish**. OneProvision will launch the provisioning process in the background. The cluster should appear in the **Provisions** tab:

.. image:: /images/fireedge_cpi_provision_list2.png
    :align: center
    :scale: 50%

|


To see detailed information, click the provision box:

.. image:: /images/fireedge_cpi_provision_show1.png
    :align: center
    :scale: 50%

|


To see a running log of the provision, click **Log**:

.. image:: /images/fireedge_cpi_provision_log.png
    :align: center

|
    
Provisioning will take a few minutes. When it’s finished, the log will display the message ``Provision successfully created``, followed by the provision’s ID.

At this point, the Edge Cluster has been created and is up and running. In the next step, we’ll verify that all of the specified resources for the provision (the host, datastore, network, and the cluster itself) have been correctly created and registered with OpenNebula.


Step 4: Validate the New Infrastructure
=======================================

To see that all objects in the provision have been correctly created, we’ll run the ``oneprovision`` command on the Front-end node. This command should be run either as the Linux user ``oneadmin``, or as ``root``.

First, log in to the Front-end node.

.. tip:: If you installed the Front-end by following the :doc:`Quickstart with miniONE on AWS <../deployment_basics/try_opennebula_on_kvm>` tutorial, to log into the Front-end you will need to use the key stored in the PEM file that you obtained from AWS. For details, see :ref:`minione_log_in_to_ec2` in that tutorial.

On the Front-end node, use the ``oneprovision`` command to perform the following actions:

List clusters in the provision: ``oneprovision cluster list``.

.. prompt:: bash $ auto

    $ oneprovision cluster list
     ID NAME                 HOSTS      VNETS DATASTORES
    100 aws-cluster              1          1          4

List hosts: ``oneprovision host list``.

.. prompt:: bash $ auto

    $ oneprovision host list
     ID NAME            CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
      1 3.120.111.242   aws-cluste   0      0 / 7200 (0%)   0K / 503.5G (0%) on

List datastores: ``oneprovision datastore list``.

.. prompt:: bash $ auto

    $ oneprovision datastore list
     ID NAME         SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
    101 aws-cluste      - -   100           0 sys  -       ssh     on
    100 aws-cluste  71.4G 90% 100           0 img  fs      ssh     o

List networks: ``oneprovision network list``.

.. prompt:: bash $ auto

    $ oneprovision network list
     ID USER     GROUP    NAME            CLUSTERS   BRIDGE   LEASES
      1 oneadmin oneadmin aws-cluster-pub 100        br0           0

.. tip:: If you want to explore further options for the command, run ``oneprovision --help``.
      

Connecting to the Edge Cluster
==============================

Currently, it is not possible to access VMs deployed on an edge cluster through the normal :ref:`Sunstone mechanisms <remote_access_sunstone>`. To connect to the cluster, you will need to use SSH.

You can easily connect to the cluster from the Front-end node, as Linux user ``oneadmin`` or as Linux user ``ubuntu``, which has access to the root account via the ``sudo`` command.

To connect to the cluster, you will need to supply the user’s identity file, which is stored on the Front-end node in the following locations:

    * For ``oneadmin``: ``/var/lib/one/.ssh/id_rsa``
    * For ``ubuntu``: ``/var/lib/one/.ssh-provision/id_rsa``
   
To log in to the edge cluster, you can use this command:

.. code::

    ssh -i <location of private key file> -l <user> <edge cluster public IP>
    
For example:

.. code::

    ssh -i /var/lib/one/.ssh-provision/id_rsa -l ubuntu <edge cluster public IP>

.. tip::

    If you want root access to the edge cluster, log in as user ``ubuntu``, then ``sudo`` to root.

Next Steps
==========

To see all of the resources created with your new edge cluster, and how they are displayed in Sunstone, see :doc:`Operating an Edge Cluster <operating_edge_cluster>`.



.. |image_provider_list_empty| image:: /images/fireedge_cpi_provider_list1.png
.. |image_provider_list| image:: /images/fireedge_cpi_provider_list2.png
.. |image_provider_create_step1| image:: /images/fireedge_cpi_provider_create1.png
.. |image_provider_create_step2| image:: /images/fireedge_cpi_provider_create2.png
.. |image_provider_create_step3| image:: /images/fireedge_cpi_provider_create3.png

.. |image_provision_list_empty| image:: /images/fireedge_cpi_provision_list1.png
.. |image_provision_list| image:: /images/fireedge_cpi_provision_list2.png
.. |image_provision_create_step1| image:: /images/fireedge_cpi_provision_create1.png
.. |image_provision_create_step2| image:: /images/fireedge_cpi_provision_create2.png
.. |image_provision_create_step3| image:: /images/fireedge_cpi_provision_create3.png
.. |image_provision_create_step4| image:: /images/fireedge_cpi_provision_create4.png
.. |image_provision_info| image:: /images/fireedge_cpi_provision_show1.png
.. |image_provision_log| image:: /images/fireedge_cpi_provision_log.png
.. |icon1| image:: /images/icons/sunstone/plus-dark.png
