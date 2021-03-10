.. _introapis:

================================================================================
Overview
================================================================================

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of Cloud architectures and can interface with multiple datacenter services. In this Guide we review the main interfaces of OpenNebula, their use and give pointers to additional documentation for each one.

.. todo:: Add FireEdge to image

|image0|

How Should I Read This Chapter
================================================================================

You should be reading this Chapter if you are trying to automate tasks in your deployed OpenNebula cloud, and you have already read all of the previous guides.

This Chapter introduces the OpenNebula system interfaces:

  * The XML-RPC interface is the primary interface for OpenNebula, exposing all the functionality to interface the OpenNebula daemon. Through the XML-RPC interface you can control and manage any OpenNebula resource, including VMs, Virtual Networks, Images, Users, Hosts and Clusters. Use the XML-RPC interface if you are developing specialized libraries for Cloud applications or you need a low-level interface with the OpenNebula core. A full reference in the :ref:`XML-RPC reference Section <api>`.
  * The OpenNebula Cloud API provides a simplified and convenient way to interface with the OpenNebula core XMLRPC API. The OCA interfaces exposes the same functionality as that of the XML-RPC interface. OpenNebula includes four language bindings for OCA: :ref:`Ruby <ruby>`, :ref:`JAVA <java>`, :ref:`Golang <go>` and :ref:`Python <python>`.
  * The :ref:`OpenNebula OneFlow API <appflow_api>` is a RESTful service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.

After this Chapter, if you are interested in extending the OpenNebula functionality, you need to read the :ref:`Infrastructure Integration Chapter <intro_integration>` to understand how OpenNebula relates with the different datacenter components.

Hypervisor Compatibility
================================================================================

All the Sections of this Chapter applies to both KVM and vCenter hypervisors.

.. |image0| image:: /images/opennebula_interfaces.png
   :scale: 75 %
