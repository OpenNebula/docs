===========================================
Docker and OpenNebula integration
===========================================

For docker integration we need to install docker machine and docker at OpenNebula frontend:

.. prompt:: bash # auto

    # curl -L https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && sudo install /tmp/docker-machine /usr/local/bin/docker-machine
    # sudo apt-get install docker-ce

Official documentation for Docker Machine is available `here <https://docs.docker.com/machine/>`__.

Usage
================================================================================

Once we have all the requirements we need to provide docker a user to use for docker-machine with OpenNebula, the user will need permissions to create / manage instances.
Set up env variables ``ONE_AUTH`` to contain ``user:password`` and ``ONE_XMLRPC`` to point to the OpenNebula cloud.

.. prompt:: bash # auto

    #export ONE_AUTH=/var/lib/one/one_auth
    #export ONE_XMLRPC=https://<ONE FRONTEND>:2633/RPC2


Once you have fulfilled these pre-requisites you can now launch your docker-engine over OpenNebula. 

We can create a host using an OpenNebula registered template:

.. prompt:: bash # auto
    
    # docker-machine create --driver opennebula --opennebula-template-id <template-id> --opennebula-network-id <network-id> <host-name>

Or using Boot2Docker image (you can import Boot2Docker image from marketplace):

.. prompt:: bash # auto

    # docker-machine create --driver opennebula --opennebula-network-name <network-name> --opennebula-image-id <image-id> --opennebula-b2d-size <data-size-mb> <name>

.. note::

    Is neccesary to attach a network to the vm in order to docker-machine works. Also is neccesary the ``--opennebula-b2d-size`` in case you use the Boot2Docker image.


vCenter
================================================================================

For the vCenter hypervisor, we recommend using Boot2Docker. You will need to follow these steps first:

- Upload the [Boot2Docker](http://marketplace.opennebula.systems/appliance/56d073858fb81d0315000002) ISO into a Datastore in vCenter.
- Make sure you have a network defined in vCenter to connect Docker to.
- Create a Template in vCenter, with the following hardware:
  - Desired capacity: CPU, Memory.
  - New CD/DVD Drive (Datastore ISO File): select the Boot2Docker ISO. Make sure you check *Connect At Power On*.
  - New Hard disk: select the desired capacity for the Docker scratch data.
  - Do not specify a network, remove it if one was added automatically.

In OpenNebula, you will need to import the template and the desired networks, using the create Host dialog. Make sure you make the network type `ipv4`.

Once you have fulfilled these pre-requisites you can now launch your docker-engine:

.. prompt:: bash # auto

    #docker-machine create --driver opennebula --opennebula-template-id $TEMPLATE_ID --opennebula-network-id $NETWORK_ID b2d



Available Driver Options
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

Using a template
================================================================================

Using a template means specifying either `--opennebula-template-id` or `--opennebula-template-name`. If you specify either of these two options, the following table applies, indicating what incompatible and what overrideable parameters are available:

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

The template must have a reference to an image, however, referencing a network is entirely option. It the template has a network, the `--opennebula-network-*` options will override it, using the one in the template by default; if the template doesn't reference any networks, the `docker-machine` user **must** specify one.