.. _market_lxd:

==============================
Linux Containers MarketPlace
==============================

Overview
================================================================================

`Linux Containers image server <https://images.linuxcontainers.org/>`__ hosts a public image server for use by LXC and LXD. It is the default image server on LXD.

OpenNebula's linuxcontainers marketplace enables users to easily download, contextualize and add Linux Container's images to an OpenNebula's image datastore. Linux Containers images are compressed **.tar.xz** files. In order to use them, this marketplace creates an image, where it dumps the content and later uploads it to OpenNebula. The marketplace will automatically take care of downloading the correct context package for your image and installing it inside the container. The marketplace also creates a VM template with a set of required values and usability ones.

Requirements
================================================================================

- OpenNebula's frontend needs an Internet connection to https://images.linuxcontainers.org and https://github.com
- Aproximately 6GB of storage plus the container image size configured on your frontend

Configuration
================================================================================

Several parameters can be specified on the marketplace's template:

+-------------------+--------------------------------------------------------------------+
|   Attribute       |                         Description                                |
+===================+====================================================================+
| ``NAME``          | Required                                                           |
+-------------------+--------------------------------------------------------------------+
| ``MARKET_MAD``    | Must be ``linuxcontainers``.                                       |
+-------------------+--------------------------------------------------------------------+
| ``ENDPOINT``      | The URL of the Market. Default: https://images.linuxcontainers.org |
+-------------------+--------------------------------------------------------------------+
| ``IMAGE_SIZE_MB`` | Size in MB for the image holding the rootfs. Default: 1024         |
+-------------------+--------------------------------------------------------------------+
| ``FILESYSTEM``    | Filesystem used for the image. Default: ext4                       |
+-------------------+--------------------------------------------------------------------+
| ``FORMAT``        | Image format. Default: raw                                         |
+-------------------+--------------------------------------------------------------------+

The OpenNebula frontend already ships with a configured LXD marketplace.

|image1|

|image2|

The following template will create a working marketplace with the default values:

.. code-block:: text

    NAME="Linux Containers"
    MARKET_MAD="linuxcontainers"
    DESCRIPTION="MarketPlace for the public image server fo LXC at linuxcontainers.org"

Save this contents on a file (e.g. lxcmarket) and create the market with:

.. prompt:: text $ auto

 $ onemarket create lxcmarket

You can also use Sunstone and input the previous values through the UI.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

.. |image1| image:: /images/lxd_market1.png
.. |image2| image:: /images/lxd_market2.png
