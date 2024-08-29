================================================================================
OpenNebula |version| Documentation
================================================================================

OpenNebula is an open-source cloud management platform that combines virtualization with multi-tenancy, automatic provision and elasticity to offer on-demand applications and services on enterprise, hybrid and edge environments.

The first two sections of the OpenNebula documentation are designed to help you quickly try out and evaluate OpenNebula, and to provide you with an overview of the OpenNebula cloud model, architecture and components.

.. table::
   :widths: grid

   +------------------------------------------------------------------------+-----------------------------------------------------------------------------+
   |             Quick Overview - Learn About OpenNebula                    |                Quick Start - Try out in Minutes                             |
   +========================================================================+=============================================================================+
   | The :ref:`Overview <ov>` section covers OpenNebula architecture        | The :ref:`Quick Start <qs>` Guide allows you to try OpenNebula              |
   | and components, and describes the steps for designing,                 | following simple tutorials to progressively build infrastructure            |
   | installing and deploying an OpenNebula Cloud.                          | using a powerful web UI.                                                    |
   |                                                                        |                                                                             |
   | * :ref:`OpenNebula Concepts <opennebula_concepts>`                     | * :ref:`Install an OpenNebula Front-end <try_opennebula_on_kvm>`            |
   | * :ref:`Key Features <key_features>`                                   | * :ref:`Deploy an Edge Cluster <first_edge_cluster>`                        |
   | * :ref:`Cloud Architecture Design <intro>`                             | * :ref:`Deploy a Virtual Machine <running_virtual_machines>`                |
   |                                                                        |                                                                             |
   +------------------------------------------------------------------------+-----------------------------------------------------------------------------+

.. table::
   :widths: grid

   +------------------------------------------------------------------------+-----------------------------------------------------------------------------+
   |                  Quick Install - Automatic Deployment                  |       Quick Migration - Smooth VM Migration from VMware                     |
   +========================================================================+=============================================================================+
   | Perform Automated DevOps-like deployment                               | Quickly migrate your VMs using OneSwap, a migration tool                    |
   | using `OneDeploy <https://github.com/OpenNebula/one-deploy>`__.        | designed to automatically migrate VMs from vCenter to OpenNebula.           |
   |                                                                        |                                                                             |
   | * :ref:`Overview <one_deploy_overview>`                                | * `OneSwap Webinar <https://opennebula.io/project/oneswap-migration/>`__    |
   | * :ref:`Automated Cloud Deployment with Local Storage <od_local>`      | * `OneSwap on GitHub <https://github.com/OpenNebula/one-swap>`__            |
   | * :ref:`Automated Cloud Deployment with Shared Storage <od_shared>`    |                                                                             |
   +------------------------------------------------------------------------+-----------------------------------------------------------------------------+

Other sections in the documentation provide detailed explanations, guides and references for OpenNebula components, tools, interfaces and procedures.

.. table::
   :width: 100%

   +------------------------------------------+------------------------------------------------------------------------------------------+
   |                  Guide                   |                                     Description                                          |
   +==========================================+==========================================================================================+
   | :ref:`Overview <ov>`                     | Learn about the OpenNebula model, popular use cases and how to design a cloud            |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Quick Start <qs>`                  | Build an OpenNebula test installation with local and remote resources                    |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Management and Operations <mo>`    | How to operate and manage your cloud, including deployment of remote clusters            |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Front-end Installation <ic>`       | How to install and configure the main OpenNebula services                                |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Open Cluster Deployment <ocd>`     | How to install and set up customized clusters based on open source components            |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Automatic Cluster Deployment <acd>`| How to automatically deploy clusters on-premises and on-cloud                            |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Integration and Development <id>`  | APIs and drivers to integrate OpenNebula with applications and platforms                 |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Release Notes <rn>`                | New features, improvements and fixes, and the upgrade process in each version            |
   +------------------------------------------+------------------------------------------------------------------------------------------+
   | :ref:`Legacy Components <lc>`            | No longer maintained, legacy & deprecated component documentation                        |
   +------------------------------------------+------------------------------------------------------------------------------------------+

The full contents of the documentation are listed below.

.. _entry_point:

.. toctree::
   :maxdepth: 2

   Overview <overview/index>
   Quick Start <quick_start/index>
   Management and Operations <management_and_operations/index>
   Installation and Configuration <installation_and_configuration/index>
   Marketplaces and Appliances <marketplace/index>
   Open Cluster Deployment <open_cluster_deployment/index>
   Automatic Cluster Deployment <provision_clusters/index>
   Integration and Development <integration_and_development/index>
   Release Notes <intro_release_notes/index>
   Legacy Components <legacy_components/index>

.. raw:: html
   :file: toc.html

.. note::
    * EE: Component only available in the Enterprise Edition
    * TP: Component distributed as Technology Preview and not recommended for production environments
