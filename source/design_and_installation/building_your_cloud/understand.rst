.. _understand:

================================================================================
Understanding OpenNebula
================================================================================

This guide is meant for cloud architects, builders and administrators, to help them understand the OpenNebula model for managing and provisiong virtual resources. This  model is a result of our collaboration with our user community during the last years. Although OpenNebula has been designed and developed to be easy to adapt to individual enterprise use cases and processes, and to perform fine-tuning of multiple aspects, OpenNebula brings a pre-defined model for cloud provisioning and consumption that offers an integrated and comprehensive framework for resource allocation and isolation in federated data centers and hybrid cloud deployments.

This guide also illustrates the three main types of cloud infrastructures that are implemented with OpenNebula:
* Data center infrastructure management
* Simple cloud provisioning model
* Advanced cloud provisioning model

The Infrastructure Perspective
================================================================================

In a small installation with a few hosts, you can use OpenNebula without giving much though to infrastructure federation and partitioning. But for medium and large deployments you will probably want to provide some level of isolation and structure. Common large IT shops have multiple Data Centers (DCs), each one of them consisting of several physical Clusters of infrastructure resources (hosts, networks and storage). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build hybrid cloud scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds, like Amazon AWS, to address peaks of demand. OpenNebula provides a single comprehensive framework to dynamically allocate all these available resources to the multiple groups of users.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement for cloudbursting with a public cloud provider, such as Amazon, SoftLayer and/or Azure. Each Data Center runs its own full OpenNebula deployment. Multiple OpenNebula installations can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across Data Centers.

|vDC Resources|

The Organizational Perspective
================================================================================

Users are organized into Groups (also called Projects, Domains, Tenants...). A Group is an authorization boundary that can be seen as a business unit if you are considering it as private cloud or as a complete new company if it is public cloud.

A Group is simply a boundary, you need to populate resources into the Group which can then be consumed by the users of that Group. A VDC (Virtual Data Center) is a Group plus Resource Providers assigned. A Resource Provider is a Cluster of infrastructure resources (physical hosts, networks, storage and external clouds) from one of the Data Centers.

Different authorization scenarios can be enabled with the powerful and configurable ACL system provided, from the definition of VDC Admins to the privileges of the users that can deploy virtual machines. Each VDC can execute different types of workload profiles with different performance and security requirements.

The following are common enterprise use cases in large cloud computing deployments:

* **On-premise Private Clouds** Serving Multiple Projects, Departments, Units or Organizations. On-premise private clouds in large organizations require powerful and flexible mechanisms to manage the access privileges to the virtual and physical infrastructure and to dynamically allocate the available resources. In these scenarios, the Cloud Administrator would define a vDC for each Department, dynamically allocating resources according to their needs, and delegating the internal administration of the vDC to the Department IT Administrator.
* **Cloud Providers** Offering Virtual Private Cloud Computing. Cloud providers providing customers with a fully-configurable and isolated environment where they have full control and capacity to administer its users and resources. This combines a public cloud with the control usually seen in a personal private cloud system.

|vDC Groups|

For example, you can think Web Development, Human Resources, and Big Data Analysis as business units represented by VDCs in a private OpenNebula cloud.

* **BLUE**: Allocation of (ClusterA-DC_West_Coast + Cloudbursting) to Web Development
* **RED**: Allocation of (ClusterB-DC_West_Coast + ClusterA-DC_Europe + Cloudbursting) to Human Resources
* **GREEN**: Allocation of (ClusterC-DC_West_Coast + ClusterB-DC_Europe) to Big Data Analysis

|vDC Organization|

A Cloud Provisioning Model Based on vDCs
================================================================================

A VDC is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the VDC admin, can create and manage compute and storage capacity. The users in the VDC, including the VDC administrator, would only see the virtual resources and not the underlying physical infrastructure. The physical resources allocated by the cloud administrator to the vDC can be completely dedicated to the vDC, providing isolation at the physical level too.

The privileges of the VDC users and the administrator regarding the operations over the virtual resources created by other users can be configured. For example, in the Advanced Cloud Provisioning Case, the users can instantiate virtual machine templates to create their machines, while the administrators of the VDC have full control over other users' resources and can also create new users in the VDC.

|cloud-view|

Users can then access their VDC through any of the existing OpenNebula interfaces, such as the CLI, Sunstone Cloud View, OCA, or the AWS APIs. VDC administrators can manage their VDCs through the CLI or the VDC Admin View in Sunstone. Cloud Administrators can manage the VDCs through the CLI or Sunstone.

The Cloud provisioning model based on VDCs enables an integrated, comprehensive framework to dynamically provision the infrastructure resources in large multi-datacenter environments to different customers, business units or groups. This brings several benefits:

* Partitioning of cloud physical resources between Groups of users
* Complete isolation of users, organizations or workloads
* Allocation of Clusters with different levels of security, performance or high availability
* Containers for the execution of software-defined data centers
* Way of hiding physical resources from Group members
* Simple federation, scalability and cloudbursting of private cloud infrastructures beyond a single cloud instance and data center

Cloud Usage Models
================================================================================

OpenNebula has three pre-defined user roles to implement three typical enterprise cloud scenarios:

* Data center infrastructure management
* Simple cloud provisioning model
* Advanced cloud provisioning model

