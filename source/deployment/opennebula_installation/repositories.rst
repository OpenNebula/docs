.. _repositories:

=======================
OpenNebula Repositories
=======================

Enterprise Edition
==================

OpenNebula Systems provides an OpenNebula Enterprise Edition to customers with an active support subscription. To distribute the packages of the Enterprise Edition there is a private enterprise repository only accessible by customers where all packages, including major, minor, and maintenance and releases, are stored. You only need to change your repository source once per major release and you'll be able to get every package in those series. Private repositories contain all OpenNebula released packages.

To access the repository you should have received a token (user/password) used to access the new repository. You have to substitute in the following instructions the appearance of <token> with your specific token:

CentOS/RHEL
-----------

To add OpenNebula enterprise repository execute the following as root:

**CentOS/RHEL 7**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Enterprise Edition
    baseurl=https://<token>@enterprise.opennebula.io/repo/5.12/CentOS/7/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache fast

**CentOS/RHEL 8**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Enterprise Edition
    baseurl=https://<token>@enterprise.opennebula.io/repo/5.12/CentOS/8/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache

Debian/Ubuntu
-------------

To add OpenNebula enterprise repository on Debian/Ubuntu execute as root:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -

**Debian 9**

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Debian/9 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Debian 10**

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 16.04**

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/16.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 18.04**

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 20.04**

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

.. note::

   Please note that you can point to a specific 5.12.x version by changing the occurrence of shorter version 5.12 in any of the above commands to the particular full 3 components version number (X.Y.Z). For instance, to point to version 5.12.1 on Ubuntu 18.04:

    .. prompt:: bash # auto

       # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12.1/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
       # apt-get update

Community Edition
=================

The community edition of OpenNebula offers the full functionality of the Cloud Management Platform. You can configure the community repositories as follows:

CentOS/RHEL/Fedora
------------------

To add OpenNebula repository execute the following as root:

**CentOS/RHEL 7**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Community Edition
    baseurl=https://downloads.opennebula.io/repo/5.12/CentOS/7/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache fast

**CentOS/RHEL 8**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Community Edition
    baseurl=https://downloads.opennebula.io/repo/5.12/CentOS/8/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache

**Fedora 32**

.. important:: This is a :ref:`Secondary Platform <secondary>` not recommended for production evironments!

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula Community Edition
    baseurl=https://downloads.opennebula.io/repo/5.12/Fedora/32/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT
    # yum makecache

Debian/Ubuntu
-------------

To add OpenNebula repository on Debian/Ubuntu execute as root:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -

**Debian 9**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Debian/9 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Debian 10**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 16.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/16.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 18.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

**Ubuntu 20.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update
