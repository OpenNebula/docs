.. _market_docker_registry:

===========================
Docker Registry Marketplace
===========================

Overview
================================================================================

This Marketplace uses a private Docker registry server to expose the images in it as Marketplace Appliances.

Requirements
================================================================================

* The Docker registry should be deployed either in the Front-end or on a node reachable by the Front-end.
* The Docker registry should be deployed by the administrator before registering the MarketPlace.

Configuration
================================================================================

The configuration attributes are described below:

+-----------------+----------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Attribute    | Required |                                                                      Description                                                                      |
+=================+==========+=======================================================================================================================================================+
| ``NAME``        | **YES**  | Marketplace name that is going to be shown in OpenNebula.                                                                                             |
+-----------------+----------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKET_MAD``  | **YES**  | Must be ``docker_registry``.                                                                                                                          |
+-----------------+----------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BASE_URL``    | **YES**  | Base URL of the Marketplace Docker registry endpoint.                                                                                                 |
+-----------------+----------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SSL``         | **NO**   | ``true`` if the registry is behind SSL proxy.                                                                                                         |
+-----------------+----------+-------------------------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrate the creation of a Marketplace using a custom registry available at ``http://fronted.opennebula.org/``:

.. prompt:: bash $ auto

    $ cat market.conf
    NAME        = DockerRegistry
    MARKET_MAD  = docker_registry
    BASE_URL    = "http://frontend.opennebula.org/"

which is created by passing the following command:

.. prompt:: bash $ auto

    $ onemarket create market.conf
    ID: 100

.. note:: In order to use the :ref:`download <marketapp_download>` functionality, make sure you read the :ref:`Sunstone Advanced Guide <suns_advance_marketplace>`.

Tuning & Extending
================================================================================

.. important:: Any modification of code should be handled carefully. Although we might provide hints on how to fine-tune various parts by customizing the OpenNebula internals, in general, **it's NOT recommended to make changes in the existing code**. Please note the changes will be lost during the OpenNebula upgrade and have to be introduced back again manually!

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
