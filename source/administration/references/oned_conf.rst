.. _oned_conf:

===================
ONED Configuration
===================

The OpenNebula daemon ``oned`` manages the cluster nodes, virtual networks, virtual machines, users, groups and storage datastores. The configuration file for the daemon is called ``oned.conf`` and it is placed inside the ``/etc/one`` directory. In this reference document we describe all the format and options that can be specified in ``oned.conf``.

Daemon Configuration Attributes
===============================

-  ``MANAGER_TIMER`` : Time in seconds the core uses to evaluate periodical functions. MONITORING\_INTERVAL cannot have a smaller value than MANAGER\_TIMER.
-  ``MONITORING_INTERVAL`` : Time in seconds between each monitorization.
-  ``MONITORING_THREADS`` : Max. number of threads used to process monitor messages
-  ``HOST_PER_INTERVAL``: Number of hosts monitored in each interval.
-  ``HOST_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Use 0 to disable HOST monitoring recording.
-  ``VM_INDIVIDUAL_MONITORING``: VM monitoring information is obtained along with the host information. For some custom monitor drivers you may need activate the individual VM monitoring process.
-  ``VM_PER_INTERVAL``: Number of VMs monitored in each interval.
-  ``VM_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Use 0 to disable VM monitoring recording.
-  ``SCRIPTS_REMOTE_DIR``: Remote path to store the monitoring and VM management script.
-  ``PORT`` : Port where oned will listen for xml-rpc calls.
-  ``LISTEN_ADDRESS``: Host IP to listen on for xmlrpc calls (default: all IPs).
-  ``DB`` : Vector of configuration attributes for the database backend.

   -  ``backend`` : Set to ``sqlite`` or ``mysql``. Please visit the :ref:`MySQL configuration guide <mysql>` for more information.
   -  ``server`` (MySQL only): Host name or an IP address for the MySQL server.
   -  ``user`` (MySQL only): MySQL user's login ID.
   -  ``passwd`` (MySQL only): MySQL user's password.
   -  ``db_name`` (MySQL only): MySQL database name.

-  ``VNC_BASE_PORT`` : VNC ports for VMs can be automatically set to ``VNC_BASE_PORT`` + ``VMID``. Refer to the :ref:`VM template reference <template>` for further information.
-  ``VM_SUBMIT_ON_HOLD`` : Forces VMs to be created on hold state instead of pending. Values: YES or NO.
-  ``LOG`` : Configure the logging system

   -  ``SYSTEM`` : Can be either ``file`` (default) or ``syslog``.
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

.. code::

    #*******************************************************************************
    # Daemon configuration attributes
    #*******************************************************************************
     
    LOG = [
      system      = "file",
      debug_level = 3
    ]
     
    #MANAGER_TIMER = 30
     
    MONITORING_INTERVAL = 60
    MONITORING_THREADS  = 50
     
    #HOST_PER_INTERVAL               = 15
    #HOST_MONITORING_EXPIRATION_TIME = 43200

    #VM_INDIVIDUAL_MONITORING      = "no"
    #VM_PER_INTERVAL               = 5
    #VM_MONITORING_EXPIRATION_TIME = 14400
     
    SCRIPTS_REMOTE_DIR=/var/tmp/one
     
    PORT = 2633
    LISTEN_ADDRESS = "0.0.0.0"
     
    DB = [ backend = "sqlite" ]
     
    # Sample configuration for MySQL
    # DB = [ backend = "mysql",
    #        server  = "localhost",
    #        port    = 0,
    #        user    = "oneadmin",
    #        passwd  = "oneadmin",
    #        db_name = "opennebula" ]
     
    VNC_BASE_PORT = 5900
     
    #VM_SUBMIT_ON_HOLD = "NO"

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

.. code::

    #*******************************************************************************
    # Federation configuration attributes
    #*******************************************************************************

    FEDERATION = [
        MODE = "STANDALONE",
        ZONE_ID = 0,
        MASTER_ONED = ""
    ]

.. _oned_conf_default_showback:

Default Showback Cost
================================================================================

The following attributes define the default cost for Virtual Machines that don't have a CPU, MEMORY or DISK cost. This is used by the :ref:`oneshowback calculate method <showback>`.

.. code::

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
-  ``TIMEOUT``: Maximum time in seconds the server will wait for the client to do anything while processing an RPC
-  ``RPC_LOG``: Create a separated log file for xml-rpc requests, in /var/log/one/one_xmlrpc.log.
-  ``MESSAGE_SIZE``: Buffer size in bytes for XML-RPC responses.
-  ``LOG_CALL_FORMAT``: Format string to log XML-RPC calls. Interpreted strings:

   -  %i -- request id
   -  %m -- method name
   -  %u -- user id
   -  %U -- user name
   -  %l -- param list
   -  %p -- user password
   -  %g -- group id
   -  %G -- group name
   -  %a -- auth token
   -  %% -- %

.. code::

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

-  ``NETWORK_SIZE``: Default size for virtual networks
-  ``MAC_PREFIX``: Default MAC prefix to generate virtual network MAC addresses

Sample configuration:

