
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.4.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.6.

..
    Database
    =========================
    - The table ``vm_pool`` now contains the column ``json_body`` which provides searching for values using JSON keys, and no longer contains the ``search_token`` column, effectively removing FULLTEXT searching entirely. This should greatly improve performance when performing search filters on virtual machines as well as remove the need for regenerating FULLTEXT indexing.  Due to this change, the search now uses a JSON path to search, for example: ``VM.NAME=production`` would match all VM's which have name containing ``production``.
    - The migrator has been updated to make these changes automatically with the ``onedb upgrade`` tool. When tested on a database containing just over 150,000 VM entries, the upgrade took roughly 4100 seconds using an HDD and about 3500 seconds using a ramdisk.

Storage & Images
========================
- When an error occurs while deleting an they image are now moved to ERROR state, instead of just logging the error and blindly removing it from the database. To recover from this failure the delete operation can be retried or you can pass a ``force`` option to remove the image from the database.

Network
========================
- When you update a network it may trigger update operations in the hypervisors to sync the VM configuration with the changes in the network (e.g. update VLAN_ID). Previous versions did not make any change on running VMs.
- Ebtables option has been removed from the configuration files and interface. Drivers are still present but deprecated and will be removed from the distribution in a future release.

Virtual Machines
========================
- Context attribute ``GATEWAY6`` is no longer generated, just the ``IP6_GATEWAY`` is added. This attribute was not used by context packages since version 6.4.0

Logging
========================
Previously OpenNebula was opening log files while truncating their previous content and relying on the logrotate to take care of the rotation before the service start. This behavior could potentially lead to missing logs in case logrotate failed. To avoid this, since version 6.6 OpenNebula opens the logs in ``append`` mode and lograte is suppsed to rotate the logs and truncate it. Also, in the older versions compression of the old log files was done during the logrotate which could eventually prolong service start. Since 6.6 old log compression is done via an additional systemd ``ExecPreStart`` section in the background.
