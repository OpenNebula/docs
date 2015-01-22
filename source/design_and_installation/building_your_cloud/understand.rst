.. _understand:

================================================================================
Understanding OpenNebula
================================================================================

This guide is meant for cloud architects, builders and administrators, to help them understand the OpenNebula model for managing and provisioning virtual resources. This model is a result of our collaboration with our user community during the last years. Although OpenNebula has been designed and developed to be easy to adapt to individual enterprise use cases and processes, and to perform fine-tuning of multiple aspects, OpenNebula brings a pre-defined model for cloud provisioning and consumption that offers an integrated and comprehensive framework for resource allocation and isolation in federated data centers and hybrid cloud deployments.

This guide also illustrates the three main types of cloud infrastructures that are implemented with OpenNebula:

* Data center infrastructure management
* Simple cloud provisioning model
* Advanced cloud provisioning model

Definitions
================================================================================

To make it easier to follow this guide, here is a list of the main resources and how we refer to them in OpenNebula:

* Physical Resources

  * **Host**: A physical machine with a hypervisor installed.
  * **Virtual Network**: Describes a Physical Network, and a set of IPs.
  * **Datastore**: Storage medium used as disk images repository or to hold images for running VMs 
  * **Cluster**: Group of physical resources (Hosts, Virtual Networks and Datastores) that share common characteristics or configurations. For example, you can have the "kvm" and "vmware" Clusters, the "kvm-ceph" and "kvm-gluster" Clusters, the "Dev" and "Production" Clusters, or the "infiniband" and "ehternet" Clusters.
  * **Zone**: A single OpenNebula instance consisting of one or several Clusters. A single Data Center (DC) can hold one or several Zones. Several Zones can be federeated within a single Cloud.

* Organization Resources

  * **User**: An OpenNebula user account.
  * **Group**: A group of Users.
  * **Virtual Data Center (VDC)**: Defines which physical resources can be used by which group. This is a logical assignment, so the physical resources can be totally unrelated. They may be part of different Clusters, i.e. have different hypervisors or CPU architecture.


The Infrastructure Perspective
================================================================================

In a small installation with a few hosts, you can use OpenNebula without giving much thought to infrastructure federation and partitioning. But for medium and large deployments you will probably want to provide some level of isolation and structure. Common large IT shops have multiple Data Centers (DCs), each one of them consisting of several physical Clusters of infrastructure resources (Hosts, Networks and Datastores). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build hybrid cloud scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds, like Amazon AWS, to address peaks of demand. OpenNebula provides a single comprehensive framework to dynamically allocate all these available resources to the multiple groups of users.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement for cloudbursting with a public cloud provider, such as Amazon, SoftLayer and/or Azure. Each Data Center runs its own zone or full OpenNebula deployment. Multiple OpenNebula zones can be configured as a federation, and in this case they will share the same user accounts, groups, and permissions across Data Centers.

|VDC Resources|

The Organizational Perspective
================================================================================

Users are organized into Groups (similar to what other environments call Projects, Domains, Tenants...). A Group is an authorization boundary that can be seen as a business unit if you are considering it as private cloud or as a complete new company if it is public cloud.

While Clusters are used to group Physical Resources according to common characteristics such as networking topology, or physical location, Virtual Data Centers (VDCs) allow to create "logical" clusters of physical resources. A VDC also associates the physical resources to user Groups, enabling their consumption.

Different authorization scenarios can be enabled with the powerful and configurable ACL system provided, from the definition of Group Admins to the privileges of the users that can deploy virtual machines. Each Group can execute different types of workload profiles with different performance and security requirements.

The following are common enterprise use cases in large cloud computing deployments:

* **On-premise Private Clouds** Serving Multiple Projects, Departments, Units or Organizations. On-premise private clouds in large organizations require powerful and flexible mechanisms to manage the access privileges to the virtual and physical infrastructure and to dynamically allocate the available resources. In these scenarios, the Cloud Administrator would define a VDC for each Department, dynamically allocating resources according to their needs, and delegating the internal administration of the Group to the Department IT Administrator.
* **Cloud Providers** Offering Virtual Private Cloud Computing. Cloud providers providing customers with a fully-configurable and isolated environment where they have full control and capacity to administer its users and resources. This combines a public cloud with the control usually seen in a personal private cloud system.

|VDC Groups|

For example, you can think Web Development, Human Resources, and Big Data Analysis as business units represented by Groups in a private OpenNebula cloud.

* **VDC BLUE**: VDC that allocates (ClusterA-DC_West_Coast + Cloudbursting) to Web Development
* **VDC RED**: VDC that allocates (ClusterB-DC_West_Coast + ClusterA-DC_Europe + Cloudbursting) to Human Resources
* **VDC GREEN**: VDC that allocates (ClusterC-DC_West_Coast + ClusterB-DC_Europe) to Big Data Analysis

