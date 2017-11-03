.. _compile:

================================================================================
Building from Source Code
================================================================================

This page will show you how to compile and install OpenNebula from the sources.

If you want to install it from your package manager, visit the `software menu <http://opennebula.org/software:software>`_ to find out if OpenNebula is included in your official distribution package repositories.

.. warning:: Do not forget to check the :ref:`Building Dependencies <build_deps>` for a list of specific software requirements to build OpenNebula.

Compiling the Software
================================================================================

Follow these simple steps to install the OpenNebula software:

-  Download and untar the OpenNebula tarball.
-  Change to the created folder and run scons to compile OpenNebula

.. code::

       $ scons [OPTION=VALUE]

   the argument expression [OPTION=VALUE] is used to set non-default values for :

+---------------+--------------------------------------------------------+
| OPTION        | VALUE                                                  |
+===============+========================================================+
| sqlite\_db    | path-to-sqlite-install                                 |
+---------------+--------------------------------------------------------+
| sqlite        | **no** if you don't want to build sqlite support       |
+---------------+--------------------------------------------------------+
| mysql         | **yes** if you want to build mysql support             |
+---------------+--------------------------------------------------------+
| xmlrpc        | path-to-xmlrpc-install                                 |
+---------------+--------------------------------------------------------+
| parsers       | **yes** if you want to rebuild flex/bison files        |
+---------------+--------------------------------------------------------+
| new\_xmlrpc   | **yes** if you have an xmlrpc-c version >= 1.31        |
+---------------+--------------------------------------------------------+
| sunstone      | **yes** if you want to build sunstone minified files   |
+---------------+--------------------------------------------------------+

If the following error appears, then you need to remove the option 'new\_xmlrpc=yes' or install xmlrpc-c version >= 1.31:

.. code::

    error: 'class xmlrpc_c::serverAbyss::constrOpt' has no member named 'maxConn'

-  OpenNebula can be installed in two modes: ``system-wide``, or in ``self-contained`` directory. In either case, you do not need to run OpenNebula as root. These options can be specified when running the install script:

.. code::

    ./install.sh <install_options>

.. note::

    To install OpenNebula with the ``system-wide`` mode you should have super user privileges.

    .. code::

        $ sudo ./install.sh <install_options>

where *<install\_options>* can be one or more of:

+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| OPTION |                                                                                    VALUE                                                                                     |
+========+==============================================================================================================================================================================+
| **-u** | user that will run OpenNebula, defaults to user executing install.sh                                                                                                         |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-g** | group of the user that will run OpenNebula, defaults to user executing install.sh                                                                                            |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-k** | keep configuration files of existing OpenNebula installation, useful when upgrading. This flag should not be set when installing OpenNebula for the first time               |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-d** | target installation directory. If defined, it will specified the path for the **self-contained** install. If not defined, the installation will be performed **system wide** |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-c** | only install client utilities: OpenNebula cli and ec2 client files                                                                                                           |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-s** | install OpenNebula Sunstone                                                                                                                                                  |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-p** | do not install OpenNebula Sunstone non-minified files                                                                                                                        |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-G** | install OpenNebula Gate                                                                                                                                                      |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-f** | install OpenNebula Flow                                                                                                                                                      |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-r** | remove Opennebula, only useful if -d was not specified, otherwise ``rm -rf $ONE_LOCATION`` would do the job                                                                  |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-l** | creates symlinks instead of copying files, useful for development                                                                                                            |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-h** | prints installer help                                                                                                                                                        |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

    If you choose the ``system-wide`` installation, OpenNebula will be installed in the following folders:
        -   /etc/one
        -   /usr/lib/one
        -   /usr/share/docs/one
        -   /usr/share/one
        -   /var/lib/one
        -   /var/lock/one
        -   /var/log/one
        -   /var/run/one

    By using ``./install.sh -r``, dinamically generated files will not be removed.

The packages do a ``system-wide`` installation. To create a similar environment, create a ``oneadmin`` user and group, and execute:

.. prompt:: text $ auto

    oneadmin@frontend:~/ $> wget <opennebula tar gz>
    oneadmin@frontend:~/ $> tar xzf <opennebula tar gz>
    oneadmin@frontend:~/ $> cd opennebula-x.y.z
    oneadmin@frontend:~/opennebula-x.y.z/ $> scons -j2 mysql=yes syslog=yes
    [ lots of compiling information ]
    scons: done building targets.
    oneadmin@frontend:~/opennebula-x.y.z $> sudo ./install.sh -u oneadmin -g oneadmin

Ruby Dependencies
================================================================================

Ruby version needs to be:

-  **ruby** >= 1.8.7

Some OpenNebula components need ruby libraries. Some of these libraries are interfaces to binary libraries and the development packages should be installed in your machine. This is the list of the ruby libraries that need a development package:

-  **sqlite3**: sqlite3 development library
-  **mysql**: mysql client development library
-  **curb**: curl development library
-  **nokogiri**: expat development librarie
-  **xmlparse**: libxml2 and libxslt development libraries

You will also need ruby development package to be able to compile these gems.

We provide a script to ease the installation of these gems. it is located in ``/usr/share/one/install_gems`` (system-wide mode). It can be called with the components you want the gem dependencies to be installed. Here are the options:

-  **optional**: libraries that make CLI and OCA faster
-  **quota**: quota system
-  **sunstone**: sunstone graphical interface
-  **cloud**: ec2 and occi interfaces
-  **ozones\_client**: CLI of ozones
-  **ozones\_server**: server part of ozones, both mysql and sqlite support
-  **ozones\_server\_sqlite**: ozones server, only sqlite support
-  **ozones\_server\_mysql**: ozones server, only mysql support
-  **acct**: accounting collector, both mysql and sqlite support
-  **acct\_sqlite**: accounting collector, only sqlite support
-  **acct\_mysql**: accounting collector, only mysql support

The tool can be also called without parameters and all the packages will be installed.

For example, to install only requirements for sunstone and ec2 interfaces you'll issue:

.. prompt:: text $ auto

    oneadmin@frontend: $> ./install_gems sunstone cloud

Building Sunstone from Source
================================================================================

Please check the :ref:`Sunstone Development guide <sunstone_dev>` for detailed information
