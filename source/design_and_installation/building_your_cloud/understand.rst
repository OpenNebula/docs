.. _understand:

================================================================================
Understanding OpenNebula
================================================================================

This guide is meant for the cloud architect and administrator, to help him to understand the way OpenNebula categorizes the infrastructure resources, and how they are consumed by the users.

In a tiny installation with a few hosts, you can use OpenNebula with the two default groups for the administrator and the users, without giving much though to the infrastructure partitioning and user organization. But for medium and big deployments you will probably want to provide some level of isolation and structure.

Although OpenNebula has been designed and developed to be easy to adapt to each individual company use case and processes, and perform fine-tuning of multiple aspects, OpenNebula brings a pre-defined model for cloud provisioning and consumption.

The OpenNebula model is a result of our collaboration with our user community during the last years.

The Infrastructure Perspective
================================================================================

Common large IT shops have multiple Data Centers (DCs), each one of them consisting of several physical Clusters of infrastructure resources (hosts, networks and storage). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build hybrid cloud scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds to address peaks of demand. Sysadmins need a single comprehensive framework to dynamically allocate all these available resources to the multiple groups of users.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement for cloudbursting with a public cloud provider, such as Amazon. Each Data Center runs its own full OpenNebula deployment. Multiple OpenNebula installations can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across Data Centers.

|vDC Resources|

The Organizational Perspective
================================================================================

Users are organized into Groups (also called Projects, Domains, Tenants...). A Group is an authorization boundary that can be seen as a business unit if you are considering it as private cloud or as a complete new company if it is public cloud.

A Group is simply a boundary, you need to populate resources into the Group which can then be consumed by the users of that Group. A vDC (Virtual Data Center) is a Group plus Resource Providers assigned. A Resource Provider is a Cluster of infrastructure resources (physical hosts, networks, storage and external clouds) from one of the Data Centers.

Different authorization scenarios can be enabled with the powerful and configurable ACL system provided, from the definition of vDC Admins to the privileges of the users that can deploy virtual machines. Each vDC can execute different types of workload profiles with different performance and security requirements.

The following are common enterprise use cases in large cloud computing deployments:

* **On-premise Private Clouds** Serving Multiple Projects, Departments, Units or Organizations. On-premise private clouds in large organizations require powerful and flexible mechanisms to manage the access privileges to the virtual and physical infrastructure and to dynamically allocate the available resources. In these scenarios, the Cloud Administrator would define a vDC for each Department, dynamically allocating resources according to their needs, and delegating the internal administration of the vDC to the Department IT Administrator.
* **Cloud Providers** Offering Virtual Private Cloud Computing. Cloud providers providing customers with a fully-configurable and isolated environment where they have full control and capacity to administer its users and resources. This combines a public cloud with the control usually seen in a personal private cloud system.

|vDC Groups|

For example, you can think Web Development, Human Resources, and Big Data Analysis as business units represented by vDCs in a private OpenNebula cloud.

* **BLUE**: Allocation of (ClusterA-DC_West_Coast + Cloudbursting) to Web Development
* **RED**: Allocation of (ClusterB-DC_West_Coast + ClusterA-DC_Europe + Cloudbursting) to Human Resources
* **GREEN**: Allocation of (ClusterC-DC_West_Coast + ClusterB-DC_Europe) to Big Data Analysis

|vDC Organization|

A Cloud Provisioning Model Based on vDCs
================================================================================

A vDC is a fully-isolated virtual infrastructure environment where a Group of users, optionally under the control of the vDC admin, can create and manage compute and storage capacity. The users in the vDC, including the vDC administrator, would only see the virtual resources and not the underlying physical infrastructure. The physical resources allocated by the cloud administrator to the vDC can be completely dedicated to the vDC, providing isolation at the physical level too.

The privileges of the vDC users and the administrator regarding the operations over the virtual resources created by other users can be configured. In a typical scenario the vDC administrator can upload and create images and virtual machine templates, while the users can only instantiate virtual machine templates to create their machines. The administrators of the vDC have full control over other users' resources and can also create new users in the vDC.

.. todo:: Screenshot of the cloud view

Users can then access their vDC through any of the existing OpenNebula interfaces, such as the CLI, Sunstone Cloud View, OCA, or the OCCI and AWS APIs. vDC administrators can manage their vDCs through the CLI or the vDC admin view in Sunstone. Cloud Administrators can manage the vDCs through the CLI or Sunstone.

