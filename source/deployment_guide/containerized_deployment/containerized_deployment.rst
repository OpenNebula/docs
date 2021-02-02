.. _containers:
.. _containerized_deployment:

================================================================================
Containerized Deployment (TP)
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

This page shows you how to install/deploy OpenNebula as Docker containers.

Overview
================================================================================

OpenNebula offers an official Docker image with all required dependencies installed inside. Running such image via (supported) container runtime like `Docker <https://www.docker.com/>`_ will create application container(s) acting as OpenNebula Frontend. The image is parametrized and can be configured to be deployed in multiple ways.

Container deployment in general provides a few benefits:

- Lightweight alternative to Virtualization
- Arguably easier and faster deployment than conventional installation
- Reproducible setup / initial deployment
- New installation option for systems without available OpenNebula packages
- Isolation of OpenNebula services from the host system and vice versa
- Parallel deployment of multiple OpenNebula Front-ends on the same system
- Easier rollback to some previous functioning version

.. note::

    There is a comprehensive explanation and comparison between virtual machines and containers on `What is a Container? <https://www.docker.com/resources/what-container>`_ page at `Docker <https://www.docker.com/>`_ website. You can then follow with the more in-depth `documentation and tutorial <https://docs.docker.com/get-started/overview/>`_.

.. _containers_requirements:

Requirements
------------

You will need a container runtime to deploy Docker images (one of these):

- **docker** (version **18.06.0+**)
- **podman** (version **2+** on CentOS/Fedora/RHEL only)

OpenNebula deployed as proper microservices will also need ``docker-compose`` tool for the relevant runtime:

- **docker-compose** for Docker (use version supporting `specification format 3.7+ <https://docs.docker.com/compose/compose-file/>`_)
- **podman-compose** for Podman (version **0.1.7dev+** - not as mature as ``docker-compose`` - beware)

.. _containers_architecture:

Architecture
================================================================================

OpenNebula Front-end, related services and their needed binaries are all shipped within a one container image: ``opennebula``

Running OpenNebula's services and other processes are confined inside the container(s). Containers are interconnected through internal container network and they can interact with the host or the host network only via :ref:`exposed TCP/IP ports <reference_ports>`.

Container startup and internal lifetime is determined by :ref:`the bootstrap process <reference_bootstrap>` which can be modified with :ref:`the image parameters <reference_params>`.

OpenNebula container can be deployed in the two major ways:

#. **single container deployment**
#. **multi-container deployment**

Single container
----------------

The single container deployment is a so called **all-in-one** deployment (all services are running inside a one container).

|image0|

.. note::

    Although despite being the most straightforward way how to run containerized OpenNebula - **this deployment is not recommended** for production use because it does not separate process groups and filesystems into isolated containers and therefore it loses some of the benefits.

Multiple containers
-------------------

The more preferable way is to deploy OpenNebula by the means of multiple containers with one container for each group of services.

This approach enables some form of concern separation and improves security. Not every process needs to have access to all secrets (tokens, passwords etc.) or a view at all the data.

To achieve the multi-container setup we can just execute series of ``docker run`` commands (crafted with proper arguments) with the same OpenNebula image **or** we can leverage **docker-compose** and the already prepared ``docker-compose.yml`` file (:ref:`explained below <deploy_multiple_containers>`).

OpenNebula provides the official ``docker-compose.yml`` and ``default.env`` file with parameter presets for every OpenNebula image version.

Multi-container deployment is then executed with a one simple ``docker-compose`` command.

|image1|

.. _install_container_runtime:

Step 1. Install Container Runtime
================================================================================

.. important::

    **SELinux** can block some operations initiated by the OpenNebula Front-end, which can result in failures. If the administrator isn't experienced in SELinux configuration, **it's recommended to disable this functionality to avoid unexpected failures**. You can enable SELinux anytime later when you have the installation working. How to do both is described in the :ref:`SELinux Appendix <appendix_selinux>`.

.. _install_docker:

Docker (recommended)
--------------------

The official installation instructions can be found on `Get Docker <https://docs.docker.com/get-docker/>`_ webpage.

Our OpenNebula image is supported for the following platforms:

- `Debian <https://docs.docker.com/engine/install/debian/>`_
- `Ubuntu <https://docs.docker.com/engine/install/ubuntu/>`_
- `CentOS <https://docs.docker.com/engine/install/centos/>`_

.. note:: If you encounter an issue with the latest Docker version or you need a specific version due to other reasons (like running some orchestrator - e.g. Kubernetes) then you can point to the desired version as is also described in the links above.

.. _install_docker_compose:

docker-compose
^^^^^^^^^^^^^^

To utilize microservices better we **strongly** recommend to install `docker-compose <https://docs.docker.com/compose/install/>`_ - for example the version ``1.27.4``:

.. prompt:: bash $ auto

    $ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    $ sudo chmod +x /usr/local/bin/docker-compose

.. _install_podman:

Podman
------

.. note:: Podman is currently supported only in CentOS/Fedora/RHEL distros.

Official instructions are here: https://podman.io/getting-started/installation

.. _install_podman_compose:

podman-compose
^^^^^^^^^^^^^^

To utilize microservices better we **strongly** recommend to install `podman-compose <https://github.com/containers/podman-compose>`_ - use the latest development version if possible:

.. prompt:: bash $ auto

    $ sudo curl -L "https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py" -o /usr/local/bin/podman-compose
    $ sudo chmod +x /usr/local/bin/podman-compose

.. note::

    All command snippets and shell examples will feature just the Docker variant. In almost all occurences though the same command should also work with Podman (just replace ``docker`` with ``podman`` or ``docker-compose`` with ``podman-compose``). For best experience we recommend to run Podman under a root user - it is possible to run Podman root-less (under unprivileged user) but some OpenNebula features will not work (mainly the Docker Hub marketplace).

    There will be comments in places where Podman or podman-compose diverge too much from Docker or when they lack certain features.

.. important::

    Please, bear in mind that Podman is much younger project and it did not reach a maturity comparable to Docker yet.

.. _setup_host:

Step 2. Prerequisites
================================================================================

.. important::

    The hypevisor nodes must be able to connect to the host address defined in ``OPENNEBULA_FRONTEND_SSH_HOST`` and the published SSH port of the ``sshd`` service - more on this below.

.. _setup_ssh:

OpenNebula SSH service
----------------------

OpenNebula Front-end's ``sshd`` service is both crucial for the nodes to connect to and problematic due to the standard SSH port (22) which will most likely conflict with the SSH service already running on the Front-end host machine.

This section tries to explain a few main workarounds.

