.. _oned_conf:

===============================
OpenNebula Configuration (oned)
===============================

The OpenNebula Daemon (``oned``) is the **core service of the cloud management platform**. It manages the cluster nodes, virtual networks and storages, groups, users and their virtual machines, and provides the XML-RPC API to other services and end-users. The service is distributed as an operating system package ``opennebula`` with system service ``opennebula``.

Configuration
=============

The OpenNebula Daemon configuration file can be found in ``/etc/one/oned.conf`` on the Front-end and can be customized with parameters:

.. note::

    After a configuration change, the OpenNebula Daemon must be :ref:`restarted <oned_conf_service>` to take effect.

-  ``MANAGER_TIMER``: Time in seconds the core uses to evaluate periodical functions. ``MONITORING_INTERVAL`` cannot have a smaller value than ``MANAGER_TIMER``.
-  ``MONITORING_INTERVAL_DATASTORE``: Time in seconds between each Datastore monitoring cycle.
-  ``MONITORING_INTERVAL_MARKET``: Time in seconds between each Marketplace monitoring cycle.
-  ``MONITORING_INTERVAL_DB_UPDATE``: Time in seconds between DB writes of VM monitoring information. ``-1`` to disable DB updating and ``0`` to write every update.
-  ``DS_MONITOR_VM_DISK``: Number of ``MONITORING_INTERVAL_DATASTORE`` intervals to monitor VM disks. ``0`` to disable. Only applies to ``fs`` and ``fs_lvm`` datastores.
-  ``SCRIPTS_REMOTE_DIR``: Remote path to store the monitoring and VM management script.
-  ``PORT``: Port where ``oned`` will listen for XML-RPC calls.
-  ``LISTEN_ADDRESS``: Host IP to listen for XML-RPC calls (default: all IPs).
-  ``HOSTNAME``: Hostname to use instead of autodetect it. This hostname is used to connect to Front-end during driver operations.
-  ``DB``: Vector of configuration attributes for the database Back-end.

   -  ``BACKEND``: Set to ``sqlite`` or ``mysql`` or ``postgresql``. Please visit the :ref:`MySQL configuration guide <mysql>` or :ref:`PostgreSQL configuration guide <postgresql>` for more information.
   -  ``SERVER`` (MySQL only): Host name or IP address of the MySQL server.
   -  ``USER`` (MySQL only): MySQL user's login ID.
   -  ``PASSWD`` (MySQL only): MySQL user's password.
   -  ``DB_NAME`` (MySQL only): MySQL database name.
   -  ``COMPARE_BINARY`` (MySQL only): compare strings using BINARY clause makes name searches case sensitive.
   -  ``ENCODING`` (MySQL only): charset to use for the db connections
   -  ``CONNECTIONS`` (MySQL only): maximum number of connections to the MySQL server.
   -  ``TIMEOUT`` (SQLite only): timeout in ms for acquiring lock to DB, should be at least 100 ms
   -  ``ERRORS_LIMIT``: number of consecutive DB errors to stop oned node in HA. Default ``25``, use ``-1`` to disable this feature.

-  ``VNC_PORTS``: VNC port pool for automatic VNC port assignment. If possible, the port will be set to ``START`` + ``VMID``. Refer to the :ref:`VM template reference <template>` for further information:

   - ``START``: First port to assign.
   - ``RESERVED``: Comma-separated list of reserved ports or ranges. Two numbers separated by a colon indicate a range.

-  ``VM_SUBMIT_ON_HOLD``: Forces VMs to be created on hold state instead of pending. Values: ``YES`` or ``NO``.
-  ``API_LIST_ORDER``: Sets order (by ID) of elements in list API calls (e.g. ``onevm list``). Values: ``ASC`` (ascending order) or ``DESC`` (descending order).
-  ``LOG``: Configure the logging system

   -  ``SYSTEM``: Can be either ``file`` (default), ``syslog`` or ``std``
   -  ``DEBUG_LEVEL``: Sets the verbosity of the log messages. Possible values are:

+----------------+---------------+
| DEBUG\_LEVEL   | Meaning       |
+================+===============+
| ``0``          | **ERROR**     |
+----------------+---------------+
| ``1``          | **WARNING**   |
+----------------+---------------+
| ``2``          | **INFO**      |
+----------------+---------------+
| ``3``          | **DEBUG**     |
+----------------+---------------+

Example of this section:

.. code-block:: bash

    #*******************************************************************************
    # Daemon configuration attributes
    #*******************************************************************************

    LOG = [
      SYSTEM      = "file",
      DEBUG_LEVEL = 3
    ]

    #MANAGER_TIMER = 15

    MONITORING_INTERVAL_DATASTORE = 300
    MONITORING_INTERVAL_MARKET    = 600

    #DS_MONITOR_VM_DISK = 10

    SCRIPTS_REMOTE_DIR=/var/tmp/one

    PORT = 2633

    LISTEN_ADDRESS = "0.0.0.0"

    DB = [ BACKEND = "sqlite" ]

    # Sample configuration for MySQL
    # DB = [ BACKEND = "mysql",
    #        SERVER  = "localhost",
    #        PORT    = 0,
    #        USER    = "oneadmin",
    #        PASSWD  = "oneadmin",
    #        DB_NAME = "opennebula",
    #        CONNECTIONS = 50 ]

    VNC_PORTS = [
        START    = 5900,
        RESERVED = "32768:65536"
        # RESERVED = "6800, 6801, 9869"
    ]

    #VM_SUBMIT_ON_HOLD = "NO"
    #API_LIST_ORDER    = "DESC"

    .. _oned_conf_federation:

