.. _kubernetes_appliance_overview:

================================================================================
Kubernetes Hosting
================================================================================

`Kubernetes <https://kubernetes.io/>`_ is a Linux container orchestration technology which has become a de-facto standard for cloud native applications. It has a long development lineage at Google before it even got its current name and became open-sourced. `Docker <https://www.docker.com>`_ was supported as the default container runtime from its inception but Kubernetes strives to be runtime-agnostic. 

Kubernetes is widely used for for the deployment and management of production containerized workflow at scale offering features such as self healing, automated rollout and rollbacks, secret and configuration management, service discovery and load balancing. 

OpenNebula provides integration with Kubernetes thanks to the `Kubernetes appliance <https://docs.opennebula.io/appliances/service/kubernetes.html>`_, that:
 
* Provides an auto-configured cluster with information exchanged over additional OpenNebula services (:ref:`OneGate <onegate_usage>`), managed as one entity (:ref:`OneFlow <appflow_use_cli>`). 

* Dynamically increase/decrease the Kubernetes cluster based on hypervisor and/or application metrics.

* Enables the provisioning of managed Kubernetes clusters and application containers on demand with just 1 click. Easily deploy different Kubernetes architectures for different users and applications.

* Runs anywhere with a built-in configuration of components (e.g., networking) selected to deal with restrictions on the end user side.

Hosting a virtualized container orchestration framework like Kubernetes on an OpenNebula private cloud:  

* Provides a flexible infrastructure environment with dynamic allocation and partitioning of physical resources, resizing of  the virtual resources on the fly, or overprovisioning if necessary. 

* Allows to encompass containers with other virtualized workloads.

* Provides a multi-tenant environment for the execution of multiple container clusters on a shared physical infrastructure.

* Enhances security thanks to the additional layer provided by the hardware virtualization to isolate different resource pools (virtual machines) on the same host.

* Offers abstraction from physical hardware, allowing to rebuild a whole container cluster from scratch without messing with the physical hosts. Grow your Kubernetes cluster with on-prem and remote bare-metal providers.
