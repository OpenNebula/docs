.. _opennebula_components:

===================
OpenNebula Overview
===================

Welcome to OpenNebula, the open source **Cloud & Edge Computing Platform** bringing real freedom to your Enterprise Cloud 🚀

OpenNebula is a **powerful, but easy-to-use, open source platform to build and manage enterprise clouds and virtualized Data Centers**. It combines existing virtualization technologies with advanced features for multi-tenancy, automatic provision and elasticity on private, hybrid, and edge environments.

OpenNebula provides a single, feature-rich and flexible platform that **unifies management of IT infrastructure and applications, preventing vendor lock-in and reducing complexity, resource consumption and operational costs**.

OpenNebula can manage:

* **Any Application**: Combine containerized applications from Kubernetes with Virtual Machine workloads in a common shared environment to offer the best of both worlds: mature virtualization technology and orchestration of application containers.

* **Any Infrastructure**: Open cloud architecture to orchestrate compute, storage, and networking driven by software.

* **Any Cloud**: Unlock the power of a true hybrid, edge and multi-cloud platform by combining your private cloud with infrastructure resources from third-party virtual and bare-metal cloud providers such as AWS and Equinix Metal, and manage all cloud operations under a single control panel and interoperable layer.

* **Any Time**: Add and remove new clusters automatically in order to meet peaks in demand, or to implement fault tolerance strategies or latency requirements.

This overview introduces the basic concepts that you need to design, install, and configure an OpenNebula cloud.

|image1|

The OpenNebula Model for Cloud Users
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula is designed for simplicity and flexibility, to help organizations adapt it to their real needs. It implements a flexible cloud model that combines Virtual Machines, virtualized and containerized applications. Its management model and underlying architecture strive to provide a single solution using proven and efficient open-source technologies to offer flexibility by allowing for different types of virtualization using a single toolset, and controlled by a single entity.

Virtualized Applications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula manages workloads based on KVM, LXC system containers. It can manage both single VMs and complex mult-tier services composed of several VMs that require sophisticated elasticity rules and dynamic adaptability. In OpenNebula, VM-based applications are created from images and templates. Users can modify templates or create new ones; they can be shared by the cloud administrator using a private corporate marketplace. Pre-defined, fully-functional templates are also available in the OpenNebula Marketplace, which allows users to easily download and deploy VMs, virtual appliances and full-featured multi-VM services.

OpenNebula’s management model provides multi-tenancy by design, offering different user interfaces depending on users’ roles within an organization, or the level of required expertise or functionality.

OpenNebula’s management tools include the Sunstone Web UI, an easy-to-use visual interface that allows for managing cloud infrastructure, including creating new templates for VMs, services, networks, etc., and implementing the full multi-tenancy features of the underlying system, allowing access to users with different roles, access and management permissions.

Containerized Applications through Kubernetes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In addition to the possibilities for containerized application deployment through LXC, OpenNebula supports the automated deployment of Kubernetes clusters through a virtual appliance, OneKE, the OpenNebula Kubernetes Engine. OneKE is an enterprise-grade, CNCF-certified Kubernetes distribution that‬ ‭simplifies the provisioning, operations, and lifecycle management of Kubernetes. It enables OpenNebula to run any type of containerized application using a single toolset, on
‭premises, on a public cloud, or at the edge. It offers the possibility a configuring as a multi-master cluster for High Availability (HA), as well as features such as a load balancing, various CNI plugins and Longhorn storage.

OneKE is available on the OpenNebula Marketplace. Using the Sunstone UI, users can easily download it from the Marketplace, apply minimal configuration, and automatically deploy it. The Quick Start Guide of this documentation features a complete tutorial for deploying it on an AWS and running an example application.

|image2|

Cloud Access Models and Roles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula’s cloud provisioning model is based on Virtual Data Centers (VDCs), designed to dynamically provision infrastructure resources in large multi-data center and multi-cloud environments to different customers, business units or groups. The following are common examples of enterprise use cases in large cloud computing environments:

* **On-premises Private Clouds** serving multiple Projects, Departments, Units or Organizations, which require fine-grained and flexible mechanisms to manage access privileges to virtual and physical infrastructures, and to dynamically allocate available resources.

* **Cloud Providers** offering customers Virtual Private Cloud Computing, including a fully-configurable and isolated environment over which customers exercise full control and capacity to administer users and resources. These environments combine a public cloud with the control usually found in a personal private cloud system.