Federation Configuration Attributes
===================================

Control the :ref:`federation capabilities of oned <introf>`. Operation in a federated setup requires a special DB configuration.

-  ``FEDERATION``: Federation attributes.

   -  ``MODE``: Operation mode of this oned.

      -  ``STANDALONE``: Not federated. This is the default operational mode.
      -  ``MASTER``: This oned is the master Zone of the federation.
      -  ``SLAVE``: This oned is a slave Zone.

-  ``ZONE_ID``: The Zone ID, as returned by the ``onezone`` command.
-  ``MASTER_ONED``: The XML-RPC endpoint of the master oned, e.g. ``http://master.one.org:2633/RPC2``.

.. code-block:: bash

    #*******************************************************************************
    # Federation configuration attributes
    #*******************************************************************************

    FEDERATION = [
        MODE = "STANDALONE",
        ZONE_ID = 0,
        MASTER_ONED = ""
    ]

Raft Configuration Attributes
=============================

Opennebula uses the Raft algorithm. It can be tuned by the following options:

- ``LIMIT_PURGE``: Number of DB log records that will be deleted on each purge.
- ``LOG_RETENTION``: Number of DB log records kept. It determines the synchronization window across servers and extra storage space needed.
- ``LOG_PURGE_TIMEOUT``: How often applied records are purged according to the log retention value (in seconds).
- ``ELECTION_TIMEOUT_MS``: Timeout to start an election process if no heartbeat or log is received from the leader (in milliseconds).
- ``BROADCAST_TIMEOUT_MS``: How often heartbeats are sent to followers (in milliseconds).
- ``XMLRPC_TIMEOUT_MS``: Timeout for Raft-related API calls (in milliseconds). For an infinite timeout, set this value to ``0``.

Example:

.. code-block:: bash

    RAFT = [
        LIMIT_PURGE          = 100000,
        LOG_RETENTION        = 500000,
        LOG_PURGE_TIMEOUT    = 600,
        ELECTION_TIMEOUT_MS  = 2500,
        BROADCAST_TIMEOUT_MS = 500,
        XMLRPC_TIMEOUT_MS    = 450
    ]

.. _oned_conf_default_showback:

Default Showback Cost
=====================

The following attributes define the default cost for Virtual Machines that don't have a CPU, MEMORY or DISK costs. This is used by the :ref:`oneshowback calculate method <showback>`.

.. code-block:: bash

    #*******************************************************************************
    # Default showback cost
    #*******************************************************************************

    DEFAULT_COST = [
        CPU_COST    = 0,
        MEMORY_COST = 0,
        DISK_COST   = 0
    ]

.. _oned_conf_xml_rpc_server_configuration:

XML-RPC Server Configuration
============================

-  ``MAX_CONN``: Maximum number of simultaneous TCP connections the server will maintain
-  ``MAX_CONN_BACKLOG``: Maximum number of TCP connections the operating system will accept on the server's behalf without the server accepting them from the operating system
-  ``KEEPALIVE_TIMEOUT``: Maximum time in seconds that the server allows a connection to be open between RPCs
-  ``KEEPALIVE_MAX_CONN``: Maximum number of RPCs that the server will execute on a single connection
-  ``TIMEOUT``: Maximum time in seconds the server will wait for the client to do anything while processing an RPC. This timeout will also be used when a proxy calls to the master in a federation.
-  ``RPC_LOG``: Create a separate log file for XML-RPC requests, in ``/var/log/one/one_xmlrpc.log``.
-  ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses.
-  ``LOG_CALL_FORMAT``: Format string to log XML-RPC calls. Interpreted strings:

   -  ``%i`` -- request id
   -  ``%m`` -- method name
   -  ``%u`` -- user id
   -  ``%U`` -- user name
   -  ``%l[number]`` -- parameter list and number of characters (optional) to print each parameter, default is 20. Example: %l300
   -  ``%p`` -- user password
   -  ``%g`` -- group id
   -  ``%G`` -- group name
   -  ``%a`` -- auth token
   -  ``%%`` -- %

.. code-block:: bash

    #*******************************************************************************
    # XML-RPC server configuration
    #*******************************************************************************

    #MAX_CONN           = 15
    #MAX_CONN_BACKLOG   = 15
    #KEEPALIVE_TIMEOUT  = 15
    #KEEPALIVE_MAX_CONN = 30
    #TIMEOUT            = 15
    #RPC_LOG            = NO
    #MESSAGE_SIZE       = 1073741824
    #LOG_CALL_FORMAT    = "Req:%i UID:%u %m invoked %l"

.. warning:: This functionality is only available when compiled with xmlrpc-c libraries >= 1.32. Currently only the packages distributed by OpenNebula are linked with this library.

Virtual Networks
================

