.. _container_reference:

================================================================================
Troubleshooting and Reference
================================================================================

This page contains complementary information to the :ref:`containerized deployment <container_deployment>` of the OpenNebula Front-end. It provides hints on how to :ref:`troubleshoot <container_troubleshooting>` problems with descriptions of common issues, :ref:`tutorials <container_guides>` on how to control services in the containers or configure CLI, and :ref:`reference <container_references>` tables of all network services, image parameters, or volumes.

.. _container_troubleshooting:

Troubleshooting
===============

Container Logs
--------------

.. note::

    Beware that ``podman-compose`` may miss some of the functionality mentioned in this section.

The first place to look for problems should be the standard output of the containers (and the log of this).

**docker**

.. prompt:: bash # auto

    # docker logs -f opennebula

**docker-compose**

Real-time tailing of all the service output messages:

.. prompt:: bash # auto

    # docker-compose logs -f

or for checking only one container you are interested in (e.g., ``opennebula-oned``):

.. prompt:: bash # auto

    # docker-compose logs -f opennebula-oned

Service Logs
------------

The most helpful debugging approach is to investigate the container inside. First, get into the particular container. E.g.:

.. prompt:: bash # auto

    # docker exec -it opennebula /bin/bash

This works with the multi-container deployment too, you just need to use the proper name (or, container ID). E.g.:

.. prompt:: bash # auto

    # docker exec -it opennebula_opennebula-oned_1 /bin/bash

**Logs**

All the log files are located in ``/var/log`` in the following significant places:

- ``/var/log/one/``
- ``/var/log/supervisor/services/``

Failed to Login into Sunstone
-----------------------------

If you already used Sunstone over HTTPS and decide to change to HTTP-only later (or vice versa), you might experience issues logging in into Sunstone without any visible error message. To fix the problem, drop the browser cookies for the Sunstone URL and try again.

Container Name Already in Use
-----------------------------

You might experience a similar error:

.. code::

    docker: Error response from daemon: Conflict. The container name "/opennebula" is already in use by container
    "93c5ebf71aa39eb66d5df0c1962d024456ddff6435c030d694aec78c6989bbc6". You have to remove (or rename) that
    container to be able to reuse that name.
    See 'docker run --help'.

In this case, the user is trying to start a **new** container with the same name as the container which was already created. This happens usually when the previous container is stopped (``docker stop opennebula``) or crashes, but the user is trying to *start* it again with the ``docker run`` command (instead of ``docker start``).

Depending on your intentions, you can *start* the existing container again:

.. prompt:: bash # auto

    # docker start opennebula

or delete it and start a new one:

.. prompt:: bash # auto

    # docker rm opennebula
    # docker run ... --name opennebula opennebula:6.1

.. _container_troubleshooting_podman:

Starting Containers on Boot with Podman
---------------------------------------

Containers won't start upon server boot with Podman and Podman Compose, even if the containers are configured with a restart policy (``--restart``). You need to implement the containers' start via your init system, e.g. ``systemd``. Read more in the `Porting containers to systemd using <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/porting-containers-to-systemd-using-podman_building-running-and-managing-containers>`__ chapter of the *Building, running, and managing container* guide.

.. _container_troubleshooting_apparmor:

AppArmor and Docker Compose on Ubuntu/Debian
--------------------------------------------

On Ubuntu/Debian with AppArmor enabled, the multi-container Docker deployment (started by using the **Docker Compose**) is configured to run the container with ``oned`` **without AppArmor security policies** applied, e.g. it's running in the unconfined mode. It can be changed via the :ref:`deployment parameter <container_reference_deploy_params>` ``DEPLOY_APPARMOR_PROFILE``.

Rationale: On Debian/Ubuntu with AppArmor enabled, the Docker uses the default `AppArmor profile <https://docs.docker.com/engine/security/apparmor/>`_ ``docker-default``, which doesn't correctly reflect extra ``SYS_ADMIN`` capabilities configured in the container. As a result, the AppArmor breaks the integration with Docker Hub, Linux Containers, and TurnKey Linux Marketplaces in the OpenNebula as it blocks its user-space mounts via ``FUSE``.

.. _container_guides:

Guides
======

This section contains various guides and tutorials.

.. _container_cli:

CLI Configuration
-----------------

You can access the OpenNebula Front-end services remotely over the API provided by each service. You need to install the :ref:`Command Line Tools <cli>`, configure credentials and connection endpoints.