The Cloud provisioning model based on vDCs enables an integrated, comprehensive framework to dynamically provision the infrastructure resources in large multi-datacenter environments to different customers, business units or groups. This brings several benefits:

* Partitioning of cloud physical resources between Groups of users
* Complete isolation of users, organizations or workloads
* Allocation of Clusters with different levels of security, performance or high availability
* Containers for the execution of software-defined data centers
* Way of hiding physical resources from Group members
* Simple federation, scalability and cloudbursting of private cloud infrastructures beyond a single cloud instance and data center

Cloud Usage Models
================================================================================

OpenNebula has three pre-defined user roles to implement two typical enterprise cloud scenarios: infrastructure management and infrastructure provisioning.

.. todo:: decide which roles have access to oneflow

In both scenarios, the Cloud Administrator manages the physical infrastructure, creates users and vDC, and prepares base templates and images for other users.

+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Role       |                                                                       Capabilities                                                                      |
+==================+=========================================================================================================================================================+
| **Cloud Admin.** | * Operates the Cloud infrastructure (i.e. computing nodes, networking fabric, storage servers)                                                          |
|                  | * Creates and manage OpenNebula infrastructure resources: Hosts, Virtual Networks, Datastores                                                           |
|                  | * Creates new groups for vDCs                                                                                                                           |
|                  | * Assigns resource providers to a vDC and sets quota limits                                                                                             |
|                  | * Defines base instance types to be used by the vDCs. These types define the capacity of the VMs (memory, cpu and additional storage) and connectivity. |
|                  | * Prepare VM images to be used by the vDCs                                                                                                              |
|                  | * Monitor the status and health of the cloud                                                                                                            |
|                  | * Generate activity reports                                                                                                                             |
+------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

Infrastructure Management
-----------------------------------------------------------------------------

In this usage model, users are familiar with virtualization concepts. Except for the infrastructure resources, the web interface offeres the same operations available to the Cloud Admin.

End users can use the templates and images pre-defined by the cloud administrator, but are also allowed to create their own. They are also able to manage the life-cycle of their resources, including advanced features that may harm the VM guests, like hot-plugging of new disks, resize of Virtual Machines, modify boot parameters, etc.


+----------------+-----------------------------------------------------------------+
|      Role      |                           Capabilities                          |
+================+=================================================================+
| **User**       | * Instantiates VMs using their own templates                    |
|                | * Creates new Images                                            |
|                | * Manages their VMs, including advanced life-cycle features     |
|                | * Check their usage and quotas                                  |
|                | * Upload SSH keys to access the VMs                             |
+----------------+-----------------------------------------------------------------+


Infrastructure Provisioning
-----------------------------------------------------------------------------

In a infrastructure provisioning model, the end users access a simplified web interface that allows them to launch Virtual Machines from pre-defined Templates and Images. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

Optionally, each vDC can define one or more users as vDC Admins. These admins can create new users inside the vDC, and also manage the resources of the rest of the users. A vDC Admin may, for example, shutdown a VM from other user to free group quota usage.

+----------------+------------------------------------------------------------------------------------------------------------------------------+
|      Role      |                                                         Capabilities                                                         |
+================+==============================================================================================================================+
| **vDC Admin.** | * Creates new users in the vDC                                                                                               |
|                | * Operates on vDC virtual machines and disk images                                                                           |
|                | * Creates and registers disk images to be used by the vDC users                                                              |
|                | * Checks vDC usage and quotas                                                                                                |
+----------------+------------------------------------------------------------------------------------------------------------------------------+
| **vDC User**   | * Instantiates VMs using the templates defined by the Cloud Admins and the images defined by the Cloud Admins or vDC Admins. |
|                | * Instantiates VMs using their own Images saved from a previous running VM                                                   |
|                | * Manages their VMs, including                                                                                               |
|                |                                                                                                                              |
|                |   * reboot                                                                                                                   |
|                |   * power off/on (short-term switching-off)                                                                                  |
|                |   * shutdown                                                                                                                 |
|                |   * make a VM image snapshot                                                                                                 |
|                |   * obtain basic monitor information and status (including IP addresses)                                                     |
|                |                                                                                                                              |
|                | * Delete any previous disk snapshot                                                                                          |
|                | * Check user usage and quotas                                                                                                |
|                | * Upload SSH keys to access the VMs                                                                                          |
+----------------+------------------------------------------------------------------------------------------------------------------------------+

.. |vDC Resources| image:: /images/vdc_resources.png
.. |vDC Groups| image:: /images/vdc_groups.png
.. |vDC Organization| image:: /images/vdc_organization.png