A key management task in an OpenNebula infrastructure environment involves determining who can use the cloud administrative interfaces, and what tasks those users are authorized to perform. The person with the role of cloud service administrator is authorized to assign the appropriate rights required by other users. OpenNebula includes three default user roles: **cloud users**, **cloud operators**, and **cloud administrators**. OpenNebula further offers the possibility of designing custom roles. The OpenNebula documentation provides general guidelines and best practices for determining cloud user roles, in `Cloud Access Models and Roles` +[link to source/overview/solutions_and_best_practices, label ‘understand’ [sic].

|image3|

.. overview_vdc.png

The OpenNebula Model for Cloud Infrastructure Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A standard OpenNebula Cloud Architecture consists of:

* The **Cloud Management Cluster** with the Front-end node(s), and
* The **Cloud Infrastructure**, comprised by one or several workload **Clusters** with the hypervisor nodes and the storage system.

An OpenNebula **Front-end** manages and orchestrates the cloud infrastructure. In the infrastructure itself, a **Host** is a physical or virtual server capable of running Virtual Machines (VMs). Hosts are grouped into clusters.

Infrastructure components may reside at different geographical locations. They are interconnected by multiple networks for internal storage and node management, and for private and public VM communications.

|image4|

.. overview_resources.png

In general, there are two types of Cluster models that can be used with OpenNebula:

* **Edge Clusters** can be deployed on demand both on-premises and on public cloud and edge providers, with a high degree of integration and automation, to enable seamless hybrid cloud deployments.

* **Customized Clusters** are typically deployed on-premises to meet specific requirements.

OpenNebula includes its own Edge Cluster configuration. Based on solid open-source storage and networking technologies, OpenNebula’s Edge Cluster model is a much simpler approach than those of customized cloud architectures made of more complex, general purpose and separate infrastructure components. An OpenNebula Edge Cluster can be deployed on-demand on virtual or resources, on premises or on public cloud or edge providers to enable seamless hybrid cloud deployments.

|image5|

.. overview_edge-cluster.png



OpenNebula is certified to work on top of multiple combinations of hypervisors, storage and networking technologies. In this model you need to install and configure the underlying cloud infrastructure software components first and then install OpenNebula to build the cloud. The clusters can be deployed on-premises or on your choice of bare-metal cloud or hosting provider. While we support OpenNebula and can troubleshoot the cloud infrastructure as a whole, please be aware that you might need to seek commercial support from third-party vendors for the rest of components in your cloud stack.

If you are interested in an OpenNebula cloud fully based on open-source platforms and technologies, please refer to our `Open Cloud Reference Architecture <https://support.opennebula.pro/hc/en-us/articles/204210319>`__.


|image6|

.. overview_customized-cluster.png

Choosing the Right Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Organizations’ and users’ needs are varied, and constantly evolve over time. We strongly believe that users should be able to choose their own cloud infrastructure configuration, or combination of configurations, that truly helps their business to grow. Our experience working with hundreds of customer engagements shows that our **Edge Cluster** configuration meets the needs of 90% of their deployments. An OpenNebula Edge Cluster implements enterprise-grade cloud features for performance, availability and scalability with a very simple design that avoids vendor lock-in and reduces complexity, resource consumption and operational costs. Moreover, it enables seamless hybrid cloud deployments that are natively integrated into public clouds. OpenNebula offers a single vendor experience by providing one-stop support and services for your entire cloud stack.

OpenNebula Components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula was designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of cloud architectures and interface with multiple data center services.

|image7|

.. overview-architecture.png

The main components of an OpenNebula installation are listed below.

* **OpenNebula Daemon** (``oned``): The OpenNebula Daemon is the core service of the cloud management platform. It manages the cluster nodes, virtual networks and storages, groups, users and their virtual machines, and provides the XML-RPC API to other services and end-users.

* **Database**: OpenNebula persists the state of the cloud a user-selected SQL database. This key component should be monitored and tuned for best performance, following best practices for the particular database product.

* **Scheduler**: The OpenNebula Scheduler is responsible for planning deployment of pending Virtual Machines on available hypervisor nodes. It’s a dedicated daemon (``mm_sched``) installed alongside the OpenNebula Daemon, but can be deployed independently on a different machine.

* **Edge Cluster Provision**: This component creates fully functional OpenNebula Clusters on public cloud or edge providers. The Provision module integrates Edge Clusters into your OpenNebula cloud by utilizing these three core technologies: Terraform, Ansible and the OpenNebula Services.

* **Monitoring Subsystem**: The monitoring subsystem is implemented as a dedicated daemon (``onemonitord``) launched by the OpenNebula Daemon. It gathers information relevant to the Hosts and the Virtual Machines, such as Host status, basic performance indicators, Virtual Machine status and capacity consumption.

* **OneFlow**: The OneFlow service orchestrates multi-VM services as single entities, defining dependencies and auto-scaling policies for the application components. It interacts with the OpenNebula Daemon to manage the Virtual Machines (starts, stops), and can be controlled via the Sunstone GUI or over CLI. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

* **OneGate**: The OneGate server allows Virtual Machines to pull and push information from/to OpenNebula, enabling users and admins to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VMs. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

* **OneGate/Proxy**: The OneGate/Proxy service is a simple TCP proxy solution that can be used to improve security for the OneGates endpoint, and which users can enable on hypervisor Nodes. When using this service, it is no longer necessary to expose the OneGate server on a public IP address in certain environments; furthermore, it greatly simplifies protecting the traffic to and from OneGate with a VPN solution.

These are OpenNebula’s system interfaces:

* **Sunstone**: OpenNebula’s next-generation Graphical User Interface (WebUI) intended for both end users and administrators to easily manage all OpenNebula resources and perform typical operations. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

* **CLI**: OpenNebula includes a comprehensive set of Unix-like command-line tools to interact with the system and its different components.

* **XML-RPC API**: This is the primary interface for OpenNebula, through which you can control and manage any OpenNebula resource, including VMs, Virtual Networks, Images, Users, Hosts, and Clusters.

* **OpenNebula Cloud API**: The OCA provides a simplified and convenient way to interface with the OpenNebula core XML-RPC API, including support for Ruby, Java, Golang, and Python.

* **OpenNebula OneFlow API**: This is a RESTful service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.

The interactions between OpenNebula and the underlying cloud infrastructure are performed by specific drivers. Each one addresses a particular area:

* **Storage**: This OpenNebula core layer abstracts storage operations (e.g. clone or delete) implemented by specific programs, which can be replaced or modified to interface special storage backends and filesystems.

* **Virtualization**: OpenNebula implements interactions with hypervisors by using custom programs to boot, stop or migrate a virtual machine. This allows you to specialize each VM operation so as to perform custom operations.

* **Monitoring**: Monitoring information is also gathered by external probes. You can add additional probes to include custom monitoring metrics that can later be used to allocate virtual machines, or for accounting purposes.

* **Authorization**: OpenNebula can also be configured to use an external program to authorize and authenticate user requests, allowing you to implement any access policy to Cloud resources.

* **Networking**: The hypervisor is also prepared with the network configuration for each Virtual Machine.

* **Event Bus**: A generic message bus where OpenNebula publishes resource events. The message bus is used to synchronize OpenNebula services as well as to integrate custom applications.

The OpenNebula documentation provides a summary of its :ref:`key features <key_features>`. The :ref:`Platform Notes <uspng>` list the infrastructure platforms and resources supported by each OpenNebula release. Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.

Next Steps
^^^^^^^^^^

**Building an evaluation environment**

We strongly recommend you evaluate OpenNebula by following our :ref:`Quick Start Guide <quick_start>`. The Guide will walk you through a set of tutorials that start at :ref:`installing an OpenNebula Front-end <try_opennebula_on_kvm>`, continue with :ref:`deploying an Edge Cluster on AWS <first_edge_cluster>`, then a :ref:`WordPress appliance <running_virtual_machines>` and finally a :ref:`Kubernetes cluster <running_kubernetes_clusters>`, all using the Sunstone web UI. This is the quickest way to familiarize yourself with OpenNebula since most tutorials take under ten minutes to complete.

**Setting up a production environment**

If you are interested in building a production environment, then :ref:`Cloud Architecture Design <intro>` is a good resource to explore and consider the available options and choices.

Remember that if you need our support at any time, or access to our professional services or to the **Enterprise Edition**, you can always `contact us <https://opennebula.io/enterprise>`__.


.. |image1| image:: /images/overview_key-features.png
  :width: 70%

.. |image2| image:: /images/overview_containers.png
  :width: 70%

.. |image3| image:: /images/overview_vdc.png
  :width: 70%

.. |image4| image:: /images/overview_resources.png
  :width: 70%

.. |image5| image:: /images/overview_edge-cluster.png
  :width: 70%

.. |image6| image:: /images/overview_customized-cluster.png
  :width: 70%

.. |image7| image:: /images/overview_architecture.png
  :width: 70%
