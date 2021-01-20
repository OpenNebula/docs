.. _understand:

================================
OpenNebula Provisioning Overview
================================

In a small installation with a few hosts, you can use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

This Section is meant for cloud architects, builders and administrators, to help them understand the OpenNebula model for managing and provisioning virtual resources. This model is a result of our collaboration with our user community throughout the life of the project.

The Infrastructure Perspective
================================================================================

Common large IT shops have multiple Data Centers (DCs), each one running its own OpenNebula instance and consisting of several physical Clusters of infrastructure resources (Hosts, Networks and Datastores). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build hybrid cloud scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds, like Amazon AWS, to address peaks of demand.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement for cloudbursting with a public cloud provider, such as Amazon, and/or Azure. Each Data Center runs its own zone or full OpenNebula deployment. Multiple OpenNebula Zones can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across Data Centers.

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

Cloud Provisioning Scenarios
================================================================================

OpenNebula has three predefined User roles to implement three typical enterprise cloud scenarios:

* Data center infrastructure management
* Simple cloud provisioning model
* Advanced cloud provisioning model

In these three scenarios, Cloud Administrators manage the physical infrastructure, create Users and VDCs, prepare base templates and images for Users, etc.

Cloud Administrators typically access the cloud using the CLI or the Admin View of Sunstone.

+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Role       |                                                                       Capabilities                                                                       |
+==================+==========================================================================================================================================================+
| **Cloud Admin.** | * Operates the Cloud infrastructure (i.e. computing nodes, networking fabric, storage servers)                                                           |
|                  | * Creates and manages OpenNebula infrastructure resources: Hosts, Virtual Networks, Datastores                                                           |
|                  | * Creates and manages Multi-VM Applications (Services)                                                                                                   |
|                  | * Creates new Groups and VDCs                                                                                                                            |
|                  | * Assigns Groups and physical resources to a VDC and sets quota limits                                                                                   |
|                  | * Defines base instance types to be used by the users. These types define the capacity of the VMs (memory, CPU and additional storage) and connectivity. |
|                  | * Prepare VM images to be used by the users                                                                                                              |
|                  | * Monitor the status and health of the cloud                                                                                                             |
|                  | * Generate activity reports                                                                                                                              |
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+

Data Center Infrastructure Management
-----------------------------------------------------------------------------

This model is used to manage data center virtualization and to integrate and federate existing IT assets that can be in different data centers. In this usage model, Users are familiar with virtualization concepts. Except for the infrastructure resources, the web interface offers the same operations available to the Cloud Admin. These are "Advanced Users" that could be considered also as "Limited Cloud Administrators".

Users can use the templates and images pre-defined by the cloud administrator, but usually are also allowed to create their own templates and images. They are also able to manage the life-cycle of their resources, including advanced features that may harm the VM guests, like hot-plugging of new disks, resize of Virtual Machines, modify boot parameters, etc.

Groups are used by the Cloud Administrator to isolate users, which are combined with VDCs to have allocated resources, but are not offered on-demand.

These "Advanced Users" typically access the cloud by using the CLI or the User View of Sunstone. This is not the default model configured for the group Users.

+-------------------+-------------------------------------------------------------+
|        Role       |                         Capabilities                        |
+===================+=============================================================+
| **Advanced User** | * Instantiates VMs using their own templates                |
|                   | * Creates new templates and images                          |
|                   | * Manages their VMs, including advanced life-cycle features |
|                   | * Creates and manages Multi-VM Application (Services)       |
|                   | * Check their usage and quotas                              |
|                   | * Upload SSH keys to access the VMs                         |
+-------------------+-------------------------------------------------------------+

Simple Cloud Provisioning
-----------------------------------------------------------------------------

In the simple infrastructure provisioning model, the Cloud offers infrastructure as a service to individual Users. Users are considered as "Cloud Users" or "Cloud Consumers", being much more limited in their operations. These Users access a very intuitive simplified web interface that allows them to launch Virtual Machines from predefined Templates. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

Groups are used by the Cloud Administrator to isolate users, which are combined with VDCs to have allocated resources, but are not offered on-demand.

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


Advanced Cloud Provisioning
--------------------------------------------------------------------------------

The advanced provisioning model is an extension of the previous one where the cloud provider offers VDCs on demand to Groups of Users (projects, companies, departments or business units). Each Group can define one or more users as Group Admins. These admins can create new users inside the Group, and also manage the resources of the rest of the users. A Group Admin may, for example, shutdown a VM from other user to free group quota usage.

These Group Admins typically access the cloud by using the Group Admin View of Sunstone.

The Group Users have the capabilities described in the previous scenario and typically access the cloud by using the Cloud View of Sunstone.

+------------------+------------------------------------------------------------+
|       Role       |                        Capabilities                        |
+==================+============================================================+
| **Group Admin.** | * Creates new users in the Group                           |
|                  | * Operates on the Group's virtual machines and disk images |
|                  | * Share Saved Templates with the members of the Group      |
|                  | * Checks Group usage and quotas                            |
+------------------+------------------------------------------------------------+

.. _understand_compatibility:


.. |VDC Resources| image:: /images/vdc_resources.png
.. |VDC Groups| image:: /images/vdc_groups.png
.. |VDC Organization| image:: /images/vdc_organization.png