**Credentials**

Create a file ``$HOME/.one/one_auth`` and put inside the credentials of the OpenNebula user you'll connect with (you can use ``oneadmin``, or any other OpenNebula user you have already created). The syntax of the file is ``username:password``. For example:

.. code::

    oneadmin:changeme123

**Endpoints**

The next step is to set-up the environmental variables with the API endpoints.

.. note::

    In the following examples, replace the ``${OPENNEBULA_HOST}`` with the actual domain name or IP address.

For TLS-secured OpenNebula Front-end deployment, use:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="https://${OPENNEBULA_HOST}:2633"
    $ export ONEFLOW_URL="https://${OPENNEBULA_HOST}:2474"

For insecure OpenNebula Front-end deployment, use:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="http://${OPENNEBULA_HOST}:2633"
    $ export ONEFLOW_URL="http://${OPENNEBULA_HOST}:2474"

.. warning::

    If you are using the default untrusted (self-signed) TLS certificates, you might need to disable TLS verification by using

    .. prompt:: bash $ auto

        $ export ONE_DISABLE_SSL_VERIFY=yes

.. _container_supervisord:

Supervisor
----------

`Supervisor <http://supervisord.org/>`_ is a process manager used inside the OpenNebula Front-end container image as a manager of services. Once :ref:`the bootstrap script <container_bootstrap>` is done with the setup of the container, Supervisor takes control of the container. It has responsibility for the lifetime of (almost) all the processes inside the running container.

This is a quick introduction to using Supervisor.

.. note::

    We expect the user to know how to list running containers and to have a basic knowledge of the Docker CLI. Otherwise, check the :ref:`container basics <container_basics>`.

Enter the running container:

.. prompt:: bash # auto

    # docker exec -it opennebula /bin/bash

The ``supervisorctl`` CLI tool is the interface to control the Supervisor daemon (``supervisord``):

.. important::

    The Supervisor daemon starts only after the successful bootstrap, until then the ``supervisorctl`` might fail like this:

    .. code::

        [root@bdd24a7d817c /]# supervisorctl status
        unix:///run/supervisor.sock no such file

Get the available commands for supervisor CLI:

.. prompt:: bash # auto

    # supervisorctl help

    default commands (type help <topic>):
    =====================================
    add    exit      open  reload  restart   start   tail
    avail  fg        pid   remove  shutdown  status  update
    clear  maintail  quit  reread  signal    stop    version

Get status information about configured services inside the container, e.g.:

.. prompt:: bash # auto

    # supervisorctl status
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

Show the status of particular service, e.g.:

.. prompt:: bash # auto

    # supervisorctl status opennebula-httpd
    opennebula-httpd                 RUNNING   pid 1067, uptime 0:01:03

Stopping, starting and restarting a particular service is pretty intuitive. E.g.:

.. prompt:: bash $ auto

    $ supervisorctl stop    opennebula-httpd
    $ supervisorctl start   opennebula-httpd
    $ supervisorctl restart opennebula-httpd

.. _container_basics:

Container Operations Basics
---------------------------

This section shows examples of most operations with the container runtime.

.. note::

    See :ref:`Get Container Image <container_image>` guide to get the OpenNebula Front-end image.

List the local container images:

.. prompt:: bash # auto

   # docker images
   REPOSITORY          TAG                      IMAGE ID            CREATED             SIZE
   opennebula          6.1                      039a43d7b277        7 hours ago         2.05GB
   centos              8                        300e315adb2f        6 weeks ago         209MB

Add a custom tag to the pulled OpenNebula image:

.. prompt:: bash # auto

    # docker tag opennebula/opennebula:6.1 opennebula:custom

Delete the local image based by name and tag:

.. prompt:: bash # auto

    # docker image rm opennebula/opennebula:6.1

Delete the local image based by a digest:

.. prompt:: bash # auto

    $ docker image rm 039a43d7b277

Remove all dangling (unnamed) images taking up storage place:

.. prompt:: bash # auto

    # docker image prune

List all currently **running** containers:

.. prompt:: bash # auto

    # docker ps

List all **created** containers (including running and stopped):

.. prompt:: bash # auto

    # docker ps -a

Start a container and store its ID into env. variable ``CONTAINER``:

.. prompt:: bash # auto

    # CONTAINER=$(docker run -d nginx)

