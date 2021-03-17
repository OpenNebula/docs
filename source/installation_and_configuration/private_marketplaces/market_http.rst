.. _market_http:

================
HTTP Marketplace
================

Overview
================================================================================

**HTTP** Marketplaces make use of a conventional HTTP server to expose the images (Marketplace Apps) uploaded to the Marketplace. The image will be placed in a specific directory that must be configured to be accessible by HTTP.

This is a fully supported Marketplace with all the implemented features.

Requirements
================================================================================

A web server should be deployed either in the frontend or in a node reachable by the frontend. A directory that will be used to store the uploaded images (Marketplace Apps) should be configured to have the necessary space available, and the web server must be configured to grant HTTP access to that directory.

It is recommended to use either `Apache <https://httpd.apache.org/>`__ or `NGINX <https://www.nginx.com/>`__, as they are known to work properly with the potentially large size of the Marketplace App files. However, other web servers may work, as long as they can handle the load.

The web server should be deployed by the administrator before registering the MarketPlace.

Configuration
================================================================================

These are the configuration attributes of a Marketplace template of the HTTP kind:

+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Attribute       | Required | Description                                                                                                                                                  |
+=================+==========+==============================================================================================================================================================+
| ``NAME``        | **YES**  | Marketplace name that is going to be shown in OpenNebula.                                                                                                    |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKET_MAD``  | **YES**  | Must be ``http``.                                                                                                                                            |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``PUBLIC_DIR``  | **YES**  | Absolute directory path to place images (the HTTP server document root) in the Frontend or in the hosts pointed at by the ``BRIDGE_LIST`` directive.         |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BASE_URL``    | **YES**  | URL base to generate MarketPlaceApp endpoints.                                                                                                               |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST`` | **NO**   | Comma-separated list of servers to access the public directory. If not defined, the public directory will be local to the Frontend.                          |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrate the creation of a Marketplace:

.. prompt:: bash $ auto

    $ cat market.conf
    NAME        = PrivateMarket
    MARKET_MAD  = http
    BASE_URL    = "http://frontend.opennebula.org/"
    PUBLIC_DIR  = "/var/loca/market-http"
    BRIDGE_LIST = "web-server.opennebula.org"

.. prompt:: bash $ auto

    $ onemarket create market.conf
    ID: 100

.. warning:: In order to use the ``download`` functionality make sure you read the :ref:`Sunstone Advanced Guide <suns_advance_marketplace>`.

Tuning & Extending
================================================================================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
