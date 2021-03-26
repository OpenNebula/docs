.. _oneapps_overview:
.. _oneflow_overview:
.. _multivm_service_management_overview:

========
Overview
========

How Should I Read This Chapter
================================================================================

Some applications require multiple VMs to implement their workflow. OpenNebula allows you to coordinate the deployment and resource usage of such applications through the OneFlow component.

This component is able to deploy services, these services are a group of interconnected virtual machines that work as an entity. They can communicate each other using virtual networks deployed by the OneFlow server itself and they can also have some relationship. A group of virtual machines, called role, can depend on other roles, so it will be deployed when the parent is ready.

This OneFlow component is able to implement elasticity policies. Service can scale up or down depending on the needs, in order to add or remove virtual machines from it.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
