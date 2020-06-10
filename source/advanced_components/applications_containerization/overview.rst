.. _overview:

================================================================================
Overview
================================================================================

Application container technologies, like `Docker <https://docker.com>`_ and `Kubernetes <https://kubernetes.io>`_, are becoming the leading standards for building containerized applications. They are serving as a foundation for deploying, running and managing applications because they offer increased levels of agility and efficiency. Kubernetes is widely used for the orchestration of containers on clusters, offering features for automating application deployment, scaling, and management.

OpenNebula supports application containerization by offering different tools and integrations.

Firstly, OpenNebula brings a built-in integration with Docker to simplify the provision and management of Dockerized hosts on your private cloud. OpenNebula provides cloud users with two approaches:

* The simpler approach is to directly instantiate the :ref:`OpenNebula Docker Appliance <docker_appliance_overview>` available on the OpenNebula Marketplace and then manage the dockerized hosts by using OpenNebula CLI or Sunstone.

* OpenNebula also provides a driver for :ref:`Docker Machine <docker_machine_overview>`, which allows the remote provision and management of Docker hosts within OpenNebula cloud, and the execution of Docker commands on the remote host from your Docker client.

As an alternative to run containerized applications, :ref:`OpenNebula Docker Hub Integration <docker_hub_overview>` provide access to `Docker Hub <https://hub.docker.com>`_ Official Images. This integration allows to easily import Docker images to the OpenNebula cloud. The OpenNebula context packages are installed during the import process so once an image is imported it’s fully prepared to be used on any supported hypervisor.

Furthermore, you can use different container orchestration platforms in your OpenNebula cloud: 

* Check :ref:`Docker Swarm Integration <docker_swarm_overview>` to see how to build `Docker Engine clusters <https://docs.docker.com/engine/swarm/>`_ within your OpenNebula cloud using `Docker Swarm Classic <https://github.com/docker/classicswarm>`_  and `Docker Swarmkit <https://github.com/docker/swarmkit>`_

* Check :ref:`Kubernetes Integration <kubernetes_appliance_overview>` to build and manage Kubernetes clusters within your OpenNebula Cloud

* Check :ref:`Rancher Integration <rancher_integration_overview>` to build and manage Kubernetes clusters using `Rancher <https://rancher.com>`_ within your OpenNebula Cloud

How Should I Read This Chapter
================================================================================

To learn more about Docker microservices inside the OpenNebula platform we recommend you to read the :ref:`Docker integration <docker_appliance_overview>`.

You can then continue with the :ref:`Docker Machine guide <docker_machine_overview>` - if you are interested in remote management of Docker hosts and clusters from a single remote location.

When you are more familiar with Docker you can proceed to the sections for :ref:`Docker Engine Clusters <docker_swarm_overview>`, :ref:`OpenNebula Kubernetes Appliance <kubernetes_appliance_overview>` or :ref:`Rancher Integration <rancher_integration_overview>`.

After reading this chapter you can continue configuring more :ref:`Advanced Components <advanced_components>`.

.. note::

   You can also consider the option of running your Docker application inside the :ref:`Firecracker microVM <fcmg>` and utilize the :ref:`Docker Hub <market_dh>`.

Hypervisor Compatibility
================================================================================

This Chapter applies both to KVM and vCenter.

.. |docker-machine| image:: /images/docker_arch.png
