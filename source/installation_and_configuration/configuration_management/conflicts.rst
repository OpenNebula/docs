.. _cfg_conflicts:

===============
Troubleshooting
===============

The configuration files upgrade is a complex process, during which many problems may arise. The root cause of all problems are the users' customizations done in the configuration files on places that also change in a newer version. Because the upgrade process tries to apply changes from newer versions to existing files, the tool can be confused when it reaches the incompatibly modified part.

In case of a problem, the upgrade process terminates and **leaves the state of configuration files unchanged**. There is no automatic mechanism preconfigured, but the user has to instruct the tool on how to resolve the problem. This is done by specifying a **patch modes** globally for the whole process, for a particular file, or for a particular file and (intermediate) version we upgrade to.

.. _cfg_patch_modes:

Patch Modes
===========

The way how the upgrade process works is a typical diff/patch approach. Each version change is described as a series of patch operations that must be applied. During the patching, some of the following problems may arise:

- A parameter has been removed by the user, but the patch tries to change it.
- Data structure of the parameter isn't the expected one.
- Precise location for change can't be found.

To deal with these situations, there are following patch modes available:

+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| Patch Modes      | Action                                                                | Problem Cause                                           |
+==================+=======================================================================+=========================================================+
| ``skip``         | **Skip** patch operation                                              | Removed or incompatible configuration part.             |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| ``force``        | Place value in any suitable place, instead of precise place.          | No precise place for application found.                 |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+
| ``replace``      | **Replace** user changed values **with new default ones**.            | User changed value for which new default appeared.      |
+------------------+-----------------------------------------------------------------------+---------------------------------------------------------+

The patch modes are specified using ``--patch-modes MODES`` parameter passed to the ``onecfg upgrade``. Patch modes can be used multiple times, but always the most specific one overrides the more general ones (patch mode for particular file/version overrides the default patch mode). The syntax of the parameter should follow one of the following syntaxes:

- ``MODES`` - **default patch modes** ``MODES`` for all files and all versions.
- ``MODES:FILE_NAME`` - patch modes ``MODES`` for specific file ``FILE_NAME`` and all its versions
- ``MODES:FILE_NAME:VERSION`` - patch modes ``MODES`` for specific file ``FILE_NAME`` when upgraded **to version** ``VERSION``

Modes (``MODES``) is a comma (``,``) separated list of selected patch modes (**skip**, **force**, **replace**).

Default Safe Patch Modes
------------------------

Each different type of file you can find :ref:`here <cfg_files>` has the following default safe patch mode:

+-------------------------+------------------------+
| File Type               | Default Patch Mode     |
+=========================+========================+
| Plain file              | None                   |
+-------------------------+------------------------+
| YAML                    | None                   |
+-------------------------+------------------------+
| YAML w/ ordered arrays  | ``force``              |
+-------------------------+------------------------+
| Shell                   | None                   |
+-------------------------+------------------------+
| oned.conf-like          | ``skip``               |
+-------------------------+------------------------+

These default patching modes can be used in the upgrade process (``onecfg upgrade``) using the parameter ``--patch-safe``.

Examples
--------

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
===================

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