-  ``NETWORK_SIZE``: Here you can define the default size for the virtual networks
-  ``MAC_PREFIX``: Default MAC prefix to be used to create the auto-generated MAC addresses. (This can be overwritten by the Virtual Network template.)
-  ``VLAN_IDS``: VLAN ID pool for the automatic ``VLAN_ID`` assignment. This pool is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver will try first to allocate ``VLAN_IDS[START] + VNET_ID``

   - ``START``: First ``VLAN_ID`` to use
   - ``RESERVED``: Comma-separated list of reserved VLAN_IDs or ranges. Two numbers separated by a colon indicate a range.

-  ``VXLAN_IDS``: Automatic VXLAN Network ID (VNI) assignment. This is used for ``vxlan`` networks.

   -  ``START``: First VNI to use
   - Note: **Reserved is not supported by this pool**

Sample configuration:

.. code-block:: bash

    #*******************************************************************************
    # Physical Networks configuration
    #*******************************************************************************

    NETWORK_SIZE = 254

    MAC_PREFIX   = "02:00"

    VLAN_IDS = [
        START    = "2",
        RESERVED = "0, 1, 4095"
    ]

    VXLAN_IDS = [
        START = "2"
    ]

.. _oned_conf_datastores:

Datastores
==========

The :ref:`Storage Subsystem <sm>` allows users to set up images, which can be operating systems or data, to be used in Virtual Machines easily. These images can be used by several Virtual Machines simultaneously and also shared with other users.

Here you can configure the default values for the Datastores and Image templates. There is more information about the template syntax :ref:`here <img_template>`.

-  ``DATASTORE_LOCATION``: Path for Datastores. It is the same for all the hosts and Front-end. It defaults to ``/var/lib/one/datastores`` (or in self-contained mode defaults to ``$ONE_LOCATION/var/datastores``). Each datastore has its own directory (called ``BASE_PATH``) of the form: ``$DATASTORE_LOCATION/<datastore_id>``. You can symlink this directory to any other path, if needed. ``BASE_PATH`` is generated from this attribute each time oned is started.
-  ``DATASTORE_CAPACITY_CHECK``: Check that there is enough capacity before creating a new image. Defaults to ``yes``.
-  ``DEFAULT_IMAGE_TYPE``: Default value for ``TYPE`` field when it is omitted in a template. Values accepted are:

   -  ``OS``: Image file holding an operating system
   -  ``CDROM``: Image file holding a CDROM
   -  ``DATABLOCK``: Image file holding a datablock, created as an empty block

-  ``DEFAULT_DEVICE_PREFIX``: Default value for the ``DEV_PREFIX`` field when it is omitted in a template. The missing ``DEV_PREFIX`` attribute is filled when images are created, so changing this prefix won't affect existing images. It can be set to:

+----------+--------------------+
| Prefix   | Device type        |
+==========+====================+
| ``hd``   | IDE                |
+----------+--------------------+
| ``sd``   | SCSI               |
+----------+--------------------+
| ``vd``   | KVM virtio disk    |
+----------+--------------------+

- ``DEFAULT_CDROM_DEVICE_PREFIX``: Same as above but for CD-ROM devices.

- ``DEFAULT_IMAGE_PERSISTENT``: Control the default value for the ``PERSISTENT`` attribute on image cloning or saving (``oneimage clone``, ``onevm disk-saveas``). If omitted, images will inherit the ``PERSISTENT`` attribute from the base image.

- ``DEFAULT_IMAGE_PERSISTENT_NEW``: Control the default value for the ``PERSISTENT`` attribute on image creation (``oneimage create``). By default images are not persistent if this is not set.

More information on the image repository can be found in the :ref:`Managing Virtual Machine Images guide <images>`.

Sample configuration:

.. code-block:: bash

    #*******************************************************************************
    # Image Repository Configuration
    #*******************************************************************************
    #DATASTORE_LOCATION  = /var/lib/one/datastores

    DATASTORE_CAPACITY_CHECK = "yes"

    DEFAULT_IMAGE_TYPE    = "OS"
    DEFAULT_DEVICE_PREFIX = "hd"

    DEFAULT_CDROM_DEVICE_PREFIX = "hd"

    #DEFAULT_IMAGE_PERSISTENT     = ""
    #DEFAULT_IMAGE_PERSISTENT_NEW = "NO"

Information Collector
=====================

This driver **cannot be assigned to a host**, and needs to be used with KVM drivers. These are the options that can be set:

-  ``-a``: Address to bind the ``collectd`` socket (default ``0.0.0.0``)
-  ``-p``: UDP port to listen for monitor information (default ``4124``)
-  ``-f``: Interval in seconds to flush collected information (default ``5``)
-  ``-t``: Number of threads for the server (default ``50``)
-  ``-i``: Time in seconds of the monitoring push cycle. This parameter must be smaller than ``MONITORING_INTERVAL``, otherwise push monitoring will not be effective.

Sample configuration:

.. code-block:: bash

    IM_MAD = [
          NAME       = "collectd",
          EXECUTABLE = "collectd",
          ARGUMENTS  = "-p 4124 -f 5 -t 50 -i 20" ]

Information Drivers
===================

The information drivers are used to gather information from the cluster nodes and they depend on the virtualization you are using. You can define more than one information manager, but make sure they have different names. To define one, the following need to be set:

