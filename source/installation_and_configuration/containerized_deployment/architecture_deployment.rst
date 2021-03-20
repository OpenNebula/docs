.. _container_deployment:

================================================================================
Architecture and Simple Deployment
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

This page describes how to deploy containerized OpenNebula Front-end.

.. _container_requirements:

Requirements
================================================================================

You need a physical or virtual host with a recommended operating system, one of the following container runtimes, and optional tool:

**Docker** (recommended)

- :ref:`dedicated IP address or relocate host SSH to non-default port <container_ssh>`
- x86-64 Linux host with CentOS/RHEL, Debian, or Ubuntu (or compatible)
- **Docker** version 18.06.0 (or newer)
- optionally **docker-compose** version 1.27.4 (or newer, must support specification `format 3.7 <https://docs.docker.com/compose/compose-file/>`__)

**Podman**

- :ref:`dedicated IP address or relocate host SSH to non-default port <container_ssh>`
- x86-64 Linux host with CentOS/RHEL 8
- **Podman** version 2.0 (or newer)
- optionally **podman-compose** version 0.1.7-2.git20201120 (or newer) from `EPEL <https://fedoraproject.org/wiki/EPEL>`__ (Extra Packages for Enterprise Linux)
- recommended ``root`` user to run privileged containers and bind on privileged ports (22, 80, 443)

.. warning::

   Unsupported features:

   - federated and HA deployments,
   - shared datastores (NFS, qcow2, Ceph, LVM, ...), only SSH-based available
   - migration of existing Front-end deployment installed from packages into containers,
   - in **unprivileged mode** - Exports from following Marketplaces - :ref:`Docker Hub <market_dh>`, :ref:`Linux Containers <market_linux_container>`, :ref:`TurnKey Linux <market_turnkey_linux>`
   - in **unprivileged mode** - :ref:`Creating an image based on a Dockerfile <dockerfile>`
   - in **rootless Podman** - Deployment on privileged ports (22, 80, 443)

.. _container_architecture:

Architecture
================================================================================

Complete OpenNebula Front-end with all services and their dependencies is running within the supported container runtimes from the official container image (``opennebula``), the services and other required processes are confined inside the container(s). The inner container startup and lifecycle is controlled by the :ref:`bootstrap process <container_bootstrap>`, which can be customized and adjusted for user needs via the :ref:`image parameters <reference_params>`. Container(s) communicate with each other over the private container network. End-users interact with services running inside only via a limited set of :ref:`exposed IP ports <reference_ports>`.

Following OpenNebula Front-end containerized deployment types are supported no matter the container runtime:

1. **multi-container** (the composition of containers, microservice pattern)
2. **single-container** (all-in-one container)

Multi-container (recommended)
-----------------------------

In multi-container deployment type, each group of OpenNebula Front-end services is running in their own dedicated container.

.. TODO - update image

|container_multi|

This approach vastly improves the security of the deployment, while preserving the simplicity to run. OpenNebula comes with a referential deployment descriptor for multi-container setup in a (Docker) Compose format and requires corresponding tools to be installed for the particular container runtime - Docker Compose for Docker or Podman Compose for Podman.

Single-container
----------------

.. warning::

    This type is recommended only for **evaluation or simple usage**.

In the single-container deployment type, also called the *all-in-one*, all OpenNebula Front-end services are running inside only a single one container.

.. TODO - update image

|onedocker_schema_all_in_one|

Using the single-container type is easy and the most straightforward way how to start with containerized OpenNebula Front-end. The security of such deployment is on a similar level as the traditional way of installation, when all services are installed on a single host without any separation among the OpenNebula services themselves. Management and customization operations of the container deployment are done directly via the container runtime commands and vast set of (configuration) environment variables, which might be confusing and hard to maintain during the time (esp. when doing the upgrade to the next major/minor version).

.. _container_install:

Step 1. Install Container Runtime
================================================================================

.. important::

    SELinux can block some operations of the container runtime. If the administrator isn't experienced in SELinux tuning, **it's recommended to disable this functionality to avoid unexpected failures**. You can enable SELinux anytime later when you have the installation working. How to do both is described in the :ref:`SELinux Appendix <appendix_selinux>`.

