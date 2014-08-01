.. _overview_cloud_model:

================================================================================
An Overview of Cloud Provisioning Models
================================================================================

This guide is meant for the cloud architect and administrator, to help him to understand the way OpenNebula categorizes the infrastructure resources, and how they are consumed by the users.

Common large IT shops have multiple Data Centers (DCs), each one of them consisting of several physical Clusters of infrastructure resources (hosts, networks and storage). These Clusters could present different architectures and software/hardware execution environments to fulfill the needs of different workload profiles. Moreover, many organizations have access to external public clouds to build :ref:`hybrid cloud <intro_h>` scenarios where the private capacity of the Data Centers is supplemented with resources from external clouds to address peaks of demand. Sysadmins need a single comprehensive framework to dynamically allocate all these available resources.

For example, you could have two Data Centers in different geographic locations, Europe and USA West Coast, and an agreement for cloudbursting with a public cloud provider, such as Amazon. Each Data Center runs its own full OpenNebula deployment. Multiple OpenNebula installations can be configured as a :ref:`federation <introf>`, and in this case they will share the same user accounts, groups, and permissions across Data Centers.

Although OpenNebula has been designed and developed to be easy to adapt to each individual company use case and processes, and perform fine-tuning of multiple aspects, we have identified three pre-defined models for cloud provisioning and consumption.

* **Data Center Infrastructure Managemnt**
* **Simple Cloud Provisioning Model**
* **Advanced Cloud Provisioning Model**

These OpenNebula models are a result of our collaboration with our user community during the last years.

The main difference between these three models is the kind of users that are going to interact with OpenNebula to manage or use the cloud, and the privileges assigned to them.


Data Center Infrastructure Managemnt
================================================================================

In this model the only kind of user that will interact with OpenNebula is the Cloud Administrator. There could be more than one Cloud Administrator registered in OpenNebula, but they are the only ones that will create new resources in the cloud. The Cloud Administrator has full control of the cloud and these are some of the tasks of his workflow:

If there is any cloud consumer, they will not be aware of OpenNebula. For example, the testing department needs a new CentOS 7 VM to test the new version of the software. The testing department will ask for a new VM to the Cloud Administrator; the Cloud Administrator will create a new VM and will send the IP and credentials to the testing department.

OpenNebula User Profiles:
* Cloud Administrator

Simple Cloud Provisioning Model
================================================================================

In this model, the cloud consumer interacts with OpenNebula through a simplified web interface that allows them to launch Virtual Machines from pre-defined Templates and Images. They can access their VMs, and perform basic operations like shutdown. The changes made to a VM disk can be saved back, but new Images cannot be created from scratch.

Users are organized into Groups (also called Projects, Domains, Tenants...). A Group is an authorization boundary that can be seen as a business unit if you are considering it as private cloud or as a complete new company if it is public cloud. A Group is simply a boundary, you need to populate resources into the Group which can then be consumed by the users of that Group. A vDC (Virtual Data Center) is a Group plus Resource Providers assigned. A Resource Provider is a Cluster of infrastructure resources (physical hosts, networks, storage and external clouds) from one of the Data Centers.

OpenNebula User Profiles:
* Cloud Administrator
* Cloud Consumer

Advanced Cloud Provisioning Model
================================================================================

Optionally, each vDC can define one or more users as vDC Admins. These admins can create new users inside the vDC, and also manage the resources of the rest of the users. A vDC Admin may, for example, shutdown a VM from other user to free group quota usage.

OpenNebula User Profiles:
* Cloud Administrator
* vDC Administrator
* Cloud Consumer

