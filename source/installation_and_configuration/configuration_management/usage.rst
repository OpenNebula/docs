.. _cfg_usage:

===========
Basic Usage
===========

This section covers ``onecfg`` tool subcommands:

- :ref:`status <cfg_status>` - Versions status
- :ref:`init <cfg_init>` - Initialize version management state
- :ref:`validate <cfg_validate>` - Validate current configuration files
- :ref:`diff <cfg_diff>` - Identify changes in configuration files
- :ref:`patch <cfg_patch>` - Apply ad-hoc changes (from diff) in configuration files
- :ref:`upgrade <cfg_upgrade>` - Upgrade configuration files to a new version

.. important::

    This command must be always run under privileged user ``root`` directly or via ``sudo``. For example:

    .. prompt:: bash $ auto

        $ sudo onecfg status

The tool comes with help for each subcommand and command-line option. Simple run without any parameter or a run with the parameter ``--help`` prints the brief documentation (e.g., ``onecfg status --help``).

.. _cfg_status:

Status
======

The ``status`` subcommand provides an overview of the OpenNebula installation. It shows:

- Current OpenNebula version.
- Current configuration files version.
- Backup from previous OpenNebula version to process.
- Available updates with the corresponding migrators.

.. note::

   If status subcommand fails on an **unknown** configuration version, check the section about :ref:`init <cfg_init>` subcommand below.

Example:

.. prompt:: bash # auto

    # onecfg status
    --- Versions -----------------
    OpenNebula: 5.10.1
    Config:     5.6.0

    --- Backup to Process ---------------------
    Snapshot:    /var/lib/one/backups/config/backup
    (will be used as one-shot source for next update)

    --- Available updates --------
    New config: 5.10.0
    - from 5.6.0 to 5.8.0 (YAML,Ruby)
    - from 5.8.0 to 5.10.0 (YAML,Ruby)

.. important::

    **OpenNebula version** and **Configuration version** are tracked independently, but both versions are closely related and must be from the same ``X.Y`` release (i.e., OpenNebula 5.10.Z must have a configuration on version 5.10.Z). Minor configuration releases ``X.Y.Z`` are linked to the OpenNebula version for which a significant update has happened. Usually, configuration version **remains on the same version for all OpenNebula releases** within the same ``X.Y`` release (i.e., configuration version 5.10.0 is valid for all OpenNebula releases from 5.10.0 to latest available 5.10.5).

**Backup to Process** is a one-shot backup that needs to be processed. It's created automatically by OpenNebula packages (since 5.10.2) during the upgrade and contains a backup of all configuration files from the previous version. Content of the backup is taken, upgraded for current OpenNebula version and placed into production directories (``/etc/one/`` and ``/var/lib/one/remotes/etc``). Any existing content will be replaced there.

Example of status without available updates:

.. prompt:: bash # auto

    # onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.10.2
    Config:      5.10.0

    --- Available Configuration Updates -------
    No updates available.


Exit codes
----------

Based on different status, the command ends with the following exit codes:

- **0** - No update available.
- **1** - Updates available.
- **255** - Unspecified error (e.g., unknown versions)

.. _cfg_init:

Init
====

For clean new installations, the ``init`` subcommand initializes the configuration management state based on the currently installed OpenNebula version.

Parameters:

+------------------+-----------------------------------------------------------------------+-----------+
| Parameter        | Description                                                           | Mandatory |
+==================+=======================================================================+===========+
| ``--force``      | Force (re)initialization                                              | NO        |
+------------------+-----------------------------------------------------------------------+-----------+
| ``--to`` VERSION | Configuration version override (default: current OpenNebula version)  | NO        |
+------------------+-----------------------------------------------------------------------+-----------+

Examples:

.. prompt:: bash # auto

    # onecfg init
    INFO  : Initialized on version 5.10.0

    # onecfg init
    ANY   : Already initialized

You can also force configuration reinitialization based on detected OpenNebula version:

