
.. _first_edge_cluster:

============================
Provisioning an Edge Cluster
============================

In this quick start guide we are going to try different workloads. Each workload needs to be deployed in a compatible type of Edge Cluster, since not all of them are capable of running all types of workload. More information on this is available in the :ref:`platform notes <uspng>`.

.. table::
   :widths: 60,15,25
   :align: left

   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | Use Case                                                           | Edge Cluster |  Hypervisor                                           |
   +====================================================================+==============+=======================================================+
   | :ref:`I want to run application containers...                      | virtual      | LXC                                                   |
   | <running_containers>`                                              +--------------+-------------------------------------------------------+
   |                                                                    | metal        | LXC, Firecracker                                      |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | :ref:`I want to run virtual servers... <running_virtual_machines>` | metal        | KVM, LXC                                              |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | I want to run a Kubernetes cluster...                              | metal        | KVM (:ref:`k8s based <running_kubernetes_clusters>`)  |
   |                                                                    |              +-------------------------------------------------------+
   |                                                                    |              | Firecracker (:ref:`k3s based <running_k3s_clusters>`) |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+

In this section you can check all the steps needed to deploy an **Edge Cluster**. This involves the FireEdge OneProvision GUI and Sunstone to manage the resources created in OpenNebula.

.. note:: We'll be creating a virtual Edge Cluster with LXC hypervisor, suitable for deploying containers. If you're planning to go all the way and to also try the deployment of VMs and K8s cluster, we recommend using a metal Edge Cluster deployment with a KVM hypervisor.

Overview
================================================================================

An Edge Cluster is a group of resources in OpenNebula and the corresponding resources in AWS. OpenNebula provides a specification of the cluster ready to be created.

The following resources are created in OpenNebula:

* **Cluster**: one cluster containing all the resources is created with each provision. There is a one-to-one relationship between the provision and the cluster, so each provision can only have **one** cluster.
* **Datastore**: each provision deploys two datastores, the system and the image.
* **Host**: the user can deploy as many as he or she wants. They will be used to run VMs.
* **Virtual Network**: for private networking there is a network template ready to be instantiated with the parameters the user needs. There is also one public network that uses the elastic drivers to pre-allocate IPs, so VMs have public connectivity.

During the provision of the cluster all these resources and their corresponding AWS objects are created with the aid of Terraform. In particular, the following AWS resources are created:

* A virtual private cloud (VPC) to allocate the OpenNebula Hosts (AWS instances)
* A CIDR block for the AWS instances. This CIDR block is used to assign secondary IPs to the Hosts to allocate elastic IPs.
* An Internet Gateway to provide Internet access to the Host and VMs.
* A routing table for the previous elements.

.. note:: Take into account that FireEdge will request Elastic IPs for the public IPs you request. If you receive an error message about not being able to request more IPs when creating a provision, please check the `limits of your account <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html>`__ in your zone.

We'll be using the FireEdge GUI in this guide, so please make sure you can log in to it using your Front-end IP and default port 2616, as well as your oneadmin credentials.

Step 1: Configuring AWS & Required Information
================================================================================

As a first step, if you don't already have one, create an account in AWS. You can follow `this guide <https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/>`__.

Whenever your account is ready, you need to obtain both an ``access_key`` and a ``secret_key`` of a user that has access to instances management. For this, you can follow `this guide <https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html>`__.

Next, you need to choose the region where you want to deploy the resources. All the available regions can be checked `here <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.

.. warning:: To be able to connect to the instances you deploy, you'll need SSH keys. They are installed in ``/var/lib/one/.ssh-oneprovision``. A current limitation of the edge clusters is that currently is not possible to access the VMs through the normal :ref:`Sunstone mechanisms <remote_access_sunstone>` to do so.

Step 2: Create an AWS provider
================================================================================

To deploy a complete edge provision with oneprovision from GUI, you first need to add a remote provider using the connection parameters above and choosing the location you wish to deploy those resources

First, to **create a provider**, go to provider list view:

|image_provider_list_empty|

Then, **click the plus button** and fill in the form. We will be using the virtual Edge Cluster type with the LXC hypervisor.

|image_provider_create_step1|

|image_provider_create_step2|

|image_provider_create_step3|

You now have a **new provider**.

Step 3: Provision a Virtual Edge Cluster
================================================================================

The user needs to provide the following inputs to create the provision:

+-----------------------+------------------------------------------------------------------+
|       User Input      |                           Description                            |
+=======================+==================================================================+
| ``Provider``          | This is the provider you just created above.                     |
+-----------------------+------------------------------------------------------------------+
| ``Number of Hosts``   | Number of physical Hosts to be deployed on AWS.                  |
+-----------------------+------------------------------------------------------------------+
| ``Number of IPs``     | Number of public IPs to get from AWS in order to connect to VMs. |
+-----------------------+------------------------------------------------------------------+
| ``AWS instance type`` | AWS instance type to deploy.                                     |
+-----------------------+------------------------------------------------------------------+
| ``Hypervisor``        | Hypervisor to install ``lxc`` (just for virtual servers)         |
+-----------------------+------------------------------------------------------------------+

Now let's go to **create a provision** and follow the same steps:

|image_provision_list_empty|

**Select the provider** where you will deploy the provision. You will only have the one defined in the previous step.

|image_provision_create_step1|

|image_provision_create_step2|

|image_provision_create_step3|

|image_provision_create_step4|

After clicking finish, you will be able to see the provision card in the Provisions tab:

|image_provision_list|

Let's explore **the log and detailed information**

|image_provision_info|

|image_provision_log|

Your provision will be ready when you see the message "Provision successfully created" in the log, followed by the ID of the recently created provision.

Step 4: Validation
================================================================================

**Infrastructure Validation**

Once the deployment has finished, you can check that all the objects have been correctly created:

.. prompt:: bash $ auto

    $ oneprovision cluster list
     ID NAME                 HOSTS      VNETS DATASTORES
    100 aws-cluster              1          1          4

.. prompt:: bash $ auto

    $ oneprovision host list
     ID NAME            CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
      1 3.120.111.242   aws-cluste   0      0 / 7200 (0%)   0K / 503.5G (0%) on

.. prompt:: bash $ auto

    $ oneprovision datastore list
     ID NAME         SIZE AVA CLUSTERS IMAGES TYPE DS      TM      STAT
    101 aws-cluste      - -   100           0 sys  -       ssh     on
    100 aws-cluste  71.4G 90% 100           0 img  fs      ssh     o

.. prompt:: bash $ auto

    $ oneprovision network list
     ID USER     GROUP    NAME            CLUSTERS   BRIDGE   LEASES
      1 oneadmin oneadmin aws-cluster-pub 100        br0           0

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
