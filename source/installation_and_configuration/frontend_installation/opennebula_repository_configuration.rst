.. _repositories:

================================================================================
OpenNebula Repositories
================================================================================

Before we can proceed with installation, we have to configure the packaging tools on your Front-end host to include OpenNebula repositories. OpenNebula software is provided via two distinct distribution channels depending on the build type you are going to install:

- :ref:`Enterprise Edition <repositories_ee>` - enterprise users facing hardened builds,
- :ref:`Community Edition <repositories_ce>` - free public builds.

Follow the steps below based on your OpenNebula edition and Front-end operating system.

.. _repositories_ee:

Enterprise Edition
================================================================================

OpenNebula Systems provides an OpenNebula Enterprise Edition to customers with an active support subscription. To distribute the packages of the Enterprise Edition there is a private enterprise repository accessible only to those customers that contains all packages (including major, minor, and maintenance releases). You only need to change your repository configuration on Front-end once per major release and you'll be able to get every package in that series. Private repositories contain all OpenNebula released packages.

.. important:: You should have received the customer access token (username and password) to access these repositories. You have to substitute the appearance of ``<token>`` with your customer specific token in all instructions below.

AlmaLinux/RHEL
--------------------------------------------------------------------------------

To add the OpenNebula enterprise repository, execute the following as user ``root``:

**RHEL 8, 9**

.. prompt:: bash # auto
   :substitutions:

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Enterprise Edition
    baseurl=https://<token>@enterprise.opennebula.io/repo/|release|/RedHat/$releasever/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo2.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache

**AlmaLinux 8, 9**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Enterprise Edition
    baseurl=https://<token>@enterprise.opennebula.io/repo/|release|/AlmaLinux/$releasever/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo2.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache


Debian/Ubuntu
--------------------------------------------------------------------------------

.. note::

    If the commands below fail, ensure you have ``gnupg``, ``wget`` and ``apt-transport-https`` packages installed and retry. E.g.,

    .. prompt:: bash # auto

        # apt-get update
        # apt-get -y install gnupg wget apt-transport-https

First, add the repository signing GPG key on the Front-end by executing as user ``root``:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo2.key | apt-key add -

and then continue with repository configuration:

**Debian 10**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://<token>@enterprise.opennebula.io/repo/|release|/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Debian 11**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://<token>@enterprise.opennebula.io/repo/|release|/Debian/11 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 20.04**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://<token>@enterprise.opennebula.io/repo/|release|/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 22.04**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://<token>@enterprise.opennebula.io/repo/|release|/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

.. note::

   You can point to a specific 6.6.x version by changing the occurrence of shorter version 6.6 in any of the above commands to the particular full 3 components version number (X.Y.Z). For instance, to point to version 6.6.1 on Ubuntu 22.04, use the following command instead:

    .. prompt:: bash # auto

       # echo "deb https://<token>@enterprise.opennebula.io/repo/6.6.1/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
       # apt-get update

In Debian and Ubuntu it's possible (and recommended) to store a customer token in a separate file to the repository configuration. If you choose to store the repository credentials separately, you need to avoid using the ``<token>@`` part in the repository definitions above. You should create a new file ``/etc/apt/auth.conf.d/opennebula.conf`` with the following structure and replace the ``<user>`` and ``<password>`` parts with the customer credentials you have received:

.. code::

    machine enterprise.opennebula.io
    login <user>
    password <password>

.. _repositories_ce:

Community Edition
================================================================================

The community edition of OpenNebula offers the full functionality of the Cloud Management Platform. You can configure the community repositories as follows:

AlmaLinux/RHEL
--------------------------------------------------------------------------------

To add OpenNebula repository, execute the following as user ``root``:

**RHEL 8, 9**

.. prompt:: bash # auto
   :substitutions:

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Community Edition
    baseurl=https://downloads.opennebula.io/repo/|release|/RedHat/$releasever/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo2.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache

**AlmaLinux 8, 9**

.. prompt:: bash # auto
   :substitutions:

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Enterprise Edition
    baseurl=https://downloads.opennebula.io/repo/|release|/AlmaLinux/$releasever/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo2.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache


Debian/Ubuntu
--------------------------------------------------------------------------------

.. note::

    If the commands below fail, ensure you have ``gnupg``, ``wget`` and ``apt-transport-https`` packages installed and retry. E.g.,

    .. prompt:: bash # auto

        # apt-get update
        # apt-get -y install gnupg wget apt-transport-https

First, add the repository signing GPG key on the Front-end by executing as user ``root``:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo2.key | apt-key add -

**Debian 10**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://downloads.opennebula.io/repo/|release|/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Debian 11**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://downloads.opennebula.io/repo/|release|/Debian/11 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 20.04**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://downloads.opennebula.io/repo/|release|/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 22.04**

.. prompt:: bash # auto
   :substitutions:

    # echo "deb https://downloads.opennebula.io/repo/|release|/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update
