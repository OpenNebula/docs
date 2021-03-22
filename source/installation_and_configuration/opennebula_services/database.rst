.. _database_maintenance:

====================
Database Maintenance
====================

OpenNebula persists the state of the cloud into the selected :ref:`SQL database <database_setup>`. The database should be monitored and tuned for the best performance by cloud administrators following the best practices of the particular database product. In this guide, we provide a few tips on how to optimize database for OpenNebula and thoroughly describe OpenNebula database maintenance tool ``onedb``, which simplifies the most common database operations - backups and restores, version upgrades, or consistency checks.

.. _mysql_maintenance:

Optimize Database
=================

Depending on the environment, following tasks should be considered to execute periodically for an optimal database performance:

MySQL FTS Index
---------------

To be able to search for VMs by different attributes, the OpenNebula database leverages `full-text search indexes <https://dev.mysql.com/doc/refman/5.6/en/innodb-fulltext-index.html>`__ (FTS). The size of this index can grow fast, depending on the cloud load. To free some space, periodically recreate FTS indexes by executing the following SQL commands:

.. code::

   ALTER TABLE vm_pool DROP INDEX ftidx;
   ALTER TABLE vm_pool ADD FULLTEXT INDEX ftidx (search_token);

Cleanup Old Content
-------------------

When Virtual Machines are terminated (change into state ``DONE``), the OpenNebula just changes their state in database, but keeps the information in the database in case it would be required in the future (e.g., to generate accounting reports). To reduce the size of the VM table, it is recommended to periodically delete the information about already terminated Virtual Machines if not needed with :ref:`onedb purge-done <onedb_purge_done>` tool is available below.

.. _onedb:

OpenNebula Database Maintenance Tool
====================================

This section describes the OpenNebula database maintenance command-line tool ``onedb``. It can be used to get information from an OpenNebula database, backup and restore, upgrade to new versions of OpenNebula database, cleanup unused content, or fix inconsistency problems.

Available subcommands (visit the :ref:`manual page <cli>` for full reference):

- :ref:`version <onedb_version>` - Shows current database schema version
- :ref:`history <onedb_history>` - Lists history of schema upgrades
- :ref:`fsck <onedb_fsck>` - Performs consistency check and repair on data
- :ref:`upgrade <onedb_upgrade>` - Upgrades database for new OpenNebula version
- :ref:`backup <onedb_backup>` - Backups database into a file
- :ref:`restore <onedb_restore>` - Restores database from backup
- :ref:`purge-history <onedb_purge_history>` - Cleanups history records in VM metadata
- :ref:`purge-done <onedb_purge_done>` - Cleanups database from unused content
- :ref:`change-body <onedb_change_body>` - Allows to update OpenNebula objects in database
- :ref:`sqlite2mysql <onedb_sqlite2mysql>` - Migration tool from SQLite to MySQL/MariaDB

The command ``onedb`` works with all supported database backends - SQLite, MySQL, or PostgreSQL. The database type and connection parameters are automatically taken from OpenNebula Daemon configuration (:ref:`/etc/one/oned.conf <oned_conf>`), but can be overriden on the command line with the following example parameters:

**Automatic Connection Parameters**

.. prompt:: bash $ auto

    $ onedb <command> -v

**SQLite**

.. prompt:: bash $ auto

    $ onedb <command> -v --sqlite /var/lib/one/one.db

**MySQL/MariaDB**

.. prompt:: bash $ auto

    $ onedb <command> -v -S localhost -u oneadmin -p oneadmin -d opennebula

**PostgreSQL**

.. prompt:: bash $ auto

    $ onedb <command> -v -t postgresql -S localhost -u oneadmin -p oneadmin -d opennebula

.. warning::

    If the MySQL user password contains special characters, such as ``@`` or ``#``, the onedb command might fail to connect to the database. The workaround is to temporarily change the oneadmin password to an alphanumeric string. The `SET PASSWORD <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

    .. prompt:: text $ auto

        $ mysql -u oneadmin -p
        mysql> SET PASSWORD = PASSWORD('newpass');


.. _onedb_version:

onedb version
-------------

Prints the current database schema version, e.g.:

.. prompt:: text $ auto

    $ onedb version
    Shared: 5.12.0
    Local:  5.12.0
    Required shared version: 5.12.0
    Required local version:  5.12.0

Use the ``-v`` flag to see the complete version with comments, e.g.:

.. prompt:: text $ auto

    $ onedb version -v
    Shared tables version:   5.12.0
    Required version:        5.12.0
    Timestamp: 09/08 11:52:46
    Comment:   Database migrated from 5.6.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.

    Local tables version:    5.12.0
    Required version:        5.12.0
    Timestamp: 09/08 11:58:27
    Comment:   Database migrated from 5.8.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.

