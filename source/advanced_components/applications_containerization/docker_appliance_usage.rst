.. _docker_appliance_usage:


=========================================================
Docker Appliance Usage
=========================================================

In order to use the Docker Appliance it is needed to have the appliance configured at the OpenNebula installation. You can find more info at :ref:`Docker Appliance Configuration <docker_appliance_configuration>`.

Step 1 - Instantiate the template
=========================================================

First of all you need to identify the template. The default name is ``Ubuntu 16.04 with Docker``.

Then you just need to instantiate it and wait for it to be in ``running`` state.

|vm-running|


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

Step 4 - Update a Docker Image
=========================================================

You can get an existing image and change it:

.. prompt:: bash # auto

    # root@ubuntu:~#docker run -i -t ubuntu /bin/bash
      Unable to find image 'ubuntu:latest' locally
      latest: Pulling from library/ubuntu
      a48c500ed24e: Pull complete
      1e1de00ff7e1: Pull complete
      0330ca45a200: Pull complete
      471db38bcfbf: Pull complete
      0b4aba487617: Pull complete
      Digest: sha256:c8c275751219dadad8fa56b3ac41ca6cb22219ff117ca98fe82b42f24e1ba64e
      Status: Downloaded newer image for ubuntu:latest
    # root@0ac23d115db8:/# apt-get update
    # root@0ac23d115db8:/# apt-get install ruby-full
    # root@ubuntu:~#docker commit 0ac23d115db8  one/ubuntu-with-ruby
      sha256:eefdc54faeb5bafebd27012520a55b70c6818808997be2986d16b85b6c6f56e2
    # root@ubuntu:~#docker image ls
      REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
      one/ubuntu-with-ruby   latest              eefdc54faeb5        22 seconds ago      79.6MB


Step 5 - Save the Image
=========================================================

If you want to save changes like the ones performed in Step 3 and Step 4, the disk saveas functionality can be used to save this image as a new one. This option is available at the storage tab of the VM, this will automatically create a new image with the performed changes.

|disk-saveas|

.. |disk-saveas| image:: /images/disksaveas-docker.png
.. |vm-running| image:: /images/docker-appliance-running.png