.. prompt:: bash # auto

    # onecfg init --force
    INFO  : Initialized on version 5.10.0

Or, force reinitialization on own provided version:

.. prompt:: bash # auto

    # onecfg init --force --to 5.8.0
    INFO  : Initialized on version 5.8.0

.. note::

   Version state is stored in configuration file ``/etc/onecfg.conf``. You **shouldn't modify this file directly**, as it might result in unpredictable behavior.

Example
-------

Initialization is necessary when the Onecfg is not sure about the version of current configuration files. When running ``onecfg status`` in the uninitialized environment, you might get the following error:

.. prompt:: bash # auto

    # onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.8.0
    Config:      unknown
    ERROR: Unknown config version

If you are sure the configuration files are current for the OpenNebula version you have (i.e., 5.8.0 in the example above), you can initialize the version management by using OpenNebula version (e.g., ``onecfg init``). Or, by explicitly providing the version configuration files match (e.g., ``onecfg init --to 5.6.0``).

In both cases, after the initialization, the configuration version should be known:

.. prompt:: bash # auto

    # onecfg status
    --- Versions ------------------------------
    OpenNebula:  5.8.0
    Config:      5.8.0

    --- Available Configuration Updates -------
    No updates available.


.. _cfg_validate:

Validate
========

The ``validate`` subcommand checks that all known :ref:`configuration files <cfg_files>` can be parsed.

Parameters:

+--------------------+---------------------------------------+-----------+
| Parameter          | Description                           | Mandatory |
+====================+=======================================+===========+
| ``--prefix`` PATH  | Root location prefix (default: ``/``) | NO        |
+--------------------+---------------------------------------+-----------+

Without any parameter provided, it validates and returns only problematic files:

.. prompt:: bash # auto

    # onecfg validate
    ERROR : Unable to process file '/etc/one/oned.conf' - Failed to parse file


When running in verbose mode with ``--verbose``, it writes all checked files:

.. prompt:: bash # auto

    # onecfg validate --verbose
    INFO  : File '/etc/one/vcenter_driver.default' - OK
    INFO  : File '/etc/one/ec2_driver.default' - OK
    INFO  : File '/etc/one/az_driver.default' - OK
    INFO  : File '/etc/one/auth/ldap_auth.conf' - OK
    INFO  : File '/etc/one/auth/server_x509_auth.conf' - OK
    ...

.. note::

    You can also validate files inside a dedicated directory instead of a system-wide installation location using the option ``--prefix``. Directory structure inside the prefix **must follow the structure on real locations** (e.g., for real ``/etc/one`` there must be ``$PREFIX/etc/one``).

    .. prompt:: bash # auto

        # onecfg validate --prefix /tmp/ONE --verbose
        INFO  : File '/tmp/ONE/etc/one/vcenter_driver.default' - OK
        INFO  : File '/tmp/ONE/etc/one/ec2_driver.default' - OK
        INFO  : File '/tmp/ONE/etc/one/az_driver.default' - OK
        INFO  : File '/tmp/ONE/etc/one/auth/ldap_auth.conf' - OK
        INFO  : File '/tmp/ONE/etc/one/auth/server_x509_auth.conf' - OK
        ...

Exit codes
----------

- **0** - all files are OK
- **1** - error when processing some file

.. _cfg_diff:

Diff
====

Similar to the validation functionality above, the ``diff`` subcommand reads all :ref:`configuration files <cfg_files>` and identifies changes that were done by the user when compared to base configuration files. It doesn't do any changes in the files, only reads and compares them.

Parameters:

+--------------------------+--------------------------------------------------------------------+-----------+
| Parameter                | Description                                                        | Mandatory |
+==========================+====================================================================+===========+
| ``--format`` FORMAT      | Format of patch data on input:                                     | NO        |
|                          | ``text`` (default), ``line`` or ``yaml``                           |           |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--prefix`` PATH        | Root location prefix (default: ``/``)                              | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+

Example:

