.. _docker_machine:

================================================================================
Docker Machine
================================================================================

`Docker Machine <https://docs.docker.com/machine/overview/>`_ is a client and management tool for the `Docker <https://www.docker.com>`_ daemons on remote systems. OpenNebula provides its users with a custom **Docker Machine driver** (described on this page) which enables functionality like automated creation of a ready Dockerized host without the need to instantiate VM beforehand.

To follow this guide you need:

    * Access to a fully working OpenNebula cloud running version 5.6 or later. You can check this by using any OpenNebula CLI command without parameters.
    * A client computer with Docker CLI (the daemon is not required) and Docker Machine installed.
    * Your OpenNebula Cloud must be accessible from your client computer.

Step 1 - Install Docker Machine OpenNebula Driver
--------------------------------------------------------------------------------

The recommended way to install the driver is to configure the :ref:`repositories <repositories>` and perform one of the following depending on the package manager available in your distibution:

- ``yum install docker-machine-opennebula``
- ``apt-get install docker-machine-opennebula``

Alternatively you can get the binary `here <https://downloads.opennebula.io/packages/opennebula-6.1.80/opennebula-docker-machine-6.1.80.tar.gz>`__.

Lastly, in the case that you already have it installed in the OpenNebula frontend (or any other host) you can instead copy the ``/usr/bin/docker-machine-driver-opennebula`` file directly from the the frontend into any directory on your desktop which is included in your ``$PATH``.

Step 2 - Configure Client Machine to Access the OpenNebula Cloud
--------------------------------------------------------------------------------

It is assumed that you have a user with permissions to create / manage instances.

Set up env variables ONE_AUTH to contain user:password and ONE_XMLRPC to point to the OpenNebula cloud:

.. prompt:: bash # auto

    # export ONE_AUTH=~/.one/one_auth
    # export ONE_XMLRPC=http://<ONE FRONTEND>:2633/RPC2

.. _start_your_first_docker_host:

Step 3 - Start your First Docker Host
--------------------------------------------------------------------------------

In order to create a docker host, you need a VM template or an OS image, and a network defined in your OpenNebula cloud. Make sure the network allows Docker Machine to connect to the VM.

.. note:: For vCenter hypervisor you will need to follow these steps to be able to use Docker Machine:

    * Make sure you have a network defined in vCenter to connect Docker to.
    * Create a template in vCenter with the desired capacity (CPU, Memory), a new hard disk (select the desired capacity) and new CD/DVD Drive (Datastore ISO File) with the ISO of the selected OS. Make sure you check Connect At Power On. Do not specify a network.
    * In OpenNebula you will need to import the template and the desired networks. Make sure you make the network type ipv4.

To start your first Docker host you just need to use the ``docker-machine create`` command:

.. prompt:: bash # auto

    #docker-machine create --driver opennebula --opennebula-template-id $TEMPLATE_ID $VM_NAME

This command creates a VM in OpenNebula using $TEMPLATE_ID as the template and $VM_NAME as the VM name. 

If you want to create a VM without using a template (only for KVM) you can take a look at "Not Using a Template" section from :ref:`Docker Machine Driver References <docker_machine_driver_reference>`.

Step 4 - Interact with your Docker Engine
--------------------------------------------------------------------------------

You can list the VMs deployed by docker machine:

.. prompt:: bash # auto

    # docker-machine ls
      NAME            ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
      ubuntu-docker   -        opennebula   Running   tcp://192.168.122.3:2376           v18.04.0-ce

Poweroff the remote host:

.. prompt:: bash # auto

    # docker-machine stop ubuntu-docker
      Stopping "ubuntu-docker"...
      Machine "ubuntu-docker" was stopped.
    # docker-machine ls
      NAME            ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER   ERRORS
      ubuntu-docker            opennebula   Timeout

Restart the remote host:

