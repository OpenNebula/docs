.. _introapis:

================================================================================
Overview
================================================================================

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of Cloud architectures and can interface with multiple datacenter services. In this Guide we review the main interfaces of OpenNebula, their use and give pointers to additional documentation for each one.

We have classified the interfaces in two categories: end-user cloud and system interfaces.

|image0|

How Should I Read This Chapter
================================================================================

You should be reading this Chapter if you are trying to automate tasks in your deployed OpenNebula cloud, and you have already read all of the previous guides.

This Chapter introduces the OpenNebula interfaces:

* **Cloud interfaces** are primarily used to develop tools targeted to the end-user, and they provide a high level abstraction of the functionality provided by the Cloud. They are designed to manage virtual machines, networks and images through a simple and easy-to-use REST API. The Cloud interfaces hide most of the complexity of a Cloud and are specially suited for end-users. OpenNebula features a EC2 interface, implementing the functionality offered by the `Amazon's EC2 API <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/Welcome.html>`__, mainly those related to virtual machine management. In this way, you can use any EC2 Query tool to access your OpenNebula Cloud. Use the cloud interface if you are developing portals, tools or specialized solutions for end-users. You can find more information at :ref:`EC2-Query reference <ec2qug>`.

* **System interfaces** expose the full functionality of OpenNebula and are mainly used to adapt and tune the behavior of OpenNebula to the target infrastructure:
  * The XML-RPC interface is the primary interface for OpenNebula, exposing all the functionality to interface the OpenNebula daemon. Through the XML-RPC interface you can control and manage any OpenNebula resource, including VMs, Virtual Networks, Images, Users, Hosts and Clusters. Use the XML-RPC interface if you are developing specialized libraries for Cloud applications or you need a low-level interface with the OpenNebula core. A full reference in the :ref:`XML-RPC reference Section <api>`.
  * The OpenNebula Cloud API provides a simplified and convenient way to interface with the OpenNebula core XMLRPC API. The OCA interfaces exposes the same functionality as that of the XML-RPC interface. OpenNebula includes two language bindings for OCA: :ref:`Ruby <ruby>` and :ref:`JAVA <java>`.
  * The :ref:`OpenNebula OneFlow API <appflow_api>` is a RESTful service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.

After this Chapter, if you are interested in extending the OpenNebula functionality, you need to read the :ref:`Infrastructure Integration Chapter <intro_integration>` to understand how OpenNebula relates with the different datacenter components.

Hypervisor Compatibility
================================================================================

All the Sections of this Chapter applies to both KVM and vCenter hypervisors.

.. |image0| image:: /images/opennebula_interfaces.png