Stop running container:

.. prompt:: bash # auto

    # docker stop ${CONTAINER}

Kill misbehaving container:

.. prompt:: bash # auto

    # docker kill ${CONTAINER}

Remove the container:

.. prompt:: bash # auto

    # docker rm ${CONTAINER}

.. _container_references:

References
==========

.. _container_reference_ports:

Network Ports
-------------

Internal container network (TCP/UDP) ports which are expected to be exposed to the public:

+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| Port      | Protocol | Service [*]_           |                     Description                                                                                       |
+===========+==========+========================+=======================================================================================================================+
| ``22``    | TCP      | ``sshd``               | Integrated SSH Server                                                                                                 |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``80``    | TCP      | ``sunstone``           | Sunstone server (HTTP) - automatically redirected to HTTPS (if ``SUNSTONE_HTTPS_ENABLED=yes``)                        |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``443``   | TCP      | ``sunstone``           | Sunstone server (HTTPS) - can be disabled                                                                             |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2474``  | TCP      | ``oneflow``            | OneFlow server                                                                                                        |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2475``  | TCP      | ``oneflow``            | OneFlow server over HTTPS (if enabled ``TLS_PROXY_ENABLED=yes``)                                                      |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2633``  | TCP      | ``oned``               | OpenNebula Daemon, main XML-RPC API endpoint                                                                          |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``2634``  | TCP      | ``oned``               | OpenNebula Daemon over HTTPS (if enabled  ``TLS_PROXY_ENABLED=yes``)                                                  |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``4124``  | TCP      | ``oned``               | Monitord server, collector of the monitoring messages from the nodes                                                  |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``4124``  | UDP      | ``oned``               | Monitord server over UDP                                                                                              |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``5030``  | TCP      | ``onegate``            | OneGate server                                                                                                        |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``5031``  | TCP      | ``onegate``            | OneGate server over HTTPS (if enabled ``TLS_PROXY_ENABLED=yes``)                                                      |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ``29876`` | TCP      | ``sunstone``           | noVNC proxy port, used for translating and redirecting VNC connections to the hypervisors.                            |
+-----------+----------+------------------------+-----------------------------------------------------------------------------------------------------------------------+

.. [*] Service as in the value of ``OPENNEBULA_SERVICE``

.. important::

    It is important to distinguish between the **container's internal** port (as in the table) and **external** (published) ports - the majority of the internal ports are hardwired and cannot be moved to another port number.

    If you want to avoid port conflicts with the already bound ports on the Host then a change to the external (published) port is needed. In a few cases, the container itself also must be informed about the changes and a relevant image parameter thus must reflect the same value.

The following table demonstrates how to utilize different ports for different services via arguments of the ``docker run`` command. Notice that in the case of **monitord** and **Sunstone VNC** both sides of expression must be modified not just the left (published) portion.

.. TODO - Drop table below:

+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| Port Mapping Examples  | Affected Parameter |_| / |_| Service           |                     Note                                                                                                                  |
+========================+================================================+===========================================================================================================================================+
| ``-p 2222:22``         |                                                | Change to the SSH port has consequences which are described in :ref:`the SSH service prerequisite <container_ssh>`.                       |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 8080:80``         | ``SUNSTONE_PORT / sunstone``                   | Sunstone port (HTTP) - ``SUNSTONE_PORT=8080``                                                                                             |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 4443:443``        | ``SUNSTONE_TLS_PORT / sunstone``               | Sunstone port (HTTPS) - ``SUNSTONE_TLS_PORT=4443``                                                                                        |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 12474:2474``      |                                                | OneFlow port - no image parameter is needed to set but :ref:`OpenNebula CLI tools <container_cli>` must be configured properly.           |
+------------------------+------------------------------------------------+                                                                                                                                           +
| ``-p 12474:2475``      |                                                |                                                                                                                                           |
+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| ``-p 12633:2633``      |                                                | OpenNebula main API port - only the :ref:`OpenNebula CLI tools <container_cli>` need to be configured.                                    |
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

.. _container_reference_params:

Image Parameters
----------------

**Image parameters** are environment variables passed into the container, which customize the bootstrap process and consequently the container's runtime. The following table provides a detailed description of user-adjustable image parameters:

