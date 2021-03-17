.. _firecracker_node_deployment_overview:

================================================================================
Overview
================================================================================

`Firecracker <https://firecracker-microvm.github.io/>`__ is an open source virtual machine monitor (VMM) developed by AWS — It's widely used as part of its Fargate and Lambda services⁠. Firecracker is especially designed for creating and managing secure, multi-tenant container and function-based services. It enables to deploy workloads in lightweight VMs (called **microVMs**) which provide enhanced security and workload isolation over traditional VMs, while enabling the speed and resource efficiency of containers.

Firecracker uses the Linux Kernel-based Virtual Machine (KVM) to create and manage microVMs. It has a minimalist design, excluding unnecessary devices and guest functionality to reduce the memory footprint and attack surface area of each microVM.


How Should I Read This Chapter
================================================================================

This chapter will focus on the configuration options for a Firecracker based Hosts.

* Read the :ref:`Firecracker driver <fcmg>` section in order to understand the specific requirements, functionalities, and limitations of the Firecracker driver.
* Read the :ref:`Firecracker node installation <fc_node>` section in order to add a Firecracker host to your OpenNebula cloud to start deploying microVMs.
