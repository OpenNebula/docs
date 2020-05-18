.. _market_dh:

==============================
DockerHub MarketPlaces
==============================

Overview
================================================================================

OpenNebula DockerHub integration provide access to `DockerHub Official Images <https://hub.docker.com/search?image_filter=official&type=image>`__. This integration allows to easily import these DockerHub images to the OpenNebula cloud. The OpenNebula context packages are installed during the import process so once an image is imported it's fully prepared to be used.

The DockerHub marketplace will also create a new VM template associated with the imported image. This template can be customized by the user (e.g adding the desire kernel, tune parameter, etc...).

|image1|

Requirements
================================================================================

- OpenNebula's frontend needs an Internet connection to https://hub.docker.com.
- Docker must be installed and configured at the frontend. ``oneadmin`` user must have permissions for running docker.
- Approximately 6GB of storage plus the container image size configured on your frontend.

Configuration
================================================================================

The Official OpenNebula Systems Marketplace is pre-registered in OpenNebula:

.. code::

    $ onemarket list
    ID NAME                                                            SIZE AVAIL   APPS MAD     ZONE
    3 DockerHub                                                         0M -        162  dockerh    0
    2 TurnKey Linux Containers                                          0M -          0  turnkey    0
    1 Linux Containers                                                  0M -         24  linuxco    0
    0 OpenNebula Public                                                 0M -         47  one        0


Therefore it does not require any additional action from the administrator.

.. note:: Note that the monitoring can be disabled for this marketplace by commenting the corresponding ``MARKET_MAD`` section in ``oned.conf`` and restarting OpenNebula service.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

.. |image1| image:: /images/dh_mktplace.png