-  **name**: name for this information driver.
-  **executable**: path of the information driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable, usually a probe configuration fileas an absolute path or relative to ``/etc/one/``.

For more information on configuring the information and monitoring system and hints to extend it, please check the :ref:`information driver configuration guide <devel-im>`.

Sample configuration:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    #  KVM UDP-push Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    IM_MAD = [
          NAME          = "kvm",
          SUNSTONE_NAME = "KVM",
          EXECUTABLE    = "one_im_ssh",
          ARGUMENTS     = "-r 3 -t 15 kvm" ]
    #-------------------------------------------------------------------------------

.. _oned_conf_virtualization_drivers:

Virtualization Drivers
======================

The virtualization drivers are used to create, control and monitor VMs on the hosts. You can define more than one virtualization driver (e.g. you have different virtualizers in several hosts) but make sure they have different names. To define one, the following need to be set:

-  ``NAME``: Name of the virtualization driver
-  ``SUNSTONE_NAME``: Name displayed in Sunstone
-  ``EXECUTABLE``: Path of the virtualization driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
-  ``ARGUMENTS``: For the driver executable
-  ``TYPE``: Driver type; supported drivers: ``xen``, ``kvm`` or ``xml``
-  ``DEFAULT``: File containing default values and configuration parameters for the driver as an absolute path or relative to ``/etc/one/``
-  ``KEEP_SNAPSHOTS``: Do not remove snapshots on power on/off cycles and live migrations if the hypervisor supports that
-  ``LIVE_RESIZE``: Hypervisor supports hotplug VCPU and memory. Values: ``YES`` or ``NO``
-  ``SUPPORT_SHAREABLE``: Hypervisor supports shareable disks. Values: ``YES`` or ``NO``
-  ``IMPORTED_VMS_ACTIONS``: Comma-separated list of actions supported for imported VMs. The available actions are:

   - ``migrate``
   - ``live-migrate``
   - ``terminate``
   - ``terminate-hard``
   - ``undeploy``
   - ``undeploy-hard``
   - ``hold``
   - ``release``
   - ``stop``
   - ``suspend``
   - ``resume``
   - ``delete``
   - ``delete-recreate``
   - ``reboot``
   - ``reboot-hard``
   - ``resched``
   - ``unresched``
   - ``poweroff``
   - ``poweroff-hard``
   - ``disk-attach``
   - ``disk-detach``
   - ``nic-attach``
   - ``nic-detach``
   - ``snap-create``
   - ``snap-delete``

There are some non-mandatory attributes:

- ``DS_LIVE_MIGRATION``: live migration between datastores is allowed.
- ``COLD_NIC_ATTACH``: NIC attach/detach in poweroff state calls networks scripts (``pre``, ``post``, ``clean``) and virtualization driver attach/detach actions.

For more information on configuring and setting up the Virtual Machine Manager Driver please check the section relevant to you:

* :ref:`KVM Driver <kvmg>`
* :ref:`vCenter Driver <vcenterg>`

Sample configuration:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    # Virtualization Driver Configuration
    #-------------------------------------------------------------------------------

    VM_MAD = [
        NAME           = "kvm",
        SUNSTONE_NAME  = "KVM",
        EXECUTABLE     = "one_vmm_exec",
        ARGUMENTS      = "-t 15 -r 0 kvm",
        DEFAULT        = "vmm_exec/vmm_exec_kvm.conf",
        TYPE           = "kvm",
        KEEP_SNAPSHOTS = "no",
        LIVE_RESIZE    = "yes",
        SUPPORT_SHAREABLE    = "yes",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, disk-attach,
            disk-detach, nic-attach, nic-detach, snap-create, snap-delete"
    ]

.. _oned_conf_transfer_driver:

Transfer Driver
===============

The transfer drivers are used to transfer, clone, remove and create VM images. The default ``TM_MAD`` driver includes plugins for all supported storage modes. You may need to modify the ``TM_MAD`` to add custom plugins.

-  ``EXECUTABLE``: path of the transfer driver executable, as an absolute path or relative to ``/usr/lib/one/mads/``
-  ``ARGUMENTS``: for the driver executable:

   -  ``-t``: number of threads, i.e. number of transfers made at the same time
   -  ``-d``: list of transfer drivers separated by commas. If not defined all the drivers available will be enabled

For more information on configuring different storage alternatives please check the :ref:`storage configuration <sm>` guide.

Sample configuration:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    # Transfer Manager Driver Configuration
    #-------------------------------------------------------------------------------

    TM_MAD = [
        EXECUTABLE = "one_tm",
        ARGUMENTS = "-t 15 -d dummy,lvm,shared,fs_lvm,qcow2,ssh,ceph,dev,vcenter,iscsi_libvirt"
    ]

The configuration for each driver is defined in the ``TM_MAD_CONF`` section. These values are used when creating a new datastore and should not be modified since they define the datastore behavior.

-  ``NAME``: name of the transfer driver, listed in the ``-d`` option of the ``TM_MAD`` section
-  ``LN_TARGET``: determines how persistent images will be cloned when a new VM is instantiated:

   -  ``NONE``: The image will be linked and no more storage capacity will be used
   -  ``SELF``: The image will be cloned in the Images datastore
   -  ``SYSTEM``: The image will be cloned in the System datastore

