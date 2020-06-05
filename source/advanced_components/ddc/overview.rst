.. _ddc_overview:

========
Overview
========

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

You should be reading this Chapter as part of the :ref:`Advanced Components Guide <advanced_components>`. You should be aware of the :ref:`Cloud Bursting <cloud_bursting>` functionality, as the cluster provisioning shares some approaches.

In this Chapter, you can find a guide on how to provide additional resources from public bare-metal cloud providers into your OpenNebula. Cloud Administrators should follow the sections which cover :ref:`Installation <ddc_install>`, :ref:`Default Infrastructure Provision <default_ddc_templates>` and :ref:`Basic Usage <ddc_usage>`, the Cloud Integrators and Developers might find useful the :ref:`Provision and Configuration Reference <ddc_ref>` and :ref:`Provision Driver <devel-pm>` API specification.

After reading this chapter you can continue with other topics from :ref:`Advanced Components <advanced_components>`.
