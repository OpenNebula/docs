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

.. note::

    scons can parallelize the build with the `-j NUM_THREADS` parameter. For instance, to compile the with 4 parallel processes execute

    .. code::

        $ scons -j 4 [OPTION=VALUE]

The argument expression [OPTION=VALUE] is used to set non-default values for :

+-------------+---------+--------------------------------------------------------------+
| OPTION      | Default | VALUE                                                        |
+=============+=========+==============================================================+
| sqlite\_dir |         | path-to-sqlite-install                                       |
+-------------+---------+--------------------------------------------------------------+
| sqlite      |  yes    | **no** if you don't want to build Sqlite support             |
+-------------+---------+--------------------------------------------------------------+
| mysql       |  no     | **yes** if you want to build MySQL support                   |
+-------------+---------+--------------------------------------------------------------+
| xmlrpc      |         | path-to-xmlrpc-install                                       |
+-------------+---------+--------------------------------------------------------------+
| parsers     |  no     | **yes** if you want to rebuild Flex/Bison files.             |
+-------------+---------+--------------------------------------------------------------+
| new\_xmlrpc |  no     | **yes** if you have an xmlrpc-c version >= 1.31              |
+-------------+---------+--------------------------------------------------------------+
| sunstone    |  no     | **yes** if you want to build Ruby Sunstone minified files    |
+-------------+---------+--------------------------------------------------------------+
| fireedge    |  no     | **yes** if you want to build FireEdge minified files         |
+-------------+---------+--------------------------------------------------------------+
| systemd     |  no     | **yes** if you want to build systemd support                 |
+-------------+---------+--------------------------------------------------------------+
| rubygems    |  no     | **yes** if you want to generate Ruby gems                    |
+-------------+---------+--------------------------------------------------------------+
| svncterm    |  yes    | **no** to skip building VNC support for LXD drivers          |
+-------------+---------+--------------------------------------------------------------+
| context     |  no     | **yes** to download guest contextualization packages         |
+-------------+---------+--------------------------------------------------------------+
| download    |  no     | **yes** to download 3rd-party tools (Restic, Prometheus...)  |
+-------------+---------+--------------------------------------------------------------+

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
| **-s** | install OpenNebula Ruby Sunstone                                                                                                                                             |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-p** | do not install OpenNebula Ruby Sunstone non-minified files                                                                                                                   |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-F** | install OpenNebula FireEdge                                                                                                                                                  |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-P** | do not install OpenNebula FireEdge non-minified files                                                                                                                        |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-G** | install OpenNebula Gate                                                                                                                                                      |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **-6** | install only OpenNebula Gate Proxy                                                                                                                                           |
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
        -   /usr/share/doc/one
        -   /usr/share/one
        -   /var/lib/one
        -   /var/lock/one
        -   /var/log/one
        -   /var/run/one

    By using ``./install.sh -r``, dynamically generated files will not be removed.

The packages do a ``system-wide`` installation. To create a similar environment, create a ``oneadmin`` user and group, and execute:

.. prompt:: text $ auto

    oneadmin@frontend:~/ $> wget <opennebula tar gz>
    oneadmin@frontend:~/ $> tar xzf <opennebula tar gz>
    oneadmin@frontend:~/ $> cd opennebula-x.y.z
    oneadmin@frontend:~/opennebula-x.y.z/ $> scons -j2 mysql=yes syslog=yes fireedge=yes
    [ lots of compiling information ]
    scons: done building targets.
    oneadmin@frontend:~/opennebula-x.y.z $> sudo ./install.sh -u oneadmin -g oneadmin

.. warning::

   An error as below might occur during building process:
    .. prompt:: bash # auto

        # scons -j2 mysql=yes syslog=yes
        /usr/bin/ld: src/common/libnebula_common.a(HttpRequest.o): undefined reference to symbol 'curl_easy_cleanup'
        /usr/bin/ld: /usr/lib64/libcurl.so.4: error adding symbols: DSO missing from command line
        collect2: error: ld returned 1 exit status
        scons: *** [src/scheduler/src/sched/mm_sched] Error 1
        scons: building terminated because of errors.

    In that case one needs to patch ``src/scheduler/src/sched/SConstruct`` file:

    .. prompt:: bash # auto
    
       # diff one/src/scheduler/src/sched/SConstruct one-orig/src/scheduler/src/sched/SConstruct 
       48c48,49
       <     'xml2'
       ---
       >     'xml2',
       >     'curl'

Ruby Dependencies
================================================================================

Please follow the :ref:`installation guide <ruby_runtime>`, for a detailed description on how to install the Ruby dependencies.

Building Python Bindings from source
================================================================================

In order to build the OpenNebula python components it is required to install pip package manager and following pip packages:

Build Dependencies:

- **generateds**: to generate the python OCA
- **setuptools**: to generate python package
- **wheel**: to generate the python package

Run Dependencies:

- **aenum**: python OCA support
- **dict2xml**: python OCA support
- **feature**: python OCA support
- **lxml**: python OCA support
- **six**: python OCA support
- **tblib**: python OCA support
- **xml2dict**: python OCA support

To build run following:

.. prompt:: text $ auto

    root@frontend:~/ $> cd src/oca/python
    root@frontend:~/ $> make
    root@frontend:~/ $> make dist
    root@frontend:~/ $> make install


Building Sunstone from Source
================================================================================

.. prompt:: text $ auto

    root@frontend:~/ $> cd ~/one/src/fireedge
    root@frontend:~/ $> npm install
    root@frontend:~/ $> cd ~/one
    root@frontend:~/ $> scons fireedge=yes
    root@frontend:~/ $> ./install.sh -F -u oneadmin -g oneadmin

Building Ruby Sunstone from Source
================================================================================

Ruby Sunstone is a legacy component, which no longer receives updates or bug fixes. Sunstone UI functionality is now provided by the FireEdge server.

Please check the :ref:`Ruby Sunstone Development guide <ruby_sunstone_dev>` for detailed information.
