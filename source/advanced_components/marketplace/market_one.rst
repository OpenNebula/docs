.. _market_one:

==============================
OpenNebula Systems MarketPlace
==============================

Overview
================================================================================

OpenNebula Systems provides a public and official MarketPlace, universally available to all the OpenNebula's. The OpenNebula Marketplace is a catalog of third party virtual appliances ready to run in OpenNebula environments. This MarketPlace is available here: `http://marketplace.opennebula.systems <http://marketplace.opennebula.systems>`__. Anyone can request an account and upload their appliances and share them with other OpenNebula's, however, as opposed to other MarketPlaces, MarketPlaceApp creation is not done through OpenNebula, but by following the instructions in `http://marketplace.opennebula.systems <http://marketplace.opennebula.systems>`__. Deletion of MarketPlaceApps is likewise limited.

The MarketPlaceApps included in the official MarketPlace are third-party contributions of other OpenNebula users, meaning that they are not certificated by the OpenNebula project.

|image0|

You can also connect to MarketPlaces deployed with the `OpenNebula Add-on AppMarket <https://github.com/OpenNebula/addon-appmarket>`__. The already deployed AppMarkets can still be used, but they are now deprecated in favor of the :ref:`HTTP MarketPlaces<market_http>`.

Requirements
================================================================================

The url `marketplace.opennebula.systems <http://marketplace.opennebula.systems>`__ must be reachable from the OpenNebula Fronted.

Configuration
================================================================================

The Official OpenNebula Systems Marketplace is pre-registered in OpenNebula:

.. code::

    $ onemarket list
    ID NAME                       SIZE AVAIL        APPS MAD
     0 OpenNebula Public            0M -              40 one

Therefore it does not require any additional action from the administrator.

However, to connect to `OpenNebula Add-on AppMarkets <https://github.com/OpenNebula/addon-appmarket>`__, it is possible to do so by creating a new MarketPlace template with the following attributes:

+----------------+--------------------------------------------------------------+
|   Attribute    |                         Description                          |
+================+==============================================================+
| ``NAME``       | Required                                                     |
+----------------+--------------------------------------------------------------+
| ``MARKET_MAD`` | Must be ``one``.                                             |
+----------------+--------------------------------------------------------------+
| ``ENDPOINT``   | (**Required to connect to AppMarket**) The URL of AppMarket. |
+----------------+--------------------------------------------------------------+

For example, the following examples illustrates the creation of a MarketPlace:

.. code::

    > cat market.conf
    NAME = PrivateMarket
    MARKET_MAD = one
    ENDPOINT = "http://privatemarket.opennebula.org"

    > onemarket create market.conf
    ID: 100

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

.. |image0| image:: /images/market1306.png
