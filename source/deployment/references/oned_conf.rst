.. _oned_conf:

===================
ONED Configuration
===================

The OpenNebula daemon ``oned`` manages the cluster nodes, virtual networks, virtual machines, users, groups and storage datastores. The configuration file for the daemon is called ``oned.conf`` and it is placed inside the ``/etc/one`` directory. In this reference document we describe all the format and options that can be specified in ``oned.conf``.

Daemon Configuration Attributes
===============================

-  ``MANAGER_TIMER`` : Time in seconds the core uses to evaluate periodical functions. MONITORING\_INTERVAL cannot have a smaller value than MANAGER\_TIMER.
-  ``MONITORING_INTERVA_HOST`` : Time in seconds between each HOST monitorization.
-  ``MONITORING_INTERVAL_VM`` : Time in seconds between each VMs monitorization.
-  ``MONITORING_INTERVAL_DATASTORE`` : Time in seconds between each DATASTORE monitorization.
-  ``MONITORING_INTERVAL_MARKET`` : Time in seconds between each MARKETPLACE monitorization.
-  ``MONITORING_THREADS`` : Max. number of threads used to process monitor messages
-  ``HOST_PER_INTERVAL``: Number of hosts monitored in each interval.
-  ``HOST_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Use 0 to disable HOST monitoring recording.
-  ``VM_INDIVIDUAL_MONITORING``: VM monitoring information is obtained along with the host information. For some custom monitor drivers you may need activate the individual VM monitoring process.
-  ``VM_PER_INTERVAL``: Number of VMs monitored in each interval.
-  ``VM_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Use 0 to disable VM monitoring recording.
-  ``SCRIPTS_REMOTE_DIR``: Remote path to store the monitoring and VM management script.
-  ``PORT`` : Port where oned will listen for xml-rpc calls.
-  ``LISTEN_ADDRESS``: Host IP to listen on for xmlrpc calls (default: all IPs).
-  ``DB`` : Vector of configuration attributes for the database back-end.

   -  ``backend`` : Set to ``sqlite`` or ``mysql``. Please visit the :ref:`MySQL configuration guide <mysql>` for more information.
   -  ``server`` (MySQL only): Host name or an IP address for the MySQL server.
   -  ``user`` (MySQL only): MySQL user's login ID.
   -  ``passwd`` (MySQL only): MySQL user's password.
   -  ``db_name`` (MySQL only): MySQL database name.
   -  ``connections`` (MySQL only): number of max. connections to MySQL server.

-  ``VNC_PORTS`` : VNC port pool for automatic VNC port assignment, if possible the port will be set to ``START`` + ``VMID``. Refer to the :ref:`VM template reference <template>` for further information:

   - ``start``: first port to assign
   - ``reserved``: comma separated list of reserved ports or ranges. Two numbers separated by a colon indicate a range.

-  ``VM_SUBMIT_ON_HOLD`` : Forces VMs to be created on hold state instead of pending. Values: YES or NO.
-  ``API_LIST_ORDER`` : Sets order (by ID) of elements in list API calls (e.g. onevm list). Values: ASC (ascending order) or DESC (descending order).
-  ``LOG`` : Configure the logging system

   -  ``SYSTEM`` : Can be either ``file`` (default), ``syslog`` or ``std``
   -  ``DEBUG_LEVEL`` : Sets the level of verbosity of the log messages. Possible values are:

+----------------+---------------+
| DEBUG\_LEVEL   | Meaning       |
+================+===============+
| 0              | **ERROR**     |
+----------------+---------------+
| 1              | **WARNING**   |
+----------------+---------------+
| 2              | **INFO**      |
+----------------+---------------+
| 3              | **DEBUG**     |
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

    MONITORING_INTERVAL_HOST = 180
    MONITORING_INTERVAL_VMS  = 180
    MONITORING_INTERVAL_DATASTORE = 300
    MONITORING_INTERVAL_MARKET    = 600
    
    MONITORING_THREADS  = 50

    #HOST_PER_INTERVAL               = 15
    #HOST_MONITORING_EXPIRATION_TIME = 43200

    #VM_INDIVIDUAL_MONITORING      = "no"
    #VM_PER_INTERVAL               = 5
    #VM_MONITORING_EXPIRATION_TIME = 14400

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
        START    = 5900
    #    RESERVED = "6800, 6801, 9869"
    ]

    #VM_SUBMIT_ON_HOLD = "NO"
    #API_LIST_ORDER    = "DESC"

    .. _oned_conf_federation:

