.. _container_custom:

================================================================================
Advanced Deployment Customizations
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

This page describes how to customize the containerized OpenNebula Front-end with

- :ref:`Custom TLS Certificate <container_custom_tls>`
- :ref:`Custom SSH Key to Access Nodes <container_custom_ssh>`
- :ref:`Custom OpenNebula Configuration <container_custom_conf>`
- :ref:`Container Bootstrap and Hooks <container_custom_hooks>`
- :ref:`Maintenance Mode <container_maintenance>`

.. _container_custom_tls:

Custom TLS Certificate
======================

If a new deployment is not provided with the custom TLS certificate, it generates its own **self-signed** one for the start. Such certificate is not for production use (users' browser will complain about it), but only for the evaluation.

To pass your own custom certificate, you need to store the TLS certificate and key in the directory on your host and configure and restart the deployment. Bootstrap process inside the container reconfigures all the services right before their start with the custom TLS certificate and key. All services are using the same TLS certificate.

Multi-container
---------------

You need to have your deployment already prepared with TLS-secured services. See the :ref:`simple deployment <container_deploy_multi>`.

Apply following steps inside your deployment (compose project) directory:

1. Save Certificates
^^^^^^^^^^^^^^^^^^^^

In the deployment (compose project) directory, place the certificate files into a precreated ``certs/`` subdirectory. For example use

- ``certs/cert.key`` for private key
- ``certs/cert.pem`` for certificate

2. Configure Deployment
^^^^^^^^^^^^^^^^^^^^^^^

Configure deployment with parameters containing absolute file names **inside the container** to the TLS key and certificate. The ``certs`` directory on your host is automatically passed into the container and mounted on ``/certs``. For (example) files above, you need to adjust your configuration in ``.env`` and to contain the paths to certificate and key

.. code::

    TLS_CERT=/certs/cert.pem
    TLS_KEY=/certs/cert.key

3. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, it must be first stopped. Otherwise, it can be directly started:

.. prompt:: bash # auto

    # docker-compose down
    # docker-compose up -d

Single-container
----------------

You need to have your (Docker/Podman) container runtime commands prepared with TLS-secured services. See the :ref:`simple deployment <container_deploy_single>`.

1. Save Certificates
^^^^^^^^^^^^^^^^^^^^

Create a dedicated subdirectory ``certs`` and put there TLS private key and certificate. For example use:

- ``certs/cert.key`` for private key
- ``certs/cert.pem`` for certificate

2. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, the single-container must be first terminated and restarted again with additional parameters. You need to have your Docker/Podman ``run`` command arguments used to run the previous deployment prepared!

First, destroy your current container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

And, start again the deployment with following **additional** arguments:

.. prompt:: bash # auto

   # docker run -d --privileged --restart=unless-stopped --name opennebula \
   ...
     -v "$(realpath ./certs):/certs:z,ro" \
     -e TLS_CERT='/certs/cert.pem' \
     -e TLS_KEY='/certs/cert.key' \
   ...
     $OPENNEBULA_IMAGE

.. _container_custom_ssh:

Custom SSH Key
==============

OpenNebula Front-end connects to the **hypervisor Nodes over SSH** to the remote ``oneadmin`` users, under which performs virtual machine management and monitoring operations. To be able to connect, the Front-end must have configured the SSH key pair and the public key part must be distributed across all the hypervisor Nodes. Read more in guide to :ref:`Configure Passwordless SSH <kvm_ssh>` for hypervisor Nodes.

If a new deployment is not provided with custom SSH key pair, it generates its own for the start. This one can be further used and deployed on the hosts or (for already existing hypervisor Nodes), you can pass your own to the OpenNebula Front-end. To pass your own SSH key pair, you need to store the relevant files into the dedicated directory on your host and configure and restart the deployment. Bootstrap process inside the container reconfigures the relevant services.

Multi-container
---------------

1. Save SSH Key Pair
^^^^^^^^^^^^^^^^^^^^

In the deployment (compose project) directory, put the SSH keys into a precreated ``ssh/`` subdirectory. For example use

- ``ssh/id_rsa`` for SSH private key
- ``ssh/id_rsa.pub`` for SSH public key

.. note::

   If using different names, their absolute file names inside the container must be now also in ``ONEADMIN_SSH_PRIVKEY`` and ``ONEADMIN_SSH_PUBKEY`` in ``.env`` before restarting the deployment. The ``ssh`` directory on your host is automatically passed into the container and mounted on ``/ssh``.

2. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, it must be first stopped. Otherwise, it can be directly started:

.. prompt:: bash # auto

    # docker-compose down
    # docker-compose up -d

Single-container
----------------

1. Save SSH Key Pair
^^^^^^^^^^^^^^^^^^^^

Create a dedicated subdirectory ``ssh`` and put the SSH keys there. For example use:

- ``ssh/id_rsa`` for SSH private key
- ``ssh/id_rsa.pub`` for SSH public key

2. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, the single-container must be first terminated and restarted again with additional parameters. You need to have your Docker/Podman ``run`` command arguments used to run previous deployment prepared!

First, destroy your current container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

And, start again the deployment with following **additional** arguments:

.. note::

   If using different names for SSH keys, their absolute file names inside the container must be set also in ``ONEADMIN_SSH_PRIVKEY`` and ``ONEADMIN_SSH_PUBKEY`` before restarting the deployment, otherwise, their setting is optional. The ``ssh`` directory on your host is passed into the container and mounted on ``/ssh``.

.. prompt:: bash # auto

   # docker run -d --privileged --restart=unless-stopped --name opennebula \
   ...
     -v "$(realpath ./ssh):/ssh:z,ro" \
     -e ONEADMIN_SSH_PRIVKEY='/ssh/id_rsa' \
     -e ONEADMIN_SSH_PUBKEY='/ssh/id_rsa.pub' \
   ...
     $OPENNEBULA_IMAGE

.. _container_custom_conf:

Custom OpenNebula Config.
=========================

On container start, the bootstrap script automatically applies a limited configuration of the OpenNebula services - configure inter-service connections and a set set of :ref:`image parameters <container_reference_params>` customized by the user. This doesn't cover all needs, as OpenNebula comes with several services and tens of :ref:`configuration files <cfg_files>`. Instead of copying the complete OpenNebula configurations into the containers, it's recommended to use the special configuration differential format for :ref:`onecfg tool <cfg_index>`, which describes individual changes in the files. Changes are then applied to the default stock configuration files in the container by :ref:`onecfg patch <cfg_patch>`.

.. important::

    It's not recommended to pass complete OpenNebula conf. files into the containers, but use the specialized configuration patching tool below!

1. Create Configuration Diff
----------------------------

In the deployment (compose project) directory, you put the configuration diff into the precreated ``config/`` directory. For single-container deployment, create the ``config/`` directory yourself in a suitable location. Create a configuration diff inside the directory in the :ref:`line format <cfg_diff_formats>` where one line describe a single change in a selected configuration file. For example, following example file ``config/onecfg_patch``:

.. code::

    /etc/one/sched.conf set SCHED_INTERVAL 10
    /var/lib/one/remotes/etc/vmm/kvm/kvmrc set SHUTDOWN_TIMEOUT 60
    /etc/one/oned.conf set DEFAULT_COST/CPU_COST 0.1
    /etc/one/oned.conf set DEFAULT_COST/MEMORY_COST 0.1
    /etc/one/oned.conf set DEFAULT_COST/DISK_COST 0.1

changes

- OpenNebula scheduling interval to 10 seconds,
- timeout for KVM virtual machines shutdown to 60 seconds and
- default cost of CPU, memory a disk for showback.

.. note::

    You need to be aware of the content of stock OpenNebula configuration files and the differential format!

Next steps are different for each deployment type.

Multi-container
---------------

2. Configure Deployment
^^^^^^^^^^^^^^^^^^^^^^^

Adjust your configuration inside the ``.env`` with the parameter ``OPENNEBULA_ONECFG_PATCH`` containing the absolute path **inside the container** to the diff file. The ``config/`` directory on your host is automatically passed into the container and mounted on ``/config``. In our case:

.. code::

    OPENNEBULA_ONECFG_PATCH=/config/onecfg_patch

3. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, it must be first stopped. Otherwise, it can be directly started:

.. prompt:: bash # auto

    # docker-compose down
    # docker-compose up -d

Single-container
----------------

2. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, the single-container must be first terminated and restarted again with additional parameters. You need to have your Docker/Podman ``run`` command arguments used to run previous deployment prepared!

First, destroy your current container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

And, start again the deployment with following **additional** arguments:

.. prompt:: bash # auto

   # docker run -d --privileged --restart=unless-stopped --name opennebula \
   ...
     -v "$(realpath ./config)":/config:z,ro \
     -e OPENNEBULA_ONECFG_PATCH="/config/onecfg_patch" \
   ...
     $OPENNEBULA_IMAGE

.. _container_custom_hooks:
.. _container_bootstrap:

Container Bootstrap and Hooks
=============================

When the container is started, the dedicated script inside (called `entrypoint <https://docs.docker.com/engine/reference/builder/#entrypoint>`__) is executed to prepare the environment. In our case the ``/frontend-entrypoint.sh`` will configure and enable the **bootstrap service** and pass control to the service manager `Supervisor <http://supervisord.org/>`__. Once Supervisor is running it will start the aforementioned bootstrap service. This service is executing the bootstrap script ``/frontend-bootstrap.sh`` where all the required services are configured and enabled including OpenNebula itself. We refer to this process as **container bootstrapping**. Any failure (e.g., due to a wrong custom configuration) will abort the bootstrap process and will lead to container's failed start.

The high-level overview of the startup process is described in the following sequence diagram:

|onedocker_schema_bootstrap|

The bootstrap process consists of the following significant steps:

#. Enter the entrypoint script ``/frontend-entrypoint.sh``
#. Prepare the root filesystem (create and cleanup directories)
#. Fix file permissions for the :ref:`significant paths (potential volumes) <container_reference_volumes>`
#. Configure service manager :ref:`Supervisor <container_supervisord>`
#. Configure and enable the bootstrap service
#. Exit entrypoint script and pass the execution to the service manager
#. Enter the bootstrap service started by the Supervisor and immediately execute the ``/frontend-bootstrap.sh``
#. *(optional)* Apply :ref:`custom OpenNebula Configuration <container_custom_conf>` (configured in ``OPENNEBULA_ONECFG_PATCH``)
#. *(optional)* Execute pre-bootstrap hook (configured in ``OPENNEBULA_PREBOOTSTRAP_HOOK``)
#. Configure and enable OpenNebula and related services (configured via ``OPENNEBULA_SERVICE``)
#. *(optional)* Execute post-bootstrap script (configured in ``OPENNEBULA_POSTBOOTSTRAP_HOOK``)
#. *(optional)* In maintenance mode, turn off autostart for services managed by Supervisor (configured in ``MAINTENANCE_MODE``)
#. Update the Supervisor and let it manage the lifetime of the services from now on

The :ref:`image parameters <container_reference_params>` affect the bootstrap process and control which services and how are deployed inside the container.

.. important::

    The boostrap process can be slightly modified by **hooks**, the optional custom shell scripts executed at the beginning or end of the bootstrap process. It's a powerful mechanism to customize the deployment beyond the capabilities offered by existing image configuration parameters, but should be used carefully as it might not be compatible with future OpenNebula versions!

1. Create Hook Script
---------------------

In the deployment (compose project) directory, put a hook shell script(s) into the precreated ``config/`` directory. For single-container deployment, create the ``config/`` directory yourself in a suitable location. Create a custom shell script(s) with executable permissions. For example, create following files with content relevant to your deployment:

- File ``config/pre-bootstrap-hook.sh``:

.. code::

    #!/bin/bash
    echo 'pre-bootstrap hook'

- File ``config/post-bootstrap-hook.sh``:

.. code::

    #!/bin/bash
    echo 'post-bootstrap hook'

Multi-container
---------------

2. Configure Deployment
^^^^^^^^^^^^^^^^^^^^^^^

Adjust your configuration inside the ``.env`` with the parameters containing the absolute path **inside the container** to the (relevant) bootstrap hook. You can opt to use just one of them or both. The ``config/`` directory on your host is automatically passed into the container and mounted on ``/config``. In our case:

.. code::

    OPENNEBULA_PREBOOTSTRAP_HOOK=/config/pre-bootstrap-hook.sh
    OPENNEBULA_POSTBOOTSTRAP_HOOK=/config/post-bootstrap-hook.sh

3. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, it must be first stopped. Otherwise, it can be directly started:

.. prompt:: bash # auto

    # docker-compose down
    # docker-compose up -d

Single-container
----------------

2. Restart Deployment
^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, the single-container must be first terminated and restarted again with additional parameters. You need to have your Docker/Podman ``run`` command arguments used to run previous deployment prepared!

First, destroy your current container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

And, start again the deployment with following **additional** arguments:

.. prompt:: bash # auto

   # docker run -d --privileged --restart=unless-stopped --name opennebula \
   ...
     -v "$(realpath ./config)":/config:z,ro \
     -e OPENNEBULA_PREBOOTSTRAP_HOOK="/config/pre-bootstrap-hook.sh" \
     -e OPENNEBULA_POSTBOOTSTRAP_HOOK="/config/post-bootstrap-hook.sh" \
   ...
     $OPENNEBULA_IMAGE

.. _container_maintenance:

Maintenance Mode
================

Container **maintenance mode** allows to start the container(s) in a state where all services inside are prepared and configured by the :ref:`bootstrap process <container_bootstrap>`, but their start is postponed (technically, all services are flagged not to automatically start). It's up to the user to start the individual services only when and if he needs. This mode is suitable for troubleshooting OpenNebula and encapsulated services, or for performing maintenance operations (e.g., database cleanup, check, or schema upgrade), which require the stopped services.

Maintenance mode is enabled by setting ``MAINTENANCE_MODE=yes`` :ref:`image parameter <container_reference_params>`.

Multi-container
---------------

Change your current working directory to the deployment (compose project) directory.

1. Stop Deployment
^^^^^^^^^^^^^^^^^^

First, stop your current deployment if it's running:

.. prompt:: bash # auto

    # docker-compose down

2. Reconfigure For Maintenance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Maintenance mode needs to be enabled in the deployment configuration. Put following configuration snippet into your ``.env``:

.. code::

    MAINTENANCE_MODE=yes

3. Start Deployment
^^^^^^^^^^^^^^^^^^^

Start the deployment by running:

.. prompt:: bash # auto

    # docker-compose up -d

All containers will start, but the services inside will be stopped.

4. Perform Maintenance
^^^^^^^^^^^^^^^^^^^^^^

List the running containers for your Docker Compose project. For example:

.. prompt:: bash # auto

    # docker-compose ps
                  Name                        Command               State                           Ports
    ------------------------------------------------------------------------------------------------------------------------------
    opennebula_opennebula-docker_1      /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-fireedge_1    /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-flow_1        /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 0.0.0.0:2474->2475/tcp, 2633/ ...
    opennebula_opennebula-gate_1        /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-guacd_1       /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-memcached_1   /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-mysql_1       /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-oned_1        /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 0.0.0.0:2 ...
    opennebula_opennebula-provision_1   /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-scheduler_1   /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...
    opennebula_opennebula-sshd_1        /frontend-bootstrap.sh   Up (unhealthy)   192.168.150.1:22->22/tcp, 2474/tcp, 2475/tcp, 2 ...
    opennebula_opennebula-sunstone_1    /frontend-bootstrap.sh   Up (unhealthy)   22/tcp, 2474/tcp, 2475/tcp, 2633/tcp, 2634/tcp, ...

and connect to those where you need to start services and proceed with any required maintenance operation.

**Example** below presents full terminal sample output with :ref:`listing services <container_supervisord>` status inside the containers, starting the MySQL server in one container and triggering the database consistency check via ``onedb fsck`` tool in different container:

1. Start MySQL service in container ``opennebula_opennebula-mysql_1``:

.. prompt:: bash # auto

    # docker exec -it opennebula_opennebula-mysql_1 /bin/bash
    [root@542c3a1375d3 /]# supervisorctl status
    crond                            STOPPED   Not started
    infinite-loop                    RUNNING   pid 158, uptime 0:11:35
    mysqld                           STOPPED   Not started
    mysqld-configure                 STOPPED   Not started
    mysqld-upgrade                   STOPPED   Not started
    supervisor-listener              STOPPED   Not started

    [root@542c3a1375d3 /]# supervisorctl start mysqld
    mysqld: started

    [root@542c3a1375d3 /]# exit

2. Trigger database consistency check in container ``opennebula_opennebula-oned_1``:

.. prompt:: bash # auto

    # docker exec -it opennebula_opennebula-oned_1 /bin/bash
    [root@6cc7ad7ead2d /]# supervisorctl status
    crond                            STOPPED   Not started
    infinite-loop                    RUNNING   pid 447, uptime 0:12:55
    opennebula                       STOPPED   Not started
    opennebula-configure             STOPPED   Not started
    opennebula-hem                   STOPPED   Not started
    opennebula-showback              STOPPED   Not started
    opennebula-ssh-add               STOPPED   Not started
    opennebula-ssh-agent             STOPPED   Not started
    opennebula-ssh-socks-cleaner     STOPPED   Not started
    stunnel                          STOPPED   Not started
    supervisor-listener              STOPPED   Not started

    [root@6cc7ad7ead2d /]# sudo -u oneadmin onedb fsck
    MySQL dump stored in /var/lib/one/mysql_opennebula-mysql_opennebula_2021-3-3_19:47:37.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0
    Total errors repaired: 0
    Total errors unrepaired: 0

    A copy of this output was stored in /var/log/one/onedb-fsck.log

    [root@6cc7ad7ead2d /]# exit

5. Exit Maintenace Mode
^^^^^^^^^^^^^^^^^^^^^^^

Stop your deployment

.. prompt:: bash # auto

    # docker-compose down

and remove ``MAINTENANCE_MODE=yes`` added into the deployment configuration in step 1 above. When changes for maintenance mode are reverted, start the deployment again to bootstrap and automatically start all services as before.

Single-container
----------------

1. Restart Deployment in Maintenance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the deployment is already running, the single-container must be first terminated and restarted again with an additional parameter. You need to have your Docker/Podman ``run`` command arguments used to run previous deployment prepared!

First, destroy your current container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

And, start again the deployment with following **additional** argument:

.. prompt:: bash # auto

   # docker run -d --privileged --restart=unless-stopped --name opennebula \
   ...
     -e MAINTENANCE_MODE='yes' \
   ...
     $OPENNEBULA_IMAGE

2. Perform Maintenance
^^^^^^^^^^^^^^^^^^^^^^

Connect inside the container and run a shell:

.. prompt:: bash # auto

    # docker exec -it opennebula /bin/bash

Proceed with any required maintenance operation. Example below presents full terminal sample output with :ref:`listing services <container_supervisord>` status inside the container, starting the MySQL server and triggering the database consistency check via ``onedb fsck`` tool:

.. prompt:: bash # auto

    [root@cc2e7762cd5e /]# supervisorctl status
    containerd                       STOPPED   Not started
    crond                            STOPPED   Not started
    docker                           STOPPED   Not started
    infinite-loop                    RUNNING   pid 983, uptime 0:00:04
    memcached                        STOPPED   Not started
    mysqld                           STOPPED   Not started
    mysqld-configure                 STOPPED   Not started
    mysqld-upgrade                   STOPPED   Not started
    oneprovision-sshd                STOPPED   Not started
    opennebula                       STOPPED   Not started
    opennebula-configure             STOPPED   Not started
    opennebula-fireedge              STOPPED   Not started
    opennebula-flow                  STOPPED   Not started
    opennebula-gate                  STOPPED   Not started
    opennebula-guacd                 STOPPED   Not started
    opennebula-hem                   STOPPED   Not started
    opennebula-httpd                 STOPPED   Not started
    opennebula-novnc                 STOPPED   Not started
    opennebula-scheduler             STOPPED   Not started
    opennebula-showback              STOPPED   Not started
    opennebula-ssh-add               STOPPED   Not started
    opennebula-ssh-agent             STOPPED   Not started
    opennebula-ssh-socks-cleaner     STOPPED   Not started
    sshd                             STOPPED   Not started
    stunnel                          STOPPED   Not started
    supervisor-listener              STOPPED   Not started

    [root@cc2e7762cd5e /]# supervisorctl start mysqld
    mysqld: started

    [root@cc2e7762cd5e /]# sudo -u oneadmin onedb fsck
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2021-3-2_21:37:31.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0
    Total errors repaired: 0
    Total errors unrepaired: 0

    A copy of this output was stored in /var/log/one/onedb-fsck.log

3. Exit Maintenace Mode
^^^^^^^^^^^^^^^^^^^^^^^

When maintenance is over, you need to terminate the container:

.. prompt:: bash # auto

    # docker stop opennebula
    # docker rm opennebula

and start container again **without** extra ``MAINTENANCE_MODE=yes`` image parameter introduced in step 1 above. Without the extra maintenance parameter, container will bootstrap and automatically start all services as before.

.. |onedocker_schema_bootstrap| image:: /images/onedocker-schema-bootstrap.svg
   :width: 600
   :align: middle
   :alt: Sequential diagram of the bootstrap process
