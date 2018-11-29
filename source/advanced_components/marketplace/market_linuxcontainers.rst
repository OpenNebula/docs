.. _market_linuxcontainers:

==============================
Linuxcontainers MarketPlace
==============================

Overview
================================================================================

[Linux Containers image server](https://images.linuxcontainers.org/) hosts a public image server for use by LXC and LXD. It is the default image server on LXD.

OpenNebula's linuxcontainers marketplace enables users to easily downlaod, contextualize and add Linux Container's images to an OpenNebula's image datastore. Linux Containers images are compressed **.tar.xz** files. In order to use them, this marketplace creates an image, where it dumps the content and later uploads it to OpenNebula. The marketplace will automatically take care of downloading the correct context package for your image and installing it inside the container. Only [tested platforms](https://github.com/OpenNebula/addon-context-linux#tested-platforms) are supported.

Requirements
================================================================================

OpenNebula's frontend needs an Internet connection. This internet connection is used to download the context package from OpenNebula that will be later added to the container. Also, you will need aproximately 6GB plus the image size configured (5G by default) on your frontend.

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
| ``IMAGE_SIZE_MB`` | Size in MB for the image holding the rootfs. Default: 5120         |
+-------------------+--------------------------------------------------------------------+
| ``FILESYSTEM``    | Filesystem used for the image. Default: ext4                       |
+-------------------+--------------------------------------------------------------------+
| ``FORMAT``        | Image format. Default: raw                                         |
+-------------------+--------------------------------------------------------------------+



Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

.. |image0| image:: /images/market1306.png
