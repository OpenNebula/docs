.. _introapis:

===============================
Scalable Architecture and APIs
===============================

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of Cloud architectures and can interface with multiple datacenter services. In this Guide we review the main interfaces of OpenNebula, their use and give pointers to additional documentation for each one.

We have classified the interfaces in two categories: end-user cloud and system interfaces. Cloud interfaces are primarily used to develop tools targeted to the end-user, and they provide a high level abstraction of the functionality provided by the Cloud. On the other hand, the system interfaces expose the full functionality of OpenNebula and are mainly used to adapt and tune the behavior of OpenNebula to the target infrastructure.

|image0|

1. Cloud Interfaces
===================

Cloud interfaces enable you to manage virtual machines, networks and images through a simple and easy-to-use REST API. The Cloud interfaces hide most of the complexity of a Cloud and are specially suited for end-users. OpenNebula an EC2 interface:

-  **EC2-Query API**. OpenNebula implements the functionality offered by the `Amazon's EC2 API <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/Welcome.html>`__, mainly those related to virtual machine management. In this way, you can use any EC2 Query tool to access your OpenNebula Cloud.

*Use the cloud interface if...* you are developing portals, tools or specialized solutions for end-users.

*You can find more information at...* :ref:`EC2-Query reference <ec2qug>`.

2. System Interfaces
====================

2.1. The OpenNebula XML-RPC Interface
-------------------------------------

The XML-RPC interface is the primary interface for OpenNebula, and it exposes all the functionality to interface the OpenNebula daemon. Through the XML-RPC interface you can control and manage any OpenNebula resource, including virtual machines, networks, images, users, hosts and clusters.

*Use the XML-RPC interface if...* you are developing specialized libraries for Cloud applications or you need a low-level interface with the OpenNebula core.

*You can find more information at...* :ref:`XML-RPC reference guide <api>`.

2.2. The OpenNebula Cloud API (OCA)
-----------------------------------

The OpenNebula Cloud API provides a simplified and convenient way to interface the OpenNebula core. The OCA interfaces exposes the same functionality as that of the XML-RPC interface. OpenNebula includes two language bindings for OCA: Ruby and JAVA.

*Use the OCA interface if...* you are developing advanced IaaS tools that need full access to the OpenNebula functionality.

*You can find more information at...* :ref:`OCA-Ruby reference guide <ruby>` and the :ref:`OCA-JAVA reference guide <java>`.

.. |image0| image:: /images/opennebula_interfaces.png
