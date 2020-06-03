.. _overview:

================================================================================
Overview
================================================================================

`Containerization <https://en.wikipedia.org/wiki/OS-level_virtualization>`_ is in general an **OS-level virtualization** method used to deploy and run lightweight VMs (here called containers) without the overhead of conventional fully (or even para) virtualized machines. Container technology does not emulate hardware and actually has no need for any virtualization support in the CPU (without any perfomance hit). These containers are basically isolated process trees sharing one kernel on the same host.

Actually containerization is not such a new concept but before it emerged on the Linux platform there was some evolution of containerization technologies and later even a paradigm shift. What was historically called container virtualization we now call the **system containerization** while the new paradigm became known as **application containerization** - following the design patterns of `microservices <https://en.wikipedia.org/wiki/Microservices>`_. OpenNebula supports both these containerization methods:

   * Firstly OpenNebula provides a native support for system containerization via :ref:`LXD driver <lxdmg>` which enables creation of VMs with a very low footprint but the same functionality as VMs on the full blown hypervisor. For more info how to install and use LXD check out the :ref:`LXD documentation <lxd_node>`.
   * Secondly the most popular container runtime - `Docker <https://www.docker.com>`_ - representing the application containerization is supported via OpenNebula's :ref:`Docker Machine driver <docker_machine_overview>` to simplify the provision and management of Dockerized hosts.

Despite the differences in the goals and concepts of these two containerization methodologies - they both share many similarities and rely under the hood on the same features and capabilities provided by the Linux kernel.

Furthermore there is an integration with the most popular Linux container orchestration tool called `Kubernetes <https://kubernetes.io>`_ via OpenNebula's `Kubernetes appliance <https://docs.opennebula.io/appliances/service/kubernetes.html>`_.

How Should I Read This Chapter
================================================================================

To learn more about Docker microservices inside the OpenNebula platform we recommend you to read the :ref:`Docker integration <docker_appliance_overview>`.

You can then continue with the :ref:`Docker Machine guide <docker_machine_overview>` - if you are interested in remote management of Docker hosts and clusters from a single remote location.

When you are more familiar with the Docker you can proceed to the :ref:`OpenNebula Kubernetes appliance <kubernetes_appliance_overview>` or :ref:`Rancher <rancher_integration_overview>`.

After reading this chapter you can continue configuring more :ref:`Advanced Components <advanced_components>`.

.. note::

   You can also consider the option of running your Docker application inside the :ref:`Firecracker microVM <fcmg>` and utilize the :ref:`Docker Hub <market_dh>`.

Hypervisor Compatibility
================================================================================

This Chapter applies both to KVM and vCenter.

.. |docker-machine| image:: /images/docker_arch.png
