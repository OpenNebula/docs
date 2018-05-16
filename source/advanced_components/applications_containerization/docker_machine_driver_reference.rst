.. _docker_machine_driver_reference:

====================================
Docker Machine Driver Reference
====================================

Driver Options
================================================================================

- ``--opennebula-user``: User identifier to authenticate with
- ``--opennebula-password``: User password or token
- ``--opennebula-xmlrpcurl``: XMLRPC endpoint
- ``--opennebula-cpu``: CPU value for the VM
- ``--opennebula-vcpu``: VCPUs for the VM
- ``--opennebula-memory``: Size of memory for VM in MB
- ``--opennebula-template-id``: Template ID to use
- ``--opennebula-template-name``: Template to use
- ``--opennebula-network-id``: Network ID to connect the machine to
- ``--opennebula-network-name``: Network to connect the machine to
- ``--opennebula-network-owner``: User ID of the Network to connect the machine to
- ``--opennebula-image-id``: Image ID to use as the OS
- ``--opennebula-image-name``: Image to use as the OS
- ``--opennebula-image-owner``: Owner of the image to use as the OS
- ``--opennebula-dev-prefix``: Dev prefix to use for the images: 'vd', 'sd', 'hd', etc...
- ``--opennebula-disk-resize``: Size of disk for VM in MB
- ``--opennebula-b2d-size``: Size of the Volatile disk in MB (only for b2d)
- ``--opennebula-ssh-user``: Set the name of the SSH user
- ``--opennebula-disable-vnc``: VNC is enabled by default. Disable it with this flag

+------------------------------+-----------------------------+------------------------+
|          CLI Option          | Default Value               |  Environment Variable  |
+==============================+=============================+========================+
| `--opennebula-user`          |                             | `ONE_USER`             |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-password`      |                             | `ONE_PASSWORD`         |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-xmlrpcurl`     | `http://localhost:2633/RPC2`| `ONE_XMLRPC`           |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-cpu`           | `1`                         | `ONE_CPU`              |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-vcpu`          | `1`                         | `ONE_VCPU`             |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-memory`        | `1024`                      | `ONE_MEMORY`           |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-template-id`   |                             | `ONE_TEMPLATE_ID`      |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-template-name` |                             | `ONE_TEMPLATE_NAME`    |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-network-id`    |                             | `ONE_NETWORK_ID`       |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-network-name`  |                             | `ONE_NETWORK_NAME`     |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-network-owner` |                             | `ONE_NETWORK_OWNER`    |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-image-id`      |                             | `ONE_IMAGE_ID`         |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-image-name`    |                             | `ONE_IMAGE_NAME`       |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-image-owner`   |                             | `ONE_IMAGE_OWNER`      |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-dev-prefix`    |                             | `ONE_IMAGE_DEV_PREFIX` |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-disk-resize`   |                             | `ONE_DISK_SIZE`        |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-b2d-size`      |                             | `ONE_B2D_DATA_SIZE`    |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-ssh-user`      | `docker`                    | `ONE_SSH_USER`         |
+------------------------------+-----------------------------+------------------------+
| `--opennebula-disable-vnc`   | Enabled                     | `ONE_DISABLE_VNC`      |
+------------------------------+-----------------------------+------------------------+

Using Templates
================================================================================

Using a VM template means specifying either `--opennebula-template-id` or `--opennebula-template-name`. If you specify either of these two options, the following table applies, indicating what incompatible and what overrideable parameters are available:

+----------------------------+------------------------------+
|        Incompatible        |           Override           |
+============================+==============================+
| `--opennebula-image-id`    | `--opennebula-cpu`           |
+----------------------------+------------------------------+
| `--opennebula-image-name`  | `--opennebula-vcpu`          |
+----------------------------+------------------------------+
| `--opennebula-image-owner` | `--opennebula-memory`        |
+----------------------------+------------------------------+
| `--opennebula-dev-prefix`  | `--opennebula-network-id`    |
+----------------------------+------------------------------+
| `--opennebula-disk-resize` | `--opennebula-network-name`  |
+----------------------------+------------------------------+
| `--opennebula-b2d-size`    | `--opennebula-network-owner` |
+----------------------------+------------------------------+
| `--opennebula-disable-vnc` |                              |
+----------------------------+------------------------------+

If you try to specify an attribute in the *incompatible* list, along with either `--opennebula-template-id` or `--opennebula-template-name`, then `docker-machine` will raise an error. If you specify an attribute in the *override* list, it will use that value instead of what is specified in the template.

The template must have a reference to an image, however, referencing a network is entirely optional. It the template has a network, the `--opennebula-network-*` options will override it, using the one in the template by default; if the template doesn't reference any networks, the `docker-machine` user **must** specify one.

.. prompt:: bash $ auto
    
    # A template that references a network doesn't require any --opennebula-network-* attribute:
    $ docker-machine create --driver opennebula --opennebula-template-id 10 mydockerengine

    # However it can be overridden:
    $ docker-machine create --driver opennebula --opennebula-template-id 10 --opennebula-network-id 2 mydockerengine

This is what the registered template in OpenNebula may look like:

.. code-block:: bash

    NAME=b2d

    CPU="1"
    MEMORY="512"

    # The OS Disl
    DISK=[
    IMAGE="b2d" ]

    # The volatile disk (only for Boot2Docker)
    DISK=[
    FORMAT="raw",
    SIZE="1024",
    TYPE="fs" ]

    # The network can be specified in the template or as a parameter
    NIC=[
    NETWORK="private" ]

    # VNC
    GRAPHICS=[
    LISTEN="0.0.0.0",
    TYPE="vnc" ]

Note that if there is a CONTEXT section in the template, it will be discarded and replaced with one by docker-machine.

Not Using Templates
================================================================================

if you don't specify neither ``-opennebula-template-id`` nor ``--opennebula-template-name``, then you must specify the image: ``--opennebula-image-*``, and the network: ``--opennebula-network-*``, and optionally the other parameters.

