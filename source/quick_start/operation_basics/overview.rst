.. _operations_basics_overview:

========
Overview
========

OpenNebula provides the tools and methods needed to dynamically grow your cloud infrastructure with Edge Clusters built with virtual and physical resources running on remote cloud providers. You are able to grow your private cloud with resources at cloud and edge data center locations and enable true hyrbid and multi-cloud environments to meet latency, bandwidth, or data regulation needs of your workload.

.. image:: /images/edge_cluster_overview.png
    :width: 50%
    :align: center

In this quick start guide we use Edge Clusters to easily build a cloud infrastructure and try the main operation and user features of OpenNebula. We are going to try different workloads. Each workload needs to be deployed in a compatible type of Edge Cluster, since not all of them are capable of running all types of workload. More information on this is available in the :ref:`platform notes <uspng>`.

.. table::
   :widths: 60,15,25
   :align: left

   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | Use Case                                                           | Edge Cluster |  Hypervisor                                           |
   +====================================================================+==============+=======================================================+
   | :ref:`I want to run application containers...                      | virtual      | LXC                                                   |
   | <running_containers>`                                              +--------------+-------------------------------------------------------+
   |                                                                    | metal        | LXC, Firecracker                                      |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | :ref:`I want to run virtual servers... <running_virtual_machines>` | virtual      | LXC                                                   |
   | <running_containers>`                                              +--------------+-------------------------------------------------------+
   |                                                                    | metal        | LXC, KVM                                              |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
   | I want to run a Kubernetes cluster...                              | metal        | KVM (:ref:`k8s based <running_kubernetes_clusters>`)  |
   |                                                                    |              +-------------------------------------------------------+
   |                                                                    |              | Firecracker (:ref:`k3s based <running_k3s_clusters>`) |
   +--------------------------------------------------------------------+--------------+-------------------------------------------------------+
