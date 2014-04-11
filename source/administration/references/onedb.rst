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

If the MySQL database password contains specials characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

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

The upgrade process is fully documented in the :ref:`Upgrading from Previous Versions guide <upgrade_46rc>`.

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