.. prompt:: bash # auto

    # onecfg diff
    /etc/one/oned.conf
    - set DEFAULT_DEVICE_PREFIX "\"sd\""
    - set VM_MAD/"vcenter"/ARGUMENTS "\"-p -t 15 -r 0 -s sh vcenter\""
    - rm  VM_MAD/"vcenter"/DEFAULT
    - ins HM_MAD/ARGUMENTS "\"-p 2101 -l 2102 -b 127.0.0.1\""
    - ins VM_RESTRICTED_ATTR "\"NIC/FILTER\""

Read more about all output formats in :ref:`Diff Formats <cfg_diff_formats>` section.

.. _cfg_patch:

Patch
=====

.. note::

   This subcommand is also available in OpenNebula **Community Edition**.

Patch applies diffs, change descriptors, generated by ``diff`` subcommand or created manually (as ``line`` or ``yaml`` formats) and provided on standard input or as filename passed as an argument. Changes are applied in ``replace`` :ref:`mode <cfg_patch_modes>` and any user customizations on addressed places are overwritten.

Parameters:

+--------------------------+--------------------------------------------------------------------+-----------+
| Parameter                | Description                                                        | Mandatory |
+==========================+====================================================================+===========+
| ``-a`` or ``--all``      | All patch changes must be applied successfully or patch doesn't    | NO        |
|                          | proceed                                                            |           |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``-n`` or ``--noop``     | Runs patch without changing system state                           | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--format`` FORMAT      | Format of patch data on input: ``line`` (default) or ``yaml``      | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--prefix`` PATH        | Root location prefix (default: ``/``)                              | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--unprivileged``       | Skip privileged operations (e.g., ``chown``) - only for testing    | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+


Example with diff passed on standard input:

.. prompt:: bash # auto

    # onecfg patch --verbose --format line <<EOF
    /etc/one/oned.conf set PORT 2633
    /etc/one/oned.conf set LISTEN_ADDRESS "\"127.0.0.1\""
    /etc/one/oned.conf set DB/BACKEND "\"mysql\""
    /etc/one/oned.conf ins DB/SERVER "\"localhost\""
    /etc/one/oned.conf ins DB/USER "\"oneadmin\""
    /etc/one/oned.conf ins DB/PASSWD "\"secret_password\""
    /etc/one/oned.conf ins DB/NAME "\"opennebula\""
    EOF
    INFO  : Applying patch to 1 files
    ANY   : Backup stored in '/var/lib/one/backups/config/2020-12-22_01:20:40_2878523'
    INFO  : Patched '/etc/one/oned.conf' with 6/7 changes
    INFO  : Applied 7/7 changes

Same example with diff passed as file:

.. prompt:: bash # auto

    # onecfg patch --verbose --format line /tmp/diff-oned1

By default, patch process finishes successfully even if all changes were not applied. We can distinguish between full or partial application by checking the exit code of the command. We can also request to apply all or none changes by using ``--all`` argument.

.. prompt:: bash # auto

    # onecfg patch --verbose --format line --all /tmp/diff-oned2
    INFO  : Applying patch to 1 files
    ANY   : Backup stored in '/var/lib/one/backups/config/2020-12-22_01:31:18_2881111'
    INFO  : Patched '/etc/one/oned.conf' with 3/7 changes
    INFO  : Applied 3/7 changes
    ERROR : Modifications not saved due to 4 unapplied changes!

Subcommands ``diff`` and ``patch`` can be chained to apply changes from one front-end to another front-end (use carefully!):

.. prompt:: bash # auto

    # onecfg diff --format yaml | ssh frontend2 onecfg patch --format yaml --verbose

Exit codes
----------

- **0** - All patch changes were applied
- **1** - Some diff changes were applied
- **255** - Error during application, nothing to apply or other error

.. _cfg_upgrade:

Upgrade
=======

The ``upgrade`` subcommand makes all the changes in configuration files to update content from one version to another. It mainly does the following steps:

