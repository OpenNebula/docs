=========================
OpenNebula Zones Overview
=========================

|image0|

The **OpenNebula Zones** (oZones) component allows for the centralized
management of multiple instances of OpenNebula (zones), managing in turn
potentially different administrative domains. The module is run by the
oZones administrator, with capacity to grant access to the different
zones to particular users.

These zones can be effectively shared through the Virtual DataCenter
(VDC) abstraction. A VDC is a set of virtual resources (images, VM
templates, virtual networks and virtual machines) and users that manage
those virtual resources, all sustained by infrastructure resources
offered by OpenNebula. A VDC is supported by the resources of one zone,
and it is associated to one `cluster </./cluster_guide>`__ of the zone.
The resources that the VDC can dispose of are a subset of that cluster.
There is a special user (the VDC administrator) that can create new
users inside the VDC, as well as manage all the virtual resources (but
can not access other resources in the zone or even the see the physical
hosts used for the VDC). VDC admin and users access the zone through a
reverse proxy, so they don't need to know the endpoint of the zone, but
rather the address of the oZones module and the VDC where they belong
to.

The bird's-eye view of the oZones component can be sketched with a
simple scenario. Let's take the point of view of the oZones manager that
has access to two OpenNebula instances, managing resources in two
different administrative domains. She can add those two instances as
OpenNebula Zones in the oZones manager (provided she has the
â€œoneadminâ€? credentials of both OpenNebula instances), and afterwards
take a look at an aggregated view of resources combined from both zones.
Also, she may want to give just a portion of the physical resources to a
set of users, so she will create a VDC in one of the given zones,
selecting a subset of the available hosts, and creating an account for
the VDC admin. Once this is in place, she will be able to provide with
access URL for the OpenNebula CLI and Sunstone GUI to the users, an url
that will mask the location of the OpenNebula zone by using a reverse
proxy. An example of such a URL can be:

.. code:: code

http://ozones-server/MyVDC

Benefits
--------

This new **Zones** functionality addresses many common requirements in
enterprise use cases, like for instance:

-  Complete **isolation** of users, organizations or workloads in
different Zones with different levels of security or high
availability
-  Optimal **performance** with the execution of different workload
profiles in different physical clusters with specific architecture
and software/hardware execution environments
-  Massive **scalability** of cloud infrastructures beyond a single
cloud instance
-  **Multiple site** support with **centralized management** and access
to clouds hosted in different data centers to build a geographically
distributed cloud

Moreover, the **VDC** mechanism allows advanced on-demand provisioning
scenarios like:

-  On-premise Private Clouds Serving **Multiple Projects, Departments,
Units or Organizations**. On-premise private clouds in large
organizations require powerful and flexible mechanisms to manage the
access privileges to the virtual and physical infrastructure and to
dynamically allocate the available resources. In these scenarios, the
cloud administrator would create a VDC for each Department,
dynamically allocation physical hosts according to their needs, and
delegating the internal administration of the VDC to the Department
IT administrator.
-  Cloud Providers Offering **Virtual Private Cloud Computing**. There
is a growing number of cloud providers, especially Telecom Operators,
that are offering Virtual Private Cloud environments to extend the
Private Clouds of their customers over virtual private networks, thus
offering a more reliable and secure alternative to traditional Public
Cloud providers. In this new cloud offering scenario, the cloud
provider provides customers with a fully-configurable and isolated
VDC where they have full control and capacity to administer its users
and resources. This combines a public cloud with the protection and
control usually seen in a personal private cloud system. Users can
themselves create and configure servers via the SunStone portal or
any of the supported cloud APIs. The total amount of physical
resources allocated to the virtual private cloud can also be
adjusted.

Next Steps
----------

-  `Configure the server </./ozonescfg>`__
-  `Manage Zones </./zonesmngt>`__
-  `Manage VDCs </./vdcmngt>`__

.. |image0| image:: /./_media/documentation:rel3.4:ozones-arch-v3.4.png?w=300
:target: /./_detail/documentation:rel3.4:ozones-arch-v3.4.png?id=
