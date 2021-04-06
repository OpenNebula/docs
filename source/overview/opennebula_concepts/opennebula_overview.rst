.. _opennebula_components:

===================
OpenNebula Overview
===================

Welcome to OpenNebula, the open source **Cloud & Edge Computing Platform** bringing real freedom to your Enterprise Cloud 🚀

OpenNebula is a **powerful, but easy to use, open source solution to build and manage Enterprise Clouds**. It combines virtualization and container technologies with multi-tenancy, automatic provision and elasticity to offer on-demand applications and services on private, hybrid and edge environments. This guide introduces the basic concepts that you need to design, install, configure and operate an OpenNebula cloud, both on-premises and as a hosted solution.

Bringing Real Freedom to Your Enterprise Cloud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

OpenNebula provides a single, feature-rich and flexible platform that **unifies management of IT infrastructure and applications, preventing vendor lock-in and reducing complexity, resource consumption and operational costs**.

OpenNebula can manage:

* **Any Application**: Combine containerized applications from Kubernetes and Docker Hub ecosystems with Virtual Machine workloads in a common shared environment to offer the best of both worlds: mature virtualization technology and orchestration of application containers.

* **Any Infrastructure**: Unlock the power of a true hybrid, edge and multi-cloud platform by combining expanding your private cloud with infrastructure resources from third-party public cloud and bare-metal providers such as AWS and Packet (Equinix Metal).

* **Any Virtualization**: Integrate multiple types of virtualization technologies to meet your workload needs, including VMware and KVM virtual machines for fully virtualized clouds, LXC system containers for container clouds, and Firecracker microVMs for serverless deployments.

* **Any Time**: Automatically add and remove new resources in order to meet peaks in demand, or to implement fault-tolerant strategies or latency requirements.

|image1|

The OpenNebula Model for Cloud Users
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

No two use cases are the same, so OpenNebula has been designed with flexibility in mind to help you to adapt it to the real needs of your organization and not the other way round! Below you’ll find some of the basic use cases and application models that OpenNebula supports.

Virtualized Applications
========================

* OpenNebula orchestrates **Virtual Machines**, but depending on the kind of workload you can use different types of hypervisors. OpenNebula can be deployed on top of your VMware vCentre infrastructure, but it can also manage KVM-based workloads as well as LXC **system containers** and lightweight Firecracker **microVMs** (especially convenient, for instance, to run application containers).

* OpenNebula provides **multi-tenancy** by design, offering different types of interfaces for users depending on their roles within your organization or the level of expertise or functionality required.

* OpenNebula can manage both single VMs and complex **multi-tier services** composed of several VMs that require sophisticated elasticity rules and dynamic adaptability.

* VM-based applications are created from images and templates that are available from the **OpenNebula Public Marketplace** but can also be created by the users themselves and shared by the cloud administrator using a private corporate marketplace.

* This model enables the quick instantiation of applications and complex services, including for instance the deployment of **Kubernetes** clusters at the edge.

Containerized Applications
==========================

OpenNebula offers a new, native approach for running containerized applications and workflows by directly using the official Docker images available from the **Docker Hub** and running them as LXC system containers or as lightweight **Firecracker microVMs**, a method that provides an extra level of efficiency and security. This solution combines all the benefits of containers with the security, orchestration and multi-tenant features of a solid Cloud Management Platform but without adding extra layers of management, thus reducing the complexity and costs—compared with Kubernetes or OpenShift.

For those cases where Kubernetes is required or is the best fit, OpenNebula also brings support for the deployment of Kubernetes clusters through a **CNCF-certified** virtual appliance available from the OpenNebula Public Marketplace or through the **k3s** Lightweight Kubernetes for resource-constrained and edge locations. For more details, please refer to the `web section and white paper <https://opennebula.io/mastering-containers/>`_ in which we describe OpenNebula’s native features for container orchestration, and how it integrates with third-party technologies like Docker, Kubernetes and Rancher.

|image2|

Cloud Access Model and Roles
============================

OpenNebula offers a flexible and powerful cloud provisioning model based on **Virtual Data Centers (VDCs)** that enables an integrated, comprehensive framework to dynamically provision the infrastructure resources in large multi-datacenter and multi-cloud environments to different customers, business units or groups. For example, the following are common enterprise use cases in large cloud computing deployments:

* **On-premise Private Clouds** serving multiple Projects, Departments, Units or Organizations: On-premise private clouds in large organizations require powerful and flexible mechanisms to manage the access privileges to the virtual and physical infrastructure and to dynamically allocate the available resources.

* **Cloud Providers** offering Virtual Private Cloud Computing: Cloud providers offering their customers a fully-configurable and isolated environment where they have full control and capacity to administer its users and resources. This combines a public cloud with the control usually seen in a personal private cloud system.

