.. _public_marketplaces:

================================================================================
Public Marketplaces
================================================================================

OpenNebula will configure by default the following Marketplaces in your installation:

+-------------------------+-----------------------------------------------------------------------------------------------+
| Marketplace Name        | Description                                                                                   |
+=========================+===============================================================================================+
| OpenNebula Public       | The official public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__|
+-------------------------+-----------------------------------------------------------------------------------------------+
| Linux Containers        | The public LXD/LXC `image repository <https://images.linuxcontainers.org>`__                  |
+-------------------------+-----------------------------------------------------------------------------------------------+
| Turnkey Linux Containers| The Turnkey Linux `image repository <https://www.turnkeylinux.org>`__                         |
+-------------------------+-----------------------------------------------------------------------------------------------+
| DockerHub               | The Docker Hub `image repository <https://hub.docker.com>`__                                  |
+-------------------------+-----------------------------------------------------------------------------------------------+

.. important:: The OpenNebula front-end needs access to the Internet to use the public Marketplaces.

Only the OpenNebula Public marketplace is enabled by default. Other marketplaces are initialized as disabled. To enable them use ``onemarket enable <market_id>``.

You can list the marketplaces configured in OpenNebula with ``onemarket list``. The output for the default installation of OpenNebula will look similar to:

.. code::

    $ onemarket list
    ID NAME                                                            SIZE AVAIL   APPS MAD     ZONE STAT
    3  DockerHub                                                         0M -          0 dockerh    0 off
    2  TurnKey Linux Containers                                          0M -          0 turnkey    0 off
    1  Linux Containers                                                  0M -          0 linuxco    0 off
    0  OpenNebula Public                                                 0M -         48 one        0 on

.. _marketplace_disable:

Disable Marketplace
================================================================================
Marketplace can be disabled with ``onemarket disable``. By disabling a Marketplace all Appliances will be removed from OpenNebula, and it will be no longer monitored. Note that this process doesn't affect already exported Images. After enabling the Marketplace with ``onemarket enable``, it will be monitored again and all Aplliances from this Marketplace will show up again. Finally, Marketplaces can be created disabled by adding ``STATE=DISABLED`` to the template file.
