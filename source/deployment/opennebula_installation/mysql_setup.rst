.. _mysql:
.. _mysql_setup:

==============
MySQL Setup
==============

The MySQL back-end is an alternative to the default Sqlite back-end. Either of them can be used seamlessly to the upper layers and ecosystem tools. These high level components do not need to be modified or configured.

The two back-ends cannot coexist, and you will have to decide which one is going to be used while planning your OpenNebula installation.

.. note:: If you are planning to install OpenNebula with MySQL back-end, please follow this guide *prior* to start OpenNebula the first time to avoid problems with oneadmin and serveradmin credentials.

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

.. note::

    Remember to choose different values, at least for the password.

    GRANT ALL PRIVILEGES ON <db\_name>.\* TO <user> IDENTIFIED BY <passwd>

Visit the `MySQL documentation <http://dev.mysql.com/doc/refman/5.7/en/user-account-management.html>`__ to learn how to manage accounts.

Now configure the transaction isolation level:

.. code::

    mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;


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

-  server: URL of the machine running the MySQL server
-  port: port for the connection to the server. If set to 0, the default port is used.
-  user: MySQL user-name
-  passwd: MySQL password
-  db\_name: Name of the MySQL database OpenNebula will use

Using OpenNebula with MySQL
===========================

After this installation and configuration process you can use OpenNebula as usual.

