========
Glossary
========

OpenNebula Components
=====================

-  **Front-end**: Machine running the OpenNebula services.
-  **Host**: Physical machine running a supported hypervisor. See the
`Host subsystem </./hostsubsystem>`__.
-  **Cluster**: Pool of hosts that share datastores and virtual
networks. Clusters are used for load balancing, high availability,
and high performance computing.
-  **Image Repository**: Storage for registered Images. Learn more about
the `Storage subsystem </./sm>`__.
-  **Sunstone**: OpenNebula web interface. Learn more about
`Sunstone </./sunstone>`__
-  **OCCI Service**: Server that enables the management of OpenNebula
with OCCI interface. Learn more about `OCCI Service </./occicg>`__
-  **Self-Service** OpenNebula web interfaced towards the end user. It
is implemented by configuring a user view of the Sunstone Portal.
-  **EC2 Service**: Server that enables the management of OpenNebula
with EC2 interface. Learn more about `EC2 Service </./ec2qcg>`__
-  **OCA**: OpenNebula Cloud API. It is a set of libraries that ease the
communication with the XML-RPC management interface. Learn more about
`ruby </./ruby>`__ and `java </./java>`__ APIs.

OpenNebula Resources
====================

-  **Template**: Virtual Machine definition. These definitions are
managed with the `onetemplate command </./vm_guide>`__.
-  **Image**: Virtual Machine disk image, created and managed with the
`oneimage command </./img_guide>`__.
-  **Virtual Machine**: Instantiated Template. A Virtual Machine
represents one life-cycle, and several Virtual Machines can be
created from a single Template. Check out the `VM management
guide </./vm_guide_2>`__.
-  **Virtual Network**: A group of IP leases that VMs can use to
automatically obtain IP addresses. See the `Networking
subsystem </./nm>`__.
-  **VDC**: Virtual Data Center, fully-isolated virtual infrastructure
environments where a group of users, under the control of the VDC
administrator.
-  **Zone**: A group of interconnected physical hosts with hypervisors
controlled by OpenNebula.

OpenNebula Management
=====================

-  **ACL**: Access Control List. Check `the managing ACL rules
guide </./manage_acl>`__.
-  **oneadmin**: Special administrative account. See the `Users and
Groups guide </./manage_users>`__.
-  **oZones**: The `susbsystem </./ozones>`__ in OpenNebula that manages
zones.

