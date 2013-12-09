=======================
Managing Multiple Zones
=======================

A Zone is essentially a group of interconnected physical hosts with
hypervisors controlled by OpenNebula. A Zone can be added to the oZones
server, providing valid oneadmin credentials, so it can contribute to
the list of aggregated resources presented by the oZones component. A
Zone can be further *compartmentalized* in `Virtual Data Center or
VDCs </./vdcmngt>`__.

Adding a New Zone
=================

This guide assumes that the oZones command line interface is correctly
`installed </./ozonescfg#installation>`__ and
`configured </./ozonescfg#configure_ozones_client>`__.

Zones resource can be managed using the **onezone** command. In order to
create a zone, we will need a Zone template, with the necessary
information to setup such resource:

.. code:: code

NAME=MyZone
ONENAME=oneadmin
ONEPASS=opennebula
ENDPOINT=http://zone.domain.name:2633/RPC2
SUNSENDPOINT=http://zone.domain.name:9869
SELFENDPOINT=http://zone.domain.name:4567/ui

The *oneadmin* credentials are checked against the OpenNebula present in
the Zone by requesting the list of available hosts. No changes are made
to the OpenNebula whatsoever. Let's create a Zone:

.. code::

$ onezone create myzone.template
ID: 1

Now we can list the available zones:

.. code::

$ onezone list
ID            NAME                                 ENDPOINT
1          MyZone        http://zone.domain.name:2633/RPC2

Examining a Zone
================

We can further examine the contents of the zone with the **onezone
show** command:

.. code::

$ onezone show 1
ZONE zone0 INFORMATION
ID             : 1
NAME           : zone0
ZONE ADMIN     : oneadmin
ZONE PASS      : 4478db59d30855454ece114e8ccfa5563d21c9bd
ENDPOINT       : http://zone.domain.name:2633/RPC2
# VDCS         : 0

Zone resources can be specifically queried with **onezone show <id>**
plus one of the following flags:

-  ``vmtemplate`` for VM templates
-  ``image`` for Images
-  ``user`` for Users
-  ``vm`` for Virtual Machines
-  ``vnet`` for Virtual Networks
-  ``host`` for Hosts

Let's query the hosts of the newly created zone:

.. code::

$ onezone show 1 host
ZONE zone0 INFORMATION
ID             : 1
NAME           : MyZone
ZONE ADMIN     : tinova
ZONE PASS      : 4478db59d30855454ece114e8ccfa5563d21c9bd
ENDPOINT       : http://zone.domain.name:2633/RPC2
# VDCS         : 0

ID NAME               RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM   STAT
0 MyHost               0      0      0    100     0K     0K     0K     on
1 EC2Host              0      0      0    100     0K     0K     0K     on
2 64BitsComp           0      0      0    100     0K     0K     0K     on

Deleting a Zone
===============

We can delete a zone with **onezone delete**, providing the Zone ID:

.. code::

$ onezone delete 1
Resource zone with id 1 successfully deleted

Using the oZones GUI
====================

Pointing the browser to

.. code:: code

http://ozones.server.domainname:6121

Will give access to the oZones GUI, where all the functionality of the
CLI is offered.

|image0|

Examining Aggregated Resources
------------------------------

Also, in the GUI there is the ability to see the aggregated resources
from multiple zones: Templates, Images, Users, Virtual Machines, Virtual
Networks and Hosts.

|image1|

.. |image0| image:: /./_media/documentation:rel3.0:generalozonesgui.png?w=700
:target: /./_detail/documentation:rel3.0:generalozonesgui.png?id=
.. |image1| image:: /./_media/documentation:rel3.0:aggregatedozonesgui.png?w=700
:target: /./_detail/documentation:rel3.0:aggregatedozonesgui.png?id=
