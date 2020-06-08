.. _market_linux_container:

==============================
Linux Containers MarketPlace
==============================

Overview
================================================================================

The `Linux Containers image server <https://images.linuxcontainers.org/>`__ hosts a public image server with container images for LXC and LXD. It is the default image server for LXD.

OpenNebula's Linux Containers marketplace enable users to easily download, contextualize and add Linux containers images to an OpenNebula datastore. The container images are downloaded in a compressed form. In order to use them, OpenNebula creates an image, where it dumps the content, install the corresponding context packages, and later uploads it to the datastore. The marketplace also creates a VM template with a set of required and optional values. There is a log file (``/var/log/chroot.log``) inside the imported app filesystem which shows information about the operations done during the app setup process; in case of issues it could be a useful source of information.

.. note:: More information on how to use Linux Containers images with the different hypervisors can be found :ref:`here <container_image_usage>`.

Requirements
================================================================================

- OpenNebula's frontend needs an Internet connection to https://images.linuxcontainers.org and https://github.com
- Approximately 6GB of storage plus the container image size configured on your frontend.

Configuration
================================================================================

Several parameters can be specified in the marketplace's template:

+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
|   Attribute       |                         Description                 |                Default                                                |
+===================+=====================================================+=======================================================================+
| ``NAME``          | Required                                            |                                                                       |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``MARKET_MAD``    | ``linuxcontainers``                                 |                                                                       |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``ENDPOINT``      | The base URL of the Market.                         | ``https://images.linuxcontainers.org``                                |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``IMAGE_SIZE_MB`` | Size in MB for the image holding the rootfs         |                 ``1024``                                              |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``FILESYSTEM``    | Filesystem used for the image                       |                 ``ext4``                                              |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``FORMAT``        | Image block file format                             |                 ``raw``                                               |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+
| ``SKIP_UNTESTED`` | Only auto-contextualized apps (linuxcontainers)     |                 ``yes``                                               |
+-------------------+-----------------------------------------------------+-----------------------------------------------------------------------+

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
