.. _firecracker_node_deployment_overview:

================================================================================
Overview
================================================================================

`Firecracker <https://firecracker-microvm.github.io/>`__ is an open source virtual machine monitor (VMM) developed by AWS — It's widely used as part of its Fargate and Lambda services⁠. Firecracker is especially designed for creating and managing secure, multi-tenant container and function-based services. It enables to deploy workloads in lightweight VMs (called **microVMs**) which provide enhanced security and workload isolation over traditional VMs, while enabling the speed and resource efficiency of containers.

Firecracker uses the Linux Kernel-based Virtual Machine (KVM) to create and manage microVMs. It has a minimalist design, excluding unnecessary devices and guest functionality to reduce the memory footprint and attack surface area of each microVM.

How Should I Read This Chapter
================================================================================

This chapter focuses on the configuration options for a Firecracker based Hosts. Read the :ref:`installation <fc_node>` section to add a Firecracker host to your OpenNebula cloud to start deploying microVMs. Continue with :ref:`driver <fcmg>` section in order to understand the specific requirements, functionalities, and limitations of the Firecracker driver.

You can then continue with Open Cloud :ref:`Storage <storage>` and :ref:`Networking <nm>` chapters to be able to deploy your Virtual Machines on your Firecracker hosts and access them remotely over the network.

Hypervisor Compatibility
================================================================================

This chapter applies only to Firecracker.
