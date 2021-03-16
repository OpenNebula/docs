.. _market_dh:

==============================
DockerHub MarketPlace
==============================

Overview
================================================================================

OpenNebula DockerHub integration provide access to `DockerHub Official Images <https://hub.docker.com/search?image_filter=official&type=image>`__. This integration allows to easily import these DockerHub images to the OpenNebula cloud. The OpenNebula context packages are installed during the import process so once an image is imported it's fully prepared to be used.

The DockerHub marketplace will also create a new VM template associated with the imported image. This template can be customized by the user (e.g adding the desire kernel, tune parameter, etc...).

.. note:: More information on how to use DockerHub images with the different hypervisors can be found :ref:`here <container_image_usage>`.

|image1|

Requirements and limitations
================================================================================

- OpenNebula's frontend needs an Internet connection to https://hub.docker.com.
- Docker must be installed and configured at the frontend. ``oneadmin`` user must have permissions for running docker.
- Approximately 6GB of storage plus the container image size configured on your frontend.
- As images are builded in the OpenNebula Frontend node the architecture of this node will limit the images architecture.

.. warning:: OpenNebula service must be restarted after providing permissions to ``oneadmin`` for  running docker.

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

Downloading non official images
================================================================================

The DockerHub MarketPlace have available only the `DockerHub Official Images <https://hub.docker.com/search?image_filter=official&type=image>`__, if a non official image needs to be imported to the cloud you can create a new image and use as ``path`` argument an URL with the following format:

.. code::

    docker://<image>?size=<image_size>&filesystem=<fs_type>&format=raw&tag=<tag>&distro=<distro>

The different arguments of the URL are explained below:

+-----------------------+-------------------------------------------------------+
| Argument              | Description                                           |
+=======================+=======================================================+
| ``<image>``           | DockerHub image name.                                 |
+-----------------------+-------------------------------------------------------+
| ``<image_size>``      | Resulting image size. (It must be greater than actual |
|                       | image size)                                           |
+-----------------------+-------------------------------------------------------+
| ``<fs_type>``         | Filesystem type (ext4, ext3, ext2 or xfs)             |
+-----------------------+-------------------------------------------------------+
| ``<tag>``             | Image tag name (default ``latest``).                  |
+-----------------------+-------------------------------------------------------+
| ``<distro>``          | (Optional) image distribution.                        |
+-----------------------+-------------------------------------------------------+

.. warning:: OpenNebula finds out the image distribution automatically by running the container and checking ``/etc/os-release`` file. If this information is not available inside the container the ``distro`` argument have to be used.

For example, with the command below we will create a new image called ``nginx-dh`` based on the ``nginx`` image from DockerHub with 3GB size using ``ext4`` and the ``alpine`` tag, the image will be stored in the image DS with id 1:

.. code::

    $ oneimage create --name nginx-dh --path 'docker://nginx?size=3072&filesystem=ext4&format=raw&tag=alpine' --datastore 1
      ID: 0
    $ oneimage list
      ID USER     GROUP    NAME      DATASTORE SIZE TYPE PER STAT RVMS
       0 oneadmin oneadmin nginx-dh  default     3G OS    No rdy     0

.. note:: This format can also be used at Sunstone image creation dialog.

.. _dockerfile:

Creating an image based on a Dockerfile
================================================================================

OpenNebula allows you to create custom images based on your own dockerfiles. The URL has the following format:

.. code::

    dockerfile://<path_to_file>?fileb64=<file_in_base64>&context=<yes|no>

The different arguments of the URL are explained below:

+-----------------------+------------------------------------------------------------+
| Argument              | Description                                                |
+=======================+============================================================+
| ``<path_to_file>``    | Path in OpenNebula server where the Dockerfile is located. |
+-----------------------+------------------------------------------------------------+
| ``<file_in_base64>``  | Dockerfile in Base64 form. If this is specified, the path  |
|                       | is ignored.                                                |
+-----------------------+------------------------------------------------------------+
| ``<context>``         | If it set to yes, OpenNebula context packages are added.   |
|                       | If it is not set or set to no, they are omitted.           |
+-----------------------+------------------------------------------------------------+

.. note:: The arguments in the previous section, are also supported.

.. important:: Multistage Dockerfiles are not supported, only one FROM directive can be included.

In order to create an image using your own Dockerfile, you can use the command ``oneimage create``:

.. code::

    $ oneimage create --name testing-df --path 'dockerfile:///tmp/my_dockerfile?size=256' --datastore 1 --prefix vd
      ID: 0
    $ oneimage list
      ID USER     GROUP    NAME       DATASTORE SIZE TYPE PER STAT RVMS
      0  oneadmin oneadmin testing-df default   256M OS    No rdy     0

There is also a dedicated command ``oneimage dockerfile`` that will open an editor so you can edit your Dockerfile there.

.. note:: In order to avoid context generation, you can use the flag ``--no-context`` in both commands.

Tuning & Extending
==================

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.

.. |image1| image:: /images/dh_mktplace.png

