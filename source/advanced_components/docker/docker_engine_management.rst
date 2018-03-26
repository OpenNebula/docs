.. _docker_engine_management:

================================================================================
Docker Engine Management
================================================================================

Requirements
================================================================================

For docker integration we need to install `docker machine <https://docs.docker.com/machine/install-machine/>`__  and `docker <https://docs.docker.com/install/#server>`__ as shown in the example below (Ubuntu 16.04):

.. prompt:: bash # auto

    # curl -L https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && sudo install /tmp/docker-machine /usr/local/bin/docker-machine
    # sudo apt-get install docker-ce

1 - Set up environment
================================================================================

Once we have all the requirements we need to provide an OpeNebula user to docker-machine, the user will need permissions to create / manage instances.
Set up env variables ``ONE_AUTH`` to contain ``user:password`` and ``ONE_XMLRPC`` to point to the OpenNebula cloud.

.. prompt:: bash # auto

    # export ONE_AUTH=/var/lib/one/one_auth
    # export ONE_XMLRPC=https://<ONE FRONTEND>:2633/RPC2

2 - Deploy a Docker Engine
================================================================================

For the vCenter hypervisor you will need to follow these steps first:

    - Upload the recommended `image <http://marketplace.opennebula.systems/appliance/56d073858fb81d0315000002>`__ for vCenter from the marketplace into a Datastore in vCenter.
    - Make sure you have a network defined in vCenter to connect Docker to.
    - Create a VM Template in vCenter, with the following hardware:
    - Desired capacity: CPU, Memory.
    - New CD/DVD Drive (Datastore ISO File): select the Boot2Docker ISO. Make sure you check *Connect At Power On*.
    - New Hard disk: select the desired capacity for the Docker scratch data.
    - Do not specify a network, remove it if one was added automatically.

    In OpenNebula, you will need to import the VM template and the desired networks, using the create Host dialog. Make sure you make the network type `ipv4`.

In order to deploy a docker engine in KVM or vCenter we can use an OpenNebula registered template

.. prompt:: bash # auto
    
    # docker-machine create --driver opennebula --opennebula-template-id <template-id> --opennebula-network-id <network-id> <host-name>

Or Boot2Docker image (you can import Boot2Docker image from the marketplace), if you are using vCenter we recommend to use this option:

.. prompt:: bash # auto

    # docker-machine create --driver opennebula --opennebula-network-name <network-name> --opennebula-image-id <image-id> --opennebula-b2d-size <data-size-mb> <name>

Once these pre-requisites are fulfilled you can now launch your docker-engine as see above:

.. prompt:: bash # auto

    #docker-machine create --driver opennebula --opennebula-template-id $TEMPLATE_ID --opennebula-network-id $NETWORK_ID b2d

.. note::
    All the driver options are available at the reference section of the driver.

.. warning:: You must specify a network for docker machine can communicate with the virtual machine.

3 - Interact with the Docker Engine
=====================================================================================

Select the docker engine you want to use executing the output of the command below:

.. prompt:: bash # auto

    # docker-machine env <name>

When the docker engine is selected an asterisk will appear in the active column:

.. prompt:: bash # auto

    # docker-machine env ls
    NAME     ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
    docker   *        opennebula   Running   tcp://192.168.122.8:2376           v18.03.0-ce

Once we have selected the docker engine we can use docker cli to interact with it:

.. prompt:: bash # auto

    # docker ps