-  ``CLONE_TARGET``: determines how non-persistent images will be cloned when a new VM is instantiated:

   -  ``NONE``: The image will be linked and no more storage capacity will be used
   -  ``SELF``: The image will be cloned in the Images datastore
   -  ``SYSTEM``: The image will be cloned in the System datastore

-  ``SHARED``: determines if the storage holding the system datastore is shared among the different hosts or not. Valid values: ``yes`` or ``no``.

- ``DS_MIGRATE``: set to ``YES`` if system datastore migrations are allowed for this TM. Only useful for system datastore TMs.

- ``ALLOW_ORPHANS``: Whether snapshots can live without parents. It allows three values: ``YES``, ``NO`` and ``MIXED``. The last mode, ``MIXED``, allows the creation of orphan snapshots but takes into account some dependencies which can appear after a revert snapshot action on Ceph datastores.

Sample configuration:

.. code-block:: bash

    TM_MAD_CONF = [
        NAME          = "lvm",
        LN_TARGET     = "NONE",
        CLONE_TARGET  = "SELF",
        SHARED        = "yes",
        ALLOW_ORPHANS = "no"
    ]

    TM_MAD_CONF = [
        NAME        = "shared",
        LN_TARGET   = "NONE",
        CLONE_TARGET= "SYSTEM",
        SHARED      = "yes",
        DS_MIGRATE  = "yes"
    ]

Datastore Driver
================

The Datastore Driver defines a set of scripts to manage the storage Back-end.

-  ``EXECUTABLE``: path of the transfer driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
-  ``ARGUMENTS``: for the driver executable

   -  ``-t`` number of threads, i.e. number of simultaneous repo operations
   -  ``-d`` datastore MADs, separated by commas
   -  ``-s`` system datastore TM drivers, used to monitor shared system DS

Sample configuration:

.. code-block:: bash

    DATASTORE_MAD = [
        EXECUTABLE = "one_datastore",
        ARGUMENTS  = "-t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter -s shared,ssh,ceph,fs_lvm"
    ]

For more information on this driver and how to customize it, please visit the :ref:`storage configuration <sm>` guide.

Marketplace Driver Configuration
================================================================================

Drivers to manage different marketplaces, specialized for the storage Back-end

-  ``EXECUTABLE``: path of the transfer driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
-  ``ARGUMENTS``: for the driver executable:

   -  ``-t`` number of threads, i.e. number of simultaneous repo operations
   -  ``-m`` marketplace mads separated by commas
   -  ``--proxy`` proxy URI, if required to access the internet. For example ``--proxy http://1.2.3.4:5678``
   -  ``-w`` timeout in seconds to execute external commands (default unlimited)

Sample configuration:

.. code-block:: bash

  MARKET_MAD = [
      EXECUTABLE = "one_market",
      ARGUMENTS  = "-t 15 -m http,s3,one"
  ]

Hook System
===========

Hooks in OpenNebula are programs (usually scripts) whose execution is triggered by a change in state in Virtual Machines or Hosts. The hooks can be executed either locally or remotely to the node where the VM or Host is running. To configure the Hook System the following needs to be set in the OpenNebula configuration file:

-  ``EXECUTABLE``: path of the hook driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
-  ``ARGUMENTS``: for the driver executable as an absolute path or relative to ``/etc/one/``

Sample configuration:

.. code-block:: bash

    HM_MAD = [
        executable = "one_hm" ]

Virtual Machine Hooks (VM\_HOOK) defined by:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ``NAME``: for the hook; useful to track the hook (OPTIONAL).
-  ``ON``: when the hook should be executed:

   -  ``CREATE``: when the VM is created (``onevm create``)
   -  ``PROLOG``: when the VM is in the prolog state
   -  ``RUNNING``: after the VM is successfully booted
   -  ``UNKNOWN``: when the VM is in the unknown state
   -  ``SHUTDOWN``: after the VM is shutdown
   -  ``STOP``: after the VM is stopped (including VM image transfers)
   -  ``DONE``: after the VM is deleted or shutdown
   -  ``CUSTOM``: user defined specific ``STATE`` and ``LCM_STATE`` combination of states to trigger the hook

-  ``COMMAND``: as an absolute path or relative to ``/usr/share/one/hooks``
-  ``ARGUMENTS``: for the hook. You can substitute VM information with:

   -  ``$ID``: the ID of the virtual machine
   -  ``$TEMPLATE``: the VM template as base64-encoded XML
   -  ``PREV_STATE``: the previous ``STATE`` of the Virtual Machine
   -  ``PREV_LCM_STATE``: the previous ``LCM_STATE`` of the Virtual Machine

-  ``REMOTE``: values:

   -  ``YES``: The hook is executed in the host where the VM was allocated
   -  ``NO``: The hook is executed in the OpenNebula server (default)

Host Hooks (HOST\_HOOK) defined by:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  ``NAME``: for the hook, useful to track the hook (OPTIONAL)
-  ``ON``: when the hook should be executed,

   -  ``CREATE``: when the Host is created (``onehost create``)
   -  ``ERROR``: when the Host enters the error state
   -  ``DISABLE``: when the Host is disabled

