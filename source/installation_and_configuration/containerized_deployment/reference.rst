.. _container_reference:

================================================================================
Troubleshooting and Reference
================================================================================

This page contains complementary information to :ref:`the official OpenNebula container image and its deployment <container_deployment>`.

:ref:`The reference section <container_reference>` below is the definitive guide to the container image internals, parameters and usage.

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

.. [*] Service as in the value of ``OPENNEBULA_SERVICE``

.. important::

    It is important to distinguish the difference between the internal port (as in the table) and external (published) ports - majority of the internal ports are hardwired and cannot be moved to another port number (exceptions are in the next info box).

    If one wants to avoid port conflicts with the already bound ports on the host then change to the external (published) port is needed. In a few cases the container itself also must be informed about the changes and a relevant image parameter thus must reflect the same value.

.. note::

    The following table showcases how to utilize different ports for different services. Notice that in the case of **monitord** and **Sunstone VNC** both sides of expression must be modified not just the left (published) portion.

+------------------------+------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------+
| Port mapping examples  | Affected Parameter |_| / |_| Service           |                     Note                                                                                                                  |
+========================+================================================+===========================================================================================================================================+
| ``-p 2222:22``         |                                                | Change to the SSH port has consequences which are described in :ref:`the SSH service prerequisite <container_ssh>`.                       |
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
| ``MYSQL_DATABASE``                   |                        | ``opennebula``           | Name of the OpenNebula's database stored in the MySQL server (it will be created).                                       |
+--------------------------------------+                        +--------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``MYSQL_USER``                       |                        | ``oneadmin``             | User allowed to access the OpenNebula's database (it will be created).                                                   |
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

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_SERVICE``. Regardless of YES/NO - only the listed services are actually affected by the parameter (otherwise all are affected).
.. [*] ``OPENNEBULA_SERVICE`` must be defined every time **only** if it is intended as multi-container setup otherwise it defaults to ``all`` and therefore will start *all-in-one* deployment in each container...
.. [*] This variable can be still useful even when ``DIND_ENABLED`` is false because the host's Docker socket can be bind-mounted inside the container.
.. [*] ``MONITORD_PORT`` must also match the internal port - it is an implementation detail which will require to change both the external (published) and internal port.
.. [*] ``MYSQL_PASSWORD`` is not required when deployed in single container (*all-in-one*).
.. [*] ``SUNSTONE_VNC_PORT`` must also match the internal port - it is an implementation detail which will require to change both the external (published) and internal port.

.. note::

    The next table describes another set of image parameters but their usability is only in multi-container deployment for which OpenNebula provides proper ``docker-compose.yml`` and ``default.env``.

    They are listed here only for completeness and for users determined to replace some of our containers with their own servers (custom MySQL, host dockerd etc.).

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

.. [*] In this column the value **YES** signals that parameter is mandatory for one or more services which are determined by listing the values of ``OPENNEBULA_SERVICE``. Regardless of YES/NO - only the listed services are actually affected by the parameter (otherwise all are affected).
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

.. [*] These volume names and mountpoints are recommended to use - the very same are utilized in the referential :ref:`docker-compose deployment <container_deploy_multi>`.

.. note::

    Locations of implicit volumes are adequate for single container deployment but in some cases they could become problematic in multi-container deployment if shared... The reason is simply due to the fact that some directories are not needed or desired to be accessible from other containers. There could also be write conflicts (logs for example).

.. _reference_deploy_params:

Deploy parameters for docker-compose
------------------------------------

.. important::

    Do not mistake these variables with the image parameters - **these are recognized only inside the official OpenNebula's docker-compose.yml**!

+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
|                  Name                 | Default                                  | Container                 |                     Description                                                                                          |
+=======================================+==========================================+===========================+==========================================================================================================================+
| ``DEPLOY_OPENNEBULA_IMAGE_NAME``      | ``opennebula/opennebula`` **OR**         | all                       | OpenNebula image name - the actual default value will depend on the CE/EE version of the image.                          |
|                                       | ``enterprise.opennebula.io/opennebula``  |                           |                                                                                                                          |
+---------------------------------------+------------------------------------------+---------------------------+--------------------------------------------------------------------------------------------------------------------------+
| ``DEPLOY_OPENNEBULA_IMAGE_TAG``       | ``5.13``                                 | all                       | OpenNebula image tag.                                                                                                    |
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

.. _reference_supervisord:

Supervisor
----------

`Supervisor <http://supervisord.org/>`_ is a process manager used inside the OpenNebula Front-end container as a manager of services. Once :ref:`the bootstrap script <container_bootstrap>` is done with the setup of the container - supervisord process will take over. It has a responsibility for the lifetime of (almost) all the processes inside the running container.

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

.. _container_appendix:

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

You can access the OpenNebula Front-end's container(s) APIs from a remote system granted `the OpenNebula CLI tools <https://docs.opennebula.io/5.13/operation/references/cli.html>`_ are installed there.

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

    In the following examples replace the ``${OPENNEBULA_HOST}`` with the actual domain name or IP address.

Setting up the OpenNebula API endpoint exposed over HTTPS (``TLS_PROXY_ENABLED=yes``) and on the typical port ``2633``:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="https://${OPENNEBULA_HOST}:2633"

Alternatively we could access the non-TLS endpoint (``TLS_PROXY_ENABLED=no``) over plain HTTP:

.. prompt:: bash $ auto

    $ export ONE_XMLRPC="http://${OPENNEBULA_HOST}:2633"

And the same goes for the OneFlow API (``TLS_PROXY_ENABLED=yes``):

.. prompt:: bash $ auto

    $ export ONEFLOW_URL="https://${OPENNEBULA_HOST}:2474"

Or over plain HTTP (``TLS_PROXY_ENABLED=no``):

.. prompt:: bash $ auto

    $ export ONEFLOW_URL="http://${OPENNEBULA_HOST}:2474"

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
    -e OPENNEBULA_HOST=${HOSTNAME} \
    -e OPENNEBULA_SSH_HOST=${HOSTNAME} \
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

.. |br| raw:: html

   <br />

.. |onedocker_schema_bootstrap| image:: /images/onedocker-schema-bootstrap.svg
   :width: 600
   :align: middle
   :alt: Sequential diagram of the bootstrap process
