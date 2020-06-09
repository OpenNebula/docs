.. _conf_management_module:

===============================
Configuration Management Module
===============================

Overview
========

The **Configuration Module** is part of the OneScape enterprise tool, its aim is to provide the means to manage and interact with configuration files. It provides the following functionality:

- Upgrade your configuration files for the new OpenNebula version.
- Check the versions status of the current installation.
- Identify custom changes made to the configuration files.
- Validate configuration files.

All the functionality is available through the single command-line tool ``onecfg``.

Installation & Upgrade
======================

In order to use the Configuration Management Module, the onescape package must be installed.

Step 1. Repository Setup
------------------------

The host needs to be configured to have access to dedicated authenticated customer repositories, then you can install or update OneScape packages.

Access to the software repositories with OneScape is authenticated by the customer's user name and token. Repository definitions below contain the placeholders ``${AUTH}`` where customer's credentials should be put. To simplify the process and to avoid dealing with the repository configurations manually, export your credentials following way before running the next commands.

.. prompt:: bash # auto

    # export AUTH='user:token'

CentOS and RHEL
~~~~~~~~~~~~~~~

To add OneScape repository execute the following as root:

**CentOS/RHEL 7**

.. prompt:: bash # auto

    # cat << EOT > /etc/yum.repos.d/onescape.repo
    [onescape]
    name=onescape
    baseurl=https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/CentOS/7/\$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT

**CentOS/RHEL 8**

.. prompt:: bash # auto

    # cat << EOT > /etc/yum.repos.d/onescape.repo
    [onescape]
    name=onescape
    baseurl=https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/CentOS/8/\$basearch
    enabled=1
    gpgkey=https://downloads.opennebula.io/repo/repo.key
    gpgcheck=1
    repo_gpgcheck=1
    EOT

Debian and Ubuntu
~~~~~~~~~~~~~~~~~

To add OneScape repository on Debian/Ubuntu execute as root:

.. prompt:: bash # auto

    # wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -

**Debian 9**

.. prompt:: bash # auto

    # echo "deb https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/Debian/9 stable onescape" > /etc/apt/sources.list.d/onescape.list

**Debian 10**

.. prompt:: bash # auto

    # echo "deb https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/Debian/10 stable onescape" > /etc/apt/sources.list.d/onescape.list

**Ubuntu 16.04**

.. prompt:: bash # auto

    # echo "deb https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/Ubuntu/16.04 stable onescape" > /etc/apt/sources.list.d/onescape.list

**Ubuntu 18.04**

.. prompt:: bash # auto

    # echo "deb https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/Ubuntu/18.04 stable onescape" > /etc/apt/sources.list.d/onescape.list

**Ubuntu 20.04**

.. prompt:: bash # auto

    # echo "deb https://${AUTH}@enterprise.opennebula.io/repo/onescape/5.10/Ubuntu/20.04 stable onescape" > /etc/apt/sources.list.d/onescape.list

Step 2. Installation
--------------------

CentOS and RHEL
~~~~~~~~~~~~~~~

.. prompt:: bash $ auto

   $ sudo yum install onescape

Debian and Ubuntu
~~~~~~~~~~~~~~~~~

.. prompt:: bash $ auto

   $ sudo apt-get install onescape

Step 3. Upgrade
---------------

CentOS and RHEL
~~~~~~~~~~~~~~~

.. prompt:: bash $ auto

   $ sudo yum update onescape

Debian and Ubuntu
~~~~~~~~~~~~~~~~~

.. prompt:: bash $ auto

   $ sudo apt-get install onescape

.. _conf_management_usage:

Basic Usage
===========

The configuration module is controlled via ``onecfg`` CLI tool. This section covers subcommands provided by the tool:

- :ref:`status <cfg_status>` - Versions status
- :ref:`init <cfg_init>` - Initialize version management state
- :ref:`validate <cfg_validate>` - Validate current configuration files
- :ref:`diff <cfg_diff>` - Identify changes in configuration files
- :ref:`upgrade <cfg_upgrade>` - Upgrade configuration files to a new version

.. important::

    This command must be always run under privileged user ``root`` directly or via ``sudo``. For example:

    .. prompt:: bash $ auto

        $ sudo onecfg status

