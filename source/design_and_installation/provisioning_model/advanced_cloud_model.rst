.. _advanced_cloud_model:

=================================
Advanced Cloud Provisioning Model
=================================

Overview
================================================================================

User Profiles
================================================================================

* Cloud Administrator
* vDC Administrator
* Cloud Consumer

Capabilities
================================================================================

+--------------------+-------------------------------------------------------------------------------------------------+
|        Role        |                                   Infrastructure Capabilities                                   |
+====================+=================================================================================================+
| **Cloud Admin.**   | * Operates the Cloud infrastructure (i.e. computing nodes, networking fabric, storage servers)  |
|                    | * Creates and manages OpenNebula infrastructure resources: Hosts, Virtual Networks, Datastores  |
|                    | * Group the OpenNebula infrastructure resources in Clusters with different QoS or configuration |
|                    | * Monitor the status and health of the cloud                                                    |
+--------------------+-------------------------------------------------------------------------------------------------+
| **vDC Admin**      | -                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------+
| **Cloud Consumer** | -                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------+

+--------------------+--------------------------------------------------------------------+
|        Role        |                    Organizational Capabilities                     |
+====================+====================================================================+
| **Cloud Admin.**   | * Creates new Groups and vDC admin users                           |
|                    | * Define Quotas for each vDC                                       |
|                    | * Assignes resource providers to the Groups                        |
|                    | * Generate accounting reports of the groups and users of the Cloud |
+--------------------+--------------------------------------------------------------------+
| **vDC Admin**      | * Creates new Users in the vDC                                     |
|                    | * Define Quotas for each User                                      |
|                    | * Assignes physical resources to the Groups                        |
|                    | * Generate accounting reports of the users of the vDC              |
+--------------------+--------------------------------------------------------------------+
| **Cloud Consumer** | -                                                                  |
+--------------------+--------------------------------------------------------------------+

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
|        Role        |                                                              Virtual Resources Capabilities                                                             |
+====================+=========================================================================================================================================================+
| **Cloud Admin.**   | * Prepares VM Images to be used by the VMs                                                                                                              |
|                    | * Prepares VM Templates referencing the Images and Virtual Networks and providing the configuration of the VM                                           |
|                    | * Prepares Service Templates referencing multiple VM Templates                                                                                          |
|                    | * Defines base instance types to be used by the vDCs. These types define the capacity of the VMs (memory, cpu and additional storage) and connectivity. |
|                    | * Manages all the VMs and Services of the Cloud                                                                                                         |
|                    | * Generate activity reports                                                                                                                             |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| **vDC Admin**      | * Manages all VMs and Services of the vDC                                                                                                               |
|                    | * Checks vDC usage and quotas                                                                                                                           |
|                    | * Generate activity reports of the vDC                                                                                                                  |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Cloud Consumer** | * Creates and manages his own VMs and Services                                                                                                          |
|                    | * Upload SSH keys to access the VMs                                                                                                                     |
|                    | * Check user usage and quotas                                                                                                                           |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+


Cloud Administrator: Adding Content to Your Cloud
================================================================================
Virtual Machines
* External Image
* Install within OpenNebula
* Marketplace

Services

Cloud Administrator: Creating new Users and vDCs
================================================================================

Cloud Administrator: Sharing Content with the Users of the Cloud
================================================================================

vDC Admnistrator: Creating new Users in the vDC
================================================================================

vDC Admnistrator: Customizing the Content of the Cloud for the vDC users
================================================================================

Cloud Consumer: Using the Cloud
================================================================================
