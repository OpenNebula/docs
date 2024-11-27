================================================================================
Overview
================================================================================

A Provider represents a Cloud where resources (hosts, networks or storage) are allocated to implement a Provision. Usually a Provider includes a zone or region in the target Cloud and an account that will be used to create the resources needed.

How Should I Read This Chapter
==============================

In this chapter you can find a guide on how to create Providers based on the supported Clouds. The following Cloud providers are enabled by default after installing OpenNebula:

  - :ref:`Equinix Provider <equinix_provider>`
  - :ref:`Amazon AWS Provider <aws_provider>`
  - :ref:`Scaleway Provider <scaleway_provider>`
  - :ref:`On-Premise Provider <onprem_provider>`

Note, the on-premise provider is a convenient abstraction to represent your own resources on your datacenter.

Hypervisor Compatibility
================================================================================

Provisions are compatible with the KVM and LXC hypervisors.
