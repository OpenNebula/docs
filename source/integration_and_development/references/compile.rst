.. _compile:

================================================================================
Building from Source Code
================================================================================

This page will show you how to compile and install OpenNebula from the sources.

.. warning:: Do not forget to check the :ref:`Building Dependencies <build_deps>` for a list of specific software requirements to build OpenNebula.

.. note::
   If you need to build customized OpenNebula packages you can find the source packages for publicly released versions available in the download repositories for easy rebuilds and customizations. If you need to access the packaging tools, please expose your case to <community-manager@opennebula.io>.

Compiling the Software
================================================================================

Follow these simple steps to install the OpenNebula software:

-  Download and untar the OpenNebula tarball.
-  Change to the created folder and run scons to compile OpenNebula

.. code::

       $ scons [OPTION=VALUE]

   the argument expression [OPTION=VALUE] is used to set non-default values for :

+----------------+--------------------------------------------------------+
| OPTION         | VALUE                                                  |
+================+========================================================+
| sqlite\_dir    | path-to-sqlite-install                                 |
+----------------+--------------------------------------------------------+
| sqlite         | **no** if you don't want to build sqlite support       |
+----------------+--------------------------------------------------------+
| mysql          | **yes** if you want to build mysql support             |
+----------------+--------------------------------------------------------+
| postgresql     | **yes** if you want to build PostgreSQL support        |
+----------------+--------------------------------------------------------+
| xmlrpc         | path-to-xmlrpc-install                                 |
+----------------+--------------------------------------------------------+
| parsers        | **yes** if you want to rebuild flex/bison files        |
+----------------+--------------------------------------------------------+
| new\_xmlrpc    | **yes** if you have an xmlrpc-c version >= 1.31        |
+----------------+--------------------------------------------------------+
| sunstone       | **yes** if you want to build sunstone minified files   |
+----------------+--------------------------------------------------------+
| fireedge       | **yes** if you want to build fireedge minified files   |
+----------------+--------------------------------------------------------+
| systemd        | **yes** if you want to build systemd support           |
+----------------+--------------------------------------------------------+
| docker_machine | **yes** if you want to build the docker-machine driver |
+----------------+--------------------------------------------------------+
| rubygems       | **yes** if you want to generate ruby gems              |
+----------------+--------------------------------------------------------+
| svncterm       | **no** to skip building vnc support for LXD drivers    |
+----------------+--------------------------------------------------------+
| context        | **no** Download guest contextualization packages       |
+----------------+--------------------------------------------------------+

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
| **-e** | install Docker Machine plugin                                                                                                                                                |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

    If you choose the ``system-wide`` installation, OpenNebula will be installed in the following folders:
        -   /etc/one
        -   /usr/lib/one
        -   /usr/share/doc/one
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

Please follow the :ref:`installation guide <ruby_runtime>`, for a detailed description on how to install the Ruby dependencies.

Building Python Bindings from source
================================================================================

In order to build the OpenNebula python components it is required to install pip package manager and following pip packages:

Build Dependencies:

- **generateds**: to generate the python OCA
- **pdoc**: to generate the API documentation
- **setuptools**: to generate python package
- **wheel**: to generate the python package

Run Dependencies:

- **aenum**: python OCA support
- **dicttoxml**: python OCA support
- **feature**: python OCA support
- **lxml**: python OCA support
- **six**: python OCA support
- **tblib**': python OCA support
- **xmltodict**: python OCA support

To build run following:

.. prompt:: text $ auto

    root@frontend:~/ $> cd src/oca/python
    root@frontend:~/ $> make
    root@frontend:~/ $> make dist
    root@frontend:~/ $> make install


Building Sunstone from Source
================================================================================

Please check the :ref:`Sunstone Development guide <sunstone_dev>` for detailed information

Building Docker Machine Plugin from Source
================================================================================

Requirements
--------------------------------------------------------------------------------

* **Go >= 1.9**
* **dep** (https://github.com/golang/dep)

Scons includes an option to build the Docker Machine Plugin using the `docker_machine` option:

.. prompt:: text $ auto

    scons docker_machine=yes

Once you have built you can install it running the install.sh with the `-e` option.

