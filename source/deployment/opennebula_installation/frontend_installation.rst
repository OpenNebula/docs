.. _ignc:
.. _frontend_installation:

========================
Front-end Installation
========================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided in our site is the recommended method, to ensure the installation of the latest version and to avoid possible packages divergences of different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.org/software:software>`__ to **download the latest package** for your Linux distribution.

If there are no packages for your distribution, head to the :ref:`Building from Source Code guide <compile>`.

Step 1. Disable SElinux in CentOS/RHEL 7
========================================

SElinux can cause some problems, like not trusting ``oneadmin`` user's SSH credentials. You can disable it changing in the file ``/etc/selinux/config`` this line:

.. code-block:: bash

    SELINUX=disabled

After this file is changed reboot the machine.

Step 2. Add OpenNebula Repositories
===================================

.. include:: ../repositories.txt

Step 3. Installing the Software
===============================

Installing on CentOS/RHEL 7
---------------------------

Before installing:

-  Activate the `EPEL <http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F>`__ repo. In CentOS this can be done with the following command:

.. prompt:: bash # auto

    # yum install epel-release

There are packages for the front-end, distributed in the various components that conform OpenNebula, and packages for the virtualization host.

To install a CentOS/RHEL OpenNebula front-end with packages from **our repository**, execute the following as root.

.. prompt:: bash # auto

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

Installing on Debian/Ubuntu
---------------------------

To install OpenNebula on a Debian/Ubuntu front-end using packages from **our repositories** execute as root:

.. prompt:: bash # auto

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
    - ``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``


.. _ruby_runtime:

Step 4. Ruby Runtime Installation
=================================

Some OpenNebula components need Ruby libraries. OpenNebula provides a script that installs the required gems as well as some development libraries packages needed.

As root execute:

.. prompt:: bash # auto

    # /usr/share/one/install_gems

The previous script is prepared to detect common Linux distributions and install the required libraries. If it fails to find the packages needed in your system, manually install these packages:

-  sqlite3 development library
-  mysql client development library
-  curl development library
-  libxml2 and libxslt development libraries
-  ruby development library
-  gcc and g++
-  make

If you want to install only a set of gems for an specific component read :ref:`Building from Source Code <compile>` where it is explained in more depth.

Step 5. Starting OpenNebula
===========================

Log in as the ``oneadmin`` user follow these steps:

-  If you installed from packages, you should have the ``one/one_auth`` file created with a randomly-generated password. Otherwise, set oneadmin's OpenNebula credentials (username and password) adding the following to ``~/.one/one_auth`` (change ``password`` for the desired password):

.. prompt:: bash $ auto

    $ mkdir ~/.one
    $ echo "oneadmin:password" > ~/.one/one_auth
    $ chmod 600 ~/.one/one_auth

.. warning:: This will set the oneadmin password on the first boot. From that point, you must use the ':ref:`oneuser passwd <manage_users>`\ ' command to change oneadmin's password.

-  You are ready to start the OpenNebula daemons:

.. prompt:: bash # auto

    # service opennebula start
    # service opennebula-sunstone start

.. _verify_frontend_section:

Step 6. Verifying the Installation
==================================

After OpenNebula is started for the first time, you should check that the commands can connect to the OpenNebula daemon. In the front-end, run as oneadmin the command onevm:

.. prompt:: bash $ auto

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME

If instead of an empty list of VMs you get an error message, then the OpenNebula daemon could not be started properly:

.. prompt:: bash $ auto

    $ onevm list
    Connection refused - connect(2)

The OpenNebula logs are located in ``/var/log/one``, you should have at least the files ``oned.log`` and ``sched.log``, the core and scheduler logs. Check ``oned.log`` for any error messages, marked with ``[E]``.

Now you can try to log in into Sunstone web interface. To do this point your browser to ``http://<fontend_address>:9869``. If everything is OK you will be greeted with a login page. The user is ``oneadmin`` and the password is the one in the file ``/var/lib/one/.one/one_auth`` in your frontend.

After installing the OpenNebula packages in the front-end the following directory structure will be used

|image2|


Step 7. Next steps
===================

.. todo:: next steps

Now that you have a fully functional cloud, it is time to start learning how to use it. A good starting point is this :ref:`overview of the virtual resource management <intropr>`.

.. |image0| image:: /images/debian-opennebula.png
.. |image2| image:: /images/sw_small.png
