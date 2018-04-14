.. _opennebula_docker_application:

=========================================================
OpenNebula Docker Application
=========================================================

This Guide shows how to use the OpenNebula Docker Application to create and run some services as containers.

OpenNebula Docker Appliance
=========================================================

The Docker Appliance available on the OpenNebula marketplace brings a Docker Engine pre-installed and the contextualization packages configured to create Docker Hosts in a single click.

The Docker Appliance is based on Ubuntu and have installed Docker, you can found more information about ths specific versions at the :ref:`platform notes<uspng>`. In order to access the appliance once it's have been deployed it's necessary to update the template with the network and the password for the root user or the SSH key.

In order to prepare your cloud to serve Docker Engines please follow the next steps.

Step 1 - Create a Template and Instantiate the VM
=========================================================

KVM
---------------------------------------------------------

  Download the appliance from the apps marketplace:

  |img-marketplace-kvm|

  When the appliance is downloaded a template with the same name it's created. It's recomended to update the template with a network for make the vm accessible from outside, set the disk size the root password or the ssh key.

  Once the template have been updated it will be ready be to instantiate.

vCenter
---------------------------------------------------------

  Download the appliance from the apps marketplace:

  |img-marketplace-vcenter|

  Create a vCenter template or update an existing one, the template must have a network for make the vm accessible from outside. Once the template is ready import both the template and the network into OpenNebula.

  From OpenNebula update the template and attach the appliance disk to the vm. Also it's recommended to update the context of the template for set the root password or to include an SSH key.

.. note:: If you want to make any changes in the appliance and save them for latter use, you can set the image as persistent before launching the appliance. After the changes are performed, you need to shut the VM down and remove the persistent option from the image. This way you can create a golden imagen and new instantiations of the appliance won't overwrite it.

|image-persistent|

Step 2 - Running Hello World
=========================================================

Once the VM is running you can connect over SSH or VNC. You can run the docker "Hello world" and make sure every thing it's running well.

.. prompt:: bash # auto

    # ssh root@<vm_ip>
    # root@ubuntu:~# docker run hello-world
      Unable to find image 'hello-world:latest' locally
      latest: Pulling from library/hello-world
      ca4f61b1923c: Pull complete
      Digest: sha256:97ce6fa4b6cdc0790cda65fe7290b74cfebd9fa0c9b8c38e979330d547d22ce1
      Status: Downloaded newer image for hello-world:latest

      Hello from Docker!
      This message shows that your installation appears to be working correctly.

Now you can see the "hello-world" image has been included in your images:

.. prompt:: bash # auto

    # root@ubuntu:~# docker images
      REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
      hello-world         latest              f2a91732366c        4 months ago        1.85kB

You can also see the container using the -a option (for show all the containers, including the ones that are not running):

.. prompt:: bash # auto

    # root@ubuntu:~# docker ps -a
      CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
      3a0189f6b0af        hello-world         "/hello"            9 minutes ago       Exited (0) 9 minutes ago                       flamboyant_mirzakhani


Step 3 - Update the Docker Version
=========================================================

You can check your Docker version:

.. prompt:: bash # auto

    # root@ubuntu:~# docker version
      Client:
        Version:	    18.03.0-ce
        API version:	1.37
        Go version:	    go1.9.4
        Git commit:	    0520e24
        Built:	Wed Mar 21 23:10:01 2018
        OS/Arch:	    linux/amd64
        Experimental:	false
        Orchestrator:	swarm

      Server:
       Engine:
        Version:	    18.03.0-ce
        API version:	1.37 (minimum version 1.12)
        Go version:	    go1.9.4
        Git commit:	    0520e24
        Built:	Wed Mar 21 23:08:31 2018
        OS/Arch:	    linux/amd64
        Experimental:	false

And update it using the OS packages manager:

.. prompt:: bash # auto

    # root@ubuntu:~#apt-get update
    # root@ubuntu:~#apt-get upgrade

Step 4 - Save the Image
=========================================================

If you want to save some changes of a non persistent image you just have to make a disk saveas, this option is available at the storage tab of the VM, this will automatically create a new image with the changes.

|disk-saveas|


.. |img-marketplace-kvm| image:: /images/ubuntu1604-docker-kvm-marketplace.png
.. |img-marketplace-vcenter| image:: /images/ubuntu1604-docker-vcenter-marketplace.png
.. |image-persistent| image:: /images/ubuntu-docker-image-persistent.png
.. |disk-saveas| image:: /images/disksaveas-docker.png