Docker (recommended)
--------------------

1. Install `Docker <https://docs.docker.com/get-docker/>`__ by following the installation instructions for `CentOS <https://docs.docker.com/engine/install/centos/>`__, `Debian <https://docs.docker.com/engine/install/debian/>`__, or `Ubuntu <https://docs.docker.com/engine/install/ubuntu/>`__.

2. (Optional) Install Docker Compose tool for multi-container deployment

.. prompt:: bash # auto

    # curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    # chmod +x /usr/bin/docker-compose

Podman
------

.. note::

    Containerized deployment on Podman is certified only on CentOS/RHEL 8.

1. Install Podman on CentOS/RHEL 8:

.. prompt:: bash # auto

    # dnf module install -y container-tools

2. (Optional) Install Podman Compose for multi-container deployment

**CentOS 8**

.. prompt:: bash # auto

    # dnf install -y epel-release
    # dnf install -y podman-compose

**RHEL 8**

.. prompt:: bash # auto

    # rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    # dnf install -y podman-compose

.. important::

    To simplify the documentation, all command and shell snippets below present the usage only with Docker commands. In almost all cases, the same arguments will work with analogous Podman commands - ``podman`` or ``podman-compose`` instead of ``docker`` or ``docker-compose``. There will be comments in places where Podman (Compose) diverge from Docker (Compose), or when they lack certain features.

.. _container_ssh:

Step 2. Reconfigure Host SSH
================================================================================

Containerized OpenNebula Front-end comes with the **integrated OpenSSH server**, which provides access to datastores both for the Front-end and hypervisor Nodes. OpenNebula is **not yet ready** to be able to directly connect to the SSH server on Front-end relocated to a different port. The integrated OpenSSH server (port 22) will clash with the OpenSSH server (port 22) running on your host, which is used for the host management operations. This is expected to be improved in the future version to provide a hassle-free experience, but right now requires an extra step to prepare the host itself.

.. important::

   Carefully consider the most suitable approach below for your environment!

One of the following options **need to be selected and applied**:

.. _container_ssh_ip:

Option A. Dedicated IP address for OpenNebula (recommended)
-----------------------------------------------------------

Recommended option is to allocate and configure your host with the additional IP address, which will be dedicated only for the containerized OpenNebula deployment. The host SSH server will run on your main host IP address and the OpenNebula's SSH server will run only on the dedicated IP address. Both running on the same default ports 22, but different IPs.

|container_ssh1|

You need to proceed with the following actions:

1. **Allocate new IP address** and configure it on your host. The setup is platform-specific and out of the scope of this guide. Check the official documentation of your operating systems, e.g. `CentOS/RHEL <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_networking>`__, `Debian <https://wiki.debian.org/NetworkConfiguration>`__,  `Ubuntu <https://ubuntu.com/server/docs/network-configuration>`__.

2. Host **OpenSSH server must be reconfigured** not use (bind to) the new IP address (by default server works on all configured addresses). Edit ``/etc/ssh/sshd_config`` and update the ``ListenAddress`` with your main IP address, **distinct to the newly allocated one for OpenNebula**. For example:

.. code::

    ...
    ListenAddress 192.168.10.1
    ...

3. **Restart the host OpenSSH** server to apply changes:

.. prompt:: bash # auto

    # service sshd restart

.. important::

    After the OpenSSH server restart and before closing any your current terminal session to the host, validate in a different terminal that the restarted host SSH works as expected and you can still connect to the host! You could end up with no way to connect the host back!

4. Dedicated IP address needs to be configured in next :ref:`Step 4. Deploy OpenNebula Front-end <container_deploy>` (:ref:`multi-container <container_deploy_multi>`, :ref:`single-container <container_deploy_single>`)!

.. _container_ssh_relocate:

Option B. Relocate host SSH to different port
---------------------------------------------

The easiest option is to relocate host SSH server to a different port (e.g., 2222) which will be used for a host management operations. Containerized OpenNebula Front-end will then use the default port.

|container_ssh2|

1. On **SELinux enabled hosts**, you need to allow the usage of a different port by the host OpenSSH server. For example:

.. prompt:: bash # auto

    # semanage port -a -t ssh_port_t -p tcp 2222

