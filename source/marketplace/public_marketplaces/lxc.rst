.. _market_linux_container:

Linux Containers MarketPlace
================================================================================

The `Linux Containers image server <https://images.linuxcontainers.org/>`__ hosts a public image server with container images for LXC and LXD. OpenNebula's Linux Containers marketplace enable users to easily download, contextualize and add Linux containers images to an OpenNebula datastore.

.. note:: A log file (``/var/log/chroot.log``) is created inside the imported image filesystem with information about the operations done during the setup process; in case of issues it could be a useful source of information.

.. note:: More information on how to use Linux Containers images with the different hypervisors can be found :ref:`here <container_image_usage>`.

Requirements
--------------------------------------------------------------------------------

- Approximately 6GB of storage plus the container image size.

Configuration Attributes
--------------------------------------------------------------------------------

+-------------------+---------------------------------------------+----------------------------------------+
| Attribute         | Description                                 | Default                                |
+===================+=============================================+========================================+
| ``NAME``          | Marketplace name (Required)                 |                                        |
+-------------------+---------------------------------------------+----------------------------------------+
| ``MARKET_MAD``    | ``linuxcontainers``                         |                                        |
+-------------------+---------------------------------------------+----------------------------------------+
| ``ENDPOINT``      | The base URL of the Market.                 | ``https://images.linuxcontainers.org`` |
+-------------------+---------------------------------------------+----------------------------------------+
| ``IMAGE_SIZE_MB`` | Size in MB for the image holding the rootfs | ``1024``                               |
+-------------------+---------------------------------------------+----------------------------------------+
| ``FILESYSTEM``    | Filesystem used for the image               | ``ext4``                               |
+-------------------+---------------------------------------------+----------------------------------------+
| ``FORMAT``        | Image block file format                     | ``raw``                                |
+-------------------+---------------------------------------------+----------------------------------------+
| ``SKIP_UNTESTED`` | Include only apps with support for context  | ``yes``                                |
+-------------------+---------------------------------------------+----------------------------------------+
| ``CPU``           | VMTemplate CPU                              | ``1``                                  |
+-------------------+---------------------------------------------+----------------------------------------+
| ``VCPU``          | VMTemplate VCPU                             | ``2``                                  |
+-------------------+---------------------------------------------+----------------------------------------+
| ``MEMORY``        | VMTemplate MEMORY                           | ``768``                                |
+-------------------+---------------------------------------------+----------------------------------------+
| ``PRIVILEGED``    | Secrurity mode of the Linux Container       | ``true``                               |
+-------------------+---------------------------------------------+----------------------------------------+

.. _market_turnkey_linux:

TurnKey Linux MarketPlace
================================================================================

`TurnKey Linux <https://www.turnkeylinux.org/>`__ is a free software repository that provides container images based on Debian. The TurnKey Linux Marketplace automatically installs OpenNebula context packages, so Images are ready to use.

.. note:: A log file (``/var/log/chroot.log``) is created inside the imported image filesystem with information about the operations done during the setup process; in case of issues it could be a useful source of information.

.. note:: More information on how to use Turnkey Linux images with the different hypervisors can be found :ref:`here <container_image_usage>`.

Requirements
--------------------------------------------------------------------------------

- Approximately 6GB of storage plus the container image size configured on your frontend.

Configuration Attributes
--------------------------------------------------------------------------------

+-------------------+-----------------------------------------------------+-----------------------------------+
|   Attribute       |                         Description                 |                Default            |
+===================+=====================================================+===================================+
| ``NAME``          | Marketplace name (Required)                         |                                   |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``MARKET_MAD``    | ``turnkeylinux``                                    |                                   |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``ENDPOINT``      | The base URL of the Market.                         | ``http://turnkeylinux.org``       |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``IMAGE_SIZE_MB`` | Size in MB for the image holding the rootfs         |                 ``1024``          |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``FILESYSTEM``    | Filesystem used for the image                       |                 ``ext4``          |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``FORMAT``        | Image block file format                             |                 ``raw``           |
+-------------------+-----------------------------------------------------+-----------------------------------+
| ``SKIP_UNTESTED`` | Include only apps with support for context          |                 ``yes``           |
+-------------------+-----------------------------------------------------+-----------------------------------+
