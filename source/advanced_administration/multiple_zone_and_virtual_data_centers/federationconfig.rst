.. _federationconfig:

====================================
OpenNebula Federation Configuration
====================================

Configure a Federation, Installing a Slave from Scratch
================================================================================

This section will explain how to configure two (or more) OpenNebula zones to work as federation master and slave, when the slave is going to be installed from scratch.

MySQL needs to be configured to enable the master-slave replication. Please read `the MySQL documentation for your version <http://dev.mysql.com/doc/refman/5.7/en/replication.html>`_ for complete instructions. The required steps are summarized here.

1. Configure the OpenNebula Federation Master
-------------------------------------------------------------------------------

- Start with an existing OpenNebula, or install OpenNebula as usual following the :ref:`installation guide <ignc>`. For new installations, you may need to create a MySQL user for OpenNebula, read more in the :ref:`MySQL configuration guide <mysql>`.

.. code-block:: none

    # mysql -u root -p
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';

- Configure OpenNebula to use the **master MySQL**, and to act as a **federation master**.

.. code-block:: none

    # vi /etc/one/oned.conf
    #DB = [ backend = "sqlite" ]

    # Sample configuration for MySQL
     DB = [ backend = "mysql",
            server  = "<ip>",
            port    = 0,
            user    = "oneadmin",
            passwd  = "oneadmin",
            db_name = "opennebula" ]

    FEDERATION = [
        MODE = "MASTER",
        ZONE_ID = 0,
        MASTER_ONED = ""
    ]

- Restart OpenNebula
- Create a Zone for each one of the slaves. This can be done via Sunstone, or with the onezone command.

.. code-block:: none

    $ vim /tmp/zone.tmpl
    NAME     = slave-name
    ENDPOINT = http://<slave-ip>:2633/RPC2

    $ onezone create /tmp/zone.tmpl 
    ID: 100

    $ onezone list
       ID NAME                     
        0 OpenNebula
      100 slave-name

- Stop OpenNebula.

2. Configure the MySQL Replication Master
--------------------------------------------------------------------------------

- In your **master MySQL**: enable the binary log for the opennebula database and set a server ID. Change the 'opennebula' database name to the one set in oned.conf.

.. code-block:: none

    # vi /etc/my.cnf
    [mysqld]
    log-bin             = mysql-bin
    server-id           = 1
    binlog-do-db        = opennebula

    # service mysqld restart

- **Master MySQL**: You also need to create a special user that will be used by the MySQL replication slaves.

.. code-block:: none

    # mysql -u root -p
    mysql> CREATE USER 'one-replication'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
    mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.mydomain.com';

- **Master MySQL**: Lock the tables and perform a dump. 

In one terminal, lock the tables while you execute the mysqldump command in another terminal. Please note the ``--master-data`` option, it must be present to allow the slaves to know the current position of the binary log.

.. code-block:: none

    mysql> FLUSH TABLES WITH READ LOCK;

    mysql> UNLOCK TABLES;

.. code-block:: none

    mysqldump -u root -p --master-data opennebula user_pool group_pool zone_pool db_versioning acl > dump.sql

- MySQL replication cannot use Unix socket files. You must be able to connect from the slaves to the master MySQL server using TCP/IP. The default port is 3306.

- You can start the master OpenNebula at this point.

3. Configure the MySQL Replication Slave
--------------------------------------------------------------------------------

For each one of the slaves, configure the MySQL server as a replication slave. Pay attention to the ``server-id`` set in my.cnf, it must be unique for each one.

- Set a server ID for the **slave MySQL**, and configure these tables to be replicated. You may need to change 'opennebula' to the database name used in oned.conf. The database name must be the same for the master and slaves OpenNebulas.

.. code-block:: none

    # vi /etc/my.cnf
    [mysqld]
    server-id           = 100
    replicate-do-table  = opennebula.user_pool
    replicate-do-table  = opennebula.group_pool
    replicate-do-table  = opennebula.zone_pool
    replicate-do-table  = opennebula.db_versioning
    replicate-do-table  = opennebula.acl

    # service mysqld restart

- Set the master configuration on the **slave MySQL**.

.. code-block:: none

    # mysql -u root -p
    mysql> CHANGE MASTER TO
        ->     MASTER_HOST='master_host_name',
        ->     MASTER_USER='replication_user_name',
        ->     MASTER_PASSWORD='replication_password';

- Copy the mysql dump file from the **master**, and import its contents to the **slave**.

.. code-block:: none

    mysql> CREATE DATABASE opennebula;
    mysql> USE opennebula;
    mysql> SOURCE /path/to/dump.sql;

- Start the **slave MySQL** process and check its status.

.. code-block:: none

    mysql> START SLAVE;
    mysql> SHOW SLAVE STATUS\G

The ``SHOW SLAVE STATUS`` output will provide detailed information, but to confirm that the slave is connected to the master MySQL, take a look at these columns:

.. code-block:: none

       Slave_IO_State: Waiting for master to send event
     Slave_IO_Running: Yes
    Slave_SQL_Running: Yes


4. Configure the OpenNebula Federation Slave
--------------------------------------------------------------------------------

For each slave, follow these steps.

- Install OpenNebula as usual following the :ref:`installation guide <ignc>`.
- Configure OpenNebula to use the **slave MySQL**, and to act as a **federation slave**. You also need to create a user in this **slave MySQL**.

.. code-block:: none

    # vi /etc/one/oned.conf
    #DB = [ backend = "sqlite" ]

    # Sample configuration for MySQL
     DB = [ backend = "mysql",
            server  = "<ip>",
            port    = 0,
            user    = "oneadmin",
            passwd  = "oneadmin",
            db_name = "opennebula" ]

    FEDERATION = [
        MODE = "SLAVE",
        ZONE_ID = 100,
        MASTER_ONED = "http://<oned-master-ip>:2633/RPC2"
    ]

    # mysql -u root -p
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';

- Copy the directory ``/var/lib/one/.one`` from the **master** front-end to the **slave**. This directory should contain these files:

.. code-block:: none

    $ ls -1 /var/lib/one/.one
    ec2_auth
    occi_auth
    one_auth
    oneflow_auth
    onegate_auth
    sunstone_auth

Make sure ``one_auth`` is present. If it's not, copy it from **master** oneadmin's ``$HOME/.one`` to the **slave** oneadmin's ``$HOME/.one``. For most configurations, oneadmin's home is ``/var/lib/one`` and this won't be necessary.

- Start the slave OpenNebula.