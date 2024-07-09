.. _mastering_application_containers:

================================
Mastering Application Containers
================================

Application container technologies, like Docker and Kubernetes, are becoming the de facto leading standards for packaging, deploying and managing applications with increased levels of agility and efficiency. Docker uses OS-level virtualization to deliver software in packages called containers, and Kubernetes is a widely used tool for the orchestration of containers on clusters. Although Kubernetes is a powerful tool, it doesn't necessarily work for every single use case nor does it solve all container management-related challenges an organization might face. Kubernetes is a very complex and demanding technology, and other open source alternatives may actually be the best solution for many use cases.

OpenNebula offers a simple but powerful approach for running containerized applications and workflows by directly using the Docker official images available from the Docker Hub and running them on light-weighted microVMs that provide an extra level of efficiency and security. This solution combines all the benefits of containers with the security, orchestration and multi-tenant features of a solid Cloud Management Platform but without adding extra layers of management. Thus, both complexity and costs are reduced when compared with Kubernetes or OpenShift. For those cases where Kubernetes is required or is the best fit, OpenNebula brings support for the deployment of Kubernetes clusters through a Virtual Appliance available from the OpenNebula Public Marketplace.

|image|

.. note:: The White Paper on Mastering Application Containers with OpenNebula is publicly available for download `here <https://support.opennebula.pro/hc/en-us/articles/360050448232-Mastering-Containers-with-OpenNebula-White-Paper>`__.

.. |image| image:: /images/overview_containers.png
  :width: 70%
