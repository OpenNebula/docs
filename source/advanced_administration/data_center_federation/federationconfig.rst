.. _federationconfig:

====================================
OpenNebula Federation Configuration
====================================

This section will explain how to configure two (or more) OpenNebula zones to work as federation master and slave. The process described here can be applied to new installations, or existing OpenNebula instances.

MySQL needs to be configured to enable the master-slave replication. Please read `the MySQL documentation for your version <http://dev.mysql.com/doc/refman/5.7/en/replication.html>`_ for complete instructions. The required steps are summarized here, but it may happen that your MySQL version needs a different configuration.

.. warning:: If Sunstone is configured behind a proxy please make sure that the request headers are being :ref:`properly sent <suns_advance_federated>`.

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
- Edit the local (master) Zone Endpoint. This can be done via Sunstone, or with the onezone command.

.. code-block:: none

    $ onezone update 0
    ENDPOINT = http://<master-ip>:2633/RPC2

- Create a Zone for each one of the slaves, and write down the new Zone ID. This can be done via Sunstone, or with the onezone command.

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

2. Import the Existing Slave OpenNebula
--------------------------------------------------------------------------------

.. note:: If your slave OpenNebula is going to be installed from scratch, you can skip this step.

If the OpenNebula to be added as a Slave is an existing installation, and you need to preserve its database (users, groups, VMs, hosts...), you need to import the contents with the ``onedb`` command.

- Stop the slave OpenNebula. Make sure the master OpenNebula is also stopped.
- Run the ``onedb import-slave`` command. Use ``-h`` to get an explanation of each option.

.. code-block:: none

    $ onedb import-slave -h
    ## USAGE
    import-slave
        Imports an existing federation slave into the federation master database

    ## OPTIONS
    ...

    $ onedb import-slave -v \
    --username oneadmin --password oneadmin \
    --server 192.168.122.3 --dbname opennebula  \
    --slave-username oneadmin --slave-password oneadmin \
    --slave-server 192.168.122.4 --slave-dbname opennebula

The tool will ask for the Zone ID you created in step 1.

.. code-block:: none

    Please enter the Zone ID that you created to represent the new Slave OpenNebula:
    Zone ID:

You will also need to decide if the users and groups will be merged.

If you had different people using the master and slave OpenNebula instances, then choose not to merge users. In case of name collision, the slave account will be renamed to ``username-1``.

You will want to merge if your users were accessing both the master and slave OpenNebula instances before the federation. To put it more clearly, the same person had previous access to the ``alice`` user in master and ``alice`` user in the slave. This will be the case if, for example, you had more than one OpenNebula instances pointing to the same LDAP server for authentication.

When a user is merged, its user template is also copied, using the master contents in case of conflict. This means that if alice had a different password or 'SSH_KEY' in her master and slave OpenNebula users, only the one in master will be preserved.

In any case, the ownership of existing resources and group membership is preserved.

.. code-block:: none

    The import process will move the users from the slave OpeNenbula to the master
    OpenNebula. In case of conflict, it can merge users with the same name.
    For example:
    +----------+-------------++------------+---------------+
    | Master   | Slave       || With merge | Without merge |
    +----------+-------------++------------+---------------+
    | 5, alice | 2, alice    || 5, alice   | 5, alice      |
    | 6, bob   | 5, bob      || 6, bob     | 6, bob        |
    |          |             ||            | 7, alice-1    |
    |          |             ||            | 8, bob-1      |
    +----------+-------------++------------+---------------+

    In any case, the ownership of existing resources and group membership
    is preserved.

    Do you want to merge USERS (Y/N): y

    Do you want to merge GROUPS (Y/N): y

When the import process finishes, onedb will write in ``/var/log/one/onedb-import.log`` the new user IDs and names if they were renamed.

3. Configure the MySQL Replication Master
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
    mysql> CREATE USER 'one-slave'@'%' IDENTIFIED BY 'one-slave-pass';
    mysql> GRANT REPLICATION SLAVE ON *.* TO 'one-slave'@'%';

.. warning:: In the previous example we are granting access to user one-replication from any host. You may want to restrict the hosts with the hostnames of the mysql slaves


- **Master MySQL**: Lock the tables and perform a dump.

First you need to lock the tables before dumping the federated tables.

.. code-block:: none

    mysql> FLUSH TABLES WITH READ LOCK;

Then you can safetly execute the mysqldump command in another terminal. Please note the ``--master-data`` option, it must be present to allow the slaves to know the current position of the binary log.

.. code-block:: none

    mysqldump -u root -p --master-data opennebula user_pool group_pool zone_pool db_versioning acl > dump.sql

Once you get the dump you can unlock the DB tables again.

.. code-block:: none

    mysql> UNLOCK TABLES;

- MySQL replication cannot use Unix socket files. You must be able to connect from the slaves to the master MySQL server using TCP/IP and port 3306 (default mysql port). Please update your firewall accordingly.

- You can start the master OpenNebula at this point.

4. Configure the MySQL Replication Slave
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
        ->     MASTER_USER='one-slave',
        ->     MASTER_PASSWORD='one-slave-pass';

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


5. Configure the OpenNebula Federation Slave
--------------------------------------------------------------------------------

For each slave, follow these steps.

- If it is a new installation, install OpenNebula as usual following the :ref:`installation guide <ignc>`.
- Configure OpenNebula to use MySQL, first you'll need to create a database user for OpenNebula and grant access to the OpenNebula database:

.. code-block:: none

    # mysql -u root -p
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';

and update oned.conf to use these values:

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

- Configure OpenNebula to act as a **federation slave**. Remember to use the ID obtained when the zone was created.

.. code-block:: none

    FEDERATION = [
        MODE = "SLAVE",
        ZONE_ID = 100,
        MASTER_ONED = "http://<oned-master-ip>:2633/RPC2"
    ]


- Copy the directory ``/var/lib/one/.one`` from the **master** front-end to the **slave**. This directory and its contents must have **oneadmin as owner**. The directory should contain these files:

.. code-block:: none

    $ ls -1 /var/lib/one/.one
    ec2_auth
    one_auth
    oneflow_auth
    onegate_auth
    sunstone_auth

Make sure ``one_auth`` (the oneadmin credentials) is present. If it's not, copy it from **master** oneadmin's ``$HOME/.one`` to the **slave** oneadmin's ``$HOME/.one``. For most configurations, oneadmin's home is ``/var/lib/one`` and this won't be necessary.

- Start the slave OpenNebula.