The tool comes with help for each subcommand and command-line option. Simple run without any parameter or a run with the parameter ``--help`` prints the brief documentation (e.g., ``onecfg status --help``).

.. _cfg_status:

Status
------

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

    **OpenNebula version** and **Configuration version** are tracked independently, but both versions are closely related and must be from the same X.Y release (i.e., OpenNebula 5.10.Z must have a configuration on version 5.10.Z). Minor configuration releases X.Y.Z are tight to the OpenNebula version for which a significant update has happened. Usually, configuration version **remains on the same version for all OpenNebula releases** within the same X.Y release (i.e., configuration version 5.8.0 is valid for all OpenNebula from 5.8.0 to 5.8.5 releases).

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
~~~~~~~~~~

Based on different status, the command ends with the following exit codes:

- **0** - No update available.
- **1** - Updates available.
- **255** - Unspecified error (e.g., unknown versions)

.. _cfg_init:

Init
----

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

   Version state is stored in configuration file ``/etc/onescape/config.yaml``. You **shouldn't modify this file directly**, as it might result in unpredictable behavior.

Example
~~~~~~~

Initialization is necessary when the OneScape is not sure about the version of current configuration files. When running ``onecfg status`` in the uninitialized environment, you might get the following error:

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
--------

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
~~~~~~~~~~

- **0** - all files are OK
- **1** - error when processing some file

.. _cfg_diff:

Diff
----

Similar to the validation functionality above, the ``diff`` subcommand reads all :ref:`configuration files <cfg_files>` and identifies changes that were done by the user when compared to based configuration files. It doesn't do any changes in the files, only reads and compares them.

Parameters:

+--------------------+---------------------------------------+-----------+
| Parameter          | Description                           | Mandatory |
+====================+=======================================+===========+
| ``--prefix`` PATH  | Root location prefix (default: ``/``) | NO        |
+--------------------+---------------------------------------+-----------+

The command prints only files with changes. Unchanged files are not included in the output. Each individual change description is printed on a separate line with following syntax:

