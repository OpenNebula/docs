.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.0.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.2.

OpenNebula Administrators
================================================================================

OpenNebula Daemon
--------------------------------------------------------------------------------

The attributes ``VNC_PORTS/RESERVED`` and ``VLAN_IDS/RESERVED`` attribute in :ref:`oned.conf <oned_conf>` now accept port ranges:

.. code-block:: bash

    #  VNC_PORTS: VNC port pool for automatic VNC port assignment, if possible the
    #  port will be set to ``START`` + ``VMID``
    #   start   : first port to assign
    #   reserved: comma separated list of ports or ranges. Two numbers separated by
    #   a colon indicate a range.

    VNC_PORTS = [
        START    = 5900
        RESERVED = "6800, 6801, 6810:6820, 9869"
    ]

    #  VLAN_IDS: VLAN ID pool for the automatic VLAN_ID assignment. This pool
    #  is for 802.1Q networks (Open vSwitch and 802.1Q drivers). The driver
    #  will try first to allocate VLAN_IDS[START] + VNET_ID
    #     start: First VLAN_ID to use
    #     reserved: Comma separated list of VLAN_IDs or ranges. Two numbers
    #     separated by a colon indicate a range.

    VLAN_IDS = [
        START    = "2",
        RESERVED = "0, 1, 4095"
    ]


Fault Tolerance Hook
--------------------------------------------------------------------------------

The :ref:`fault tolerance hook <ftguide>` now has a new option, ``-u``:

.. code-block:: bash

    #*******************************************************************************
    # Fault Tolerance Hooks
    #*******************************************************************************
    # This hook is used to perform recovery actions when a host fails.
    # Script to implement host failure tolerance
    #   One of the following modes must be chosen
    #           -m resched VMs to another host. (Only for images in shared storage!)
    #           -r recreate VMs running in the host. State will be lost.
    #           -d delete VMs running in the host
    #
    #   Additional flags
    #           -f resubmit suspended and powered off VMs (only for recreate)
    #           -p <n> avoid resubmission if host comes back after n monitoring
    #                 cycles. 0 to disable it. Default is 2.
    #           -u disables fencing. Fencing is enabled by default. Don't disable it
    #                 unless you are very sure about what you're doing
    #*******************************************************************************


Virtual Machine Management
--------------------------------------------------------------------------------

New recovery option for a Virtual Machine is these states:

* ``PROLOG_MIGRATE_FAILURE``
* ``PROLOG_MIGRATE_POWEROFF_FAILURE``
* ``PROLOG_MIGRATE_SUSPEND_FAILURE``
* ``PROLOG_MIGRATE_UNKNOWN_FAILURE``

If a migration to another Host fails the administrator can fix the situation and:

* **[NEW in 5.2]** Force OpenNebula to assume the VM is running in the previous Host (where the migration was started):

    .. prompt:: bash $ auto

        $ onevm recover <id> --failure

* Force OpenNebula to assume the VM is running in the destination Host:

    .. prompt:: bash $ auto

        $ onevm recover <id> --success

* Retry the migration:

    .. prompt:: bash $ auto

        $ onevm recover <id> --retry


User Tokens
--------------------------------------------------------------------------------

The login token functionality has been improved with two main differences:

* More than one token can be defined per user
* Each token can have an "effective Group ID"

Instead of the ``oneuser login`` command, the tokens are now managed with these new sub-commands:

* ``oneuser token-create [<username>]``
* ``oneuser token-set [<username>]``
* ``oneuser token-delete [<username>] <token>``
* ``oneuser token-delete-all <username>``

Read more about login tokens in the :ref:`Managing Users documentation <user_tokens>`.


LDAP Group Management
--------------------------------------------------------------------------------

The LDAP drivers were capable of creating new users in a set of configured groups. Now in OpenNebula 5.2 the user's groups will be updated after the user creation if the LDAP driver reports a different list of Group IDs.

Read more in the :ref:`LDAP Authentication documentation <ldap_group_mapping>`.

Migration Across Clusters
--------------------------------------------------------------------------------

Before OpenNebula 5.2 a VM migration could only be performed if the current Host was in the same Cluster as the new Host. This ensured that the destination Host had access to the same infrastructure requirements: Datastores and Virtual Networks.

Now the requirements have changed to allow the migration if the destination Host is in a Cluster that contains all the Datastores and Virtual Networks required by the VM. In an homogeneous infrastructure this allows greater flexibility, but there is a special case where this change could be problematic:

If the Clusters separate incompatible Hosts (incompatible hypervisor versions, or hardware architecture) but contain the same set of Datastores and Virtual Networks, the migration could fail. This is specially important when the ``onevm resched`` command is used, as the scheduler now will decide that all those incompatible Hosts are eligible for the migration.


Developers and Integrators
================================================================================

IM and VM Drivers
--------------------------------------------------------------------------------

Each ``IM_MAD`` and ``VM_MAD`` defined in :ref:`oned.conf <oned_conf>` can now define a timeout with the ``-w`` parameter:

.. code-block:: none

    -w  Timeout in seconds to execute external commands (default unlimited)


IPAM Drivers
--------------------------------------------------------------------------------

There is a new kind of driver to interact with existing IPAM modules. Read more about it in the :ref:`IPAM driver documentation <devel-ipam>`.

Authentication Drivers
--------------------------------------------------------------------------------

The authentication drivers defined in :ref:`oned.conf <oned_conf>` now have 2 extra attributes that define their behavior, ``DRIVER_MANAGED_GROUPS`` and ``MAX_TOKEN_TIME``.

.. code-block:: bash

    #*******************************************************************************
    # Authentication Driver Behavior Definition
    #*******************************************************************************
    # The configuration for each driver is defined in AUTH_MAD_CONF. These
    # values must not be modified since they define the driver behavior.
    #   name            : name of the auth driver
    #   password_change : allow the end users to change their own password. Oneadmin
    #                     can still change other user's passwords
    #   driver_managed_groups : allow the driver to set the user's group even after
    #                     user creation. In this case addgroup, delgroup and chgrp
    #                     will be disabled, with the exception of chgrp to one of
    #                     the groups in the list of secondary groups
    #   max_token_time  : limit the maximum token validity, in seconds. Use -1 for
    #                     unlimited maximum, 0 to disable login tokens
    #*******************************************************************************

    AUTH_MAD_CONF = [
        NAME = "core",
        PASSWORD_CHANGE = "YES",
        DRIVER_MANAGED_GROUPS = "NO",
        MAX_TOKEN_TIME = "-1"
    ]

    AUTH_MAD_CONF = [
        NAME = "ldap",
        PASSWORD_CHANGE = "YES",
        DRIVER_MANAGED_GROUPS = "YES",
        MAX_TOKEN_TIME = "86400"
    ]

XML-RPC API
--------------------------------------------------------------------------------

This section lists all the changes in the API. Visit the :ref:`complete reference <api>` for more information.

* Changed api calls:

  * ``one.user.login``: New parameter EGID, effective GID to use with this token. To use the current GID and user groups set it to -1
  * ``one.user.allocate``: New parameter gids, array of Group IDs. To create a new User setting the main and secondary groups directly
  * ``one.*pool.info``: New filter flag **-4**, to request resources that belong to the user's primary group only.