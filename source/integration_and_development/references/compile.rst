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
| sqlite\_db     | path-to-sqlite-install                                 |
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
| systemd        | **yes** if you want to build systemd support           |
+----------------+--------------------------------------------------------+
| docker_machine | **yes** if you want to build the docker-machine driver |
+----------------+--------------------------------------------------------+
| rubygems       | **yes** if you want to generate ruby gems              |
+----------------+--------------------------------------------------------+
| svncterm       | **no** to skip building vnc support for LXD drivers    |
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


Ruby version needs to be:

-  **ruby** >= 2.0.0

Some OpenNebula components need ruby libraries. Some of these libraries are interfaces to binary libraries and the development packages should be installed in your machine. This is the list of the ruby libraries that need a development package:

-  **sqlite3**: sqlite3 development library
-  **mysql**: mysql client development library
-  **pg**: PostgreSQL client development library
-  **curb**: curl development library
-  **nokogiri**: expat development librarie
-  **xmlparse**: libxml2 and libxslt development libraries
-  **zeromq**: libzmq5 and libzmq3 development libraries
-  **augeas**: libaugeas development libraries

You will also need ruby development package to be able to compile these gems.

We provide a script to ease the installation of these gems. it is located in ``/usr/share/one/install_gems`` (system-wide mode). It can be called with the components you want the gem dependencies to be installed. Here are the options:

-  **quota**: quota system
-  **sunstone**: sunstone graphical interface
-  **cloud**: ec2 and occi interfaces
-  **hybrid**: azure and configuration parser
-  **auth_ldap**: net ldap authentication
-  **vmware**: rbvmomi and json for vCenter support
-  **oneflow**: sinatra, treetop and parse cron for OneFlow support
-  **ec2_hybrid**: aws sdk support
-  **oca**: ox support
-  **onedb**: mysql and postgres support
-  **hooks**: zeromq support
-  **serversync**: augeas support
-  **gnuplot**: gnuplot support

The tool can be also called without parameters and all the packages will be installed.

For example, to install only requirements for sunstone and ec2 interfaces you'll issue:

.. prompt:: text $ auto

    oneadmin@frontend: $> ./install_gems sunstone cloud

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

Once you have builded you can install it running the install.sh with the `-e` option.

Configure sudo for oneadmin
================================================================================

``oneadmin`` user, both on frontend and nodes, needs to run several commands
under a privileged user via ``sudo``. When installing the OpenNebula from
official packages, the necessary configuration is part of the
``opennebula-common`` package. When installing from the source, you have
to ensure the proper ``sudo`` configuration enables following commands
to the ``oneadmin``.

+---------------+-------------------------------------------------------------+
| Section       | Commands                                                    |
+===============+=============================================================+
| networking    | ebtables, iptables, ip6tables, ipset, ip link, ip tuntap    |
+---------------+-------------------------------------------------------------+
| LVM           | lvcreate, lvremove, lvs, vgdisplay, lvchange, lvscan,       |
|               | lvextend                                                    |
+---------------+-------------------------------------------------------------+
| Open vSwitch  | ovs-ofctl, ovs-vsctl                                        |
+---------------+-------------------------------------------------------------+
| Ceph          | rbd                                                         |
+---------------+-------------------------------------------------------------+
| LXD           | /snap/bin/lxc, /usr/bin/catfstab, mount, umount, mkdir,     |
|               | lsblk, losetup, kpartx, qemu-nbd, blkid, e2fsck, resize2fs, |
|               | xfs_growfs, rbd-nbd, xfs_admin, tune2fs                     |
+---------------+-------------------------------------------------------------+
| HA            | systemctl start opennebula-flow,                            |
|               | systemctl stop opennebula-flow,                             |
|               | systemctl start opennebula-gate,                            |
|               | systemctl stop opennebula-gate,                             |
|               | systemctl start opennebula-hem,                             |
|               | systemctl stop opennebula-hem,                              |
|               | systemctl start opennebula-showback.timer,                  |
|               | systemctl stop opennebula-showback.timer,                   |
|               | service opennebula-flow start,                              |
|               | service opennebula-flow stop,                               |
|               | service opennebula-gate start,                              |
|               | service opennebula-gate stop,                               |
|               | service opennebula-hem start,                               |
|               | service opennebula-hem stop,                                |
|               | ip address *                                                |
+---------------+-------------------------------------------------------------+
| MARKET        | {lib_location}/sh/create_container_image.sh,                |
|               | {lib_location}/sh/create_docker_image.sh                    |
+---------------+-------------------------------------------------------------+
| FIRECRACKER   | /usr/bin/jailer,                                            |
|               | /usr/sbin/one-clean-firecracker-domain,                     |
|               | /usr/sbin/one-prepare-firecracker-domain                    |
+---------------+-------------------------------------------------------------+

Each command has to be specified with the absolute path, which can be
different for each platform. Commands are started on background, ``sudo``
needs to be configured **not to require real tty** and any password
for them.

The main sudoers file suitable for the front-end with distribution-specific
command paths can be created by the sudoers generator
`sudo_commands.rb <https://github.com/OpenNebula/one/tree/master/share/sudoers>`_.
You only need to ensure that all listed commands are already installed on
your system so that the generator can detect their filesystem location.
Generated sudo commands aliases must be enabled additionally.

Example configuration
--------------------------------------------------------------------------------

You can put following ``sudo`` configuration template into
``/etc/sudoers.d/opennebula`` and replace example commands
``/bin/true`` and ``/bin/false`` with comma separated list of commands
listed above, with the absolute path specific for your platform.

.. code::

    Defaults:oneadmin !requiretty
    Defaults:oneadmin secure_path = /sbin:/bin:/usr/sbin:/usr/bin

    oneadmin ALL=(ALL) NOPASSWD: /bin/true, /bin/false

Qemu configuration
--------------------------------------------------------------------------------

Qemu should be configured to not change file ownership. Modify ``/etc/libvirt/qemu.conf`` to include ``dynamic_ownership = 0``. To be able to use the images copied by OpenNebula, change also the user and group below the dynamic_ownership setting"

LXD configuration
--------------------------------------------------------------------------------
Add oneadmin to the lxd and libvirt group:

.. code-block:: bash

    usermod -aG lxd oneadmin
    usermod -aG libvirt oneadmin

If you plan to user qcow2 images on LXD, then you should load the **nbd** kernel module.

.. code-block:: bash

    modprobe nbd

Starting OpenNebula
================================================================================

Setup authentication file.

.. code-block:: bash

    echo '$USER:password' > ~/.one/one_auth

Start the opennebula server

.. code::

    one start

Check it worked

.. code::

    oneuser show
    USER 0 INFORMATION
    ID              : 0
    NAME            : oneadmin
    GROUP           : oneadmin
    PASSWORD        : 4478db59d30855454ece114e8ccfa5563d21c9bd
    AUTH_DRIVER     : core
    ENABLED         : Yes

    TOKENS

    USER TEMPLATE
    TOKEN_PASSWORD="f99aab65e58162dc83a0fae59bec074a935c9a68"

    VMS USAGE & QUOTAS

    VMS USAGE & QUOTAS - RUNNING

    DATASTORE USAGE & QUOTAS

    NETWORK USAGE & QUOTAS

    IMAGE USAGE & QUOTAS
