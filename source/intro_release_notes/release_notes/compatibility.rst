
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.4.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 7.0.

Database
=========================
- The table ``vm_pool`` now contains the column ``json_body`` which provides searching for values using JSON keys, and no longer contains the ``search_token`` column, effectively removing FULLTEXT searching entirely. This should greatly improve performance when performing search filters on virtual machines as well as remove the need for regenerating FULLTEXT indexing.  Due to this change, the search now uses a JSON path to search, for example: ``VM.NAME=production`` would match all VM's which have name containing ``production``.
- The migrator has been updated to make these changes automatically with the ``onedb upgrade`` tool. When tested on a database containing just over 150,000 VM entries, the upgrade took roughly 4100 seconds using an HDD and about 3500 seconds using a ramdisk.
