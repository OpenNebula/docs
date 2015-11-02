.. _ignc:

========================
Installing the Software
========================

This page shows you how to install OpenNebula from the binary packages.

.. note:: OpenNebula allows to import Wild VMs (ie VMs not launched through OpenNebula). OpenNebula can be installed and then import existing VMs (proceed to this :ref:`host guide section <import_wild_vms>` for more details) to control their lifecycle.

Step 1. Front-end Installation
==============================

Using the packages provided in our site is the recommended method, to ensure the installation of the latest version and to avoid possible packages divergences of different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.org/software:software>`__ to **download the latest package** for your Linux distribution.

Remember that we offer Quickstart guides for:

-  :ref:`OpenNebula on CentOS and KVM <qs_centos7_kvm>`
-  :ref:`OpenNebula on Ubuntu and KVM <qs_ubuntu_kvm>`

If there are no packages for your distribution, head to the :ref:`Building from Source Code guide <compile>`.

1.1. Installing on CentOS/RHEL
------------------------------

Before installing:

-  Activate the `EPEL <http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F>`__ repo. In CentOS this can be done with the following commad:

.. code::

    # yum install epel-release

There are packages for the front-end, distributed in the various components that conform OpenNebula, and packages for the virtualization host.

To install a CentOS/RHEL OpenNebula front-end with packages from **our repository**, execute the following as root.

For CentOS 6:

.. code::

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=opennebula
    baseurl=http://downloads.opennebula.org/repo/4.14/CentOS/6/x86_64
    enabled=1
    gpgcheck=0
    EOT
    # yum install opennebula-server opennebula-sunstone opennebula-ruby

For CentOS 7:

.. code::

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=opennebula
    baseurl=http://downloads.opennebula.org/repo/4.14/CentOS/7/x86_64
    enabled=1
    gpgcheck=0
    EOT
    # yum install opennebula-server opennebula-sunstone opennebula-ruby

**CentOS/RHEL Package Description**

These are the packages available for this distribution:

-  **opennebula**: Command Line Interface
-  **opennebula-server**: Main OpenNebula daemon, scheduler, etc
-  **opennebula-sunstone**: OpenNebula Sunstone and EC2
-  **opennebula-ruby**: Ruby Bindings
-  **opennebula-java**: Java Bindings
-  **opennebula-gate**: Gate server that enables communication between VMs and OpenNebula
-  **opennebula-flow**: Manages services and elasticity
-  **opennebula-node-kvm**: Meta-package that installs the oneadmin user, libvirt and kvm
-  **opennebula-common**: Common files for OpenNebula packages


.. note::

    The files located in ``/var/lib/one/remotes`` are marked as configuration files.

1.2. Installing on Debian/Ubuntu
--------------------------------

The JSON ruby library packaged with Debian 6 is not compatible with OpenNebula. To make it work a new gem should be installed and the old one disabled. You can do so executing these commands:

.. code::

    $ sudo gem install json
    $ sudo mv /usr/lib/ruby/1.8/json.rb /usr/lib/ruby/1.8/json.rb.no

To install OpenNebula on a Debian/Ubuntu front-end from packages from **our repositories** execute as root:

.. code::

    # wget -q -O- http://downloads.opennebula.org/repo/Debian/repo.key | apt-key add -

**Debian 8**

.. code::

    # echo "deb http://downloads.opennebula.org/repo/4.14/Debian/8 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Ubuntu 14.04**

.. code::

    # echo "deb http://downloads.opennebula.org/repo/4.14/Ubuntu/14.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

**Ubuntu 15.04**

.. code::

    # echo "deb http://downloads.opennebula.org/repo/4.14/Ubuntu/15.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

To install the packages on a Debian/Ubuntu front-end:

.. code::

    # apt-get update
    # apt-get install opennebula opennebula-sunstone

**Debian/Ubuntu Package Description**

These are the packages available for these distributions:

|image0|

-  **opennebula-common**: provides the user and common files
-  **ruby-opennebula**: Ruby API
-  **libopennebula-java**: Java API
-  **libopennebula-java-doc**: Java API Documentation
-  **opennebula-node**: prepares a node as an opennebula-node
-  **opennebula-sunstone**: OpenNebula Sunstone Web Interface
-  **opennebula-tools**: Command Line interface
-  **opennebula-gate**: Gate server that enables communication between VMs and OpenNebula
-  **opennebula-flow**: Manages services and elasticity
-  **opennebula**: OpenNebula Daemon

.. note::

    The following files are marked as configuration files:

    - ``/var/lib/one/remotes/datastore/ceph/ceph.conf``
    - ``/var/lib/one/remotes/datastore/lvm/lvm.conf``
    - ``/var/lib/one/remotes/datastore/vmfs/vmfs.conf``
    - ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``


.. _ruby_runtime:

Step 2. Ruby Runtime Installation
=================================

Some OpenNebula components need ruby libraries. OpenNebula provides a script that installs the required gems as well as some development libraries packages needed.

As root execute:

.. code::

    # /usr/share/one/install_gems

The previous script is prepared to detect common linux distributions and install the required libraries. If it fails to find the packages needed in your system, manually install these packages:

-  sqlite3 development library
-  mysql client development library
-  curl development library
-  libxml2 and libxslt development libraries
-  ruby development library
-  gcc and g++
-  make

If you want to install only a set of gems for an specific component read :ref:`Building from Source Code <compile>` where it is explained in more depth.

Step 3. Starting OpenNebula
===========================

Log in as the ``oneadmin`` user follow these steps:

-  If you installed from packages, you should have the ``one/one_auth`` file created with a randomly-generated password. Otherwise, set oneadmin's OpenNebula credentials (username and password) adding the following to ``~/.one/one_auth`` (change ``password`` for the desired password):

.. code::

    $ mkdir ~/.one
    $ echo "oneadmin:password" > ~/.one/one_auth
    $ chmod 600 ~/.one/one_auth

.. warning:: This will set the oneadmin password on the first boot. From that point, you must use the ':ref:`oneuser passwd <manage_users>`\ ' command to change oneadmin's password.

-  You are ready to start the OpenNebula daemons:

.. code::

    $ one start

.. warning:: Remember to always start OpenNebula as ``oneadmin``!

Step 4. Verifying the Installation
==================================

After OpenNebula is started for the first time, you should check that the commands can connect to the OpenNebula daemon. In the front-end, run as oneadmin the command onevm:

.. code::

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME

If instead of an empty list of VMs you get an error message, then the OpenNebula daemon could not be started properly:

.. code::

    $ onevm list
    Connection refused - connect(2)

The OpenNebula logs are located in ``/var/log/one``, you should have at least the files ``oned.log`` and ``sched.log``, the core and scheduler logs. Check ``oned.log`` for any error messages, marked with ``[E]``.

.. warning:: The first time OpenNebula is started, it performs some SQL queries to check if the DB exists and if it needs a bootstrap. You will have two error messages in your log similar to these ones, and can be ignored:

.. code::

    [ONE][I]: Checking database version.
    [ONE][E]: (..) error: no such table: db_versioning
    [ONE][E]: (..) error: no such table: user_pool
    [ONE][I]: Bootstraping OpenNebula database.

After installing the OpenNebula packages in the front-end the following directory structure will be used

|image2|

Step 5. Node Installation
=========================

5.1. Installing on CentOS/RHEL
------------------------------

When the front-end is installed and verified, it is time to install the packages for the nodes if you are using KVM. To install a CentOS/RHEL OpenNebula front-end with packages from our repository, add the repo using the snippet from the previous section and execute the following as root:

.. code::

    # sudo yum install opennebula-node-kvm

If you are using Xen you can prepare the node with opennebula-common:

.. code::

    # sudo yum install opennebula-common

For further configuration and/or installation of other hypervisors, check their specific guides: :ref:`Xen <xeng>`, :ref:`KVM <kvmg>` and :ref:`VMware <evmwareg>`.

5.2. Installing on Debian/Ubuntu
--------------------------------

When the front-end is installed, it is time to install the packages for the nodes if you are using KVM. To install a Debian/Ubuntu OpenNebula front-end with packages from our repository, add the repo as described in the previous section and then install the node package.

.. code::

    $ sudo apt-get install opennebula-node

For further configuration and/or installation of other hypervisors, check their specific guides: :ref:`Xen <xeng>`, :ref:`KVM <kvmg>` and :ref:`VMware <evmwareg>`.

Step 6. Manual Configuration of Unix Accounts
=============================================

.. warning:: This step can be skipped if you have installed the node/common package for CentOS or Ubuntu, as it has already been taken care of.

The OpenNebula package installation creates a new user and group named ``oneadmin`` in the front-end. This account will be used to run the OpenNebula services and to do regular administration and maintenance tasks. That means that you eventually need to login as that user or to use the ``sudo -u oneadmin`` method.

The hosts need also this user created and configured. Make sure you change the uid and gid by the ones you have in the front-end.

-  Get the user and group id of ``oneadmin``. This id will be used later to create users in the hosts with the same id. In the **front-end**, execute as ``oneadmin``:

.. code::

    $ id oneadmin
    uid=1001(oneadmin) gid=1001(oneadmin) groups=1001(oneadmin)

In this case the user id will be 1001 and group also 1001.

Then log as root **in your hosts** and follow these steps:

-  Create the ``oneadmin`` group. Make sure that its id is the same as in the frontend. In this example 1001:

.. code::

    # groupadd --gid 1001 oneadmin

-  Create the ``oneadmin`` account, we will use the OpenNebula ``var`` directory as the home directory for this user.

.. code::

    # useradd --uid 1001 -g oneadmin -d /var/lib/one oneadmin

.. warning:: You can use any other method to make a common ``oneadmin`` group and account in the nodes, for example NIS.

Step 7. Manual Configuration of Secure Shell Access
===================================================

You need to create ``ssh`` keys for the ``oneadmin`` user and configure the host machines so it can connect to them using ``ssh`` without need for a password.

Follow these steps in the **front-end**:

-  Generate ``oneadmin`` ssh keys:

.. code::

    $ ssh-keygen

When prompted for password press enter so the private key is not encrypted.

-  Append the public key to ``~/.ssh/authorized_keys`` to let ``oneadmin`` user log without the need to type a password.

.. code::

    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

-  Many distributions (RHEL/CentOS for example) have permission requirements for the public key authentication to work:

.. code::

    $ chmod 700 ~/.ssh/
    $ chmod 600 ~/.ssh/id_dsa.pub
    $ chmod 600 ~/.ssh/id_dsa
    $ chmod 600 ~/.ssh/authorized_keys

-  Tell ssh client to not ask before adding hosts to ``known_hosts`` file. Also it is a good idea to reduced the connection timeout in case of network problems. This is configured into ``~/.ssh/config``, see ``man ssh_config`` for a complete reference.:

.. code::

    $ cat ~/.ssh/config
    ConnectTimeout 5
    Host *
        StrictHostKeyChecking no

-  Check that the ``sshd`` daemon is running in the hosts. Also remove any ``Banner`` option from the ``sshd_config`` file in the hosts.

-  Finally, Copy the front-end ``/var/lib/one/.ssh`` directory to each one of the hosts in the same path.

To test your configuration just verify that ``oneadmin`` can log in the hosts without being prompt for a password.

.. _ignc_step_8_networking_configuration:

Step 8. Networking Configuration
================================

|image3|

A network connection is needed by the OpenNebula front-end daemons to access the hosts to manage and monitor the hypervisors; and move image files. It is highly recommended to install a dedicated network for this purpose.

There are various network models (please check the :ref:`Networking guide <nm>` to find out the networking technologies supported by OpenNebula), but they all have something in common. They rely on network bridges with the same name in all the hosts to connect Virtual Machines to the physical network interfaces.

The simplest network model corresponds to the ``dummy`` drivers, where only the network bridges are needed.

For example, a typical host with two physical networks, one for public IP addresses (attached to eth0 NIC) and the other for private virtual LANs (NIC eth1) should have two bridges:

.. code::

    $ brctl show
    bridge name bridge id         STP enabled interfaces
    br0        8000.001e682f02ac no          eth0
    br1        8000.001e682f02ad no          eth1

Step 9. Storage Configuration
=============================

OpenNebula uses Datastores to manage VM disk Images. There are two configuration steps needed to perform a basic set up:

-  First, you need to configure the **system datastore** to hold images for the running VMs, check the :ref:`the System Datastore Guide <system_ds>`, for more details.
-  Then you have to setup one ore more datastore for the disk images of the VMs, you can find more information on setting up :ref:`Filesystem Datastores here <fs_ds>`.

The suggested configuration is to use a shared FS, which enables most of OpenNebula VM controlling features. OpenNebula **can work without a Shared FS**, but this will force the deployment to always clone the images and you will only be able to do *cold* migrations.

The simplest way to achieve a shared FS backend for OpenNebula datastores is to export via NFS from the OpenNebula front-end both the ``system`` (``/var/lib/one/datastores/0``) and the ``images`` (``/var/lib/one/datastores/1``) datastores. They need to be mounted by all the virtualization nodes to be added into the OpenNebula cloud.

Step 10. Adding a Node to the OpenNebula Cloud
==============================================

To add a node to the cloud, there are four needed parameters: name/IP of the host, virtualization, network and information driver. Using the recommended configuration above, and assuming a KVM hypervisor, you can add your host ``node01`` to OpenNebula in the following fashion (as oneadmin, in the front-end):

.. code::

    $ onehost create node01 -i kvm -v kvm -n dummy

To learn more about the host subsystem, read :ref:`this guide <hostsubsystem>`.

Step 11. Next steps
===================

Now that you have a fully functional cloud, it is time to start learning how to use it. A good starting point is this :ref:`overview of the virtual resource management <intropr>`.

.. |image0| image:: /images/debian-opennebula.png
.. |image2| image:: /images/sw_small.png
.. |image3| image:: /images/network-02.png