.. prompt:: bash # auto

    # docker-machine start ubuntu-docker
      Starting "ubuntu-docker"...
      (ubuntu-docker) Waiting for SSH..
      Machine "ubuntu-docker" was started.
      Waiting for SSH to be available...
      Detecting the provisioner...
    # docker-machine ls
      NAME            ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
      ubuntu-docker   -        opennebula   Running   tcp://192.168.122.3:2376           v18.04.0-ce

Remove the remote host (it will remove the VM from OpenNebula):

.. prompt:: bash # auto

    # docker-machine rm ubuntu-docker
      About to remove ubuntu-docker
      WARNING: This action will delete both local reference and remote instance.
      Are you sure? (y/n): y
      Successfully removed ubuntu-docker

Get more information about the host:

.. prompt:: bash # auto

    # docker-machine inspect ubuntu-docker
      ...
      "EngineOptions": {
            "ArbitraryFlags": [],
            "Dns": null,
            "GraphDir": "",
            "Env": [],
            "Ipv6": false,
            "InsecureRegistry": [],
            "Labels": [],
            "LogLevel": "",
            "StorageDriver": "",
            "SelinuxEnabled": false,
            "TlsVerify": true,
            "RegistryMirror": [],
            "InstallURL": "https://get.docker.com"
        }
      ...

Get the IP address of the host:

.. prompt:: bash # auto

    # docker-machine ip ubuntu-docker
    192.168.122.3

Connect to the host via SSH:

.. prompt:: bash # auto

    # docker-machine ssh ubuntu-docker
      $ docker ps -a
        CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
        787b15395f48        hello-world         "/hello"            16 seconds ago      Exited (0) 15 seconds ago                       upbeat_bardeen

Activate the host, you can connect your Docker client to the remote host to run docker commands:

.. prompt:: bash # auto

    # eval $(docker-machine env ubuntu-docker)
    # docker-machine ls
      NAME            ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
      ubuntu-docker   *        opennebula   Running   tcp://192.168.122.3:2376           v18.04.0-ce
    # docker ps -a
      CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
      787b15395f48        hello-world         "/hello"            6 minutes ago       Exited (0) 6 minutes ago                       upbeat_bardeen


You can see how an "*" appears at the active field.

.. _docker_machine_driver_reference:

Docker Machine Driver Reference
------------------------------------

Driver Options
--------------------------------------------------------------------------------

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
- ``--opennebula-start-retries``: number of retries to make for check if the VM is running, after each retry the driver sleeps for 2 seconds.

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
| `--opennebula-start-retries` | 600                         | `ONE_START_RETRIES`    |
+------------------------------+-----------------------------+------------------------+

Using Templates
--------------------------------------------------------------------------------

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

The template must have a reference to an image, however, referencing a network is entirely optional. If the template has a network, the `--opennebula-network-*` options will override it, using the one in the template by default; if the template doesn't reference any networks, the `docker-machine` user **must** specify one.

.. prompt:: bash $ auto

    # A template that references a network doesn't require any --opennebula-network-* attribute:
    $ docker-machine create --driver opennebula --opennebula-template-id 10 mydockerengine

    # However it can be overridden:
    $ docker-machine create --driver opennebula --opennebula-template-id 10 --opennebula-network-id 2 mydockerengine

This is what the registered template in OpenNebula may look like:

.. code-block:: bash

    NAME="Ubuntu 18.04"

    CPU="1"
    MEMORY="512"

    # The OS Disk
    DISK=[
    IMAGE="Ubuntu 18.04" ]

    # The network can be specified in the template or as a parameter
    NIC=[
    NETWORK="public" ]

    # VNC
    GRAPHICS=[
    LISTEN="0.0.0.0",
    TYPE="vnc" ]

Note that if there is a CONTEXT section in the template, it will be discarded and replaced with one by docker-machine.

Not Using Templates
--------------------------------------------------------------------------------

if you don't specify neither ``-opennebula-template-id`` nor ``--opennebula-template-name``, then you must specify the image: ``--opennebula-image-*``, and the network: ``--opennebula-network-*``, and optionally the other parameters.
