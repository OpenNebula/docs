.. _database_maintenance:

.. todo:: Review and adapt. This is the old onedb guide + database maintenance

====================
Database Maintenance
====================

.. _mysql_maintenance:

MySQL database maintenance
===========================

For an optimal database performance improvement there are some tasks that should be done periodically, depending on the load of the environment. They are listed below.

Search index
----------------------

In order to be able to search for VMs by different attributes, OpenNebula's database has an `FTS index <https://dev.mysql.com/doc/refman/5.6/en/innodb-fulltext-index.html>`__. The size of this index can increase fast, depending on the cloud load. To free some space, perform the following maintenance task periodically:

.. code::

   alter table vm_pool drop index ftidx;
   alter table vm_pool add fulltext index ftidx (search_token);

VMs in DONE state
----------------------

When a VM is terminated, OpenNebula changes its state to DONE but it keeps the VM in the database in case the VM information is required in the future (e.g. to generate accounting reports). In order to reduce the size of the VM table, it is recommended to periodically delete the VMs in the DONE state when not needed. For this task the :ref:`onedb purge-done <cli>` tool is available.


.. _onedb:

This section describes the ``onedb`` CLI tool. It can be used to get information from an OpenNebula database, upgrade it, or fix inconsistency problems.

Connection Parameters
=====================

The command ``onedb`` can connect to any SQLite or MySQL database. Visit the :ref:`onedb man page <cli>` for a complete reference. These are two examples for the default databases:

.. prompt:: text $ auto

    $ onedb <command> -v --sqlite /var/lib/one/one.db
    $ onedb <command> -v -S localhost -u oneadmin -p oneadmin -d opennebula

onedb fsck
==========

Checks the consistency of the DB (database), and fixes any problems found. For example, if the machine where OpenNebula is running crashes, or loses connectivity to the database, you may have the wrong number of VMs running in a Host, or incorrect usage quotas for some users.

.. prompt:: text $ auto

    $ onedb fsck --sqlite /var/lib/one/one.db
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

If onedb fsck shows the following error message:

.. code-block:: none

    [UNREPAIRED] History record for VM <<vid>> seq # <<seq>> is not closed (etime = 0)

It means that when using accounting or showback, the etime (end-time) of that history record was not set, and the VM was considered as still running when it should not have been. To fix this problem, you could locate the time when the VM was shut down in the logs and then execute this patch to edit the times manually:

.. prompt:: text $ auto

    $ onedb patch -v --sqlite /var/lib/one/one.db /usr/lib/one/ruby/onedb/patches/history_times.rb
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


onedb version
=============

Prints the current DB version.

.. prompt:: text $ auto

    $ onedb version --sqlite /var/lib/one/one.db
    Shared: 5.12.0
    Local:  5.12.0
    Required shared version: 5.12.0
    Required local version:  5.12.0



Use the ``-v`` flag to see the complete version and comment.

.. prompt:: text $ auto

    $ onedb version -v --sqlite /var/lib/one/one.db
    Shared tables version:   5.12.0
    Required version:        5.12.0
    Timestamp: 09/08 11:52:46
    Comment:   Database migrated from 5.6.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.

    Local tables version:    5.12.0
    Required version:        5.12.0
    Timestamp: 09/08 11:58:27
    Comment:   Database migrated from 5.8.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.

.. note:: ``onedb version`` command will return different RCs depending on the state of the installation. Run ``onedb version --help`` for more information.

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin password to an alphanumeric string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. prompt:: text $ auto

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');

onedb history
=============

Each time the DB is upgraded, the process is logged. You can use the ``history`` command to retrieve the upgrade history.

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

onedb upgrade
=============

The upgrade process is fully documented in the :ref:`upgrade guides <upgrade>`.

onedb backup
============

Dumps the OpenNebula DB to a file.

.. prompt:: text $ auto

    $ onedb backup --sqlite /var/lib/one/one.db /tmp/my_backup.db
    Sqlite database backup stored in /tmp/my_backup.db
    Use 'onedb restore' or copy the file back to restore the DB.

onedb restore
=============

Restores the DB from a backup file. Please note that this tool will only restore backups generated from the same backend, i.e. you cannot backup an SQLite database and then try to populate a MySQL one.

.. _onedb_sqlite2mysql:

onedb sqlite2mysql
==================

This command migrates from an SQLite database to a MySQL database. The procedure to follow is:

* Stop OpenNebula
* Change the DB directive in ``/etc/one/oned.conf`` to use MySQL instead of SQLite
* Bootstrap the MySQL Database: ``oned -i``
* Migrate the Database: ``onedb sqlite2mysql -s <SQLITE_PATH> -u <MYSQL_USER> -p <MYSQL_PASS> -d <MYSQL_DB>``
* Start OpenNebula

onedb purge-history
===================

Deletes all but the last 2 history records from non-DONE VMs. You can specify start and end dates in case you don't want to delete all history:

.. prompt:: text $ auto

    $ onedb purge-history --start 2014/01/01 --end 2016/06/15

.. warning::

    This action is done while OpenNebula is running. Make a backup of the database before executing.

onedb purge-done
================

Deletes information from machines in the DONE state; ``--start`` and ``--end`` parameters can be used as for ``purge-history``:

.. prompt:: text $ auto

    $ onedb purge-done --end 2016/01

.. warning::

    This action is done while OpenNebula is running. Make a backup of the database before executing.

onedb change-body
=================

Changes a value from the body of an object. The possible objects are: ``vm``, ``host``, ``vnet``, ``image``, ``cluster``, ``document``, ``group``, ``marketplace``, ``marketplaceapp``, ``secgroup``, ``template``, ``vrouter`` or ``zone``.

You can filter the objects to modify using one of these options:

    * ``--id``: object id, example: 156
    * ``--xpath``: xpath expression, example: ``TEMPLATE[count(NIC)>1]``
    * ``--expr``: xpath expression, can use operators ``=``, ``!=``, ``<``, ``>``, ``<=`` or ``>=``
        examples: ``UNAME=oneadmin``, ``TEMPLATE/NIC/NIC_ID>0``

If you want to change a value, use a third parameter. In case you want to delete it use ``--delete`` option.

Change the second network of VMs that belong to "user":

.. prompt:: text $ auto

    $ onedb change-body vm --expr UNAME=user '/VM/TEMPLATE/NIC[NETWORK="service"]/NETWORK' new_network

Delete the cache attribute for all disks, write XML, but do not modify the DB:

.. prompt:: text $ auto

    $ onedb change-body vm '/VM/TEMPLATE/DISK/CACHE' --delete --dry

Delete the cache attribute for all disks in poweroff:

.. prompt:: text $ auto

    $ onedb change-body vm --expr LCM_STATE=8 '/VM/TEMPLATE/DISK/CACHE' --delete

.. warning::

    This action is done while OpenNebula is running. Make a backup of the database before executing.
