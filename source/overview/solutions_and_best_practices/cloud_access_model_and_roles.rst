.. _understand:

================================
Cloud Access Model and Roles
================================

In a small installation with a few hosts, you can use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

This Section is meant for cloud architects, builders and administrators, to help them understand the OpenNebula model for managing and provisioning virtual resources. This model is a result of our collaboration with our user community throughout the life of the project.

The Infrastructure Perspective
================================================================================

Common large IT shops have multiple Data Centers (DCs), each one running its own OpenNebula instance and consisting of several physical Clusters of infrastructure resources (Hosts, Networks and Datastores). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build true hybrid cloud scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds, like Amazon AWS, to address peaks of demand.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement with a public cloud provider, such as Amazon, and/or Equinix. Each Data Center runs its own zone or full OpenNebula deployment. Multiple OpenNebula Zones can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across Data Centers. Alternatively, you could have a single OpenNebula zone for both Data Centers and configure each Data Center as a cluster.

.. todo:: Explain latency and bandwith requirements for across DCs zones

|VDC Resources|

The Organizational Perspective
================================================================================

Users are organized into Groups (similar to what other environments call Projects, Domains, Tenants...). A Group is an authorization boundary that can be seen as a business unit if you are considering it as a private cloud or as a complete new company if it is a public cloud. While Clusters are used to group Physical Resources according to common characteristics such as networking topology or physical location, Virtual Data Centers (VDCs) allow creating "logical" pools of Physical Resources (which could belong to different Clusters and Zones) and allocate them to user Groups.

A VDC is a fully-isolated virtual infrastructure environment where a Group of users (or optionally several Groups of users), under the control of a Group admin, can create and manage compute and storage capacity. The users in the Group, including the Group admin, would only see the virtual resources and not the underlying physical infrastructure. The Physical Resources allocated to the Group are managed by the cloud administrator through a VDC. These resources grouped in the VDC can be dedicated exclusively to the Group, providing isolation at the physical level too.

The privileges of the Group users and the admin regarding the operations over the virtual resources created by other users can be configured. For example, in the Advanced Cloud Provisioning Case described below, the users can instantiate virtual machine templates to create their machines, while the admins of the Group have full control over other users' resources and can also create new users in the Group.

Users can access their resources through any of the existing OpenNebula interfaces, such as the CLI, Sunstone Cloud View, OCA, or the AWS APIs. Group admins can manage their Groups through the CLI or the Group Admin View in Sunstone. Cloud administrators can manage the Groups through the CLI or Sunstone.

.. image:: /images/cloud-view.png
    :width: 90%
    :align: center

The Cloud provisioning model based on VDCs enables an integrated, comprehensive framework to dynamically provision the infrastructure resources in large multi-datacenter environments to different customers, business units or groups. This brings several benefits:

* Partitioning of cloud Physical Resources between Groups of users
* Complete isolation of Users, organizations or workloads
* Allocation of Clusters with different levels of security, performance or high availability
* Containers for the execution of software-defined data centers
* Way of hiding Physical Resources from Group members
* Simple federation, scalability and cloudbursting of private cloud infrastructures beyond a single cloud instance and data center

Examples of Provisioning Use Cases
================================================================================

The following are common enterprise use cases in large cloud computing deployments:

* **On-premise Private Clouds** Serving Multiple Projects, Departments, Units or Organizations. On-premise private clouds in large organizations require powerful and flexible mechanisms to manage the access privileges to the virtual and physical infrastructure and to dynamically allocate the available resources. In these scenarios, the Cloud Administrator would define a VDC for each Department, dynamically allocating resources according to their needs, and delegating the internal administration of the Group to the Department IT Administrator.
* **Cloud Providers** Offering Virtual Private Cloud Computing. Cloud providers providing customers with a fully-configurable and isolated environment where they have full control and capacity to administer its users and resources. This combines a public cloud with the control usually seen in a personal private cloud system.

For example, you can think Web Development, Human Resources, and Big Data Analysis as business units represented by Groups in a private OpenNebula cloud, and allocate them resources from your DCs and public clouds in order to create three different VDCs.

