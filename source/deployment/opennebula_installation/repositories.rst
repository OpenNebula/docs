.. _repositories:

=======================
OpenNebula Repositories
=======================

Enterprise Edition
==================

OpenNebula Systems provides an OpenNebula Enterprise Edition to customers with an active support subscription. To distribute the packages of the Enterprise Edition there is a private enterprise repository only accessible by customers where all packages, including major, minor, and maintenance and releases, are stored. You only need to change your repository source once per major release and you'll be able to get every package in those series. Private repositories contain all OpenNebula released packages.

To access the repository you should have received a token (user/password) used to access the new repository. You have to substitute in the following instructions the appearance of ``<token>`` with your specific token:

CentOS/RHEL
-----------

*CentOS/RHEL 7*

.. prompt:: bash # auto

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
      [opennebula]
      name=opennebula
      baseurl=https://<token>@enterprise.opennebula.io/repo/5.12/CentOS/7/x86_64
      enabled=1
      gpgkey=https://downloads.opennebula.io/repo/repo.key
      gpgcheck=1
      #repo_gpgcheck=1
    EOT
    # yum makecache fast

*CentOS/RHEL 8*

.. prompt:: bash # auto

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
      [opennebula]
      name=opennebula
      baseurl=https://<token>@enterprise.opennebula.io/repo/5.12/CentOS/8/x86_64
      enabled=1
      gpgkey=https://downloads.opennebula.io/repo/repo.key
      gpgcheck=1
      #repo_gpgcheck=1
    EOT
    # yum makecache fast

Debian/Ubuntu
-------------

*Debian 9*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Debian/9 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

*Debian 10*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

*Ubuntu 16.04*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/16.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

*Ubuntu 18.04*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

*Ubuntu 20.04*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

*Ubuntu 20.10*

.. prompt:: bash # auto

    # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12/Ubuntu/20.10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
    # apt-get update

.. note::

   Please note that you can point to a specific 5.12.x version changing the occurrence of 5.12 in any of the above to the specific version number. For instance, to point to version 5.12.1 in Ubuntu 18.04:

    .. prompt:: bash # auto

       Ubuntu 18.04
       # echo "deb https://<token>@enterprise.opennebula.io/repo/5.12.1/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
       # apt-get update

Since Debian 10 and Ubuntu 16.04, it's possible (and recommended) to store customer token in a separate file distinct to the repository configuration. If you choose to store the repository credentials separately, you need to avoid using ``<token>@`` part in the repository definitions above, create a new file ``/etc/apt/auth.conf.d/opennebula.conf`` with following structure and replace ``<user>`` and ``<password>`` parts with customer credentials you have received:

.. code::

    machine enterprise.opennebula.io
    login <user>
    password <password>

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
    name=OpenNebula
    baseurl=https://downloads.opennebula.io/repo/5.12/CentOS/7/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT

**CentOS/RHEL 8**

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula
    baseurl=https://downloads.opennebula.io/repo/5.12/CentOS/8/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT

**Fedora 32**

.. important:: This is a :ref:`Secondary Platform <secondary>` not recommended for production evironments!

.. prompt:: bash # auto

    # cat << "EOT" > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=OpenNebula
    baseurl=https://downloads.opennebula.io/repo/5.12/Fedora/32/$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT

Debian/Ubuntu
-------------

To add OpenNebula repository on Debian/Ubuntu execute as root:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -

**Debian 9**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Debian/9 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Debian 10**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Ubuntu 16.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/16.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Ubuntu 18.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/18.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Ubuntu 20.04**

.. prompt:: bash # auto

    # echo "deb https://downloads.opennebula.io/repo/5.12/Ubuntu/20.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
