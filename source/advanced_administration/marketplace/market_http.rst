.. _market_http:

================
HTTP MarketPlace
================

Overview
================================================================================

MarketPlaces of `HTTP` make use of a conventional HTTP server to expose the images (MarketPlaceApps) uploaded to a MarketPlace of this kind. The image will be placed in a specific directory that must be configured to be exposed by HTTP.

This is a fully supported MarketPlace with all the implemented features.

Requirements
================================================================================

A web-server should be deployed either in the fronted or in a node reachable by the frontend. A directory that will be used to store the uploaded images (MarketPlaceApps) should be configured to have the desired available space, and the web-server must be configured in order to grant HTTP access to that directory.

It is recommended to use either `Apache <https://httpd.apache.org/>`__ or `NGINX <https://www.nginx.com/>`__ as they are known to handle properly to the potentially large MarketPlaceApp files. However, other web servers may work as long as they're capable to handle the load.

The web-server should be deployed by the administrator before registering the MarketPlace.

Configuration
================================================================================

These are the conifguration attributes of a MarketPlace template of the `HTTP` kind.

+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute    |                                                              Description                                                              |
+=================+=======================================================================================================================================+
| ``NAME``        | Required                                                                                                                              |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKET_MAD``  | Must be ``http``                                                                                                                      |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``PUBLIC_DIR``  | (**Required**) The address of MarketPlace.                                                                                            |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``BASE_URL``    | (**Required**) The url where the ``PUBLIC_DIR`` is accessible.                                                                        |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST`` | (Optional) Comma separated list of hosts where the frontend can write the image files into. There will typically be just one or none. |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrates the creation of an MarketPlace:

.. code::

    > cat market.conf
    NAME = PrivateMarket
    MARKET_MAD = http
    BASE_URL = "http://frontend.opennebula.org/"
    PUBLIC_DIR = "/var/loca/market-http"
    BRIDGE_LIST = "web-server.opennebula.org"

    > onemarket create market.conf
    ID: 100

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
