.. _oneapps_overview:
.. _oneflow_overview:

================================================================================
Overview
================================================================================

Some applications require multiple VMs to implement their workflow. OpenNebula allows you to coordinate the deployment and resource usage of such applications through two components:

* VMGroup, to fine control the placement of related virtual machines.
* OneFlow, to define and manage multi-vm applications as single entities. OneFlow also let's you define dependencies and auto-scaling policies for the application components.

How Should I Read This Chapter
================================================================================

This chapter should be read after the infrastructure is properly setup, and contains working Virtual Machine templates.

Proceed to each section following these links:

* :ref:`VMGroup Management <vmgroups>`
* :ref:`OneFlow Server Configuration <appflow_configure>`
* :ref:`OneFlow Services Management <appflow_use_cli>`
* :ref:`OneFlow Services Auto-scaling <appflow_elasticity>`

Hypervisor Compatibility
================================================================================

This chapter applies to all the hypervisors.
