.. _mysql:

==============
MySQL Backend
==============

The MySQL backend was introduced in OpenNebula 2.0 as an alternative to the Sqlite backend available in previous releases.

Either of them can be used seamlessly to the upper layers and ecosystem tools. These high level components do not need to be modified or configured.

The two backends cannot coexist, and you will have to decide which one is going to be used while planning your OpenNebula installation.

Building OpenNebula with MySQL Support
======================================

This section is only relevant if you are building OpenNebula from source. If you downloaded our compiled packages, you can skip to :ref:`Installation <mysql_installation>`.

Requirements
------------

An installation of the mysql server database is required. For an Ubuntu distribution, the packages to install are:

-  libmysql++-dev
-  libxml2-dev

Also, you will need a working mysql server install. For Ubuntu again, you can install the mysql server with:

-  mysql-server-5.1

Compilation
-----------

To compile OpenNebula from source with mysql support, you need the following option passed to the scons:

.. code::

    $ scons mysql=yes

Afterwards, installation proceeds normally, configuration needs to take into account the mysql server details, and for users of OpenNebula the DB backend is fully transparent.

.. _mysql_installation:

Installation
============

First of all, you need a working MySQL server.

Of course, you can use any instance you have already deployed. OpenNebula will connect to other machines different from localhost.

You can also configure two different OpenNebula installations to use the same MySQL server. In this case, you have to make sure that they use different database names.

Configuring MySQL
-----------------

In order to let OpenNebula use your existing MySQL database server, you need to add a new user and grant it privileges on one new database. This new database doesn't need to exist, OpenNebula will create it the first time you run it.

Assuming you are going to use the default values, log in to your MySQL server and issue the following commands:

.. code::

    $ mysql -u root -p
    Enter password: 
    Welcome to the MySQL monitor. [...]

    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';
    Query OK, 0 rows affected (0.00 sec)

.. warning:: Remember to choose different values, at least for the password.

.. warning:: GRANT ALL PRIVILEGES ON <db\_name>.\* TO <user> IDENTIFIED BY <passwd>

Visit the `MySQL documentation <http://dev.mysql.com/doc/refman/5.5/en/user-account-management.html>`__ to learn how to manage accounts.

Configuring OpenNebula
----------------------

Before you run OpenNebula, you need to set in :ref:`oned.conf <oned_conf>` the connection details, and the database you have granted privileges on.

.. code::

    # Sample configuration for MySQL
    DB = [ backend = "mysql",
           server  = "localhost",
           port    = 0,
           user    = "oneadmin",
           passwd  = "oneadmin",
           db_name = "opennebula" ]

Fields:

-  server: url of the machine running the MySQL server
-  port: port for the connection to the server. If set to 0, the default port is used.
-  user: MySQL user-name
-  passwd: MySQL password
-  db\_name: Name of the MySQL database OpenNebula will use

Using OpenNebula with MySQL
===========================

After this installation and configuration process you can use OpenNebula as usual.