A key management task in any OpenNebula Infrastructure environment has to do with determining who can use the cloud interfaces and what tasks those users are authorized to perform. The person with the role of cloud service administrator is authorized to assign the appropriate rights required by other users. OpenNebula brings three default types of user roles: cloud users, cloud service administrators (operators), and cloud infrastructure administrators. The OpenNebula documentation provides information to help with the designing of custom roles, and gives recommendations for how to work with roles and privileges in OpenNebula. For more details, please refer to the `Cloud Provisioning Model and User Roles <http://docs.opennebula.io/6.1/overview/solutions_and_best_practices/cloud_access_model_and_roles.html>`_ section.

|image3|

The OpenNebula Model for Cloud Infrastructure Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A standard OpenNebula Cloud Architecture consists of:

* The **Cloud Management Cluster** with the Front-end node(s), and

* The **Cloud Infrastructure**, made of one or several workload **Clusters** with the hypervisor nodes and the storage system, which can be located at multiple geographical locations, all interconnected with multiple networks for internal storage and node management, and for private and public guest (VM or container) communication.

|image4|

An OpenNebula Cloud Infrastructure can combine multiple clusters with different configurations and technologies to better meet your needs. In general, there are two types of Cluster models that can be used with OpenNebula:

* **Edge Clusters**: can be deployed on demand both on-premises and on public cloud and edge providers, with a high degree of integration and automation.

* **Customized Clusters**: typically these are deployed on-premises to meet specific requirements.

Edge Cluster
============

OpenNebula brings its own Edge Cluster configuration that is based on solid open source storage and networking technologies, and is a much simpler approach than those of customized cloud architectures made of more complex, general-purpose and separate infrastructure components. It can be deployed on-demand on virtual or bare-metal resources both on-premises and on your choice of public cloud or edge provider. Our Edge Clusters are **fully supported end-to-end by OpenNebula Systems**. More info on this approach can be found on our `website <https://opennebula.io/edge-cloud/>`_.

|image5|

Customized Cluster
==================

OpenNebula is certified to work on top of multiple combinations of hypervisors, storage and networking technologies. In this model you need to install and configure the underlying cloud infrastructure software components first and then install OpenNebula to build the cloud. The clusters can be deployed on-premises or on your choice of bare-metal cloud or hosting provider. While we support OpenNebula and can troubleshoot the cloud infrastructure as a whole, please be aware that you might need to seek commercial support from third-party vendors for the rest of components in your cloud stack. If you are interested in designing and deploying an OpenNebula cloud on top of VMware vCenter, please refer to our `VMWare Cloud Reference Architecture <https://support.opennebula.pro/hc/en-us/articles/206652953>`_. If you are interested in an OpenNebula cloud fully based on open-source platforms and technologies, please refer to our `Open Cloud Reference Architecture <https://support.opennebula.pro/hc/en-us/articles/204210319>`_.

|image6|

Which is the Right One for You?
===============================

Our users have different needs that are constantly evolving over time. We strongly believe that they should be able to choose the cloud infrastructure configuration, or combination of configurations, that really accelerates their business. Our experience working with hundreds of customer engagements shows that our **Edge Cluster** configuration meets the needs of 90% of their deployments. It implements enterprise-grade cloud features for performance, availability and scalability with a very simple design that avoids vendor lock-in and reduces complexity, resource consumption and operational costs. Moreover, it enables seamless hybrid cloud deployments that are natively integrated into public clouds. OpenNebula offers a single vendor experience by providing one-stop support and services for your entire cloud stack.

OpenNebula Components
^^^^^^^^^^^^^^^^^^^^^

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of cloud architectures and can interface with multiple data center services.

|image7|

The main components of an OpenNebula installation are:

* **OpenNebula Daemon** (*oned*): The OpenNebula Daemon is the core service of the cloud management platform. It manages the cluster nodes, virtual networks and storages, groups, users and their virtual machines, and provides the XML-RPC API to other services and end-users.

* **Database**: OpenNebula persists the state of the cloud into the selected SQL database. This is a key component that should be monitored and tuned for the best performance by cloud administrators following the best practices of the particular database product.

* **Scheduler**: The OpenNebula Scheduler is responsible for the planning of the pending Virtual Machines on available hypervisor Nodes. It’s a dedicated daemon installed alongside the OpenNebula Daemon, but can be deployed independently on a different machine.

* **Edge Cluster Provision**: This component creates fully functional OpenNebula Clusters on public cloud or edge providers. The Provision module integrates Edge Clusters into your OpenNebula cloud by utilizing these three core technologies: Terraform, Ansible and the OpenNebula Services.

* **Monitoring**: The monitoring subsystem is represented by a dedicated daemon running as part of the OpenNebula Daemon. It gathers information relevant to the Hosts and the Virtual Machines, e.g. Host status, basic performance indicators, Virtual Machine status, and capacity consumption.