Federation Configuration Attributes
=================================================

Control the :ref:`federation capabilities of oned <introf>`. Operation in a federated setup requires a special DB configuration.

-  ``FEDERATION`` : Federation attributes.

   -  ``MODE`` : Operation mode of this oned.

      -  ``STANDALONE``: not federated. This is the default operational mode
      -  ``MASTER``: this oned is the master zone of the federation
      -  ``SLAVE``: this oned is a slave zone

-  ``ZONE_ID`` : The zone ID as returned by onezone command.
-  ``MASTER_ONED`` : The xml-rpc endpoint of the master oned, e.g. http://master.one.org:2633/RPC2

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
================================================================================

The Raft algorithm can be tuned by several parameters in the configuration file ``/etc/one/oned.conf``. Following options are available:

- ``LIMIT_PURGE``: Number of DB log records that will be deleted on each purge.
- ``LOG_RETENTION``: Number of DB log records kept, it determines the synchronization window across servers and extra storage space needed.
- ``LOG_PURGE_TIMEOUT``: How often applied records are purged according the log retention value. (in seconds)
- ``ELECTION_TIMEOUT_MS``: Timeout to start a election process if no heartbeat or log is received from leader.
- ``BROADCAST_TIMEOUT_MS``: How often heartbeats are sent to  followers.
- ``XMLRPC_TIMEOUT_MS``: To timeout raft related API calls. To set an infinite  timeout set this value to 0.

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
================================================================================

The following attributes define the default cost for Virtual Machines that don't have a CPU, MEMORY or DISK cost. This is used by the :ref:`oneshowback calculate method <showback>`.

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
-  ``TIMEOUT``: Maximum time in seconds the server will wait for the client to do anything while processing an RPC. This timeout will be also used when proxy calls to the master in a federation.
-  ``RPC_LOG``: Create a separated log file for xml-rpc requests, in /var/log/one/one_xmlrpc.log.
-  ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses.
-  ``LOG_CALL_FORMAT``: Format string to log XML-RPC calls. Interpreted strings:

   -  ``%i`` -- request id
   -  ``%m`` -- method name
   -  ``%u`` -- user id
   -  ``%U`` -- user name
   -  ``%l[number]`` -- param list and number of characters (optional) to print each parameter, default is 20. Example: %l300
   -  ``%p`` -- user password
   -  ``%g`` -- group id
   -  ``%G`` -- group name
   -  ``%a`` -- auth token
   -  ``%A`` -- request IP address
   -  ``%P`` -- request port
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

.. warning:: This functionality is only available when compiled with xmlrpc-c libraires >= 1.32. Currently only the packages distributed by OpenNebula are linked with this library.

Virtual Networks
================

-  ``NETWORK_SIZE``: Here you can define the default size for the virtual networks
-  ``MAC_PREFIX``: Default MAC prefix to be used to create the auto-generated MAC addresses is defined here (this can be overwritten by the Virtual Network template)
-  ``VLAN_IDS``: VLAN ID pool for the automatic VLAN_ID assignment. This pool is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver will try first to allocate VLAN_IDS[START] + VNET_ID

   - ``start``: First VLAN_ID to use
   - ``reserved``: Comma separated list of VLAN_IDs or ranges. Two numbers separated by a colon indicate a range.

-  ``VXLAN_IDS``: Automatic VXLAN Network ID (VNI) assignment. This is used for vxlan networks.

   -  ``start``: First VNI to use
   - .. note:: reserved is not supported by this pool

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