Command exits with different return codes based on the state of database:

- ``0``: The current version of the DB match with the source version.
- ``1``: The database has not been bootstraped yet, requires OpenNebula start.
- ``2``: The DB version is older than required, requires upgrade.
- ``3``: The DB version is newer and not supported by this release.
- ``-1``: Any other problem (e.g., connection issues)

.. _onedb_history:

onedb history
-------------

Every database upgrade is internally logged into the table. You can use the ``history`` command to show the upgrade history, e.g.:

.. prompt:: text $ auto

    $ onedb history -S localhost -u oneadmin -p oneadmin -d opennebula
    Version:   3.0.0
    Timestamp: 10/07 12:40:49
    Comment:   OpenNebula 3.0.0 daemon bootstrap

    ...

    Version:   3.7.80
    Timestamp: 10/08 17:36:15
    Comment:   Database migrated from 3.6.0 to 3.7.80 (OpenNebula 3.7.80) by onedb command.

    Version:   3.8.0
    Timestamp: 10/19 16:04:17
    Comment:   Database migrated from 3.7.80 to 3.8.0 (OpenNebula 3.8.0) by onedb command.


.. _onedb_fsck:

onedb fsck
----------

Checks the consistency of OpenNebula objects inside the database and fixes any problems it finds. For example, if the machine where OpenNebula is running crashes, or loses connectivity to the database, you may have the wrong number of VMs running in a Host, or incorrect usage quotas for some users.

.. prompt:: text $ auto

    $ onedb fsck
    Sqlite database backup stored in /var/lib/one/one.db.bck
    Use 'onedb restore' or copy the file back to restore the DB.

    Host 0 RUNNING_VMS has 12   is  11
    Host 0 CPU_USAGE has 1200   is  1100
    Host 0 MEM_USAGE has 1572864    is  1441792
    Image 0 RUNNING_VMS has 6   is  5
    User 2 quotas: CPU_USED has 12  is  11.0
    User 2 quotas: MEMORY_USED has 1536     is  1408
    User 2 quotas: VMS_USED has 12  is  11
    User 2 quotas: Image 0  RVMS has 6  is  5
    Group 1 quotas: CPU_USED has 12     is  11.0
    Group 1 quotas: MEMORY_USED has 1536    is  1408
    Group 1 quotas: VMS_USED has 12     is  11
    Group 1 quotas: Image 0 RVMS has 6  is  5

    Total errors found: 12

Repairing VM History End-time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If ``onedb fsck`` shows the following error message:

.. code-block:: none

    [UNREPAIRED] History record for VM <<vid>> seq # <<seq>> is not closed (etime = 0)

it means that when using accounting or showback, the etime (end-time) of that history record was not set, and the VM was considered as still running while it shouldn't been. To fix this problem, you could locate the time when the VM was shut down in the logs and then execute this patch to edit the times manually:

.. prompt:: text $ auto

    $ onedb patch -v /usr/lib/one/ruby/onedb/patches/history_times.rb
    Version read:
    Shared tables 4.11.80 : OpenNebula 5.0.1 daemon bootstrap
    Local tables  4.13.85 : OpenNebula 5.0.1 daemon bootstrap

    Sqlite database backup stored in /var/lib/one/one.db_2015-10-13_12:40:2.bck
    Use 'onedb restore' or copy the file back to restore the DB.

      > Running patch /usr/lib/one/ruby/onedb/patches/history_times.rb
    This tool will allow you to edit the timestamps of VM history records, used to calculate accounting and showback.
    VM ID: 1
    History sequence number: 0

    STIME   Start time          : 2015-10-08 15:24:06 UTC
    PSTIME  Prolog start time   : 2015-10-08 15:24:06 UTC
    PETIME  Prolog end time     : 2015-10-08 15:24:29 UTC
    RSTIME  Running start time  : 2015-10-08 15:24:29 UTC
    RETIME  Running end time    : 2015-10-08 15:42:35 UTC
    ESTIME  Epilog start time   : 2015-10-08 15:42:35 UTC
    EETIME  Epilog end time     : 2015-10-08 15:42:36 UTC
    ETIME   End time            : 2015-10-08 15:42:36 UTC

    To set new values:
      empty to use current value; <YYYY-MM-DD HH:MM:SS> in UTC; or 0 to leave unset (open history record).
    STIME   Start time          : 2015-10-08 15:24:06 UTC
    New value                   :

    ETIME   End time            : 2015-10-08 15:42:36 UTC
    New value                   :


    The history record # 0 for VM 1 will be updated with these new values:
    STIME   Start time          : 2015-10-08 15:24:06 UTC
    PSTIME  Prolog start time   : 2015-10-08 15:24:06 UTC
    PETIME  Prolog end time     : 2015-10-08 15:24:29 UTC
    RSTIME  Running start time  : 2015-10-08 15:24:29 UTC
    RETIME  Running end time    : 2015-10-08 15:42:35 UTC
    ESTIME  Epilog start time   : 2015-10-08 15:42:35 UTC
    EETIME  Epilog end time     : 2015-10-08 15:42:36 UTC
    ETIME   End time            : 2015-10-08 15:42:36 UTC

    Confirm to write to the database [Y/n]: y
      > Done

      > Total time: 27.79s