|VDC Organization|

A Cloud Provisioning Model Based on VDCs
================================================================================

A Group is a fully-isolated virtual infrastructure environment where a group of users, optionally under the control of the Group admin, can create and manage compute and storage capacity. The users in the Group, including the Group administrator, would only see the virtual resources and not the underlying physical infrastructure. The physical resources allocated to the Group are managed by the cloud administrator through a VDC. These resources grouped in the VDC can be dedicated exclusively to the Group, providing isolation at the physical level too.

The privileges of the Group users and the administrator regarding the operations over the virtual resources created by other users can be configured. For example, in the Advanced Cloud Provisioning Case, the users can instantiate virtual machine templates to create their machines, while the administrators of the Group have full control over other users' resources and can also create new users in the Group.

|cloud-view|

Users can then access their resources through any of the existing OpenNebula interfaces, such as the CLI, Sunstone Cloud View, OCA, or the AWS APIs. Group administrators can manage their Groups through the CLI or the Group Admin View in Sunstone. Cloud Administrators can manage the Groups and VDCs through the CLI or Sunstone.

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

+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Role       |                                                                       Capabilities                                                                       |
+==================+==========================================================================================================================================================+
| **Cloud Admin.** | * Operates the Cloud infrastructure (i.e. computing nodes, networking fabric, storage servers)                                                           |
|                  | * Creates and manages OpenNebula infrastructure resources: Hosts, Virtual Networks, Datastores                                                           |
|                  | * Creates and manages Multi-VM Applications (Services)                                                                                                   |
|                  | * Creates new Groups and VDCs                                                                                                                            |
|                  | * Assigns Groups and physical resources to a VDC and sets quota limits                                                                                   |
|                  | * Defines base instance types to be used by the users. These types define the capacity of the VMs (memory, cpu and additional storage) and connectivity. |
|                  | * Prepare VM images to be used by the users                                                                                                              |
|                  | * Monitor the status and health of the cloud                                                                                                             |
|                  | * Generate activity reports                                                                                                                              |
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+

Data Center Infrastructure Management
-----------------------------------------------------------------------------

This model is used to manage data center virtualization and to integrate and federate existing IT assets that can be in different data centers. In this usage model, Users are familiar with virtualization concepts. Except for the infrastructure resources, the web interface offeres the same operations available to the Cloud Admin. These are "Advanced Users" that could be considered also as "Limited Cloud Administrators".

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

Simple Cloud Provisioning Model
-----------------------------------------------------------------------------

In the simple infrastructure provisioning model, the Cloud is offering infrastructure as a service to individual Users. Users are considered as "Cloud Users" or "Cloud Consumers", being much more limited in their operations.These Users access a very intuitive simplified web interface that allows them to launch Virtual Machines from pre-defined Templates. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

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


Advanced Cloud Provisioning Model
-----------------------------------------------------------------------------

The advanced provisioning model is an extension of the previous one where the cloud provider offers Groups on demand to projects, companies, departments or business units. Each Group can define one or more users as Group Admins. These admins can create new users inside the Group, and also manage the resources of the rest of the users. A Group Admin may, for example, shutdown a VM from other user to free group quota usage.

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

Differences with Previous Versions
================================================================================

In OpenNebula 4.6 the terms **Virtual Data Center (VDC)** and **Resource Providers** were introduced. A **Resource Provider** was not a separate entity, it was the way we called a Cluster assigned to a Group. The term **VDC** was used to name a Group with Resource Providers (Clusters) assigned, but was not a separate entity either.

Starting with OpenNebula 4.12, **VDCs** are a new kind of OpenNebula resource with its own ID, name, etc. and the term Resource Provider disappears. Making VDCs a first-class citizen has several advantages over the previous Group/VDC concept.

Now that VDCs are a separate entity, they can have one or more groups added to them. This gives the Cloud Admin greater resource assignment flexibility. For example, you may have the group Web Development added to the 'low-performance' VDC, and during a few days this Group can also be added to the 'high-performance' VDC. In previous versions, this single operation would require you to write down which resources were added to the group, to undo it later.

From the resource assignment perspective, the new VDC approach allows to create more advanced scenarios. In previous versions, the Group's Resource Providers were whole Clusters. This had some limitations, since Clusters define the topology of your physical infrastructure in a fixed way. The Admin could not assign arbitrary resources to a Group, he had to choose from those fixed Clusters.

The new VDCs contain a list of Clusters, just like before, but they can also have individual Hosts, Virtual Networks, and Datastores. This means that a VDC can create logical groups of physical resources, that don't have to resemble the real configuration of the physical infrastructure.


.. |VDC Resources| image:: /images/vdc_resources.png
.. |VDC Groups| image:: /images/vdc_groups.png
.. |VDC Organization| image:: /images/vdc_organization.png
.. |cloud-view| image:: /images/cloud-view.png