- ``ins PATH = VALUE`` - inserted new parameter on ``PATH`` with ``VALUE```
- ``set PATH = VALUE`` - existing attribute on ``PATH`` was changed with different ``VALUE``
- ``rm PATH (= VALUE)`` - deleted parameter on ``PATH`` (optionally specifying the removed ``VALUE``)

Example:

.. prompt:: bash # auto

    # onecfg diff
    /etc/one/cli/onegroup.yaml
    - ins ID/adjust = true
    - set NAME/size = 15
    - ins NAME/expand = true

    /etc/one/cli/onehost.yaml
    - ins ID/adjust = true
    - ins NAME/expand = true
    - set CLUSTER/size = 10
    - set STAT/size = 4

    /etc/one/cli/oneimage.yaml
    - ins ID/adjust = true
    - set USER/size = 8
    - set GROUP/size = 8
    - ins NAME/expand = true

    /etc/one/oned.conf
    - set DEFAULT_DEVICE_PREFIX = "\"sd\""
    - set VM_MAD[NAME = '"vcenter"']/ARGUMENTS = "\"-p -t 15 -r 0 -s sh vcenter\""
    - rm  VM_MAD[NAME = '"vcenter"']/DEFAULT = "\"vmm_exec/vmm_exec_vcenter.conf\""
    - ins HM_MAD/ARGUMENTS = "\"-p 2101 -l 2102 -b 127.0.0.1\""
    - ins VM_RESTRICTED_ATTR = "\"NIC/FILTER\""
    ...

How to read the output? Let's go through few examples for ``/etc/one/cli/onegroup.yaml`` above:

- ``ins ID/adjust = true`` - new key ``adjust`` with value ``true`` was added into ``ID`` section
- ``set NAME/size = 15`` - value for existing key ``size`` inside section ``NAME`` was changed to ``15``

.. _cfg_upgrade:

Upgrade
-------

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
| ``--noop``               | Runs upgrade without changing system state                         | NO        |
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
~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~

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

.. _cfg_conflicts:

Troubleshooting
===============

The configuration files upgrade is a complex process, during which many problems may arise. The root cause of all problems is the users' customizations done in the configuration files on places that change in a newer version. Because the upgrade process tries to apply changes from newer versions to existing files, the tool can be confused when it reaches the incompatibly modified part.

In case of a problem, the upgrade process terminates and leaves the state of configuration files unchanged. There is no automatic mechanism preconfigured, but the user has to instruct the tool on how to resolve the problem. This is done by specifying a **patch modes** globally for the whole process, for a particular file, or for a particular file and (intermediate) version we upgrade to.

Patch Modes
-----------

The way how the upgrade process works is a typical diff/patch approach. Each version change is described as a series of patches that must be applied. During the patching, some of the following problems may arise:

- A parameter has been removed by the user, but the patch tries to change it.
- Data structure of the parameter isn't the expected one.
- Precise location for change can't be found.

To deal with these situations, there are following patch modes available:

+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| Patch Modes      | Action                                                                | Problem Cause                                           |
+==================+=======================================================================+=========================================================+
| ``skip``         | **Skip** patch operation                                              | Removed or incompatible configuration part.             |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| ``force``        | Place value in some suitable place, instead of precise place.         | No precise place for application found                  |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| ``replace``      | **Replace** user changed values **with new default ones**.            | User changed value for which new default appeared       |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+

The patch modes are specified using ``--patch-modes MODES`` parameter passed to the ``onecfg upgrade``. Patch modes can be used multiple times, but always the most specific one overrides the more general ones (patch mode for particular file/version overrides the default patch mode). The syntax of the parameter should follow one of the following syntaxes:

- ``MODES`` - **default patch modes** ``MODES`` for all files and all versions.
- ``MODES:FILE_NAME`` - patch modes ``MODES`` for specific file ``FILE_NAME`` and all its versions
- ``MODES:FILE_NAME:VERSION`` - patch modes ``MODES`` for specific file ``FILE_NAME`` when upgraded **to version** ``VERSION``

Modes (``MODES``) is a comma (``,``) separated list of selected patch modes (**skip**, **force**, **replace**).

Default Patch Modes
~~~~~~~~~~~~~~~~~~~

Each different type of file you can find :ref:`here <cfg_files>` has the following default patch mode:

+---------------+--------------------+
| File Type     | Default Patch Mode |
+===============+====================+
| Simple        | None               |
+---------------+--------------------+
| Yaml          | None               |
+---------------+--------------------+
| Yaml::Strict  | ``force``          |
+---------------+--------------------+
| Augeas::Shell | None               |
+---------------+--------------------+
| Augeas::ONE   | ``skip``           |
+---------------+--------------------+

These default patching modes can be used in the upgrade process (``onecfg upgrade``) using the parameter ``--patch-safe``.

Examples
~~~~~~~~

Set default patch mode to **skip** problematic places for all files in any version:

.. prompt:: bash # auto

    # onecfg upgrade --patch-modes skip

Set patch mode to **skip** problematic places only for ``/etc/one/oned.conf``, leave unspecified mode for all the rest files:

.. prompt:: bash # auto

    # onecfg upgrade --patch-modes skip:/etc/one/oned.conf

Set patch mode to **skip** only for ``/etc/one/oned.conf`` when upgraded **to version** 5.6.0, rest files have unspecified mode:

.. prompt:: bash # auto

    # onecfg upgrade --patch-modes skip:/etc/one/oned.conf:5.6.0

Example of multiple patch modes for multiple files:

.. prompt:: bash # auto

    # onecfg upgrade \
        --patch-modes skip:/etc/one/oned.conf \
        --patch-modes skip,replace:/etc/one/oned.conf:5.10.0 \
        --patch-modes force:/etc/one/sunstone-logos.yaml:5.6.0 \
        --patch-modes replace:/etc/one/sunstone-server.conf \
        --patch-modes skip:/etc/one/sunstone-views/admin.yaml:5.4.1 \
        --patch-modes skip:/etc/one/sunstone-views/admin.yaml:5.4.2 \
        --patch-modes skip:/etc/one/sunstone-views/kvm/admin.yaml

Restore from Backup
-------------------

Upgrade operations are done safely on a copy of production configuration files without changing the system state. After upgrade ends successffully, the modified files are copied back to production locations.

.. important::

    Each upgrade operation creates a backup of current directories with OpenNebula configuration files into ``/var/lib/one/backups/config/``. In case of error when copying the modified state back to production locations, the automatic restore is triggered.

In the case of a catastrophic failure when even automatic restore fails, the original content of configuration directories must be restored **manually** from initial backup. Example of failed upgrade which requires manual intervention:

.. prompt:: bash # auto

    # onecfg upgrade
    ANY   : Backup stored in '/tmp/onescape/backups/2019-12-18_12:22:28_2891'
    FATAL : Fatal error on restore, we are very sorry! You have to restore following directories manually:
        - copy /tmp/onescape/backups/2019-12-18_12:22:28_2891/etc/one into /etc/one
        - copy /tmp/onescape/backups/2019-12-18_12:22:28_2891/var/lib/one/remotes into /var/lib/one/remotes
    FATAL : FAILED - Data synchronization failed

.. _cfg_files:

Appendix - List of Configuration Files
======================================

Following table describes all configuration files and their type from directories

- ``/etc/one/``
- ``/var/lib/one/remotes/``

managed by the **onecfg** tool:

================================================================== ======================
Name                                                               Type
================================================================== ======================
``/etc/one/auth/ldap_auth.conf``                                   YAML w/ ordered arrays
``/etc/one/auth/server_x509_auth.conf``                            YAML
``/etc/one/auth/x509_auth.conf``                                   YAML
``/etc/one/az_driver.conf``                                        YAML
``/etc/one/az_driver.default``                                     Plain file (or XML)
``/etc/one/cli/*.yaml``                                            YAML w/ ordered arrays
``/etc/one/defaultrc``                                             Shell
``/etc/one/ec2_driver.conf``                                       YAML
``/etc/one/ec2_driver.default``                                    Plain file (or XML)
``/etc/one/ec2query_templates/*.erb``                              Plain file (or XML)
``/etc/one/econe.conf``                                            YAML
``/etc/one/hm/hmrc``                                               Shell
``/etc/one/monitord.conf``                                         oned.conf-like
``/etc/one/oned.conf``                                             oned.conf-like
``/etc/one/oneflow-server.conf``                                   YAML
``/etc/one/onegate-server.conf``                                   YAML
``/etc/one/onehem-server.conf``                                    YAML
``/etc/one/packet_driver.default``                                 Plain file (or XML)
``/etc/one/sched.conf``                                            oned.conf-like
``/etc/one/sunstone-logos.yaml``                                   YAML w/ ordered arrays
``/etc/one/sunstone-server.conf``                                  YAML
``/etc/one/sunstone-views.yaml``                                   YAML
``/etc/one/sunstone-views/**/*.yaml``                              YAML
``/etc/one/tmrc``                                                  Shell
``/etc/one/vcenter_driver.conf``                                   YAML
``/etc/one/vcenter_driver.default``                                Plain file (or XML)
``/etc/one/vmm_exec/vmm_exec_kvm.conf``                            oned.conf-like
``/etc/one/vmm_exec/vmm_exec_vcenter.conf``                        oned.conf-like
``/etc/one/vmm_exec/vmm_execrc``                                   Shell
``/var/lib/one/remotes/datastore/ceph/ceph.conf``                  Shell
``/var/lib/one/remotes/etc/datastore/ceph/ceph.conf``              Shell
``/var/lib/one/remotes/etc/datastore/fs/fs.conf``                  Shell
``/var/lib/one/remotes/etc/im/firecracker-probes.d/probe_db.conf`` YAML
``/var/lib/one/remotes/etc/im/kvm-probes.d/pci.conf``              YAML
``/var/lib/one/remotes/etc/im/kvm-probes.d/probe_db.conf``         YAML
``/var/lib/one/remotes/etc/im/lxd-probes.d/pci.conf``              YAML
``/var/lib/one/remotes/etc/im/lxd-probes.d/probe_db.conf``         YAML
``/var/lib/one/remotes/etc/market/http/http.conf``                 Shell
``/var/lib/one/remotes/etc/tm/fs_lvm/fs_lvm.conf``                 Shell
``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc``         YAML
``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``                         Shell
``/var/lib/one/remotes/etc/vmm/lxd/lxdrc``                         YAML
``/var/lib/one/remotes/etc/vmm/vcenter/vcenterrc``                 YAML
``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``            YAML
``/var/lib/one/remotes/vmm/kvm/kvmrc``                             Shell
``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``                YAML
================================================================== ======================
