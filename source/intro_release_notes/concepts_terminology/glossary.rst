.. _glossary:

=========
Glossary
=========

OpenNebula Components
=====================

-  **Front-end**: Machine running the OpenNebula services.
-  **Host**: Physical machine running a supported hypervisor. See the :ref:`Host subsystem <hostsubsystem>`.
-  **Cluster**: Pool of hosts that share datastores and virtual networks. Clusters are used for load balancing, high availability, and high performance computing.
-  **Image Repository**: Storage for registered Images. Learn more about the :ref:`Storage subsystem <sm>`.
-  **Sunstone**: OpenNebula web interface. Learn more about :ref:`Sunstone <sunstone>`
-  **OCCI Service**: Server that enables the management of OpenNebula with OCCI interface. You can use `rOCCI server <http://gwdg.github.io/rOCCI-server/>`_ to provide this service.
-  **Self-Service** OpenNebula web interfaced towards the end user. It is implemented by configuring a user view of the Sunstone Portal.
-  **EC2 Service**: Server that enables the management of OpenNebula with EC2 interface. Learn more about :ref:`EC2 Service <ec2qcg>`
-  **OCA**: OpenNebula Cloud API. It is a set of libraries that ease the communication with the XML-RPC management interface. Learn more about :ref:`ruby <ruby>` and :ref:`java <java>` APIs.

OpenNebula Resources
====================

-  **Template**: Virtual Machine definition. These definitions are managed with the :ref:`onetemplate command <vm_guide>`.
-  **Image**: Virtual Machine disk image, created and managed with the :ref:`oneimage command <img_guide>`.
-  **Virtual Machine**: Instantiated Template. A Virtual Machine represents one life-cycle, and several Virtual Machines can be created from a single Template. Check out the :ref:`VM management guide <vm_guide_2>`.
-  **Virtual Network**: A group of IP leases that VMs can use to automatically obtain IP addresses. See the :ref:`Networking subsystem <nm>`.
-  **VDC**: Virtual Data Center, fully-isolated virtual infrastructure environments where a group of users, under the control of the VDC administrator.
-  **Zone**: A group of interconnected physical hosts with hypervisors controlled by OpenNebula.

OpenNebula Management
=====================

-  **ACL**: Access Control List. Check :ref:`the managing ACL rules guide <manage_acl>`.
-  **oneadmin**: Special administrative account. See the :ref:`Users and Groups guide <manage_users>`.
-  **Federation**: Several OpenNebula instances can be :ref:`configured as zones <introf>`.