+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                | Required |_| [*]_ |_|  | Default                  |                     Description                                                                                          |
+======================================+========================+==========================+==========================================================================================================================+
| ``OPENNEBULA_SERVICE``               | YES (all) |_| [*]_     | ``all``                  | Front-end service to run inside the container - proper values are listed here:                                           |
|                                      |                        |                          |                                                                                                                          |
|                                      |                        |                          | - ``all`` - Run all services (all-in-one deployment) - this is the default value                                         |
|                                      |                        |                          | - ``docker`` - Docker in Docker - needed for Docker Hub marketplace (requires ``--privileged`` option)                   |
|                                      |                        |                          | - ``etcd`` -  Etcd service storing shared configuration related data                                                     |
|                                      |                        |                          | - ``fireedge`` - FireEdge service to proxy VMRC, Guacemole (VM console) and access the OneProvision                      |
|                                      |                        |                          | - ``guacd`` - Guacemole proxy providing access to the VM console (along the regular VNC)                                 |
|                                      |                        |                          | - ``memcached`` - Memcached service required by Sunstone web server                                                      |
|                                      |                        |                          | - ``mysqld`` - Database server backend for the oned service                                                              |
|                                      |                        |                          | - ``none`` - No service will be bootstrapped and started - container will be running dummy noop process                  |
|                                      |                        |                          | - ``oned`` - OpenNebula daemon providing the main API (requires ``SYS_ADMIN`` capability)                                |
|                                      |                        |                          | - ``oneflow`` - OneFlow service                                                                                          |
|                                      |                        |                          | - ``onegate`` - OneGate service                                                                                          |
|                                      |                        |                          | - ``oneprovision`` - OneProvision where all provision related commands are executed and provisioned SSH keys accessed    |
|                                      |                        |                          | - ``scheduler`` - OpenNebula scheduler needed by oned                                                                    |
|                                      |                        |                          | - ``sshd`` - SSH daemon to which nodes will connect to                                                                   |
|                                      |                        |                          | - ``sunstone`` - Sunstone web server                                                                                     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_HOST``                  | YES: |br|              |                          | Host (DNS domain, IP address) which will be advertised as the Front-end endpoint for FireEdge. It also serves as a       |
|                                      | ``oned`` |br|          |                          | default for the OneGate and SSH endpoints - both of these can be overriden with ``OPENNEBULA_ONEGATE_HOST`` and          |
|                                      | ``sunstone``           |                          | ``OPENNEBULA_SSH_HOST`` respectively.                                                                                    |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_ONEGATE_HOST``          | NO: ``oned``           |                          | Host (DNS domain, IP address) which will be advertised as the Front-end endpoint for OneGate (defaults to                |
|                                      |                        |                          | ``OPENNEBULA_HOST``).                                                                                                    |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_SSH_HOST``              | YES: ``oned``          |                          | Host (DNS domain, IP address) which will be advertised as the SSH endpoint (sshd) to which nodes will connect to.        |
|                                      |                        |                          | (defaults to ``OPENNEBULA_HOST``).                                                                                       |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_CUSTOMER_TOKEN``        | NO: ``sunstone``       |                          | Customer specific support token.                                                                                         |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_ONECFG_PATCH``          | NO (all)               |                          | Path within the container to the custom patch file which will be passed to the onecfg command (**before pre-hook**).     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_PREBOOTSTRAP_HOOK``     | NO (all)               |                          | Path within the container to the custom file which will be executed **before** the bootstrap is started.                 |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_POSTBOOTSTRAP_HOOK``    | NO (all)               |                          | Path within the container to the custom file which will be executed **after** the bootstrap is ended.                    |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``OPENNEBULA_BATCH_FILE``            | NO (all)               |                          | Path within the container to the custom file which will be executed **after** the bootstrap and once ``oned`` is started.|
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_ENABLED``                     | NO: ``docker``         | ``no``                   | Enable Docker service (*Docker-in-Docker*) - requires ``--privileged`` option (or adequate list of capabilities).        |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_SOCKET`` |_| [*]_             |                        | ``/var/run/docker.sock`` | Configurable path of the Docker socket for the Docker inside the container.                                              |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ETCD_ROOT_PASSWORD``               | NO: ``etcd``           |                          | Etcd root's initial password or it will be randomly generated (only once) and stored in ``/srv/one/etcd``.               |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MAINTENANCE_MODE``                 | NO (all)               | ``no``                   | Boolean option for starting the container in the maintenance mode - service is bootstrapped but not started.             |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MONITORD_PORT`` |_| [*]_           | NO: ``oned``           | ``4124``                 | **Published/exposed and internal** Monitord port (TCP and UDP).                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_PORT``                       | NO: |br|               | ``3306``                 | Port on which MySQL service will be listening and accessible from.                                                       |
|                                      | ``mysqld`` |br|        |                          |                                                                                                                          |
|                                      | ``oned``               |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_DATABASE``                   |                        | ``opennebula``           | Name of OpenNebula's database stored in the MySQL server (it will be created).                                           |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_USER``                       |                        | ``oneadmin``             | User allowed to access OpenNebula's database (it will be created).                                                       |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_PASSWORD``                   | YES |_| [*]_: |br|     |                          | User's database password otherwise it will be randomly generated in the case of *all-in-one* deployment (only once).     |
|                                      | ``mysqld`` |br|        |                          |                                                                                                                          |
|                                      | ``oned``               |                          |                                                                                                                          |
|                                      | ``etcd``               |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_ROOT_PASSWORD``              | NO: |br|               |                          | MySQL root password for the first time setup otherwise it will be randomly generated (only once).                        |
|                                      | ``mysqld``             |                          |                                                                                                                          |
|                                      | ``etcd``               |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_PASSWORD``                | NO: ``oned``           |                          | Oneadmin's initial password or it will be randomly generated (only once) and stored in ``/var/lib/one/.one/one_auth``.   |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PRIVKEY_BASE64``      | NO: ``etcd``           |                          | Custom SSH key (private portion) in base64 format.                                                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PUBKEY_BASE64``       |                        |                          | Custom SSH key (public portion) in base64 format.                                                                        |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PRIVKEY``             |                        | ``/ssh/id_rsa``          | Path within the container to the custom SSH key (private portion).                                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEADMIN_SSH_PUBKEY``              |                        | ``/ssh/id_rsa.pub``      | Path within the container to the custom SSH key (public portion).                                                        |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONED_DB_BACKUP_ENABLED``           | NO: ``oned``           | ``yes``                  | Enable database backup before the upgrade (it will run sqldump and store the backup in ``/var/lib/one/backups``).        |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEGATE_PORT``                     | NO: ``oned``           | ``5030``                 | Advertised port where OneGate service is published (the host portion is defined by ``OPENNEBULA_HOST``)                  |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_HTTPS_ENABLED``           | NO: ``sunstone``       | ``yes``                  | Enable HTTPS access to the Sunstone server (it will generate self-signed certificate if none is provided).               |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_PORT``                    |                        | ``80``                   | **Published/exposed** Sunstone HTTP port (pointing to the internal HTTP).                                                |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_TLS_PORT``                |                        | ``443``                  | **Published/exposed** Sunstone HTTPS port (pointing to the internal HTTPS).                                              |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``SUNSTONE_VNC_PORT`` |_| [*]_       |                        | ``29876``                | **Published/exposed and internal** Sunstone VNC port (pointing to the internal VNC).                                     |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_PROXY_ENABLED``                | NO: |br|               | ``yes``                  | Enable TLS proxy (via stunnel) to all OpenNebula APIs (it will generate self-signed certificate if none is provided).    |
|                                      | ``oned`` |br|          |                          |                                                                                                                          |
|                                      | ``oneflow`` |br|       |                          |                                                                                                                          |
|                                      | ``onegate``            |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``TLS_DOMAIN_LIST``                  | NO: ``etcd``           | ``*``                    | List of DNS names separated by spaces (asterisk allowed)                                                                 |
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

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_SERVICE``. Regardless of whether or not they are required, only the listed services are actually affected by the parameter (otherwise all are affected).
.. [*] ``OPENNEBULA_SERVICE`` must be defined every time **only** if it is intended as multi-container setup otherwise it defaults to ``all`` and therefore will start *all-in-one* deployment in each container...
.. [*] This variable can be still useful even when ``DIND_ENABLED`` is false because the Host's Docker socket can be bind-mounted inside the container.
.. [*] ``MONITORD_PORT`` must also match the internal port - it is an implementation detail which will require changing both the external (published) and internal port.
.. [*] ``MYSQL_PASSWORD`` is not required when deployed in single container (*all-in-one*).
.. [*] ``SUNSTONE_VNC_PORT`` must also match the internal port - it is an implementation detail which will require changing both the external (published) and internal port.