1. Use designated IP address (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The conflicting SSH port can be avoided by simply not trying to bind the same port on the same (host) address.

You can assign the host a new different IP from either the same or a different subnet, e.g. ``192.168.10.2`` and use that address with the container deployment:

.. prompt:: bash $ auto

    $ docker run -d --privileged --name opennebula-custom \
    -p 192.168.10.2:80:80 \
    -p 192.168.10.2:443:443 \
    -p 192.168.10.2:22:22 \
    -p 192.168.10.2:29876:29876 \
    -p 192.168.10.2:2633:2633 \
    -p 192.168.10.2:5030:5030 \
    -p 192.168.10.2:2474:2474 \
    -p 192.168.10.2:4124:4124 \
    -p 192.168.10.2:4124:4124/udp \
    ...
    opennebula:5.13

How to configure a new IP address and relevant network routing is out-of-scope here - such setup is system-specific and we recommend to follow the official documentation of your operating system.

Regardless the way the new address is configured - we still need to tell the host's SSH daemon to not bind on that new address.

.. note::

    The default command-line text editor differs system from system but historically it is the ``vi``. Some users may prefer less intimidating tool. Whenever we will need to edit files - we will expect that environmental variable ``EDITOR`` is set by you or the command will fallback to ``vi`` again.

    .. prompt:: bash $ auto

        $ export EDITOR=/usr/bin/nano
        $ ${EDITOR:-vi} /some/config/file

Edit the sshd configuration file on the Front-end's host (you must have root privileges):

.. prompt:: bash $ auto

    $ sudo ${EDITOR:-vi} /etc/ssh/sshd_config

and set the intended listening addresses - e.g.:

.. code::

    ...
    ListenAddress 192.168.10.1
    ...

.. note::

    There can be more than one listening addresses but of course do not set the designated one (in our example: ``192.168.10.2``).

The SSH daemon must be restarted after the edit (change ``sshd`` to ``ssh`` or to a service name your system uses):

.. prompt:: bash $ auto

    $ sudo service sshd restart

2. Move host's SSH service to another port
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The most simple scenario is when the Front-end host's SSH daemon can be moved to another port.

The steps are almost identical as in the previous solution - we just have to change a different option inside the ``/etc/ssh/sshd_config``:

.. prompt:: bash $ auto

    $ sudo ${EDITOR:-vi} /etc/ssh/sshd_config

and set the port to something else - e.g. 2222:

.. code::

    ...
    Port 2222
    ...

.. note::

    Make sure that only one directive ``Port`` is set or uncommented.

.. important::

    If you are using SELinux then there may be an extra step:

        $ semanage port -a -t ssh_port_t -p tcp 2222

The SSH daemon must be again restarted after the edit (change ``sshd`` to ``ssh`` or to a service name your system uses):

.. prompt:: bash $ auto

    $ sudo service sshd restart

3. Configure SSH config on the nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If none of the above can be done then you must tweak oneadmin's SSH config on all :ref:`the hypervisor nodes <setup_nodes>`.

Firstly publish OpenNebula's SSH port on some non-conflicting port - e.g. 2222:

.. prompt:: bash $ auto

    $ docker run ... -p 2222:22 ... opennebula:5.13

.. note::

    Make sure that the value of ``OPENNEBULA_FRONTEND_SSH_HOST`` is resolvable correctly from the nodes.

The second step is to edit the ``~oneadmin/.ssh/config`` on the node(s) (replace ``OPENNEBULA_FRONTEND_SSH_HOST`` with the actual value) and add this stanza:

.. code::

    Host OPENNEBULA_FRONTEND_SSH_HOST
      StrictHostKeyChecking accept-new
      ServerAliveInterval 10
      #############################################################################
      # 'ControlMaster' is overriden by OpenNebula's drivers when needed
      ControlMaster no
      # The following options must be aligned with the accompanying timer/cronjob:
      # opennebula-ssh-socks-cleaner (if present) which implements workaround for
      # OpenSSH race condition during the closing of the master socket.
      #
      # 'ControlPersist' should be set to more than twice the period after which
      # timer or cronjob is run - to offset the delay - e.g.: timer job is run each
      # 30s then 'ControlPersist' should be at least one minute. It will also not
      # change the behavior even if it set much higher or to the infinity (0) - it
      # is limited by the timer/cronjob *AND* the command which is executed inside.
      #
      # (+) Add another 10s to give timer/cronjob a room for cleanup
      ControlPersist 70s
      # 'ControlPath' must be in-sync with the script run by timer/cronjob above!
      ControlPath /run/one/ssh-socks/ctl-M-%C.sock
      #
      # This will ensure the SSH connection to the OpenNebula container:
      Port 2222

.. _deploy_containers:

Step 3. Deploy container(s)
================================================================================

.. note::

    OpenNebula container image is built as a standard `OCI <https://opencontainers.org/>`_ image but there are differences and nuances between container runtimes. Each runtime can treat the same image slightly differently which can result in a failed start of container(s). OpenNebula image is made with compatibility in mind and so it should work under both **Docker** (the most popular container runtime) and **Podman** (the new daemon-less contender).

.. note::

    In this section we expect that OpenNebula image is either pulled to the local registry (e.g. ``/var/lib/docker``) or the correct URL is provided for the docker-compose.

The functionality of the OpenNebula container is controlled via :ref:`image parameters <reference_params>`. Their complete list is embedded in the image itself and can be extracted with a simple shell one-liner (in this case the image is named ``opennebula:5.13``):

.. prompt:: bash $ auto

    $ docker image inspect -f '{{ index .Config.Labels "org.label-schema.docker.params"}}' opennebula:5.13 | sed 's/, /\n/g'

.. _deploy_multiple_containers:

Multi-container deployment (recommended)
----------------------------------------

There is only one image for OpenNebula Front-end and therefore all things discussed in :ref:`the single container section <deploy_single_container>` still apply in multi-container deployment.

.. note::

    Even though the single-container deployment is not recommended as a serious/production path - we still advise you to read through it anyway just to get the overall understanding.

    It also fills some blank spots and describes a few gotcha's.

The difference is that one singular container with all running services is broken up into dozen of little containers each with its own portion of services (or one service) cooperating together - this is so called **microservice** pattern.

There is a special image parameter ``OPENNEBULA_FRONTEND_SERVICE`` for the OpenNebula Front-end container to know in which mode it should be running.

The official multi-container deployment consists of a few files and directories:

.. code::

    opennebula/
    ├── certs
    │   └── README.txt
    ├── config
    │   └── README.txt
    ├── custom.env
    ├── default.env
    ├── docker-compose.yml
    ├── .env
    ├── examples
    │   └── http-only.env
    └── ssh
        └── README.txt

+------------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| File                   | Customizable | Description                                                                                                                                |
+========================+==============+============================================================================================================================================+
| ``docker-compose.yml`` | NO           | Main deployment file for the docker-compose - it is provided by OpenNebula.                                                                |
+------------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| ``default.env``        | NO           | Contains all default values of :ref:`image parameters <reference_params>` - it is provided by OpenNebula.                                  |
+------------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| ``custom.env``         | YES          | This file is intended for the user to edit and it will override the ``default.env``.                                                       |
+------------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| ``.env``               | YES          | Similarly as with the ``custom.env`` but this file is for the customization of :ref:`the deploy parameters <reference_deploy_params>`.     |
+------------------------+--------------+--------------------------------------------------------------------------------------------------------------------------------------------+

Prepare deployment files
^^^^^^^^^^^^^^^^^^^^^^^^

Setup both the ``custom.env`` and ``.env`` to meet your needs based on your environment and requirements.

Let's start with the custom :ref:`image parameters <reference_params>`, e.g.:

.. code::

    # This is a custom environment file for the opennebula (frontend) image
    # (Settings here will override the values from the 'default.env' file)

    ###############################################################################
    # FEEL FREE TO EDIT THIS FILE TO FIT YOUR NEEDS!                              #
    ###############################################################################

    #
    # Custom image params / container(s) variables
    #

    # these two are the bare minimum for any successful deployment
    OPENNEBULA_FRONTEND_HOST=192.168.1.1
    OPENNEBULA_FRONTEND_SSH_HOST=192.168.1.1

    # other image parameters can be here:

.. important::

    Despite the risk of repeating ourselves - ``OPENNEBULA_FRONTEND_SSH_HOST`` must be resolvable by all the nodes and ``OPENNEBULA_FRONTEND_HOST`` must be resolvable by not only the nodes but also the client's browser (for Sunstone to work).

and ``.env`` with the custom :ref:`deploy parameters <reference_deploy_params>`, e.g.:

.. code::

    # This is the default (deploy) environment file for the docker-compose
    # (You can provide your own environment file via '--env-file' argument)

    ###############################################################################
    # FEEL FREE TO EDIT THIS FILE TO FIT YOUR NEEDS!                              #
    ###############################################################################

    #
    # Deploy variables for docker-compose
    #

    # container image
    DEPLOY_OPENNEBULA_REGISTRY=
    DEPLOY_OPENNEBULA_IMAGE_NAME=opennebula
    DEPLOY_OPENNEBULA_IMAGE_TAG=5.13

    # deployment-wide host address to which bind the published ports
    DEPLOY_BIND_ADDR=192.168.1.1
    DEPLOY_BIND_SSH_ADDR=192.168.1.1

    # other deploy parameters can be here:

.. important::

    The SSH port for the ``sshd`` service is published by default on the standard port (22) which would conflict with the host in most cases (as was commented in the :ref:`SSH service workarounds <setup_ssh>`) - that is why the ``DEPLOY_BIND_SSH_ADDR`` is crucial to setup to some designated IP otherwise it would default to ``0.0.0.0``.

    The other option would be to utilize ``DEPLOY_SSH_EXTERNAL_PORT`` and ssh config workaround.

.. important::

    Because some image parameters and deploy parameters must have equal values for the deployment to work properly - the OpenNebula's ``docker-compose.yml`` will ensure that if you change some deploy parameters then they will also set some image parameters:

    * ``DEPLOY_SUNSTONE_EXTERNAL_PORT`` -> ``SUNSTONE_PORT``
    * ``DEPLOY_SUNSTONE_EXTERNAL_TLS_PORT`` -> ``SUNSTONE_TLS_PORT``
    * ``DEPLOY_SUNSTONE_EXTERNAL_VNC_PORT`` -> ``SUNSTONE_VNC_PORT``
    * ``DEPLOY_ONEGATE_EXTERNAL_PORT`` -> ``ONEGATE_PORT``
    * ``DEPLOY_MONITORD_EXTERNAL_PORT`` -> ``MONITORD_PORT``

    So that means that you don't need to duplicate the value in the both ``.env`` and ``custom.env`` - just setup the ``.env`` with the deploy keys and all the depending image parameters will be automatically fixed (full disclosure: modifying the ``custom.env`` with these port variables would be ineffective - no change).

    The definitive rules are described in :ref:`the deploy parameters section <reference_deploy_params>`.

    This is one of the big differences with :ref:`the single container deployment <deploy_single_container>` where you have to take care of this nuisance manually.

Run docker-compose
^^^^^^^^^^^^^^^^^^

.. note::

    We must be inside the directory with the ``docker-compose.yml`` or use the ``--file`` argument.

After the proper preparation of both ``custom.env`` and ``.env`` we can deploy the containers:

.. prompt:: bash $ auto

    $ docker-compose up -d

.. note::

    The next command can be used in the case we are using modified docker-compose file named for example ``custom-docker-compose.yml`` and we also want to prefix the container names with ``custom``:

    .. prompt:: bash $ auto

        $ docker-compose up -d --file ./custom-docker-compose.yml --project-name custom

To monitor what is happening during :ref:`the bootstrap process <reference_bootstrap>` we could do (not supported by podman-compose):

.. prompt:: bash $ auto

    $ docker-compose logs -f

Stop docker-compose
^^^^^^^^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ docker-compose down

.. important::

    There is the ``always`` `restart policy <https://docs.docker.com/config/containers/start-containers-automatically/>`_ for each container in the ``docker-compose.yml`` which will ensure that container is always restarted when crashed and the whole deployment is automatically started on the reboot.

    If podman-compose is used then :ref:`extra steps <appendix_podman>` must be taken.

.. _deploy_single_container:

Single container (*all-in-one*)
-------------------------------

The most straightforward and simple way to run OpenNebula Front-end is within a one singular container. In such case all needed services are running together in the same process space and thus can communicate simply over localhost and local filesystem.

There is a long list of :ref:`image parameters <reference_params>` as was mentioned in :ref:`the introduction <deploy_containers>` to this chapter. These are either needed or they affect the container deployment in some meaningful way.

We don't need all of them though to deploy OpenNebula Front-end in full and with all features enabled (thanks to the defaults):

.. prompt:: bash $ auto

    $ docker run -d --privileged --restart=unless-stopped --name opennebula \
    -p 80:80 \
    -p 443:443 \
    -p 22:22 \
    -p 29876:29876 \
    -p 2633:2634 \
    -p 5030:5031 \
    -p 2474:2475 \
    -p 4124:4124 \
    -p 4124:4124/udp \
    -e OPENNEBULA_FRONTEND_HOST=${HOSTNAME} \
    -e OPENNEBULA_FRONTEND_SSH_HOST=${HOSTNAME} \
    -e ONEADMIN_PASSWORD=changeme123 \
    -e DIND_ENABLED=yes \
    -v opennebula_db:/var/lib/mysql \
    -v opennebula_datastores:/var/lib/one/datastores \
    -v opennebula_srv:/srv/one \
    -v opennebula_oneadmin_auth:/var/lib/one/.one \
    -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \
    -v opennebula_oneprovision_ssh:/var/lib/one/.ssh-oneprovision \
    -v opennebula_logs:/var/log \
    opennebula:5.13

.. note::

    Instead of the ``${HOSTNAME}`` use the fully qualified domain name or an IP.

You can monitor what is happening by:

.. prompt:: bash $ auto

    $ docker logs -f opennebula

.. note::

    If no problem occurred then in a moment you should get access to Sunstone on ``http://OPENNEBULA_FRONTEND_HOST`` - replace ``OPENNEBULA_FRONTEND_HOST`` with the actual value.

The command is easily deconstructed into the following semantic parts:

1. Docker run
^^^^^^^^^^^^^

.. code::

    $ docker run -d --privileged --restart=unless-stopped --name opennebula ...

The ``run`` argument of the Docker command (or Podman) will create a new container from the selected image (the very last part) and will start the execution of its `entrypoint <https://docs.docker.com/engine/reference/builder/#entrypoint>`_.

The options are shortly described as follows:

* ``-d`` - Detach the container from the terminal (basically it will execute in the background).
* ``--privileged`` - Potentially dangerous option because it will give the container more rights and permissions than normally a container would need. In our case it is needed for Docker Hub marketplace to work - if this function is not needed then this unsafe option can be dropped.
* ``--restart=unless-stopped`` - `Restart policy <https://docs.docker.com/config/containers/start-containers-automatically/>`_ which will ensure that container is always restarted when crashed and automatically started on reboot |_| [*]_.
* ``--name`` - Simply assign an explicit name to the container which can be referenced by.

.. [*] Start on boot is working only in Docker - how to simulate this behavior with Podman is described in :ref:`the Podman appendix <appendix_podman>`.

2. Published ports
^^^^^^^^^^^^^^^^^^

.. code::

    -p 80:80
    -p 443:443
    -p 22:22
    -p 29876:29876
    -p 2633:2634
    -p 5030:5031
    -p 2474:2475
    -p 4124:4124
    -p 4124:4124/udp

These arguments will expose the internal network port (number on the right ) where the service is actually listening inside the container. It will be accessible via its external port (number on the left) on the host.

There may be a need to change one or more of these ports to not either conflict with already running service on the host or using higher number (greater than 1024) for unprivileged users.

.. important::

    The published ports can conflict with other services on the host - in that case change the left portion of the ``-p`` argument - although in some cases you must also change the port number on the right and on top of that add a few more parameters. This is discussed in the more detail under :ref:`the ports reference <reference_ports>`.

    The biggest hurdle could be SSH (22) because the majority of the hosts will have their own SSH daemon listening on that port. Unfortunately OpenNebula (as of yet) does not support natively frontend's SSH access on different than standard port. The workarounds for this are described in :ref:`the OpenNebula SSH service prerequisite <setup_ssh>`.

.. important::

    The ``docker run`` above will enable TLS and HTTPS (it's a default). OpenNebula's APIs (oned, OneFlow, OneGate) are also published over HTTPS. Internally (in the container) these APIs are reachable over both ports (HTTP and HTTPS) when ``TLS_PROXY_ENABLED`` is set to true (that is the default) - what actual port is published is for the user to decide.

    We chose to publish only the HTTPS variant but we could choose HTTP - to change that you must decrement the port number on the right by one to look like this:

    * ``-p 2633:2633``
    * ``-p 5030:5030``
    * ``-p 2474:2474``

    or publish over different ports entirely to have access to both HTTP and HTTPS:

    * ``-p 2633:2634`` - oned/HTTPS
    * ``-p 5030:5031`` - gate/HTTPS
    * ``-p 2474:2475`` - flow/HTTPS
    * ``-p 12633:2633`` - oned/HTTP
    * ``-p 15030:5030`` - gate/HTTP
    * ``-p 12474:2474`` - flow/HTTP

.. important::

    We **strongly** recommend to leave the port numbers intact and instead publish them on a designated IP (e.g. ``192.168.1.1``) like so:

    .. code::

        -p 192.168.1.1:80:80
        -p 192.168.1.1:443:443
        -p 192.168.1.1:22:22
        -p 192.168.1.1:29876:29876
        -p 192.168.1.1:2633:2634
        -p 192.168.1.1:5030:5031
        -p 192.168.1.1:2474:2475
        -p 192.168.1.1:4124:4124
        -p 192.168.1.1:4124:4124/udp

    This way all the headaches with the conflicting ports and SSH is effectively eliminated.

More info can be found in :ref:`the table describing exposed ports <reference_ports>`.

3. Environment variables (image parameters)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

    -e OPENNEBULA_FRONTEND_HOST=${HOSTNAME}
    -e OPENNEBULA_FRONTEND_SSH_HOST=${HOSTNAME}
    -e ONEADMIN_PASSWORD=changeme123
    -e DIND_ENABLED=yes

* ``OPENNEBULA_FRONTEND_HOST`` must be an address on the host which is resolvable from the nodes.
* ``OPENNEBULA_FRONTEND_SSH_HOST`` must be an address (they can be identical) on the host which is resolvable not only from the nodes but **from within the containers too**.
* ``ONEADMIN_PASSWORD`` is one-time setup of oneadmin's password (the same is used for web login via Sunstone).
* ``DIND_ENABLED`` will enable Docker-in-Docker - the prerequisite is the ``--privileged`` argument.

.. important::

    ``${HOSTNAME}`` is just a placeholder which you should replace with a valid fully qualified domain name or a designated IP.

There are more parameters which can be used with the single container deployment.

All are described in :ref:`the image parameters table <reference_params>`.

4. Volumes (persistent storage)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

    -v opennebula_db:/var/lib/mysql
    -v opennebula_datastores:/var/lib/one/datastores
    -v opennebula_srv:/srv/one
    -v opennebula_oneadmin_auth:/var/lib/one/.one
    -v opennebula_oneadmin_ssh:/var/lib/one/.ssh
    -v opennebula_oneprovision_ssh:/var/lib/one/.ssh-oneprovision \
    -v opennebula_logs:/var/log

There could be used more fine grained volumes as is implemented in the official ``docker-compose.yml`` but this volume list covers all important data which must survive container's restart.

In this volume section we could utilize our custom SSH key and TLS certificate which will also require setup of certain :ref:`image parameters <reference_params>`.

Let us setup two directories on the host:

* ``/custom/hostpath/ssh`` with the (passphrase-less) SSH private key ``id_rsa`` and public key ``id_rsa.pub``.
* ``/custom/hostpath/certs`` with the TLS certificate ``cert.pem`` and private key ``cert.key``.

Then we could instruct the OpenNebula image with the extra arguments:

* ``-v /custom/hostpath/ssh:/ssh:z,ro`` bindmounts (read-only) the content of the directory on the left to the container under ``/ssh``.
* ``-v /custom/hostpath/certs:/certs:z,ro`` similarly bindmounts the TLS certificate directory inside the container under ``/certs``.
* ``-e ONEADMIN_SSH_PRIVKEY=/ssh/id_rsa`` tells the container that it should use the exposed SSH private key inside the bindmounted directory.
* ``-e ONEADMIN_SSH_PUBKEY=/ssh/id_rsa.pub`` tells the same for the public SSH key.
* ``-e TLS_CERT=/certs/cert.pem`` instructs the container where to find the TLS certificate.
* ``-e TLS_KEY=/certs/cert.key`` works the same for the TLS certificate key.

.. note::

    Instead of bindmounting directories for the SSH key or the TLS certificate - we could just use image parameters with base64 encoded values:

    .. code::

        ONEADMIN_SSH_PRIVKEY_BASE64
        ONEADMIN_SSH_PUBKEY_BASE64
        TLS_KEY_BASE64
        TLS_CERT_BASE64

All significant directories and potential volume candidates are described in :ref:`the volume table <reference_volumes>`.

.. note::

    Not all canonical volumes from the reference table are meaningful for the single container deployment - mainly those **shared** could be ignored because there is no other container to share data with.

5. OpenNebula image
^^^^^^^^^^^^^^^^^^^

The last part is just the name of the image which can be qualified with registry URL or a custom name or a tag.

* ``opennebula:5.13``

More examples
^^^^^^^^^^^^^

More single container deployments can be seen in the :ref:`Single container examples appendix <appendix_single_container_examples>`.

.. _setup_nodes:

Step 4. Add node(s)
================================================================================

Installation of the hypervisor node is done the same way as with the normal non-containerized deployment.

How to setup one is described in `the OpenNebula documentation <https://docs.opennebula.io/stable/deployment/node_installation/index.html>`_.

.. important::

    The hypevisor nodes must be able to connect to the host address defined in ``OPENNEBULA_FRONTEND_SSH_HOST`` and the published SSH port of the ``sshd`` service.

    Using the IP address should be the most problem-free approach but if a dns name is used and there is a misconfigured DNS in your network then you could workaround this by fixing the ``/etc/hosts`` file on each hypervisor node.

    If the OneGate/OneFlow functionality is desired then the node must also be able to connect to the ``OPENNEBULA_FRONTEND_HOST`` on the ``ONEGATE_PORT``.

.. _image_update:

Image update
================================================================================

Once is OpenNebula image downloaded and in the local filesystem it will not automatically check for a new version or update itself - but this can be done manually by simple ``docker pull``:

.. prompt:: bash $ auto

    $ docker pull https://docker.opennebula.io/opennebula:5.13 # TODO

After this command the local version of the image with the same name and tag will be updated.

The next step is to stop/delete the already running container using the same image (but with different digest) and creating a new container with the exactly same command. This time it will use the newer image.

.. note::

    The precondition here is that the used image name is always the one and the same in all the commands.

.. important::

    Thanks to the **onedb** upgrade feature the database should be automatically migrated to the new OpenNebula version. So no extra work is required.

docker-compose
--------------

If the docker-compose is used then the following sequence should be enough to update all images and start them again:

.. prompt:: bash $ auto

    $ docker-compose down && docker-compose pull && docker-compose up -d

.. _troubleshooting:

Troubleshooting
================================================================================

Container output
----------------

First place to look for problems should be the standard output of the containers:

.. prompt:: bash $ auto

    $ docker logs -f opennebula

docker-compose
^^^^^^^^^^^^^^

.. note::

    Beware that ``podman-compose`` may miss some of the mentioned functionality in this section.

Realtime tailing of all the service output messages:

.. prompt:: bash $ auto

    $ docker-compose logs -f

or checking only one container we are interested in (``opennebula-oned``):

.. prompt:: bash $ auto

    $ docker-compose logs -f opennebula-oned

Logs and inside view
--------------------

The most helpful debugging tool is to investigate the container from within:

.. prompt:: bash $ auto

    $ docker exec -it opennebula /bin/bash

This of course works with the docker-compose too - you just must use the proper name (or digest):

.. prompt:: bash $ auto

    $ docker exec -it opennebula_opennebula-oned_1 /bin/bash

Logs
^^^^

All the log files are located in ``/var/log`` as one would expect. Although there are two the most significant places where to look for information:

* ``/var/log/one/``
* ``/var/log/supervisor/services/``

One could do the following to not miss anything important while debugging an issue (inside the container):

.. prompt:: bash $ auto

    $ tail -f /var/log/one/* /var/log/supervisor/services/*

Maintenance mode
----------------

Sometimes the problem solving will require more of a hands-on approach and for this situation OpenNebula container supports the maintenance mode.

Maintenance mode is enabled when ``MAINTENANCE_MODE`` parameter is set to true (e.g.: ``yes``) and it will affect :ref:`the bootstrap process <reference_bootstrap>` slightly.

Startup of the container proceed as normal with one exception - at the end of the bootstrap right before the execution is passed to ``supervisord`` - **all** internal services are disabled on start.

This means that configuration files are modified, changes done by hook scripts are implemented and every supervised services is prepared but not started.

.. note::

    Maintenance mode is not intended for long-term run so ``-d|--detach`` is optional and ``-it`` could be used instead to drop directly into the container.

.. important::

    Maintenance mode has little of use if no volume is used - **use the same named volumes as in the normal run**.

Run the container as usual but add the ``MAINTENANCE_MODE`` parameter:

.. prompt:: bash $ auto

    $ docker run -d ... -e MAINTENANCE_MODE=yes ... --name opennebula opennebula:5.13

Enter the container:

.. prompt:: bash $ auto

    $ docker exec -it opennebula /bin/bash

And check the status of Supervisor:

.. prompt:: bash $ auto

    $ supervisorctl status

.. note::

    There should be only one running service: ``infinite-loop``

You could for example start the MySQL service and fix some database records before stopping the service and container.

After your work is done and problem solved you can stop and delete the container:

.. prompt:: bash $ auto

    $ docker stop opennebula
    $ docker rm opennebula

Now you can start the container the usual way without the ``MAINTENANCE_MODE`` parameter.

Miscellaneous
-------------

Sunstone login is failing
^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes can happen that login into Sunstone will fail even when the deployment seems to be correct. There will be no visible message on the webpage nor any helpful error in the logs.

This can happen when we already **did** successfully login some other time before and **a cookie** was created. It happens quite regulerly while switching the deployment between HTTP and HTTPS.

Simple fix is to just delete the cookie in the browser and try to login again.

Container refuses to start
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes a similar error message can pop up:

.. code::

    docker: Error response from daemon: Conflict. The container name "/opennebula" is already in use by container "93c5ebf71aa39eb66d5df0c1962d024456ddff6435c030d694aec78c6989bbc6". You have to remove (or rename) that container to be able to reuse that name.
    See 'docker run --help'.

The message is actually clear about what is the problem.

User is trying to start a **new** container with the same name as the other container which was already created.

This happens a lot when container is stopped:

.. prompt:: bash $ auto

    $ docker stop opennebula

And user is trying to *start* it again but with the ``docker run`` command.

Depending on what is the goal you can either delete the previous container:

.. prompt:: bash $ auto

    $ docker rm opennebula

and run the new with presumably changed arguments (volumes, variables, ports etc.):

.. prompt:: bash $ auto

    $ docker run ... --name opennebula opennebula:5.13

or if you don't need to modify the container at all - just start it again:

.. prompt:: bash $ auto

    $ docker start opennebula

Managing terminated containers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the container is stopped or terminated (e.g. crashed) then the container's filesystem state will still be stored on the disc.

If the user is not naming the containers with the ``--name`` argument - these containers will not clash (as error message above) and their number will build up over time.

This is the command to list them all:

.. prompt:: bash $ auto

    $ docker ps -a

Now you can pick the one you wish to not have anymore and delete them:

.. prompt:: bash $ auto

    $ docker rm opennebula

You could also trigger the automatic deletion on the container termination with the ``--rm`` argument.

.. _reference:

Reference
================================================================================

.. _reference_bootstrap:

Bootstrap process
-----------------

There must be an executable which is started when container is instantiated. The actual binary or script is defined as so called `entrypoint <https://docs.docker.com/engine/reference/builder/#entrypoint>`_. The entrypoint is then fully responsible for the whole application logic. It *usually* becomes the first process inside the container and therefore has PID 1. In our case the entrypoint is actually started by the init wrapper which will properly handle signals and will reap zombie processes.

The entrypoint for the OpenNebula Front-end image is a shell script called ``frontend-bootstrap.sh`` located directly under the root directory (``/`` not the root user's home directory).

.. code::

    ENTRYPOINT [ "/frontend-bootstrap.sh" ]

Once the bootstrap script is finished with all the configuration and preparation of the container it will replace itself with the `Supervisor <http://supervisord.org/>`_ service manager and relay the execution to its process ``supervisord``. The exception being an error encountered anywhere during the bootstrap which will force the entrypoint to abort and container to fail.

|image2|

The bootstrap script is generally executing the following steps:

#. Setup trap and cleanup functions
#. Apply custom onecfg patch (``OPENNEBULA_FRONTEND_ONECFG_PATCH``) if provided (**optional**)
#. Execute pre-bootstrap script (``OPENNEBULA_FRONTEND_PREHOOK``) if provided (**optional**)
#. Prepare the rootfs (create and cleanup operational directories)
#. Fix file permissions for the :ref:`significant paths (potential volumes) <reference_volumes>`
#. Configure the :ref:`Supervisor daemon <reference_supervisord>`
#. Configure and enable all services based on the value of ``OPENNEBULA_FRONTEND_SERVICE``
#. Execute post-bootstrap script (``OPENNEBULA_FRONTEND_POSTHOOK``) if provided (**optional**)
#. If the maintenance mode is required (``MAINTENANCE_MODE``) then turn off the autostart of supervised services (**optional**)
#. Exit and pass the execution to the **supervisord process** (which will govern the lifetime of the services from now on)

The :ref:`image parameters <reference_params>` affect the bootstrap process and determines what service and how they are deployed inside the container(s).

.. _reference_ports:

Exposed ports
-------------

Internal ports which are designed to be exposed to the host or overlay network.

+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| Port      | Protocol | Service [*]_           |                     Description                                                                                       |
+===========+==========+========================+=======================================================================================================================+
| ``22``    | TCP      | ``sshd``               | SSH access to OpenNebula Front-end.                                                                                   |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``80``    | TCP      | ``sunstone``           | Sunstone server (HTTP) - automatically redirected to HTTPS (if HTTPS is enabled: ``SUNSTONE_HTTPS_ENABLED=yes``)      |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``443``   | TCP      | ``sunstone``           | Sunstone server (HTTPS) - can be disabled.                                                                            |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2474``  | TCP      | ``oneflow``            | OneFlow server.                                                                                                       |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2475``  | TCP      | ``oneflow``            | OneFlow server over HTTPS (if TLS proxy enabled: ``TLS_PROXY_ENABLED=yes``).                                          |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2633``  | TCP      | ``oned``               | OpenNebula daemon, main XML-RPC API endpoint.                                                                         |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2634``  | TCP      | ``oned``               | OpenNebula daemon over HTTPS (if TLS proxy enabled: ``TLS_PROXY_ENABLED=yes``), main XML-RPC API endpoint.            |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``4124``  | TCP      | ``oned``               | Monitord server, collector of the monitoring messages from the nodes.                                                 |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``4124``  | UDP      | ``oned``               | Monitord server, UDP access.                                                                                          |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``5030``  | TCP      | ``onegate``            | OneGate server.                                                                                                       |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``5031``  | TCP      | ``onegate``            | OneGate server over HTTPS (if TLS proxy enabled: ``TLS_PROXY_ENABLED=yes``).                                          |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``29876`` | TCP      | ``sunstone``           | VNC proxy port, used for translating and redirecting VNC connections to the hypervisors.                              |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+

.. [*] Service as in the value of ``OPENNEBULA_FRONTEND_SERVICE``

.. important::

    It is important to distinguish the difference between the internal port (as in the table) and external (published) ports - majority of the internal ports are hardwired and cannot be moved to another port number (exceptions are in the next info box).

    If one wants to avoid port conflicts with the already bound ports on the host then change to the external (published) port is needed. In a few cases the container itself also must be informed about the changes and a relevant image parameter thus must reflect the same value.

.. note::

    The following table showcases how to utilize different ports for different services. Notice that in the case of **monitord** and **Sunstone VNC** both sides of expression must be modified not just the left (published) portion.

+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| Port mapping examples  | Affected Parameter |_| / |_| Service           |                     Note                                                                                                                  |
+========================+================================================+===========================================================================================================================================+
| ``-p 2222:22``         |                                                | Change to the SSH port has consequences which are described in :ref:`the SSH service prerequisite <setup_ssh>`.                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 8080:80``         | ``SUNSTONE_PORT / sunstone``                   | Sunstone port (HTTP) - ``SUNSTONE_PORT=8080``                                                                                             |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 4443:443``        | ``SUNSTONE_TLS_PORT / sunstone``               | Sunstone port (HTTPS) - ``SUNSTONE_TLS_PORT=4443``                                                                                        |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 12474:2474``      |                                                | OneFlow port - no image parameter is needed to set but :ref:`OpenNebula CLI tools <appendix_opennebula_cli>` must be configured properly. |
+------------------------+------------------------------------------------+                                                                                                                                           +
| ``-p 12474:2475``      |                                                |                                                                                                                                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 12633:2633``      |                                                | OpenNebula main API port - only the :ref:`OpenNebula CLI tools <appendix_opennebula_cli>` need to be configured.                          |
+------------------------+------------------------------------------------+                                                                                                                                           +
| ``-p 12633:2634``      |                                                |                                                                                                                                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 14124:14124``     |  ``MONITORD_PORT / oned``                      | Monitord port (affects both TCP and UDP) - ``MONITORD_PORT=14124`` - **BEWARE that both external/internal port must be set**.             |
+------------------------+                                                +                                                                                                                                           +
| ``-p 14124:14124/udp`` |                                                |                                                                                                                                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 15030:5030``      | ``ONEGATE_PORT / oned``                        | OneGate port - ``ONEGATE_PORT=15030`` (it's a parameter for ``oned`` service/container **not** the ``onegate``!)                          |
+------------------------+                                                +                                                                                                                                           +
| ``-p 15030:5031``      |                                                |                                                                                                                                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 30000:30000``     | ``SUNSTONE_VNC_PORT / sunstone``               | VNC port - ``SUNSTONE_VNC_PORT`` - **BEWARE that both external/internal port must be set**.                                               |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+

.. _reference_params:

Image parameters
----------------

Environmental variables relayed to the container which modify the bootstrap process and consequently the container's runtime.

+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                | Required |_| [*]_ |_|  | Default                  |                     Description                                                                                          |
+======================================+========================+==========================+==========================================================================================================================+
| ``MAINTENANCE_MODE``                 | NO (all)               | ``no``                   | Boolean option for starting the container in the maintenance mode - service is bootstrapped but not started.             |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_SERVICE``      | YES (all) |_| [*]_     | ``all``                  | Front-end service to run inside the container - proper values are listed here:                                           |
|                                      |                        |                          |                                                                                                                          |
|                                      |                        |                          | - ``all`` - run all services (all-in-one deployment) - this is the default value                                         |
|                                      |                        |                          | - ``docker`` - Docker in Docker - needed for Docker Hub marketplace (requires ``--privileged`` option)                   |
|                                      |                        |                          | - ``fireedge`` - Fireedge service to proxy VMRC, Guacemole (VM console) and access the OneProvision                      |
|                                      |                        |                          | - ``guacd`` - Guacemole proxy providing access to the VM console (along the regular VNC)                                 |
|                                      |                        |                          | - ``memcached`` - memcached service required by Sunstone web server                                                      |
|                                      |                        |                          | - ``mysqld`` - database server backend for the oned service                                                              |
|                                      |                        |                          | - ``none`` - No service will be bootstrapped and started - container will be running dummy noop process                  |
|                                      |                        |                          | - ``oned`` - OpenNebula daemon providing the main API (requires ``SYS_ADMIN`` capability)                                |
|                                      |                        |                          | - ``oneflow`` - OneFlow service                                                                                          |
|                                      |                        |                          | - ``onegate`` - OneGate service                                                                                          |
|                                      |                        |                          | - ``oneprovision`` - OneProvision where all provision related commands are executed and provisioned SSH keys accessed    |
|                                      |                        |                          | - ``scheduler`` - OpenNebula scheduler needed by oned                                                                    |
|                                      |                        |                          | - ``sshd`` - SSH daemon to which nodes will connect to                                                                   |
|                                      |                        |                          | - ``sunstone`` - Sunstone web server                                                                                     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_HOST``         | YES:                   |                          | Host (DNS domain, IP address) which will be advertised as the Front-end endpoint (oned).                                 |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``all``              |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_SSH_HOST``     | YES:                   |                          | Host (DNS domain, IP address) which will be advertised as the SSH endpoint (sshd) to which nodes will connect to.        |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``all``              |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_ONECFG_PATCH`` | NO (all)               |                          | Path within the container to the custom patch file which will be passed to the onecfg command (**before pre-hook**).     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_PREHOOK``      | NO (all)               |                          | Path within the container to the custom file which will be executed **before** the bootstrap is started.                 |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_FRONTEND_POSTHOOK``     | NO (all)               |                          | Path within the container to the custom file which will be executed **after** the bootstrap is started.                  |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONED_DB_BACKUP_ENABLED``           | NO:                    | ``yes``                  | Enable database backup before the upgrade (it will run sqldump and store the backup in ``/var/lib/one/backups``).        |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MONITORD_PORT`` [*]_               | NO:                    | ``4124``                 | **Published/exposed and internal** Monitord port (TCP and UDP).                                                          |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEGATE_PORT``                     | NO:                    | ``5030``                 | Advertised port where OneGate service is published (the host portion is defined by ``OPENNEBULA_FRONTEND_HOST``)         |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_HTTPS_ENABLED``           | NO:                    | ``yes``                  | Enable HTTPS access to the Sunstone server (it will generate self-signed certificate if none is provided).               |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_PORT``                    |                        | ``80``                   | **Published/exposed** Sunstone HTTP port (pointing to the internal HTTP).                                                |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_TLS_PORT``                |                        | ``443``                  | **Published/exposed** Sunstone HTTPS port (pointing to the internal HTTPS).                                              |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_VNC_PORT`` [*]_           |                        | ``29876``                | **Published/exposed and internal** Sunstone VNC port (pointing to the internal VNC).                                     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_PROXY_ENABLED``                | NO:                    | ``yes``                  | Enable TLS proxy (via stunnel) to all OpenNebula APIs (it will generate self-signed certificate if none is provided).    |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
|                                      | - ``oneflow``          |                          |                                                                                                                          |
|                                      | - ``onegate``          |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_DOMAIN_LIST``                  |                        | ``*``                    | List of DNS names separated by spaces (asterisk allowed)                                                                 |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_VALID_DAYS``                   |                        | ``365``                  | Amount of valid days before the generated self-signed certificate will expire.                                           |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_KEY_BASE64``                   |                        |                          | Private key portion of the custom certificate in base64 format.                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_CERT_BASE64``                  |                        |                          | Custom certificate (public portion) in base64 format.                                                                    |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_KEY``                          |                        |                          | Path within the container to the private key portion of the custom certificate.                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_CERT``                         |                        |                          | Path within the container to the custom ceritificate (public portion).                                                   |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_PASSWORD``                | NO:                    |                          | Oneadmin's initial password or it will be randomly generated (only once) and stored in ``/var/lib/one/.one/one_auth``).  |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PRIVKEY_BASE64``      |                        |                          | Custom SSH key (private portion) in base64 format.                                                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PUBKEY_BASE64``       |                        |                          | Custom SSH key (public portion) in base64 format.                                                                        |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PRIVKEY``             |                        | ``/ssh/id_rsa``          | Path within the container to the custom SSH key (private portion).                                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PUBKEY``              |                        | ``/ssh/id_rsa.pub``      | Path within the container to the custom SSH key (public portion).                                                        |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_ENABLED``                     | NO:                    | ``no``                   | Enable Docker service (*Docker-in-Docker*) - requires ``--privileged`` option (or adequate list of capabilities).        |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``docker``           |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_PORT``                       | NO:                    | ``3306``                 | Port on which MySQL service will be listening and accessible from.                                                       |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``mysqld``           |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_DATABASE``                   |                        | ``opennebula``           | Name of the OpenNebula's database stored in the MySQL server (it will be created).                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_USER``                       |                        | ``oneadmin``             | User allowed to access the OpenNebula's database (it will be created).                                                   |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_PASSWORD``                   | YES |_| [*]_:          |                          | User's database password otherwise it will be randomly generated in the case of *all-in-one* deployment (only once).     |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``mysqld``           |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_ROOT_PASSWORD``              | NO:                    |                          | MySQL root password for the first time setup otherwise it will be randomly generated (only once).                        |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``mysqld``           |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_FRONTEND_SERVICE``. Regardless of YES/NO - only the listed services are actually affected by the parameter (otherwise all are affected).
.. [*] ``OPENNEBULA_FRONTEND_SERVICE`` must be defined every time if it is intended as multi-container setup otherwise it defaults to ``all`` and therefore will start *all-in-one* deployment in each container...
.. [*] ``MONITORD_PORT`` must also match the internal port - it is an implementation detail which will require to change both the external (published) and internal port.
.. [*] ``SUNSTONE_VNC_PORT`` must also match the internal port - it is an implementation detail which will require to change both the external (published) and internal port.
.. [*] ``MYSQL_PASSWORD`` is not required when deployed in single container (*all-in-one*).

.. note::

    The next table describes another set of image parameters but their usability is only in multi-container deployment for which OpenNebula provides proper ``docker-compose.yml`` and ``default.env``.

    They are listed here only for completeness and for users determined to replace some of our containers with their own servers (custom MySQL, host dockerd etc.).

+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                | Required |_| [*]_      | Default                  |                     Description |_| [*]_                                                                                 |
+======================================+========================+==========================+==========================================================================================================================+
| ``DIND_TCP_ENABLED``                 | NO:                    | ``no``                   | Enable access to the Docker daemon via TCP (needed for Docker to work in multi-container setup).                         |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``docker``           |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_HOST``                        |                        | ``localhost``            | Container host where Docker service is running.                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_SOCKET``                      |                        | ``/var/run/docker.sock`` | Configurable path of the Docker socket for the Docker inside the container.                                              |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``FIREEDGE_HOST``                    | YES:                   | ``localhost``            | Container host where Fireedge service is running.                                                                        |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``GUACD_HOST``                       | YES:                   | ``localhost``            | Container host where guacd service is running.                                                                           |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``fireedge``         |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_HOST``                       | YES:                   | ``localhost``            | Container host where MySQL service is running.                                                                           |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``mysqld``           |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MEMCACHED_HOST``                   | YES:                   | ``localhost``            | Container host where memcached service is running.                                                                       |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONED_HOST``                        | YES:                   | ``localhost``            | Container host where oned service is running.                                                                            |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``oned``             |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
|                                      | - ``fireedge``         |                          |                                                                                                                          |
|                                      | - ``scheduler``        |                          |                                                                                                                          |
|                                      | - ``oneflow``          |                          |                                                                                                                          |
|                                      | - ``onegate``          |                          |                                                                                                                          |
|                                      | - ``oneprovision``     |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEFLOW_HOST``                     | YES:                   | ``localhost``            | Container host where OneFlow service is running.                                                                         |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``sunstone``         |                          |                                                                                                                          |
|                                      | - ``fireedge``         |                          |                                                                                                                          |
|                                      | - ``onegate``          |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEPROVISION_HOST``                | YES:                   | ``localhost``            | Container host for OneProvision with SSH keys.                                                                           |
|                                      |                        |                          |                                                                                                                          |
|                                      | - ``fireedge``         |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_FRONTEND_SERVICE``. Regardless of YES/NO - only the listed services are actually affected by the parameter (otherwise all are affected).
.. [*] Avoid the usage of an IP address, they are dynamically assigned in most cases.

.. _reference_volumes:

Volumes and data
----------------

OpenNebula image has defined implicit (anonymous) volumes and so every time a container is instantiated from the image a few unnamed volumes will be created holding the container's data. This is done as a precaution to losing important runtime data in the case someone realizes too late that container is running without assigned persistent storage.

.. important::

    Once the running container is removed (``docker rm`` or started with ``--rm``) these implicit volumes may be automatically deleted too!

    **ALWAYS USE NAMED VOLUMES!**

    Usage of containers tend to create a lot of implicit (anonymous) volumes - we can check them with the command:

    .. prompt:: bash $ auto

        $ docker volume ls

    If we are sure that no data can be lost because we use only named volumes then periodic cleanup can be done like this:

    .. prompt:: bash $ auto

        $ docker volume prune -f

.. note::

    In the table below are described crucial directories which are either implicit volumes, should be used as named volumes or are otherwise significant.

+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| Canonical |_| volume |_| name |_| [*]_          | Directory |_| path                      | Implicit                | Used |_| by                        |  Description                                                                                        |
+=================================================+=========================================+=========================+====================================+=====================================================================================================+
| ``opennebula_mysql``                            | ``/var/lib/mysql``                      | YES                     | - ``mysqld``                       |  Database directory with MySQL data.                                                                |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/var/lib/one/backups``                | YES                     |                                    |  OpenNebula stores backup files into this location.                                                 |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_backups_db``                       | ``/var/lib/one/backups/db``             | NO                      |                                    |  OpenNebula stores here sqldumps during ``onedb upgrade``.                                          |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_datastores``                       | ``/var/lib/one/datastores``             | YES                     | - ``oned``                         |  OpenNebula's datastore for VM images.                                                              |
|                                                 |                                         |                         | - ``sshd``                         |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_shared_vmrc``                      | ``/var/lib/one/sunstone_vmrc_tokens``   | NO                      |                                    |  Shared directory between Sunstone and Fireedge with temporary files.                               |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_auth``                    | ``/var/lib/one/.one``                   | YES                     | - ``oned``                         |  Oneadmin's secret OpenNebula tokens.                                                               |
|                                                 |                                         |                         | - ``scheduler``                    |                                                                                                     |
|                                                 |                                         |                         | - ``oneflow``                      |                                                                                                     |
|                                                 |                                         |                         | - ``onegate``                      |                                                                                                     |
|                                                 |                                         |                         | - ``sunstone``                     |                                                                                                     |
|                                                 |                                         |                         | - ``fireedge``                     |                                                                                                     |
|                                                 |                                         |                         | - ``oneprovision``                 |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_ssh``                     | ``/var/lib/one/.ssh``                   | YES                     | - ``oned``                         |  Oneadmin's SSH directory.                                                                          |
+-------------------------------------------------+                                         +                         +------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_ssh_provision``           |                                         |                         | - ``oneprovision``                 |  SSH directory used only for connections between Fireedge and OneProvision containers.              |
|                                                 |                                         |                         | - ``fireedge``                     |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_ssh_copyback`` |_| [*]_   | ``/var/lib/one/.ssh-copyback``          | YES                     | - ``oned``                         |  SSH directory for **sshd** service - initialized with oneadmin's public SSH key.                   |
|                                                 |                                         |                         | - ``sshd``                         |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneprovision_ssh``                 | ``/var/lib/one/.ssh-oneprovision``      | YES                     | - ``oneprovision``                 |  Contains SSH key-pair for OneProvision.                                                            |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/var/log``                            | YES                     |                                    |  All system logs (**not recommended to share named volume with this location between containers**). |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_logs``                             | ``/var/log/one``                        | NO                      | - ``oned``                         |  All OpenNebula logs (**this should be a named volume shared between all OpenNebula services**)     |
|                                                 |                                         |                         | - ``scheduler``                    |                                                                                                     |
|                                                 |                                         |                         | - ``oneflow``                      |                                                                                                     |
|                                                 |                                         |                         | - ``onegate``                      |                                                                                                     |
|                                                 |                                         |                         | - ``sunstone``                     |                                                                                                     |
|                                                 |                                         |                         | - ``fireedge``                     |                                                                                                     |
|                                                 |                                         |                         | - ``oneprovision``                 |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_shared_tmp``                       | ``/var/tmp/sunstone``                   | NO                      | - ``oned``                         |  Shared directory between oned and Sunstone needed to be upload local images through browser.       |
|                                                 |                                         |                         | - ``sunstone``                     |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/srv/one``                            | YES                     |                                    |  Parent directory for various persistent data.                                                      |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_secret_db``                        | ``/srv/one/secret-db``                  | NO                      | - ``mysqld``                       |  Stores MySQL passwords.                                                                            |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_secret_tls``                       | ``/srv/one/secret-tls``                 | NO                      | - ``oned``                         |  TLS certificate (provided or generated) is stored here.                                            |
|                                                 |                                         |                         | - ``sshd``                         |                                                                                                     |
|                                                 |                                         |                         | - ``oneflow``                      |                                                                                                     |
|                                                 |                                         |                         | - ``onegate``                      |                                                                                                     |
|                                                 |                                         |                         | - ``sunstone``                     |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_secret_sshd``                      | ``/srv/one/secret-sshd``                | NO                      | - ``oneprovision``                 |  SSH host keys for the sshd service (also oneprivision).                                            |
|                                                 |                                         |                         | - ``sshd``                         |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+

.. [*] These volume names and mountpoints are recommended to use - the very same are utilized in the referential :ref:`docker-compose deployment <deploy_multiple_containers>`.
.. [*] Please note that ``opennebula_oneadmin_ssh_copyback`` volume is mounted to ``/var/lib/one/.ssh`` in ``sshd`` service!

.. note::

    Locations of implicit volumes are adequate for single container deployment but in some cases they could become problematic in multi-container deployment if shared... The reason is simply due to the fact that some directories are not needed or desired to be accessible from other containers. There could also be write conflicts (logs for example).

.. _reference_deploy_params:

Deploy parameters for docker-compose
------------------------------------

.. important::

    Do not mistake these variables with the image parameters - **these are recognized only inside the official OpenNebula's docker-compose.yml**!

+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                 | Default         | Container                 |                     Description                                                                                          |
+=======================================+=================+===========================+==========================================================================================================================+
| ``DEPLOY_OPENNEBULA_REGISTRY``        |                 | all                       | It will prefix the OpenNebula image name (to qualify the registry URL).                                                  |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_OPENNEBULA_IMAGE_NAME``      | ``opennebula``  | all                       | OpenNebula image name.                                                                                                   |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_OPENNEBULA_IMAGE_TAG``       | ``5.13``        | all                       | OpenNebula image tag.                                                                                                    |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_BIND_ADDR``                  | ``0.0.0.0``     | all (except sshd)         | This will tell the docker-compose where to bind the published ports - perfect for a designated IP address.               |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_BIND_SSH_ADDR``              | ``0.0.0.0``     | ``opennebula-sshd``       | As with the ``DEPLOY_BIND_ADDR`` but this time only for SSH service.                                                     |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SSH_EXTERNAL_PORT``          | ``22``          | ``opennebula-sshd``       | External/published SSH port.                                                                                             |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONED_INTERNAL_PORT``         | ``2634``        | ``opennebula-oned``       | Internal port for the main OpenNebula API (TLS).                                                                         |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONED_EXTERNAL_PORT``         | ``2633``        | ``opennebula-oned``       | External/published port for the main OpenNebula API.                                                                     |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_MONITORD_EXTERNAL_PORT``     | ``4124``        | ``opennebula-oned``       | External/published and internal port for the monitord (TCP and UDP) - it will also setup ``MONITORD_PORT``.              |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEGATE_INTERNAL_PORT``      | ``5031``        | ``opennebula-gate``       | Internal port for the OneGate service (TLS).                                                                             |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEGATE_EXTERNAL_PORT``      | ``5030``        | ``opennebula-gate``       | External/published port for the OneGate service - it will also setup ``ONEGATE_PORT`` in ``opennebula-oned``.            |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEFLOW_INTERNAL_PORT``      | ``2475``        | ``opennebula-flow``       | Internal port for the OneFlow service (TLS).                                                                             |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEFLOW_EXTERNAL_PORT``      | ``2474``        | ``opennebula-flow``       | External/published port for the OneFlow service.                                                                         |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_PORT``     | ``80``          | ``opennebula-sunstone``   | External/published port for the Sunstone service (HTTP) - it will also setup ``SUNSTONE_PORT``.                          |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_TLS_PORT`` | ``443``         | ``opennebula-sunstone``   | External/published port for the Sunstone service (HTTPS) - it will also setup ``SUNSTONE_TLS_PORT``.                     |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_VNC_PORT`` | ``29876``       | ``opennebula-sunstone``   | External/published and internal port for the Sunstone's VNC - it will also setup ``SUNSTONE_VNC_PORT``.                  |
+---------------------------------------+-----------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+

.. _reference_supervisord:

Supervisor
----------

`Supervisor <http://supervisord.org/>`_ is a process manager used inside the OpenNebula Front-end container as a manager of services. Once :ref:`the bootstrap script <reference_bootstrap>` is done with the setup of the container - supervisord process will take over. It has a responsibility for the lifetime of (almost) all the processes inside the running container.

This section is dedicated to get familiarized with this program and how to use it when inside the container.

.. note::

    We will expect that the user already knows how to list running containers and has a basic knowledge of the Docker CLI - if not there is a concise :ref:`container primer <appendix_container_basics>` in the appendix.

Entering the running container:

.. prompt:: bash $ auto

    $ docker exec -it opennebula /bin/bash

The ``supervisorctl`` client tool is the interface through which we are communicating with the ``supervisord`` process (Supervisor daemon).

.. important::

    Supervisord process starts only after the bootstrap is finished and therefore until that happens the supervisorctl client will give similar output to this:

    .. code::

        [root@bdd24a7d817c /]# supervisorctl status
        unix:///run/supervisor.sock no such file

To get the usage:

.. prompt:: bash $ auto

    $ supervisorctl help

The output can look like this:

.. code::

    default commands (type help <topic>):
    =====================================
    add    exit      open  reload  restart   start   tail
    avail  fg        pid   remove  shutdown  status  update
    clear  maintail  quit  reread  signal    stop    version

Getting the status info about all configured services inside the container:

.. prompt:: bash $ auto

    $ supervisorctl status

Sample output (single container *all-in-one* deployment):

.. code::

    containerd                       RUNNING   pid 1012, uptime 0:01:03
    crond                            RUNNING   pid 1013, uptime 0:01:03
    docker                           RUNNING   pid 1022, uptime 0:01:03
    memcached                        RUNNING   pid 1014, uptime 0:01:03
    mysqld                           RUNNING   pid 1015, uptime 0:01:03
    mysqld-configure                 RUNNING   pid 1755, uptime 0:00:55
    mysqld-upgrade                   RUNNING   pid 1682, uptime 0:01:01
    oneprovision-sshd                RUNNING   pid 1016, uptime 0:01:03
    opennebula                       RUNNING   pid 1033, uptime 0:01:03
    opennebula-fireedge              RUNNING   pid 1036, uptime 0:01:03
    opennebula-flow                  RUNNING   pid 1039, uptime 0:01:03
    opennebula-gate                  RUNNING   pid 1049, uptime 0:01:03
    opennebula-guacd                 RUNNING   pid 1055, uptime 0:01:03
    opennebula-hem                   RUNNING   pid 1063, uptime 0:01:03
    opennebula-httpd                 RUNNING   pid 1067, uptime 0:01:03
    opennebula-novnc                 RUNNING   pid 1072, uptime 0:01:03
    opennebula-scheduler             RUNNING   pid 1077, uptime 0:01:03
    opennebula-showback              RUNNING   pid 1082, uptime 0:01:03
    opennebula-ssh-add               RUNNING   pid 1662, uptime 0:01:01
    opennebula-ssh-agent             RUNNING   pid 1497, uptime 0:01:02
    opennebula-ssh-socks-cleaner     RUNNING   pid 1029, uptime 0:01:03
    sshd                             RUNNING   pid 1019, uptime 0:01:03
    stunnel                          RUNNING   pid 1020, uptime 0:01:03

Status of only one specific service:

.. prompt:: bash $ auto

    $ supervisorctl status opennebula-httpd

Stopping, starting and restarting is done as expected:


.. prompt:: bash $ auto

    $ supervisorctl stop opennebula-httpd
    $ supervisorctl start opennebula-httpd
    $ supervisorctl restart opennebula-httpd

There are a few ways how to add/remove a service to/from Supervisor - here is described the cleanest.

Removing the service - stop the service and remove it by supervisorctl:

.. code::

    [root@d3a9560266a2 /]# supervisorctl status crond
    crond                            RUNNING   pid 1013, uptime 0:10:41
    [root@d3a9560266a2 /]# supervisorctl stop crond
    crond: stopped
    [root@d3a9560266a2 /]# supervisorctl remove crond
    crond: removed process group
    [root@d3a9560266a2 /]# supervisorctl status crond
    crond: ERROR (no such process)

Adding the service - the *ini* file must be already created:

.. code::

    [root@d3a9560266a2 /]# ls -l /etc/supervisord.d/crond.ini
    -rw-r--r-- 1 root root 174 Jan 26 11:16 /etc/supervisord.d/crond.ini
    [root@d3a9560266a2 /]# supervisorctl add crond
    crond: added process group
    [root@d3a9560266a2 /]# supervisorctl status crond
    crond                            RUNNING   pid 8127, uptime 0:00:06

.. note::

    All enabled services are represented as **ini** files inside the directory ``/etc/supervisord.d/`` - if you wish to modify some service you can edit the files and update the Supervisor:

        $ supervisorctl update

.. important::

    Using the facility of the maintenance mode (parameter ``MAINTENANCE_MODE``) will prevent all services from starting (they will have ``autostart`` option set to ``false``).

.. _appendix:

Appendix
================================================================================

.. _appendix_glossary:

Glossary
--------

Container image
^^^^^^^^^^^^^^^

The container image is stored in a registry (explained in the next section) and it is just a plain tar archive with some metadata in the form of json files and with another tar archives inside. These inner archives represent so called layers which are basically snapshots of the data containing binaries, config files etc. The whole structure of the image is described in a source file named `Dockerfile <https://docs.docker.com/engine/reference/builder/>`_.

After the image is build (based on the instructions in the Dockerfile) and a container is instantiated from it then the image layers (including the new container layer) are layed over one another creating a seemless view of the filesystem (rootfs).

The official Docker document page `Images and layers <https://docs.docker.com/storage/storagedriver/#images-and-layers>`_ explains this topic in depth.

Docker registry
^^^^^^^^^^^^^^^

Container images are stored in a `registry <https://docs.docker.com/registry/introduction/>`_.

There are many public container registries and it is often the case that each runtime has some own list built in. Such a list of registries and the order in which they are searched for an image is project specific. For example the go-to registry for Docker images is `the Docker Hub <https://hub.docker.com/>`_ which is prioritized in Docker but that does not need to be the case with Podman.

Container image is designated with an optional URL of the registry, repository, name and a tag. One image can have multiple assigned names and tags without taking any extra space on the disk. Visit the official documentation regarding `image names <https://docs.docker.com/engine/reference/commandline/tag/#extended-description>`_.

.. _appendix_opennebula_cli:

OpenNebula CLI configuration
----------------------------

You can access the OpenNebula Front-end's container(s) APIs from a remote system granted `the OpenNebula CLI tools <https://docs.opennebula.io/5.12/operation/references/cli.html>`_ are installed there.

Oneadmin's one_auth
^^^^^^^^^^^^^^^^^^^

Before we can start using the CLI we must prepare a ``one_auth`` file:

.. prompt:: bash $ auto

    $ mkdir -p ~/.one
    $ echo "oneadmin:${ONEADMIN_PASSWORD}" > ~/.one/one_auth

.. important::

   Replace ``${ONEADMIN_PASSWORD}`` with the actual password - ``ONEADMIN_PASSWORD`` must of course be the same as the one used in the deployment.

API endpoints
^^^^^^^^^^^^^

Next step is to setup the shell environmental variables so the CLI tools will start using the API endpoints of our container deployment.

.. note::

    In the following examples replace the ``${OPENNEBULA_FRONTEND_HOST}`` with the actual domain name or IP address.

Setting up the OpenNebula API endpoint exposed over HTTPS (``TLS_PROXY_ENABLED=yes``) and on the typical port ``2633``:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="https://${OPENNEBULA_FRONTEND_HOST}:2633"

Alternatively we could access the non-TLS endpoint (``TLS_PROXY_ENABLED=no``) over plain HTTP:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="http://${OPENNEBULA_FRONTEND_HOST}:2633"

And the same goes for the OneFlow API (``TLS_PROXY_ENABLED=yes``):

.. prompt:: bash $ auto

    $ export ONEFLOW_URL="https://${OPENNEBULA_FRONTEND_HOST}:2474"

Or over plain HTTP (``TLS_PROXY_ENABLED=no``):

.. prompt:: bash $ auto

    $ export ONEFLOW_URL="http://${OPENNEBULA_FRONTEND_HOST}:2474"

CLI examples
^^^^^^^^^^^^

.. prompt:: bash $ auto

    $ mkdir -p ~/.one
    $ echo "oneadmin:changeme123" > ~/.one/one_auth

.. prompt:: bash $ auto

    $ ONE_XMLRPC="https://192.168.1.1:2633" onehost list

.. prompt:: bash $ auto

    $ ONEFLOW_URL="https://192.168.1.1:2474" oneflow-template list

Further details can be found in the documentation regarding `the management of the users <http://docs.opennebula.io/stable/operation/users_groups_management/manage_users.html>`_.

.. _appendix_single_container_examples:

Single container examples
-------------------------

Custom files
^^^^^^^^^^^^

More complicated deployment using custom SSH key, TLS certificate, hooks, onecfg patch, designated bind address and some non-standard ports.

We will need a few prerequisites.

``ssh`` directory with passphrase-less SSH key:

.. prompt:: bash $ auto

    $ ls ./ssh
    id_rsa  id_rsa.pub

``certs`` directory with your TLS certificate:

.. prompt:: bash $ auto

    $ ls ./certs
    cert.key  cert.pem

and ``config`` directory with the onecfg patch, pre-hook and post-hook executable:

.. prompt:: bash $ auto

    $ ls ./config
    onecfg_patch  prepare.sh  setup.sh

.. note::

    The bind address must also be adjusted to your situation.

The deployment itself:

.. prompt:: bash $ auto

    $ docker run -d --privileged --name opennebula-custom \
    -p 192.168.1.1:8080:80 \
    -p 192.168.1.1:4443:443 \
    -p 192.168.1.1:22:22 \
    -p 192.168.1.1:30001:30001 \
    -p 192.168.1.1:12633:2633 \
    -p 192.168.1.1:15030:5030 \
    -p 192.168.1.1:12474:2474 \
    -p 192.168.1.1:14124:14124 \
    -p 192.168.1.1:14124:14124/udp \
    -v "$(realpath ./config)":/config:z,ro \
    -v "$(realpath ./ssh):/ssh:z,ro" \
    -v "$(realpath ./certs):/certs:z,ro" \
    -v opennebula_db:/var/lib/mysql \
    -v opennebula_datastores:/var/lib/one/datastores \
    -v opennebula_srv:/srv/one \
    -v opennebula_oneadmin_auth:/var/lib/one/.one \
    -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \
    -v opennebula_oneprovision_ssh:/var/lib/one/.ssh-oneprovision \
    -v opennebula_logs:/var/log \
    -e OPENNEBULA_FRONTEND_HOST=${HOSTNAME} \
    -e OPENNEBULA_FRONTEND_SSH_HOST=${HOSTNAME} \
    -e OPENNEBULA_FRONTEND_ONECFG_PATCH="/config/onecfg_patch" \
    -e OPENNEBULA_FRONTEND_PREHOOK="/config/prepare.sh" \
    -e OPENNEBULA_FRONTEND_POSTHOOK="/config/setup.sh" \
    -e ONEADMIN_PASSWORD=changeme123 \
    -e DIND_ENABLED=yes \
    -e ONEADMIN_SSH_PRIVKEY="/ssh/id_rsa" \
    -e ONEADMIN_SSH_PUBKEY="/ssh/id_rsa.pub" \
    -e TLS_CERT="/certs/cert.pem" \
    -e TLS_KEY="/certs/cert.key" \
    -e SUNSTONE_PORT=8080 \
    -e SUNSTONE_TLS_PORT=4443 \
    -e SUNSTONE_VNC_PORT=30001 \
    -e ONEGATE_PORT=15030 \
    -e MONITORD_PORT=14124 \
    opennebula:5.13

.. note::

    All OpenNebula APIs are published on atypical ports - look at :ref:`the ports reference table <reference_ports>` to get the idea how to make CLI commands working.

.. note::

    ``SUNSTONE_PORT`` and ``SUNSTONE_TLS_PORT`` must be aligned with the Sunstone's published ports (8080, 4443). This applies to ``ONEGATE_PORT`` (15030) too.

    Similar situation is also with the ``SUNSTONE_VNC_PORT`` (30001) and ``MONITORD_PORT`` (14124) - but pay attention to the both sides of publish port argument (both sides must be set).

Simple test
^^^^^^^^^^^

Limited **test** deployment without Docker-in-Docker, TLS, HTTPS or volumes:

.. prompt:: bash $ auto

    $ docker run -d --name opennebula-test \
    -p 8080:80 \
    -p 2222:22 \
    -p 29876:29876 \
    -p 2633:2633 \
    -p 5030:5030 \
    -p 2474:2474 \
    -p 4124:4124 \
    -p 4124:4124/udp \
    -e OPENNEBULA_FRONTEND_HOST=${HOSTNAME} \
    -e OPENNEBULA_FRONTEND_SSH_HOST=${HOSTNAME} \
    -e ONEADMIN_PASSWORD=changeme123 \
    -e TLS_PROXY_ENABLED=no \
    -e SUNSTONE_HTTPS_ENABLED=no \
    -e SUNSTONE_PORT=8080 \
    -e DIND_ENABLED=no \
    opennebula:5.13

.. note::

    Notice that ``--privileged`` argument is missing and ``DIND_ENABLED`` is disabled so in the least Docker Hub marketplace will not work and maybe other functionality will be missing/failing!

.. _appendix_selinux:

SELinux on CentOS/RHEL
----------------------

Disable SELinux (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Change the following line in ``/etc/selinux/config`` to **disable** SELinux:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.

Enable SELinux
^^^^^^^^^^^^^^

Change the following line in ``/etc/selinux/config`` to **enable** SELinux in ``enforcing`` state:

.. code-block:: bash

    SELINUX=enforcing

When changing from the ``disabled`` state, it's necessary to trigger filesystem relabel on the next boot by creating a file ``/.autorelabel``, e.g.:

.. prompt:: bash $ auto

    $ touch /.autorelabel

After the changes, you should reboot the machine.

.. note:: Follow the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__ for more information on how to configure and troubleshoot SELinux.

.. _appendix_podman:

Podman
------

Restart policy
^^^^^^^^^^^^^^

Please note that restart (``--restart``) will not restart containers after a system reboot. If this functionality is required in your environment, you can invoke Podman from a **systemd unit file**, or create an init script for whichever init system is in use. To generate systemd unit files, please see ``podman generate systemd``.

.. _appendix_container_basics:

Container basics
----------------

Logging into private registry - in this case OpenNebula enterprise registry:

.. prompt:: bash $ auto

    $ docker login https://docker.opennebula.io # TODO

Pulling image from the private repo:

.. prompt:: bash $ auto

    $ docker pull https://docker.opennebula.io/opennebula:5.13 # TODO

Pulling image of the community edition from the Docker Hub:

.. prompt:: bash $ auto

    $ docker pull opennebula/opennebula:5.13

Add ``latest`` tag to the pulled image:

.. prompt:: bash $ auto

    $ docker tag opennebula/opennebula:5.13 opennebula:latest

List the local images:

.. code::

   $ docker images
   REPOSITORY          TAG                      IMAGE ID            CREATED             SIZE
   opennebula          5.13                     039a43d7b277        7 hours ago         2.05GB
   opennebula          latest                   039a43d7b277        7 hours ago         2.05GB
   centos              8                        300e315adb2f        6 weeks ago         209MB

Delete the name and tag:

.. prompt:: bash $ auto

    $ docker image rm opennebula/opennebula:5.13

Delete the image with all its names and tags (by using the digest):

.. prompt:: bash $ auto

    $ docker image rm 039a43d7b277

Remove all dangling (unnamed) images taking storage place:

.. prompt:: bash $ auto

    $ docker image prune

List all currently **running** containers:

.. prompt:: bash $ auto

    $ docker ps

List all **created** containers including running and stopped:

.. prompt:: bash $ auto

    $ docker ps -a

Start a container and store its ID into variable ``CONTAINER``:

.. prompt:: bash $ auto

    $ CONTAINER=$(docker run -d nginx)

Stop running container:

.. prompt:: bash $ auto

    $ docker stop ${CONTAINER}

Kill misbehaving container:

.. prompt:: bash $ auto

    $ docker kill ${CONTAINER}

Remove the container:

.. prompt:: bash $ auto

    $ docker rm ${CONTAINER}


.. xxxxxxxxxxxxxxxxxxxxxxxx MARK THE END OF THE CONTENT xxxxxxxxxxxxxxxxxxxxxxxx

.. |_| unicode:: 0xA0
   :trim:

.. |image0| image:: /images/onedocker-schema-all-in-one.svg
   :width: 600
   :align: middle
   :alt: Deployment schema of the all-in-one OpenNebula container
.. |image1| image:: /images/onedocker-schema-microservices.svg
   :width: 600
   :align: middle
   :alt: Deployment schema of the OpenNebula containers as microservices
.. |image2| image:: /images/onedocker-schema-bootstrap.svg
   :width: 600
   :align: middle
   :alt: Sequential diagram of the bootstrap process