- Detect if an upgrade is necessary (or, at least if one-shot backup should be processed)
- Backup existing configuration files
- Apply upgrades (run migrators)
- Copy upgraded files back

.. important::

    Upgrade operation is always done on a copy of your production configuration files in the temporary directory. If anything fails during the upgrade process, it doesn't affect the real files. When the upgrade is successfully done for all files and for all intermediate versions, the new state is copied back to production locations. In case of serious failure during the final copy back, there should be a backup stored in ``/var/lib/one/backups/config/`` for manual restore.

.. note::

    You can first test the dry upgrade with ``--noop``, which doesn't change real production files. It skips the final copy back phase.

.. important::

    Upgrade operation detects changed values and preserves their content. Using patch mode **replace** described in :ref:`Troubleshooting <cfg_conflicts>`, the user can request to replace changed values with default ones for which **new default appears in the newer version**.

Parameters:

+--------------------------+--------------------------------------------------------------------+-----------+
| Parameter                | Description                                                        | Mandatory |
+==========================+====================================================================+===========+
| ``--from`` VERSION       | Old configuration version (default: current)                       | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--to`` VERSION         | New configuration version (default: autodetected from OpenNebula)  | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``-n`` or ``--noop``     | Runs upgrade without changing system state                         | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--unprivileged``       | Skip privileged operations (e.g., ``chown``) - only for testing    | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--patch-modes`` MODES  | Patch modes per file and version                                   | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--patch-safe``         | Use the default patch safe mode for each file type                 | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--recreate``           | Recreate deleted files that would be changed                       | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--prefix`` PATH        | Root location prefix (default: ``/``)                              | NO        |
+--------------------------+--------------------------------------------------------------------+-----------+
| ``--read-from`` PATH     | Backup directory to take as source of current state                | NO        |
|                          | (instead of production directories)                                |           |
+--------------------------+--------------------------------------------------------------------+-----------+

In most cases, the upgrade from one version to another will be as easy as simply run of command ``onecfg upgrade`` without any extra parameters. It'll upgrade based on internal configuration version tracking and currently installed OpenNebula. For example:

.. prompt:: bash # auto

    # onecfg upgrade
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-16_13:10:16_18130'
    ANY   : Configuration updated to 5.10.0

.. important::

    The upgrade process tries to apply changes from newer versions to your current configuration files (i.e., diff/patch approach modified for each different configuration file type). If the configuration files have been heavily modified, the upgrade might easily fail. The dedicated section describes how to :ref:`deal with conflicts <cfg_conflicts>` during the upgrade (patching) process.

If there is no upgrade available, the tool will not do anything:

.. prompt:: bash # auto

    # onecfg upgrade
    ANY   : No updates available

To see the files changed during the upgrade, run the command in verbose mode via ``--verbose`` parameter. For example:

.. prompt:: bash # auto

    # onecfg upgrade --verbose
    INFO  : Checking updates from 5.8.0 to 5.10.0
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-12_15:14:39_18278'
    INFO  : Updating from 5.8.0 to 5.10.0
    INFO  : Incremental update from 5.8.0 to 5.10.0
    INFO  : Update file '/etc/one/vcenter_driver.default'
    INFO  : Skip file '/etc/one/cli/oneprovision.yaml' - missing
    INFO  : Update file '/etc/one/cli/onegroup.yaml'
    INFO  : Update file '/etc/one/cli/onehost.yaml'
    INFO  : Update file '/etc/one/cli/oneimage.yaml'
    ...

Versions Override
-----------------

It can be useful to control the upgrade process by providing custom source configuration version (``--from VERSION``), target configuration version (``--to VERSION``), or both configuration versions in cases when some version is not known or when user wants to have control over the process when upgrading over multiple major versions.

The example below demonstrates step-by-step manual upgrade with versions enforcing (verbose output was filtered):

