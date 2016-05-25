.. _oneapps_overview:
.. _oneflow_overview:

================================================================================
Overview
================================================================================

.. todo::
    * Cloud Architect
    * Cloud Admin
    * KVM
    * vCenter

OneFlow is an OpenNebula component that allows users and administrators to define, execute and manage multi-tiered services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced :ref:`OpenNebula user and group management <auth_overview>`.

The benefits of OneFlow are:

* Define multi-tiered applications (services) as collection of applications
* Manage multi-tiered applications as a single entity
* Automatic execution of services with dependencies
* Provide configurable services from a catalog and self-service portal
* Enable tight, efficient administrative control
* Fine-grained access control for the secure sharing of services with other users
* Auto-scaling policies based on performance metrics and schedule

How Should I Read This Chapter
================================================================================

This chapter should be read after the infrastructure is properly setup, and contains working Virtual Machine templates.

Proceed to each section following these links:

* :ref:`OneFlow Server Configuration <appflow_configure>`
* :ref:`Multi-tier Applications <appflow_use_cli>`
* :ref:`Application Auto-scaling <appflow_elasticity>`

Hypervisor Compatibility
================================================================================

This chapter applies to all the hypervisors.