In the three scenarios, the Cloud Administrators manage the physical infrastructure, creates users and VDCs, prepares base templates and images for users, etc

Cloud Administrators typically access to the cloud by using the CLI or the Admin View of Sunstone.

+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Role       |                                                                       Capabilities                                                                      |
+==================+=========================================================================================================================================================+
| **Cloud Admin.** | * Operates the Cloud infrastructure (i.e. computing nodes, networking fabric, storage servers)                                                          |
|                  | * Creates and manages OpenNebula infrastructure resources: Hosts, Virtual Networks, Datastores                                                          |
|                  | * Creates and manages application Flows (Services)                                                                                                      |
|                  | * Creates new groups for VDCs                                                                                                                           |
|                  | * Assigns resource providers to a VDC and sets quota limits                                                                                             |
|                  | * Defines base instance types to be used by the VDCs. These types define the capacity of the VMs (memory, cpu and additional storage) and connectivity. |
|                  | * Prepare VM images to be used by the VDCs                                                                                                              |
|                  | * Monitor the status and health of the cloud                                                                                                            |
|                  | * Generate activity reports                                                                                                                             |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

Data Center Infrastructure Management
-----------------------------------------------------------------------------

This model is used to manage data center virtualziation and to integrate and federate existing IT assets that can be in different data centers. In this usage model, Users are familiar with virtualization concepts. Except for the infrastructure resources, the web interface offeres the same operations available to the Cloud Admin. These are "Advanced Users" that could be considered also as "Limited Cloud Administrators".

Users can use the templates and images pre-defined by the cloud administrator, but usually are also allowed to create their own templates and images. They are also able to manage the life-cycle of their resources, including advanced features that may harm the VM guests, like hot-plugging of new disks, resize of Virtual Machines, modify boot parameters, etc.

VDCs are used by the Cloud Administrator to isolate users and allocate resources but are not offered on-demand.

These "Advanced Users" typically access to the cloud by using the CLI or the User View of Sunstone. This is not the default model configured for the group Users.

+-------------------+-------------------------------------------------------------------+
|   Role            |                            Capabilities                           |
+===================+===================================================================+
| **Advanced User** | * Instantiates VMs using their own templates                      |
|                   | * Creates new templates and images                                |
|                   | * Manages their VMs, including advanced life-cycle features       |
|                   | * Creates and manages Application Flows                           |
|                   | * Check their usage and quotas                                    |
|                   | * Upload SSH keys to access the VMs                               |
+-------------------+-------------------------------------------------------------------+

Simple Cloud Provisioning Model
-----------------------------------------------------------------------------

In the simple infrastructure provisioning model, the Cloud is offering infrastructure as a service to individual Users. Users are considered as "Cloud Users" or "Cloud Consumers", being much more limited in their operations.These Users access a very simple and simplified web interface that allows them to launch Virtual Machines from pre-defined Templates. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

VDCs are used by the Cloud Administrator to isolate users and allocate resources but are not offered on-demand.

These "Cloud Users" typically access to the cloud by using the Cloud View of Sunstone. This is the default model configured for the group Users.

+----------------+------------------------------------------------------------------------------------------------------------------------------+
|      Role      |                                                         Capabilities                                                         |
+================+==============================================================================================================================+
| **Cloud User** | * Instantiates VMs using the templates defined by the Cloud Admins and the images defined by the Cloud Admins or vDC Admins. |
|                | * Instantiates VMs using their own Images saved from a previous running VM                                                   |
|                | * Manages their VMs, including                                                                                               |
|                |                                                                                                                              |
|                | * reboot                                                                                                                     |
|                | * power off/on (short-term switching-off)                                                                                    |
|                | * delete                                                                                                                     |
|                | * save a VM into a new Template                                                                                              |
|                | * obtain basic monitor information and status (including IP addresses)                                                       |
|                |                                                                                                                              |
|                | * Delete any previous VM template and disk snapshot                                                                          |
|                | * Check user usage and quotas                                                                                                |
|                | * Upload SSH keys to access the VMs                                                                                          |
+----------------+------------------------------------------------------------------------------------------------------------------------------+


Advanced Cloud Provisioning Model
-----------------------------------------------------------------------------

The advanced provisioning model is an extension of the previous one where the cloud provider offers VDCs on demand to projects, companies, departments or business units. Each VDC can define one or more users as VDC Admins. These admins can create new users inside the VDC, and also manage the resources of the rest of the users. A VDC Admin may, for example, shutdown a VM from other user to free group quota usage.

These VDC Admins typically access to the cloud by using the VDC Admin View of Sunstone.

The VDC Users have the capabilities described in the previous scenario and typically access to the cloud by using the Cloud View of Sunstone.

+----------------+-----------------------------------------------------+
|      Role      |                     Capabilities                    |
+================+=====================================================+
| **VDC Admin.** | * Creates new users in the VDC                      |
|                | * Operates on VDC virtual machines and disk images  |
|                | * Share Saved Templates with the members of the VDC |
|                | * Checks VDC usage and quotas                       |
+----------------+-----------------------------------------------------+

.. |vDC Resources| image:: /images/vdc_resources.png
.. |vDC Groups| image:: /images/vdc_groups.png
.. |vDC Organization| image:: /images/vdc_organization.png
.. |cloud-view| image:: /images/cloud-view.png