The :ref:`Storage Subsystem <sm>` allows users to set up images, which can be operative systems or data, to be used in Virtual Machines easily. These images can be used by several Virtual Machines simultaneously, and also shared with other users.

Here you can configure the default values for the Datastores and Image templates. You have more information about the templates syntax :ref:`here <img_template>`.

-  ``DATASTORE_LOCATION``: Path for Datastores. It IS the same for all the hosts and front-end. It defaults to /var/lib/one/datastores (in self-contained mode defaults to $ONE_LOCATION/var/datastores). Each datastore has its own directory (called BASE_PATH) in the form: ``$DATASTORE_LOCATION/<datastore_id>``. You can symlink this directory to any other path if needed. BASE_PATH is generated from this attribute each time oned is started.
-  ``DATASTORE_CAPACITY_CHECK``: Checks that there is enough capacity before creating a new image. Defaults to Yes
-  ``DEFAULT_IMAGE_TYPE`` : Default value for TYPE field when it is omitted in a template. Values accepted are:

   -  ``OS``: Image file holding an operating system
   -  ``CDROM``: Image file holding a CDROM
   -  ``DATABLOCK``: Image file holding a datablock, created as an empty block

-  ``DEFAULT_DEVICE_PREFIX`` : Default value for DEV\_PREFIX field when it is omitted in a template. The missing DEV\_PREFIX attribute is filled when Images are created, so changing this prefix won't affect existing Images. It can be set to:

+----------+--------------------+
| Prefix   | Device type        |
+==========+====================+
| hd       | IDE                |
+----------+--------------------+
| sd       | SCSI               |
+----------+--------------------+
| vd       | KVM virtual disk   |
+----------+--------------------+

- ``DEFAULT_CDROM_DEVICE_PREFIX``: Same as above but for CDROM devices.

- ``DEFAULT_IMAGE_PERSISTENT``: Control the default value for the PERSISTENT attribute on image creation (oneimage clone, onevm disk-saveas). If blank images will inherit the persistent attribute from the base image.

- ``DEFAULT_IMAGE_PERSISTENT_NEW``: Control the default value for the PERSISTENT attribute on image creation (oneimage create). By default images are no persistent if not set.

More information on the image repository can be found in the :ref:`Managing Virtual Machine Images guide <img_guide>`.

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

This driver CANNOT BE ASSIGNED TO A HOST, and needs to be used with KVM drivers. Options that can be set:

-  ``-a``: Address to bind the collectd socket (default 0.0.0.0)
-  ``-p``: UDP port to listen for monitor information (default 4124)
-  ``-f``: Interval in seconds to flush collected information (default 5)
-  ``-t``: Number of threads for the server (default 50)
-  ``-i``: Time in seconds of the monitorization push cycle. This parameter must be smaller than MONITORING\_INTERVAL, otherwise push monitorization will not be effective.

Sample configuration:

.. code-block:: bash

    IM_MAD = [
          name       = "collectd",
          executable = "collectd",
          arguments  = "-p 4124 -f 5 -t 50 -i 20" ]

Information Drivers
===================

The information drivers are used to gather information from the cluster nodes, and they depend on the virtualizer you are using. You can define more than one information manager but make sure it has different names. To define it, the following needs to be set:

-  **name**: name for this information driver.
-  **executable**: path of the information driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable, usually a probe configuration file, can be an absolute path or relative to ``/etc/one/``.

For more information on configuring the information and monitoring system and hints to extend it please check the :ref:`information driver configuration guide <devel-im>`.

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

Virtualization Drivers
======================

The virtualization drivers are used to create, control and monitor VMs on the hosts. You can define more than one virtualization driver (e.g. you have different virtualizers in several hosts) but make sure they have different names. To define it, the following needs to be set:

