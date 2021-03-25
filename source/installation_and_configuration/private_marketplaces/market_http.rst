.. _market_http:

================
HTTP Marketplace
================

Overview
================================================================================

This Marketplace uses a conventional HTTP server to expose the images (Marketplace Appliances) uploaded to the Marketplace. The image will be placed in a specific directory (available on or at least accessible from the Front-end), that must be also served by a dedicated HTTP service.

This is a fully supported Marketplace with all the implemented features.

Requirements
================================================================================

Web server should be deployed either in the Front-end or on a node reachable by the Front-end. A directory that will be used to store the uploaded images (Marketplace Apps.) should be configured to have the necessary space available, and the web server must be configured to grant HTTP access to that directory.

It is recommended to use either `Apache <https://httpd.apache.org/>`__ or `NGINX <https://www.nginx.com/>`__, as they are known to work properly with the potentially large size of the Marketplace App. files. However, other web servers may work, as long as they can handle the load.

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
| ``BASE_URL``    | **YES**  | Base URL of the Marketplace HTTP endpoint.                                                                                                                   |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST`` | **NO**   | Comma-separated list of servers to access the public directory. If not defined, the public directory will be local to the Frontend.                          |
+-----------------+----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrate the creation of a Marketplace:

.. prompt:: bash $ auto

    $ cat market.conf
    NAME        = PrivateMarket
    MARKET_MAD  = http
    BASE_URL    = "http://frontend.opennebula.org/"
    PUBLIC_DIR  = "/var/local/market-http"
    BRIDGE_LIST = "web-server.opennebula.org"

which is created by passing to the following command:

.. prompt:: bash $ auto

    $ onemarket create market.conf
    ID: 100

.. note:: In order to use the :ref:`download <marketapp_download>` functionality make sure you read the :ref:`Sunstone Advanced Guide <suns_advance_marketplace>`.

Tuning & Extending
================================================================================

.. important:: Any modification of code should be handled carefully. Although we might provide hints on how to fine-tune various parts by customizing the OpenNebula internals, in general, **it's NOT recommended to do changes in the existing code**. Please note the changes will be lost during the OpenNebula upgrade and have to be introduced back again manually!

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
