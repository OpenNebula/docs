.. _database_setup:

==============
Database Setup
==============

OpenNebula Front-end uses the database to persist the complete state of the cloud. It supports several database solutions and each is recommended for different usage. It's necessary to decide carefully which solution is the best for your needs, as the migration of an existing installation to a different database type is complex or impossible (depending on the Back-end). The following options are available:

- default embedded :ref:`SQLite <sqlite_setup>` for small workloads,
- recommended :ref:`MySQL/MariaDB <mysql_setup>` for production,
- experimental :ref:`PostgreSQL <postgresql_setup>` for evaluation only (support still in **Technology Preview**),

It's recommended to install the database Back-end now. Later, when doing the :ref:`Front-end Installation <frontend_installation>`, return back here and only update the OpenNebula configuration for specific Back-end based tasks (ideally) *prior* to starting OpenNebula for the first time.

.. _sqlite_setup:

SQLite Setup
============

.. note::

    The information about SQLite is only for information, default installation is preconfigured for SQLite and no actions are required!

The **SQLite** Back-end is the default database Back-end. It's not recommended for production use, as it doesn't perform well under load and on bigger infrastructures. For most cases, it's recommended to use :ref:`MySQL/MariaDB <mysql_setup>`.

Install
-------

No installation is required.

Configure OpenNebula
--------------------

No changes are needed. The default OpenNebula configuration already uses SQLite. The following is the relevant part in the :ref:`/etc/one/oned.conf <oned_conf>` configuration file:

.. code::

    DB = [ BACKEND = "sqlite",
           TIMEOUT = 2500 ]

.. _database_mysql:
.. _mysql:
.. _mysql_setup:

MySQL Setup
===========

The **MySQL/MariaDB** Back-end is an alternative to the default SQLite Back-end. It's recommended for heavy or production workloads and is fully featured for the best performance. In this guide and in the rest of the documentation and configuration files we refer to this database as MySQL. However, OpenNebula can use either MySQL or MariaDB.

.. _mysql_installation:

Install
-------

First of all, you need a working MySQL or MariaDB server. You can either deploy one for the OpenNebula installation following the guides for your operating system or reuse an existing one accessible via the Front-end. We assume you have a working MySQL/MariaDB server installed.

.. note:: MySQL should be recent enough to support the FULLTEXT indexing used by OpenNebula to implement the VM search feature. For MariaDB, that means at least a late minor version of release 10.0 if you use the default InnoDB.  If you are using CentOS 7 you may be interested in install packages from Software Collections (``centos-release-scl-rh``) and probably the ``syspaths`` variants (``rh-mariadb103-mariadb-config-syspaths``, ``rh-mariadb103-mariadb-syspaths``, and ``rh-mariadb103-mariadb-server-syspaths``) to provide the usual MySQL paths. On RHEL 7, subscribe to the ``rhel-server-rhscl-7-rpms`` repo and then install the ``rh-mariadb`` packages.

Configure
---------

You need to add a new database user and grant the user privileges on the ``opennebula`` database. This database doesn't need to exist already, as OpenNebula will create it the first time it runs. Assuming you are going to use the default values, log in to your MySQL server and issue the following commands while replacing ``<thepassword>`` with your own secure password:

.. prompt:: bash $ auto

    $ mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor. [...]

    mysql> CREATE USER 'oneadmin' IDENTIFIED BY '<thepassword>';
    Query OK, 0 rows affected (0.00 sec)
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin';
    Query OK, 0 rows affected (0.00 sec)

Visit the `MySQL documentation <https://dev.mysql.com/doc/refman/8.0/en/access-control.html>`__ to learn how to manage accounts.

Now, configure the transaction isolation level:

.. code::

    mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

Configure OpenNebula
--------------------

Before you run OpenNebula for the first time in the next section :ref:`Front-end Installation <frontend_installation>`, you'll need to set the database Back-end and connection details in the configuration file :ref:`/etc/one/oned.conf <oned_conf>` as follows:

.. code::

    # Sample configuration for PostgreSQL
    DB = [ BACKEND = "mysql",
           SERVER  = "localhost",
           PORT    = 0,
           USER    = "oneadmin",
           PASSWD  = "<thepassword>",
           DB_NAME = "opennebula",
           CONNECTIONS = 25,
           COMPARE_BINARY = "no" ]

