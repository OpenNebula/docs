.. _market_dh:

DockerHub Marketplace
================================================================================

The DockerHub Marketplace provide access to `DockerHub Official Images <https://hub.docker.com/search?image_filter=official&type=image>`__. The OpenNebula context packages are installed during the import process so once an image is imported it's fully prepared to be used.

.. note:: More information on how to use DockerHub images with the different hypervisors can be found :ref:`here <container_image_usage>`.

Requirements and limitations
--------------------------------------------------------------------------------

- Docker must be installed and configured at the frontend. ``oneadmin`` user must have permissions for running docker.
- Approximately 6GB of storage plus the container image size.
- As images are builded in the OpenNebula Frontend node the architecture of this node will limit the images architecture.

.. warning:: OpenNebula service must be restarted after providing permissions to ``oneadmin`` for  running docker.

Configuration Attributes
--------------------------------------------------------------------------------

+----------------+--------------------------------------------------------------+
|   Attribute    |                         Description                          |
+================+==============================================================+
| ``NAME``       | The name of the Marketplace. Default: DockerHub              |
+----------------+--------------------------------------------------------------+
| ``MARKET_MAD`` | ``dockerhub``                                                |
+----------------+--------------------------------------------------------------+


Downloading non official images
--------------------------------------------------------------------------------

The DockerHub MarketPlace only list official images, if you need to use a non official image you can create an image (``oneimage create``) using as ``PATH`` (or ``--path`` option) an URL with the following format:

.. code::

    docker://<image>?size=<image_size>&filesystem=<fs_type>&format=raw&tag=<tag>&distro=<distro>

where the meaning of each option is described below:

+-----------------------+-------------------------------------------------------+
| Argument              | Description                                           |
+=======================+=======================================================+
| ``<image>``           | DockerHub image name.                                 |
+-----------------------+-------------------------------------------------------+
| ``<image_size>``      | Resulting image size in MB. (It must be greater       |
|                       | than actual image size)                               |
+-----------------------+-------------------------------------------------------+
| ``<fs_type>``         | Filesystem type (ext4, ext3, ext2 or xfs)             |
+-----------------------+-------------------------------------------------------+
| ``<tag>``             | Image tag name (default ``latest``).                  |
+-----------------------+-------------------------------------------------------+
| ``<distro>``          | (Optional) image distribution.                        |
+-----------------------+-------------------------------------------------------+

.. warning:: OpenNebula finds out the image distribution automatically by running the container and checking ``/etc/os-release`` file. If this information is not available inside the container the ``distro`` argument have to be used.

For example, to create a new image called ``nginx-dh`` based on the ``nginx`` image from DockerHub with 3GB size using ``ext4`` and the ``alpine`` tag, you can use:

.. code::

    $ oneimage create --name nginx-dh --path 'docker://nginx?size=3072&filesystem=ext4&format=raw&tag=alpine' --datastore 1
      ID: 0

.. note:: This url format can also be used at Sunstone image creation dialog.

Entrypoint
--------------------------------------------------------------------------------

When you download an application from the Dockerhub, OpenNebula will automatically inspect it to check if there is entrypoint information. This ``ENTRYPOINT`` and/or ``CMD`` commands are placed in the ``/one_entrypoint.sh`` script so it can be executed on boot. All the environment variables are passed into the script and can be further customized by the user by adding new values through context. Simply, add the environment variable as described by the documentation of the appliance in the ``CONTEXT`` section.

.. note:: You **have to** trigger the entrypoint execution in the ``START_SCRIPT`` with a line similar to: ``nohup /one_entrypoint.sh &> /dev/null &``.