.. _onedb_upgrade:

onedb upgrade
-------------

Upgrades database for new OpenNebula version, process if fully documented in the :ref:`upgrade guides <upgrade>`.


.. _onedb_backup:

onedb backup
------------

Dumps OpenNebula database into a file, e.g.:

.. prompt:: text $ auto

    $ onedb backup /tmp/my_backup.db
    Sqlite database backup stored in /tmp/my_backup.db
    Use 'onedb restore' or copy the file back to restore the DB.


.. _onedb_restore:

onedb restore
-------------

Restores OpenNebula database from a provided :ref:`backup <onedb_backup>` file. Please note that only backups **from same backend can be restored**, i.e. you cannot backup SQLite database and then restore to a MySQL. E.g.,

.. prompt:: text $ auto

    $ onedb restore /tmp/my_backup.db
    Sqlite database backup restored in /var/lib/one/one.db


.. _onedb_purge_history:

onedb purge-history
-------------------

.. warning::

    The operation is done while OpenNebula is running. Make a **database backup** before executing!

Deletes all but last 2 history records from metadata of Virtual Machines, which are still active (not in a ``DONE`` state). You can specify the start and end dates if you don't want to delete all history. E.g.,

.. prompt:: text $ auto

    $ onedb purge-history --start 2014/01/01 --end 2016/06/15


.. _onedb_purge_done:

onedb purge-done
----------------

.. warning::

    The operation is done while OpenNebula is running. Make a **database backup** before executing!

Deletes information from the database with already terminated Virtual Machines (state ``DONE``). You can set start and end dates via ``-start`` and ``--end`` parameters if you don't want to delete all old data. E.g.,

.. prompt:: text $ auto

    $ onedb purge-done --end 2016/01


.. _onedb_change_body:

onedb change-body
-----------------

.. warning::

    The operation is done while OpenNebula is running. Make a **database backup** before executing!

This command allows updating of the body content of OpenNebula objects in a database. Supported object types are ``vm``, ``host``, ``vnet``, ``image``, ``cluster``, ``document``, ``group``, ``marketplace``, ``marketplaceapp``, ``secgroup``, ``template``, ``vrouter`` or ``zone``.

You can filter the objects to update using one of the options:

* ``--id``: object ID. Example: ``156``
* ``--xpath``: XPath expression. Example: ``TEMPLATE[count(NIC)>1]``
* ``--expr``: Simple expression using operators ``=``, ``!=``, ``<``, ``>``, ``<=`` or ``>=``. Examples: ``UNAME=oneadmin``, ``TEMPLATE/NIC/NIC_ID>0``

If you want to change a value, add it as a third parameter. Use ``--delete`` argument to delete matching objects.

Examples:

- Change the ``service`` network of VMs that belong to user ``johndoe`` to ``new_network``:

.. prompt:: text $ auto

    $ onedb change-body vm --expr UNAME=johndoe '/VM/TEMPLATE/NIC[NETWORK="service"]/NETWORK' new_network

- Delete the ``CACHE`` attribute for all VMs and their disks. Don't modify DB (``dry``), but only show the XML object content.

.. prompt:: text $ auto

    $ onedb change-body vm '/VM/TEMPLATE/DISK/CACHE' --delete --dry

- Delete the ``CACHE`` attribute for all disks in VMs in ``poweroff`` state:

.. prompt:: text $ auto

    $ onedb change-body vm --expr LCM_STATE=8 '/VM/TEMPLATE/DISK/CACHE' --delete


.. _onedb_sqlite2mysql:

onedb sqlite2mysql
------------------

This command migrates from an SQLite database to a MySQL database. Follow the steps:

* Stop OpenNebula
* Reconfigure database in :ref:`/etc/one/oned.conf <oned_conf>` to use MySQL instead of SQLite
* Bootstrap the MySQL Database by running ``oned -i``
* Migrate the Database: ``onedb sqlite2mysql -s <SQLITE_PATH> -u <MYSQL_USER> -p <MYSQL_PASS> -d <MYSQL_DB>``
* Start OpenNebula