-  ``COMMAND``: as an absolute path or relative to ``/usr/share/one/hooks``
-  ``ARGUMENTS``: for the hook. You can use the following Host information:

   -  ``$ID``: the ID of the host
   -  ``$TEMPLATE``: the Host template as base64-encoded XML

-  ``REMOTE``: values,

   -  ``YES``: The hook is executed in the host
   -  ``NO``: The hook is executed in the OpenNebula server (default)

Sample configuration:

.. code-block:: bash


    VM_HOOK = [
      name      = "advanced_hook",
      on        = "CUSTOM",
      state     = "ACTIVE",
      lcm_state = "BOOT_UNKNOWN",
      command   = "log.rb",
      arguments = "$ID $PREV_STATE $PREV_LCM_STATE" ]

.. _oned_auth_manager_conf:

Auth Manager Configuration
==========================

-  ``AUTH_MAD``: The :ref:`driver <external_auth>` that will be used to authenticate and authorize OpenNebula requests. If not defined, OpenNebula will use the built-in authorization policies.

   -  ``EXECUTABLE``: path of the auth driver executable as an absolute path or relative to ``/usr/lib/one/mads/``
   -  ``AUTHN``: list of authentication modules, separated by commas. If not defined, all the modules available will be enabled
   -  ``AUTHZ``: list of authorization modules, separated by commas

-  ``SESSION_EXPIRATION_TIME``: Time in seconds for which an authenticated token is valid. During this time the driver is not used. Use ``0`` to disable session caching.
-  ``ENABLE_OTHER_PERMISSIONS``: Whether or not to enable the permissions for 'other'. Users in the oneadmin group will still be able to change these permissions. Values: ``YES`` or ``NO``.
-  ``DEFAULT_UMASK``: Similar to Unix umask. Sets the default resource permissions. Its format must be 3 octal digits. For example a umask of 137 will set the new object's permissions to 640 ``um- u-- ---``.

Sample configuration:

.. code-block:: bash

    AUTH_MAD = [
        executable = "one_auth_mad",
        authn = "ssh,x509,ldap,server_cipher,server_x509"
    ]

    SESSION_EXPIRATION_TIME = 900

    #ENABLE_OTHER_PERMISSIONS = "YES"

    DEFAULT_UMASK = 177

The ``DEFAULT_AUTH`` can be used to point to the desired default authentication driver, for example ``ldap``:

.. code-block:: bash

    DEFAULT_AUTH = "ldap"

.. _oned_conf_vm_operations:

VM Operations Permissions
=========================

The following parameters define the operations associated with the **ADMIN**,
**MANAGE** and **USE** permissions. Note that some VM operations may require additional
permissions on other objects. Also some operations refer to a class of
actions:

- ``disk-snapshot``: includes ``create``, ``delete`` and revert actions
- ``disk-attach``: includes ``attach`` and ``detach`` actions
- ``nic-attach``: includes ``attach`` and ``detach`` actions
- ``snapshot``: includes ``create``, ``delete`` and ``revert`` actions
- ``resched``: includes ``resched`` and ``unresched`` actions

The list and show operations require **USE** permission; this is not configurable.

In the following example you need **ADMIN** rights on a VM to perform ``migrate``, ``delete``, ``recover`` ... while ``undeploy``, ``hold``, ... need **MANAGE** rights:

.. code-block:: bash

    VM_ADMIN_OPERATIONS  = "migrate, delete, recover, retry, deploy, resched"

    VM_MANAGE_OPERATIONS = "undeploy, hold, release, stop, suspend, resume, reboot,
        poweroff, disk-attach, nic-attach, disk-snapshot, terminate, disk-resize,
        snapshot, updateconf, rename, resize, update, disk-saveas"

    VM_USE_OPERATIONS    = ""

.. _oned_conf_restricted_attributes_configuration:

Restricted Attributes Configuration
===================================

Users outside the ``oneadmin`` group won't be able to instantiate templates created by users outside the ``oneadmin`` group that include attributes restricted by:

-  ``VM_RESTRICTED_ATTR``: Virtual Machine attribute to be restricted for users outside the oneadmin group
-  ``IMAGE_RESTRICTED_ATTR``: Image attribute to be restricted for users outside the oneadmin group
-  ``VNET_RESTRICTED_ATTR``: Virtual Network attribute to be restricted for users outside the oneadmin group when updating a reservation. These attributes are not considered for regular VNET creation.

If the VM template has been created by admins in the ``oneadmin`` group, then users outside the oneadmin group **can** instantiate these templates.

Sample configuration:

