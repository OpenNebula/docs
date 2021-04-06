.. _restoring_version:

==============================
Restoring Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula |version| still installed, restore the DB backup using ``onedb restore -f``
-  Uninstall OpenNebula |version|, and install your previous version again.
-  Copy back the backup of ``/etc/one`` you did to restore your configuration.