The next table describes a further set of image parameters where usability is limited only for multi-container deployment via Docker/Podman Compose. They are listed here only for information, usually, **users shouldn't modify** them!

+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                | Required |_| [*]_      | Default                  |                     Description |_| [*]_                                                                                 |
+======================================+========================+==========================+==========================================================================================================================+
| ``DIND_TCP_ENABLED``                 | NO: |br|               | ``no``                   | Enable access to the Docker daemon via TCP (needed for Docker to work in multi-container setup).                         |
|                                      | ``docker`` |br|        |                          |                                                                                                                          |
|                                      | ``oned``               |                          |                                                                                                                          |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DIND_HOST``                        |                        | ``localhost``            | Container host where Docker service is running.                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ETCD_HOST``                        | YES: all               | ``localhost``            | Container host where etcd service is running.                                                                            |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``FIREEDGE_HOST``                    | YES: ``sunstone``      | ``localhost``            | Container host where FireEdge service is running.                                                                        |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``GUACD_HOST``                       | YES: ``fireedge``      | ``localhost``            | Container host where guacd service is running.                                                                           |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_HOST``                       | YES: |br|              | ``localhost``            | Container host where MySQL service is running.                                                                           |
|                                      | ``mysqld`` |br|        |                          |                                                                                                                          |
|                                      | ``oned``               |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MEMCACHED_HOST``                   | YES: ``sunstone``      | ``localhost``            | Container host where memcached service is running.                                                                       |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONED_HOST``                        | YES: |br|              | ``localhost``            | Container host where oned service is running.                                                                            |
|                                      | ``oned`` |br|          |                          |                                                                                                                          |
|                                      | ``sunstone`` |br|      |                          |                                                                                                                          |
|                                      | ``fireedge`` |br|      |                          |                                                                                                                          |
|                                      | ``scheduler`` |br|     |                          |                                                                                                                          |
|                                      | ``oneflow`` |br|       |                          |                                                                                                                          |
|                                      | ``onegate`` |br|       |                          |                                                                                                                          |
|                                      | ``oneprovision``       |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEFLOW_HOST``                     | YES: |br|              | ``localhost``            | Container host where OneFlow service is running.                                                                         |
|                                      | ``sunstone`` |br|      |                          |                                                                                                                          |
|                                      | ``fireedge`` |br|      |                          |                                                                                                                          |
|                                      | ``onegate``            |                          |                                                                                                                          |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``ONEPROVISION_HOST``                | YES: ``fireedge``      | ``localhost``            | Container host for OneProvision with SSH keys.                                                                           |
+--------------------------------------+------------------------+--------------------------+--------------------------------------------------------------------------------------------------------------------------+

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_SERVICE``. Regardless of whether or not they are required - only the listed services are actually affected by the parameter (otherwise all are affected).
.. [*] Avoid the usage of an IP address, they are dynamically assigned in most cases.

