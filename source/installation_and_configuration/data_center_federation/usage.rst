.. _federationmng:

================
Federation Usage
================

A user will have access to all the Zones where at least one of his or her groups has VDC resources. This access be can done through Sunstone or the CLI.

Sunstone
================================================================================

In the upper right corner of the Sunstone page, users will see a globe icon next to the name of the Zone currently being used. If the user clicks on that, he or she will get a dropdown with all the Zones accessible. Clicking on any of the Zones in the dropdown will get the user to that Zone.

What's happening behind the scenes is that the Sunstone server you are using is redirecting its requests to the OpenNebula oned process present in the other Zone. In the example above, if the user clicks on **ZoneB**, Sunstone contacts the OpenNebula listening at ``http://zoneb.opennebula.front-end.server:2633/RPC2``.

|zoneswitchsunstone|

.. |zoneswitchsunstone| image:: /images/zoneswitchsunstone.png

.. warning:: Uploading Virtual Machine Images over Sunstone works only for the main Zone to which the particular Sunstone instance belongs, not with other Zones users can switch to.

.. _cli_federation_usage:

CLI
================================================================================

Users can show and switch Zones through the command line using the `onezone </doc/6.2/cli/onezone.1.html>`__ command. See following examples to understand the Zone management through the CLI.

.. prompt:: bash $ auto

    $ onezone list
    C    ID NAME                      ENDPOINT
    *     0 OpenNebula                http://localhost:2633/RPC2
        104 ZoneB                     http://ultron.c12g.com:2634/RPC2

We can see in the above command output that the user has access to Zones **OpenNebula** and **ZoneB**, and is currently using the **OpenNebula** Zone. The active Zone can be changed by ``set`` subcommand of `onezone </doc/6.2/cli/onezone.1.html>`__:

.. code-block:: none

    $ onezone set 104
    Endpoint changed to "http://ultron.c12g.com:2634/RPC2" in /home/<username>/.one/one_endpoint

    $ onezone list
    C    ID NAME                      ENDPOINT
          0 OpenNebula                http://localhost:2633/RPC2
    *   104 ZoneB                     http://ultron.c12g.com:2634/RPC2

All the subsequent CLI commands executed would connect to the OpenNebula listening at ``http://zoneb.opennebula.front-end.server:2633/RPC2``.

OneFlow
================================================================================

If you are using OneFlow in the federation, you need to configure the enpoint for each zone. First update each zone with ``onezone update`` command:

.. prompt:: bash $ auto

    $ onezone show 0
    ZONE 0 INFORMATION
    ID                : 0
    NAME              : OpenNebula
    STATE             : ENABLED


    ZONE TEMPLATE
    ENDPOINT="http://192.168.150.1:2633/RPC2"
    ONEFLOW_ENDPOINT="http://192.168.150.1:2474"

The new variable ``ONEFLOW_ENDPOINT`` should point to the IP where OneFlow is configured to listen.

.. note:: The IP and the PORT should be the ones configured in ``/etc/one/oneflow-server.conf``.

Then you can switch the zone by using the command ``onezone set``:

.. prompt:: bash $ auto

    $ onezone set 0
    Endpoint changed to "http://192.168.150.1:2633/RPC2" in /var/lib/one/.one/one_endpoint
    OneFlow Endpoint changed to "http://192.168.150.1:2474" in /var/lib/one/.one/oneflow_endpoint
