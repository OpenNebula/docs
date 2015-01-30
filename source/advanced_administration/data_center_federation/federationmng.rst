.. _federationmng:

================================
OpenNebula Federation Management
================================

The administrator of a federation has the ability to add or remove Zones from the federation. See this guide for details on how to configure the federation in both the master and the slave of the OpenNebula federation.

A user will have access to all the Zones where at least one of her groups has VDC resources in. This access can done through Sunstone or through the CLI 

Adding a Zone
=============

Adding a Zone through the CLI entails the creation of a Zone template.

+-----------+-----------------------------------+
| Parameter |            Description            |
+===========+===================================+
| Name      | Name of the new Zone              |
+-----------+-----------------------------------+
| Endpoint  | XMLRPC endpoint of the OpenNebula |
+-----------+-----------------------------------+

.. code-block:: none

    # vi zone.tmpl
    NAME = ZoneB
    ENDPOINT = http://zoneb.opennebula.front-end.server:2633/RPC2

This same operation can be performed through Sunstone (Zone tab -> Create).


.. warning:: The ENDPOINT has to be reachable from the Sunstone server machine, or the computer running the CLI in order for the user to access the Zone.

Using a Zone
============

Through Sunstone
----------------

In the upper right position of Sunstone page, users will see a house icon next to the name of the Zone you are curently using. If the user clicks on that, she will get a dropdown with all the Zones she has access to. Clicking on any of the Zones in the dropdown will get the user to that Zone.

What's happening behind the scenes is that the Sunstone server you are connecting to is redirecting its requests to the OpenNebula oned process present in the other Zone. In the example above, if the uer clicks on ZoneB, Sunstone will contact the OpenNebula listening at `http://zoneb.opennebula.front-end.server:2633/RPC2`.

|zoneswitchsunstone|

.. |zoneswitchsunstone| image:: /images/zoneswitchsunstone.jpg

Through CLI
-----------

Users can switch Zones through the command line using the `onezone </doc/4.10/cli/onezone.1.html>`__ command. The following session can be examined to understand the Zone management through the CLI.

.. code-block:: none

    $ onezone list
    C    ID NAME                      ENDPOINT
    *     0 OpenNebula                http://localhost:2633/RPC2
        104 ZoneB                     http://ultron.c12g.com:2634/RPC2

We can see in the above command output that the user has access to both "OpenNebula" and "ZoneB", and it is currently in the "OpenNebula" Zone. To change the active Zone can be changed using the 'set' command of `onezone </doc/4.10/cli/onezone.1.html>`__:

.. code-block:: none

    $ onezone set 104
    Endpoint changed to "http://ultron.c12g.com:2634/RPC2" in /home/<username>/.one/one_endpoint

    $ onezone list
    C    ID NAME                      ENDPOINT    
          0 OpenNebula                http://localhost:2633/RPC2
    *   104 ZoneB                     http://ultron.c12g.com:2634/RPC2    

All the subsequent CLI commands executed would connect to the OpenNebula listening at "http://zoneb.opennebula.front-end.server:2633/RPC2".