.. _container_reference_deploy_params:

Deployment Parameters (only multi-container)
--------------------------------------------

.. important::

    Do not confuse deployment parameters with :ref:`image parameters <container_reference_params>`. The deployment parameters are used only with a referential :ref:`multi-container deployment <container_deploy_multi>`. Values are processed only by Docker/Podman Compose tools and they are not passed into the container instances!

+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                 | Default                                  | Container                 |                     Description                                                                                          |
+=======================================+==========================================+===========================+==========================================================================================================================+
| ``DEPLOY_OPENNEBULA_IMAGE_NAME``      | ``opennebula/opennebula`` **OR**         | all                       | OpenNebula image name - the actual default value will depend on the CE/EE version of the image.                          |
|                                       | ``enterprise.opennebula.io/opennebula``  |                           |                                                                                                                          |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_OPENNEBULA_IMAGE_TAG``       | ``6.1``                                  | all                       | OpenNebula image tag.                                                                                                    |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_APPARMOR_PROFILE``           | ``unconfined``                           | ``opennebula-oned``       | Modifies the `AppArmor profile <https://docs.docker.com/engine/security/apparmor/>`_ - disables it by default.           |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_BIND_ADDR``                  | ``0.0.0.0``                              | all (except sshd)         | This will tell the docker-compose where to bind the published ports - perfect for a designated IP address.               |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_BIND_ONEGATE_ADDR``          | ``0.0.0.0``                              | ``opennebula-gate``       | As with the ``DEPLOY_BIND_ADDR`` but this time only for OneGate service.                                                 |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_BIND_SSH_ADDR``              | ``0.0.0.0``                              | ``opennebula-sshd``       | As with the ``DEPLOY_BIND_ADDR`` but this time only for SSH service.                                                     |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_MONITORD_EXTERNAL_PORT``     | ``4124``                                 | ``opennebula-oned``       | External/published and internal port for the monitord (TCP and UDP) - it will also setup ``MONITORD_PORT``.              |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONED_INTERNAL_PORT``         | ``2634``                                 | ``opennebula-oned``       | Internal port for the main OpenNebula API (TLS).                                                                         |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONED_EXTERNAL_PORT``         | ``2633``                                 | ``opennebula-oned``       | External/published port for the main OpenNebula API.                                                                     |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEGATE_INTERNAL_PORT``      | ``5031``                                 | ``opennebula-gate``       | Internal port for the OneGate service (TLS).                                                                             |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEGATE_EXTERNAL_PORT``      | ``5030``                                 | ``opennebula-gate``       | External/published port for the OneGate service - it will also setup ``ONEGATE_PORT`` in ``opennebula-oned``.            |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEFLOW_INTERNAL_PORT``      | ``2475``                                 | ``opennebula-flow``       | Internal port for the OneFlow service (TLS).                                                                             |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_ONEFLOW_EXTERNAL_PORT``      | ``2474``                                 | ``opennebula-flow``       | External/published port for the OneFlow service.                                                                         |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_RESTART_POLICY``             | ``unless-stopped``                       |  all                      | `Container restart policy <https://docs.docker.com/config/containers/start-containers-automatically/>`_.                 |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SSH_EXTERNAL_PORT``          | ``22``                                   | ``opennebula-sshd``       | External/published SSH port.                                                                                             |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_PORT``     | ``80``                                   | ``opennebula-sunstone``   | External/published port for the Sunstone service (HTTP) - it will also setup ``SUNSTONE_PORT``.                          |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_TLS_PORT`` | ``443``                                  | ``opennebula-sunstone``   | External/published port for the Sunstone service (HTTPS) - it will also setup ``SUNSTONE_TLS_PORT``.                     |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_SUNSTONE_EXTERNAL_VNC_PORT`` | ``29876``                                | ``opennebula-sunstone``   | External/published and internal port for the Sunstone's VNC - it will also setup ``SUNSTONE_VNC_PORT``.                  |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_VOLUME_DATASTORES``          | ``opennebula_datastores``                | ``opennebula-oned`` |br|  | The value can be either a custom named volume (it must be precreated) or a path on the host - bind mount.                |
|                                       |                                          | ``opennebula-sshd``       |                                                                                                                          |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+

