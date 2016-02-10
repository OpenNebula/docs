.. _market_one:

==============================
OpenNebula Systems MarketPlace
==============================

Overview
================================================================================

OpenNebula Systems provides a public and official MarketPlace, universally available to all the OpenNebula's. The OpenNebula Marketplace is a catalog of third party virtual appliances ready to run in OpenNebula environments. This MarketPlace is available here: `http://marketplace.opennebula.systems <http://marketplace.opennebula.systems>`__. Anyone can request an account and upload their appliances and share it with other OpenNebula's.

|image0|

This MarketPlace is read-only, you will not be able to import new MarketPlaceApps into this MarketPlace or remove them.

You can also connect to MarketPlaces deployed with the `OpenNebula Add-on AppMarket <https://github.com/OpenNebula/addon-appmarket>`__.

Requirements
================================================================================

The url `marketplace.opennebula.systems <http://marketplace.opennebula.systems>`__ must be reachable from the OpenNebula Fronted.

Configuration
================================================================================

The Official OpenNebula Systems Marketplace is pre-registered in OpenNebula:

    $ onemarket list
      ID       SIZE AVAIL        APPS MAD     NAME
       0         0M -              40 one     OpenNebula Public

Therefore it does not require any additional action from the administrator.

However, to connect to `OpenNebula Add-on AppMarkets <https://github.com/OpenNebula/addon-appmarket>`__, it is possible to do so by creating a new MarketPlace template with the following attributes:

+----------------+------------------------------------------------------------------+
|   Attribute    |                           Description                            |
+================+==================================================================+
| ``NAME``       | Required                                                         |
+----------------+------------------------------------------------------------------+
| ``MARKET_MAD`` | Must be ``one``                                                  |
+----------------+------------------------------------------------------------------+
| ``ENDPOINT``   | (**Required to connect to AppMarket**) The address of AppMarket. |
+----------------+------------------------------------------------------------------+

For example, the following examples illustrates the creation of an MarketPlace:

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