.. code::

    #*******************************************************************************
    # Physical Networks configuration
    #*******************************************************************************
     
    NETWORK_SIZE = 254
    MAC_PREFIX   = "02:00"

.. _oned_conf_datastores:

Datastores
==========

The :ref:`Storage Subsystem <sm>` allows users to set up images, which can be operative systems or data, to be used in Virtual Machines easily. These images can be used by several Virtual Machines simultaneously, and also shared with other users.

Here you can configure the default values for the Datastores and Image templates. You have more information about the templates syntax :ref:`here <img_template>`.

-  ``DATASTORE_LOCATION``: Path for Datastores in the hosts. It is the same for all the hosts in the cluster. ``DATASTORE_LOCATION`` **is only for the hosts and not the front-end**. It defaults to /var/lib/one/datastores (or ``$ONE_LOCATION/var/datastores`` in self-contained mode)
-  ``DATASTORE_BASE_PATH``: This is the base path for the SOURCE attribute of the images registered in a Datastore. This is a default value, that can be changed when the datastore is created.
-  ``DATASTORE_CAPACITY_CHECK``: Checks that there is enough capacity before creating a new imag. Defaults to Yes.
-  ``DEFAULT_IMAGE_TYPE`` : Default value for TYPE field when it is omitted in a template. Values accepted are ``OS``, ``CDROM``, ``DATABLOCK``.
-  ``DEFAULT_DEVICE_PREFIX`` : Default value for DEV\_PREFIX field when it is omitted in a template. The missing DEV\_PREFIX attribute is filled when Images are created, so changing this prefix won't affect existing Images. It can be set to:

+----------+--------------------+
| Prefix   | Device type        |
+==========+====================+
| hd       | IDE                |
+----------+--------------------+
| sd       | SCSI               |
+----------+--------------------+
| xvd      | XEN Virtual Disk   |
+----------+--------------------+
| vd       | KVM virtual disk   |
+----------+--------------------+

- ``DEFAULT_CDROM_DEVICE_PREFIX``: Same as above but for CDROM devices.

More information on the image repository can be found in the :ref:`Managing Virtual Machine Images guide <img_guide>`.

Sample configuration:

.. code::

    #*******************************************************************************
    # Image Repository Configuration
    #*******************************************************************************
    #DATASTORE_LOCATION  = /var/lib/one/datastores
     
    #DATASTORE_BASE_PATH = /var/lib/one/datastores
     
    DATASTORE_CAPACITY_CHECK = "yes"
     
    DEFAULT_IMAGE_TYPE    = "OS"
    DEFAULT_DEVICE_PREFIX = "hd"

    DEFAULT_CDROM_DEVICE_PREFIX = "hd"

Information Collector
=====================

This driver CANNOT BE ASSIGNED TO A HOST, and needs to be used with KVM or Xen drivers Options that can be set:

-  ``-a``: Address to bind the collectd sockect (defults 0.0.0.0)
-  ``-p``: UDP port to listen for monitor information (default 4124)
-  ``-f``: Interval in seconds to flush collected information (default 5)
-  ``-t``: Number of threads for the server (defult 50)
-  ``-i``: Time in seconds of the monitorization push cycle. This parameter must be smaller than MONITORING\_INTERVAL, otherwise push monitorization will not be effective.

Sample configuration:

.. code::

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

.. code::

    #-------------------------------------------------------------------------------
    #  KVM Information Driver Manager Configuration
    #    -r number of retries when monitoring a host
    #    -t number of threads, i.e. number of hosts monitored at the same time
    #-------------------------------------------------------------------------------
    IM_MAD = [
          name       = "kvm",
          executable = "one_im_ssh",
          arguments  = "-r 0 -t 15 kvm" ]
    #-------------------------------------------------------------------------------

Virtualization Drivers
======================

The virtualization drivers are used to create, control and monitor VMs on the hosts. You can define more than one virtualization driver (e.g. you have different virtualizers in several hosts) but make sure they have different names. To define it, the following needs to be set:

-  **name**: name of the virtualization driver.
-  **executable**: path of the virtualization driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments**: for the driver executable
-  **type**: driver type, supported drivers: xen, kvm or xml
-  **default**: default values and configuration parameters for the driver, can be an absolute path or relative to ``/etc/one/``

For more information on configuring and setting up the virtualizer please check the guide that suits you:

-  :ref:`Xen Adaptor <xeng>`
-  :ref:`KVM Adaptor <kvmg>`
-  :ref:`VMware Adaptor <evmwareg>`

Sample configuration:

.. code::

    #-------------------------------------------------------------------------------
    # Virtualization Driver Configuration
    #-------------------------------------------------------------------------------
     
    VM_MAD = [
        name       = "kvm",
        executable = "one_vmm_ssh",
        arguments  = "-t 15 -r 0 kvm",
        default    = "vmm_ssh/vmm_ssh_kvm.conf",
        type       = "kvm" ]

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

.. code::

    #-------------------------------------------------------------------------------
    # Transfer Manager Driver Configuration
    #-------------------------------------------------------------------------------
     
    TM_MAD = [
        executable = "one_tm",
        arguments  = "-t 15 -d dummy,lvm,shared,fs_lvm,qcow2,ssh,vmfs,ceph" ]

