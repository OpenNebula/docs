.. _simple_cloud_model:

===============================
Simple Cloud Provisioning Model
===============================

Overview
================================================================================

User Profiles
================================================================================

* Cloud Administrator
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
| **Cloud Consumer** | -                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------+

+--------------------+--------------------------------------------------------------------+
|        Role        |                    Organizational Capabilities                     |
+====================+====================================================================+
| **Cloud Admin.**   | * Creates new Users and Groups                                     |
|                    | * Assignes physical resources to the Groups                        |
|                    | * Generate accounting reports of the groups and users of the Cloud |
+--------------------+--------------------------------------------------------------------+
| **Cloud Consumer** | -                                                                  |
+--------------------+--------------------------------------------------------------------+

+--------------------+---------------------------------------------------------------------------------------------------------------+
|        Role        |                                         Virtual Resources Capabilities                                        |
+====================+===============================================================================================================+
| **Cloud Admin.**   | * Prepares VM Images to be used by the VMs                                                                    |
|                    | * Prepares VM Templates referencing the Images and Virtual Networks and providing the configuration of the VM |
|                    | * Manages all the VMs and Services of the Cloud                                                               |
|                    | * Generate activity reports of the Cloud                                                                      |
+--------------------+---------------------------------------------------------------------------------------------------------------+
| **Cloud Consumer** | * Creates and manages his own VMs and Services                                                                |
|                    | * Upload SSH keys to access the VMs                                                                           |
|                    | * Check user usage and quotas                                                                                 |
+--------------------+---------------------------------------------------------------------------------------------------------------+


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

Cloud Consumer: Using the Cloud
================================================================================
