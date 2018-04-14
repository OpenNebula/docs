.. _docker_host_provision_with_docker_machine:

================================================================================
Docker Hosts Provision with Docker Machine
================================================================================

Introduction
================================================================================

The Guides shows how to provision and manage remote Docker Hosts with Docker Machine on your OpenNebula cloud. 

Prerequisites
================================================================================
To follow this guide, you will need the following (see the Platform Notes to see the version certified):

    * Access to a fully working OpenNebula cloud running version 5.6 or later. You can check this by using any OpenNebula CLI command without parameters.
    * A client computer with Docker CLI (the daemon is not required) and Docker Machine installed.
    * Your OpenNebula Cloud must be accessible from your client computer.
    * The OpenNebula Docker application available in the Marketplace should have been imported into the OpenNebula cloud.
   
This guide shows how to specify in the command line all the required attributes to create the Docker Engines. As an alternative you can specify a template registered in OpenNebula, in this case you can see all the available options at :ref:`Docker Machine Driver References <docker_machine_driver_reference>` section.

Step 1 - Install Docker Machine OpenNebula Driver
================================================================================

In order to install the Docker Machine OpenNebula Driver just need to install at your front-end node the package `opennebula-docker`.

If you want to use docker in other host just copy the `docker-machine-driver-opennebula` file from the /usr/share/docker_machine path of your frontend.

Step 2 - Configure Client Machine to Access the OpenNebula Cloud
================================================================================

It is assumed that you have a user with permissions to create / manage instances.

Set up env variables ONE_AUTH to contain user:password and ONE_XMLRPC to point to the OpenNebula cloud:

.. prompt:: bash # auto
    
    # export ONE_AUTH=~/.one/one_auth
    # export ONE_XMLRPC=https://<ONE FRONTEND>:2633/RPC2

Step 3 - Use with vCenter
================================================================================

For vCenter hypervisor you will need to follow this steps:
    
    * Make sure you have a network defined in vCenter to connect Docker to.
    * Create a template in vCenter with the desired capacity (CPU, Memory), a new hard disk (select the desired capacity) and new CD/DVD Drive (Datastore    ISO File) with the ISO of the selected OS. Make sure you check Connect At Power On. Do not specify a network.
    * In OpenNebula you will need to import the template and the desired networks. Make sure you make the network type ipv4.

Once you have fulfilled these pre-requisites you can now launch your docker-engine:

    .. prompt:: bash # auto

        # docker-machine create --driver opennebula --opennebula-template-id $TEMPLATE_ID --opennebula-network-id $NETWORK_ID $VM_NAME

Step 4 - Start your First Docker Host
================================================================================

For start your first Docker host you just need to use the `docker-machine create` command:

.. prompt:: bash # auto
    
    #docker-machine create --driver opennebula --opennebula-network-name $NETWORK_NAME --opennebula-image-id $IMG_ID --opennebula-b2d-size $DATA_SIZE_MB $VM_NAME

This command create a VM in OpenNebula using $IMG_ID as image, $NETWORK_NAME as network, $DATA_SIZE_MB as disk size and $VM_NAME as the VM name.

Make sure the network you pass throught $NETWORK_NAME allow Docker Machine to connect to the VM.

You can use many other options for create a VM, like create a VM from a template, you can see all the available options at :ref:`Docker Machine Driver References <docker_machine_driver_reference>` section.

Step 5 - Interact with your Docker Engine
================================================================================

You can list or the VMs deployed by docker machine:

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

Activate the host, you can connect your Docker client to the remote host for run docker commands:

.. prompt:: bash # auto
    
    # eval $(docker-machine env ubuntu-docker)
    # docker-machine ls
      NAME            ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER        ERRORS
      ubuntu-docker   *        opennebula   Running   tcp://192.168.122.3:2376           v18.04.0-ce   
    # docker ps -a
      CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
      787b15395f48        hello-world         "/hello"            6 minutes ago       Exited (0) 6 minutes ago                       upbeat_bardeen


You can see how an "*" appears at the active field.
