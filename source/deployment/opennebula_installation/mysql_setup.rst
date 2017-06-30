.. _mysql:
.. _mysql_setup:

==============
MySQL Setup
==============

The MySQL/MariaDB back-end is an alternative to the default SQLite back-end. In this guide and in the rest of OpenNebula's documentation and configuration files we will refer to this database as the MySQL, however OpenNebula you can use either MySQL or MariaDB.

The two back-ends cannot coexist (SQLite and MySQL), and you will have to decide which one is going to be used while planning your OpenNebula installation.

.. note:: If you are planning to install OpenNebula with MySQL back-end, please follow this guide *prior* to start OpenNebula the first time to avoid problems with oneadmin and serveradmin credentials.

.. _mysql_installation:

Installation
============

First of all, you need a working MySQL server. You can either deploy one for the OpenNebula installation or reuse any existing MySQL already deployed and accessible by the Front-end.

Configuring MySQL
-----------------

You need to add a new user and grant it privileges on the ``opennebula`` database. This new database doesn't need to exist, OpenNebula will create it the first time you run it.

Assuming you are going to use the default values, log in to your MySQL server and issue the following commands:

.. code::

    $ mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor. [...]

    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY '<thepassword>';
    Query OK, 0 rows affected (0.00 sec)

Visit the `MySQL documentation <http://dev.mysql.com/doc/refman/5.7/en/user-account-management.html>`__ to learn how to manage accounts.

Now configure the transaction isolation level:

.. code::

    mysql> SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;


Configuring OpenNebula
----------------------

Before you run OpenNebula for the first time, you need to set in :ref:`oned.conf <oned_conf>` the connection details, and the database you have granted privileges on.

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


Editing Systemd opennebula.service script
-----------------------------------------

When on Ubuntu 16.04 and using OpenNebula with MySQL you might notice OpenNebula backend service not starting up automatically on system boot due to MySQL not having been started yet. In this case you may wish to edit /lib/systemd/system/opennebula.service and replace

.. code::

    After=mariadb.service
    
with

.. code::

    After=mysql.service


Using OpenNebula with MySQL
===========================

After this installation and configuration process you can use OpenNebula as usual.