2. Host **OpenSSH server must be reconfigured** to listen on the different port. Edit ``/etc/ssh/sshd_config`` and update the ``Port`` with the selected management port. Make sure that only one occurrence of directive ``Port`` is set/uncommented! For example:

.. code::

    ...
    Port 2222
    ...

3. **Restart the host OpenSSH** server to apply the changes:

.. prompt:: bash # auto

    # service sshd restart

.. important::

    After the OpenSSH server restart and before closing any of your current terminal sessions to the host, validate in different terminal that the restarted host SSH works as expected and you can still connect to the host! You could end up with no way to connect the host back! The new port must be specified as an argument to the SSH client, for example:

    .. prompt:: bash $ auto

        $ ssh -p 2222 myhost.example.com

.. _container_ssh_nodes:

Option C. Reconfigure nodes to connect to different port
--------------------------------------------------------

If approaches above are not possible, the last (documented) option proposes to relocate OpenNebula integrated SSH server port and reconfigure all current and future hypervisor Nodes to use a related SSH port **only** when connecting back to the OpenNebula Front-end.

|container_ssh3|

Following changes are required for your current and future hypervisor Nodes:

1. Decide **hostname/IP and port** on which OpenNebula Front-end's integrate SSH server will be available to the hypervisor Nodes (can be different to the hostname/IP used for OpenNebula end-users!). Needs to be configured also in next :ref:`Step 4. Deploy OpenNebula <container_deploy>`!

.. note::

   If there are no existing hypervisor Nodes to connect, rest point(s) can be skipped now and applied on new Nodes later.

2. Login the hypervisor Nodes (they must have preinstalled OpenNebula node package in a version corresponding to the OpenNebula Front-end version) and **update the SSH client** configuration for user ``oneadmin`` in ``/var/lib/one/.ssh/config``. Put following snippet at the very beginning and replace example values ``one.example.com`` and port ``2222`` with network parameters selected in previous point.

**CentOS/RHEL 7**, **Debian 9** and **Ubuntu 16.04**:

.. code::

    Host one.example.com
      Port 2222

(and ensure the OpenNebula Front-end's host SSH key is in the trusted SSH known keys)

**Rest newer platforms**:

.. code::

    Host one.example.com
      StrictHostKeyChecking accept-new
      Port 2222

Needs to be deployed on all hypervisor Nodes, no other changes are necessary.

3. Selected port  needs to be configured in the next :ref:`Step 4. Deploy OpenNebula Front-end <container_deploy>` (:ref:`multi-container <container_deploy_multi>`, :ref:`single-container <container_deploy_single>`)!

.. _container_image:

Step 3. Get Container Image
================================================================================

OpenNebula image is built as a standard OCI container image with variants for the **Enterprise** and **Community Editions**, each hosted separately. It's developed with compatibility with both Docker and Podman, single-container and multi-container deployments in mind.

.. note::

   There is only a single one image with all Front-end services and their dependencies preinstalled for all types of supported deployments!

Repeat the same approach below to update to the newer image build or to get the newer OpenNebula releases.

Enterprise Edition
------------------

OpenNebula **Enterprise Edition** is provided for customers with an active subscription. The container images for major, minor, and maintenance releases are available only in a private enterprise repository (container registry) and only accessible by customers. To access the repository, you should have received an authentication ``token`` (in format ``username:password``), which is the same for both traditional :ref:`package repositories <repositories>` and container registry.

Download the image to your container runtime in 2 simple steps:

1. **Login** to the customer registry `enterprise.opennebula.io <https://enterprise.opennebula.io>`__ with your customer *username* and *password*:

.. prompt:: bash # auto

    # docker login enterprise.opennebula.io
    Username: *****
    Password: ***************
    Login Succeeded

(required only before very first download)

2. **Download** the current version of image to your host:

.. prompt:: bash # auto

    # docker pull enterprise.opennebula.io/opennebula:5.13.85
    5.13: Pulling from opennebula
    14d5f30b982f: Pull complete
    56fd5a76ed9f: Pull complete
    Digest: sha256:abf26354b99485e7836370c3ef7249ea68ffee4bbc5e38381029f458d0be80a7
    Status: Downloaded newer image for enterprise.opennebula.io/opennebula:5.13
    enterprise.opennebula.io/opennebula:5.13

Community Edition
-----------------

OpenNebula Community Edition is a free and public version, which offers the full functionality of the Cloud Management Platform. It's published on the `Docker Hub <https://hub.docker.com/r/opennebula/opennebula>`__, the most popular hosted container registry, and can be fetched simply by running the following command:

.. prompt:: bash # auto

    # docker pull docker.io/opennebula/opennebula:5.13.85

.. _container_deploy:

Step 4. Deploy OpenNebula Front-end
================================================================================

There are 2 types of supported deployments, **multi-container** and **single-container** on Docker and Podman. The multi-container deployment is recommended for production/serious usage, the single-container deployment is easier and suitable for learning, quick evaluation, and simple usage. For new users, it's always good to start with the single-container first to learn and move to multi-container later.

Each deployment type is documented in variants with

- **TLS-secured services** (recommended) with all public OpenNebula services secured by self-signed (default) or custom TLS certificate,
- **insecure services** where all services are directly exposed without any encryption.

Continue to the deployment guide for the selected type below:

- :ref:`multi-container <container_deploy_multi>`
- :ref:`single-container <container_deploy_single>`

.. _container_deploy_multi:

Multi-container (recommended)
-----------------------------

Multi-container deployment is managed by the **Docker Compose** or **Podman Compose** tools. OpenNebula provides an archive with a deployment descriptor (file ``docker-compose.yml``), default parameters, and configuration directories to use by these tools. The deployment archive needs to be downloaded, configured with site-specific parameters and passed to deployment tools to start.

A. Get Deployment Archive
^^^^^^^^^^^^^^^^^^^^^^^^^

.. important::

    Deployment archive is **specific for each OpenNebula edition and version**. When updating the existing containerized deployment with the newer OpenNebula release, it's needed to **redownload again and use the deployment archive** for the corresponding OpenNebula version.

**Enterprise Edition**

Update *username* and interactively pass *password* from your customer ``token`` to the following command:

.. prompt:: bash # auto

    # wget --user=XXXX --ask-password https://enterprise.opennebula.io/packages/opennebula-5.13.85/container/docker-compose-opennebula.tar.gz
    # tar -xvf docker-compose-opennebula.tar.gz
    # cd opennebula/

**Community Edition**

.. prompt:: bash # auto

    # wget https://downloads.opennebula.io/packages/opennebula-5.13.85/container/docker-compose-opennebula.tar.gz
    # tar -xvf docker-compose-opennebula.tar.gz
    # cd opennebula/

B. Configure Deployment
^^^^^^^^^^^^^^^^^^^^^^^

It's **highly recommended NOT to modify** any of the provided files in the deployment (compose project) directory, which comes from the deployment archive. As new OpenNebula releases require to use of new deployment archives, such an approach would make your upgrades difficult. Create a new dedicated configuration file ``.env`` (which is loaded on deployment start) and **put inside all own customizations** with

- :ref:`image parameters <reference_params>` (to override those in ``default.env``),
- :ref:`deployment parameters <reference_deploy_params>` (to override those in ``docker-compose.yml``).

**Every deployment needs some minimal configuration, set the passwords and IP addresses.**

In the deployment directory ``opennebula/``, create the following configuration file ``.env`` with the bare minimum to run OpenNebula Front-end:

Set Image Parameters
####################

.. note::

    For insecure deployment (without TLS), append also following snippet into your ``.env``.

    .. code::

        SUNSTONE_HTTPS_ENABLED=no

Create file ``.env`` with the following example content and adapt to your environment:

.. code::

    OPENNEBULA_HOST=one.example.com
    OPENNEBULA_SSH_HOST=one.example.com
    ONEADMIN_PASSWORD=changeme123

where is

- ``OPENNEBULA_HOST`` - hostname/IP which will be used by end-users to access Front-end
- ``OPENNEBULA_SSH_HOST`` - hostname/IP to connect to the integrated SSH server, used by hypervisor Nodes (defaults to ``OPENNEBULA_HOST``)
- ``ONEADMIN_PASSWORD`` - **initial (only)** password for OpenNebula user ``oneadmin``

See more image configuration options in :ref:`reference <reference_params>`.

Set Deployment Parameters
#########################

Into configuration file ``.env`` created above append following additional parameters. Please note the required parameters are **different for each approach you have selected** in :ref:`Step 2. Reconfigure Host SSH <container_ssh>`.

.. note::

    For insecure deployment (without TLS), append also following snippet into your ``.env``.

    .. code::

        DEPLOY_ONED_INTERNAL_PORT=2633
        DEPLOY_ONEGATE_INTERNAL_PORT=5030
        DEPLOY_ONEFLOW_INTERNAL_PORT=2474

- Option :ref:`A. Dedicated IP address for OpenNebula <container_ssh_ip>` - append into ``.env`` the dedicated IP address of your OpenNebula Front-end. It's possible (but not required) to configure integrated SSH and the rest of Front-end services independently. For example:

.. code::

    DEPLOY_BIND_ADDR=192.168.10.3
    DEPLOY_BIND_SSH_ADDR=192.168.10.2

where is

  - ``DEPLOY_BIND_ADDR`` - dedicated IP address for (most) **Front-end** services
  - ``DEPLOY_BIND_SSH_ADDR`` - dedicated IP address for **integrated SSH** server (can be same as ``DEPLOY_BIND_ADDR``)

- Option :ref:`B. Relocate host SSH to different port <container_ssh_relocate>` - no additional deployment configuration required.

- Option :ref:`C. Reconfigure Nodes to connect to different port <container_ssh_nodes>` - append into ``.env`` the port of the OpenNebula integrated SSH server, on which will available for hypervisor Nodes to connect back to the Front-end. For example:

.. code::

    DEPLOY_SSH_EXTERNAL_PORT=2222

where is

  - ``DEPLOY_SSH_EXTERNAL_PORT`` - port on host on which OpenNebula integrated SSH server will be exposed

C. Start Deployment
^^^^^^^^^^^^^^^^^^^

Inside the deployment (compose project) directory ``opennebula/``, start the containerized OpenNebula Front-end by following command:

.. prompt:: bash # auto

    # docker-compose up -d

.. hint::

    To monitor the deployment :ref:`bootstrap process <container_bootstrap>` use following command to watch the logs (not supported with Podman Compose):

    .. prompt:: bash # auto

        # docker-compose logs -f

    On the very first start or for troubleshooting purposes, it might come in handy to run the deployment in the foreground. In this mode, you'll see bootstrap logs directly on your terminal, you can terminate the whole deployment by sending ``Control+C``, or the complete deployment terminates automatically in case of any single failure. Try:

    .. prompt:: bash # auto

        # docker-compose up --abort-on-container-exit

.. note::

    If you already use Sunstone over HTTPS and decide to change to HTTP-only later (or vice versa), you might experience issues to login into Sunstone. To fix the problem, drop the browser cookies for the Sunstone URL and try again.

D. Stop Deployment (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When needed, stop the deployment by command:

.. prompt:: bash # auto

    # docker-compose down

The default settings ensure the individual deployment containers are **automatically restarted** on their failure. The complete deployment is automatically started on server boot with Docker, but on Podman the :ref:`extra steps <appendix_podman>` must be taken.

.. _container_deploy_single:

Single-container
----------------

Single-container (*all-in-one*) deployment is the most straightforward and simple way to run OpenNebula Front-end in a single container. In such case all needed services are running together in the same process space, communicate simply over localhost and the local filesystem.

A. Start Deployment
^^^^^^^^^^^^^^^^^^^

.. note::

    If you already use Sunstone over HTTPS and decide to change to HTTP-only later (or vice versa), you might experience issues to login into Sunstone. To fix the problem, drop the browser cookies for the Sunstone URL and try again.

Based on selected approach in :ref:`Step 2. Reconfigure Host SSH <container_ssh>` update one of the following command examples with required extra parameters.

- Option :ref:`A. Dedicated IP address for OpenNebula <container_ssh_ip>` - take and **customize** (see instructions below) one of the examples below:

+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
| TLS-secured Services                                                          | Insecure Services                                                             |
+===============================================================================+===============================================================================+
| .. prompt:: bash # auto                                                       | .. prompt:: bash # auto                                                       |
|                                                                               |                                                                               |
|    # docker run -d --privileged --restart=unless-stopped \                    |    # docker run -d --privileged --restart=unless-stopped \                    |
|      --name opennebula \                                                      |      --name opennebula \                                                      |
|      -p 192.168.10.2:22:22 \                                                  |      -p 192.168.10.2:22:22 \                                                  |
|      -p 192.168.10.3:80:80 \                                                  |      -p 192.168.10.3:80:80 \                                                  |
|      -p 192.168.10.3:443:443 \                                                |      \                                                                        |
|      -p 192.168.10.3:2474:2475 \                                              |      -p 192.168.10.3:2474:2474 \                                              |
|      -p 192.168.10.3:2633:2634 \                                              |      -p 192.168.10.3:2633:2633 \                                              |
|      -p 192.168.10.3:4124:4124 \                                              |      -p 192.168.10.3:4124:4124 \                                              |
|      -p 192.168.10.3:4124:4124/udp \                                          |      -p 192.168.10.3:4124:4124/udp \                                          |
|      -p 192.168.10.3:5030:5031 \                                              |      -p 192.168.10.3:5030:5030 \                                              |
|      -p 192.168.10.3:29876:29876 \                                            |      -p 192.168.10.3:29876:29876 \                                            |
|      -e OPENNEBULA_HOST=one.example.com \                                     |      -e OPENNEBULA_HOST=one.example.com \                                     |
|      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |
|      -e ONEADMIN_PASSWORD=changeme123 \                                       |      -e ONEADMIN_PASSWORD=changeme123 \                                       |
|      -e DIND_ENABLED=yes \                                                    |      -e DIND_ENABLED=yes \                                                    |
|      \                                                                        |      -e SUNSTONE_HTTPS_ENABLED=no \                                           |
|      -v opennebula_db:/var/lib/mysql \                                        |      -v opennebula_db:/var/lib/mysql \                                        |
|      -v opennebula_datastores:/var/lib/one/datastores \                       |      -v opennebula_datastores:/var/lib/one/datastores \                       |
|      -v opennebula_srv:/srv/one \                                             |      -v opennebula_srv:/srv/one \                                             |
|      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |
|      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |
|      -v opennebula_etcd:/srv/one/etcd \                                       |      -v opennebula_etcd:/srv/one/etcd \                                       |
|      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |
|      -v opennebula_logs:/var/log \                                            |      -v opennebula_logs:/var/log \                                            |
|      $OPENNEBULA_IMAGE                                                        |      $OPENNEBULA_IMAGE                                                        |
+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+

Carefully replace following occurrences with

  - ``192.168.10.3`` - your dedicated IP address for OpenNebula Front-end
  - ``192.168.10.2`` - your dedicated IP address for integrated SSH server (can be same as above)
  - ``one.example.com`` - hostname/IP which will be used by end-users to access Front-end (and SSH)
  - ``changeme123`` - custom initial password for OpenNebula user ``oneadmin``
  - ``$OPENNEBULA_IMAGE`` - substitute

    - for **Enterprise Edition** with ``enterprise.opennebula.io/opennebula:5.13.85``
    - for **Community Edition** with ``docker.io/opennebula/opennebula:5.13.85``

- Option :ref:`B. Relocate host SSH to different port <container_ssh_relocate>` - take and **customize** (see instructions below) one of the examples below:

+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
| TLS-secured Services                                                          | Insecure Services                                                             |
+===============================================================================+===============================================================================+
| .. prompt:: bash # auto                                                       | .. prompt:: bash # auto                                                       |
|                                                                               |                                                                               |
|    # docker run -d --privileged --restart=unless-stopped \                    |    # docker run -d --privileged --restart=unless-stopped \                    |
|      --name opennebula \                                                      |      --name opennebula \                                                      |
|      -p 22:22 \                                                               |      -p 22:22 \                                                               |
|      -p 80:80 \                                                               |      -p 80:80 \                                                               |
|      -p 443:443 \                                                             |      \                                                                        |
|      -p 2474:2475 \                                                           |      -p 2474:2474 \                                                           |
|      -p 2633:2634 \                                                           |      -p 2633:2633 \                                                           |
|      -p 4124:4124 \                                                           |      -p 4124:4124 \                                                           |
|      -p 4124:4124/udp \                                                       |      -p 4124:4124/udp \                                                       |
|      -p 5030:5031 \                                                           |      -p 5030:5030 \                                                           |
|      -p 29876:29876 \                                                         |      -p 29876:29876 \                                                         |
|      -e OPENNEBULA_HOST=one.example.com \                                     |      -e OPENNEBULA_HOST=one.example.com \                                     |
|      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |
|      -e ONEADMIN_PASSWORD=changeme123 \                                       |      -e ONEADMIN_PASSWORD=changeme123 \                                       |
|      -e DIND_ENABLED=yes \                                                    |      -e DIND_ENABLED=yes \                                                    |
|      \                                                                        |      -e SUNSTONE_HTTPS_ENABLED=no \                                           |
|      -v opennebula_db:/var/lib/mysql \                                        |      -v opennebula_db:/var/lib/mysql \                                        |
|      -v opennebula_datastores:/var/lib/one/datastores \                       |      -v opennebula_datastores:/var/lib/one/datastores \                       |
|      -v opennebula_srv:/srv/one \                                             |      -v opennebula_srv:/srv/one \                                             |
|      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |
|      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |
|      -v opennebula_etcd:/srv/one/etcd \                                       |      -v opennebula_etcd:/srv/one/etcd \                                       |
|      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |
|      -v opennebula_logs:/var/log \                                            |      -v opennebula_logs:/var/log \                                            |
|      $OPENNEBULA_IMAGE                                                        |      $OPENNEBULA_IMAGE                                                        |
+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+

Carefully replace following occurrences with

  - ``one.example.com`` - hostname/IP which will be used by end-users to access Front-end (and SSH)
  - ``changeme123`` - custom initial password for OpenNebula user ``oneadmin``
  - ``$OPENNEBULA_IMAGE`` - substitute

    - for **Enterprise Edition** with ``enterprise.opennebula.io/opennebula:5.13.85``
    - for **Community Edition** with ``docker.io/opennebula/opennebula:5.13.85``

- Option :ref:`C. Reconfigure Nodes to connect to different port <container_ssh_nodes>` - take and **customize** (see instructions below) one of the examples below:

+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
| TLS-secured Services                                                          | Insecure Services                                                             |
+===============================================================================+===============================================================================+
| .. prompt:: bash # auto                                                       | .. prompt:: bash # auto                                                       |
|                                                                               |                                                                               |
|    # docker run -d --privileged --restart=unless-stopped \                    |    # docker run -d --privileged --restart=unless-stopped \                    |
|      --name opennebula \                                                      |      --name opennebula \                                                      |
|      -p 2222:22 \                                                             |      -p 2222:22 \                                                             |
|      -p 80:80 \                                                               |      -p 80:80 \                                                               |
|      -p 443:443 \                                                             |      \                                                                        |
|      -p 2474:2475 \                                                           |      -p 2474:2474 \                                                           |
|      -p 2633:2634 \                                                           |      -p 2633:2633 \                                                           |
|      -p 4124:4124 \                                                           |      -p 4124:4124 \                                                           |
|      -p 4124:4124/udp \                                                       |      -p 4124:4124/udp \                                                       |
|      -p 5030:5031 \                                                           |      -p 5030:5030 \                                                           |
|      -p 29876:29876 \                                                         |      -p 29876:29876 \                                                         |
|      -e OPENNEBULA_HOST=one.example.com \                                     |      -e OPENNEBULA_HOST=one.example.com \                                     |
|      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |      -e OPENNEBULA_SSH_HOST=one.example.com \                                 |
|      -e ONEADMIN_PASSWORD=changeme123 \                                       |      -e ONEADMIN_PASSWORD=changeme123 \                                       |
|      -e DIND_ENABLED=yes \                                                    |      -e DIND_ENABLED=yes \                                                    |
|      \                                                                        |      -e SUNSTONE_HTTPS_ENABLED=no \                                           |
|      -v opennebula_db:/var/lib/mysql \                                        |      -v opennebula_db:/var/lib/mysql \                                        |
|      -v opennebula_datastores:/var/lib/one/datastores \                       |      -v opennebula_datastores:/var/lib/one/datastores \                       |
|      -v opennebula_srv:/srv/one \                                             |      -v opennebula_srv:/srv/one \                                             |
|      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |      -v opennebula_oneadmin_auth:/var/lib/one/.one \                          |
|      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |      -v opennebula_oneadmin_ssh:/var/lib/one/.ssh \                           |
|      -v opennebula_etcd:/srv/one/etcd \                                       |      -v opennebula_etcd:/srv/one/etcd \                                       |
|      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |      -v opennebula_etcd_secrets:/srv/one/etcd-secrets \                       |
|      -v opennebula_logs:/var/log \                                            |      -v opennebula_logs:/var/log \                                            |
|      $OPENNEBULA_IMAGE                                                        |      $OPENNEBULA_IMAGE                                                        |
+-------------------------------------------------------------------------------+-------------------------------------------------------------------------------+

Carefully replace following occurrences with

  - ``2222`` - selected port on host on which OpenNebula's integrated SSH server will be exposed
  - ``one.example.com`` - hostname/IP which will be used by end-users to access Front-end (and SSH)
  - ``changeme123`` - custom initial (only) password for OpenNebula user ``oneadmin``
  - ``$OPENNEBULA_IMAGE`` - substitute

    - for **Enterprise Edition** with ``enterprise.opennebula.io/opennebula:5.13.85``
    - for **Community Edition** with ``docker.io/opennebula/opennebula:5.13.85``

B. Watch Logs (optional)
^^^^^^^^^^^^^^^^^^^^^^^^

You can watch logs and monitor the bootstrap process and services inside by running:

.. prompt:: bash # auto

    # docker logs -f opennebula

C. Stop Deployment (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When required, you can stop the complete OpenNebula Front-end deployment by:

.. prompt:: bash # auto

    # docker stop opennebula

.. _container_verify:

Step 5. Verify Deployment
================================================================================

We have a running deployment of the OpenNebula Front-end and we can validate it works by logging into the Sunstone web UI.

Sunstone
--------

Open the browser and go to the hostname/IP provided as part of ``OPENNEBULA_HOST`` configuration parameters. I.e., for the example ``one.example.com`` used above you would direct your browser to ``http://one.example.com``. Login as user ``oneadmin`` with the password provided via ``ONEADMIN_PASSWORD`` image parameter.

|sunstone_login|

.. _container_nodes:

Step 6. Add Nodes(s) (optional)
================================================================================

When needed, continue by adding hypervisor Nodes to your working containerized OpenNebula Front-end deployment by following the :ref:`Customized Clusters Installation <node_installation>` guide, the approach is the same as for Front-end installed the traditional way.

.. xxxxxxxxxxxxxxxxxxxxxxxx MARK THE END OF THE CONTENT xxxxxxxxxxxxxxxxxxxxxxxx

.. |_| unicode:: 0xA0
   :trim:

.. |onedocker_schema_all_in_one| image:: /images/onedocker-schema-all-in-one.svg
   :width: 600
   :align: middle
   :alt: Deployment schema of the all-in-one OpenNebula container

.. |onedocker_schema_microservices| image:: /images/onedocker-schema-microservices.svg
   :width: 600
   :align: middle
   :alt: Deployment schema of the OpenNebula containers as microservices

.. |container_multi| image:: /images/container_multi.svg
   :align: middle
   :alt: Deployment schema of the OpenNebula containers as microservices

.. |container_ssh1| image:: /images/container_ssh1.svg
   :width: 500
   :align: middle
   :alt: Deployment schema of SSH servers (1)

.. |container_ssh2| image:: /images/container_ssh2.svg
   :width: 500
   :align: middle
   :alt: Deployment schema of SSH servers (2)

.. |container_ssh3| image:: /images/container_ssh3.svg
   :width: 500
   :align: middle
   :alt: Deployment schema of SSH servers (3)

.. |sunstone_login| image:: /images/sunstone-login.png
   :width: 350
   :align: middle