-  **name**: name of the virtualization driver.
-  **executable**: path of the virtualization driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable
-  **type**: driver type, supported drivers: xen, kvm or xml
-  **default**: default values and configuration parameters for the driver, can be an absolute path or relative to ``/etc/one/``
-  **keep_snapshots**: do not remove snapshots on power on/off cycles and live migrations if the hypervisor supports that.
-  **imported_vms_actions** : comma-separated list of actions supported for imported vms. The available actions are:

   - migrate
   - live-migrate
   - terminate
   - terminate-hard
   - undeploy
   - undeploy-hard
   - hold
   - release
   - stop
   - suspend
   - resume
   - delete
   - delete-recreate
   - reboot
   - reboot-hard
   - resched
   - unresched
   - poweroff
   - poweroff-hard
   - disk-attach
   - disk-detach
   - nic-attach
   - nic-detach
   - snap-create
   - snap-delete

For more information on configuring and setting up the Virtual Machine Manager Driver please check the section that suits you:

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
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, disk-attach,
            disk-detach, nic-attach, nic-detach, snap-create, snap-delete"
    ]

.. _oned_conf_transfer_driver:

Transfer Driver
===============

The transfer drivers are used to transfer, clone, remove and create VM images. The default TM\_MAD driver includes plugins for all supported storage modes. You may need to modify the TM\_MAD to add custom plugins.

-  **executable**: path of the transfer driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable:

   -  **-t**: number of threads, i.e. number of transfers made at the same time
   -  **-d**: list of transfer drivers separated by commas, if not defined all the drivers available will be enabled

For more information on configuring different storage alternatives :ref:`please check the storage configuration guide <sm>`.

Sample configuration:

.. code-block:: bash

    #-------------------------------------------------------------------------------
    # Transfer Manager Driver Configuration
    #-------------------------------------------------------------------------------
     
    TM_MAD = [
        EXECUTABLE = "one_tm",
        ARGUMENTS = "-t 15 -d dummy,lvm,shared,fs_lvm,qcow2,ssh,ceph,dev,vcenter,iscsi_libvirt"
    ]

The configuration for each driver is defined in the TM\_MAD\_CONF section. These values are used when creating a new datastore and should not be modified since they define the datastore behavior.

-  **name** : name of the transfer driver, listed in the -d option of the TM\_MAD section
-  **ln\_target** : determines how the persistent images will be cloned when a new VM is instantiated.

   -  **NONE**: The image will be linked and no more storage capacity will be used
   -  **SELF**: The image will be cloned in the Images datastore
   -  **SYSTEM**: The image will be cloned in the System datastore

-  **clone\_target** : determines how the non persistent images will be cloned when a new VM is instantiated.

   -  **NONE**: The image will be linked and no more storage capacity will be used
   -  **SELF**: The image will be cloned in the Images datastore
   -  **SYSTEM**: The image will be cloned in the System datastore

-  **shared** : determines if the storage holding the system datastore is shared among the different hosts or not. Valid values: *yes* or *no*.

- **ds_migrate**: set if system datastore migrations are allowed for this TM. Only useful for system datastore TMs.

- **allow_orphans**: Snapshots can live without parents

Sample configuration:

.. code-block:: bash

    TM_MAD_CONF = [
        name          = "lvm",
        ln_target     = "NONE",
        clone_target  = "SELF",
        shared        = "yes",
        allow_orphans = "no"
    ]
     
    TM_MAD_CONF = [
        name        = "shared",
        ln_target   = "NONE",
        clone_target= "SYSTEM",
        shared      = "yes",
        ds_migrate  = "yes"
    ]

Datastore Driver
================

The Datastore Driver defines a set of scripts to manage the storage backend.

-  **executable**: path of the transfer driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable

   -  **-t** number of threads, i.e. number of repo operations at the same time
   -  **-d** datastore mads separated by commas
   -  **-s** system datastore tm drivers, used to monitor shared system ds

Sample configuration:

.. code-block:: bash

    DATASTORE_MAD = [
        EXECUTABLE = "one_datastore",
        ARGUMENTS  = "-t 15 -d dummy,fs,lvm,ceph,dev,iscsi_libvirt,vcenter -s shared,ssh,ceph,fs_lvm"
    ]

For more information on this Driver and how to customize it, please visit :ref:`its reference guide <sm>`.

Marketplace Driver Configuration
================================================================================

