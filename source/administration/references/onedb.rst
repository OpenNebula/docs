.. _onedb:

===========
Onedb Tool
===========

This guide describes the ``onedb`` CLI tool. It can be used to get information from an OpenNebula database, upgrade it, or fix inconsistency problems.

Connection Parameters
=====================

The command ``onedb`` can connect to any SQLite or MySQL database. Visit the :ref:`onedb man page <cli>` for a complete reference. These are two examples for the default databases:

.. code::

    $ onedb <command> -v --sqlite /var/lib/one/one.db

    $ onedb <command> -v -S localhost -u oneadmin -p oneadmin -d opennebula

onedb fsck
==========

Checks the consistency of the DB, and fixes the problems found. For example, if the machine where OpenNebula is running crashes, or looses connectivity with the database, you may have a wrong number of VMs running in a Host, or incorrect usage quotas for some users.

.. code::

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

.. code::

    [UNREPAIRED] History record for VM <<vid>> seq # <<seq>> is not closed (etime = 0)

This is due to `bug #4000 <http://dev.opennebula.org/issues/4000>`_. It means that when using accounting or showback, the etime (end-time) of that history record is not set, and the VM is considered as still running when it should not. To fix this problem, locate the time when the VM was shut down in the logs and then execute this patch to edit the times manually:

.. code::


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

.. code::

    $ onedb version --sqlite /var/lib/one/one.db
    3.8.0

Use the ``-v`` flag to see the complete version and comment.

.. code::

    $ onedb version -v --sqlite /var/lib/one/one.db
    Version:   3.8.0
    Timestamp: 10/19 16:04:17
    Comment:   Database migrated from 3.7.80 to 3.8.0 (OpenNebula 3.8.0) by onedb command.

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');

onedb history
=============

Each time the DB is upgraded, the process is logged. You can use the ``history`` command to retrieve the upgrade history.

.. code::

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

The upgrade process is fully documented in the :ref:`Upgrading from Previous Versions guide <upgrade>`.

onedb backup
============

Dumps the OpenNebula DB to a file.

.. code::

    $ onedb backup --sqlite /var/lib/one/one.db /tmp/my_backup.db
    Sqlite database backup stored in /tmp/my_backup.db
    Use 'onedb restore' or copy the file back to restore the DB.

onedb restore
=============

Restores the DB from a backup file. Please not that this tool will only restore backups generated from the same backend, i.e. you cannot backup a SQLite database and then try to populate a MySQL one.

onedb sqlite2mysql
==================

This command migrates from a sqlite database to a mysql database. The procedure to follow is:

* Stop OpenNebula
* Change the DB directive in ``/etc/one/oned.conf`` to use MySQL instead of SQLite
* Bootstrap the MySQL Database: ``oned -i``
* Migrate the Database: ``onedb sqlite2mysql -s <SQLITE_PATH> -u <MYSQL_USER> -p <MYSQL_PASS> -d <MYSQL_DB>``
* Start OpenNebula
