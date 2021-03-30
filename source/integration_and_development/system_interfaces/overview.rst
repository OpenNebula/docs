.. _introapis:

================================================================================
Overview
================================================================================

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of Cloud architectures and can interface with multiple datacenter services. In this Guide we review the main interfaces of OpenNebula and their.

|image0|

How Should I Read This Chapter
================================================================================

You should be reading this Chapter if you are trying to automate tasks in your deployed OpenNebula cloud, and you have already read all of the previous guides.

This Chapter introduces the OpenNebula system interfaces:

  * A very convinient way to integrate OpenNebula in your infrastructure are the **Hooks**. Hooks allow you to trigger actions on specific OpenNebula events. You can also subscribe to the event bus (zeroMQ) to integrate your own modules.
  * The **XML-RPC interface** is the primary interface for OpenNebula, exposing all the functionality to interface the OpenNebula daemon. Through the XML-RPC interface you can control and manage any OpenNebula resource. You can find also bindings on some popular languages like :ref:`Ruby <ruby>`, :ref:`JAVA <java>`, :ref:`Golang <go>` and :ref:`Python <python>`.
  * The :ref:`OpenNebula OneFlow API <appflow_api>` is a RESTful service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.

Hypervisor Compatibility
================================================================================

All the Sections of this Chapter applies to both KVM and vCenter hypervisors.

.. |image0| image:: /images/overview_architecture.png
   :scale: 75 %