.. _container_reference_volumes:

Volumes and Data
----------------

The Front-end container defines a few implicit (anonymous) volumes and every time a new container is instantiated from the image, a few unnamed volumes will be created holding the container's data. This is done as a precaution to avoid losing important runtime data in the case someone realizes too late that the container is running without assigned persistent storage.

.. important::

   Always use named volumes!

.. note::

    Once the running container is removed (``docker rm`` or started with ``--rm``), these implicit volumes may be automatically deleted too! Usage of containers tends to create a lot of implicit (anonymous) volumes - we can check them with the command:

    .. prompt:: bash # auto

        # docker volume ls

    If we are sure that no data can be lost because we use only named volumes then a periodic cleanup can be done like this:

    .. prompt:: bash # auto

        # docker volume prune -f

This table describes directories in the container which are either implicit volumes, should be used as named volumes or are otherwise significant:

+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| Canonical |_| Volume |_| Name |_| [*]_          | Directory |_| path                      | Implicit                | Used |_| by                        |  Description                                                                                        |
+=================================================+=========================================+=========================+====================================+=====================================================================================================+
|                                                 | ``/var/lib/one/backups``                | YES                     |                                    |  OpenNebula stores backup files into this location.                                                 |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_backups_db``                       | ``/var/lib/one/backups/db``             | NO                      |                                    |  OpenNebula stores here sqldumps during ``onedb upgrade``.                                          |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_datastores``                       | ``/var/lib/one/datastores``             | YES                     | ``oned`` |br|                      |  OpenNebula's datastore for VM images.                                                              |
|                                                 |                                         |                         | ``sshd``                           |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_etcd``                             | ``/srv/one/etcd``                       | NO                      | ``etcd``                           |  Persistent storage for etcd.                                                                       |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_etcd_secrets``                     | ``/srv/one/etcd-secrets``               | NO                      | ``etcd`` |br|                      |  Persistent storage for etcd secrets (user password files).                                         |
|                                                 |                                         |                         | ``fireedge`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``mysqld`` |br|                    |                                                                                                     |
|                                                 |                                         |                         | ``oned`` |br|                      |                                                                                                     |
|                                                 |                                         |                         | ``oneflow`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``onegate`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``oneprovision`` |br|              |                                                                                                     |
|                                                 |                                         |                         | ``sunstone`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``sshd``                           |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_fireedge``                         | ``/var/lib/one/fireedge``               | YES                     | ``fireedge`` |br|                  |  Shared volume between FireEdge and OneProvision.                                                   |
|                                                 |                                         |                         | ``oneprovision``                   |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/var/log``                            | YES                     |                                    |  All system logs (**not recommended to share named volume with this location between containers**). |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_logs``                             | ``/var/log/one``                        | NO                      | ``oned`` |br|                      |  All OpenNebula logs (**this should be a named volume shared between all OpenNebula services**)     |
|                                                 |                                         |                         | ``scheduler`` |br|                 |                                                                                                     |
|                                                 |                                         |                         | ``oneflow`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``onegate`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``sunstone`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``fireedge`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``oneprovision``                   |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_mysql``                            | ``/var/lib/mysql``                      | YES                     | ``mysqld``                         |  Database directory with MySQL data.                                                                |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_auth``                    | ``/var/lib/one/.one``                   | YES                     | ``oned`` |br|                      |  Oneadmin's secret OpenNebula tokens.                                                               |
|                                                 |                                         |                         | ``scheduler`` |br|                 |                                                                                                     |
|                                                 |                                         |                         | ``oneflow`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``onegate`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``sunstone`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``fireedge`` |br|                  |                                                                                                     |
|                                                 |                                         |                         | ``oneprovision``                   |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_oneadmin_ssh``                     | ``/var/lib/one/.ssh``                   | YES                     | ``oned``                           |  Oneadmin's SSH directory.                                                                          |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/var/lib/one/.ssh-oneprovision``      | YES                     | ``oneprovision``                   |  Contains SSH key-pair for OneProvision.                                                            |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/srv/one``                            | YES                     |                                    |  Parent directory for various persistent data.                                                      |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
|                                                 | ``/srv/one/secret-tls``                 | NO                      | ``oned`` |br|                      |  TLS certificate (provided or generated) is stored here.                                            |
|                                                 |                                         |                         | ``sshd`` |br|                      |                                                                                                     |
|                                                 |                                         |                         | ``oneflow`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``onegate`` |br|                   |                                                                                                     |
|                                                 |                                         |                         | ``sunstone``                       |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_shared_vmrc``                      | ``/var/lib/one/sunstone_vmrc_tokens``   | NO                      |                                    |  Shared directory between Sunstone and FireEdge with temporary files.                               |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+
| ``opennebula_shared_tmp``                       | ``/var/tmp/sunstone``                   | NO                      | ``oned`` |br|                      |  Shared directory between oned and Sunstone needed to be upload local images through browser.       |
|                                                 |                                         |                         | ``sunstone``                       |                                                                                                     |
+-------------------------------------------------+-----------------------------------------+-------------------------+------------------------------------+-----------------------------------------------------------------------------------------------------+

.. [*] These volume names and mountpoints are recommended for use - the very same ones are utilized in the referential :ref:`multi-container deployment <container_deploy_multi>`.

.. note::

    The location of implicit volumes is adequate for single container deployment but, in some cases, they could become problematic in multi-container deployment if shared. The reason is simply that some directories are not needed or desired to be accessible from other containers. There could also be write conflicts (e.g., logs).

.. xxxxxxxxxxxxxxxxxxxxxxxx MARK THE END OF THE CONTENT xxxxxxxxxxxxxxxxxxxxxxxx

.. |_| unicode:: 0xA0
   :trim:

.. |br| raw:: html

   <br />

.. |onedocker_schema_bootstrap| image:: /images/onedocker-schema-bootstrap.svg
   :width: 600
   :align: middle
   :alt: Sequential diagram of the bootstrap process
