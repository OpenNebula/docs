.. _mysql:
.. _mysql_setup:

==============
MySQL Setup
==============

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

    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY '<thepassword>';
    Query OK, 0 rows affected (0.00 sec)

Visit the `MySQL documentation <http://dev.mysql.com/doc/refman/5.7/en/user-account-management.html>`__ to learn how to manage accounts.

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
