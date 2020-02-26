.. _docker_host_provision_with_docker_machine:

================================================================================
Docker Hosts Provision with Docker Machine
================================================================================

Introduction
================================================================================

This guide shows how to provision and manage remote Docker Hosts with Docker Machine on your OpenNebula cloud.

Prerequisites
================================================================================
To follow this guide, you will need the following (see the Platform Notes to see the version certified):

    * Access to a fully working OpenNebula cloud running version 5.6 or later. You can check this by using any OpenNebula CLI command without parameters.
    * A client computer with Docker CLI (the daemon is not required) and Docker Machine installed.
    * Your OpenNebula Cloud must be accessible from your client computer.
    * The OpenNebula Docker application available in the Marketplace should have been imported into the OpenNebula cloud, you can find more information at :ref:`Docker Appliance Configuration <docker_appliance_configuration>`.

This guide shows how to specify all the required command line  attributes to create the Docker Engines. As an alternative you can specify a template registered in OpenNebula, in this case you can see all the available options at :ref:`Docker Machine Driver References <docker_machine_driver_reference>` section.

Step 1 - Install Docker Machine OpenNebula Driver
================================================================================

In order to install the Docker Machine OpenNebula Driver you just need to install the package `docker-machine-opennebula` available `here <https://opennebula.org/software/>`__ in your desktop.

In case you already have it installed in the OpenNebula frontend (or any other host) you instead can copy the `docker-machine-driver-opennebula` file from the /usr/share/docker_machine path of the frontend into any folder of your desktop that is included in your $PATH.


Step 2 - Configure Client Machine to Access the OpenNebula Cloud
================================================================================

It is assumed that you have a user with permissions to create / manage instances.

Set up env variables ONE_AUTH to contain user:password and ONE_XMLRPC to point to the OpenNebula cloud:

.. prompt:: bash # auto

    # export ONE_AUTH=~/.one/one_auth
    # export ONE_XMLRPC=https://<ONE FRONTEND>:2633/RPC2

Step 3 - Use with vCenter
================================================================================

For vCenter hypervisor you will need to follow these steps to be able to use Docker Machine:

    * Make sure you have a network defined in vCenter to connect Docker to.
    * Create a template in vCenter with the desired capacity (CPU, Memory), a new hard disk (select the desired capacity) and new CD/DVD Drive (Datastore    ISO File) with the ISO of the selected OS. Make sure you check Connect At Power On. Do not specify a network.
    * In OpenNebula you will need to import the template and the desired networks. Make sure you make the network type ipv4.

.. _start_your_first_docker_host:

Step 4 - Start your First Docker Host
================================================================================

To start your first Docker host you just need to use the `docker-machine create` command:

.. prompt:: bash # auto

    #docker-machine create --driver opennebula --opennebula-template-id $TEMPLATE_ID $VM_NAME

This command creates a VM in OpenNebula using $TEMPLATE_ID as the template and $VM_NAME as the VM name.

Make sure the network attached to the template allows Docker Machine to connect to the VM.

If you want to create a VM without using a template (only for KVM) you can take a look at "Not Using a Template" section from :ref:`Docker Machine Driver References <docker_machine_driver_reference>`.

Step 5 - Interact with your Docker Engine
================================================================================

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

Containers Orchestration Platforms
================================================================================

Swarm
--------------------------------------------------------------------------------

Check the OpenNebula `blog post <https://opennebula.org/docker-swarm-with-opennebula/>`__ to learn how to use Docker Swarm on an OpenNebula cloud.

Swarmkit / Swarm mode
--------------------------------------------------------------------------------

Check `Docker documentation <https://docs.docker.com/get-started/part4/#create-a-cluster>`__ to use Swarmkit / Swarm mode. If you have discovery issues, please check your multicast support is OK.

As long as your VM template includes only one network, you should not even need to give --advertise-addr or --listen-addr

Rancher
--------------------------------------------------------------------------------

In order to use Rancher with OpenNebula, you first need create a VM with docker, by using docker-machine. You can find information about this step here :ref:`Step 4 - Start your First Docker Host <start_your_first_docker_host>`.

**Step 1 – Rancher Installation**

Once the machine is created, we can install the rancher server using the following commands:

.. prompt:: bash # auto

    $ eval $(docker-machine env rancher-server)

    $ docker run -d --restart=unless-stopped -p 8080:8080 rancher/server

After about a minute, your host should be ready and you can browse to http://rancher-server-ip:8080 and bring up the Rancher UI. If you deploy the Rancher server on a VM with access to the to the Internet, it’s a good idea to set up access control (via github, LDAP …). For more information regarding the Rancher installation (single node and HA setup and the authentication) you can refer to the official `documentation <http://docs.rancher.com//>`__.

**Step 2 – Adding OpenNebula Machine Driver**

To add OpenNebula Virtual Machines as hosts to Rancher you need to add the docker machine plugin binary in the Admin Machine Drivers settings.

|add the docker machine plugin binary|

A Linux binary of the OpenNebula machine driver is available at https://github.com/OpenNebula/docker-machine-opennebula/releases/download/release-0.2.0/docker-machine-driver-opennebula.tgz.

|adding the docker machine plugin binary|

Once you added the machine driver, a screen with the OpenNebula driver should be active.

|added the docker machine plugin binary|

**Step 3 – Adding OpenNebula Hosts**

The first time adding a host, you will see a screen asking you to confirm the IP address your Rancher server is available on, i.e. where the compute nodes will connect.

|adding openNebula hosts|

Once you save the settings, you can proceed to create the first Rancher host.

|create the first rancher host|

Select the opennebula driver and insert at least the following options:

* Authentication: user, password
* OpenNebula endpoint: xmlrpcurl (http://one:2633/RPC2)
* ImageID
* NetworkID

and then you can proceed to create the host. After few minutes, when the creation process is complete, you should get a screen with the active host.

**Step 4 – Deploy a container**

To test the environment, you can select the host and add a container:

Autoscaling via OneFlow
--------------------------------------------------------------------------------

A service of Docker engines can be defined in :ref:`OneFlow <appflow_use_cli>`, and the autoscaling mechanisms of OneFlow used to automatically grow/decrease the number of Docker engines based on application metrics.

.. |add the docker machine plugin binary| image:: /images/add_the_docker_machine_plugin_binary.png
.. |adding the docker machine plugin binary| image:: /images/adding_the_docker_machine_plugin_binary.png
.. |added the docker machine plugin binary| image:: /images/added_the_docker_machine_plugin_binary.png
.. |adding openNebula hosts| image:: /images/adding_openNebula_hosts.png
.. |create the first rancher host| image:: /images/create_the_first_rancher_host.png