Drivers to manage different marketplaces, specialized for the storage back-end

-  **executable**: path of the transfer driver executable, can be an absolute path or relative to /usr/lib/one/mads/
-  **arguments** : for the driver executable

   -  **-t** number of threads, i.e. number of repo operations at the same time
   -  **-m** marketplace mads separated by commas
   -  **--proxy** proxy URI if required to access the internet. For example ``--proxy http://1.2.3.4:5678``
   -  **-w** timeout in seconds to execute external commands (default unlimited)

Sample configuration:

.. code-block:: bash

  MARKET_MAD = [
      EXECUTABLE = "one_market",
      ARGUMENTS  = "-t 15 -m http,s3,one"
  ]

Hook System
===========

Hooks in OpenNebula are programs (usually scripts) which execution is triggered by a change in state in Virtual Machines or Hosts. The hooks can be executed either locally or remotely in the node where the VM or Host is running. To configure the Hook System the following needs to be set in the OpenNebula configuration file:

-  **executable**: path of the hook driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments** : for the driver executable, can be an absolute path or relative to ``/etc/one/``

Sample configuration:

.. code-block:: bash

    HM_MAD = [
        executable = "one_hm" ]

Virtual Machine Hooks (VM\_HOOK) defined by:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  **name**: for the hook, useful to track the hook (OPTIONAL).
-  **on**: when the hook should be executed,

   -  **CREATE**, when the VM is created (onevm create)
   -  **PROLOG**, when the VM is in the prolog state
   -  **RUNNING**, after the VM is successfully booted
   -  **UNKNOWN**, when the VM is in the unknown state
   -  **SHUTDOWN**, after the VM is shutdown
   -  **STOP**, after the VM is stopped (including VM image transfers)
   -  **DONE**, after the VM is deleted or shutdown
   -  **CUSTOM**, user defined specific STATE and LCM\_STATE combination of states to trigger the hook

-  **command**: path can be absolute or relative to /usr/share/one/hooks
-  **arguments**: for the hook. You can access to VM information with $

   -  **$ID**, the ID of the virtual machine
   -  **$TEMPLATE**, the VM template in xml and base64 encoded multiple
   -  **PREV\_STATE**, the previous STATE of the Virtual Machine
   -  **PREV\_LCM\_STATE**, the previous LCM STATE of the Virtual Machine

-  **remote**: values,

   -  **YES**, The hook is executed in the host where the VM was allocated
   -  **NO**, The hook is executed in the OpenNebula server (default)

Host Hooks (HOST\_HOOK) defined by:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-  **name**: for the hook, useful to track the hook (OPTIONAL)
-  **on**: when the hook should be executed,

   -  **CREATE**, when the Host is created (onehost create)
   -  **ERROR**, when the Host enters the error state
   -  **DISABLE**, when the Host is disabled

-  **command**: path can be absolute or relative to /usr/share/one/hooks
-  **arguments**: for the hook. You can use the following Host information:

   -  **$ID**, the ID of the host
   -  **$TEMPLATE**, the Host template in xml and base64 encoded

-  **remote**: values,

   -  **YES**, The hook is executed in the host
   -  **NO**, The hook is executed in the OpenNebula server (default)

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

-  **AUTH\_MAD**: The :ref:`driver <external_auth>` that will be used to authenticate and authorize OpenNebula requests. If not defined OpenNebula will use the built-in auth policies

   -  **executable**: path of the auth driver executable, can be an absolute path or relative to /usr/lib/one/mads/
   -  **authn**: list of authentication modules separated by commas, if not defined all the modules available will be enabled
   -  **authz**: list of authentication modules separated by commas

-  **SESSION\_EXPIRATION\_TIME**: Time in seconds to keep an authenticated token as valid. During this time, the driver is not used. Use 0 to disable session caching
-  **ENABLE\_OTHER\_PERMISSIONS**: Whether or not to enable the permissions for 'other'. Users in the oneadmin group will still be able to change these permissions. Values: YES or NO
-  **DEFAULT\_UMASK**: Similar to Unix umask, sets the default resources permissions. Its format must be 3 octal digits. For example a umask of 137 will set the new object's permissions to 640 ``um- u-- ---``

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
===================================
The following parameters define the operations associated to the ADMIN,
MANAGE and USE permissions. Note that some VM operations may require additional
permissions on other objects. Also some operations refers to a class of
actions:

- disk-snapshot, includes create, delete and revert actions
- disk-attach, includes attach and detach actions
- nic-attach, includes attach and detach actions
- snapshot, includes create, delete and revert actions
- resched, includes resched and unresched actions

The list and show operations require the USE permission, this is not configurable.

In the following example you need ADMIN right on a VM to perform migrate, delete, recover... while undeploy, hold, ... need MANAGE right:

.. code-block:: bash

    VM_ADMIN_OPERATIONS  = "migrate, delete, recover, retry, deploy, resched"

    VM_MANAGE_OPERATIONS = "undeploy, hold, release, stop, suspend, resume, reboot,
        poweroff, disk-attach, nic-attach, disk-snapshot, terminate, disk-resize,
        snapshot, updateconf, rename, resize, update, disk-saveas"

    VM_USE_OPERATIONS    = ""

.. _oned_conf_restricted_attributes_configuration:

Restricted Attributes Configuration
===================================

Users outside the oneadmin group won't be able to instantiate templates created by users outside the ''oneadmin'' group that include the attributes restricted by:

-  **VM\_RESTRICTED\_ATTR**: Virtual Machine attribute to be restricted for users outside the ''oneadmin'' group
-  **IMAGE\_RESTRICTED\_ATTR**: Image attribute to be restricted for users outside the ''oneadmin'' group
-  **VNET\_RESTRICTED\_ATTR**: Virtual Network attribute to be restricted for users outside the ''oneadmin'' group when updating a reservation. These attributes are not considered for regular VNET creation.

If the VM template has been created by admins in the ''oneadmin'' group, then users outside the ''oneadmin'' group **can** instantiate these templates.

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

- on VM template instantiate (onetemplate instantiate)
- on VM create (onevm create)
- on VM attach nic (onevm nic-attach) (for example to forbid users to use NIC/MAC)


Inherited Attributes Configuration
==================================

The following attributes will be copied from the resource template to the instantiated VMs. More than one attribute can be defined.

-  ``INHERIT_IMAGE_ATTR``: Attribute to be copied from the Image template to each VM/DISK.
-  ``INHERIT_DATASTORE_ATTR``: Attribute to be copied from the Datastore template to each VM/DISK.
-  ``INHERIT_VNET_ATTR``: Attribute to be copied from the Network template to each VM/NIC.

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

OneGate Configuration
=====================

-  **ONEGATE\_ENDPOINT**: Endpoint where OneGate will be listening. Optional.

Sample configuration:

.. code-block:: bash

    ONEGATE_ENDPOINT = "http://192.168.0.5:5030"


Default Permissions for VDC ACL rules
======================================

Default ACL rules created when resource is added to a VDC. The following attributes configures the permissions granted to the VDC group for each resource types:

-  ``DEFAULT_VDC_HOST_ACL``: permissions granted on hosts added to a VDC.
-  ``DEFAULT_VDC_NET_ACL``: permissions granted on vnets added to a VDC.
-  ``DEFAULT_VDC_DATASTORE_ACL``: permissions granted on datastores to a VDC.

-  ``DEFAULT_VDC_CLUSTER_HOST_ACL``: permissions granted to cluster hosts when acluster is added to the VDC.
-  ``DEFAULT_VDC_CLUSTER_NET_ACL``: permissions granted to cluster vnets when acluster is added to the VDC.
-  ``DEFAULT_VDC_CLUSTER_DATASTORE_ACL``: permissions granted to cluster datastores when a cluster is added to the VDC.

When defining the permissions you can use "" or "-" to not add any rule to that specific resource. Also you can combine several permissions with "+", for example "MANAGE+USE". Valid permissions are USE, MANAGE or ADMIN.

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