.. code-block:: bash

    VM_RESTRICTED_ATTR = "CONTEXT/FILES"
    VM_RESTRICTED_ATTR = "NIC/MAC"
    VM_RESTRICTED_ATTR = "NIC/VLAN_ID"
    VM_RESTRICTED_ATTR = "NIC/BRIDGE"
    VM_RESTRICTED_ATTR = "NIC_DEFAULT/MAC"
    VM_RESTRICTED_ATTR = "NIC_DEFAULT/VLAN_ID"
    VM_RESTRICTED_ATTR = "NIC_DEFAULT/BRIDGE"
    VM_RESTRICTED_ATTR = "DISK/TOTAL_BYTES_SEC"
    VM_RESTRICTED_ATTR = "DISK/READ_BYTES_SEC"
    VM_RESTRICTED_ATTR = "DISK/WRITE_BYTES_SEC"
    VM_RESTRICTED_ATTR = "DISK/TOTAL_IOPS_SEC"
    VM_RESTRICTED_ATTR = "DISK/READ_IOPS_SEC"
    VM_RESTRICTED_ATTR = "DISK/WRITE_IOPS_SEC"
    #VM_RESTRICTED_ATTR = "DISK/SIZE"
    VM_RESTRICTED_ATTR = "DISK/ORIGINAL_SIZE"
    VM_RESTRICTED_ATTR = "CPU_COST"
    VM_RESTRICTED_ATTR = "MEMORY_COST"
    VM_RESTRICTED_ATTR = "DISK_COST"
    VM_RESTRICTED_ATTR = "PCI"
    VM_RESTRICTED_ATTR = "USER_INPUTS"

    #VM_RESTRICTED_ATTR = "RANK"
    #VM_RESTRICTED_ATTR = "SCHED_RANK"
    #VM_RESTRICTED_ATTR = "REQUIREMENTS"
    #VM_RESTRICTED_ATTR = "SCHED_REQUIREMENTS"

    IMAGE_RESTRICTED_ATTR = "SOURCE"

    VNET_RESTRICTED_ATTR = "VN_MAD"
    VNET_RESTRICTED_ATTR = "PHYDEV"
    VNET_RESTRICTED_ATTR = "VLAN_ID"
    VNET_RESTRICTED_ATTR = "BRIDGE"

    VNET_RESTRICTED_ATTR = "AR/VN_MAD"
    VNET_RESTRICTED_ATTR = "AR/PHYDEV"
    VNET_RESTRICTED_ATTR = "AR/VLAN_ID"
    VNET_RESTRICTED_ATTR = "AR/BRIDGE"

OpenNebula evaluates these attributes:

- on VM template instantiate (``onetemplate instantiate``)
- on VM create (``onevm create``)
- on VM attach NIC (``onevm nic-attach``), for example, to prevent using ``NIC/MAC``

.. _encrypted_attrs:

Encrypted Attributes Configuration
==================================

These attributes are encrypted and decrypted by the OpenNebula core. The supported attributes are:

- ``CLUSTER_ENCRYPTED_ATTR``
- ``DOCUMENT_ENCRYPTED_ATTR``
- ``DATASTORE_ENCRYPTED_ATTR``
- ``HOST_ENCRYPTED_ATTR``
- ``VM_ENCRYPTED_ATTR``: these attributes apply also to the user template.
- ``VNET_ENCRYPTED_ATTR``: these attributes apply also to address ranges which belong to the virtual network.

Sample configuration:

.. code-block:: bash

    DOCUMENT_ENCRYPTED_ATTR = "PROVISION_BODY"

    HOST_ENCRYPTED_ATTR = "AZ_ID"
    HOST_ENCRYPTED_ATTR = "AZ_CERT"
    HOST_ENCRYPTED_ATTR = "VCENTER_PASSWORD"
    HOST_ENCRYPTED_ATTR = "NSX_PASSWORD"
    HOST_ENCRYPTED_ATTR = "ONE_PASSWORD"

    VM_ENCRYPTED_ATTR = "ONE_PASSWORD"
    VM_ENCRYPTED_ATTR = "CONTEXT/PASSWORD"

OpenNebula encrypts these attributes:

- on object create (``onecluster/onedatastore/onehost/onevm/onevnet create``)
- on object update (``onecluster/onedatastore/onehost/onevm/onevnet update``)

To decrypt the attribute, you need to use the ``info`` API method with ``true`` as a parameter. You can decrypt the attributes using the ``--decrypt`` option for ``onevm show``, ``onehost show`` and ``onevnet show``.

Inherited Attributes Configuration
==================================

The following attributes will be copied from the resource template to the instantiated VMs. More than one attribute can be defined.

-  ``INHERIT_IMAGE_ATTR``: Attribute to be copied from the Image template to each ``VM/DISK``.
-  ``INHERIT_DATASTORE_ATTR``: Attribute to be copied from the Datastore template to each ``VM/DISK``.
-  ``INHERIT_VNET_ATTR``: Attribute to be copied from the Network template to each ``VM/NIC``.

Sample configuration:

.. code-block:: bash

    #INHERIT_IMAGE_ATTR     = "EXAMPLE"
    #INHERIT_IMAGE_ATTR     = "SECOND_EXAMPLE"
    #INHERIT_DATASTORE_ATTR = "COLOR"
    #INHERIT_VNET_ATTR      = "BANDWIDTH_THROTTLING"

    INHERIT_DATASTORE_ATTR  = "CEPH_HOST"
    INHERIT_DATASTORE_ATTR  = "CEPH_SECRET"
    INHERIT_DATASTORE_ATTR  = "CEPH_USER"
    INHERIT_DATASTORE_ATTR  = "CEPH_CONF"
    INHERIT_DATASTORE_ATTR  = "POOL_NAME"

    INHERIT_DATASTORE_ATTR  = "ISCSI_USER"
    INHERIT_DATASTORE_ATTR  = "ISCSI_USAGE"
    INHERIT_DATASTORE_ATTR  = "ISCSI_HOST"

    INHERIT_IMAGE_ATTR      = "ISCSI_USER"
    INHERIT_IMAGE_ATTR      = "ISCSI_USAGE"
    INHERIT_IMAGE_ATTR      = "ISCSI_HOST"
    INHERIT_IMAGE_ATTR      = "ISCSI_IQN"

    INHERIT_DATASTORE_ATTR  = "GLUSTER_HOST"
    INHERIT_DATASTORE_ATTR  = "GLUSTER_VOLUME"

    INHERIT_DATASTORE_ATTR  = "DISK_TYPE"
    INHERIT_DATASTORE_ATTR  = "ADAPTER_TYPE"

    INHERIT_IMAGE_ATTR      = "DISK_TYPE"
    INHERIT_IMAGE_ATTR      = "ADAPTER_TYPE"

    INHERIT_VNET_ATTR       = "VLAN_TAGGED_ID"
    INHERIT_VNET_ATTR       = "FILTER_IP_SPOOFING"
    INHERIT_VNET_ATTR       = "FILTER_MAC_SPOOFING"
    INHERIT_VNET_ATTR       = "MTU"
    INHERIT_VNET_ATTR       = "METRIC"

.. _oned_conf_onegate:

OneGate Configuration
=====================

-  ``ONEGATE_ENDPOINT``: Endpoint where OneGate will be listening. Optional.

Sample configuration:

.. code-block:: bash

    ONEGATE_ENDPOINT = "http://192.168.0.5:5030"

Default Permissions for VDC ACL rules
=====================================

Default ACL rules created when a resource is added to a VDC. The following attributes configure the permissions granted to the VDC group for each resource type:

-  ``DEFAULT_VDC_HOST_ACL``: permissions granted on hosts added to a VDC.
-  ``DEFAULT_VDC_NET_ACL``: permissions granted on vnets added to a VDC.
-  ``DEFAULT_VDC_DATASTORE_ACL``: permissions granted on datastores to a VDC.
-  ``DEFAULT_VDC_CLUSTER_HOST_ACL``: permissions granted to cluster hosts when a cluster is added to the VDC.
-  ``DEFAULT_VDC_CLUSTER_NET_ACL``: permissions granted to cluster vnets when a cluster is added to the VDC.
-  ``DEFAULT_VDC_CLUSTER_DATASTORE_ACL``: permissions granted to a datastores added to a cluster.

When defining the permissions you can use ``""`` or ``"-"`` to avoid adding any rule to that specific resource. Also, you can combine several permissions with ``"+"``, for example ``"MANAGE+USE"``. Valid permissions are **USE**, **MANAGE**, or **ADMIN**.

Example:

.. code-block:: bash

    DEFAULT_VDC_HOST_ACL      = "MANAGE"
    #Adds @<gid> HOST/#<hid> MANAGE #<zid> when a host is added to the VDC.
    onevdc addhost <vdc> <zid> <hid>

    DEFAULT_VDC_NET_ACL       = "USE"
    #Adds @<gid> NET/#<vnetid> USE #<zid> when a vnet is added to the VDC.
    onevdc addvnet <vdc> <zid> <vnetid>

    DEFAULT_VDC_DATASTORE_ACL = "USE"
    #Adds @<gid> DATASTORE/#<dsid> USE #<zid> when a vnet is added to the VDC.
    onevdc adddatastore <vdc> <zid> <dsid>

    DEFAULT_VDC_CLUSTER_HOST_ACL      = "MANAGE"
    DEFAULT_VDC_CLUSTER_NET_ACL       = "USE"
    DEFAULT_VDC_CLUSTER_DATASTORE_ACL = "USE"
    #Adds:
    #@<gid> HOST/%<cid> MANAGE #<zid>
    #@<gid> DATASTORE+NET/%<cid> USE #<zid>
    #when a cluster is added to the VDC.
    onevdc addcluster <vdc> <zid> <cid>

.. _oned_conf_service:

Service Control and Logs
========================

Change the server running state by managing the operating system service ``opennebula``.

To start, restart, stop the server, execute one of:

.. prompt:: bash # auto

    # systemctl start   opennebula
    # systemctl restart opennebula
    # systemctl stop    opennebula

To enable or disable automatic start on host boot, execute one of:

.. prompt:: bash # auto

    # systemctl enable  opennebula
    # systemctl disable opennebula

Server **logs** are located in ``/var/log/one`` in following files:

- ``/var/log/one/oned.log``
- ``/var/log/one/one_xmlrpc.log`` (optional, if ``RPC_LOG`` enabled)

Logs of individual VMs can be found in

- ``/var/log/one/$ID.log`` where ``$ID`` identifies the VM

Other logs are also available in Journald, use the following command to show:

.. prompt:: bash # auto

    # journalctl -u opennebula.service

.. important::

    See :ref:`Troubleshooting <troubleshoot_additional>` guide to learn about the logging of individual OpenNebula Daemon subsystems and drivers.