Fields:

- ``SERVER`` - IP/hostname of the machine running the MySQL server,
- ``PORT`` - port for the connection to the server (default port is used when ``0``),
- ``USER`` - MySQL user-name,
- ``PASSWD`` - MySQL password,
- ``DB_NAME`` - name of the MySQL database OpenNebula will use,
- ``CONNECTIONS`` - max. number of connections,
- ``COMPARE_BINARY`` - compare strings using BINARY clause to make name searches case sensitive.

.. _postgresql:
.. _postgresql_setup:

PostgreSQL Setup (TP)
=====================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

The **PostgreSQL** Back-end is an alternative to SQLite and MySQL/MariaDB Back-ends. It's not possible to automatically migrate the existing OpenNebula database from SQLite or MySQL/MariaDB to PostgreSQL!

Features:

* Required **PostgreSQL 9.5 or newer** (WARNING: base RHEL/CentOS 7 contains unsupported PostgreSQL 9.2!)
* No migrator for existing deployments from SQLite or MySQL/MariaDB
* No full-text search support

.. _postgresql_installation:

Installation
============

First of all, you need a working PostgreSQL server **version 9.5 or newer**. You can either deploy one for the OpenNebula installation following the guides for your operating system or reuse an existing one accessible via the Front-end. We assume you have a PostgreSQL server installed and running.

Configuring PostgreSQL
----------------------

Create a new database user ``oneadmin`` and provide a password for the user:

.. prompt:: bash $ auto

    $ sudo -i -u postgres -- createuser -E -P oneadmin
    Enter password for new role: **********
    Enter it again: **********

Create database ``opennebula`` with owner ``oneadmin``:

.. prompt:: bash $ auto

    $ sudo -i -u postgres -- createdb -O oneadmin opennebula

.. note::

    The database doesn't need to be created if the database user has privileges to create databases. In that case, OpenNebula creates the database the first time it runs. To maintain the lowest privileges necessary, it's recommended to follow the steps above and prepare everything beforehand.

Visit the `PostgreSQL documentation <https://www.postgresql.org/docs/12/user-manag.html>`__ to learn how to manage accounts.

Validate a working connection, e.g.:

.. code::

    $ psql -h localhost -U oneadmin opennebula
    Password for user oneadmin:
    psql (10.12 (Ubuntu 10.12-0ubuntu0.18.04.1))
    SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
    Type "help" for help.

    opennebula=>

If the connection above fails, you might need to configure client authentication mechanisms in your PostgreSQL server. Review the authentication configuration file ``pg_hba.conf`` in your installation (e.g., located in ``/var/lib/pgsql/data/pg_hba.conf``, ``/etc/postgresql/$VERSION/main/pg_hba.conf`` where ``$VERSION`` is your major PostgreSQL version). Ensure the file contains:

.. code::

    # host  DATABASE        USER            ADDRESS                 METHOD  [OPTIONS]
    host    opennebula      oneadmin        127.0.0.1/32            md5
    host    opennebula      oneadmin        ::1/128                 md5

Reload the PostgreSQL server after the change:

.. prompt:: bash # auto

    # systemctl reload postgresql

Validate a working connection again.

Configure OpenNebula
----------------------

Before you run OpenNebula for the first time in the next section :ref:`Front-end Installation <frontend_installation>`, you'll need to set the database Back-end and connection details in configuration file :ref:`/etc/one/oned.conf <oned_conf>` as follows:

.. code::

    # Sample configuration for PostgreSQL
    DB = [ BACKEND = "postgresql",
           SERVER  = "localhost",
           PORT    = 0,
           USER    = "oneadmin",
           PASSWD  = "<thepassword>",
           DB_NAME = "opennebula" ]

Fields:

- ``SERVER`` - IP/hostname of the machine running the PostgreSQL server,
- ``PORT`` - port for the connection to the server (default port is used when ``0``),
- ``USER`` - PostgreSQL user-name,
- ``PASSWD`` - PostgreSQL password,
- ``DB_NAME`` - name of the PostgreSQL database OpenNebula will use.