.. prompt:: bash # auto

    # onecfg upgrade --verbose --from 5.4.0 --to 5.6.0
    INFO  : Checking updates from 5.4.0 to 5.6.0
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:08:05_28564'
    INFO  : Updating from 5.4.0 to 5.6.0
    INFO  : Incremental update from 5.4.0 to 5.4.1
    INFO  : Incremental update from 5.4.1 to 5.4.2
    INFO  : Incremental update from 5.4.2 to 5.4.6
    INFO  : Incremental update from 5.4.6 to 5.6.0
    ANY   : Configuration updated to 5.6.0

    # onecfg upgrade --verbose --to 5.8.0
    INFO  : Checking updates from 5.6.0 to 5.8.0
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:10:18_29087'
    INFO  : Updating from 5.6.0 to 5.8.0
    INFO  : Incremental update from 5.6.0 to 5.8.0
    ANY   : Configuration updated to 5.8.0

    # onecfg upgrade --verbose
    INFO  : Checking updates from 5.8.0 to 5.10.0
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:11:19_29405'
    INFO  : Updating from 5.8.0 to 5.10.0
    INFO  : Incremental update from 5.8.0 to 5.10.0
    ANY   : Configuration updated to 5.10.0

Successful upgrade saves the target version as a new current configuration version.

Debug Output
------------

The tool provides more detailed information even about individual changes done in the configuration files and status of their application, if run with the debug logging enabled via parameter ``--debug``. On the example below, see the **Patch Report** section which uses the format introduced for :ref:`diff subcommand <cfg_diff>` prefixed by patch application status in square brackets:

.. prompt:: bash $ auto

    $ onecfg upgrade --debug
    DEBUG : Loading migrators
    INFO  : Checking updates from 5.4.0 to 5.10.0
    DEBUG : Backing up multiple dirs into '/tmp/onescape/backups/2019-12-16_13:16:16_22128'
    DEBUG : Backing up /tmp/ONE540/etc/one in /tmp/onescape/backups/2019-12-16_13:16:16_22128/etc/one
    DEBUG : Backing up /tmp/ONE540/var/lib/one/remotes in /tmp/onescape/backups/2019-12-16_13:16:16_22128/var/lib/one/remotes
    DEBUG : Loading migrators
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-16_13:16:16_22128'
    DEBUG : Restoring multiple dirs from '/tmp/ONE540'
    DEBUG : Restoring /tmp/ONE540/etc/one to /tmp/d20191216-22128-qqek6g/etc/one
    DEBUG : Restoring /tmp/ONE540/var/lib/one/remotes to /tmp/d20191216-22128-qqek6g/var/lib/one/remotes
    INFO  : Updating from 5.4.0 to 5.10.0
    INFO  : Incremental update from 5.4.0 to 5.4.1
    DEBUG : 5.4.0 -> 5.4.1 - No Ruby pre_up available
    INFO  : Update file '/etc/one/az_driver.conf'
    DEBUG : --- PATCH REPORT '/etc/one/az_driver.conf' ---
    DEBUG : Patch [OK] set instance_types/ExtraSmall/memory = 0.768
    DEBUG : Patch [OK] ins instance_types/Standard_A1_v2 = {"cpu"=>1, "memory"=>2.0}
    DEBUG : Patch [OK] ins instance_types/Standard_A2_v2 = {"cpu"=>2, "memory"=>4.0}
    DEBUG : Patch [OK] ins instance_types/Standard_A4_v2 = {"cpu"=>4, "memory"=>8.0}
    DEBUG : Patch [--] ins instance_types/Standard_A8_v2 = {"cpu"=>8, "memory"=>16.0}
    DEBUG : Patch [--] ins instance_types/Standard_A2m_v2 = {"cpu"=>2, "memory"=>16.0}
    DEBUG : Patch [--] ins instance_types/Standard_A4m_v2 = {"cpu"=>4, "memory"=>32.0}
    DEBUG : Patch [--] ins instance_types/Standard_A8m_v2 = {"cpu"=>8, "memory"=>64.0}
    DEBUG : Patch [--] ins instance_types/Standard_G1 = {"cpu"=>2, "memory"=>28.0}
    ...