* **OneFlow**: The OneFlow orchestrates multi-VM services as a whole, defining dependencies and auto-scaling policies for the application components, interacts with the OpenNebula Daemon to manage the Virtual Machines (starts, stops), and can be controlled via the Sunstone GUI or over CLI. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

* **OneGate**: The OneGate server allows Virtual Machines to pull and push information from/to OpenNebula, so users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VMs. It can be used with all hypervisor Host types (KVM, LXC, FIrecracker, and vCenter) if the guest operating system has preinstalled the OpenNebula contextualization package. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

These are OpenNebula’s system interfaces:

* **Sunstone**: OpenNebula comes with a Graphical User Interface (WebUI) intended for both end users and administrators to easily manage all OpenNebula resources and perform typical operations. It’s a dedicated daemon installed by default as part of the Single Front-end Installation, but can be deployed independently on a different machine.

* **FireEdge**: The FireEdge server provides a next-generation Graphical User Interface (WebUI) for the provisioning of remote OpenNebula Clusters (leveraging the new OneProvision tool) as well as additional functionality to Sunstone.

* **CLI**: OpenNebula provides a significant set of commands to interact with the system and its different components via terminal.

* **XML-RPC API**: This is the primary interface for OpenNebula, through which you can control and manage any OpenNebula resource, including VMs, Virtual Networks, Images, Users, Hosts, and Clusters.

* **OpenNebula Cloud API**: The OCA provides a simplified and convenient way to interface with the OpenNebula core XML-RPC API, including support for Ruby, Java, Goland, and Python.

* **OpenNebula OneFlow API**: This is a RESTful service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.

The interactions between OpenNebula and the underlying cloud infrastructure are performed by specific drivers. Each one addresses a particular area:

* **Storage**: The OpenNebula core issue abstracts storage operations (e.g. clone or delete) that are implemented by specific programs that can be replaced or modified to interface special storage backends and file-systems.

* **Virtualization**: The interaction with the hypervisors are also implemented with custom programs to boot, stop or migrate a virtual machine. This allows you to specialize each VM operation so as to perform custom operations.

* **Monitoring**: Monitoring information is also gathered by external probes. You can add additional probes to include custom monitoring metrics that can later be used to allocate virtual machines or for accounting purposes.

* **Authorization**: OpenNebula can be also configured to use an external program to authorize and authenticate user requests. In this way, you can implement any access policy to Cloud resources.

* **Networking**: The hypervisor is also prepared with the network configuration for each Virtual Machine.

* **Event Bus**: A generic message bus where OpenNebula publishes resource events. The message bus is used to synchronize OpenNebula services as well as to integrate custom applications.

The OpenNebula documentation summarizes the `Platform Notes <http://docs.opennebula.io/6.1/intro_release_notes/release_notes/platform_notes.html>`_ with the infrastructure platforms and services supported by each OpenNebula release, and its `key features <http://docs.opennebula.io/6.1/overview/opennebula_concepts/key_features.html>`_. Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.

Next Steps
^^^^^^^^^^

**Building an evaluation environment**

You can always evaluate OpenNebula by following our `Quick Start <http://docs.opennebula.io/6.1/quick_start/index.html>`_ guide, where you will learn how to use `vOneCloud <http://docs.opennebula.io/6.1/quick_start/deployment_basics/try_opennebula_on_vmware.html>`_—our virtual appliance for VMware vSphere—or `miniONE <http://docs.opennebula.io/6.1/quick_start/deployment_basics/try_opennebula_on_kvm.html>`_—our deployment tool for installing a single-node OpenNebula cloud with KVM inside a virtual machine or physical host— and then to provision an OpenNebula Edge Cluster on AWS to run your `containers <http://docs.opennebula.io/6.1/quick_start/usage_basics/running_containers.html>`_, `virtual machines <http://docs.opennebula.io/6.1/quick_start/usage_basics/running_virtual_machines.html>`_ or `Kubernetes <http://docs.opennebula.io/6.1/quick_start/usage_basics/running_kubernetes_clusters.html>`_ clusters on a truly multi-cloud environment. This is the fastest way for you to familiarize yourself with the new OpenNebula, as you only need the necessary resources to deploy the OpenNebula front-end.

**Setting up a production environment**

If you are interested in building a production environment, the `Cloud Architecture Design <http://docs.opennebula.io/6.1/overview/cloud_architecture_and_design/cloud_architecture_design.html>`_ guide is a good resource for you to explore the different options to consider and the available choices. Remember that if you need our support at any time, or access to our professional services (including our **Managed Cloud Services**) or to the **Enterprise Edition**, you can always `contact us <https://opennebula.io/enterprise>`_.


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


