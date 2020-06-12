.. _restoring_version_5.10:

==============================
Restoring Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula |version| still installed, restore the DB backup using ``onedb restore -f``
-  Uninstall OpenNebula |version|, and install again your previous version.
-  Copy back the backup of ``/etc/one`` you did to restore your configuration.
