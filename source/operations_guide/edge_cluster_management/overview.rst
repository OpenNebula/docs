.. _try_hybrid_overview:

========
Overview
========

Overview: PREVIOUS AUTOMATIC PROVISION OVERVIEW USE AS REFERENCE. NEEDS REVIEW
================================================================================

The aim of this advanced component is to provide the tools and methods needed to dynamically grow your cloud infrastructure with physical resources running on remote bare-metal cloud providers.

Two of the use cases that are supported by this new elastic infrastructure approach will be:

* **Edge Cloud Computing**. This approach will allow the transition from centralized clouds to distributed edge-like cloud environments. You will be able to grow your private cloud with resources at edge data center locations to meet latency, bandwidth or data regulation needs of your workload.
* **Hybrid Cloud Computing**. This approach works as an alternative to the existing hybrid cloud drivers. So if there is a peak of demand and need for extra computing power you will be able to dynamically grow your underlying physical infrastructure. Compared with the use of hybrid drivers, this approach can be more efficient because it involves a single management layer. Also, it is a simpler approach because you can continue using the existing OpenNebula images and templates. Moreover, you always keep complete control over the infrastructure and avoid vendor lock-in.

.. image:: /images/ddc_overview.png
    :width: 50%
    :align: center

There are several benefits of this approach over the traditional, more decoupled hybrid solution that involves using the provider cloud API. However, one of them stands out among the rest; it is the ability to move offline workloads between your local and rented resources.

How Should I Read This Chapter
==============================

You should be reading this Chapter as part of the :ref:`Advanced Components Guide <advanced_components>`.

In this Chapter, you can find a guide about how to automatically allocate and provision remote resources from bare-metal cloud providers, and add them to your OpenNebula. Cloud Administrators should follow the sections which cover the :ref:installation of the OneProvision tool <ddc_install>, :ref:an example of automated provisioning of a remote cluster on AWS and Packet <default_ddc_templates>, :ref:the available commands to create and manage resource provisions <ddc_usage> and references about :ref:provision templates <ddc_template>, :ref:provision drivers <ddc_provision_driver> and :ref:automated configuration <ddc_config>.

After reading this chapter you can continue with other topics from :ref:Advanced Components <advanced_components>.