The configuration for each driver is defined in the TM\_MAD\_CONF section. These values are used when creating a new datastore and should not be modified since they define the datastore behaviour.

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

Sample configuration:

.. code::

    TM_MAD_CONF = [
        name        = "lvm",
        ln_target   = "NONE",
        clone_target= "SELF",
        shared      = "yes"
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

Sample configuration:

.. code::

    DATASTORE_MAD = [
        executable = "one_datastore",
        arguments  = "-t 15 -d dummy,fs,vmfs,lvm,ceph"
    ]

For more information on this Driver and how to customize it, please visit :ref:`its reference guide <sm>`.

Hook System
===========

Hooks in OpenNebula are programs (usually scripts) which execution is triggered by a change in state in Virtual Machines or Hosts. The hooks can be executed either locally or remotely in the node where the VM or Host is running. To configure the Hook System the following needs to be set in the OpenNebula configuration file:

-  **executable**: path of the hook driver executable, can be an absolute path or relative to ``/usr/lib/one/mads/``
-  **arguments** : for the driver executable, can be an absolute path or relative to ``/etc/one/``

Sample configuration:

.. code::

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

.. code::
     
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
-  **DEFAULT\_UMASK**: Similar to Unix umask, sets the default resources permissions. Its format must be 3 octal digits. For example a umask of 137 will set the new object's permissions to 640 ``um- u– —``

Sample configuration:

.. code::

    AUTH_MAD = [
        executable = "one_auth_mad",
        authn = "ssh,x509,ldap,server_cipher,server_x509"
    ]
     
    SESSION_EXPIRATION_TIME = 900
     
    #ENABLE_OTHER_PERMISSIONS = "YES"
     
    DEFAULT_UMASK = 177


The ``DEFAULT_AUTH`` can be used to point to the desired default authentication driver, for example ``ldap``:

.. code::

    DEFAULT_AUTH = "ldap"

.. _oned_conf_restricted_attributes_configuration:

Restricted Attributes Configuration
===================================

Users outside the oneadmin group won't be able to instantiate templates created by users outside the ''oneadmin'' group that include the attributes restricted by:

-  **VM\_RESTRICTED\_ATTR**: Virtual Machine attribute to be restricted for users outside the ''oneadmin'' group
-  **IMAGE\_RESTRICTED\_ATTR**: Image attribute to be restricted for users outside the ''oneadmin'' group
-  **VNET\_RESTRICTED\_ATTR**: Virtual Network attribute to be restricted for users outside the ''oneadmin'' group when updating a reservation. These attributes are not considered for regular VNET creation.

If the VM template has been created by admins in the ''oneadmin'' group, then users outside the ''oneadmin'' group **can** instantiate these templates.

Sample configuration:

.. code::

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
     
    #VM_RESTRICTED_ATTR = "RANK"
    #VM_RESTRICTED_ATTR = "SCHED_RANK"
    #VM_RESTRICTED_ATTR = "REQUIREMENTS"
    #VM_RESTRICTED_ATTR = "SCHED_REQUIREMENTS"
     
    IMAGE_RESTRICTED_ATTR = "SOURCE"

    VNET_RESTRICTED_ATTR = "PHYDEV"
    VNET_RESTRICTED_ATTR = "VLAN_ID"
    VNET_RESTRICTED_ATTR = "VLAN"
    VNET_RESTRICTED_ATTR = "BRIDGE"

    VNET_RESTRICTED_ATTR = "AR/PHYDEV"
    VNET_RESTRICTED_ATTR = "AR/VLAN_ID"
    VNET_RESTRICTED_ATTR = "AR/VLAN"
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

.. code::

    #INHERIT_IMAGE_ATTR     = "EXAMPLE"
    #INHERIT_IMAGE_ATTR     = "SECOND_EXAMPLE"
    #INHERIT_DATASTORE_ATTR = "COLOR"
    #INHERIT_VNET_ATTR      = "BANDWIDTH_THROTTLING"

    INHERIT_DATASTORE_ATTR  = "CEPH_HOST"
    INHERIT_DATASTORE_ATTR  = "CEPH_SECRET"
    INHERIT_DATASTORE_ATTR  = "CEPH_USER"
    INHERIT_DATASTORE_ATTR  = "CEPH_CONF"

    INHERIT_DATASTORE_ATTR  = "GLUSTER_HOST"
    INHERIT_DATASTORE_ATTR  = "GLUSTER_VOLUME"

    INHERIT_VNET_ATTR       = "VLAN_TAGGED_ID"
    INHERIT_VNET_ATTR       = "BRIDGE_OVS"
    INHERIT_VNET_ATTR       = "FILTER_IP_SPOOFING"
    INHERIT_VNET_ATTR       = "FILTER_MAC_SPOOFING"
    INHERIT_VNET_ATTR       = "MTU"

OneGate Configuration
=====================

-  **ONEGATE\_ENDPOINT**: Endpoint where OneGate will be listening. Optional.

Sample configuration:

.. code::

    ONEGATE_ENDPOINT = "http://192.168.0.5:5030"

