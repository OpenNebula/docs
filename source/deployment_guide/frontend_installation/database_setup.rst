.. _database_setup:
.. _mysql:
.. _mysql_setup:

==============
Database Setup
==============

MySQL Setup
===========

The MySQL/MariaDB back-end is an alternative to the default SQLite back-end. In this guide and in the rest of OpenNebula's documentation and configuration files we will refer to this database as MySQL. However, OpenNebula can use either MySQL or MariaDB.

The two back-ends cannot coexist (SQLite and MySQL), and you will have to decide which one is going to be used while planning your OpenNebula installation.

.. note:: If you are planning to install OpenNebula with MySQL back-end, please follow this guide *prior* to starting OpenNebula the first time to avoid problems with oneadmin and serveradmin credentials.

.. _mysql_installation:

Installation
============

First of all, you need a working MySQL server. You can either deploy one for the OpenNebula installation or reuse any existing MySQL already deployed and accessible by the Frontend.

Configuring MySQL
-----------------

You need to add a new user and grant it privileges on the ``opennebula`` database. This new database doesn't need to exist as OpenNebula will create it the first time it runs.

Assuming you are going to use the default values, log in to your MySQL server and issue the following commands:

.. code::

    $ mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor. [...]

    mysql> CREATE USER 'oneadmin' IDENTIFIED BY '<thepassword>';
    Query OK, 0 rows affected (0.00 sec)
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin';
    Query OK, 0 rows affected (0.00 sec)

Visit the `MySQL documentation <https://dev.mysql.com/doc/refman/8.0/en/access-control.html>`__ to learn how to manage accounts.

Now configure the transaction isolation level:

.. code::

    mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;


Configuring OpenNebula
----------------------

Before you run OpenNebula for the first time, you need to set in the :ref:`oned.configuration <oned_conf>` the connection details, and the database you have granted privileges on.

.. code::

    # Sample configuration for MySQL
    DB = [ backend = "mysql",
           server  = "localhost",
           port    = 0,
           user    = "oneadmin",
           passwd  = "<thepassword>",
           db_name = "opennebula" ]

Fields:

* **server**: URL of the machine running the MySQL server.
* **port**: port for the connection to the server. If set to 0, the default port is used.
* **user**: MySQL user-name.
* **passwd**: MySQL password.
* **db_name**: Name of the MySQL database OpenNebula will use.

Using OpenNebula with MySQL
===========================

After this installation and configuration process you can use OpenNebula as usual.

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


.. _postgresql:
.. _postgresql_setup:

PostgreSQL Setup (TP)
=====================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

The PostgreSQL back-end is an alternative to SQLite and MySQL/MariaDB back-ends. All back-ends cannot coexist, and you will have to decide which one is going to be used while planning your OpenNebula installation. It's not possible to automatically migrate the existing OpenNebula database from SQLite or MySQL/MariaDB to PostgreSQL.

Features:

* Required **PostgreSQL 9.5 or newer** (WARNING: base RHEL/CentOS 7 contains unsupported PostgreSQL 9.2!)
* No migrator for existing deployments from SQLite or MySQL/MariaDB
* No full-text search support

.. note:: If you are planning to install OpenNebula with PostgreSQL back-end, please follow this guide **prior** to starting OpenNebula for the first time to avoid problems with oneadmin and serveradmin credentials.

.. _postgresql_installation:

Installation
============

First of all, you need a working PostgreSQL server **version 9.5 or newer**. You can either deploy one for the OpenNebula installation or reuse any existing PostgreSQL already deployed and accessible by the Frontend. We assume you have PostgreSQL server installed and running.

Configuring PostgreSQL
----------------------

Create new database user ``oneadmin`` and provide own password for database user:

.. code::

    $ sudo -i -u postgres -- createuser -E -P oneadmin
    Enter password for new role: **********
    Enter it again: **********

Create database ``opennebula`` with owner ``oneadmin``:

.. code::

    $ sudo -i -u postgres -- createdb -O oneadmin opennebula

.. note::

    The database doesn't need to be created if the database user has privileges to create databases. In that case, OpenNebula creates the database on the first connect. To keep the lowest needed privileges, it's recommended to follow the steps above and prepare everything beforehand.

Visit the `PostgreSQL documentation <https://www.postgresql.org/docs/12/user-manag.html>`__ to learn how to manage accounts.

Validate a working connection, e.g.:

.. code::

    $ psql -h localhost -U oneadmin opennebula
    Password for user oneadmin:
    psql (10.12 (Ubuntu 10.12-0ubuntu0.18.04.1))
    SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
    Type "help" for help.

    opennebula=>

If connection above fails, you might need to configure client authentication mechanisms in your PostgreSQL server. Review authentication configuration file ``pg_hba.conf`` in your installation (e.g., located in ``/var/lib/pgsql/data/pg_hba.conf``, ``/etc/postgresql/$VERSION/main/pg_hba.conf`` where ``$VERSION`` is your major PostgreSQL version). Ensure the file contains:

.. code::

    # host  DATABASE        USER            ADDRESS                 METHOD  [OPTIONS]
    host    opennebula      oneadmin        127.0.0.1/32            md5
    host    opennebula      oneadmin        ::1/128                 md5

Reload the PostgreSQL server after the change:

.. code::

    $ sudo systemctl reload postgresql

Validate a working connection again.

Visit the `PostgreSQL documentation <https://www.postgresql.org/docs/12/auth-pg-hba-conf.html>`__ to learn how to manage client authentication configuration.

Configuring OpenNebula
----------------------

Before you run OpenNebula for the first time, you need to set database connection details in :ref:`oned.conf <oned_conf>`.

.. code::

    # Sample configuration for PostgreSQL
    DB = [ backend = "postgresql",
           server  = "localhost",
           port    = 0,
           user    = "oneadmin",
           passwd  = "**********",
           db_name = "opennebula" ]

Fields:

* **server**: of the machine running the PostgreSQL server.
* **port**: port for the connection to the server. If set to 0, the default port is used.
* **user**: PostgreSQL user-name.
* **passwd**: PostgreSQL password.
* **db_name**: Name of the PostgreSQL database OpenNebula will use.

Using OpenNebula with PostgreSQL
================================

After this installation and configuration process you can use OpenNebula as usual.

.. _postgresql_maintenance:
