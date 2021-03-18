.. _federationmng:

================
Federation Usage
================

A user will have access to all the Zones where at least one of her groups has VDC resources in. This access be can done through Sunstone or the CLI.

Sunstone
================================================================================

In the upper right corner of the Sunstone page, users will see a globe icon next to the name of the Zone you are currently using. If the user clicks on that, she will get a dropdown with all the Zones she has access to. Clicking on any of the Zones in the dropdown will get the user to that Zone.

What's happening behind the scenes is that the Sunstone server you are using is redirecting its requests to the OpenNebula oned process present in the other Zone. In the example above, if the user clicks on **ZoneB**, Sunstone contacts the OpenNebula listening at ``http://zoneb.opennebula.front-end.server:2633/RPC2``.

|zoneswitchsunstone|

.. |zoneswitchsunstone| image:: /images/zoneswitchsunstone.png

.. warning:: Uploading an image functionality is limited to the zone where the Sunstone instance the user is connecting to, even if it can switch to other federated zones.

CLI
================================================================================

Users can show and switch Zones through the command line using the `onezone </doc/5.13/cli/onezone.1.html>`__ command. See following examples to understand the Zone management through the CLI.

.. prompt:: bash $ auto

    $ onezone list
    C    ID NAME                      ENDPOINT
    *     0 OpenNebula                http://localhost:2633/RPC2
        104 ZoneB                     http://ultron.c12g.com:2634/RPC2

We can see in the above command output that the user has access to zones **OpenNebula** and **ZoneB**, and is currently using the **OpenNebula** Zone. The active Zone can be changed by ``set`` subcommand of `onezone </doc/5.13/cli/onezone.1.html>`__:

.. code-block:: none

    $ onezone set 104
    Endpoint changed to "http://ultron.c12g.com:2634/RPC2" in /home/<username>/.one/one_endpoint

    $ onezone list
    C    ID NAME                      ENDPOINT
          0 OpenNebula                http://localhost:2633/RPC2
    *   104 ZoneB                     http://ultron.c12g.com:2634/RPC2

All the subsequent CLI commands executed would connect to the OpenNebula listening at ``http://zoneb.opennebula.front-end.server:2633/RPC2``.