* **VDC BLUE**: VDC that allocates (ClusterA-DC_West_Coast + Cloudbursting) to Web Development
* **VDC RED**: VDC that allocates (ClusterB-DC_West_Coast + ClusterA-DC_Europe + Cloudbursting) to Human Resources
* **VDC GREEN**: VDC that allocates (ClusterC-DC_West_Coast + ClusterB-DC_Europe) to Big Data Analysis

|VDC Organization|

Cloud Access Roles
================================================================================

.. todo:: This section needs deep review


Cloud Users
-----------------------------------------------------------------------------

Cloud Users use the CLI or the **User View** of Sunstone to perform the following actions:

+-------------------+-------------------------------------------------------------+
|        Role       |                         Capabilities                        |
+===================+=============================================================+
| **Cloud User**    | * ...                                                       |
+-------------------+-------------------------------------------------------------+

An OpenNebula cloud can offer VDCs on demand to Groups of Users (projects, companies, departments or business units). In these cases, each Group can define one or more users as Group Admins. These admins can create new users inside the Group, and also manage the resources of the rest of the users. A Group Admin may, for example, shutdown a VM from other user to free group quota usage.

These Group Admins typically access the cloud by using the CLI or **Group Admin View** of Sunstone.

+------------------+------------------------------------------------------------+
|       Role       |                        Capabilities                        |
+==================+============================================================+
| **Group Admin.** | * Creates new users in the Group                           |
|                  | * Operates on the Group's virtual machines and disk images |
|                  | * Share Saved Templates with the members of the Group      |
|                  | * Checks Group usage and quotas                            |
+------------------+------------------------------------------------------------+

OpenNebula also offers a **Cloud View** interface for users with much more limited operations. This is a very intuitive simplified web interface that allows users to launch Virtual Machines from predefined Templates. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

These "Cloud Users" typically access the cloud by using the Cloud View of Sunstone. This is the default model configured for the group Users.

+----------------+--------------------------------------------------------------------------------------------------------------------------------+
|      Role      |                                                          Capabilities                                                          |
+================+================================================================================================================================+
| **Cloud User** | * Instantiates VMs using the templates defined by the Cloud Admins and the images defined by the Cloud Admins or Group Admins. |
|                | * Instantiates VMs using their own Images saved from a previous running VM                                                     |
|                | * Manages their VMs, including                                                                                                 |
|                |                                                                                                                                |
|                |   * reboot                                                                                                                     |
|                |   * power off/on (short-term switching-off)                                                                                    |
|                |   * delete                                                                                                                     |
|                |   * save a VM into a new Template                                                                                              |
|                |   * obtain basic monitor information and status (including IP addresses)                                                       |
|                |                                                                                                                                |
|                | * Delete any previous VM template and disk snapshot                                                                            |
|                | * Check user account usage and quotas                                                                                          |
|                | * Upload SSH keys to access the VMs                                                                                            |
+----------------+--------------------------------------------------------------------------------------------------------------------------------+


Cloud Service Administrators (Operators)
-----------------------------------------------------------------------------

Cloud Administrators typically access the cloud using the CLI or the **Admin View** of Sunstone.

+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Role       |                                                                       Capabilities                                                                       |
+==================+==========================================================================================================================================================+
| **Cloud Oper.**  | * ...                                                                                                                                                    |
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+

Cloud Operators also provide support to Cloud Users in any aspect related to the Cloud Service.

Cloud Infrastructure Administrators
-----------------------------------------------------------------------------

Cloud Infrastructure Administrators typically perform the following actions.

+------------------+--------------+
|       Role       | Capabilities |
+==================+==============+
| **Cloud Admin.** | * ...        |
+------------------+--------------+


Cloud Admins also provide support to Cloud Operators and perform any corrective and periodic preventive maintenance tasks related to the infrastructure:
*  Capacity planning to match demand to available resources
*  Tuning and maintenance of OpenNebula and other software components
*  Updates and security patches of OpenNebula and other software components

Cloud Managed Services
================================================================================

.. todo:: Here explain OpenNebula cloud managed services


.. _understand_compatibility:


.. |VDC Resources| image:: /images/vdc_resources.png
.. |VDC Groups| image:: /images/vdc_groups.png
.. |VDC Organization| image:: /images/vdc_organization.png
