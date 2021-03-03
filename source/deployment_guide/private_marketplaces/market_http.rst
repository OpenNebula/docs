:orphan:

.. _market_http:

================
HTTP MarketPlace
================

Overview
================================================================================

`HTTP` MarketPlaces make use of a conventional HTTP server to expose the images (MarketPlaceApps) uploaded to the MarketPlace. The image will be placed in a specific directory that must be configured to be accessible by HTTP.

This is a fully supported MarketPlace with all the implemented features.

Requirements
================================================================================

A web server should be deployed either in the Frontend or in a node reachable by the Frontend. A directory that will be used to store the uploaded images (MarketPlaceApps) should be configured to have the necessary space available, and the web server must be configured to grant HTTP access to that directory.

It is recommended to use either `Apache <https://httpd.apache.org/>`__ or `NGINX <https://www.nginx.com/>`__, as they are known to work properly with the potentially large size of the MarketPlaceApp files. However, other web servers may work, as long as they can handle the load.

The web server should be deployed by the administrator before registering the MarketPlace.

Configuration
================================================================================

These are the configuration attributes of a MarketPlace template of the `HTTP` kind.

+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute    |                                                                               Description                                                                               |
+=================+=========================================================================================================================================================================+
| ``NAME``        | Required                                                                                                                                                                |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKET_MAD``  | Must be ``http``                                                                                                                                                        |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PUBLIC_DIR``  | (**Required**) Absolute directory path to place images (the HTTP server document root) in the Frontend or in the hosts pointed at by the ``BRIDGE_LIST`` directive.     |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BASE_URL``    | (**Required**) URL base to generate MarketPlaceApp endpoints.                                                                                                           |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST`` | (Optional) Comma-separated list of servers to access the public directory. If not defined, the public directory will be local to the Frontend.                          |
+-----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrate the creation of a MarketPlace:

.. prompt:: bash $ auto

    $ cat market.conf
    NAME = PrivateMarket
    MARKET_MAD = http
    BASE_URL = "http://frontend.opennebula.org/"
    PUBLIC_DIR = "/var/loca/market-http"
    BRIDGE_LIST = "web-server.opennebula.org"

    $ onemarket create market.conf
    ID: 100

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
